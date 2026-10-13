<#
.SYNOPSIS
    Tests whether all function-to-function calls resolve to a defined command.
.DESCRIPTION
    Parses every .ps1 file (excluding tests) under the automation root using AST,
    then checks each function call against: (a) the definitions map of automation
    functions, and (b) Get-Command for built-ins, vendor modules, and other loaded
    commands.

    Returns $true when all calls resolve, $false when any are unresolved.
    Unresolved calls are written to the Verbose stream with caller and target details.

    Throws if two modules define the same public (module-root) function name — exported names must be globally
    unique, mirroring the importer's Assert-UniqueModuleFunctionName. Duplicate private names across modules are
    allowed (privates are module-scoped and not exported).

    Must run post-import so Get-Command covers all loaded modules. Reads the per-function source files, which
    exist only in the source tree, so it stops with a named error in build mode (Assert-SourceTree,
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to $env:RepositoryRoot/automation.
.EXAMPLE
    Test-FunctionDependency
.EXAMPLE
    Test-FunctionDependency -Verbose
#>
function Test-FunctionDependency {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string] $AutomationRoot = (Join-Path $env:RepositoryRoot 'automation')
    )

    Assert-SourceTree

    # Parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider
    # overhead, [ADR-AUTO-TEST#18](/docs/adr/automation/test-automation.md#rule-adr-auto-test18)); the definition map
    # and the call-resolution walk reuse these ASTs, so each file is read and parsed a single time. The walk itself is
    # [Catzc.Base.ModuleSystem.FunctionCallCollector] — one C# pass per function, not scriptblock-predicate FindAll calls.
    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($AutomationRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDir)
        if ($module -match '^\.') {
            continue
        }

        $files = [System.IO.Directory]::EnumerateFiles($moduleDir, '*.ps1', [System.IO.SearchOption]::AllDirectories) | Sort-Object
        foreach ($path in $files) {
            $name = [System.IO.Path]::GetFileName($path)
            # Match assets/private against the MODULE-RELATIVE path, not the absolute one: an absolute temp/CI
            # path can itself sit under a '/private/' or '/assets/' segment (e.g. macOS $TestDrive resolves to
            # /private/var/folders/...), which would otherwise misclassify every fixture file as private.
            $rel = $path.Substring($moduleDir.Length)
            if ($name -like '*.Tests.ps1' -or $rel -match '[/\\]assets[/\\]') {
                continue
            }

            $tokens = $null
            $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
            $collectors = [Catzc.Base.ModuleSystem.FunctionCallCollector]::Collect($ast)
            $isPrivate = $rel -match '^[/\\]private[/\\]'

            $parsed.Add([pscustomobject]@{ Module = $module; FileName = $name; Functions = $collectors })

            foreach ($collector in $collectors) {
                $fn = $collector.Function
                $info = @{ Module = $module; File = $name; Line = $fn.Extent.StartLineNumber; Private = $isPrivate }

                if (-not $definitions.ContainsKey($fn.Name)) {
                    $definitions[$fn.Name] = $info
                    continue
                }

                # Two PUBLIC (module-root) definitions of one name is a real collision — the module imported
                # last silently shadows the other. Fail fast rather than overwrite silently (defense-in-depth;
                # the importer's Assert-UniqueModuleFunctionName already blocks this at load). Duplicate PRIVATE
                # names across modules are legal (privates are module-scoped, not exported): keep first-wins,
                # but prefer a public definition over a private one for resolution and reporting.
                $existing = $definitions[$fn.Name]
                if (-not $isPrivate -and -not $existing.Private) {
                    $a = "$($existing.Module)/$($existing.File)"
                    $b = "$module/$name"
                    throw "Duplicate public function '$($fn.Name)' in $a and $b (exported names must be unique)."
                }
                if ($existing.Private -and -not $isPrivate) {
                    $definitions[$fn.Name] = $info
                }
            }
        }
    }

    # Check each collected call → flag any that resolve to nothing. Get-Command runs once per distinct external name
    # in this run (a whole-session Get-Command snapshot measures slower than the few dozen lookups the memo leaves).
    $unresolved = [System.Collections.Generic.List[PSObject]]::new()
    $isLoadedCommand = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($entry in $parsed) {
        foreach ($collector in $entry.Functions) {
            $localDefs = [System.Collections.Generic.HashSet[string]]::new(
                $collector.NestedFunctionNames,
                [System.StringComparer]::OrdinalIgnoreCase
            )

            foreach ($call in $collector.Calls) {
                $cmdName = $call.Name
                if (-not $cmdName.Contains('-')) {
                    continue
                }
                if ($definitions.ContainsKey($cmdName)) {
                    continue
                }
                if ($localDefs.Contains($cmdName)) {
                    continue
                }
                if (-not $isLoadedCommand.ContainsKey($cmdName)) {
                    $isLoadedCommand[$cmdName] = [bool](Get-Command $cmdName -ErrorAction Ignore)
                }
                if ($isLoadedCommand[$cmdName]) {
                    continue
                }

                $unresolved.Add([PSCustomObject]@{
                        CallerModule   = $entry.Module
                        CallerFunction = $collector.Function.Name
                        CallerFile     = $entry.FileName
                        CallerLine     = $call.Line
                        MissingCommand = $cmdName
                    })
            }
        }
    }

    foreach ($entry in $unresolved) {
        Write-Message "$($entry.CallerFunction) -> $($entry.MissingCommand) ($($entry.CallerFile):$($entry.CallerLine))" -ForegroundColor Red
    }

    $unresolved.Count -eq 0
}

<#
.SYNOPSIS
    The function dependency quality gate: every function-to-function call resolves to a defined command.
.DESCRIPTION
    Parses every .ps1 file (excluding tests) under the automation root using AST,
    then checks each function call against: (a) the definitions map of automation
    functions, and (b) Get-Command for built-ins, vendor modules, and other loaded
    commands.

    An issue is an unresolved call ('<caller> -> <missing> (<module>/<file>:<line>)') or two modules defining the
    same public (module-root) function name — exported names must be globally unique, mirroring the importer's
    Assert-UniqueModuleFunctionName. Duplicate private names across modules are allowed (privates are
    module-scoped and not exported).

    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
    through Write-QualityGateReport, which writes out/test-function-dependency/, prints every issue, and throws
    once listing them all; -PassThru returns the result instead.

    Must run post-import so Get-Command covers all loaded modules. Reads the per-function source files, which
    exist only in the source tree, so it stops with a named error in build mode (Assert-SourceTree,
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-function-dependency.
.PARAMETER PassThru
    Return a result object ({ Subject; IssueCount; Issues; ReportPath; FunctionCount }) instead of throwing.
.OUTPUTS
    Throws on any issue; with -PassThru, returns the result object.
.EXAMPLE
    Test-FunctionDependency
.EXAMPLE
    (Test-FunctionDependency -PassThru).Issues
#>
function Test-FunctionDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    # Parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider
    # overhead, [ADR-AUTO-TEST#18](/docs/adr/automation/test-automation.md#rule-adr-auto-test18)); the definition map
    # and the call-resolution walk reuse these ASTs, so each file is read and parsed a single time. The walk itself is
    # [Catzc.Base.ModuleSystem.FunctionCallCollector] — one C# pass per function, not scriptblock-predicate FindAll calls.
    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}
    $issues = [System.Collections.Generic.List[string]]::new()

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
                # last silently shadows the other (defense-in-depth; the importer's Assert-UniqueModuleFunctionName
                # already blocks this at load). Duplicate PRIVATE names across modules are legal (privates are
                # module-scoped, not exported): keep first-wins, but prefer a public definition over a private one
                # for resolution and reporting.
                $existing = $definitions[$fn.Name]
                if (-not $isPrivate -and -not $existing.Private) {
                    $issues.Add("Duplicate public function '$($fn.Name)' in $($existing.Module)/$($existing.File) and $module/$name (exported names must be unique).")
                    continue
                }
                if ($existing.Private -and -not $isPrivate) {
                    $definitions[$fn.Name] = $info
                }
            }
        }
    }

    # Check each collected call → flag any that resolve to nothing. Get-Command runs once per distinct external name
    # in this run (a whole-session Get-Command snapshot measures slower than the few dozen lookups the memo leaves).
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

                $issues.Add("$($collector.Function.Name) -> $cmdName ($($entry.Module)/$($entry.FileName):$($call.Line)) does not resolve to a command.")
            }
        }
    }

    Write-QualityGateReport -Subject function-dependency -Title Test-FunctionDependency -Issues $issues.ToArray() `
        -Facts ([ordered]@{ FunctionCount = $definitions.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}

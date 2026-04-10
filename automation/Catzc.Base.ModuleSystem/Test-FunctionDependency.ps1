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

    Must run post-import so Get-Command covers all loaded modules.
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

    # Parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider
    # overhead, ADR-TEST:18); the definition map and the call-resolution walk reuse these ASTs, so each file is read
    # and parsed a single time (it was twice before).
    $isFunction = { param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] }
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
            $fns = @($ast.FindAll($isFunction, $false) | Where-Object { $_.Parent.Parent -eq $ast })
            $isPrivate = $rel -match '^[/\\]private[/\\]'

            $parsed.Add([pscustomobject]@{ Module = $module; FileName = $name; Functions = $fns })

            foreach ($fn in $fns) {
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

    # Walk each already-parsed function body for calls → flag any that resolve to nothing.
    $isCommand = { param($n) $n -is [System.Management.Automation.Language.CommandAst] }
    $unresolved = [System.Collections.Generic.List[PSObject]]::new()

    foreach ($entry in $parsed) {
        foreach ($fn in $entry.Functions) {
            # Collect nested function names defined inside this function body
            $nestedNames = $fn.Body.FindAll($isFunction, $true) | ForEach-Object { $_.Name }
            $localDefs = [System.Collections.Generic.HashSet[string]]::new(
                [string[]]@($nestedNames | Where-Object { $_ }),
                [System.StringComparer]::OrdinalIgnoreCase
            )

            foreach ($call in $fn.Body.FindAll($isCommand, $true)) {
                $cmdName = $call.GetCommandName()
                if (-not $cmdName) {
                    continue
                }
                if ($cmdName -notmatch '-') {
                    continue
                }
                if ($definitions.ContainsKey($cmdName)) {
                    continue
                }
                if ($localDefs.Contains($cmdName)) {
                    continue
                }
                if (Get-Command $cmdName -ErrorAction Ignore) {
                    continue
                }

                $unresolved.Add([PSCustomObject]@{
                        CallerModule   = $entry.Module
                        CallerFunction = $fn.Name
                        CallerFile     = $entry.FileName
                        CallerLine     = $call.Extent.StartLineNumber
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

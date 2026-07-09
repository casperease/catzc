<#
.SYNOPSIS
    Compiles a list of function-to-function calls across all automation modules using AST.
.DESCRIPTION
    Parses every .ps1 file (excluding tests) under the automation root, builds a
    definition map of all functions, then walks each function body for CommandAst
    nodes and cross-references them against the map.
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to $env:RepositoryRoot/automation.
.EXAMPLE
    Get-FunctionDependency
.EXAMPLE
    Get-FunctionDependency | Where-Object CrossModule
.EXAMPLE
    Get-FunctionDependency | Get-ModuleDependency
#>
function Get-FunctionDependency {
    param(
        [string] $AutomationRoot = (Join-Path $env:RepositoryRoot 'automation')
    )

    # Filesystem-derived information — cached for the session, lazily on first use, keyed on the resolved automation
    # root (ADR-AUTO-CACHE:2/ADR-AUTO-CACHE:4). The expensive AST walk runs once and Get-ModuleDependency / Get-AutomationFunctions
    # / Get-FunctionDependencyTree (and the integrity tests) all reuse it. Re-running the importer resets the
    # $script: state — the only invalidation (ADR-AUTO-CACHE:6). A fixture root passed by a test gets its own entry, so it
    # cannot collide with the real tree (ADR-AUTO-TEST:4). Callers treat the result as read-only (ADR-AUTO-CACHE:5).
    if (-not $script:functionDependencyCache) {
        $script:functionDependencyCache = @{}
    }
    if ($script:functionDependencyCache.ContainsKey($AutomationRoot)) {
        return $script:functionDependencyCache[$AutomationRoot]
    }

    # Enumerate + parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/
    # call provider overhead, ADR-AUTO-TEST:18), capturing each file's top-level functions. Both the definition map and
    # the call walk reuse these ASTs, so a file is read and parsed a single time (it was twice before).
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
            if ($name -like '*.Tests.ps1' -or $path -match '[/\\]assets[/\\]') {
                continue
            }

            $tokens = $null
            $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
            $fns = @($ast.FindAll($isFunction, $false) | Where-Object { $_.Parent.Parent -eq $ast })

            $parsed.Add([pscustomobject]@{ Module = $module; FileName = $name; Functions = $fns })
            foreach ($fn in $fns) {
                $definitions[$fn.Name] = @{ Module = $module; File = $name; Line = $fn.Extent.StartLineNumber }
            }
        }
    }

    # Walk each already-parsed function body for calls → cross-reference against the full definition map.
    $isCommand = { param($n) $n -is [System.Management.Automation.Language.CommandAst] }
    $ret = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($entry in $parsed) {
        foreach ($fn in $entry.Functions) {
            foreach ($call in $fn.Body.FindAll($isCommand, $true)) {
                $cmdName = $call.GetCommandName()
                if (-not $cmdName -or -not $definitions.ContainsKey($cmdName)) {
                    continue
                }

                $target = $definitions[$cmdName]
                $ret.Add([PSCustomObject]@{
                        CallerModule   = $entry.Module
                        CallerFunction = $fn.Name
                        CallerFile     = $entry.FileName
                        CallerLine     = $call.Extent.StartLineNumber
                        TargetModule   = $target.Module
                        TargetFunction = $cmdName
                        CrossModule    = $entry.Module -ne $target.Module
                    })
            }
        }
    }

    $script:functionDependencyCache[$AutomationRoot] = $ret
    $ret
}

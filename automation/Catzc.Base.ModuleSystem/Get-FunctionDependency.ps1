<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs:
      - ADR-AUTO-CACHE#2
      - ADR-AUTO-CACHE#4
      - ADR-AUTO-CACHE#5
      - ADR-AUTO-CACHE#6
      - ADR-AUTO-TEST#4
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-PESTER#9
---
#>

<#
.SYNOPSIS
    Compiles a list of function-to-function calls across all automation modules using AST.
.DESCRIPTION
    Reads per-function source files that exist only in the source tree, so build mode stops with a named error.
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
.PARAMETER ParsedScripts
    The call's shared parse of each script; the session cache of the result stays, this only spares a second parse of a file within one build.
.EXAMPLE
    Get-FunctionDependency
.EXAMPLE
    Get-FunctionDependency | Where-Object CrossModule
.EXAMPLE
    Get-FunctionDependency | Get-ModuleDependency
#>
function Get-FunctionDependency {
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot),

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    Assert-SourceTree

    # Cached per root for the session: only a re-import resets it, so callers must treat the result as read-only.
    # [comment:2](/docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md#comment2)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:functionDependencyCache')) {
        # GetValue probes the entry because reading an unset script variable directly would throw under strict mode.
        # [comment:3](/docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md#comment3)
        $script:functionDependencyCache = @{}
    }
    if ($script:functionDependencyCache.ContainsKey($AutomationRoot)) {
        return $script:functionDependencyCache[$AutomationRoot]
    }

    # Each file is parsed once, and that AST feeds both the definition map and the call walk.
    # [comment:4](/docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md#comment4)
    $parsed = [System.Collections.Generic.List[object]]::new()
    $definitions = @{}

    foreach ($moduleDir in ([System.IO.Directory]::EnumerateDirectories($AutomationRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDir)
        if ($module -match '^\.') {
            continue
        }

        # A module's scripts sit at most three levels below its folder (tests/types/ is the deepest).
        $files = Get-ChildPath $moduleDir -File -Filter '*.ps1' -Depth 3 | Sort-Object
        foreach ($path in $files) {
            $name = [System.IO.Path]::GetFileName($path)
            if ($name -like '*.Tests.ps1' -or $path -match '[/\\]assets[/\\]') {
                continue
            }

            $ast = $ParsedScripts.Get($path).Ast
            $fns = @([Catzc.Base.Repository.SyntaxSearch]::TopLevelFunctions($ast))

            $parsed.Add([pscustomobject]@{ Module = $module; FileName = $name; Functions = $fns })
            foreach ($fn in $fns) {
                $definitions[$fn.Name] = @{ Module = $module; File = $name; Line = $fn.Extent.StartLineNumber }
            }
        }
    }

    # Walk each already-parsed function body for calls → cross-reference against the full definition map.
    $ret = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($entry in $parsed) {
        foreach ($fn in $entry.Functions) {
            foreach ($call in [Catzc.Base.Repository.SyntaxSearch]::Commands($fn.Body)) {
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

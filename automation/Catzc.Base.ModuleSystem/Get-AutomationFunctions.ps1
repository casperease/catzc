# catzc:
#   path: automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
#   module: Catzc.Base.ModuleSystem
#   visibility: public

<#
.SYNOPSIS
    Lists all exported automation functions.
.DESCRIPTION
    Lists loaded modules, so it works in both run modes; -NotUsedInternally needs the per-function files and fails in build mode.
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md#comment1)
.PARAMETER NotUsedInternally
    Only return functions that have no incoming calls from other automation functions.
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
.EXAMPLE
    Get-AutomationFunctions
.EXAMPLE
    Get-AutomationFunctions -NotUsedInternally
#>
function Get-AutomationFunctions {
    param(
        [switch] $NotUsedInternally,
        [string] $AutomationRoot = (Get-CatzcModulesRoot)
    )

    if ($NotUsedInternally) {
        Assert-SourceTree
    }

    # [System.IO] enumeration ([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9))
    $moduleNames = Get-AutomationModules -AutomationRoot $AutomationRoot

    $modules = Get-Module | Where-Object { $_.Name -in $moduleNames }

    $functions = foreach ($mod in $modules) {
        foreach ($name in $mod.ExportedFunctions.Keys) {
            [PSCustomObject]@{
                Function = $name
                Module   = $mod.Name
            }
        }
    }

    if ($NotUsedInternally) {
        $called = Get-FunctionDependency -AutomationRoot $AutomationRoot |
            ForEach-Object { $_.TargetFunction } |
            Sort-Object -Unique
        $functions = $functions | Where-Object { $_.Function -notin $called }
    }

    $functions | Sort-Object Module, Function
}

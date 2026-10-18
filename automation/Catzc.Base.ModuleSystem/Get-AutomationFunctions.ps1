<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
    name: get-automation-functions
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.ModuleSystem/tests/Get-AutomationFunctions.Tests.ps1
    cites:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-PESTER#9
---
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
    $moduleNames = (Get-CatzcModule -TrackType modules).name

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

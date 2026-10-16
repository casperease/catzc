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
  config:
    synopsis: Lists all exported automation functions.
    description: |-
      Takes the modules of the code track from the resolver (Get-CatzcModule),
      finds the matching loaded modules, and returns their exported functions.

      With -NotUsedInternally, filters to functions that are never called by
      another automation function (no incoming edges in the call graph).

      The listing describes the loaded modules, so it works in both run modes
      ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
      -NotUsedInternally reads the per-function source files, so it stops with a named error in build mode
      (Assert-SourceTree).
    parameters:
      NotUsedInternally: Only return functions that have no incoming calls from other automation functions.
      AutomationRoot: Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).
    examples:
      - Get-AutomationFunctions
      - Get-AutomationFunctions -NotUsedInternally
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

<#
---
catzc:
  immutable:
    with_body_sha: d299837dd546
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleFunction.Tests.ps1
    docs: "[Get-ModuleFunction.ps1.md](../../docs/references/pwsh/catzc-base-module-system/Get-ModuleFunction.ps1.md)"
    cites:
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
      - DDR-RUNMODE
---
#>

function Get-ModuleFunction {
    param(
        [switch] $NotUsedInternally,
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    if ($NotUsedInternally) {
        Assert-SourceTree
    }

    # [System.IO] enumeration ([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths))
    $moduleNames = (Get-CatzcModule -EngineTrack).name

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
        $called = Get-FunctionDependency -ModulesRoot $ModulesRoot |
            ForEach-Object { $_.TargetFunction } |
            Sort-Object -Unique
        $functions = $functions | Where-Object { $_.Function -notin $called }
    }

    $functions | Sort-Object Module, Function
}

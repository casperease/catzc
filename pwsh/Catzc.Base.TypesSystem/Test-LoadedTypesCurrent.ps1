<#
---
catzc:
  immutable:
    with_body_sha: "3b196ff0f001"
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
    docs: "[Test-LoadedTypesCurrent.ps1.md](../../docs/references/pwsh/catzc-base-types-system/Test-LoadedTypesCurrent.ps1.md)"
    cites:
      - ADR-BCL-TYPES-CHANGEDAFTERLOAD
---
#>

function Test-LoadedTypesCurrent {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    Import-InternalModule Types
    (Get-LoadedTypeDrift -ModulesRoot $ModulesRoot).Current
}

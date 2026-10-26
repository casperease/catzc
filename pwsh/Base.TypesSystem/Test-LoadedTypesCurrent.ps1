<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/Test-LoadedTypesCurrent.ps1.md"
  header: "generated"
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

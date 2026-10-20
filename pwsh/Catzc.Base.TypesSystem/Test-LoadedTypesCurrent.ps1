<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
    name: test-loaded-types-current
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
    docs: "[Test-LoadedTypesCurrent.ps1.md](/docs/references/pwsh/catzc-base-typessystem/Test-LoadedTypesCurrent.ps1.md)"
    cites:
      - ADR-AUTO-TYPES-CHANGEDAFTERLOAD
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

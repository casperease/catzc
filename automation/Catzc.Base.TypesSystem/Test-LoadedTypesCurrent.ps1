<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
    name: test-loaded-types-current
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
    cites:
      - ADR-AUTO-TYPES#7
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

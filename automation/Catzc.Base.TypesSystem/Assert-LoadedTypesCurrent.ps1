<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
    name: assert-loaded-types-current
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST#3
      - ADR-AUTO-TYPES#7
---
#>

function Assert-LoadedTypesCurrent {
    [CmdletBinding()]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    Import-InternalModule Types
    $state = Get-LoadedTypeDrift -ModulesRoot $ModulesRoot
    if ($state.Current) {
        return
    }
    $drifted = if ($state.Drift.Count) {
        ' Drifted: ' + ($state.Drift -join '; ') + '.'
    }
    else {
        ''
    }
    throw ("$($state.Summary)$drifted This process cannot reload them: open a new PowerShell and import again " +
        '(re-running the importer in your own console starts the new one for you).')
}

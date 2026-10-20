<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
    name: assert-loaded-types-current
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
    docs: "[Assert-LoadedTypesCurrent.ps1.md](/docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-ASSERTPRECONDITIONS
      - ADR-AUTO-TYPES-CHANGEDAFTERLOAD
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

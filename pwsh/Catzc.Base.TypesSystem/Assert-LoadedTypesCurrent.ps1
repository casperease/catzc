<#
---
catzc:
  immutable:
    with_body_sha: e8a46906cd1a
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
    docs: "[Assert-LoadedTypesCurrent.ps1.md](docs/references/pwsh/catzc-base-types-system/Assert-LoadedTypesCurrent.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-ASSERTPRECONDITIONS
      - ADR-BCL-TYPES-CHANGEDAFTERLOAD
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

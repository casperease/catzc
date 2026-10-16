<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
    kind: function
    subkind: assert
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    visibility: public
    relatives:
      test: automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
    adrs:
      - ADR-AUTO-FAILFAST#3
      - ADR-AUTO-TYPES#7
  config:
    synopsis: Asserts that the C# types loaded in this PowerShell process are current with their sources.
    description: |-
      The throwing form of Test-LoadedTypesCurrent
      ([ADR-AUTO-FAILFAST#3](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast3)): a precondition
      for work that must run on the types as written, such as a test of a type just edited. A loaded assembly cannot
      be swapped in a running process
      ([ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)), so the one remedy is
      a new process; the message names it, with every drifted type and both hashes or code roots.
    parameters:
      ModulesRoot: 'The code root whose type sources to compare. Default: the loaded code root (Get-CatzcModulesRoot).'
    examples:
      - Assert-LoadedTypesCurrent
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

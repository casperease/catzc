# catzc:
#   path: automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
#   module: Catzc.Base.TypesSystem
#   visibility: public

<#
.SYNOPSIS
    Asserts that the C# types loaded in this PowerShell process are current with their sources.
.DESCRIPTION
    A loaded type cannot be swapped in place, so the only remedy it names is a fresh process.
    [ADR-AUTO-FAILFAST#3](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast3),
    [ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md#comment1)
.PARAMETER ModulesRoot
    The code root whose type sources to compare. Default: the loaded code root (Get-CatzcModulesRoot).
.EXAMPLE
    Assert-LoadedTypesCurrent
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

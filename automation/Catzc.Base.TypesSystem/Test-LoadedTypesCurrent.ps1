<#
.SYNOPSIS
    Tests whether the C# types loaded in this PowerShell process are current with their sources.
.DESCRIPTION
    A loaded assembly cannot be unloaded or swapped in a running process: once a types/*.cs file changes after its...
    [ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Test-LoadedTypesCurrent.ps1.md#comment1)
.PARAMETER ModulesRoot
    The code root whose type sources to compare. Default: the loaded code root (Get-CatzcModulesRoot).
.OUTPUTS
    [bool]
.EXAMPLE
    if (-not (Test-LoadedTypesCurrent)) { 'Open a new PowerShell to pick up the type changes.' }
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

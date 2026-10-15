<#
.SYNOPSIS
    Tests whether the repo's Azure resource-name order (the `ado_naming` variant) is the one named.
.DESCRIPTION
    A predicate over the `ado_naming` repo-wide variant (see Get-AdoNaming).
    [comment:1](/docs/references/automation/catzc-base-variants/Test-AdoNaming.ps1.md#comment1)
.PARAMETER Standard
    Test for the 'standard' order (env/slot first, type last).
.PARAMETER Classic
    Test for the 'classic' order (type first, CAF-style).
.EXAMPLE
    if (Test-AdoNaming -Classic) { ... }
#>
function Test-AdoNaming {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [switch] $Standard,

        [Parameter(Mandatory, ParameterSetName = 'Classic')]
        [switch] $Classic
    )

    $order = Get-AdoNaming
    ($Standard -and $order -eq 'standard') -or ($Classic -and $order -eq 'classic')
}

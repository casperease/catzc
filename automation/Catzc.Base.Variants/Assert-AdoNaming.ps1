<#
.SYNOPSIS
    Asserts the repo's Azure resource-name order (the `ado_naming` variant) is the one named, else throws.
.DESCRIPTION
    The throwing companion to Test-AdoNaming.
    [comment:1](/docs/references/automation/catzc-base-variants/Assert-AdoNaming.ps1.md#comment1)
.PARAMETER Standard
    Require the 'standard' order.
.PARAMETER Classic
    Require the 'classic' order.
.EXAMPLE
    Assert-AdoNaming -Standard
#>
function Assert-AdoNaming {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [switch] $Standard,

        [Parameter(Mandatory, ParameterSetName = 'Classic')]
        [switch] $Classic
    )

    $order = Get-AdoNaming
    $isMatch = ($Standard -and $order -eq 'standard') -or ($Classic -and $order -eq 'classic')
    $want = if ($Standard) {
        'standard'
    }
    else {
        'classic'
    }
    Assert-True $isMatch -ErrorText "Expected ado_naming '$want' but the repo is '$order' — set ado_naming in variants.yml."
}

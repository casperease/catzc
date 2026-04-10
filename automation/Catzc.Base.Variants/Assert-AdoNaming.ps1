<#
.SYNOPSIS
    Asserts the repo's Azure resource-name order (the `ado_naming` variant) is the one named, else throws.
.DESCRIPTION
    The throwing companion to Test-AdoNaming. Pass exactly one of -Standard or -Classic; throws (naming the
    actual order and where to change it) when the repo's order does not match. Guards a code path that only
    holds under one naming convention.
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

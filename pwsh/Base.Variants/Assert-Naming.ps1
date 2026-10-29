function Assert-Naming {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [switch] $Standard,

        [Parameter(Mandatory, ParameterSetName = 'Classic')]
        [switch] $Classic
    )

    $want = if ($Standard) {
        'standard'
    }
    else {
        'classic'
    }
    $isMatch = if ($Classic) {
        Test-Naming -Classic
    }
    else {
        Test-Naming -Standard
    }
    $naming = Get-Naming
    Assert-True $isMatch -ErrorText "Expected naming '$want' but the repo is '$($naming -join ', ')' — set naming in variants.yml."
}

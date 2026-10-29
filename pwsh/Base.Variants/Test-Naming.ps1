function Test-Naming {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [switch] $Standard,

        [Parameter(Mandatory, ParameterSetName = 'Classic')]
        [switch] $Classic
    )

    $naming = Get-Naming
    $want = if ($Standard) {
        'standard'
    }
    elseif ($Classic) {
        'classic'
    }
    $naming -is [string] -and $naming -eq $want
}

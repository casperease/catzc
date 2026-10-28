function Test-WriterDue {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [AllowNull()]
        [object[]] $Row
    )

    $found = @($Row | Where-Object { $null -ne $_ -and $_.Name -ceq $Name })
    # A writer with no row runs, as every writer does when the due rows cannot be read.
    if ($found.Count -eq 0) {
        return $true
    }
    [bool] $found[0].Due
}

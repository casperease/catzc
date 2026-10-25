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
    # A writer with no row, or none declaring lists, runs as it always has.
    if ($found.Count -eq 0 -or -not $found[0].HasLists) {
        return $true
    }
    [bool] $found[0].Due
}

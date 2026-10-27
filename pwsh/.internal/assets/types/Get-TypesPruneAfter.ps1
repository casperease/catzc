function Get-TypesPruneAfter {
    [OutputType([TimeSpan])]
    param()

    [TimeSpan]::FromDays(1)
}

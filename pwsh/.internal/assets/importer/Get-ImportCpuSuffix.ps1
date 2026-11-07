function Get-ImportCpuSuffix {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [double] $TotalSeconds,

        # Null when the roof is not known, which names no CPU time.
        [Nullable[int]] $RoofSeconds,

        [Parameter(Mandatory)]
        [double] $CpuSeconds
    )

    if ($null -eq $RoofSeconds -or $TotalSeconds -le $RoofSeconds) {
        return ''
    }
    ", $([math]::Round($CpuSeconds, 1)) s of CPU"
}

function Get-ImportCpuSuffix {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [double] $TotalSeconds,

        # Null when the roof is not known, which names no CPU time.
        [Nullable[int]] $RoofSeconds,

        [Parameter(Mandatory)]
        [double] $CpuSeconds,

        # True when the antivirus signature differs from the ledger's last line: the first import after an update waits on the scan of every script it reads.
        [switch] $AntivirusSignatureChanged
    )

    if ($null -eq $RoofSeconds -or $TotalSeconds -le $RoofSeconds) {
        return ''
    }
    $suffix = ", $([math]::Round($CpuSeconds, 1)) s of CPU"
    if ($AntivirusSignatureChanged) {
        $suffix += ', the first import since an antivirus signature update'
    }
    $suffix
}

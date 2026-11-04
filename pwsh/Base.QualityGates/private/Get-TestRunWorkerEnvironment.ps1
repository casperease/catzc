function Get-TestRunWorkerEnvironment {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [int] $MaxLevel
    )

    # The L0/L1 tripwire rides each worker's own environment: a real process there means a missed Mock.
    $mode = if ($MaxLevel -lt [Catzc.Base.Timeouts.TestTiers]::FirstRealProcessTier) {
        [Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch
    }
    else {
        [Catzc.Base.Timeouts.TestTiers]::BlockByTier
    }
    @{ CATZC_BLOCK_REAL_PROCESS = $mode }
}

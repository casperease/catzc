function Test-RealProcessBlocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $mode = $env:CATZC_BLOCK_REAL_PROCESS
    if (-not $mode) {
        return $false
    }
    if ($mode -eq [Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch) {
        return $true
    }
    if ($mode -ne [Catzc.Base.Timeouts.TestTiers]::BlockByTier) {
        throw "CATZC_BLOCK_REAL_PROCESS is '$mode', which is neither '$([Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch)' nor '$([Catzc.Base.Timeouts.TestTiers]::BlockByTier)'."
    }

    # Armed per container: only an L0 or L1 Describe forbids a real process; outside any Describe nothing is armed.
    $pester = Get-Module Pester
    if (-not $pester) {
        return $false
    }
    $block = & $pester { $state.CurrentBlock }
    if (-not $block -or $block.IsRoot) {
        return $false
    }
    while ($block.Parent -and -not $block.Parent.IsRoot) {
        $block = $block.Parent
    }
    $processFree = [Catzc.Base.Timeouts.TestTiers]::Names[0..([Catzc.Base.Timeouts.TestTiers]::FirstRealProcessTier - 1)]
    [bool] (@($block.Tag) | Where-Object { $_ -in $processFree })
}

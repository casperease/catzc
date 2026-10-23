function Test-RealProcessBlocked {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $mode = $env:CATZC_BLOCK_REAL_PROCESS
    if (-not $mode) {
        return $false
    }
    if ($mode -ne 'tier') {
        return $true
    }

    $pester = Get-Module Pester
    if (-not $pester) {
        return $false
    }
    $block = & $pester { Get-CurrentBlock }
    if (-not $block -or $block.IsRoot) {
        return $false
    }
    while ($block.Parent -and -not $block.Parent.IsRoot) {
        $block = $block.Parent
    }
    [bool] (@($block.Tag) | Where-Object { $_ -in 'L0', 'L1' })
}

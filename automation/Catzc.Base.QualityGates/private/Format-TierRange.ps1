# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Format-TierRange.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Formats a tier range the way a test run names it: 'L2' for one tier, 'L0-L2' for a range.
.PARAMETER MinLevel
    The lowest tier.
.PARAMETER MaxLevel
    The highest tier.
.OUTPUTS
    [string]
.EXAMPLE
    Format-TierRange -MinLevel 0 -MaxLevel 2
#>
function Format-TierRange {
    [OutputType([string])]
    param(
        [int] $MinLevel = 0,

        [int] $MaxLevel = 3
    )

    if ($MinLevel -eq $MaxLevel) {
        return "L$MaxLevel"
    }
    "L$MinLevel-L$MaxLevel"
}

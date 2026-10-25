<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Format-TierRange.ps1.md"
  warning: "Generated Header"
---
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

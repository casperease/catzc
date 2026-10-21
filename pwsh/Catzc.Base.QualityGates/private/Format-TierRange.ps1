<#
---
catzc:
  immutable:
    with_body_sha: c1abd6bdc4f8
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Format-TierRange.Tests.ps1
    docs: "[Format-TierRange.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Format-TierRange.ps1.md)"
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

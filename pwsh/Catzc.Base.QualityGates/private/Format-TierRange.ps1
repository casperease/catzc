<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Format-TierRange.ps1
    folder: private
    name: format-tier-range
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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

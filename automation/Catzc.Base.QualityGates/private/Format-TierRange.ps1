<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Format-TierRange.ps1
    folder: private
    name: format-tier-range
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Format-TierRange.Tests.ps1
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

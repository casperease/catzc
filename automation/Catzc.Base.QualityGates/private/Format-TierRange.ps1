<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Format-TierRange.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Format-TierRange.Tests.ps1
  config:
    synopsis: 'Formats a tier range the way a test run names it: ''L2'' for one tier, ''L0-L2'' for a range.'
    parameters:
      MinLevel: The lowest tier.
      MaxLevel: The highest tier.
    outputs: '[string]'
    examples:
      - Format-TierRange -MinLevel 0 -MaxLevel 2
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

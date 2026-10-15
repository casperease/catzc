<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
    kind: assert-function
    module: Catzc.Azure.Cli
    visibility: public
    adrs:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI#1
---
#>

<#
.SYNOPSIS
    Asserts the Bicep CLI is available to az and at or above the configured minimum (throws otherwise).
.DESCRIPTION
    Fails early because a missing or stale Bicep makes az bicep build exit 0 yet write no main.json.
.PARAMETER ErrorText
    Custom error message. Defaults to one naming the specific cause and the matching az bicep fix.
.EXAMPLE
    Assert-AzCliBicep
#>
function Assert-AzCliBicep {
    param(
        [string] $ErrorText
    )

    Assert-Tool 'az_cli'

    $state = Get-AzCliBicepState
    if ($state.meets_minimum) {
        return
    }

    if ($ErrorText) {
        throw $ErrorText
    }

    if (-not $state.installed) {
        throw (
            'The Bicep CLI is not available to az (`az bicep version` failed). ' +
            '`az bicep build` cannot compile without it. Run: az bicep install'
        )
    }
    if ($null -eq $state.version) {
        throw (
            'Could not determine the Bicep CLI version from `az bicep version`. ' +
            "At least $($state.min_version) is required. Run: az bicep upgrade"
        )
    }
    throw (
        "The Bicep CLI version $($state.version) is below the required minimum " +
        "$($state.min_version) (azure.yml bicep_min_version). Run: az bicep upgrade"
    )
}

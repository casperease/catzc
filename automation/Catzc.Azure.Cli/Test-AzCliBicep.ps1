<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
    kind: gate-function
    module: Catzc.Azure.Cli
    visibility: public
    adrs:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI#1
---
#>

<#
.SYNOPSIS
    Tests whether the Bicep CLI is available to az AND at or above the configured minimum version.
.DESCRIPTION
    Probes up front because a missing or stale Bicep makes az bicep build exit 0 yet write no main.json.
.EXAMPLE
    if (Test-AzCliBicep) { Build-Bicep sample }
#>
function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}

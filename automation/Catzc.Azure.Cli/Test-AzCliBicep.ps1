<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
---
#>

<#
.SYNOPSIS
    Tests whether the Bicep CLI is available to az AND at or above the configured minimum version.
.DESCRIPTION
    Probes up front because a missing or stale Bicep makes az bicep build exit 0 yet write no main.json.
    [ADR-AUTO-ENTERP](/docs/adr/automation/effective-in-enterprises.md),
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1)
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliBicep.ps1.md#comment1)
.EXAMPLE
    if (Test-AzCliBicep) { Build-Bicep sample }
#>
function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}

<#
.SYNOPSIS
    Tests whether the Bicep CLI is available to az AND at or above the configured minimum version.
.DESCRIPTION
    Returns $true when `az bicep version` exits zero and reports a version at or above Get-AzureBicepMinVersion...
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1),
    [ADR-AUTO-ENTERP](/docs/adr/automation/effective-in-enterprises.md)
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliBicep.ps1.md#comment1)
.EXAMPLE
    if (Test-AzCliBicep) { Build-Bicep sample }
#>
function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}

<#
.SYNOPSIS
    Tests whether the Bicep CLI is available to az AND at or above the configured minimum version.
.DESCRIPTION
    Returns $true when `az bicep version` exits zero and reports a version at or above
    Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); $false otherwise (not installed, unparseable,
    or too old). A pure query: it never throws. Use Assert-AzCliBicep for the throwing companion (with a
    remediation message that distinguishes not-installed from too-old). Both share Get-AzCliBicepState.

    Why this exists: `az bicep build` auto-installs the Bicep CLI on first use, and on a machine where
    that install is missing, blocked (enterprise proxy/firewall), or stale, the first build can exit zero
    while writing no main.json. Probing `az bicep version` first surfaces — and warms — the Bicep CLI, and
    enforces a known-good minimum, before a build depends on it.
    See docs/adr/automation/powershell/prefer-az-cli.md#rule-adr-azcli1 and effective-in-enterprises.md.
.EXAMPLE
    if (Test-AzCliBicep) { Build-Bicep sample }
#>
function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}

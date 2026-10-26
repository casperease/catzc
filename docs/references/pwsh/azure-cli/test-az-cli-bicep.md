# pwsh/Azure.Cli/Test-AzCliBicep.ps1

The query twin of the Bicep assertion: it returns a bool for whether the Bicep CLI is available to az and at or above the configured minimum
version.

## help

### synopsis

Tests whether the Bicep CLI is available to az AND at or above the configured minimum version.

### description

Returns
$true when `az bicep version` exits zero and reports a version at or above
Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); $false
otherwise (not installed, unparseable, or too old). A pure query: it never throws. Use Assert-AzCliBicep for the throwing companion (with a
remediation message that distinguishes not-installed from too-old). Both share Get-AzCliBicepState.

Why this exists: `az bicep build` auto-installs the Bicep CLI on first use, and on a machine where that install is missing, blocked
(enterprise proxy/firewall), or stale, the first build can exit zero while writing no main.json. Probing `az bicep version` first surfaces —
and warms — the Bicep CLI, and enforces a known-good minimum, before a build depends on it. See
[ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault) and
[ADR-AUTO-ENTERP](../../../drs/automation/effective-in-enterprises.md).

### example 1

```powershell
if (Test-AzCliBicep) { Build-Bicep sample }
```

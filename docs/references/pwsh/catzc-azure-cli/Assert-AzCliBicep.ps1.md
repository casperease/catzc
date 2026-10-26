# pwsh/Azure.Cli/Assert-AzCliBicep.ps1

The throwing check that the Bicep CLI az needs is installed and at or above the configured minimum version. It exists so a build fails early
with a named cause and the matching fix, instead of `az bicep build` exiting 0 without writing a file.

## help

### synopsis

Asserts the Bicep CLI is available to az and at or above the configured minimum (throws otherwise).

### description

The throwing companion to Test-AzCliBicep. Throws a remediation-bearing error when the Bicep CLI that `az bicep build` needs is missing or
below Get-AzureBicepMinVersion (azure.yml `bicep_min_version`), distinguishing the two cases: not installed -> `az bicep install`; too old
-> `az bicep upgrade`. Asserting it before a build turns the silent "az bicep build exits 0 but writes no main.json" failure into a clear,
early error at the source. It first asserts the az CLI itself is installed at the locked version (Assert-Tool 'az_cli'), then checks the
Bicep CLI. Both share Get-AzCliBicepState. See [ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault) and
[ADR-AUTO-ENTERP](../../../drs/automation/effective-in-enterprises.md).

### parameter `ErrorText`

Custom error message. Defaults to one naming the specific cause and the matching az bicep fix.

### example 1

```powershell
Assert-AzCliBicep
```

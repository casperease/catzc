# pwsh/Azure.Cli/Install-AzCliBicep.ps1

The command that installs, or upgrades, the Bicep CLI az uses so that it meets the configured minimum version.

## help

### synopsis

Installs (or upgrades) the Bicep CLI that az uses, to at least the configured minimum.

### description

The install companion to Test-AzCliBicep (query) and Assert-AzCliBicep (throw). `az bicep build` needs the Bicep CLI; this provisions it
deterministically instead of relying on az's silent first-use auto-install, which can fail quietly behind an enterprise proxy or leave a
stale version. Idempotent — skips when the Bicep CLI already meets Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); installs it
when absent, upgrades it when too old. Asserts the az CLI itself first (Assert-Tool 'az_cli'), and confirms the result meets the minimum
before returning. See [ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

### parameter `Force`

Upgrade to the latest Bicep CLI even when the installed one already meets the minimum.

### example 1

```powershell
Install-AzCliBicep
```

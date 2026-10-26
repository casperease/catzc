# pwsh/Azure/Get-AzureBicepMinVersion.ps1

The public accessor for the minimum Bicep CLI version that `configs/azure.yml` requires. It exists so the Bicep assert and test commands
compare against one declared value instead of a literal in their own code.

## help

### synopsis

Returns the minimum required Bicep CLI version from azure.yml.

### description

Reads the required `bicep_min_version` global from configs/azure.yml (validated as MAJOR.MINOR.PATCH by the AzureConfig type on load) and
returns it as a `[version]` for comparison. Assert-AzCliBicep / Test-AzCliBicep use it to decide whether `az bicep build` may run.

### example 1

```powershell
Get-AzureBicepMinVersion   # -> 0.30.0
```

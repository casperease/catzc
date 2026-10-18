# automation/Catzc.Azure/Get-AzureBicepMinVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

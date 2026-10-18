# automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Parses a config / resource-group identity name into its (environment, slot) parts.

### description

The inverse of Get-BicepConfigName. A config-name is `<environment>[-<slot>]`; env names contain no hyphen, so splitting on the FIRST `-`
cleanly separates them: the part before is the environment (must be defined in azure.yml), the remainder is the optional slot (1-3 lowercase
alphanumeric, empty for the base slot). Used at discovery to map config filenames back to envs. See
[ADR-AZ-DATAMOD#2](../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2).

### parameter `ConfigName`

The config-name (a config filename without extension), e.g. `dev` or `dev-001`.

### example 1

```powershell
Resolve-BicepConfigName dev-001   # -> @{ environment = 'dev'; slot = '001' }
```

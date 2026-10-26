# pwsh/Azure.Templates/private/Resolve-BicepConfigName.ps1

The private function that parses a config and resource-group identity name into its environment and slot parts, the inverse of
`Get-BicepConfigName`.

## help

### synopsis

Parses a config / resource-group identity name into its (environment, slot) parts.

### description

The inverse of Get-BicepConfigName. A config-name is `<environment>[-<slot>]`; env names contain no hyphen, so splitting on the FIRST `-`
cleanly separates them: the part before is the environment (must be defined in azure.yml), the remainder is the optional slot (1-3 lowercase
alphanumeric, empty for the base slot). Used at discovery to map config filenames back to envs. See
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription).

### parameter `ConfigName`

The config-name (a config filename without extension), e.g. `dev` or `dev-001`.

### example 1

```powershell
Resolve-BicepConfigName dev-001   # -> @{ environment = 'dev'; slot = '001' }
```

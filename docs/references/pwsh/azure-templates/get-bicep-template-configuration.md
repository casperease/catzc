# pwsh/Azure.Templates/Get-BicepTemplateConfiguration.ps1

The function that loads a template's per-slot config and returns it as an ordered dictionary.

## help

### synopsis

Loads a template's per-slot config and returns the ordered dictionary.

### description

Returns the parsed yml as an ordered dictionary — typically just a `ParametersFile` (the template's ARM parameters, written statically). No
merge with global config happens here; PrePost's Invoke-BicepPrepareParameterSet is the merge seam. A ResourceGroup-target slot's
top-level `ResourceGroup:` key comes back with the rest, and Get-BicepDeploymentContext reads it as the deploy target
([ADR-AZ-DATAMOD-DECLAREDGROUPNAME](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-declaredgroupname)).

The config address is literal ([ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)): a configuration-root file
`configuration/<env>[-<slot>].yml` (the shared-platform deployment), or a customer's file `configuration/<customer>/<env>[-<slot>].yml` when
-Customer is given. No resolution machinery — the coordinate IS the file.

### parameter `Template`

Template name (folder under infrastructure/templates/).

### parameter `Environment`

Environment shortname. Must be configured for the template.

### parameter `Slot`

Optional special-slot discriminator — 1-3 lowercase alphanumeric chars (`001`, `blu`, …). Selects `<env>-<slot>.yml`; omitted selects the
env's base slot `<env>.yml`. The selected config must exist.

### parameter `Customer`

Optional customer key (a configuration subfolder). Selects the config under `configuration/<customer>/`; omitted selects the
configuration-root (shared-platform) config.

### example 1

```powershell
$configuration = Get-BicepTemplateConfiguration sample dev
```

### example 2

```powershell
$configuration = Get-BicepTemplateConfiguration sample dev -Customer apex
```

### example 3

```powershell
$configuration = Get-BicepTemplateConfiguration indexed-template prod -Slot 001
$configuration.ParametersFile.parameters.storageAccountName.value
```

## The coordinate is the file address

There is one config file per customer (optional), environment and slot. The coordinate is the file address: the configuration root for the
shared platform, `configuration/<customer>/` for a customer deployment.

## A bicepparam slot

The Bicep compiler reads a `.bicepparam` slot, not this function, so its descriptor carries its source path
([ADR-AZ-DATAMOD-BICEPPARAMSLOT](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-bicepparamslot)) and, for a ResourceGroup-target
slot, the `ResourceGroup` its sibling `<slot>.yml` declares, the one key that sibling holds.

# infrastructure/modules/data-factory.bicep

The reusable module for an Azure Data Factory.

## Defaults

Public network access is off by default (`publicNetworkAccess`, default `Disabled`), like the Key Vault's, so the factory is reached through
a private endpoint. Set `Enabled` only for a factory that must be reached from the internet.

## Use

A template references it with a relative `module` declaration (`../../modules/data-factory.bicep`), and `bicep build` inlines it into the
template's `main.json`.

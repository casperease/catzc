# infrastructure/modules

Reusable bicep modules, shared across templates in `infrastructure/templates/`.

These are plain `.bicep` files. A template references one with a relative `module` declaration from its `main.bicep`:

```bicep
module storage '../../modules/storage-account.bicep' = {
  name: 'storage'
  params: {
    name: storageAccountName
  }
}
```

`az bicep build` (run by `Build-Bicep`) **inlines** the referenced module into the template's compiled `main.json`, so nothing from this
folder ships separately at deploy time.

Modules here are **not** discovered as templates — `Get-BicepTemplates` scans only `infrastructure/templates/`. A folder under `modules/`
does not need `options.yml`, `configuration/`, or any of the template structure; it is just bicep.

## The modules

- `log-analytics.bicep` — a Log Analytics workspace (the shared telemetry sink).
- `key-vault.bicep` — a Key Vault (holds secrets such as the SQL admin password).
- `storage-account.bicep` — a single storage account.
- `sql-server.bicep` — a SQL server (logical server).
- `sql-database.bicep` — a SQL database on a server.
- `data-factory.bicep` — an Azure Data Factory.
- `virtual-network.bicep` — a virtual network with its subnet, NIC, and public IP.
- `vm.bicep` — a virtual machine.

See the [Catzc.Azure.Templates reference](../automation/catzc-azure-templates.md) for the templating system overview.

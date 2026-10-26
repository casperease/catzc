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

Every module deploys at resource-group level unless its target scope says otherwise. Modules that create a resource take a `tags` object;
`location` defaults to the resource group (or, at subscription scope, the deployment) location.

### Data and monitoring

- `log-analytics.bicep` — a Log Analytics workspace (the shared telemetry sink).
- `key-vault.bicep` — a Key Vault (holds secrets such as the break-glass SQL password).
- `storage-account.bicep` — a StorageV2 account, with the Well-Architected defaults below. Outputs `id`, `name`, `principalId`, and
  `blobEndpoint`.
- `sql-server.bicep` — a SQL logical server, with the Well-Architected defaults below. It requires the Entra ID administrator
  (`entraAdminLogin`, `entraAdminObjectId`). Outputs `id`, `name`, `principalId`, and `fullyQualifiedDomainName`.
- `sql-database.bicep` — a SQL database on a server, with the Well-Architected defaults below. Serverless SKUs take `autoPauseDelay` and
  `minCapacity`. Outputs `id` and `name`.
- `data-factory.bicep` — an Azure Data Factory.
- `diagnostic-setting.bicep` — sends one resource's logs and metrics to a Log Analytics workspace (`workspaceId`). A diagnostic setting
  attaches to a typed resource, so the caller names the `resourceKind` (`storageAccount`, `blobService`, `sqlDatabase`, `keyVault`,
  `networkSecurityGroup`, `virtualNetwork`) and the `resourceName` (plus `parentName`, the server, for `sqlDatabase`). Logs go by the
  `allLogs` category group; metrics by the categories that kind exports.
- `subscription-diagnostic-setting.bicep` (target scope `subscription`) — sends the activity log of the subscription to a Log Analytics
  workspace.

### Network

- `virtual-network.bicep` — a virtual network with its `subnets` declared inline (`name`, `addressPrefix`, and optionally
  `networkSecurityGroupId`, `routeTableId`, `privateEndpointNetworkPolicies`). Outputs `id`, `name`, and `subnetIds`, keyed by subnet name.
  A VNet owns its subnets: redeploying it with a subnet missing from the list tries to delete that subnet, so a template lists every subnet
  of a VNet it deploys here.
- `subnet.bicep` — one subnet added to an existing VNet that the template does not deploy itself.
- `nsg.bicep` — a network security group; the caller passes the `securityRules` in the ARM shape. The Azure default rules (allow VNet and
  load-balancer inbound, deny all other inbound) apply beneath them.
- `route-table.bicep` — a route table; the caller passes the `routes` in the ARM shape.
- `vnet-peering.bicep` — one side of a VNet peering (`virtualNetworkName` → `remoteVirtualNetworkId`, which may be in another subscription).
  A peering is two-sided: the hub deploys hub → spoke and the spoke deploys spoke → hub.
- `private-dns-zone.bicep` — a `privateDnsZones` resource for one private-link DNS name (e.g. `privatelink.blob.core.windows.net`) with a
  VNet link, named after the VNet, to each of `virtualNetworkIds`.
- `private-endpoint.bicep` — a private endpoint in `subnetId` for one `groupId` (`blob`, `sqlServer`, …) of `privateLinkServiceId`, with a
  `privateDnsZoneGroups` entry registering it in `privateDnsZoneIds`.
- `vm.bicep` — a virtual machine with its NIC and public IP, attached to an existing subnet.

### Subscription

- `resource-group.bicep` (target scope `subscription`) — a resource group. A subscription-level template creates its resource groups with
  it, then deploys into them with `scope: resourceGroup(<name>)`.
- `policy-assignment.bicep` (target scope `subscription`) — assigns a policy definition (`policyDefinitionId`, `parameters` in the ARM shape
  `{ <name>: { value: … } }`). `enforcementMode` (`Default` or `DoNotEnforce`) is required and has no default in the module: a template
  reads it from the repository-wide `policy_enforcement` setting in `azure.yml`. A policy that deploys or modifies resources sets
  `assignIdentity` and lists the `roleDefinitionIds` its remediation needs; the module grants them to the assignment's identity on the
  subscription.
- `budget.bicep` (target scope `subscription`) — a cost budget of `amount` per `timeGrain` from `startDate` (the first of a month), with an
  alert per entry of `thresholds` (percent; 50, 80, 100 by default). Alerts go to the holders of `contactRoles` (`Owner` by default), so no
  email address is kept in configuration.

## Well-Architected defaults

The storage and SQL modules carry the Well-Architected settings as parameters with secure defaults, so every caller gets them unless it
overrides one on purpose.

- `storage-account.bicep`:
  - `skuName` is `Standard_ZRS` (zone-redundant);
  - `publicNetworkAccess` is `Disabled`, and the network rules deny by default, so the account is reached through a private endpoint;
  - TLS 1.2 minimum, HTTPS only, and no anonymous blob access are fixed;
  - `allowSharedKeyAccess` is `false`, so callers authenticate with Entra ID;
  - `deleteRetentionDays` is `7`, the soft delete for blobs and containers;
  - a system-assigned managed identity is fixed.
- `sql-server.bicep`:
  - the Entra ID administrator is required (`entraAdminLogin`, `entraAdminObjectId`), and `entraAdminPrincipalType` is `Group`;
  - `entraOnlyAuthentication` is `true`; a break-glass SQL login sets it to `false` and passes `administratorLogin` and
    `administratorLoginPassword` (a Key Vault reference);
  - `publicNetworkAccess` is `Disabled`; the "allow Azure services" firewall rule exists only with `allowAzureServices` and public access
    on;
  - TLS 1.2 minimum and a system-assigned managed identity are fixed.
- `sql-database.bicep`:
  - `zoneRedundant` is on for the Premium, GeneralPurpose, BusinessCritical, and Hyperscale tiers;
  - `backupStorageRedundancy` is `Geo`;
  - `backupRetentionDays` is `7`, the point-in-time restore window (Basic allows at most 7).

See the [Catzc.Azure.Templates reference](../pwsh/azure-templates/index.md) for the templating system overview.

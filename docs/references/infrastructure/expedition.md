# expedition

A Well-Architected workload: a storage account and a SQL database, reached only through private endpoints, landing in the `discovery`
landing zone. `expedition` owns its data resources and nothing of the network or the guardrails around them. A customer's deployment places
its private endpoints in the `private-endpoints` subnet of the customer's spoke; a shared-platform deployment places them in the hub's
`shared-services` subnet. Either way they register in the hub's private DNS zones. It needs `discovery`'s network and DNS zones and
`foundation`'s Log Analytics workspace and Key Vault, so both deploy first (see [discovery](discovery.md) and [foundation](foundation.md)).
The configuration tree is [data-model](../../drs/azure/azure-data-model.md).

## Resources

- Storage account — `storage-account.bicep`
- SQL logical server, with an Entra ID administrator group and a break-glass SQL login — `sql-server.bicep`
- SQL database — `sql-database.bicep`
- Private endpoint of the blob service and of the SQL server, each registered in its private DNS zone in the hub — `private-endpoint.bicep`
- Diagnostics of the storage account, its blob service, and the database to `foundation`'s workspace — `diagnostic-setting.bicep`

## The Well-Architected pillars

- **Reliability:** zone-redundant storage (`Standard_ZRS`). In production the database is zone-redundant, with geo-redundant backups kept
  for 35 days; outside production, local backups kept for 7.
- **Security:** no public network access to the account or the server, TLS 1.2 minimum, and a system-assigned managed identity on both. The
  server's administrator is an Entra ID group. The break-glass SQL login takes its password from a Key Vault reference to `foundation`'s
  vault (secret `exped-sql-admin-password`), so no secret is kept in the repository.
- **Cost optimisation:** outside production the database is serverless (`GP_S_Gen5`) and pauses after an hour without activity; in
  production it is provisioned (`GP_Gen5`).
- **Operational excellence:** every resource sends its logs and metrics to `foundation`'s workspace, and carries the CAF tags.
- **Performance efficiency:** the database SKU, tier, and vCores are config values per environment class.

## Recovery objectives

The recovery point objective (RPO, the most data a recovery may lose) and the recovery time objective (RTO, the longest a recovery may take)
per environment class follow from the backups the configuration sets; a change to those backups changes these targets in the same change.

- **`production`:** a fault in one zone loses nothing and recovers by itself, since the database and the storage are zone-redundant. A
  point-in-time restore inside the 35 days of retention has an RPO of 10 minutes and an RTO of 4 hours. A geo-restore after a regional
  outage, from the geo-redundant backups, has an RPO of 1 hour and an RTO of 12 hours.
- **`nonproduction`:** a point-in-time restore inside the 7 days of retention has an RPO of 10 minutes and an RTO of 1 business day; a
  regional outage is recovered by a redeploy from the repository, with the data rebuilt rather than restored.

## Configuration

- `short_name`: `exped`; `environment_kind`: `standard` (per environment).
- `configuration/apex/dev.yml`, the ephemeral slot `dev-blu` on it (a second deployment beside the base one, with no file: cd-apex deploys
  it from its own target list), and `configuration/apex/prod.yml` for apex; `configuration/nova/dev.yml` for nova; `configuration/dev.yml`
  and `configuration/test.yml` at the configuration root, for the shared platform.
- The network is named by resource group, virtual network, and subnet. The hub's subscription id, which holds the private DNS zones, is a
  config address into `azure.yml` (`global.azure.subscriptions.<hub subscription>.id`).
- The break-glass password is a Key Vault `reference` to `foundation`'s vault in the same subscription.
- No `PrePost.psm1`.

## Modules used

- `storage-account.bicep`, `sql-server.bicep`, `sql-database.bicep`, `private-endpoint.bicep`, `diagnostic-setting.bicep` — see
  [modules](modules.md).

# infrastructure/templates/expedition/main.bicep

The expedition template, the Well-Architected workload: a storage account and a SQL server with one database. They are reached only through
private endpoints in a discovery network, either a customer spoke's private-endpoints subnet or the hub's shared-services subnet for the
shared platform, and registered in the hub's private DNS zones.

It deploys into its own resource group, one per configuration slot.

## The pillars

Each pillar is a module default or a config value.

- **Reliability** — zone-redundant storage; a zone-redundant database and geo backups in production; the backup retention per environment
  class.
- **Security** — no public network access; TLS 1.2; managed identities; an Entra ID administrator group, plus a break-glass SQL login whose
  password is a Key Vault reference to foundation's vault.
- **Cost optimisation** — a serverless database that pauses when idle outside production, provisioned in it.
- **Operational excellence** — diagnostics from the storage account, its blobs and the database to foundation's Log Analytics workspace; the
  CAF tags on every resource.
- **Performance efficiency** — the database SKU and tier per environment class, from the config.

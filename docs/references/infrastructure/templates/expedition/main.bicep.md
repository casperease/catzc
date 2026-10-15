---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/main.bicep.md
    kind: reference
    body_sha: "0227d1cda920"
    adrs: []
---

# infrastructure/templates/expedition/main.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Azure region. Defaults to the resource group location; it must...`.

```text
expedition — the Well-Architected workload: a storage account and a SQL server with one database,
reached only through private endpoints in a discovery network (a customer spoke's private-endpoints
subnet, or the hub's shared-services subnet for the shared platform) and registered in the hub's
private DNS zones. Deployed into its own resource group, one per configuration slot.

The pillars, each a module default or a config value:
  Reliability            — zone-redundant storage; a zone-redundant database and geo backups in production;
                           the backup retention per environment class.
  Security               — no public network access; TLS 1.2; managed identities; an Entra ID administrator
                           group, plus a break-glass SQL login whose password is a Key Vault reference to
                           foundation's vault.
  Cost optimisation      — a serverless database that pauses when idle outside production, provisioned in it.
  Operational excellence — diagnostics from the storage account, its blobs, and the database to foundation's
                           Log Analytics workspace; the CAF tags on every resource.
  Performance efficiency — the database SKU and tier per environment class, from the config.
```

---
catzc:
  immutable:
    with_body_sha: ef636b89241d
    path: docs/references/infrastructure/templates/expedition/main.bicep.md
    folder: docs/references/infrastructure/templates/expedition
    name: main-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/expedition/main.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Azure region. Defaults to the resource group location; it must...`, written with `//`.

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

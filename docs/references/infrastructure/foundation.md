---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/infrastructure/foundation.md
    folder: docs/references/infrastructure
    name: foundation
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/azure/azure-data-model.md
      - docs/references/infrastructure/discovery.md
      - docs/references/infrastructure/expedition.md
      - docs/references/infrastructure/modules.md
---

# foundation

The once-per-subscription baseline. `foundation` deploys the shared services every other template in the subscription depends on — a Log
Analytics workspace and a Key Vault — and nothing customer- or environment-specific. It is classified `environment_kind: subscription` — one
deployment per subscription, not per environment (see [data-model](../../adr/azure/azure-data-model.md)).

Its consumers name its resources in their configs, so `foundation` deploys before them:

- [discovery](discovery.md) sends the activity log of the subscription, and the diagnostics of its network, to the workspace.
- [expedition](expedition.md) sends the diagnostics of its storage and database to the workspace, and takes the password of its break-glass
  SQL login from a Key Vault reference to the vault (secret `exped-sql-admin-password`).

## Resources

- Log Analytics workspace — `log-analytics.bicep`
- Key Vault — `key-vault.bicep`

## Configuration

- `short_name`: `fnd`; `environment_kind`: `subscription`.
- One config per subscription, keyed by the per-subscription environment (`nsub` non-production, `psub` production); no special slot.
- `configuration/<nsub|psub>.yml` at the configuration root — the shared platform pair — plus `configuration/<customer>/<nsub|psub>.yml` for
  the `apex`, `nova`, and `flux` customers (non-production and, for apex, production).

## Modules used

- `log-analytics.bicep`, `key-vault.bicep` — see [modules](modules.md).

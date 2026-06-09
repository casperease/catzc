# foundation

The once-per-subscription baseline. `foundation` deploys the shared services every other template in the subscription depends on — a Log
Analytics workspace and a Key Vault — and nothing customer- or environment-specific. Its Key Vault holds the SQL admin password readers read
at deploy time (injected by their `PrePost.psm1`), so foundation must deploy before them. It is classified `environment_kind: subscription`
— one deployment per subscription, not per environment (see[data-model](../../adr/azure/data-model.md)).

## Resources

- Log Analytics workspace — `log-analytics.bicep`
- Key Vault — `key-vault.bicep`

## Configuration

- `short_name`: `fnd`; `environment_kind`: `subscription`.
- One config per subscription, keyed by the per-subscription environment (`subn` non-production, `subp` production); no slot.
- `configuration/<subscription>/<subn|subp>.yml` — shipped for the `shared`, `apex`, `nova`, and `flux` subscriptions (non-production and,
  for shared/apex, production).

## Modules used

- `log-analytics.bicep`, `key-vault.bicep` — see [modules](modules.md).

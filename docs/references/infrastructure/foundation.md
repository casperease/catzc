# foundation

The once-per-subscription baseline. `foundation` deploys the shared services every other template in the subscription depends on — a Log
Analytics workspace and a Key Vault — and nothing customer- or environment-specific. It is classified as a subscription template — one
deployment per subscription, not per environment (see [data-model](../../drs/azure/azure-data-model.md)).

Its consumers name its resources in their configs, so `foundation` deploys before them, and once more after `discovery` for the vault's
private endpoint:

- [discovery](discovery.md) sends the activity log of the subscription, and the diagnostics of its network, to the workspace.
- [expedition](expedition.md) sends the diagnostics of its storage and database to the workspace, and takes the password of its break-glass
  SQL login from a Key Vault reference to the vault (secret `exped-sql-admin-password`).

## Resources

- Log Analytics workspace — `log-analytics.bicep`
- Key Vault, with purge protection on and public network access off — `key-vault.bicep`
- The vault's diagnostics to the workspace — `diagnostic-setting.bicep`
- The vault's private endpoint, in the subscription's network (a spoke's `private-endpoints` subnet, a hub's `shared-services` subnet) and
  registered in the hub's `privatelink.vaultcore.azure.net` zone — `private-endpoint.bicep`

## Configuration

- `short_name`: `fnd`; environment kind (inferred): subscription.
- One config per subscription, keyed by the per-subscription environment (`nsub` non-production, `psub` production); no special slot.
- `configuration/<nsub|psub>.yml` at the configuration root — the shared platform pair — plus `configuration/<customer>/<nsub|psub>.yml` for
  the `apex`, `nova`, and `flux` customers (non-production and, for apex, production).
- The vault endpoint's names derive through `options.yml` `names:`: its own, the network's resource group and virtual network, and the hub's
  DNS zone resource group; each slot addresses its hub's subscription id. `PrePost.psm1` keeps one choice, the subnet by network kind (a
  hub's shared-services, a spoke's private-endpoints), and a value the slot sets wins. `deployKeyVaultPrivateEndpoint: { value: false }` is
  the bootstrap pass, deployed before `discovery` has built the network, so the deploy order is `foundation`, `discovery`, then `foundation`
  again.
- `secretNames` overrides a secret name one entry at a time; the template outputs the merged names for its consumers.

## Modules used

- `log-analytics.bicep`, `key-vault.bicep`, `diagnostic-setting.bicep`, `private-endpoint.bicep` — see [modules](modules.md).

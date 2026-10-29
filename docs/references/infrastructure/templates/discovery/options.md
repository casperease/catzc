# infrastructure/templates/discovery/options.yml

The per-template options of discovery, the CAF application landing zone: the hub-and-spoke network, the policy assignments, the activity log
and the budget of one subscription. It deploys at subscription level.

## Classification

The classification follows [ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md) and is inferred, never declared in `options.yml`.

- The environment kind is subscription — configs use the per-subscription envs (`nsub`, `psub`), once per subscription.
- `deployment_target: Subscription` — the deployment is `az deployment sub create`, and the template creates its own resource group.

## comment:1

Above `spokes:`, written with `#`.

```text
Items naming another slot of discovery by its subscription: the network names come from that slot, the peering from the slot that
holds the list (a hub's peering to a spoke takes the spoke customer's shortcode as its role).
```

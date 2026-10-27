# Roll out a spoke

A spoke is the landing zone of one customer subscription: `discovery` deployed with the customer's configuration, its network peered to the
hub of the same environment class ([discovery](../../references/infrastructure/discovery.md)). Rolling one out adds a customer subscription
to an environment class, or adds the production class to a customer that has only non-production.

## Declare it

Everything a spoke needs is configuration, declared in one reviewed change:

1. **The subscription:** its id under `global.azure.subscriptions` in `pwsh/Azure/configs/azure.yml`.
2. **The network:** the spoke's kind, address space and subnets under `global.network.subscriptions.<subscription>` in `network.yml`, with
   an address space that overlaps no other network of the plan ([network-model](../../drs/azure/azure-network-model.md)).
3. **The configurations:** `configuration/<customer>/<nsub|psub>.yml` for `foundation` and for `discovery`, the same coordinates as the
   existing customers'.
4. **The peering:** the spoke's configuration names its hub, and the hub's configuration lists the new spoke. Peering is two-sided, so both
   change in the same commit.

## Deploy it

1. `Deploy-Bicep <nsub|psub> foundation` for the customer, so the spoke's workspace and vault exist.
2. `Deploy-Bicep <nsub|psub> discovery` for the customer, previewed first with `-DryRun`: the spoke's network, guardrails and budget.
3. `Deploy-Bicep <nsub|psub> discovery` for the hub, so the hub's side of the peering is created.
4. Seed the spoke vault's secrets (see [seed a secret](seed-a-secret.md)).

## Check it

- The peering shows `Connected` on both sides.
- The spoke's resources send their diagnostics to its workspace.
- `Test-BicepTemplateCompliance` passes for the customer's configurations.

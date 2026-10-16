---
catzc:
  derived:
    path: docs/references/infrastructure/discovery.md
    kind: reference
    language: markdown
    filekind: md
    track: docs
    body_sha: "499e30733666"
    links:
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-network-model.md
      - docs/references/infrastructure/foundation.md
      - docs/references/infrastructure/modules.md
---

# discovery

The CAF application landing zone of one subscription. `discovery` deploys the network, the guardrails, and the cost control a workload lands
in, and no workload of its own. It is deployed once per subscription, at subscription scope: a **hub** in each shared subscription and a
**spoke** in each customer subscription, peered to its hub. Management groups are out of its reach; the landing zone ends at the
subscription. It needs `foundation`'s Log Analytics workspace, so `foundation` deploys first (see [foundation](foundation.md)). The network
plan is [network-model](../../adr/azure/azure-network-model.md); the configuration tree and the config-addressed parameters are
[data-model](../../adr/azure/azure-data-model.md).

## Resources

- Resource group, with the CAF tags — `resource-group.bicep`
- Virtual network, with every subnet of the network plan declared inline — `virtual-network.bicep`
- Network security group per subnet named in the config, allowing traffic inside the virtual networks and denying inbound traffic from the
  internet — `nsg.bicep`. The reserved hub subnets, `GatewaySubnet` and `AzureFirewallSubnet`, get none, and nothing is deployed into them.
- Spoke only: a route table on every subnet — `route-table.bicep` — and the peering to the hub — `vnet-peering.bicep`
- Hub only: a peering to each spoke the config lists — `vnet-peering.bicep` — and the private DNS zones of SQL Database and Blob Storage
  (`privatelink.database.windows.net`, `privatelink.blob.core.windows.net`, spelled from `environment()` for the cloud), each linked to the
  hub and to every listed spoke — `private-dns-zone.bicep`
- Activity log of the subscription to `foundation`'s workspace — `subscription-diagnostic-setting.bicep`
- Diagnostics of the virtual network and of each network security group to the same workspace — `diagnostic-setting.bicep`
- Three policy assignments of built-in definitions — allowed locations (the deployment region), a required tag on resources, and no public
  IP address on a network interface — `policy-assignment.bicep`
- Budget with alerts at 50, 80, and 100 percent, sent to the subscription `Owner` role — `budget.bicep`

## Configuration

- `short_name`: `disco`; `environment_kind`: `subscription`; `deployment_target`: `Subscription` (`az deployment sub create`).
- One config per subscription, keyed by the per-subscription environment (`nsub` non-production, `psub` production); no special slot.
- `configuration/<nsub|psub>.yml` at the configuration root are the two hubs; `configuration/<customer>/<nsub|psub>.yml` are the spokes of
  the `apex`, `nova`, and `flux` customers (non-production and, for apex, production) — the same coordinates as `foundation`.
- The kind, the address space, and the subnets are config addresses into `network.yml` (`global.network.subscriptions.<subscription>.kind`,
  `….vnet_address_space`, `….subnets`), so the network plan has one home and the config holds no range. The kind decides hub or spoke.
- A peered network is named by its subscription, resource group, and virtual network. Its subscription id comes from `azure.yml` through the
  `subscriptions` parameter, the address `global.azure.subscriptions`. Peering is static and two-sided: a spoke's config names its hub, and
  a hub's config lists its spokes.
- The policy enforcement mode is the config address `global.azure.policy_enforcement.production` in `psub.yml` and `….nonproduction` in
  `nsub.yml`, so the repository-wide setting in `azure.yml` decides whether the assignments enforce or only audit.
- The budget amount and its start date (the first of a month) are config values.
- No `PrePost.psm1`.

## Modules used

- `resource-group.bicep`, `virtual-network.bicep`, `nsg.bicep`, `route-table.bicep`, `vnet-peering.bicep`, `private-dns-zone.bicep`,
  `subscription-diagnostic-setting.bicep`, `diagnostic-setting.bicep`, `policy-assignment.bicep`, `budget.bicep` — see
  [modules](modules.md).

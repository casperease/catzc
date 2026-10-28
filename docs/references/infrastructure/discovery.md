# discovery

The CAF application landing zone of one subscription. `discovery` deploys the network, the guardrails, and the cost control a workload lands
in, and no workload of its own. It is deployed once per subscription, at subscription scope: a **hub** in each shared subscription and a
**spoke** in each customer subscription, peered to its hub. Management groups are out of its reach; the landing zone ends at the
subscription. It needs `foundation`'s Log Analytics workspace, so `foundation` deploys first (see [foundation](foundation.md)). The network
plan is [network-model](../../drs/azure/azure-network-model.md); the configuration tree and the config-addressed parameters are
[data-model](../../drs/azure/azure-data-model.md).

## Resources

- Resource group, with the CAF tags — `resource-group.bicep`
- Virtual network, with every subnet of the network plan declared inline — `virtual-network.bicep`
- Network security group per subnet named in the config, allowing the flows `network.yml` declares to the subnet's role and denying the rest
  of the virtual network and inbound traffic from the internet — `nsg.bicep`. The gateway and firewall subnets get none.
- Spoke only: a route table on every subnet, sending `0.0.0.0/0` to the hub's firewall — `route-table.bicep` — and the peering to the hub —
  `vnet-peering.bicep`
- Hub only: an Azure Firewall in `AzureFirewallSubnet` with its two public IP addresses and an egress policy that allows the service and
  FQDN tags of `firewall_egress` — `firewall.bicep`, `firewall-policy.bicep`; a route table on `shared-services` that sends each spoke's
  range to the firewall; `GatewaySubnet` stays empty
- Hub only: a peering to each spoke the config lists — `vnet-peering.bicep` — and the private DNS zones of SQL Database, Blob Storage and
  Key Vault (`privatelink.database.windows.net`, `privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net`, spelled from
  `environment()` for the cloud), each linked to the hub and to every listed spoke — `private-dns-zone.bicep`; a `CanNotDelete` lock on the
  hub's network and on each zone — `lock.bicep`
- Service Health and Resource Health alerts to `foundation`'s action group — `health-alert.bicep`
- The Defender for Cloud plans of `defenderPlans` — `defender-plans.bicep`
- Activity log of the subscription to `foundation`'s workspace — `subscription-diagnostic-setting.bicep`
- Diagnostics of the virtual network and of each network security group to the same workspace — `diagnostic-setting.bicep`
- Ten policy assignments — allowed locations (the deployment region), the CAF tags (the one custom definition), no public IP address on a
  network interface, public network access off for storage and SQL, a diagnostic setting on every data resource, the allowed storage SKUs,
  virtual machine sizes and resource types, and the Microsoft cloud security benchmark, audited only — `landing-zone-policies.bicep`,
  `policy-assignment.bicep`
- Budget with alerts at 50, 80, and 100 percent, sent to the subscription `Owner` role — `budget.bicep`
- A daily cost anomaly alert, emailed to its recipients for a year from the budget's start date — `scheduled-action.bicep`

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
- The policy enforcement mode is a fact the build derives (`options.yml` `facts: policyEnforcementMode: policy_enforcement`): a subscription
  that holds a production environment takes `policy_enforcement.production` of `azure.yml`, every other subscription `.nonproduction`, so no
  slot writes it and the repository-wide setting decides whether the assignments enforce or only audit.
- The budget amount and its start date (the first of a month) are config values.
- The anomaly alert's recipients are a required secure parameter, comma-separated, that every config supplies as a Key Vault reference to
  its subscription's `foundation` vault (secret `disco-anomaly-recipients`), seeded at deploy time, so no address is in config
  ([seed a secret](../../how-to/infrastructure/seed-a-secret.md)).
- No `PrePost.psm1`.

## Modules used

- `resource-group.bicep`, `virtual-network.bicep`, `nsg.bicep`, `route-table.bicep`, `vnet-peering.bicep`, `private-dns-zone.bicep`,
  `subscription-diagnostic-setting.bicep`, `diagnostic-setting.bicep`, `policy-assignment.bicep`, `budget.bicep`,
  `landing-zone-network.bicep`, `landing-zone-policies.bicep`, `landing-zone-monitoring.bicep`, `landing-zone-access.bicep` — see
  [modules](modules.md).

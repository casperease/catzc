# infrastructure/templates/discovery/main.bicep

The discovery template, the CAF application landing zone. It deploys once per subscription (envs `nsub` and `psub`) at subscription level: a
hub in each shared subscription and a spoke in each customer subscription.

## Where the network comes from

The kind, the address space and the subnets come from `network.yml` by config address, so the IP plan is read, never copied
([ADR-AZ-NETWORK-ONEIPPLAN](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-oneipplan)).

## What both kinds deploy

- One resource group with the virtual network, every subnet inline.
- A network security group per subnet named in `networkSecurityGroupNames`.
- The activity log and the network diagnostics, sent to foundation's Log Analytics workspace.
- Ten policy assignments, nine enforced and the cloud security benchmark audited only.
- A budget.

## What differs

- A spoke adds a route table and its peering to the hub.
- A hub adds its peerings to the spokes it lists and the private DNS zones, linked to the hub and to every spoke.

The reserved hub subnets (`GatewaySubnet`, `AzureFirewallSubnet`) get no network security group and nothing is deployed into them.

## Security rules

The inbound rules allow traffic inside the virtual networks and deny traffic from the internet. The Azure default rules (deny all other
inbound) apply beneath them.

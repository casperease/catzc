---
catzc:
  immutable:
    with_body_sha: "239f47e44093"
    path: docs/references/infrastructure/templates/discovery/main.bicep.md
    folder: docs/references/infrastructure/templates/discovery
    name: main-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AZ-NETWORK#1
---

# infrastructure/templates/discovery/main.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `targetScope = 'subscription'`, written with `//`.

```text
discovery — the CAF application landing zone. Deployed once per subscription (envs nsub/psub) at
subscription scope: a hub in each shared subscription, a spoke in each customer subscription. The
kind, the address space, and the subnets come from network.yml by config address, so the IP plan is
read, never copied ([ADR-AZ-NETWORK#1](/docs/adr/azure/azure-network-model.md#rule-adr-az-network1)).

Both kinds deploy one resource group with the virtual network (every subnet inline), a network security
group per subnet named in networkSecurityGroupNames, the activity log and the network diagnostics to
foundation's Log Analytics workspace, three policy assignments, and a budget. A spoke adds a route table
and its peering to the hub; a hub adds its peerings to the spokes it lists and the private DNS zones,
linked to the hub and to every spoke. The reserved hub subnets (GatewaySubnet, AzureFirewallSubnet) get no
network security group and nothing is deployed into them.
```

## comment:2

Above `var securityRules = [`, written with `//`.

```text
Inbound: allow traffic inside the virtual networks, deny traffic from the internet. The Azure default
rules (deny all other inbound) apply beneath them.
```

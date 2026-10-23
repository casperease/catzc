---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION
      - ADR-AZ-LZ-WORKLOADOWNSNONE
---

# A workload owns none of its landing zone and every subscription has one network

This article is one rule:
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription) and
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../drs/azure/landing-zones.md#rule-adr-az-lz-workloadownsnone) merged into one. It holds nothing beyond what
those two rules say.

A workload lands in its landing zone and owns none of it: `expedition` places its private endpoints in the `private-endpoints` subnet of its
customer's spoke, the shared platform's in the hub's `shared-services` subnet, and creates no network, peering, DNS zone or policy. Every
`azure.yml` subscription has one network, a hub when it has no `customer` and a spoke when it has one.

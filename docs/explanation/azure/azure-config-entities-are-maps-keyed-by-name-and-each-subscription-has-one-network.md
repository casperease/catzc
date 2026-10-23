---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
      - ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION
---

# Azure config entities are maps keyed by name and each subscription has one network

This article is one rule: [ADR-AZ-DATAMOD-NAMEKEYEDMAPS](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-namekeyedmaps) and
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription) merged into one.
It holds nothing beyond what those two rules say.

All named entities in `azure.yml` are maps keyed by name, so duplicate names are structurally impossible, and every config's coordinate must
resolve to exactly one subscription id. Each subscription then has exactly one network in the plan's `subscriptions` block, keyed by the
subscription name, a hub when it has no `customer` and a spoke when it has one.

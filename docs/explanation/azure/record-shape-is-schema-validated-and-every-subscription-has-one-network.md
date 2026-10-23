---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY
      - ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION
---

# Record shape is schema validated and every subscription has one network

This article is one rule: [ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)
and [ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription) merged into
one. It holds nothing beyond what those two rules say.

Per-record shape is schema-validated and cross-record integrity is owned by the `AzureConfig` config type, including per-customer
environment disjointness: no two subscriptions of one customer serve the same env. Every `azure.yml` subscription has one network in the
plan's `subscriptions` block, a hub when it has no `customer` and a spoke when it has one.

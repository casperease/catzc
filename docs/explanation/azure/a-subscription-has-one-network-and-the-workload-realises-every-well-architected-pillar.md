---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION
      - ADR-AZ-LZ-EVERYPILLAR
---

# A subscription has one network and the workload realises every well architected pillar

This article is one rule:
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription) and
[ADR-AZ-LZ-EVERYPILLAR](../../drs/azure/landing-zones.md#rule-adr-az-lz-everypillar) merged into one. It holds nothing beyond what those two
rules say.

Every `azure.yml` subscription has one network in the plan's `subscriptions` block, a hub when it has no `customer` and a spoke when it has
one. The workload realises every pillar of the Azure Well-Architected Framework, each as a module default or a config value: reliability as
zone-redundant storage, and in production a zone-redundant database with geo-redundant backups, and security as no public network access,
private endpoints only and TLS 1.2 minimum.

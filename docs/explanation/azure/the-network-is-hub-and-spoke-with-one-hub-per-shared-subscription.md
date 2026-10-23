---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETTOP-HUBSPOKEASNETWORKDESIGN
      - ADR-AZ-LZ-HUBANDSPOKE
---

# The network is hub and spoke with one hub per shared subscription

This article is one rule:
[ADR-AZ-CAF-NETTOP-HUBSPOKEASNETWORKDESIGN](../../drs/azure/caf/network-topology.md#rule-adr-az-caf-nettop-hubspokeasnetworkdesign) and
[ADR-AZ-LZ-HUBANDSPOKE](../../drs/azure/landing-zones.md#rule-adr-az-lz-hubandspoke) merged into one. It holds nothing beyond what those two
rules say.

The network is hub-and-spoke: one hub per shared subscription and one spoke per customer subscription, peered to the hub of its tier.
Peering is static and two-sided, a spoke's config naming its hub and a hub's config listing its spokes.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION
      - ADR-AZ-CAF-NETTOP-MINIMALSETSHAREDSERVICESHUB
---

# A hub carries two reserved subnets and shared services and a spoke follows its customer

This article is one rule:
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription) and
[ADR-AZ-CAF-NETTOP-MINIMALSETSHAREDSERVICESHUB](../../drs/azure/caf/network-topology.md#rule-adr-az-caf-nettop-minimalsetsharedserviceshub)
merged into one. It holds nothing beyond what those two rules say.

Every `azure.yml` subscription has one network, and its kind follows from the subscription: a hub when it has no `customer`, a spoke when it
has one. A hub carries exactly `GatewaySubnet` and `AzureFirewallSubnet`, reserved, and `shared-services`. The minimal set is only partly
adopted: the hub carries the two reserved subnets, `shared-services` and the private DNS zones, and the shared platform's own workload also
lands in `shared-services`.

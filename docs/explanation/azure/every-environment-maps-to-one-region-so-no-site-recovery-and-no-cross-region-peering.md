---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-MGMT-REPLICATEVIRTUALMACHINESSITERECOVERY
      - ADR-AZ-CAF-NETTOP-GLOBALPEERINGFEWCROSSREGIONSPOKES
---

# Every environment maps to one region so no site recovery and no cross region peering

This article is one rule:
[ADR-AZ-CAF-MGMT-REPLICATEVIRTUALMACHINESSITERECOVERY](../../drs/azure/caf/management.md#rule-adr-az-caf-mgmt-replicatevirtualmachinessiterecovery)
and
[ADR-AZ-CAF-NETTOP-GLOBALPEERINGFEWCROSSREGIONSPOKES](../../drs/azure/caf/network-topology.md#rule-adr-az-caf-nettop-globalpeeringfewcrossregionspokes)
merged into one. It holds nothing beyond what those two rules say.

Replicating virtual machines for site recovery is not adopted, because no template deploys a virtual machine and every environment maps to
one region. Global peering for few cross-region spokes is not adopted either: every environment deploys to one region, so no spoke needs a
cross-region link.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETPRV-PRIVATEDNSZONESAZUREONLYRESOLUTION
      - ADR-AZ-CAF-MGMT-REPLICATEVIRTUALMACHINESSITERECOVERY
---

# Name resolution is azure only and no virtual machine is replicated for site recovery

This article is one rule:
[ADR-AZ-CAF-NETPRV-PRIVATEDNSZONESAZUREONLYRESOLUTION](../../drs/azure/caf/network-private-access.md#rule-adr-az-caf-netprv-privatednszonesazureonlyresolution)
and
[ADR-AZ-CAF-MGMT-REPLICATEVIRTUALMACHINESSITERECOVERY](../../drs/azure/caf/management.md#rule-adr-az-caf-mgmt-replicatevirtualmachinessiterecovery)
merged into one. It holds nothing beyond what those two rules say.

Name resolution is Azure-only, through Azure-provided DNS and the hub's `privatelink` zones; a custom DNS zone with automatic registration
is not adopted, because no template deploys a virtual machine. Replicating virtual machines for site recovery is not adopted for the same
reason, and because every environment maps to one region.

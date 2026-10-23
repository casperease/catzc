---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETCON-PROTECTINBOUNDWEBTRAFFICINSIDELANDINGZONENETWORK
      - ADR-AZ-CAF-NETPRV-SERVICEENDPOINTSWHEREPRIVATELINKISNOTNEEDED
---

# Every data service takes a private endpoint and no workload takes inbound web traffic

This article is one rule:
[ADR-AZ-CAF-NETCON-PROTECTINBOUNDWEBTRAFFICINSIDELANDINGZONENETWORK](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-protectinboundwebtrafficinsidelandingzonenetwork)
and
[ADR-AZ-CAF-NETPRV-SERVICEENDPOINTSWHEREPRIVATELINKISNOTNEEDED](../../drs/azure/caf/network-private-access.md#rule-adr-az-caf-netprv-serviceendpointswhereprivatelinkisnotneeded)
merged into one. It holds nothing beyond what those two rules say.

Two protections are not adopted. Protecting inbound web traffic inside the landing-zone network is not adopted, because no workload takes
inbound web traffic. Virtual network service endpoints are not adopted, because every data service takes a private endpoint, which keeps one
way of reaching data for every workload. The result is a network with no inbound web path and a single way to reach data.

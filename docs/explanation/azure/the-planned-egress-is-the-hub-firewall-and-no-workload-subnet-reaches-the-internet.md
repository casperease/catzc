---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETCON-USENATGATEWAYDIRECTOUTBOUNDTRAFFIC
      - ADR-AZ-WAF-SE-SE06
---

# The planned egress is the hub firewall and no workload subnet reaches the internet

This article is one rule:
[ADR-AZ-CAF-NETCON-USENATGATEWAYDIRECTOUTBOUNDTRAFFIC](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-usenatgatewaydirectoutboundtraffic)
and [ADR-AZ-WAF-SE-SE06](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se06) merged into one. It holds nothing beyond what those two
rules say.

A NAT gateway for direct outbound traffic is not adopted, because the planned egress path of every spoke is the hub firewall and no workload
subnet hosts compute that reaches the internet. Inbound is closed too: data services have public network access off, inbound internet
traffic is denied at every workload subnet and no network interface takes a public IP address; egress through a firewall and flow logs are
planned.

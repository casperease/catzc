---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-SEC-WORKLOADNETWORKINGPLANNEDZEROTRUST
      - ADR-AZ-WAF-SE-SE06
---

# Workload networking is private by plan and data services take only private endpoints

This article is one rule:
[ADR-AZ-CAF-SEC-WORKLOADNETWORKINGPLANNEDZEROTRUST](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-workloadnetworkingplannedzerotrust)
and [ADR-AZ-WAF-SE-SE06](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se06) merged into one. It holds nothing beyond what those two
rules say.

Workload networking is private by plan: `network.yml`, a network security group per workload subnet and private endpoints, with egress
filtering through a hub firewall planned. Data services have public network access off and are reached only through private endpoints
resolved by the hub's private DNS zones, inbound internet traffic is denied at every workload subnet and no network interface takes a public
IP address.

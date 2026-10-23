---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-SE-SE06
      - ADR-AZ-CAF-NETPRV-VIRTUALNETWORKINJECTIONPAASSERVICES
---

# Data services take private endpoints and no service is injected into a subnet

This article is one rule: [ADR-AZ-WAF-SE-SE06](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se06) and
[ADR-AZ-CAF-NETPRV-VIRTUALNETWORKINJECTIONPAASSERVICES](../../drs/azure/caf/network-private-access.md#rule-adr-az-caf-netprv-virtualnetworkinjectionpaasservices)
merged into one. It holds nothing beyond what those two rules say.

Data services have public network access off and are reached only through private endpoints resolved by the hub's private DNS zones, inbound
internet traffic is denied at every workload subnet and no network interface takes a public IP address. Virtual network injection is not
adopted, because no template deploys a service that is injected into a subnet; the data services are reached through private endpoints
instead.

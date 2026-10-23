---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS
      - ADR-AZ-WAF-SE-SE06
---

# Private link is the only way to reach a data service and public access off (ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS + ADR-AZ-WAF-SE-SE06)

This article is one rule:
[ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS](../../drs/azure/caf/network-private-access.md#rule-adr-az-caf-netprv-privatelinkprivateonlyaccess)
and [ADR-AZ-WAF-SE-SE06](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se06) merged into one. It holds nothing beyond what those two
rules say.

Every data service is reached through Private Link: storage and SQL have public network access off and a private endpoint registered in the
hub's private DNS zones, and the vault's private endpoint is planned. Data services are reached only through those private endpoints,
inbound internet traffic is denied at every workload subnet, and no network interface takes a public IP address; egress through a firewall
and flow logs are planned.

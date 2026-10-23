---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS
      - ADR-AZ-CAF-SEC-VAULTFIREWALLNETWORKRESTRICTION
---

# A vaults network access is planned closed and data services use private link

This article is one rule:
[ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS](../../drs/azure/caf/network-private-access.md#rule-adr-az-caf-netprv-privatelinkprivateonlyaccess)
and
[ADR-AZ-CAF-SEC-VAULTFIREWALLNETWORKRESTRICTION](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-vaultfirewallnetworkrestriction)
merged into one. It holds nothing beyond what those two rules say.

Every data service is reached through Private Link: storage and SQL have public network access off and a private endpoint registered in the
hub's private DNS zones. A vault's network access is planned to be closed in the same way: public network access off and a private endpoint
in the hub's private DNS, in place of the service endpoints CAF names.

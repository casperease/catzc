---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS
      - ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS
---

# Every data service is reached through private link under zero trust platform access

This article is one rule:
[ADR-AZ-CAF-NETPRV-PRIVATELINKPRIVATEONLYACCESS](../../drs/azure/caf/network-private-access.md#rule-adr-az-caf-netprv-privatelinkprivateonlyaccess)
and [ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-zerotrustplatformaccess)
merged into one. It holds nothing beyond what those two rules say.

Every data service is reached through Private Link: storage and SQL have public network access off and a private endpoint registered in the
hub's private DNS zones, and the vault's private endpoint is planned. Access to the platform follows Zero Trust through Entra ID identities,
a service connection per subscription pinned on every deploy, and private endpoints for data; `foundation`'s vault and workspace accept
public traffic until that closes it.

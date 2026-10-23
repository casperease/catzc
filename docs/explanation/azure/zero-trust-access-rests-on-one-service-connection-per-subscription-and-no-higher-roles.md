---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-RESORG-NOWORKLOADTEAMROLESATMANAGEMENTGROUPLEVEL
      - ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS
---

# Zero trust access rests on one service connection per subscription and no higher roles (ADR-AZ-CAF-RESORG-NOWORKLOADTEAMROLESATMANAGEMENTGROUPLEVEL + ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS)

This article is one rule:
[ADR-AZ-CAF-RESORG-NOWORKLOADTEAMROLESATMANAGEMENTGROUPLEVEL](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-noworkloadteamrolesatmanagementgrouplevel)
and [ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-zerotrustplatformaccess)
merged into one. It holds nothing beyond what those two rules say.

Access to the platform follows Zero Trust through Entra ID identities, a service connection per subscription pinned on every deploy, and
private endpoints for data; `foundation`'s vault and workspace accept public traffic until ADR-AZ-WAF-SE-SE06 closes it. The repository
grants no role above a subscription, each subscription is deployed by its own service connection pinned with `-SubscriptionIdAssertIs`, and
the templates make no role assignment for workload teams.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-SE-SE11
      - ADR-AZ-CAF-RESORG-NOWORKLOADTEAMROLESATMANAGEMENTGROUPLEVEL
---

# Security checks run at build time and no role above a subscription is ever granted

This article is one rule: [ADR-AZ-WAF-SE-SE11](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se11) and
[ADR-AZ-CAF-RESORG-NOWORKLOADTEAMROLESATMANAGEMENTGROUPLEVEL](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-noworkloadteamrolesatmanagementgrouplevel)
merged into one. It holds nothing beyond what those two rules say.

The repository's checks run at build time on the templates and configs; security tests of a deployed workload are planned. Access follows
the same restraint: the repository grants no role above a subscription, each subscription is deployed by its own service connection pinned
with `-SubscriptionIdAssertIs`, and the templates make no role assignment for workload teams.

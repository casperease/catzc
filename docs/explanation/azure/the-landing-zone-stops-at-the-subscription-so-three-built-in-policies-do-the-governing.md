---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-RESORG-KEEPMANAGEMENTGROUPHIERARCHYFLAT
      - ADR-AZ-CAF-PRIN-POLICYDRIVENGOVERNANCE
---

# The landing zone stops at the subscription so three built in policies do the governing

This article is one rule:
[ADR-AZ-CAF-RESORG-KEEPMANAGEMENTGROUPHIERARCHYFLAT](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-keepmanagementgrouphierarchyflat)
and [ADR-AZ-CAF-PRIN-POLICYDRIVENGOVERNANCE](../../drs/azure/caf/design-principles.md#rule-adr-az-caf-prin-policydrivengovernance) merged
into one. It holds nothing beyond what those two rules say.

The repository has no management group hierarchy to keep flat, because its landing zone stops at the subscription. Governance is therefore
partly adopted at that scope: every landing zone assigns three built-in Azure Policy guardrails at subscription scope, enforced or audited
by the repository-wide `policy_enforcement` setting.

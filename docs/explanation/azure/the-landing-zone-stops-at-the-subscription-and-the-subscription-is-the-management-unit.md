---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-RESORG-KEEPMANAGEMENTGROUPHIERARCHYFLAT
      - ADR-AZ-CAF-PRIN-SUBSCRIPTIONDEMOCRATIZATION
---

# The landing zone stops at the subscription and the subscription is the management unit (ADR-AZ-CAF-RESORG-KEEPMANAGEMENTGROUPHIERARCHYFLAT + ADR-AZ-CAF-PRIN-SUBSCRIPTIONDEMOCRATIZATION)

This article is one rule:
[ADR-AZ-CAF-RESORG-KEEPMANAGEMENTGROUPHIERARCHYFLAT](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-keepmanagementgrouphierarchyflat)
and [ADR-AZ-CAF-PRIN-SUBSCRIPTIONDEMOCRATIZATION](../../drs/azure/caf/design-principles.md#rule-adr-az-caf-prin-subscriptiondemocratization)
merged into one. It holds nothing beyond what those two rules say.

The repository has no management group hierarchy to keep flat, because its landing zone stops at the subscription. The subscription is the
unit of management: each customer holds its own non-production and production subscription pair declared in `azure.yml`, and a new
subscription's landing zone is a config file reviewed as a pull request. Subscription vending and a management group hierarchy are not
adopted.

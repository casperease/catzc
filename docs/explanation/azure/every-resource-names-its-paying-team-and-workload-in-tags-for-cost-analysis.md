---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS
      - ADR-AZ-CAF-BILL-ANALYSECOSTBYTAGLOCATION
---

# Every resource names its paying team and workload in tags for cost analysis (ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS + ADR-AZ-CAF-BILL-ANALYSECOSTBYTAGLOCATION)

This article is one rule:
[ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-tagresourcescostanalysis) and
[ADR-AZ-CAF-BILL-ANALYSECOSTBYTAGLOCATION](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-analysecostbytaglocation) merged
into one. It holds nothing beyond what those two rules say.

Cost is analysed by tag and location. Every resource names its paying team in `cost-center` and its workload in `workload`, and every
resource carries the CAF tags and lands in its environment's one region, so Cost Management can slice spend by tag and location. Both are
partly realised: the resource groups that `Deploy-Bicep` creates for `foundation` and `expedition` carry no CAF tags, which is planned.

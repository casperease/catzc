---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS
      - ADR-AZ-CAF-RESORG-NAVIGATEACROSSHIERARCHYBYTAGS
---

# Every resource carries cost tags and the six caf tags aid navigation

This article is one rule:
[ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-tagresourcescostanalysis) and
[ADR-AZ-CAF-RESORG-NAVIGATEACROSSHIERARCHYBYTAGS](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-navigateacrosshierarchybytags)
merged into one. It holds nothing beyond what those two rules say.

Every resource names its paying team in `cost-center` and its workload in `workload`, and carries the six CAF tags, with the landing zone
requiring `cost-center`. Both are partly realised: the resource groups that `Deploy-Bicep` creates for `foundation` and `expedition` carry
deployment-tracking tags but not the CAF tags, which is planned.

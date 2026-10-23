---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NAME-ENFORCETAGSAZUREPOLICY
      - ADR-AZ-CAF-PRIN-POLICYDRIVENGOVERNANCE
---

# One built in policy requires the cost center tag and three guardrails are assigned

This article is one rule:
[ADR-AZ-CAF-NAME-ENFORCETAGSAZUREPOLICY](../../drs/azure/caf/naming-and-tagging.md#rule-adr-az-caf-name-enforcetagsazurepolicy) and
[ADR-AZ-CAF-PRIN-POLICYDRIVENGOVERNANCE](../../drs/azure/caf/design-principles.md#rule-adr-az-caf-prin-policydrivengovernance) merged into
one. It holds nothing beyond what those two rules say.

One built-in policy per landing zone requires the `cost-center` tag; requiring the other keys and checking their values is planned, and
resource selectors are not adopted, because each landing zone has one region. That policy is one of the three built-in Azure Policy
guardrails every landing zone assigns at subscription scope, enforced or audited by the repository-wide `policy_enforcement` setting.

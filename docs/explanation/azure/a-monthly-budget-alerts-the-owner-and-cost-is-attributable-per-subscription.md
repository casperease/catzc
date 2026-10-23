---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-GOV-OVERSEESPENDCOSTMANAGEMENT
      - ADR-AZ-WAF-CO-CO03
---

# A monthly budget alerts the owner and cost is attributable per subscription

This article is one rule:
[ADR-AZ-CAF-GOV-OVERSEESPENDCOSTMANAGEMENT](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-overseespendcostmanagement) and
[ADR-AZ-WAF-CO-CO03](../../drs/azure/waf/cost-optimization.md#rule-adr-az-waf-co-co03) merged into one. It holds nothing beyond what those
two rules say.

Cost is attributable and watched per subscription: every resource carries the CAF tags with `cost-center` and `owner`, and every landing
zone deploys a monthly budget whose alerts reach the subscription's `Owner` role at 50, 80 and 100 percent of actual cost. Cost exports,
forecast alerts and anomaly alerts are planned.

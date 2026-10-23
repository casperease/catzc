---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-CO-CO04
      - ADR-AZ-LZ-THREEBUILTINPOLICIES
---

# Spending guardrails are landing zone controls built on three policies

This article is one rule: [ADR-AZ-WAF-CO-CO04](../../drs/azure/waf/cost-optimization.md#rule-adr-az-waf-co-co04) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../drs/azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) merged into one. It holds nothing
beyond what those two rules say.

Spending guardrails are platform controls in the landing zone: the allowed-locations and required-tag policies, a budget per subscription,
`@allowed` and bound decorators on the SKU tier, size and retention parameters, and a `--what-if` preview before a deploy; an allowed-SKU
policy and a pre-deploy cost estimate are planned. Two of those policies are among the three built-in policies every landing zone assigns.

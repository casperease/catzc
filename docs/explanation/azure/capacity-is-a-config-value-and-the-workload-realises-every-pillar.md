---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-PE-PE02
      - ADR-AZ-LZ-EVERYPILLAR
---

# Capacity is a config value and the workload realises every pillar

This article is one rule: [ADR-AZ-WAF-PE-PE02](../../drs/azure/waf/performance-efficiency.md#rule-adr-az-waf-pe-pe02) and
[ADR-AZ-LZ-EVERYPILLAR](../../drs/azure/landing-zones.md#rule-adr-az-lz-everypillar) merged into one. It holds nothing beyond what those two
rules say.

Capacity is a config value per environment class: the database SKU, vCore count and serverless floor in each `expedition` config, the budget
per subscription in each `discovery` config, with no demand forecast or service-limit check behind it. The workload realises every pillar of
the Azure Well-Architected Framework, each as a module default or a config value.

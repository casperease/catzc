---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-RE-RE06
      - ADR-AZ-WAF-PE-PE05
---

# The templates deploy no compute and the database scales inside a serverless range

This article is one rule: [ADR-AZ-WAF-RE-RE06](../../drs/azure/waf/reliability.md#rule-adr-az-waf-re-re06) and
[ADR-AZ-WAF-PE-PE05](../../drs/azure/waf/performance-efficiency.md#rule-adr-az-waf-pe-pe05) merged into one. It holds nothing beyond what
those two rules say.

The templates deploy no compute to scale. Outside production the database scales itself between a serverless floor and ceiling from the
config, capped by `databaseSkuCapacity`, and pauses when idle; in production it is provisioned at a fixed capacity and scales by a config
change and a deploy. The unit of scale-out is a configuration slot, a whole deployment of the workload in its own resource group, with no
autoscale rule and no data partitioning.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-PE-PE05
      - ADR-AZ-LZ-EVERYPILLAR
---

# The workload realises every well architected pillar and the database scales by config (ADR-AZ-WAF-PE-PE05 + ADR-AZ-LZ-EVERYPILLAR)

This article is one rule: [ADR-AZ-WAF-PE-PE05](../../drs/azure/waf/performance-efficiency.md#rule-adr-az-waf-pe-pe05) and
[ADR-AZ-LZ-EVERYPILLAR](../../drs/azure/landing-zones.md#rule-adr-az-lz-everypillar) merged into one. It holds nothing beyond what those two
rules say.

The workload realises every pillar of the Azure Well-Architected Framework, each as a module default or a config value; reliability, for
instance, is zone-redundant storage and, in production, a zone-redundant database with geo-redundant backups. Performance follows the same
route: outside production the database scales itself between a serverless floor and ceiling from the config and pauses when idle, and in
production it is provisioned at a fixed capacity.

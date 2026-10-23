---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-LZ-EVERYPILLAR
      - ADR-AZ-WAF-RE-RE05
---

# Redundancy stays inside one region and the workload realises every pillar

This article is one rule: [ADR-AZ-LZ-EVERYPILLAR](../../drs/azure/landing-zones.md#rule-adr-az-lz-everypillar) and
[ADR-AZ-WAF-RE-RE05](../../drs/azure/waf/reliability.md#rule-adr-az-waf-re-re05) merged into one. It holds nothing beyond what those two
rules say.

The workload realises every pillar of the Azure Well-Architected Framework, each as a module default or a config value; reliability is
zone-redundant storage and, in production, a zone-redundant database with geo-redundant backups. Redundancy stays inside one region: storage
is zone-redundant in every environment, and a second region is not adopted.

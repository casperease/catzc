---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-PE-PE04
      - ADR-AZ-LZ-THREEBUILTINPOLICIES
---

# Three built in policies guard each landing zone and logs never mix across environments

This article is one rule: [ADR-AZ-WAF-PE-PE04](../../drs/azure/waf/performance-efficiency.md#rule-adr-az-waf-pe-pe04) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../drs/azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) merged into one. It holds nothing
beyond what those two rules say.

Every landing zone assigns three built-in policies: allowed locations (its region), a required tag on resources, and no public IP address on
a network interface, enforcing or only auditing by the repository-wide `policy_enforcement` setting. The workload's data services and the
landing zone's network send their logs and metrics through a diagnostic setting to `foundation`'s workspace of the same subscription, so
production and non-production signals never mix; baselines, alerts and dashboards are not part of the templates.

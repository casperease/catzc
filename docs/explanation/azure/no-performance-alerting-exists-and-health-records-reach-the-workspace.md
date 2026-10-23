---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-PE-PE11
      - ADR-AZ-WAF-RE-RE10
---

# No performance alerting exists and health records reach the workspace

This article is one rule: [ADR-AZ-WAF-PE-PE11](../../drs/azure/waf/performance-efficiency.md#rule-adr-az-waf-pe-pe11) and
[ADR-AZ-WAF-RE-RE10](../../drs/azure/waf/reliability.md#rule-adr-az-waf-re-re10) merged into one. It holds nothing beyond what those two
rules say.

No performance alert, triage plan or on-call rota exists, because there is no baseline to deviate from. The activity log's service-health
and resource-health records reach the workspace through the landing zone: the landing zone and the workload send their diagnostics to
`foundation`'s Log Analytics workspace, and alerts on those signals and a health model are planned.

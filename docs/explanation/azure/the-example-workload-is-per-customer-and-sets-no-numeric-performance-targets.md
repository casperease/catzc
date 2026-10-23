---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-BILL-READMULTITENANTSOLUTIONGUIDANCE
      - ADR-AZ-WAF-PE-PE01
---

# The example workload is per customer and sets no numeric performance targets (ADR-AZ-CAF-BILL-READMULTITENANTSOLUTIONGUIDANCE + ADR-AZ-WAF-PE-PE01)

This article is one rule:
[ADR-AZ-CAF-BILL-READMULTITENANTSOLUTIONGUIDANCE](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-readmultitenantsolutionguidance)
and [ADR-AZ-WAF-PE-PE01](../../drs/azure/waf/performance-efficiency.md#rule-adr-az-waf-pe-pe01) merged into one. It holds nothing beyond
what those two rules say.

Two usual practices are not adopted for the examples. Multitenant solution guidance is not adopted, because the example workload is deployed
per customer subscription, not built as a multitenant application. Numeric performance targets are not set, because the templates deploy no
application with users or flows to measure; a workload built on them sets its own targets before it is deployed.

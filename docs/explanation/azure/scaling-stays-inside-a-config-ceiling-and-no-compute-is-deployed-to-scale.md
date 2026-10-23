<div style="background:#c00;color:#fff;padding:6px 10px"><b>Experimental</b> &nbsp; Scaling stays inside a config ceiling and no compute is deployed to scale (ADR-AZ-WAF-RE-RE06 + ADR-AZ-WAF-CO-CO12)</div>

> **Experimental.** This article is one rule: [ADR-AZ-WAF-RE-RE06](../../drs/azure/waf/reliability.md#rule-adr-az-waf-re-re06) and [ADR-AZ-WAF-CO-CO12](../../drs/azure/waf/cost-optimization.md#rule-adr-az-waf-co-co12) merged into one. It holds nothing beyond what those two rules say.

The templates deploy no compute to scale. A component that scales does so within a ceiling set in config: the serverless database moves between `databaseMinCapacity` and `databaseSkuCapacity` vCores, and no other component of the examples scales. A non-production database scales itself inside that serverless range, while a production database scales by a config change and a deploy.

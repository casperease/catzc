---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-OE-OE06
      - ADR-AZ-CAF-DEVOPS-TESTDEPLOYTHROUGHPIPELINES
---

# Every infrastructure change travels one supply chain and production is reached by promotion

This article is one rule: [ADR-AZ-WAF-OE-OE06](../../drs/azure/waf/operational-excellence.md#rule-adr-az-waf-oe-oe06) and
[ADR-AZ-CAF-DEVOPS-TESTDEPLOYTHROUGHPIPELINES](../../drs/azure/caf/platform-automation-and-devops.md#rule-adr-az-caf-devops-testdeploythroughpipelines)
merged into one. It holds nothing beyond what those two rules say.

Every infrastructure change travels one supply chain: a CD pipeline triggered by its deployable-unit's globset builds the artifacts once and
deploys the same bytes, in dependency order, into subscriptions it asserts. Production is meant to be reached by promotion, not by the same
stage that deploys non-production; this is partly realised, since a CI pipeline builds and tests every template and globset-triggered CD
pipelines deploy them in order, but production deploys in the same stage as non-production.

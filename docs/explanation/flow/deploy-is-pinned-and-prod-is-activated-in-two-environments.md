---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-TYPE-DEPLOYISPINNED
      - FDR-CD-TWOENVIRONMENTACTIVATION
---

# Deploy is pinned and prod is activated in two environments

This article is one rule: [FDR-CD-TYPE-DEPLOYISPINNED](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-deployispinned) and
[FDR-CD-TWOENVIRONMENTACTIVATION](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-twoenvironmentactivation) merged into one.
It holds nothing beyond what those two rules say.

DEPLOY is pinned and deterministic: it deploys the artifact of one chosen commit, so the same commit deploys the same bytes on every run,
and it never deploys from a floating `latest` and never renders config at deploy time. Deploy-to-prod is a two-environment activation: stage
the artifact inactive in pre-prod, validate the exact bytes, then activate it live to production; DEPLOY-Prod never deploys straight into
the serving environment.

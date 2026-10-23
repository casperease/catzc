---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-SEPARATEPIPELINEKINDS
      - FDR-CD-TYPE-CDEAUTOMATESPRODROLL
---

# Pipeline kinds are separate and cde automates the roll to production

This article is one rule:
[FDR-CD-SEPARATEPIPELINEKINDS](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-separatepipelinekinds) and
[FDR-CD-TYPE-CDEAUTOMATESPRODROLL](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-cdeautomatesprodroll) merged into one. It holds nothing
beyond what those two rules say.

CI, CD, CDe and DEPLOY are separate pipeline kinds keyed together by the tagged artifact, each its own ADO pipeline with its own trigger,
governance and history. CDe is the kind that internalizes and automates the roll to production: it runs the same CI engine and the same
deploy-and-verify path as CD, builds nothing new, and drives the tagged, commit-pinned artifact all the way to prod.

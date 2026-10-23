---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-CDCONTAINSCI
      - FDR-CD-TYPE-CDEAUTOMATESPRODROLL
---

# A cd pipeline contains the ci component and cde automates the roll to production

This article is one rule: [FDR-CD-CDCONTAINSCI](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdcontainsci) and
[FDR-CD-TYPE-CDEAUTOMATESPRODROLL](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-cdeautomatesprodroll) merged into one. It holds nothing
beyond what those two rules say.

A CD pipeline always contains a CI component, and a solo CI pipeline contains only it: the CI component is the same build-and-verify in
both, one CI engine. CDe is a CD that internalizes and automates the roll to production: it runs the same CI engine and the same
deploy-and-verify path as CD, builds nothing new, and drives the CI engine's tagged, commit-pinned artifact all the way to prod.

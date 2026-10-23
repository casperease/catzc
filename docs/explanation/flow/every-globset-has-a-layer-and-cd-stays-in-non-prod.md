---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-GLOBS-EVERYSETHASLAYER
      - FDR-CD-CDSTAYSINNONPROD
---

# Every globset has a layer and cd stays in non prod

This article is one rule: [FDR-CD-GLOBS-EVERYSETHASLAYER](../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-everysethaslayer) and
[FDR-CD-CDSTAYSINNONPROD](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdstaysinnonprod) merged into one. It holds nothing
beyond what those two rules say.

Every globset carries a layer, the kind of thing it maps: `deployable-unit`, a configurable unit that ships, and `loose-fileset`, a
cross-cutting check surface. CD takes the tagged artifact in a direction entirely within non-prod: after its CI component a CD pipeline
deploys the artifact to an on-demand environment and runs L3 system-level end-to-end tests there, then rolls the same artifact on.

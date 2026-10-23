---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-CDEINTERNALIZESPROMOTION
      - FDR-CD-TYPE-CDEINTERNALGATES
---

# Cde internalizes the prod promotion and its internal gates are checkpoints

This article is one rule:
[FDR-CD-CDEINTERNALIZESPROMOTION](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdeinternalizespromotion) and
[FDR-CD-TYPE-CDEINTERNALGATES](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-cdeinternalgates) merged into one. It holds nothing beyond
what those two rules say.

CDe is a CD that internalizes the prod promotion: it runs the same CI component and the same non-prod direction, then automatically rolls
the locked commit's tagged artifact the rest of the way to production. It may contain internal manual gates, such as an approval before the
production stage, but they are checkpoints inside an automated promotion and do not make it a DEPLOY: what separates CDe from CD followed by
DEPLOY is that the roll-to-prod activity is automatically determined, not human-initiated.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-CDEINTERNALIZESPROMOTION
      - FDR-CD-TYPE-CDESHARESDEPLOYPATH
---

# Cde internalizes the prod promotion and shares the one deploy path

This article is one rule:
[FDR-CD-CDEINTERNALIZESPROMOTION](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdeinternalizespromotion) and
[FDR-CD-TYPE-CDESHARESDEPLOYPATH](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-cdesharesdeploypath) merged into one. It holds nothing
beyond what those two rules say.

CDe is a CD that internalizes the prod promotion: it runs the same CI component and the same non-prod direction, then automatically rolls
the locked commit's tagged artifact the rest of the way to production. It shares the one deploy-and-verify path with CD and DEPLOY, never a
second deploy implementation, and a deployable unit's production promotion is governed as either CD then DEPLOY or CDe, never both.

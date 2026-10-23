---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-TYPE-CDESHARESDEPLOYPATH
      - FDR-CD-TWORELEASEGATES
---

# Cde shares the one deploy path and rc and rbc are two hands on gates

This article is one rule: [FDR-CD-TYPE-CDESHARESDEPLOYPATH](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-cdesharesdeploypath) and
[FDR-CD-TWORELEASEGATES](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates) merged into one. It holds nothing
beyond what those two rules say.

CDe shares the one deploy-and-verify path with CD and DEPLOY, never a second deploy implementation, and a deployable unit's production
promotion is governed as either CD then DEPLOY or CDe, never both. For the human-governed route, RC and RBC are the two hands-on release
gates, each a gate and not a pipeline: RC at main-UAT and RBC at release-uat.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-PRODPROGRESSIONISDEPLOY
      - FDR-CD-TYPE-CDESHARESDEPLOYPATH
---

# Progression toward prod enters deploy and cde shares its deploy path

This article is one rule:
[FDR-CD-PRODPROGRESSIONISDEPLOY](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-prodprogressionisdeploy) and
[FDR-CD-TYPE-CDESHARESDEPLOYPATH](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-cdesharesdeploypath) merged into one. It holds nothing
beyond what those two rules say.

Progression toward prod leaves the automated flow and enters DEPLOY: from non-prod, the same tagged artifact is promoted toward production
via DEPLOY activities, a solo, manually-governed pipeline that drives the artifact into a non-automated environment behind a manual gate.
CDe shares the one deploy-and-verify path with CD and DEPLOY, and a unit's production promotion is governed as either CD then DEPLOY or CDe,
never both.

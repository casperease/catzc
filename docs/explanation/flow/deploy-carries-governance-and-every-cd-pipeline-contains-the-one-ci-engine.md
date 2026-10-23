---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE
      - FDR-CD-CDCONTAINSCI
---

# Deploy carries governance and every cd pipeline contains the one ci engine

This article is one rule: [FDR-CD-TYPE-DEPLOYCARRIESGOVERNANCE](../../drs/flow/pipeline-types.md#rule-fdr-cd-type-deploycarriesgovernance)
and [FDR-CD-CDCONTAINSCI](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdcontainsci) merged into one. It holds nothing
beyond what those two rules say.

DEPLOY exists to make an environment's governance a first-class pipeline construct: one place for access control, isolation and audit
history over an environment behind a manual gate. It splits by target on the one build-once artifact, DEPLOY-Non-Prod for the non-prod AT
environments and DEPLOY-Prod for the RBC-cleared artifact through pre-prod into production. A CD pipeline always contains a CI component,
and a solo CI contains only it. The CI component is the same build-and-verify in both, one CI engine, so the tagged artifact it produces as
the front of a CD is what DEPLOY then governs.

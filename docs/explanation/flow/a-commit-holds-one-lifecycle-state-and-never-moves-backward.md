---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-LIFE-ONESTATEADVANCESONERUNG
      - FDR-GIT-TOPICHISTORYISTHEAUTHORS
---

# A commit holds one lifecycle state and never moves backward

This article is one rule: [FDR-CD-LIFE-ONESTATEADVANCESONERUNG](../../drs/flow/commit-lifecycle.md#rule-fdr-cd-life-onestateadvancesonerung)
and [FDR-GIT-TOPICHISTORYISTHEAUTHORS](../../drs/flow/git-topic-flow.md#rule-fdr-git-topichistoryistheauthors) merged into one. It holds
nothing beyond what those two rules say.

A commit holds one lifecycle state at a time; the state advances one rung along the promotion ladder or leaves it, and never moves backward.
The ladder runs from topic (brown) to landed on main (grey) to BVT-verified (yellow), L3-verified (blue), and on to the UAT rungs. A topic's
history is its author's to rewrite until it lands, and the server's main is never rewritten.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-QUEUE-THREEQUEUES
      - FDR-CD-TWORELEASEGATES
---

# The ladder has exactly three manual queues and rc and rbc are gates

This article is one rule: [FDR-CD-QUEUE-THREEQUEUES](../../drs/flow/manual-queues.md#rule-fdr-cd-queue-threequeues) and
[FDR-CD-TWORELEASEGATES](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates) merged into one. It holds nothing
beyond what those two rules say.

The promotion ladder has exactly three manual queues, each named, each with a named server, a named store and a measured wait: the authoring
queue before the server's main, the main-UAT signature before release-uat, and the release-uat signature before production. RC and RBC are
the two hands-on release gates, each a gate and not a pipeline, a human-owned certification on an always-on environment.

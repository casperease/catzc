---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - FDR-CD-QUEUE-THREEQUEUES
      - FDR-CD-LIFE-DISCARDISTERMINAL
---

# The ladder has three manual queues and discard is terminal rejection

This article is one rule: [FDR-CD-QUEUE-THREEQUEUES](../../drs/flow/manual-queues.md#rule-fdr-cd-queue-threequeues) and
[FDR-CD-LIFE-DISCARDISTERMINAL](../../drs/flow/commit-lifecycle.md#rule-fdr-cd-life-discardisterminal) merged into one. It holds nothing
beyond what those two rules say.

The promotion ladder has exactly three manual queues, each with a named server, a named store and a measured wait. Discard is terminal
rejection at a named stage, and the discarded commit stays in history: BVT and L3 discard automatically, release-uat discards through its
manual gate (RBC), and main-UAT can kill a commit that fails there or hold it at its manual gate (RC).

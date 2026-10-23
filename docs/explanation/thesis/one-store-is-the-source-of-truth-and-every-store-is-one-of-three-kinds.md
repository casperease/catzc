---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - TDR-ONETRUTH-ONESTOREDECIDES
      - TDR-STORES-THREEKINDS
---

# One store is the source of truth and every store is one of three kinds

This article is one rule: [TDR-ONETRUTH-ONESTOREDECIDES](../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-onestoredecides) and
[TDR-STORES-THREEKINDS](../../drs/thesis/truth-stores.md#rule-tdr-stores-threekinds) merged into one. It holds nothing beyond what those two
rules say.

A source of truth is the one store whose content decides what is true about the delivered system; delivery is slow because truth is spread
across disjoint stores that drift apart, and catzc's answer is one source of truth, the repository. A truth store is any store that holds
part of the truth about a delivered system, of three kinds: a version-controlled repository, a fact source and a state machine.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - TDR-STORES-FACTSOURCEREADONLY
      - TDR-ONETRUTH-ONESTOREDECIDES
---

# A fact source is read only state and one store is the source of truth

This article is one rule: [TDR-STORES-FACTSOURCEREADONLY](../../drs/thesis/truth-stores.md#rule-tdr-stores-factsourcereadonly) and
[TDR-ONETRUTH-ONESTOREDECIDES](../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-onestoredecides) merged into one. It holds nothing
beyond what those two rules say.

A fact source is a state store: a database with a reachable live URL that holds state about delivery outside the repository, such as Azure
DevOps runtime state, and catzc reads its state only. A source of truth is the one store whose content decides what is true about the
delivered system; delivery is slow because truth is spread across disjoint stores that drift apart, and catzc's answer is one source of
truth, the repository.

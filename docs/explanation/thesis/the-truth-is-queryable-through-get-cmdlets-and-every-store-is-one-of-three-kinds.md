---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - TDR-ONETRUTH-TRUTHISQUERYABLE
      - TDR-STORES-THREEKINDS
---

# The truth is queryable through get cmdlets and every store is one of three kinds (TDR-ONETRUTH-TRUTHISQUERYABLE + TDR-STORES-THREEKINDS)

This article is one rule: [TDR-ONETRUTH-TRUTHISQUERYABLE](../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable) and
[TDR-STORES-THREEKINDS](../../drs/thesis/truth-stores.md#rule-tdr-stores-threekinds) merged into one. It holds nothing beyond what those two
rules say.

A truth store is any store that holds part of the truth about a delivered system, and there are three kinds: a version-controlled
repository, a fact source and a state machine. Every store catzc reads or reports to is one of the three, and its kind decides how catzc
treats it. The source of truth is queryable: every question about the system's state is answered by reading the repository through the
tooling's `Get-*` cmdlets, each of which also emits its answer as data (JSON).

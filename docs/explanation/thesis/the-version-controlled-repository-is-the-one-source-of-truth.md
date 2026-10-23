---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - TDR-STORES-VERSIONCONTROLLEDREPOSITORY
      - TDR-ONETRUTH-ONESTOREDECIDES
---

# The version controlled repository is the one source of truth

This article is one rule:
[TDR-STORES-VERSIONCONTROLLEDREPOSITORY](../../drs/thesis/truth-stores.md#rule-tdr-stores-versioncontrolledrepository) and
[TDR-ONETRUTH-ONESTOREDECIDES](../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-onestoredecides) merged into one. It holds nothing
beyond what those two rules say.

A version-controlled repository is the high-level kind of truth store whose content is a versioned history of reviewed changes; a git
repository is one subgroup of it. A source of truth is the one store whose content decides what is true about the delivered system. Delivery
is slow because truth is spread across disjoint stores that drift apart, servers, databases, CMDBs and ticket systems, and catzc's answer is
one source of truth, the repository.

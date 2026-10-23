---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# Contracts are laid out by unit version and module and every file has head policy

This article is one rule: [ADR-REPO-CONTRACT-LAYOUT](../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

Contracts are laid out as `contracts/<unit>/<version>/<module>/<path>`, where the unit is the deployable-unit that carries the contracts,
`catzc`, the bundle, the one unit a consumer pins, and the version is that unit's version, which `Resolve-CatzcBuildVersion` resolves. Every
file on disk is format-managed: a `Format-*` command covers it and decides its head policy.

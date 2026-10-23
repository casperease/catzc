---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-ROOTCFG-WILDCARDGENERATOR
---

# Contracts are laid out by unit version and module and a generator may name wildcard

This article is one rule: [ADR-REPO-CONTRACT-LAYOUT](../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout) and
[ADR-REPO-ROOTCFG-WILDCARDGENERATOR](../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-wildcardgenerator) merged into
one. It holds nothing beyond what those two rules say.

Contracts are laid out as `contracts/<unit>/<version>/<module>/<path>`, where the unit is `catzc`, the bundle, the version is that unit's
version and the module is the owning catzc module. A root-config `generator` entry may name a wildcard target (`*/tests/*/go.mod`) and
render one file per record, each target a repository-relative path the pattern matches, written and reported on its own.

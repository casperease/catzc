---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-VARIANT-MINIMALDEPENDENCIES
      - ADR-REPO-FOLDERS-CONTRACTSFOLDER
---

# The variants module depends on three modules and contracts live in a root folder

This article is one rule:
[ADR-REPO-VARIANT-MINIMALDEPENDENCIES](../../drs/repository/repo-variants.md#rule-adr-repo-variant-minimaldependencies) and
[ADR-REPO-FOLDERS-CONTRACTSFOLDER](../../drs/repository/conventional-folders.md#rule-adr-repo-folders-contractsfolder) merged into one. It
holds nothing beyond what those two rules say.

`Catzc.Base.Variants` depends only on `Catzc.Base.Config` (to read the file), `Catzc.Base.Objects` (the `DictionaryRecord` base of its
config type) and `Catzc.Base.Asserts` (for the `Assert-` guards), and its config type is self-contained. Contracts live under the root
`contracts/` folder, laid out as `contracts/<unit>/<version>/<module>/<path>`, where the unit is the deployable unit that carries the
contracts and the version is that unit's version.

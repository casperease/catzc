---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CONTRACT-NODOTFOLDERS
      - ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY
---

# Contracts and documentation folders hold content and no dot folders (ADR-REPO-CONTRACT-NODOTFOLDERS + ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY)

This article is one rule: [ADR-REPO-CONTRACT-NODOTFOLDERS](../../drs/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders) and
[ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY](../../drs/repository/conventional-folders.md#rule-adr-repo-folders-documentationmarkdownonly)
merged into one. It holds nothing beyond what those two rules say.

`contracts/` holds no dot-prefixed folder at any depth, because a dot prefix marks infrastructure at the repository root and every folder
under `contracts/` is content: a unit, a version, a module or a folder of an asset's path. Documentation folders are markdown-only: `docs/`
organizes its subfolders freely but holds only `.md` files, except the dot-prefixed `.assets/` folders that hold the diagrams the markdown
embeds.

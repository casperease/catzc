---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-KINDSCOPE
      - ADR-REPO-README-AUTHOREDSOURCES
---

# A kinds scope excludes vendored files and authored sources live in references

This article is one rule: [ADR-REPO-FILEMETA-KINDSCOPE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-kindscope) and
[ADR-REPO-README-AUTHOREDSOURCES](../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources) merged into one. It holds
nothing beyond what those two rules say.

The scope of a kind is the files it selects, less the files `.gitattributes` marks `linguist-vendored`, `linguist-generated`,
`catzc-fixture` or `catzc-contract`, and those it marks `-catzc-meta`. Authored sources live under `docs/references/`, with the one mapping
outside it being `docs/drs/`.

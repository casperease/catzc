---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-PROVENANCEINHEAD
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
---

# A generated head states its warning once and an authored head holds two edges

This article is one rule: [ADR-REPO-FILEMETA-PROVENANCEINHEAD](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-provenanceinhead)
and [ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-computablefactsonly) merged into
one. It holds nothing beyond what those two rules say.

A generated file states its provenance once, in the head, with the one string "Do Not Edit, this file is generated" declared once as the
default of the head's config type. An authored code or config file's head is the navigation head and holds exactly two edges under `edges`:
`cites`, the rule codes that bind the file, sorted and without duplicates, and `docs`, the link to its comment page.

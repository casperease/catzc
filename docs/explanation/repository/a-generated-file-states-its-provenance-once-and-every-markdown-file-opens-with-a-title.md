---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-PROVENANCEINHEAD
      - ADR-REPO-FORMAT-MARKDOWNTITLE
---

# A generated file states its provenance once and every markdown file opens with a title

This article is one rule: [ADR-REPO-FILEMETA-PROVENANCEINHEAD](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-provenanceinhead)
and [ADR-REPO-FORMAT-MARKDOWNTITLE](../../drs/repository/uniform-formatting.md#rule-adr-repo-format-markdowntitle) merged into one. It holds
nothing beyond what those two rules say.

A generated file states its provenance once, in the head: the `warning`, the one string "Do Not Edit, this file is generated". Every
git-tracked Markdown file opens, after any YAML front matter, with an H1 that is the document's title: words that say what it is, never its
repository path.

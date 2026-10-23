---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
      - ADR-REPO-COMMENTS-COMMENTPAGEPLACE
---

# Minimaps are computed from declared inputs and a comment page maps to one file

This article is one rule:
[ADR-REPO-SLIDES-MINIMAPSFROMDATA](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-minimapsfromdata) and
[ADR-REPO-COMMENTS-COMMENTPAGEPLACE](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-commentpageplace) merged into one. It
holds nothing beyond what those two rules say.

Derived artifacts are computed or mapped, never hand-kept. A diagram shows exactly three minimaps, and a minimap's data is computed, never
drawn by hand and never stored in the declaration: the declaration holds only the inputs, the rule codes in `about.adrs` and the minimap
ids. A file's comment page is mapped the same way: it lives under `docs/references/` at the place the `pages` map gives its source folder
and keeps the file's own name plus `.md`, so a page maps back to exactly one file.

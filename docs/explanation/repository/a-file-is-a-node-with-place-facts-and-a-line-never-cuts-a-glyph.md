---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-FILEISNODE
      - ADR-REPO-SLIDES-PAINTORDER
---

# A file is a node with place facts and a line never cuts a glyph

This article is one rule: [ADR-REPO-FILEMETA-FILEISNODE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode) and
[ADR-REPO-SLIDES-PAINTORDER](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-paintorder) merged into one. It holds nothing
beyond what those two rules say.

A file is a node, and its meta block says two things about it, each in a part of its own: `immutable` holds the place facts a reader of the
head needs, and only a generated head has any, its `with_body_sha` while git tracks it and its `warning`. A diagram obeys a comparable
order: a line never cuts a glyph, the kit declaring the paint order once in `drawio.yml` `layers:`, back to front: panels, frames, span
bars, lines, edges, glyphs, marks, then text.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
      - ADR-REPO-FILEMETA-PROVENANCEINHEAD
---

# Minimaps are computed from declared inputs and a generated file states its provenance once (ADR-REPO-SLIDES-MINIMAPSFROMDATA + ADR-REPO-FILEMETA-PROVENANCEINHEAD)

This article is one rule:
[ADR-REPO-SLIDES-MINIMAPSFROMDATA](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-minimapsfromdata) and
[ADR-REPO-FILEMETA-PROVENANCEINHEAD](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-provenanceinhead) merged into one. It holds
nothing beyond what those two rules say.

A diagram shows exactly three minimaps, and a minimap's data is computed, never drawn by hand and never stored in the declaration, which
holds only the inputs. A generated file states its provenance once, in the head: the one string "Do Not Edit, this file is generated",
declared once as the default of the head's config type.

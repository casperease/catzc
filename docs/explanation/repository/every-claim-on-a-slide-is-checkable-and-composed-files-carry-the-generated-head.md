---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-CHECKABLECLAIMS
      - ADR-REPO-FILEMETA-COMPOSEDFILES
---

# Every claim on a slide is checkable and composed files carry the generated head

This article is one rule: [ADR-REPO-SLIDES-CHECKABLECLAIMS](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-checkableclaims)
and [ADR-REPO-FILEMETA-COMPOSEDFILES](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-composedfiles) merged into one. It holds
nothing beyond what those two rules say.

Every claim on a slide is checkable: every code in the head's `cites` exists in the DRS index, a field that quotes a rule carries the
registry's text verbatim or the drift is reported, and `Test-Slides` is the gate over these checks. A file the automation composes whole, a
root-config copy, a generator's output or a `.gitkeep`, carries the generated-file head instead of an imprinted block.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-PATTERN
      - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
---

# A slide pattern is one file and every folder is conventional

This article is one rule: [ADR-REPO-SLIDES-PATTERN](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-pattern) and
[ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL](../../drs/repository/conventional-folders.md#rule-adr-repo-folders-everyfolderconventional)
merged into one. It holds nothing beyond what those two rules say.

A pattern is one file, `patterns/<name>.html` in the slides kit, one section in the slide format whose placeholders name its fields and say
which are required; a slide names its pattern in its head, and adding a layout is a new pattern file. Every folder in the repository is
conventional: its name infers its contents and purpose, and no folder needs a mapping file or a README to be understood.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-ROOTCFG-COMPOSEDROOTFILE
      - ADR-REPO-SLIDES-DECLARATION
---

# A managed root file carries the unified generated head and a diagram has one declaration

This article is one rule:
[ADR-REPO-ROOTCFG-COMPOSEDROOTFILE](../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-composedrootfile) and
[ADR-REPO-SLIDES-DECLARATION](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-declaration) merged into one. It holds nothing
beyond what those two rules say.

Every managed root file, a `source` copy or a `generator`'s output, carries the unified generated-file head, naming the `role` the
file-kinds registry gives the target and the `generator`. A diagram has the same single-source shape: its render `<name>.drawio.png` in an
`.assets/` folder and its one source, the diagram declaration.

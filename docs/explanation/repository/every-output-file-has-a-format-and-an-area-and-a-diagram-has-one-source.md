---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-OUTDIR-EVERYFILEHASFORMAT
      - ADR-REPO-SLIDES-DECLARATION
---

# Every output file has a format and an area and a diagram has one source (ADR-REPO-OUTDIR-EVERYFILEHASFORMAT + ADR-REPO-SLIDES-DECLARATION)

This article is one rule:
[ADR-REPO-OUTDIR-EVERYFILEHASFORMAT](../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-everyfilehasformat) and
[ADR-REPO-SLIDES-DECLARATION](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-declaration) merged into one. It holds nothing
beyond what those two rules say.

Every file under the output root belongs to one format of `output-formats.yml`, and its format's area (`run`, `build`, `cache`, `review`,
`session`, `log`) sets how long it stays. A diagram is the counterpart on the source side: its render `<name>.drawio.png` sits in an
`.assets/` folder and its one source is the diagram declaration.

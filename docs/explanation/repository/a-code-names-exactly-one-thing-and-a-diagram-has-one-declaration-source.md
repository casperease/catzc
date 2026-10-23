---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-DRSCODE-ONESTRINGONEFACT
      - ADR-REPO-SLIDES-DECLARATION
---

# A code names exactly one thing and a diagram has one declaration source

This article is one rule:
[ADR-REPO-DRSCODE-ONESTRINGONEFACT](../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-onestringonefact) and
[ADR-REPO-SLIDES-DECLARATION](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-declaration) merged into one. It holds nothing
beyond what those two rules say.

Under one parent, a child ADR and a rule never share a segment, so every code names exactly one ADR, rule or domain; a retired name is never
reused and a rule whose meaning changes takes a new name. A diagram follows the same single-source habit: it is its render
`<name>.drawio.png` in an `.assets/` folder and its one source is the diagram declaration.

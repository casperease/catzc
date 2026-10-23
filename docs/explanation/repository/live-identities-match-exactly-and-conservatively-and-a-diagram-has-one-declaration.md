---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-LANG-EXACTMATCHING
      - ADR-REPO-SLIDES-DECLARATION
---

# Live identities match exactly and conservatively and a diagram has one declaration (ADR-REPO-LANG-EXACTMATCHING + ADR-REPO-SLIDES-DECLARATION)

This article is one rule: [ADR-REPO-LANG-EXACTMATCHING](../../drs/repository/domain-language-separation.md#rule-adr-repo-lang-exactmatching)
and [ADR-REPO-SLIDES-DECLARATION](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-declaration) merged into one. It holds
nothing beyond what those two rules say.

Matching of live identities is exact and conservative: a distinctive live identity, a customer, subscription, org, template or project, is
flagged only as a bare string literal that is the token, not a substring or path segment. A diagram has the same single source: its render
`<name>.drawio.png` in an `.assets/` folder and its one source, the diagram declaration.

---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/index.md
    folder: docs/explanation/thesis
    name: index
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/index.md#thesis
      - docs/adr/repository/slides-as-markdown.md
      - docs/explanation/index.md
      - docs/explanation/thesis/product-thesis/deck.md
---

# Thesis explanations

```text
What cats is for, as a deck.

Product thesis   one source of truth, six principles, twelve domains, in 21 slides
```

These pages explain the [thesis ADR domain](../../adr/index.md#thesis). The product thesis is a deck kept as slide files under
[product-thesis](product-thesis/deck.md), rendered through the slides kit ([ADR-REPO-SLIDES](../../adr/repository/slides-as-markdown.md));
the [explanation index](../index.md) says how to read the explanations.

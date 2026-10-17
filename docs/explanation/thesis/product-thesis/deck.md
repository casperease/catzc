---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/deck.md
    folder: docs/explanation/thesis/product-thesis
    name: deck
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/index.md
      - docs/adr/thesis/one-source-of-truth.md
---

# Cats product thesis

## Sections

- cover: Why cats exists, and the one decision it rests on.
- principles: The six principles, the mechanics of the thesis.
- domains: The domains that specialise the principles, and how a rule is cited.

## About

The deck is the visual of [one-source-of-truth](../../../adr/thesis/one-source-of-truth.md), the thesis ADR: delivery is slow because the
truth about a system is spread across stores that drift apart, and cats removes that problem by making the repository the one source of
truth with one change process. It then shows the six principles that state the thesis's mechanics and the domains that specialise them, as
the [ADR index](../../../adr/index.md) lists them. Every slide that states a rule carries the rule's code, and a slide that quotes a rule
carries the registry's text, which the render compares.

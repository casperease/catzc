# Cats product thesis

## Sections

- cover: Why cats exists, and the one decision it rests on.
- principles: The six principles, the mechanics of the thesis.
- domains: The domains that specialise the principles, and how a rule is cited.

## About

The deck is the visual of [one-source-of-truth](../../../drs/thesis/one-source-of-truth.md), the thesis ADR: delivery is slow because the
truth about a system is spread across stores that drift apart, and cats removes that problem by making the repository the one source of
truth with one change process. One slide sorts those stores into the three kinds of [truth-stores](../../../drs/thesis/truth-stores.md): the
one catzc writes, the ones it reads and the ones it meets. It then shows the six principles that state the thesis's mechanics and the
domains that specialise them, as the [DRS index](../../../drs/index.md) lists them. Every slide that states a rule carries the rule's code,
and a slide that quotes a rule carries the registry's text, which the render compares.

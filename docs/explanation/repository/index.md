# Repository explanations

```text
How the repository is kept in shape.

Root config materialisation   every managed root file comes from one source
Variant primitives            nothing reads variants.yml directly
Diagram build                 five stages in one command; rendering is the cost
```

These articles explain decisions from the [repository DRS domain](../../drs/index.md#repository). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## The contract reference

One command reads the contract assets through the one reader and writes a reference page per unit
([api-contracts](../../drs/repository/api-contracts.md), [command-contracts](../../drs/repository/command-contracts.md)).

| Article                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------- |
| [How the contract reference is built](building-the-contract-reference-writes-one-page-per-unit.md) |

## Minimaps

A diagram's minimaps are one projection, computed from data and never drawn by hand
([slides-as-markdown](../../drs/repository/slides-as-markdown.md)).

| Article                                                                                            |
| -------------------------------------------------------------------------------------------------- |
| [A diagram's minimaps are one projection, computed from data and never drawn by hand](minimaps.md) |

## Diagram build

Build-Diagrams runs five stages in one command, and rendering is the cost
([slides-as-markdown](../../drs/repository/slides-as-markdown.md)).

| Lens           | Article                                                                                 |
| -------------- | --------------------------------------------------------------------------------------- |
| implementation | [Build-Diagrams runs five stages, and rendering is the cost](how-diagrams-are-built.md) |

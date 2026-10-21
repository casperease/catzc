# Repository explanations

```text
How the repository is kept in shape.

Root config materialisation   every managed root file comes from one source
Variant primitives            nothing reads variants.yml directly
Diagram build                 five stages in one command; rendering is the cost
```

These articles explain decisions from the [repository ADR domain](../../adr/index.md#repository). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## Diagram build

Build-Diagrams runs five stages in one command, and rendering is the cost
([slides-as-markdown](../../adr/repository/slides-as-markdown.md)).

| Lens           | Article                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------ |
| implementation | [Build-Diagrams runs five stages, and rendering is the cost](build-diagrams-runs-five-stages.md) |

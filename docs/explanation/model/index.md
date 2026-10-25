# Model explanations

```text
What the repository knows about itself, and where each part is declared.

The physical model            the tree, its tracks and places, file languages, aspects, and the four link relations
The meta model                modules and their order, engines, decision kinds and domains, and the glossary
Where each model is declared  one table: model, config file, query command, and the gate that keeps it true
The zoom ladder               C0 to C4, how far out a diagram stands, crossing the lens it is drawn through
```

These articles explain the models the repository keeps of itself: the physical model of its files and the meta model of its modules, engines
and decisions. Every part of each model is declared once in a config, answered by a query command, and kept true by a gate, so a reader,
human or agent, can ask a command instead of grepping the configs. The [explanation index](../index.md) says how to read the explanations.

- [The physical model](the-physical-model.md) — the tree, the tracks and their places, the file languages, the aspects, and the link
  relations between files.
- [The meta model](the-meta-model.md) — the modules and the order they load in, the engines, the decision kinds and domains, and the
  glossary.
- [Where each model is declared](where-each-model-is-declared.md) — each model with its config, its query and its gate.
- The five ladders, one per point of the tree: [the repository root](zoom-root.md) (C0–C2), [pwsh](zoom-pwsh.md) (C2–C3),
  [pwsh/.internal](zoom-internal.md) (C3–C4), [Catzc.Base.Config](zoom-config.md) (C3–C4) and [docs/drs](zoom-drs.md) (C2–C4).
- [The zoom ladder](the-zoom-ladder.md) — the five levels a diagram stands at, from the landscape around the repository down to one module's
  files ([DDR-VISUAL-ZOOMISANAXIS](../../drs/design/visual-design.md#rule-ddr-visual-zoomisanaxis)).

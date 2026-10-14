# docs/explanation/automation/index.md

`Automation explanations`

```text
How the automation layer of cats holds together.

Module dependency groups   the declared allow-list, its layers, and the gates that check it
```

These articles explain decisions from the [automation ADR domain](../../adr/index.md#automation): how modules may depend on one another, how
the importer loads them, and how the bundle is built and installed. Each article narrates one diagram; the [explanation index](../index.md)
says how to read them.

## Module dependency groups

Every module dependency is declared in one allow-list, and the declared graph forms three layers
([ADR-AUTO-DEPM](../../adr/automation/controlling-module-dependencies.md)).

- architecture — [Module dependencies form three layers, and every edge points down](three-layers-edges-point-down.md)

# docs/explanation/automation/index.md

`Automation explanations`

```text
How the automation layer of cats holds together.

The bundle                 one commit becomes one verified package, and every code root is a copy
The importer               every entry runs one load sequence
Module dependency groups   one declared allow-list, and every edge points down
```

These articles explain decisions from the [automation ADR domain](../../adr/index.md#automation): how the bundle is built and placed, how
the importer loads the modules, and how modules may depend on one another. Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## The bundle

One commit becomes one verified, immutable package, and every code root is a copy of it
([platform-bundle](../../adr/automation/platform-bundle.md)).

| Lens           | Article                                                                                                                        |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| meta           | [One commit becomes one verified, immutable package, and every code root is a copy of it](one-commit-one-immutable-package.md) |
| architecture   | [One engine builds the bundle, and every code root is a copy of its output](every-code-root-is-a-copy.md)                      |
| implementation | [Build-Modules builds, verifies, and leaves one folder that every target copies whole](build-verify-then-copy-the-folder.md)   |
| operations     | [Build the bundle once, then place it with one command](build-then-place-with-one-command.md)                                  |
| governance     | [Every stage of the bundle has a rule, and two gates check it](what-gates-each-bundle-stage.md)                                |

## The importer

Every entry runs one load sequence through the importer ([platform-bundle](../../adr/automation/platform-bundle.md)).

| Lens           | Article                                                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------------------------- |
| meta           | [Every entry runs one load sequence](every-entry-runs-one-load-sequence.md)                                               |
| architecture   | [Two entry scripts feed one importer, and the importer leaves once the load is done](two-entries-feed-one-importer.md)    |
| implementation | [Invoke-Importer loads, asserts one run mode, tidies up and unloads, in one call chain](invoke-importer-in-code-order.md) |
| operations     | [Dot-source one entry script, and a failed check stops the load with a named error](dot-source-one-entry-script.md)       |
| governance     | [Every load stage but the unload has an ADR rule and a gate](rule-and-gate-per-load-stage.md)                             |

## Module dependency groups

One declared allow-list says what may depend on what, and the declared graph forms three layers
([controlling-module-dependencies](../../adr/automation/controlling-module-dependencies.md)).

| Lens           | Article                                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| meta           | [One declared allow-list says what may depend on what, and every edge points down](a-declared-allow-list-of-layers.md)          |
| architecture   | [Module dependencies form three layers, and every edge points down](three-layers-edges-point-down.md)                           |
| implementation | [Two sections of dependencies.yml are unioned into one allow-set per source module](two-sections-unioned-into-one-allow-set.md) |
| operations     | [An undeclared module edge fails the gate with one line per issue](undeclared-edge-fails-with-one-line.md)                      |
| governance     | [Two gates check the layer pins, and one rule is left to review](two-gates-check-the-layer-pins.md)                             |

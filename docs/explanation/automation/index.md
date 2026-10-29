# Automation explanations

```text
How the automation of cats holds together.

The bundle                 one commit becomes one verified package, and every code root is a copy
The importer               every entry runs one load sequence
Module dependency groups   one declared allow-list, and every edge points down
Compiled types             what unboxing costs, and what costs more than it
```

These articles explain decisions from the [automation DRS domain](../../drs/index.md#automation): how the bundle is built and placed, how
the importer loads the modules, how modules may depend on one another, and what compiled types cost. Each article but the last narrates one
diagram; the [explanation index](../index.md) says how to read them.

## The bundle

One commit becomes one verified, immutable package, and every code root is a copy of it
([platform-bundle](../../drs/automation/platform-bundle.md)).

- **meta**: [One commit becomes one verified, immutable package, and every code root is a copy of it](how-a-commit-becomes-a-package.md)
- **architecture**: [One engine builds the bundle, and every code root is a copy of its output](where-the-code-roots-get-their-bundle.md)
- **implementation**:
  [Build-Modules builds, verifies, and leaves one folder that every target copies whole](what-build-modules-leaves-behind.md)
- **operations**: [Build the bundle once, then place it with one command](how-a-bundle-is-built-and-placed.md)
- **governance**: [Every stage of the bundle has a rule, and two gates check it](what-gates-each-bundle-stage.md)

## The importer

Every entry runs one load sequence through the importer ([platform-bundle](../../drs/automation/platform-bundle.md)).

- **meta**: [Every entry runs one load sequence](which-stages-a-load-runs.md)
- **architecture**: [Two entry scripts feed one importer, and the importer leaves once the load is done](two-entries-feed-one-importer.md)
- **implementation**:
  [Invoke-Importer loads, asserts one run mode, tidies up and unloads, in one call chain](invoke-importer-in-code-order.md)
- **operations**:
  [Dot-source one entry script, and a failed check stops the load with a named error](how-the-entry-script-loads-the-modules.md)
- **governance**: [Every load stage but the unload has a DRS rule and a gate](what-checks-each-load-stage.md)

## Module dependency groups

One declared allow-list says what may depend on what, and the declared graph forms three layers
([controlling-module-dependencies](../../drs/automation/controlling-module-dependencies.md)).

- **meta**: [One declared allow-list says what may depend on what, and every edge points down](a-declared-allow-list-of-layers.md)
- **architecture**: [Module dependencies form three layers, and every edge points down](how-modules-are-layered.md)
- **implementation**:
  [Two sections of dependencies.yml are unioned into one allow-set per source module](two-sections-unioned-into-one-allow-set.md)
- **operations**: [An undeclared module edge fails the gate with one line per issue](undeclared-edge-fails-with-one-line.md)
- **governance**: [Two gates check the layer pins, and one rule is left to review](two-gates-check-the-layer-pins.md)

## The accosted language

A flat list of harmless contracted calls proves a command from every engine
([accosted-language](../../drs/automation/accosted-language.md)).

| Article                                                                                                                           |
| --------------------------------------------------------------------------------------------------------------------------------- |
| [Reading an accosted file writes nothing and leaves the contract checks as they were](reading-an-accosted-file-writes-nothing.md) |

## The spelling oracle

The `Test-Spelling` quality gate judges every identifier fragment against one curated registry and one committed English word list
([spell-out-names](../../drs/automation/spell-out-names.md)).

| Article                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------- |
| [Building the English dictionary writes one stamped word list](building-the-english-dictionary-writes-one-stamped-word-list.md) |

## The Python workspace

uv is the single handler for Python, and one command lays out the workspace it handles
([uv-python-handler](../../drs/automation/uv-python-handler.md),
[python-test-artifacts](../../drs/automation/python/python-test-artifacts.md)).

| Article                                                                                                   |
| --------------------------------------------------------------------------------------------------------- |
| [One command lays out the Python workspace that uv handles](one-command-lays-out-the-python-workspace.md) |

## Compiled types

Reading a value out of an object costs a few nanoseconds, and the type tests, reflection lookups and PowerShell crossings around it cost
more ([native-csharp-types](../../drs/automation/BCL/native-csharp-types.md)).

- **[**
- **[**

---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration.md
    kind: reference
    language: markdown
    track: docs
    body_sha: e2cb090c3f31
    links:
      - docs/adr/automation/path-representation.md
      - docs/adr/automation/sensible-defaults.md
      - docs/adr/automation/test-automation.md
      - docs/adr/configuration/module-config-loading.md
      - docs/adr/repository/inspiration.md
      - docs/references/automation/catzc-tooling-keyhandler.md
---

# Catzc.Tooling.Inspiration

The inspiration module of the Tooling group: one checked way to find the sibling repositories catzc reads for ideas, never as a reference
implementation ([inspiration](../../adr/repository/inspiration.md)). It declares each inspiration in config, resolves where it lives on this
machine, and reports whether it is there, so an agent or a human asks the module instead of trusting a path written into prose. It reads
nothing inside an inspiration and decides nothing from it; catzc's own ADRs decide. Like
[Catzc.Tooling.KeyHandler](catzc-tooling-keyhandler.md), it installs nothing, so it rests only on the `Base` group.

## Responsibilities

| Responsibility   | Area    | Name                                                                   |
| ---------------- | ------- | ---------------------------------------------------------------------- |
| responsibility:1 | find    | [Find the inspirations](#responsibility1--find-the-inspirations)       |
| responsibility:2 | declare | [Declare the inspirations](#responsibility2--declare-the-inspirations) |

### responsibility:1 — Find the inspirations

Resolve where each inspiration lives on this machine, and say whether it is there. A sibling checkout lives beside the repository, so its
root is stored on the workspace anchor, `{workspace}`: the parent folder of the repository root. The anchor resolves to an absolute path
only at the point of use, and it resolves the same from pwsh's view of the repository root as from Git Bash's. With no arguments the module
lists every available inspiration; it also returns one by id, available or not, or picks a number of distinct inspirations at random, with a
seed that makes the pick repeatable. An inspiration whose root does not exist here is reported as unavailable, never thrown on, because the
work carries on without it.

### responsibility:2 — Declare the inspirations

Each inspiration is an entry in `configs/inspiration.yml`: an id, the root it lives at, one sentence on what it is, and the folders inside
it worth reading. The root is stored in communication form, never as an absolute or `..` path
([path-representation](../../adr/automation/path-representation.md)), and the entries are validated when the config loads. The sensible
default, the one `eac` entry, is declared once on the config type, so an empty file and a fresh checkout behave the same
([sensible-defaults](../../adr/automation/sensible-defaults.md)).

## What the module does

The module turns a policy into a query. The [inspiration](../../adr/repository/inspiration.md) ADR says a sibling may be read for ideas and
that its absence costs nothing; the module makes the sibling's location configuration rather than prose, and makes its absence a value
rather than an error. The config is read through the one config reader, `Get-Config`, and validated on load by its C# config type
([module-config-loading](../../adr/configuration/module-config-loading.md)).

Path handling follows [path-representation](../../adr/automation/path-representation.md): the stored root is portable, and each result
carries the normalized absolute path, the degraded form for a folder outside the repository. The anchor arithmetic and the mapping of a Git
Bash drive path to a Windows one are pure methods that take the platform as a parameter, so every branch is unit-tested on any OS
([test-automation](../../adr/automation/test-automation.md)). The random pick is a seeded shuffle, deterministic under a seed, which the
tests rely on.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                              | Function          |
| ------------------------------------------- | ----------------- |
| responsibility:1 — Find the inspirations    | `Get-Inspiration` |
| responsibility:2 — Declare the inspirations | `inspiration.yml` |

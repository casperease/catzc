---
catzc:
  immutable:
    repo_status: clean
    path: docs/adr/automation/importer.md
    folder: docs/adr/automation
    name: importer
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AUTO-IMPORTER#{1-5}
    cites:
      - ADR-AUTO-BUNDLE#3
      - ADR-AUTO-CACHE#6
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#{6,7}
      - ADR-AUTO-EXTEND#3
      - ADR-AUTO-LAYERS#4
      - ADR-AUTO-MODULE#3
      - ADR-AUTO-TYPES#7
      - ADR-DSGN-RUNMODE#{1,4}
    links:
      - docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7
      - docs/adr/automation/caching.md#rule-adr-auto-cache6
      - docs/adr/automation/devbox-pipeline-parity.md
      - docs/adr/automation/execution-engines.md#rule-adr-auto-engine6
      - docs/adr/automation/execution-engines.md#rule-adr-auto-engine7
      - docs/adr/automation/layers.md#rule-adr-auto-layers4
      - docs/adr/automation/module-model.md#rule-adr-auto-module3
      - docs/adr/automation/open-closed-architecture.md
      - docs/adr/automation/open-closed-architecture.md#rule-adr-auto-extend3
      - docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle3
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
      - docs/adr/design/run-modes.md#rule-adr-dsgn-runmode1
      - docs/adr/design/run-modes.md#rule-adr-dsgn-runmode4
      - docs/adr/repository/generated-root-configs.md
---

# ADR-AUTO-IMPORTER: the importer decides the mix

## Rules: ADR-AUTO-IMPORTER

### Rule ADR-AUTO-IMPORTER:1

The **importer** is the one way catzc enters a session: per execution engine one entry at the repository root, the importer entry the
engine model names, every entry generated from one source and never hand-edited
([ADR-AUTO-ENGINE#6](execution-engines.md#rule-adr-auto-engine6), [ADR-DSGN-RUNMODE#1](../design/run-modes.md#rule-adr-dsgn-runmode1)).

- [One entry per engine](#one-entry-per-engine)

### Rule ADR-AUTO-IMPORTER:2

The importer decides the mix a session loads: which languages, which engines and which modules. Each input resolves in the one order of a
setting ([ADR-AUTO-DEFAULT#6](sensible-defaults.md#rule-adr-auto-default6)): the caller's explicit value, else the importer's configuration,
else the default declared once on its config type. The default is `auto`: every engine whose executable is present, with a missing one
skipped and reported ([ADR-AUTO-ENGINE#7](execution-engines.md#rule-adr-auto-engine7)), and the languages of the modules it loads.

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER:3

The mix is one record for the session. The test runner reads its engines from it and the builder reads its modules from it; neither decides
again what the importer decided ([ADR-AUTO-BUNDLE#3](platform-bundle.md#rule-adr-auto-bundle3),
[ADR-AUTO-CACHE#6](caching.md#rule-adr-auto-cache6)).

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER:4

A language the configuration names and the importer has no handler for stops the import with a NotImplemented error that names the
language; the handled implementation languages are PowerShell with its hosted C#, Bash, Python and Go
([ADR-AUTO-MODULE#3](module-model.md#rule-adr-auto-module3)). A new language is a handler and a registry entry, never a branch
([ADR-AUTO-EXTEND#3](open-closed-architecture.md#rule-adr-auto-extend3)).

- [Growth by entry](#growth-by-entry)

### Rule ADR-AUTO-IMPORTER:5

The run mode, source or build, and the host, console or headless, are orthogonal to the mix: they choose where the modules are read from and
how the native types load ([ADR-DSGN-RUNMODE#4](../design/run-modes.md#rule-adr-dsgn-runmode4),
[ADR-AUTO-TYPES#7](BCL/native-csharp-types.md#rule-adr-auto-types7)), the mix chooses which modules, languages and engines.

- [The mix](#the-mix)

## Context

About thirty ADRs mention the importer and none defines it. The entry scripts, the module loader, the types loader and the bundle each
assume a mix of languages, engines and modules that no one place states: the loader reads every module folder of the code root, the test
runner runs every Go and Python test once per engine from the engine model, and the builder reads the bundle's profile. Three places decide
three parts of one thing. This ADR names the importer as the one that decides, and names the inputs and the result, so the others read it
([ADR-AUTO-LAYERS#4](layers.md#rule-adr-auto-layers4)).

### One entry per engine

An engine reaches catzc through a script it can run: pwsh dot-sources `importer.ps1`, bash and zsh dot-source `importer.sh`, which dispatches
to the `cats` command. Both are root configs written by a generator from one source, so a change to what the importer does is one edit, and
`Test-GeneratedFiles` reports the drift when a copy is stale ([generated-root-configs](../repository/generated-root-configs.md)).

### The mix

Languages, engines and modules are three axes of one choice. The order of resolution is the order every setting has: an explicit argument
to the importer wins, configuration comes second, and the default declared once on the config type comes last, so a devbox, a pipeline and
a consumer each get the same answer from the same inputs ([devbox-pipeline-parity](devbox-pipeline-parity.md)). The result is kept for the
session and read, never recomputed: a test runner that re-decided the engines could disagree with the loader that chose the modules.

### Growth by entry

The repository grows by adding an entry and its handlers, not by adding a branch ([open-closed-architecture](open-closed-architecture.md)).
A language the configuration names but the importer cannot load is an error at import, loud and early, rather than a silent subset loaded;
the pattern is the one a contract takes for a kind it does not implement.

## Decision

The importer is the one entry per engine and the one place that decides the mix, in the resolution order every setting has, with `auto` as
the default; the result is one record per session that the test runner and the builder read.

## Consequences

- The importer loads every module of the code root under pwsh, with PowerShell and its hosted C# as the languages; that is the mix the
  rules above describe, and an importer configuration with a readable mix record makes it a setting instead of a fact of the code.
- `importer.ps1` and `importer.sh` stay generated; a hand edit is drift that `Test-GeneratedFiles` reports.
- A test runner or a builder that selects engines or modules on its own is a defect against rule 3.

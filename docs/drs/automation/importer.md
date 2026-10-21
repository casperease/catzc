# ADR-AUTO-IMPORTER: the importer decides the mix

## Rules: ADR-AUTO-IMPORTER

### Rule ADR-AUTO-IMPORTER-ONEENTRY

The **importer** is the one way catzc enters a session: per execution engine one entry at the repository root, the importer entry the engine
model names, every entry generated from one source and never hand-edited
([ADR-AUTO-ENGINE-IMPORTERENTRY](execution-engines.md#rule-adr-auto-engine-importerentry),
[DDR-RUNMODE-TWORUNMODES](../design/run-modes.md#rule-ddr-runmode-tworunmodes)).

- [One entry per engine](#one-entry-per-engine)

### Rule ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX

An engine's importer entry is generated only when one of the engines it serves is in the mix: `importer.sh` only with a POSIX engine. Which
engines an entry serves comes from the engine model's importer entry, never from a key beside the generated file, so the fact lives once
([ADR-AUTO-ENGINE-IMPORTERENTRY](execution-engines.md#rule-adr-auto-engine-importerentry)).

- [One entry per engine](#one-entry-per-engine)

### Rule ADR-AUTO-IMPORTER-DECIDESMIX

The importer decides the mix a session loads: which languages, which engines and which modules. Each input resolves in the one order of a
setting ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): the caller's explicit value,
else the importer's configuration, else the default declared once on its config type. The default is `auto`: every engine whose executable
is present, with a missing one skipped and reported
([ADR-AUTO-ENGINE-AUTONAMESNOENGINE](execution-engines.md#rule-adr-auto-engine-autonamesnoengine)), and the languages of the modules it
loads.

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER-ONEMIXRECORD

The mix is one record for the session. The test runner reads its engines from it and the builder reads its modules from it; neither decides
again what the importer decided ([ADR-AUTO-BUNDLE-ONELIVINGIMPORTER](platform-bundle.md#rule-adr-auto-bundle-onelivingimporter),
[ADR-AUTO-CACHE-IMPORTERINVALIDATES](caching.md#rule-adr-auto-cache-importerinvalidates)).

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD

The importer loads every module of the code root, resolves the mix once from the loaded toolset, keeps it as the session's record, and then
removes the modules outside the mix. The decision reads the same module model, languages configuration and engine locator as every other
command, so there is no second, pre-load copy of them.

- [Deciding after the load](#deciding-after-the-load)

### Rule ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES

A module's code languages are the executable languages of the files that a language's own layout row places; the shared rows, assets and
tests, never count ([ADR-AUTO-MODULE-EXISTSBYLAYOUT](module-model.md#rule-adr-auto-module-existsbylayout)). A module is in the mix when
every code language of it is; a module with one outside the mix is not loaded. Assets are data a module ships, and tests run under the test
runner, so neither decides whether the module runs.

- [Deciding after the load](#deciding-after-the-load)

### Rule ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS

A language the configuration names and the importer has no handler for stops the import with a NotImplemented error that names the language;
a language is handled when it is executable and its layout rows place it in a module or its tests runner runs it, so the handled
implementation languages are PowerShell with its hosted C#, Bash, Python and Go
([ADR-AUTO-MODULE-LANGUAGESFROMFILES](module-model.md#rule-adr-auto-module-languagesfromfiles)). A new language is a handler and a registry
entry, never a branch
([ADR-AUTO-EXTEND-CONTENTAGNOSTICINFRASTRUCTURE](open-closed-architecture.md#rule-adr-auto-extend-contentagnosticinfrastructure)).

- [Growth by entry](#growth-by-entry)

### Rule ADR-AUTO-IMPORTER-MODEANDHOSTORTHOGONAL

The run mode, source or build, and the host, console or headless, are orthogonal to the mix: they choose where the modules are read from and
how the native types load ([DDR-RUNMODE-MODEISDERIVED](../design/run-modes.md#rule-ddr-runmode-modeisderived)), the mix chooses
which modules, languages and engines.

- [The mix](#the-mix)

## Context

About thirty ADRs mention the importer and none defines it. The entry scripts, the module loader, the types loader and the bundle each
assume a mix of languages, engines and modules that no one place states: the loader reads every module folder of the code root, the test
runner runs every Go and Python test once per engine from the engine model, and the builder reads the bundle's profile. Three places decide
three parts of one thing. This ADR names the importer as the one that decides, and names the inputs and the result, so the others read it
([ADR-AUTO-LAYERS-IMPORTERDECIDESMIX](layers.md#rule-adr-auto-layers-importerdecidesmix)).

### One entry per engine

An engine reaches catzc through a script it can run: pwsh dot-sources `importer.ps1`, the other engines dot-source `importer.sh`, which
dispatches to the `cats` command. Both are root configs written by a generator from one source, so a change to what the importer does is one
edit, and `Test-GeneratedFiles` reports the drift when a copy is stale. An entry exists for the engines the session serves: with pwsh alone
in the mix, `importer.sh` is not managed, because no engine would run it.

### The mix

Languages, engines and modules are three axes of one choice. The order of resolution is the order every setting has: an explicit argument to
the importer wins, configuration comes second, and the default declared once on the config type comes last, so a devbox, a pipeline and a
consumer each get the same answer from the same inputs ([devbox-pipeline-parity](devbox-pipeline-parity.md)). The result is kept for the
session and read, never recomputed: a test runner that re-decided the engines could disagree with the loader that chose the modules.

### Deciding after the load

Deciding the mix needs the module model, the languages configuration and the engine locator, and those are modules themselves. Deciding
after the load uses them as they are. A two-phase load, with the deciding modules first and the rest filtered, carries a second load path. A
file-extension map inside the importer is a second living version of the languages configuration
([one-living-version](../principles/one-living-version.md)). Loading a module and then removing it costs time only when the mix leaves
modules out. Counting a module's asset or test files would let an explicit mix drop a module for a script it only ships.

### Growth by entry

The repository grows by adding an entry and its handlers, not by adding a branch ([open-closed-architecture](open-closed-architecture.md)).
A language the configuration names but the importer cannot load is an error at import, loud and early, rather than a silent subset loaded;
the pattern is the one a contract takes for a kind it does not implement.

## Decision

The importer is the one entry per engine and the one place that decides the mix, in the resolution order every setting has, with `auto` as
the default; the result is one record per session that the test runner and the builder read.

## Consequences

- `importer.yml` in `Catzc.Base.ModuleSystem` holds the importer configuration, `ImporterConfig` declares its defaults, `Set-ImportMix`
  resolves and keeps the record, and `Get-ImportMix` reads it.
- `importer.ps1` and `importer.sh` stay generated; a hand edit is drift that `Test-GeneratedFiles` reports.
- A test runner or a builder that selects engines or modules on its own is a defect against rule 3.

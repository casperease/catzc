# ADR-AUTO-IMPORTER: the importer decides the mix

## Rules: ADR-AUTO-IMPORTER

### Rule ADR-AUTO-IMPORTER-ONEENTRY

The **importer** is the one way catzc enters a session: per execution engine one entry at the repository root, the importer entry the engine
model names, every entry generated from one source and never hand-edited
([ADR-AUTO-ENGINE-IMPORTERENTRY](execution-engines.md#rule-adr-auto-engine-importerentry),
[DDR-RUNMODE-TWORUNMODES](../design/run-modes.md#rule-ddr-runmode-tworunmodes)). The POSIX engines share one such entry, a committed root
file each of them loads into its session, with no copy per shell.

- [One entry per engine](#one-entry-per-engine)

### Rule ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX

An engine's importer entry is generated only when one of the engines it serves is in the mix: `importer.sh` only with a POSIX engine. Which
engines an entry serves comes from the engine model's importer entry, never from a key beside the generated file, so the fact lives once
([ADR-AUTO-ENGINE-IMPORTERENTRY](execution-engines.md#rule-adr-auto-engine-importerentry)).

- [One entry per engine](#one-entry-per-engine)

### Rule ADR-AUTO-IMPORTER-DECIDESMIX

The importer decides the mix a session loads: which languages, which engines and which modules; no command, test runner or builder decides
it again. Each input resolves in the one order of a setting
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): the caller's explicit value, else
the importer's configuration, else the default declared once on its config type. The default is `auto`: every engine whose executable is
present, with a missing one skipped and reported
([ADR-AUTO-ENGINE-AUTONAMESNOENGINE](execution-engines.md#rule-adr-auto-engine-autonamesnoengine)), and the languages of the modules it
loads.

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER-ONEMIXRECORD

The mix is one record for the session. The test runner reads its engines from it and the builder reads its modules from it; neither decides
again what the importer decided ([ADR-AUTO-BUNDLE-ONELIVINGIMPORTER](platform-bundle.md#rule-adr-auto-bundle-onelivingimporter),
[ADR-AUTO-CACHE-IMPORTERINVALIDATES](caching.md#rule-adr-auto-cache-importerinvalidates)).

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD

The importer resolves the mix once, after the modules that decide it are loaded, from the loaded toolset, and keeps it as the session's
record. A headless session loads every module of the code root at import and then removes the modules outside the mix. A console session
loads the core at import and each other module at the first use of one of its commands; a module outside the mix is never loaded by a first
use. The decision reads the same module model, languages configuration and engine locator as every other command, so there is no second,
pre-load copy of them.

- [Deciding after the load](#deciding-after-the-load)

### Rule ADR-AUTO-IMPORTER-LOADEDBYFIRSTUSE

The core is the module that decides the mix and every module it is declared to need, derived from the declared graph and never listed by
hand. A module loads the same files in the same order at import or at first use, through one load function. The function-name collision
check and the generated manifests cover every module at import. A command that enumerates the loaded modules completes the load first. A
session's result never depends on when a module loads. An import may name its own load with `-ModuleLoad`, which overrides the load row for
that import alone, so a child session that runs one command loads the core and the rest on first use.

- [Deciding after the load](#deciding-after-the-load)
- [An import names its own load](#an-import-names-its-own-load)

### Rule ADR-AUTO-IMPORTER-LANGUAGESSELECTMODULES

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
entry, never a branch ([ADR-AUTO-EXTEND-CONTENTAGNOSTICCORE](open-closed-architecture.md#rule-adr-auto-extend-contentagnosticcore)).

- [Growth by entry](#growth-by-entry)

### Rule ADR-AUTO-IMPORTER-MODEANDHOSTORTHOGONAL

The run mode, source or build, and the host, console or headless, are orthogonal to the mix: they choose where the modules are read from,
how the native types load and when the modules load ([DDR-RUNMODE-MODEISDERIVED](../design/run-modes.md#rule-ddr-runmode-modeisderived)),
the mix chooses which modules, languages and engines. The load row of the host and mode is the default for when the modules load; an import
that names its own load overrides it for that import alone.

- [The mix](#the-mix)

### Rule ADR-AUTO-IMPORTER-CONSOLEROOF

A console import has a roof, `import.console_seconds` in the timeouts configuration (3 s). Every console import appends one line to the
import ledger under the output folder with its phases, its CPU seconds and the antivirus signature version; an import over the roof names
its CPU seconds on its closing line, and says when it is the first import since that signature changed; that first console import also warms
the scanner's cache in the background. A slow import warns and never fails.

- [The console roof and the ledger](#the-console-roof-and-the-ledger)

## Context

Many records mention the importer. The entry scripts, the module loader, the types loader and the bundle each assume a mix of languages,
engines and modules: the loader reads every module folder of the code root, the test runner runs every Go and Python test once per engine
from the engine model, and the builder reads the bundle's profile. Three places deciding three parts of one thing would drift, so this
record names the importer as the one that decides, with its inputs and its result, and the others read it
([ADR-AUTO-IMPORTER-DECIDESMIX](#rule-adr-auto-importer-decidesmix)).

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
after the load uses them as they are: the importer loads the core, the module that decides and every module it is declared to need, and
resolves the mix from what is loaded. A headless session then loads the rest at import and removes the modules outside the mix, which costs
time only when the mix leaves modules out. A console session leaves the rest unloaded: each module loads at the first lookup of one of its
commands, and a module outside the mix is struck from the lookup, so a first use never loads it.

One load function serves both moments. A module loads the same files in the same order whether it loads at import or at first use, so a
session's result does not depend on when a module loads, and a parse error in a deferred module fails where the module is first used, not at
import. The collision check and the generated manifests read every module at import, so a deferred module is still checked and still has its
manifest. The core is derived from the declared module graph, never listed by hand, so the list has no second living version
([one-living-version](../principles/one-living-version.md)). A command that enumerates the loaded modules completes the load first, since a
partial list would be a wrong answer.

A two-phase load by a hand-written list of deciding modules carries a second load path. A file-extension map inside the importer is a second
living version of the languages configuration. Counting a module's asset or test files would let an explicit mix drop a module for a script
it only ships.

### An import names its own load

The load row decides by host and mode, and a test's child session is headless, so by the row it loads every module at import, 13 to 16 s
pooled, where a console import loads the core and the rest on first use in under 2 s. A child that runs one command or script needs no more
than a console does, while a child that proves the load itself needs every module. Only the caller knows which child it starts, so the
caller names the exception: `-ModuleLoad lazy` or `-ModuleLoad eager` replaces the row's value where the load policy is resolved, once. The
lookup hook is installed whenever a module is deferred, so the override holds under every row; a row's trigger concerns only the types. The
choice is a parameter, never an environment variable: a variable would pass to every child of that child, and a grandchild that proves the
load would inherit a choice its own test did not make.

### The console roof and the ledger

The importer is the entry to every session, so a slow import is felt by every command after it. A console import has a roof,
`import.console_seconds`, declared once on the timeouts configuration; the importer reads it after the load for its own closing line, and an
import over it warns and never fails, since an import must not throw for being slow. A slow import must also say whether it computed or
waited: each console import appends one line to the import ledger under the output folder with the seconds of each phase, the process's CPU
seconds over the same span, and the antivirus signature version, and an import over the roof names its CPU seconds at the prompt. CPU
seconds near the wall seconds mean the import computed; CPU seconds far below them mean it waited on another process, such as a scan. The
scan is the measured cause of a slow first import: the on-access scanner rescans every script the import reads after a signature update, so
the first console import after one read 14.0 s of wall for 6.5 s of CPU with file reads sixteen times slower (2026-11-07), and 5.0 s for 3.1
s once modules load on first use (2026-11-08). An import over the roof whose signature differs from the ledger's last line says so on its
closing line; the tree is not excluded from the scanner, since the exclusion is a security control of the machine, not of the repository.

The same rescan slows the first test run after a signature update: it read 235 to 248 s against 205 to 237 s warm, over its 240 s roof
(2026-11-16 and 2026-11-17). The first console import after the update knows of it, so it warms the scanner's cache: it starts one detached
process at idle priority that reads every file of the repository once, the output folder, the git folder, the environments and the build
products left out, and stops at a fixed roof of seconds however many files remain. A marker under the output folder, keyed by the signature,
makes the warmup run once per signature on the machine, whichever console imports first, and holds the file count once the read ends. The
closing line says the scanner's cache is warming in the background, under the roof too, so a busy disk has its reason at the prompt. Only a
console import warms: a test worker or a child imports through a script file and writes no ledger line. The import never waits on the warmup
and never fails for it, and reading the tree changes no control of the machine.

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

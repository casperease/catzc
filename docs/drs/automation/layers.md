# ADR-AUTO-LAYERS: the layers of the automation

## Rules: ADR-AUTO-LAYERS

### Rule ADR-AUTO-LAYERS-AUTOMATIONISABSTRACT

**automation** is the abstract: the commands and behaviours the repository offers and the doctrine that governs them, the decision-record
domain `automation` (code `AUTO`), the value-chain row `AUTO` and the concern `automation`. The word names no language, no shell and no
folder; a sentence that means the PowerShell code names its track, a sentence that means a loaded module names the module.

- [Five layers, one word each](#five-layers-one-word-each)
- [What the word covers](#what-the-word-covers)

### Rule ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION

A **command** is one public function of the module system, the unit a contract describes. A command is written in one **implementation
language**: a file language of `languages.yml` whose entry sets `executable: true`, a flag that is false unless stated
([DDR-TRACK-ONETECHSTACK](../design/tracks.md#rule-ddr-track-onetechstack),
[ADR-AUTO-MODULE-LANGUAGESFROMFILES](module-model.md#rule-adr-auto-module-languagesfromfiles)); PowerShell with the C# types it hosts is one
such language, Bash, Python and Go are the others.

- [Five layers, one word each](#five-layers-one-word-each)

### Rule ADR-AUTO-LAYERS-TOOLSRUNTHROUGHENGINE

A command's tools run through an execution engine, one of the closed set
([ADR-AUTO-ENGINE-THREEENGINES](execution-engines.md#rule-adr-auto-engine-threeengines)), and a track is named by the stack it holds, never
by the abstract: **pwsh** is the name of the PowerShell track, beside `go`, `python` and `bash`, the same word as the engine that runs it.

- [Named by the stack](#named-by-the-stack)

### Rule ADR-AUTO-LAYERS-CONTRACTATBOUNDARY

A public command's interface is stated at the repository boundary by its contract under `contracts/`, versioned with the unit that carries
it; the command itself is the implementation of that contract in one language under one engine.

- [Five layers, one word each](#five-layers-one-word-each)

### Rule ADR-AUTO-LAYERS-REALISENEVERREDEFINE

Each layer realises the one above it and never redefines it: automation, contract, language, engine, importer, read top down as what, its
interface, how it is written, how it runs, how it is assembled. Every ADR of the automation domain records the layer it belongs to as data,
the `layer` key of its entry in `drs.yml`, which defaults to `automation`; the codes never change for it.

- [Layer membership is data](#layer-membership-is-data)

### Rule ADR-AUTO-LAYERS-LEAVESCHOICEOPEN

`auto` leaves a layer's choice open: for the engine it is the value that names none
([ADR-AUTO-ENGINE-AUTONAMESNOENGINE](execution-engines.md#rule-adr-auto-engine-autonamesnoengine)), for the languages it is the languages of
the loaded modules, and in every case it resolves in the one resolution order of a setting
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

- [Five layers, one word each](#five-layers-one-word-each)

## Context

One word that means the doctrine, the value-chain row, a code folder and the layer of modules at once binds either everything or one folder,
and a reader cannot tell which. The repository runs under three engines and tests in four languages, so any one language's code is an
implementation of the abstract, not the abstract itself ([execution-engines](execution-engines.md)). Naming the layers once, each with its
own word, lets every other rule say which one it binds.

### Five layers, one word each

Automation is what the repository offers. A contract states a command's interface at the boundary, so a consumer can rely on it. A language
is what a command's source is written in. An engine is the shell the code runs under. The importer brings a chosen mix of them into a
session ([ADR-AUTO-IMPORTER-DECIDESMIX](importer.md#rule-adr-auto-importer-decidesmix)). Each layer stands on the one above and adds nothing
to it, as a language's own records stand on the automation rules.

### What the word covers

The decision-record domain, the value-chain row and the concern keep the word, because each names the abstract: the rules that govern every
implementation, the row of the stack every concern crosses, and the first stage of the chain, loading the modules and reading the
configuration. A code is a stable locator ([one-living-version](../principles/one-living-version.md)), so the layer a record belongs to is
recorded beside its code, never by renaming it.

### Named by the stack

A track owns one coherent stack and is named by it ([tracks](../design/tracks.md#rule-ddr-track-onetechstack)), so the word automation means
the abstract wherever it appears and a path that names a track names its stack. Every reader of a track's root reads it from the track
registry ([ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](module-model.md#rule-adr-auto-module-deployabletrackmodule)), so a track's folder is one
fact.

### Layer membership is data

The ADRs of the automation domain are not regrouped into folders by layer, because a folder move changes every link and buys only a view.
The `layer` key of each registry entry gives the same view as data, defaults to `automation` so that only the exceptions are written, and is
validated against the five names by the registry's config type.

## Decision

Five layers, each with one word: automation the abstract, contract its interface, language how a command is written, engine how it runs,
importer how a session is assembled. The track is named by its stack. Layer membership is a registry key, never a code change.

## Consequences

- The glossary carries automation, command, implementation language and pwsh as defined terms, each by its rule here; the layer family has
  contract, engine and importer as its forms.
- `drs.yml` carries a `layer` per automation record, validated by `DrsConfig`.
- `languages.yml` names its formatter tools `formatters`, so engine means an execution engine and nothing else.

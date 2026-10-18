---
catzc:
  immutable:
    repo_status: clean
    path: docs/adr/automation/layers.md
    folder: docs/adr/automation
    name: layers
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AUTO-LAYERS#{1-7}
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#{1,7}
      - ADR-AUTO-MODULE#{1,3}
      - ADR-DSGN-TRACK#3
    links:
      - docs/adr/automation/execution-engines.md
      - docs/adr/automation/execution-engines.md#rule-adr-auto-engine1
      - docs/adr/automation/execution-engines.md#rule-adr-auto-engine7
      - docs/adr/automation/importer.md
      - docs/adr/automation/module-model.md#rule-adr-auto-module1
      - docs/adr/automation/module-model.md#rule-adr-auto-module3
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
      - docs/adr/design/tracks.md#rule-adr-dsgn-track3
      - docs/adr/principles/one-living-version.md
      - docs/adr/pwsh/pwsh-engine.md
      - docs/adr/repository/api-contracts.md
---

# ADR-AUTO-LAYERS: the layers of the automation

## Rules: ADR-AUTO-LAYERS

### Rule ADR-AUTO-LAYERS:1

**automation** is the abstract: the commands and behaviours the repository offers and the doctrine that governs them, the ADR domain
`automation` (code `AUTO`), the value-chain row `AUTO` and the concern `automation`. The word names no language, no shell and no folder; a
sentence that means the PowerShell code names its track, a sentence that means a loaded module names the module.

- [Five layers, one word each](#five-layers-one-word-each)
- [What the word covers](#what-the-word-covers)

### Rule ADR-AUTO-LAYERS:2

A **command** is one public function of the module system, the unit a contract describes. A command is written in one **implementation
language**: one of the file languages of `languages.yml` that its track declares
([ADR-DSGN-TRACK#3](../design/tracks.md#rule-adr-dsgn-track3), [ADR-AUTO-MODULE#3](module-model.md#rule-adr-auto-module3)); PowerShell with
the C# types it hosts is one such language, Bash, Python and Go are the others.

- [Five layers, one word each](#five-layers-one-word-each)

### Rule ADR-AUTO-LAYERS:3

A command's tools run through an execution engine, one of the closed set ([ADR-AUTO-ENGINE#1](execution-engines.md#rule-adr-auto-engine1)),
and a track is named by the stack it holds, never by the abstract: **pwsh** is the name of the PowerShell track, beside `go`, `python` and
`bash`, the same word as the engine that runs it.

- [Named by the stack](#named-by-the-stack)

### Rule ADR-AUTO-LAYERS:4

The importer decides the mix a session loads, which languages, which engines and which modules, from one configuration with sensible
defaults ([ADR-AUTO-IMPORTER](importer.md)); no command, test runner or builder decides it again.

- [Five layers, one word each](#five-layers-one-word-each)

### Rule ADR-AUTO-LAYERS:5

A public command's interface is stated at the repository boundary by its contract under `contracts/`, versioned with the unit that carries
it; the command itself is the implementation of that contract in one language under one engine.

- [Five layers, one word each](#five-layers-one-word-each)

### Rule ADR-AUTO-LAYERS:6

Each layer realises the one above it and never redefines it: automation, contract, language, engine, importer, read top down as what, its
interface, how it is written, how it runs, how it is assembled. Every ADR of the automation domain records the layer it belongs to as data,
the `layer` key of its entry in `adrs.yml`, which defaults to `automation`; the codes never change for it.

- [Layer membership is data](#layer-membership-is-data)

### Rule ADR-AUTO-LAYERS:7

`auto` leaves a layer's choice open: for the engine it is the value that names none
([ADR-AUTO-ENGINE#7](execution-engines.md#rule-adr-auto-engine7)), for the languages it is the languages of the loaded modules, and in every
case it resolves in the one resolution order of a setting ([ADR-AUTO-DEFAULT#6](sensible-defaults.md#rule-adr-auto-default6)).

- [Five layers, one word each](#five-layers-one-word-each)

## Context

One word, automation, carried four meanings: the doctrine of the `ADR-AUTO-*` rules, the value-chain row and concern, the folder that holds
the PowerShell modules, and the layer those modules form. A reader could not tell from a sentence which was meant, and a rule that said
"automation" bound either everything or one folder. The repository runs under three engines and tests in four languages, so the PowerShell
code is one implementation of the abstract, not the abstract itself ([execution-engines](execution-engines.md)). Naming the layers once, and
giving each its own word, lets every later rule say which one it binds.

### Five layers, one word each

Automation is what the repository offers. A contract states a command's interface at the boundary, so a consumer can rely on it
([api-contracts](../repository/api-contracts.md)). A language is what a command's source is written in. An engine is the shell the code runs
under. The importer brings a chosen mix of them into a session. Reading down the list answers "what, interface, how written, how run, how
assembled"; each answer stands on the one above and adds nothing to it, the stance the PowerShell rules already take toward the automation
rules ([pwsh-engine](../pwsh/pwsh-engine.md)).

### What the word covers

The ADR domain, the value-chain row and the concern keep the word, because each names the abstract: the rules that govern every
implementation, the row of the stack every concern crosses, and the first stage of the chain, loading the modules and reading the
configuration. About ten thousand citations of `ADR-AUTO-*` codes stay as they are; a code is a stable locator
([one-living-version](../principles/one-living-version.md)), and the layer an ADR belongs to is recorded beside it, never by renaming it.

### Named by the stack

A track owns one coherent stack and is named by it ([tracks](../design/tracks.md#rule-adr-dsgn-track3)): `go`, `python` and `bash` are the
test-artifact tracks, and the PowerShell track is `pwsh`, the name of the engine that runs it and of nothing else. The word automation then
means the abstract wherever it appears, and a path that names a track names its stack. The code track's folder is the one place that still
carries the old name; moving it is a single change, made in one quiet window, and every reader of the root reads it from the track registry
([ADR-AUTO-MODULE#1](module-model.md#rule-adr-auto-module1)), so the move changes a folder and nothing else.

### Layer membership is data

The ADRs of the automation domain are not regrouped into folders by layer, because a folder move changes every link and buys only a view.
The `layer` key of each registry entry gives the same view as data, defaults to `automation` so that only the exceptions are written, and is
validated against the five names by the registry's config type.

## Decision

Five layers, each with one word: automation the abstract, contract its interface, language how a command is written, engine how it runs,
importer how a session is assembled. The track is named by its stack. Layer membership is a registry key, never a code change.

## Consequences

- The glossary carries automation, command, implementation language and pwsh as defined terms, each by its rule here; the layer family gains
  contract, engine and importer as its forms.
- `adrs.yml` carries a `layer` per automation ADR, validated by `AdrsConfig`; the index and the codes are unchanged.
- The code track's folder is renamed to `pwsh` in one quiet window; every root is read through the track registry, so the rename is the only
  change.
- `languages.yml` names its formatter tools `formatters`, so engine means an execution engine and nothing else.

# Catzc.Base.Modules

The one resolver of a module: for every deployable track it finds the modules the track's places hold, and returns each as one
`Catzc.Base.Modules.Module` with its name, track, module type, place, root, shape, files, languages, engines and the files its layout does
not place ([module-model](../../drs/automation/module-model.md), ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE and ADR-AUTO-MODULE-EXISTSBYLAYOUT).
It also owns the aspect convention of a track, the ordered first-match classification that says which of a unit's files are live and which
are not ([module-aspects](../../drs/design/module-aspects.md)). It does not hold the dependency graph, the module order or the integrity
tests; those read its module list and live in [Catzc.Base.ModuleSystem](catzc-base-module-system.md). It does not declare the tracks, the
layout or the module types either; it reads them from [Catzc.Base.Variants](catzc-base-variants.md) and
[Catzc.Base.Languages](catzc-base-languages.md).

## Responsibilities

| Responsibility   | Area    | Name                                                             |
| ---------------- | ------- | ---------------------------------------------------------------- |
| responsibility:1 | resolve | [Module resolution](#responsibility1--module-resolution)         |
| responsibility:2 | aspects | [Aspect classification](#responsibility2--aspect-classification) |

### responsibility:1 — Module resolution

Answering "which modules exist, and what is each made of" from the configuration alone. For each deployable track, by its track type, the
resolver takes the module types the track type admits, finds the modules those types place under the track's places, and reads each module
from its files: a module exists when its files stand in the layout, so nothing registers it. Its languages are those of its live files, its
engines come from the track with a per-module override, and a file in no layout row is reported by name for a module whose track's primary
language owns a layout. No track root is spelled here; the code track is anchored on the loaded code root, and a fixture tree isolates a
logic test.

### responsibility:2 — Aspect classification

Saying which part of a unit each file belongs to. An aspect convention is an ordered list of named patterns, matched first to last, whose
last entry is the catch-all. A code track derives its convention from the layout: `live` is the layout's live rows, kept closed so a stray
file falls to the `tests` catch-all and never ships. Any other track takes the convention its `aspects` entry in `variants.yml` declares,
read through [Catzc.Base.Variants](catzc-base-variants.md), else the built-in one for its track type: a deployment makes `live` the
catch-all, so everything under a template ships and only an explicit tests folder is non-live.

## What the module does

The module turns the registries into a list of modules and a classification of their files, and nothing else. Responsibility 1 is the
resolver every other module-aware command calls: the module system's graph and order, the exporter's bundle, the quality gates' scopes all
start from `Get-CatzcModule` instead of walking folders of their own, so a track's root is read from the track and nowhere spelled
(ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE). Responsibility 2 gives the globs engine the patterns it compiles into a scan, so the same table
that lays a module out also decides what of it ships.

The module sits low in the dependency graph: it needs the tracks and track types of `Catzc.Base.Variants`, the layout and languages of
`Catzc.Base.Languages`, and the engines, and it is called by everything above them. The loader that imports the modules cannot call it, so a
test holds the loader's own folder rules to the same layout.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                           | Function          |
| ---------------------------------------- | ----------------- |
| responsibility:1 — Module resolution     | `Get-CatzcModule` |
| responsibility:2 — Aspect classification | `Get-Aspect`      |

# Design: Module aspects — a unit's files partition into live and tests

## Rules: DDR-ASPECT

### Rule DDR-ASPECT-MODULESPARTITIONED

Every module (and, at track granularity, every delivery package) **partitions** its tracked files into named **aspects** that are pairwise
**disjoint** and jointly **exhaustive** — a true partition, no file in two aspects and no file in none. The aspect set is an ordered
first-match ("fallthrough") classification, `live` then `tests` for a code track — the prod-going artifacts (`live`, what ships) and the
means to verify them (`tests`). A code track derives it from its module layout; any other track declares it in the `aspects` repo-wide
variant (`Catzc.Base.Variants`).

- [Context](#context)
- [Decision](#decision)

### Rule DDR-ASPECT-ASPECTSAREDERIVED

Aspects are **auto-derived** from folder conventions, never hand-declared. `live` is a **closed** convention (the folder-scoped patterns of
the layout's live rows — `*.ps1`, `private/**`, `types/**`, `configs/**`, `assets/**` — that never reach `tests/`, and are what the builder
ships); the **last** aspect is the `**` catch-all remainder. Ordered first-match makes the partition disjoint and exhaustive _by
construction_: `AspectPartition.Compile` gives aspect _k_ the leaf scan program `+ (its own patterns) − (every earlier aspect's patterns)`,
all prefixed by the unit root.

- [Decision](#decision)

### Rule DDR-ASPECT-TRACKPICKSCATCHALL

Which aspect is the catch-all remainder is each **track's** call. A **code** track (`pwsh`) keeps `live` closed and declares the non-live
`tests` last, so a stray or unclassified file lands on the verification side and can **never silently ship** (default-deny). A
**deployment** track (`infrastructure`) declares `live` last, because everything under a template deploys, and only an explicit `tests/`
folder is non-live. The `VariantsConfig` config type enforces the structure at load: the last aspect is the `**` catch-all, and no earlier
aspect uses it.

- [Decision](#decision)
- [Consequences](#consequences)

### Rule DDR-ASPECT-ISAGLOBSET

Each aspect is its own derived globset, `<unit>-<aspect>`, with its own live durable-SHA identity and nothing committed per set. A unit's
two aspects are therefore **two independent identities** — one `live`, one `tests`: a `tests`-only change never re-keys `live`, and a
runtime change never re-keys `tests`. A unit's rolled-up identity is the fold of its aspect identities, not a separate whole-unit hash,
which would re-key on any change and defeat the isolation. Single-file units (internal `.psm1` modules) have no `tests/`, so they carry the
degenerate one-aspect partition.

- [Context](#context)
- [Consequences](#consequences)

### Rule DDR-ASPECT-PARTITIONISCHECKED

The partition invariant — disjoint + exhaustive over `git ls-files` — is an integrity check: a file claimed by two aspects, or by none,
fails it (`AspectPartition.Validate`). The `module-leftovers` catch-all is the module-space complement — files under `pwsh/` that no module
partition claims — and stays empty in a clean tree.

- [Decision](#decision)

## Context

A module is not one fileset — it holds two kinds of thing with opposite roles: the runtime code that ships to production, and the tests that
verify it. Collapsing them into one set means a test-only edit re-keys the module's identity, firing everything downstream that keys on "did
this module change" — even though nothing shippable moved. Isolation demands they be separate, versioned areas-of-control.

## Decision

Aspects make the split first-class and fail-safe. In the code track everything `live` does not claim — tests, docs, editor droppings, a file
dropped at a module's root — falls through to `tests`, so a new file can only enter `live` by an explicit convention change, never by
accident.

The convention lives in the `aspects` variant so the vocabulary can evolve (a future `config`/`docs` aspect is one more ordered rule, and
each track still names its own remainder) without touching the engine. `Catzc.Base.Globs` reads it through `Get-Aspect` and compiles per
unit root with `AspectPartition`; `Get-ModuleGlobSet` derives `<module>-live` / `<module>-tests`, each with its own identity.

## Consequences

- **Isolated identities.** A test edit and a runtime edit re-key different identities; downstream (protection, blast-radius, triggers) sees
  the precise one.
- **Fail-safe shipping of code.** In the code track an unclassified file defaults to non-live — it cannot ride into production unnoticed. A
  deployment track ships a template whole, so there the explicit `tests/` folder is the only non-live part.
- **One convention, many granularities.** The same ordered rule set that partitions a module is what a track's `-live`/`-tests` delivery
  packages use when derived — one convention, module and track alike.
- **Protection covers the whole module.** A module's protection identity folds both aspect hashes (`Get-ModuleProtectionIdentity`), so it
  covers the module's whole content — the split refines the identities, not what a module's tests depend on.

# docs/adr/design/module-aspects.md

`ADR: Module aspects — a unit's files partition into live and tests`

## Rules: ADR-DSGN-ASPECT

### Rule ADR-DSGN-ASPECT:1

Every module (and, at track granularity, every delivery package) **partitions** its tracked files into named **aspects** that are pairwise
**disjoint** and jointly **exhaustive** — a true partition, no file in two aspects and no file in none. The aspect set is the `aspects`
repo-wide variant (`Catzc.Base.Variants`): an ordered first-match ("fallthrough") classification, defaulting to `live` then `tests` — the
prod-going artifacts (`live`, what ships) and the means to verify them (`tests`).

- [Context](#context)
- [Decision](#decision)

### Rule ADR-DSGN-ASPECT:2

Aspects are **auto-derived** from folder conventions, never hand-declared. `live` is a **closed** convention (folder-scoped patterns —
`*.ps1`, `private/**`, `types/**`, `configs/**`, `assets/**` — that never reach `tests/`, and are what the builder ships); the **last**
aspect is the `**` catch-all remainder. Ordered first-match makes the partition disjoint and exhaustive _by construction_:
`AspectPartition.Compile` gives aspect _k_ the leaf scan program `+ (its own patterns) − (every earlier aspect's patterns)`, all prefixed by
the unit root.

- [Decision](#decision)

### Rule ADR-DSGN-ASPECT:3

Which aspect is the catch-all remainder is each **track's** call, declared in its `aspects` entry. A **code** track (`automation`) keeps
`live` closed and declares the non-live `tests` last, so a stray or unclassified file lands on the verification side and can **never
silently ship** (default-deny). A **deployment** track (`infrastructure`) declares `live` last, because everything under a template deploys,
and only an explicit `tests/` folder is non-live. The `VariantsConfig` config type enforces the structure at load: the last aspect is the
`**` catch-all, and no earlier aspect uses it.

- [Decision](#decision)
- [Consequences](#consequences)

### Rule ADR-DSGN-ASPECT:4

Each aspect is an immutable sha lock, marker `<unit>-<aspect>.yml`. A shipped unit is therefore **1 + 1 = 2 immutable, versioned artifacts**
— one `live`, one `tests` — stored and versioned independently: a `tests`-only change never re-keys `live`, and a runtime change never
re-keys `tests`. A unit's rolled-up identity is the _set_ of its aspect locks, not a separate whole-unit marker (such a marker's sha would
re-key on any change, defeating the isolation). Single-file units (internal `.psm1` modules) have no `tests/`, so they carry the degenerate
one-artifact partition.

- [Context](#context)
- [Consequences](#consequences)

### Rule ADR-DSGN-ASPECT:5

The partition invariant — disjoint + exhaustive over `git ls-files` — is an integrity check: a file claimed by two aspects, or by none,
fails it (`AspectPartition.Validate`). The `module-leftovers` catch-all is the module-space complement — files under `automation/` that no
module partition claims — and stays empty in a clean tree.

- [Decision](#decision)

## Context

A module is not one fileset — it holds two kinds of thing with opposite roles: the runtime code that ships to production, and the tests that
verify it. Collapsing them into one set means a test-only edit re-keys the module's identity, firing everything downstream that keys on "did
this module change" — even though nothing shippable moved. Isolation demands they be separate, versioned areas-of-control.

## Decision

Aspects make the split first-class and fail-safe. In the code track the `live` surface is a **closed, explicit** convention; everything it
does not claim — tests, docs, editor droppings, a file dropped at a module's root — falls through to the non-live `tests` remainder.
Shipping code is therefore default-deny: a new file can only enter `live` by an explicit convention change, never by accident. A deployment
track inverts the remainder: a template ships whole, so its `tests` is the closed, explicit head and `live` is the remainder. The two
aspects partition the module exactly (ordered first-match with a `**` remainder guarantees it), and each is locked and versioned on its own.

The convention lives in the `aspects` variant so the vocabulary can evolve (a future `config`/`docs` aspect is one more ordered rule, and
each track still names its own remainder) without touching the engine. `Catzc.Base.Globs` reads it through `Get-Aspect` and compiles per
unit root with `AspectPartition`; `Get-ModuleGlobSet` derives `<module>-live` / `<module>-tests` and their markers.

## Consequences

- **Isolated identities.** A test edit and a runtime edit touch different markers; downstream (protection, blast-radius, triggers) sees the
  precise one.
- **Fail-safe shipping of code.** In the code track an unclassified file defaults to non-live — it cannot ride into production unnoticed. A
  deployment track ships a template whole, so there the explicit `tests/` folder is the only non-live part.
- **One convention, many granularities.** The same ordered rule set that partitions a module is what a track's `-live`/`-tests` delivery
  packages use when derived — one convention, module and track alike.
- **Protection covers the whole module.** A module's protection identity folds both aspect hashes (`Get-ModuleProtectionIdentity`), so it
  covers the module's whole content — the split refines the markers, not what a module's tests depend on.

## Related

- [durable-sha-globs](../flow/durable-sha-globs.md) — the marker mechanism, the scan program (`ADR-FLOW-CD-GLOBS:4`), the layers
  (`ADR-FLOW-CD-GLOBS:7`), and the immutable sha lock each aspect is (`ADR-FLOW-CD-GLOBS#9`)
- [repo-variants](../repository/repo-variants.md) — the `aspects` variant's home (`ADR-REPO-VARIANT`)
- [protected-globs](../repository/protected-globs.md) — the `module-leftovers` catch-all (`ADR-REPO-PROTGLOB`)
- [test-automation](../automation/test-automation.md) — logic vs integrity tests, the `tests/` surface aspects isolate
- [platform-bundle](../automation/platform-bundle.md) — the build's runtime payload, deliberately broader than `live`

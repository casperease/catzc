# ADR: Module aspects — a unit's files partition into live and tests

## Rules: ADR-ASPECT

### Rule ADR-ASPECT:1

Every module (and, at track granularity, every delivery package) **partitions** its tracked files into named **aspects** that are pairwise
**disjoint** and jointly **exhaustive** — a true partition, no file in two aspects and no file in none. The aspect set is the `aspects`
repo-wide variant (`Catzc.Base.Variants`, `ADR-REPO-VARIANT`): an ordered first-match ("fallthrough") classification, defaulting to `live`
then `tests` — the prod-going artifacts (`live`, what ships) and the means to verify them (`tests`).

### Rule ADR-ASPECT:2

Aspects are **auto-derived** from folder conventions, never hand-declared. `live` is a **closed** convention (folder-scoped patterns —
`*.ps1`, `private/**`, `types/**`, `configs/**` — that never reach `tests/`); the **last** aspect is the `**` catch-all remainder. Ordered
first-match makes the partition disjoint and exhaustive _by construction_: `AspectPartition.Compile` gives aspect _k_ the leaf scan program
`+ (its own patterns) − (every earlier aspect's patterns)`, all prefixed by the unit root (`ADR-FLOW-CD-GLOBS:4`).

### Rule ADR-ASPECT:3

The catch-all remainder is **non-live** (`tests` is declared last). `live` — the shipped surface — is never the fallthrough, so a stray or
unclassified file lands on the verification side and can **never silently ship** (default-deny). `Assert-VariantsConfig` and the aspect type
enforce this: the last aspect is the `**` catch-all, that aspect is not `live`, and `live` uses only closed patterns.

### Rule ADR-ASPECT:4

Each aspect is an immutable sha lock (`ADR-FLOW-CD-GLOBS:9`), marker `<unit>-<aspect>.yml`. A shipped unit is therefore **1 + 1 = 2
immutable, versioned artifacts** — one `live`, one `tests` — stored and versioned independently: a `tests`-only change never re-keys `live`,
and a runtime change never re-keys `tests`. A unit's rolled-up identity is the _set_ of its aspect locks, not a separate whole-unit marker
(that marker is dropped — its sha would re-key on any change, defeating the isolation). Single-file units (internal `.psm1` modules) have no
`tests/`, so they carry the degenerate one-artifact partition.

### Rule ADR-ASPECT:5

The partition invariant — disjoint + exhaustive over `git ls-files` — is an integrity gate: a file claimed by two aspects, or by none, fails
it (`AspectPartition.Validate`). The `module-leftovers` catch-all (`ADR-REPO-PROTGLOB`) is the module-space complement — files under
`automation/` that no module partition claims — and stays empty in a clean tree.

## Context

A module is not one fileset — it holds two kinds of thing with opposite roles: the runtime code that ships to production, and the tests that
verify it. Collapsing them into one set means a test-only edit re-keys the module's identity, firing everything downstream that keys on "did
this module change" — even though nothing shippable moved. Isolation demands they be separate, versioned areas-of-control.

## Decision

Aspects make the split first-class and fail-safe. The `live` surface is a **closed, explicit** convention; everything it does not claim —
tests, docs, editor droppings, a file dropped at a module's root — falls through to the non-live `tests` remainder. Shipping is therefore
default-deny: a new file can only enter `live` by an explicit convention change, never by accident. The two aspects partition the module
exactly (ordered first-match with a `**` remainder guarantees it), and each is locked and versioned on its own.

The convention lives in the `aspects` variant so the vocabulary can evolve (a future `config`/`docs` aspect is one more ordered rule, `live`
still the closed head and the `**` remainder still non-live) without touching the engine. `Catzc.Base.Globs` reads it through `Get-Aspect`
and compiles per unit root with `AspectPartition`; `Get-ModuleGlobSet` derives `<module>-live` / `<module>-tests` and their markers.

## Consequences

- **Isolated identities.** A test edit and a runtime edit touch different markers; downstream (protection, blast-radius, triggers) sees the
  precise one.
- **Fail-safe shipping.** An unclassified file defaults to non-live — it cannot ride into production unnoticed.
- **One convention, many granularities.** The same ordered rule set that partitions a module is what a track's `-live`/`-tests` delivery
  packages use when derived — one convention, module and track alike.
- **Protection unchanged in meaning.** A module's protection identity folds both aspect hashes (`Get-ModuleProtectionIdentity`), reproducing
  the pre-aspect whole-module identity — the split refines the markers, not what a module's tests depend on.

## Related

- [durable-sha-globs](../flow/durable-sha-globs.md) — the marker mechanism, the scan program (`ADR-FLOW-CD-GLOBS:4`), the layers
  (`ADR-FLOW-CD-GLOBS:7`)
- [repo-variants](../repository/repo-variants.md) — the `aspects` variant's home (`ADR-REPO-VARIANT`)
- [test-automation](../automation/test-automation.md) — logic vs integrity tests, the `tests/` surface aspects isolate

## Dora explains

DORA identifies loosely coupled teams and code maintainability as predictors of delivery performance. Partitioning modules into live and
test aspects creates clear ownership boundaries, prevents accidental shipping of unreviewed code, and enables independent reasoning about
each concern.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — aspects partition code and tests, enabling independent
  change and verification.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — explicit, convention-driven partitions reduce cognitive load
  and prevent silent errors.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

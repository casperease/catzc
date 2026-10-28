# The quality gate on config checks that ** is last; whether the remainder ships is each track's unchecked call

```text
The quality gate on config checks that ** is last; whether the remainder ships is each track's unchecked call.

1  live                      pwsh's closed convention: no gate checks that it stays closed
2  tests                     pwsh's remainder: that it is the non-live one is the track's call
3  VariantsConfig            the gate: the last aspect is the bare **, and no earlier aspect uses it
4  AspectPartition.Validate  the partition check: unit tests on fixtures are its only callers
5  tests                     infrastructure's closed head: the explicit tests/ folders
6  live                      infrastructure's remainder: that it ships is the track's call

Supports DDR-ASPECT-ASPECTSAREDERIVED, DDR-ASPECT-TRACKPICKSCATCHALL and DDR-ASPECT-PARTITIONISCHECKED (governance lens).
```

The aspect convention of cats has one real quality gate, and it checks shape, not meaning. When the variants config loads, the config type
refuses any track whose last aspect is not the bare `**`, or that uses `**` anywhere earlier, so the remainder is always exactly one aspect
and always last. Which aspect that is, and so whether a stray file ships or not, is each track's declaration, and no gate reads it. The
partition check that the DDR describes exists in code, but only unit tests on fixture files call it.

```yml drawio
description:
  "The one real gate on the aspect convention checks shape: the variants config refuses any track whose last aspect is not the bare
  remainder; whether the remainder ships is each track's unchecked declaration, and the partition check runs only in unit tests."
about:
  rules: [DDR-ASPECT-ASPECTSAREDERIVED, DDR-ASPECT-TRACKPICKSCATCHALL, DDR-ASPECT-PARTITIONISCHECKED]
  lens: governance
content:
  title: The quality gate on config checks that ** is last; whether the remainder ships is each track's unchecked call
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-code, label: PWSH }
    - { id: band-deployment, label: INFRASTRUCTURE }
  glyphs:
    - { id: s-code-live, kind: set, label: live, in: band-code }
    - { id: s-code-tests, kind: set, label: tests, in: band-code }
    - { id: g-partition, kind: gate, label: AspectPartition.Validate, in: band-code }
    - { id: g-config, kind: gate, label: VariantsConfig, in: band-code }
    - { id: s-deployment-tests, kind: set, label: tests, in: band-deployment }
    - { id: s-deployment-live, kind: set, label: live, in: band-deployment }
    - { id: g-config-deployment, kind: gate, label: VariantsConfig, in: band-deployment }
  edges:
    - { from: g-partition, to: s-code-live, kind: record, label: "" }
    - { from: g-config, to: s-code-tests, kind: flow, label: "" }
    - { from: g-config-deployment, to: s-deployment-live, kind: flow, label: "" }
  markers:
    - { at: s-code-live, number: 1 }
    - { at: s-code-tests, number: 2 }
    - { at: g-config, number: 3 }
    - { at: g-partition, number: 4 }
    - { at: s-deployment-tests, number: 5 }
    - { at: s-deployment-live, number: 6 }
  chips:
    - { at: s-code-live, kind: rule, rule: DDR-ASPECT-ASPECTSAREDERIVED, gated: false }
    - { at: s-code-tests, kind: rule, rule: DDR-ASPECT-TRACKPICKSCATCHALL, gated: false }
    - { at: g-config, kind: rule, rule: DDR-ASPECT-TRACKPICKSCATCHALL }
    - { at: g-partition, kind: rule, rule: DDR-ASPECT-PARTITIONISCHECKED, gated: false }
    - { at: s-deployment-live, kind: rule, rule: DDR-ASPECT-TRACKPICKSCATCHALL, gated: false }
    - { at: g-config-deployment, kind: rule, rule: DDR-ASPECT-TRACKPICKSCATCHALL }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-code: { x: 20, y: 84, w: 610, h: 300 }
  band-deployment: { x: 650, y: 84, w: 630, h: 300 }
  s-code-live: { x: 40, y: 176, w: 270, h: 44 }
  s-code-tests: { x: 40, y: 296, w: 270, h: 44 }
  g-partition: { x: 360, y: 150, w: 240, h: 76 }
  g-config: { x: 360, y: 270, w: 240, h: 76 }
  s-deployment-tests: { x: 670, y: 176, w: 300, h: 44 }
  s-deployment-live: { x: 670, y: 296, w: 300, h: 44 }
  g-config-deployment: { x: 1010, y: 280, w: 240, h: 76 }
```

![The gate checks order, not liveness](.assets/gate-checks-order-not-liveness.drawio.png)

## Walkthrough

1. **live, in the pwsh track.** The closed convention of DDR-ASPECT-ASPECTSAREDERIVED: folder-scoped patterns that never reach `tests/`. The
   rule is DRS-only in this respect: no gate checks that the patterns stay closed, and a pattern that reached `tests/` would load.
2. **tests, in the pwsh track.** The remainder. That the code track's remainder is the non-live aspect, so that a stray file never ships, is
   the track's own declaration in its `aspects` entry. A unit test proves it on a fixture module; no gate checks the real convention for it.
3. **VariantsConfig.** The gate, run per track entry when the config loads. The last aspect must be the single pattern `**`, and no earlier
   aspect may use the bare `**`; names must be kebab-case and unique, and every aspect needs a pattern. The same check runs for the
   infrastructure entry.
4. **AspectPartition.Validate.** The disjoint-and-exhaustive check of DDR-ASPECT-PARTITIONISCHECKED over a file universe: a file claimed by
   two aspects, or by none, is a violation. The type's own comment calls it the integrity check, but its only callers are the aspect unit
   tests, so on the real tree it is DRS-only.
5. **tests, in the infrastructure track.** The deployment track's closed head, `**/tests/**`. Only the gate's structural checks apply to it.
6. **live, in the infrastructure track.** The deployment track's remainder, and the one that ships. Its liveness is a declaration like the
   pwsh one, unchecked by any gate; and no code derives an infrastructure globset from it, so the partition check could not run there even
   if it were wired.

## Why it holds

- `live` is a closed convention and the last aspect is the `**` catch-all remainder (DDR-ASPECT-ASPECTSAREDERIVED).
- Which aspect is the remainder is each track's call, and the config type enforces the structure at load: the last aspect is `**`, and no
  earlier one uses it (DDR-ASPECT-TRACKPICKSCATCHALL).
- A file claimed by two aspects, or by none, fails the partition integrity check (DDR-ASPECT-PARTITIONISCHECKED).

## Where the code and the decision record differ

- The DDR makes the partition invariant an integrity check over `git ls-files`, and the type's reference page (`Aspect.cs.md`) says
  `AspectPartition.Validate` re-checks for the integrity tests; no gate runs it on the real tree.
- The DDR partitions every delivery package at track granularity by the same convention; no code derives a track's delivery packages, and
  the infrastructure convention only classifies files for the world map.
- The reference page of the aspect type (`Aspect.cs.md`) says the last aspect is non-live by rule; the infrastructure track declares `live`
  last.

## See also

- [Module aspects](../../drs/design/module-aspects.md) — the decision this article explains.
- The other lenses on the same catch-all: [meta](each-track-picks-its-catch-all.md), [architecture](only-pwsh-compiles-its-aspects.md),
  [implementation](get-aspect-feeds-globs-and-maps.md) and [operations](get-aspect-names-the-remainder.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

# Each track picks its catch-all: a stray module file falls to tests, a stray template file to live

```text
Each track picks its catch-all: a stray module file falls to tests, a stray template file to live.

1  a tracked file of a unit  any file git tracks under a module folder or a template
2  live                      the code track's first aspect: a closed convention, what ships
3  tests                     the code track's last aspect: the ** remainder, never ships
4  tests                     the deployment track's first aspect: only an explicit tests/ folder
5  live                      the deployment track's last aspect: the ** remainder, it ships

Supports DDR-ASPECT-MODULESPARTITIONINTOASPECTS, DDR-ASPECT-ASPECTSAREDERIVED and DDR-ASPECT-TRACKPICKSCATCHALL (meta lens).
```

A unit in cats, a module folder or a template, holds files that ship and files that verify them. Its tracked files partition into aspects by
ordered first match: a file is tried against the aspects in their declared order, and the last aspect, the bare `**`, takes whatever no
earlier aspect claimed. Which aspect is that remainder is each track's call. The pwsh track keeps `live` closed and lets `tests` catch the
rest, so a stray file can never silently ship. The infrastructure track declares the opposite order, because a template deploys whole.

![Each track picks its catch-all](.assets/each-track-picks-its-catch-all/diagram.drawio.png)

## Walkthrough

1. **A tracked file of a unit.** Any file git tracks under a module folder of the pwsh track, or under a template of the infrastructure
   track. Each track declares its own ordered list of aspects in the `aspects` variant, and the file is tried against that list from the
   top. The first aspect whose pattern matches claims it.
2. **live, in the pwsh track.** The first aspect of a code track is a closed convention: `*.ps1`, `private/**`, `types/**`, `configs/**` and
   `assets/**`, folder-scoped patterns that never reach `tests/`. A `*` inside a segment never crosses a `/`, so `*.ps1` claims the module's
   root files only. This is what the builder ships, and a new kind of file enters it only through an explicit change to the convention.
3. **tests, in the pwsh track.** The last aspect of a code track is the `**` remainder: every file `live` did not claim. Tests, docs, a file
   dropped at the module root, all land here, and none of it ships. Shipping code is default-deny.
4. **tests, in the infrastructure track.** A deployment track puts the non-live part first and keeps it closed: `**/tests/**`, an explicit
   `tests/` folder anywhere under the template, is the only part that does not deploy.
5. **live, in the infrastructure track.** The last aspect of a deployment track is `live`, the `**` remainder. Everything else under a
   template deploys, so a stray template file ships. The track's class backs the choice: the pwsh track is the core, infrastructure an
   adapter to a delivery target.

## Why it holds

- A unit's tracked files partition into aspects that are pairwise disjoint and jointly exhaustive, and the aspect set is the `aspects`
  variant, an ordered first-match classification per track (DDR-ASPECT-MODULESPARTITIONINTOASPECTS).
- Aspects derive from folder conventions, never from a hand-written list. `live` is a closed convention, the last aspect is the `**`
  remainder, and ordered first match makes the partition true by construction (DDR-ASPECT-ASPECTSAREDERIVED).
- Which aspect is the remainder is the track's call: a code track declares the non-live `tests` last, a deployment track declares `live`
  last, and the config type checks the structure when the variants load (DDR-ASPECT-TRACKPICKSCATCHALL).

## Where the code and the decision record differ

- The ADR partitions every delivery package at track granularity by the same convention. In the code, only the module folders of the pwsh
  track are compiled into aspect sets; the infrastructure convention is read and classifies files as live or not, but no set is derived from
  it.
- The reference page of the aspect type (`Aspect.cs.md`) says the last aspect is non-live by rule; the infrastructure track declares `live`
  last.

## See also

- [Module aspects](../../drs/design/module-aspects.md) — the decision this article explains.
- The other lenses on the same catch-all: [architecture](only-pwsh-compiles-its-aspects.md),
  [implementation](get-aspect-feeds-globs-and-maps.md), [operations](get-aspect-names-the-remainder.md) and
  [governance](gate-checks-order-not-liveness.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

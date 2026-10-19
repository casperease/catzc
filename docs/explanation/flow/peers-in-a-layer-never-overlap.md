# Peers in a layer never share a file, except in the loose-fileset layer

```text
Peers in a layer never share a file on their own contribution; only loose-filesets may overlap.

1  What ships               the deployable-unit layer: one boundary per unit that ships
2  Cross-cutting surfaces   the loose-fileset layer: overlaps the other layers by design
3  Module space             the module layer: derived from the folders, never declared
4  Peers disjoint           the one rule, checked by a gate for the two boundary layers

Supports ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER and ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER (meta lens).
```

Every globset in cats belongs to one layer, and a layer is a set of peers that partition one concern into boundaries. Within a layer, no two
peers share a file on their own contribution, because overlap would mean one boundary consumes another's files. The `loose-fileset` layer,
which cuts across the others, is the only exemption, and across layers one file may sit in all three.

![Peers in a layer never overlap, except loose-filesets](.assets/peers-in-a-layer-never-overlap/diagram.drawio.png)

## Walkthrough

1. **What ships.** The `deployable-unit` layer is declared: one boundary per unit that ships. A unit never consumes another unit's files.
2. **Cross-cutting surfaces.** The `loose-fileset` layer holds track roots, scan scopes and the reserved umbrellas. Its sets overlap the
   boundaries of the other two layers by design, so nothing checks its peers against each other, and it stands alone.
3. **Module space.** The `module` layer is derived from the folders and never declared: aspect sets per module folder, one set per internal
   shared module file, and a catch-all for module-space files no module owns. A module never consumes another module's files.
4. **Peers disjoint.** The one rule: peers in a layer are disjoint on their own files, with composition ignored, and a gate checks it for
   the `deployable-unit` and `module` layers. A file under `pwsh/Catzc.Base.Globs/` still belongs to the `automation` track, to a module set
   and, if it ships, to a deployable-unit, because overlap across layers is expected.

## Why it holds

- Every globset carries a layer: two are declared, and `module` is derived-only (ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER).
- Within a layer, no two globsets select a common file on their own contribution; the rule is per layer, never across, and the
  `loose-fileset` layer is exempt (ADR-FLOW-CD-GLOBS-NOOVERLAPWITHINLAYER).

## Where the code and the ADR differ

The ADR describes one module set per folder. The code derives two aspect sets per folder, `-live` and `-tests`, and no whole-module set.

## See also

- [Globset triggers](../../adr/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same layers: [architecture](two-declared-layers-one-derived.md),
  [implementation](independence-check-groups-by-layer.md), [operations](declare-or-add-folder-gate-names-overlaps.md) and
  [governance](overlap-gated-for-units-and-modules.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

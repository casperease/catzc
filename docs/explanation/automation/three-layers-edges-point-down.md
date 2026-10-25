# Module dependencies form three layers, and every edge points down

```text
Module dependencies form three layers, and every allowed edge points down.

1  AzureExt             top layer: the five Azure extension modules, one group
2  Catzc.Azure          middle layer: the Azure root, one module
3  Tooling              middle layer: the six external-tool modules, one group
4  Github, KeyHandler,  middle layer: five Tooling modules that belong to no group
   Inspiration, Listen,
   Claude
5  Base                 foundation: 34 libraries that everything rests on
6  Cli -> Tooling.Core  the one edge from the top layer to a single Tooling module

Supports ADR-AUTO-DEPM-CODEBUILTFROM, ADR-AUTO-DEPM-TWOSECTIONS and ADR-AUTO-DEPM-GROUPAWAREINTEGRITY (architecture lens).
```

Cats is built from fifty-one PowerShell modules that call one another. To keep that web from tangling, every dependency between modules is
declared up front in one file, `dependencies.yml`, and the declaration is the allow-list: an edge the file does not permit fails the build.
Seen from far enough away, the declared graph has a simple shape. The modules sit in three layers, and every allowed dependency points down
to a lower one.

```yml drawio
description:
  "Module dependencies form three layers: the Azure extension group on top, the Azure root and the tooling modules in the middle, and the
  base libraries as the foundation; every allowed edge points down."
about:
  adrs: [ADR-AUTO-DEPM-CODEBUILTFROM, ADR-AUTO-DEPM-TWOSECTIONS, ADR-AUTO-DEPM-GROUPAWAREINTEGRITY]
  lens: architecture
content:
  title: Module dependencies form three layers, and every edge points down
  kind: explanation
  flow: top-to-bottom
  relation: may depend on
  theme: dark
  bands:
    - { id: band-top, label: TOP LAYER }
    - { id: band-middle, label: MIDDLE LAYER }
    - { id: band-foundation, label: FOUNDATION }
  glyphs:
    - { id: s-azure-ext, kind: set, label: AzureExt, in: band-top }
    - { id: g-azure, kind: code, label: Catzc.Azure, in: band-middle }
    - { id: g-core, kind: code, label: Tooling.Core, in: band-middle }
    - { id: s-tooling, kind: set, label: Tooling, in: band-middle }
    - { id: g-github, kind: code, label: Github · KeyHandler · Inspiration · Listen · Claude, in: band-middle }
    - { id: s-base, kind: set, label: Base, in: band-foundation }
  edges:
    - { from: s-azure-ext, to: g-azure, kind: flow, label: 4/5 }
    - { from: s-azure-ext, to: s-base, kind: thick, label: 5/5 }
    - { from: s-azure-ext, to: s-tooling, kind: thick, label: 3/5 }
    - { from: s-azure-ext, to: g-core, kind: flow, label: "" }
    - { from: g-azure, to: s-base, kind: thick, label: "" }
    - { from: s-tooling, to: s-base, kind: thick, label: 6/6 }
    - { from: g-github, to: s-base, kind: thick, label: 5/5 }
  markers:
    - { at: s-azure-ext, number: 1 }
    - { at: g-azure, number: 2 }
    - { at: s-tooling, number: 3 }
    - { at: g-github, number: 4 }
    - { at: s-base, number: 5 }
    - { at: g-core, number: 6 }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-top: { x: 20, y: 84, w: 1260, h: 130 }
  band-middle: { x: 20, y: 254, w: 1260, h: 120 }
  band-foundation: { x: 20, y: 424, w: 1260, h: 120 }
  s-azure-ext: { x: 140, y: 122, w: 620, h: 56 }
  g-azure: { x: 40, y: 292, w: 200, h: 56 }
  g-core: { x: 280, y: 292, w: 130, h: 56 }
  s-tooling: { x: 560, y: 292, w: 240, h: 56 }
  g-github: { x: 840, y: 292, w: 400, h: 56 }
  s-base: { x: 40, y: 462, w: 1200, h: 56 }
```

![Module dependencies form three layers, and every edge points down](.assets/three-layers-edges-point-down.drawio.png)

## Walkthrough

1. **AzureExt.** The top of the graph is one group: the five Azure extension modules that sit below the `Catzc.Azure` root. Inside the
   group, Cli is the root that the others build on. Four of the five may use `Catzc.Azure`, three may use the Tooling group, and all five
   may use Base.
2. **Catzc.Azure.** The Azure root is a single module in the middle of the graph. It depends on Base alone.
3. **Tooling.** The six modules that install and manage external tools form the group in the middle of the graph. Core is their foundation,
   Provisioning orchestrates the whole devbox on top of the others, and every member may use Base.
4. **Github, KeyHandler, Inspiration, Listen and Claude.** Five Tooling modules belong to no group. Each is declared on its own, and all
   five may use Base (5 of 5).
5. **Base.** The foundation is a group of 34 small libraries. Two of them, Asserts and Engines, depend on nothing at all, and every declared
   module in cats ultimately rests on this layer.
6. **Cli to Tooling.Core.** One edge from the top of the graph names a single module instead of a whole group: Cli may use Tooling's Core,
   but no other Tooling member. The edge from AzureExt to `Catzc.Azure` is the other single-module edge in the diagram.

## Why it holds

- The declaration is the only place a module dependency can exist, and an undeclared edge fails the build (ADR-AUTO-DEPM-CODEBUILTFROM).
- A group is a concept, not a folder on disk. Depending on a group permits an edge to any of its members, while naming a module permits
  exactly that one edge (ADR-AUTO-DEPM-TWOSECTIONS).
- The declaration is checked when it loads, so every target must exist and no cycle may form, and the quality gate then checks every real
  edge in the code against it (ADR-AUTO-DEPM-GROUPAWAREINTEGRITY).

## Where the code and the decision record differ

The ADR says a module missing from the `modules:` section is unconstrained. The code also constrains every member of a group, so a Base
library that appears only in `groups:` is still held to the Base group's internal order.

## See also

- [Controlling module dependencies](../../drs/automation/controlling-module-dependencies.md) — the decision this article explains.
- The other lenses on the same graph: [meta](a-declared-allow-list-of-layers.md),
  [implementation](two-sections-unioned-into-one-allow-set.md), [operations](undeclared-edge-fails-with-one-line.md) and
  [governance](two-gates-check-the-layer-pins.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

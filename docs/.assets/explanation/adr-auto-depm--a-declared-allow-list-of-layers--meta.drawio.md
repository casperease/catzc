---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.md
    kind: asset-description
    body_sha: d970c7ce6940
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# One declared allow-list, edges point down: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands, beside one tall band on the right.
Glyphs: 3 named sets (mauve), 1 code unit (slate), 1 failure; 5 downward edges, 1 failure path; 5 markers.
Sidebar: world-map grid (3 lit cells), tree (4 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/automation/a-declared-allow-list-of-layers.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
bands on the left, labelled `TOP LAYER`, `MIDDLE LAYER` and `FOUNDATION`, beside one tall band on the right labelled `INVARIANT`. It holds
five glyphs, three named sets, one code unit and one failure, joined by five downward edges and one horizontal failure path, with five
markers and a legend panel along the bottom. The eye lands first on the red failure at the bottom right.

## Reading path

1. Marker 1, top band: the named set AzureExt.
2. Down the three edges that leave it.
3. Markers 2 and 3, middle band, left to right: the code unit Catzc.Azure, the named set Tooling.
4. Marker 4, foundation band: the named set Base, which every downward edge reaches.
5. Right along the failure path to marker 5, INVARIANT band: the failure Undeclared edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                           |
| --------------------- | ----- | ------------------------------------------------------------------------------- |
| named set             | 3     | AzureExt (top band), Tooling (middle band, right), Base (foundation band, wide) |
| code unit             | 1     | Catzc.Azure (middle band, left)                                                 |
| failure               | 1     | Undeclared edge (INVARIANT band, bottom)                                        |

Named sets are mauve and the code unit is slate, both with white names; the failure is light red.

## Edges

| Edge kind              | Count | From → to                                                               |
| ---------------------- | ----- | ----------------------------------------------------------------------- |
| thick, to a named set  | 4     | AzureExt → Base, AzureExt → Tooling, Catzc.Azure → Base, Tooling → Base |
| flow, to one code unit | 1     | AzureExt → Catzc.Azure                                                  |
| failure path           | 1     | Base → Undeclared edge                                                  |

Every edge is straight, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                | Phrase                          |
| --------------------- | ------------------------------- |
| mauve rounded box     | named set                       |
| slate rounded box     | code unit                       |
| thick arrow           | may depend on, to a named set   |
| thin arrow            | may depend on, to one code unit |
| light red rounded box | failure                         |
| red arrow             | failure path                    |
| dark disc `1`         | marker: a Walkthrough step      |
| grey band             | band: one layer                 |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md),
[tree](adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md) and
[value-chain map](adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md). A file or ADR lights a minimap when it cites, or is, the
ADR the slide supports (ADR-AUTO-DEPM); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `automation × .cs` (3 files: 3 cite ADR-AUTO-DEPM);
  `automation × .yml` (1 file: 1 cites ADR-AUTO-DEPM); `docs × .md` (3 files: 2 cite ADR-AUTO-DEPM; 1 is the ADR file of ADR-AUTO-DEPM).
- **Tree** (the repository's files): 4 lit groups, `ModuleSystem` (3 files); `adr/auto` (2 files); `Docs` (1 file); `adr/*` (1 file). The
  ADR file `docs/adr/automation/controlling-module-dependencies.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × LOCAL`, because ADR-AUTO-DEPM: its
  ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.drawio.md
    kind: asset-description
    body_sha: "8ea906cb80c1"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Module dependencies form three layers: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 2 code units (slate); 7 downward edges; 6 markers.
Sidebar: world-map grid (3 lit cells), tree (4 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-auto-depm--three-layers-edges-point-down--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/three-layers-edges-point-down.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `TOP LAYER`, `MIDDLE LAYER` and `FOUNDATION`. It holds five glyphs, three named sets and two code units, joined
by seven downward edges, with six markers and a legend panel along the bottom. The eye lands first on the wide named set in the foundation
band, which nearly spans the drawing area.

## Reading path

1. Marker 1, top band: the named set AzureExt, centred left.
2. Down the four edges that leave it, to the middle band.
3. Markers 2, 3 and 4, middle band, left to right: the code unit Catzc.Azure, the named set Tooling, the code unit Github · KeyHandler.
4. Marker 6, touching the thin edge that enters Tooling from AzureExt.
5. Down to marker 5, foundation band: the named set Base.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------- |
| named set             | 3     | AzureExt (top band), Tooling (middle band, centre), Base (foundation band, full width) |
| code unit             | 2     | Catzc.Azure (middle band, left), Github · KeyHandler (middle band, right)              |

Named sets are mauve and code units are slate, both with white names.

## Edges

| Edge kind              | Count | From → to                                                                                           |
| ---------------------- | ----- | --------------------------------------------------------------------------------------------------- |
| thick, to a named set  | 5     | AzureExt → Base, AzureExt → Tooling, Catzc.Azure → Base, Tooling → Base, Github · KeyHandler → Base |
| flow, to one code unit | 2     | AzureExt → Catzc.Azure, AzureExt → Tooling (marker 6)                                               |

Every edge is straight and vertical, and none crosses another. Five carry a fraction chip: 4/5, 3/5 and 5/5 on the edges that leave
AzureExt, 6/6 below Tooling, and 2/2 below Github · KeyHandler.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| mauve rounded box | named set                            |
| slate rounded box | code unit                            |
| thick arrow       | may depend on, to a named set        |
| thin arrow        | may depend on, to one code unit      |
| bold `4/5`        | fraction chip: members with the edge |
| dark disc `1`     | marker: a Walkthrough step           |
| grey band         | band: one layer                      |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-depm--three-layers-edges-point-down--architecture.grid.md),
[tree](adr-auto-depm--three-layers-edges-point-down--architecture.tree.md) and
[value-chain map](adr-auto-depm--three-layers-edges-point-down--architecture.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-DEPM); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `automation × .cs` (3 files: 3 cite ADR-AUTO-DEPM);
  `automation × .yml` (1 file: 1 cites ADR-AUTO-DEPM); `docs × .md` (3 files: 2 cite ADR-AUTO-DEPM; 1 is the ADR file of ADR-AUTO-DEPM).
- **Tree** (the repository's files): 4 lit groups, `ModuleSystem` (3 files); `adr/auto` (2 files); `Docs` (1 file); `adr/*` (1 file). The
  ADR file `docs/adr/automation/controlling-module-dependencies.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × LOCAL`, because ADR-AUTO-DEPM: its
  ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

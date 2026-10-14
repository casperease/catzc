# docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md

`Sync from the last certified commit, not HEAD: the diagram described`

```text
A 1572 x 600 diagram, read top to bottom, then left to right; no bands.
Glyphs: 1 ADR-only box, 1 environment (ADR-only, framed), 2 commits; 1 ADR-only flow edge, 1 failure path; 3 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/sync-from-the-last-certified-commit.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. There are no bands. The drawing holds one
ADR-only box, one environment hexagon (white, dashed, inside a dashed frame) and two commits, joined by one dashed flow edge and one dashed
failure path, with three markers and a legend panel along the bottom. The eye lands first on the hexagon in the middle.

## Reading path

1. Marker 1: the ADR-only box upstream integrator, top centre.
2. Down its dashed edge to marker 2: the light-blue commit `6` inside the hexagon main-UAT.
3. Right along the red dashed failure path to marker 3: the blue commit `10`, named dirty HEAD beneath it.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                  |
| ------------------------------ | ----- | ------------------------------------------------------ |
| ADR-only (box)                 | 1     | upstream integrator, top centre                        |
| environment (ADR-only, framed) | 1     | main-UAT, centre                                       |
| commit (locked palette)        | 2     | light-blue `6` inside main-UAT; blue `10` to its right |

No glyph on this diagram is structural: the environment is neutral and both commits keep their locked colours.

## Edges

| Edge kind                            | Count | From → to                 |
| ------------------------------------ | ----- | ------------------------- |
| flow: takes its commit from (dashed) | 1     | upstream integrator → `6` |
| failure path (red, dashed)           | 1     | main-UAT → `10`           |

Both edges are straight: the first vertical, the second horizontal. They do not cross.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| white hexagon     | environment: its occupant inside  |
| two commit dots   | commit (locked palette)           |
| dashed white box  | ADR-only (no code): glyph or edge |
| dashed grey arrow | flow: takes its commit from       |
| dashed red arrow  | failure path                      |
| dark disc `1`     | marker: a Walkthrough step        |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. No other cell carries a
  dot.
- **Tree minimap:** one lit tile group, labelled `adr/dsgn`, at the right edge.
- **Lens badge:** META, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.

# docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md

`Drop a file, and the next import exports it: the diagram described`

```text
A 1572 x 702 diagram, read left to right from a tall code unit into two bands.
Glyphs: 3 code units (slate), 2 results, 1 failure, 1 gate; 6 edges; 7 markers.
Sidebar: axis minimap (main cell DSGN x BUILD), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/drop-a-file-the-import-exports-it.md).

## At a glance

A 1572 × 702 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right. A tall code unit
stands outside the bands on the far left, with a gate below it, and two bands sit to its right: EVERY IMPORT (on top) and WHICH ASPECT
(below). It holds seven glyphs (three code units, two results, one failure and one gate) joined by six edges, with seven markers and a
legend panel along the bottom. The eye lands first on the red failure box in EVERY IMPORT.

## Reading path

1. Marker 1, left of the bands: the code unit Verb-Noun.ps1.
2. Right into EVERY IMPORT: marker 2, the code unit . ./importer.ps1; then marker 3, the result Verb-Noun exported, above marker 4, the
   failure Function name collision(s), reached by the red failure path.
3. Back to the left, along the lower edge into WHICH ASPECT: marker 5, the code unit Get-ModuleGlobSet, then marker 6, the result in
   &lt;kebab&gt;-live.
4. Down from Verb-Noun.ps1 to marker 7, outside the bands: the gate Quality gates.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| code unit             | 3     | Verb-Noun.ps1 (far left, tall), . ./importer.ps1 (EVERY IMPORT), Get-ModuleGlobSet (WHICH ASPECT) |
| result                | 2     | Verb-Noun exported (EVERY IMPORT, right, top), in &lt;kebab&gt;-live (WHICH ASPECT, right)        |
| failure               | 1     | Function name collision(s) (EVERY IMPORT, right, below the result)                                |
| gate                  | 1     | Quality gates (below Verb-Noun.ps1, outside the bands; grey rhombus with a 3 px rim)              |

Code units are slate with white names; results are mint, the failure is red, and the gate is grey.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                            |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow         | 5     | Verb-Noun.ps1 → . ./importer.ps1, . ./importer.ps1 → Verb-Noun exported, Verb-Noun.ps1 → Get-ModuleGlobSet, Get-ModuleGlobSet → in &lt;kebab&gt;-live, Verb-Noun.ps1 → Quality gates |
| failure path | 1     | . ./importer.ps1 → Function name collision(s)                                                                                                                                        |

Five edges are straight and horizontal, pointing right; the edge into Quality gates points straight down. None crosses another, and none
carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| mint rounded box        | result                     |
| red rounded box         | failure                    |
| grey rhombus, thick rim | gate                       |
| thin grey arrow         | flow: runs, then yields    |
| thin red arrow          | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is DSGN × BUILD, framed and filled in the BUILD purple with the you-are-here dot. Four touched cells carry
  a small grey dot: AUTO × LOAD, AUTO × CONFIG, AUTO × GLOBS and AUTO × BUILD. The DSGN and BUILD axis labels carry a purple tick.
- **Tree minimap:** lit tiles labelled QualityGates, ModuleSystem, Globs, internal, RootConfig, adr/dsgn (the ADR file framed in dark ink)
  and .claude.
- **Lens badge:** OPS, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.

# docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md

`ScanProgram() feeds three role functions: the diagram described`

```text
A 1572 x 560 diagram, read left to right through four bands.
Glyphs: 1 file (olive), 7 code units (slate), 1 gate, 1 failure; 8 flow edges, 1 failure path; 9 markers.
Sidebar: axis minimap (main cell PIPE x GLOBS), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/one-scan-program-feeds-three-roles.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands side by side, labelled CONFIG, PROGRAM, FUNCTIONS and CALLERS. It holds ten glyphs, one file, seven code units, one gate and one
failure, joined by nine edges, with nine markers and a legend panel along the bottom. The eye lands first on the tall code unit in the
PROGRAM band, then on the red failure at the bottom of the CONFIG band.

## Reading path

1. Marker 1, CONFIG band, top: the file globs.yml.
2. Down its edge to marker 2: the code unit GlobsConfig; a red failure path continues down to the failure validation failed.
3. Right from GlobsConfig to marker 3, PROGRAM band: the tall code unit GlobSet.ScanProgram().
4. Right along three parallel edges to markers 4, 5 and 6, FUNCTIONS band, top to bottom: Get-GlobSetTrigger, Get-ChangedGlobSet and
   Get-GlobSetHash.
5. Right along three edges to the CALLERS band: marker 7 at the top vertex of the gate Trigger gates, then markers 8 and 9 on the code units
   Test-GlobSetAffected and Test-GlobSetProtection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                                                                         |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | globs.yml (CONFIG band, top row)                                                                                                                                                                                                              |
| code unit             | 7     | GlobsConfig (CONFIG, middle row); GlobSet.ScanProgram() (PROGRAM, all rows); Get-GlobSetTrigger, Get-ChangedGlobSet, Get-GlobSetHash (FUNCTIONS, one per row); Test-GlobSetAffected, Test-GlobSetProtection (CALLERS, middle and bottom rows) |
| gate                  | 1     | Trigger gates (CALLERS band, top row), 3 px rim                                                                                                                                                                                               |
| failure               | 1     | validation failed (CONFIG band, bottom row)                                                                                                                                                                                                   |

The file is olive and the code units are slate, all with white names; the gate is grey and the failure red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                               |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 8     | globs.yml → GlobsConfig (down); GlobsConfig → GlobSet.ScanProgram(); ScanProgram() → each of the three functions; each function → the caller in its row |
| failure path | 1     | GlobsConfig → validation failed (down, red)                                                                                                             |

Every edge is straight; none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                 | Phrase                        |
| ---------------------- | ----------------------------- |
| olive folded page      | file                          |
| slate rounded box      | code unit                     |
| grey rhombus, 3 px rim | gate                          |
| red rounded box        | failure                       |
| thin grey arrow        | flow: output read by the next |
| thin red arrow         | failure path                  |
| dark disc `1`          | marker: a Walkthrough step    |

## Sidebar

- **Axis minimap:** the main cell is PIPE × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. One touched cell, AUTO ×
  GLOBS, carries a small grey dot.
- **Tree minimap:** lit tiles labelled Globs and adr/flow.
- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.

# docs/.assets/explanation/adr-dsgn-aspect--get-aspect-feeds-globs-and-maps--implementation.drawio.md

`Get-Aspect feeds Globs and Maps: the diagram described`

```text
A 1572 x 668 diagram, read top to bottom from a file, a code unit and a failure, through a wide code unit, into two column bands.
Glyphs: 1 file (olive), 6 code units (slate), 2 named sets (mauve), 1 failure; 6 flow edges, 1 thick edge, 1 failure path; 10 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-dsgn-aspect--get-aspect-feeds-globs-and-maps--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/get-aspect-feeds-globs-and-maps.md).

## At a glance

A 1572 × 668 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom, with one row
read left to right. The top row holds a file, a code unit and a failure, left to right; a wide code unit spans the drawing area below them;
and under that two column bands sit side by side, labelled `AUTOMATION` on the left and `INFRASTRUCTURE` on the right. The left band stacks
two code units above a frame with two named sets side by side; the right band stacks two code units. Eight edges join the glyphs, ten
markers number them, and a legend panel runs along the bottom. The eye lands first on the red failure at the top right.

## Reading path

1. Marker 1, top left: the file variants.yml; right along a flow edge to marker 2, the code unit VariantsConfig; right along the failure
   path to marker 3, the failure the last aspect must be '**'.
2. Down the flow edge from VariantsConfig to marker 4, the wide code unit Get-Aspect.
3. Down the left flow edge into the left band: marker 5, the code unit Get-ModuleGlobSet; down to marker 6, the code unit
   AspectPartition.Compile; down the thick edge into the frame, markers 7 and 8, the named sets catzc-base-globs-live and
   catzc-base-globs-tests.
4. Down the right flow edge into the right band: marker 9, the code unit Get-WorldMap; down to marker 10, the code unit
   WorldMapBuilder.IsLive.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | variants.yml (top row, left)                                                                                                                                                     |
| code unit             | 6     | VariantsConfig (top row, centre), Get-Aspect (wide, second row), Get-ModuleGlobSet and AspectPartition.Compile (left band), Get-WorldMap and WorldMapBuilder.IsLive (right band) |
| named set             | 2     | catzc-base-globs-live and catzc-base-globs-tests (left band, bottom, inside one frame)                                                                                           |
| failure               | 1     | the last aspect must be '**' (top row, right)                                                                                                                                    |

The file is olive, the code units slate and the named sets mauve, all with white names; the failure is red with a pale name. The frame
around the two named sets is a thin grey rounded rim with no fill.

## Edges

| Edge kind              | Count | From → to                                                                                                                                                                                                 |
| ---------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow                   | 6     | variants.yml → VariantsConfig; VariantsConfig → Get-Aspect; Get-Aspect → Get-ModuleGlobSet; Get-ModuleGlobSet → AspectPartition.Compile; Get-Aspect → Get-WorldMap; Get-WorldMap → WorldMapBuilder.IsLive |
| thick (to a named set) | 1     | AspectPartition.Compile → the frame around catzc-base-globs-live and catzc-base-globs-tests                                                                                                               |
| failure path           | 1     | VariantsConfig → the last aspect must be '**'                                                                                                                                                             |

Two edges are horizontal, pointing right, in the top row; the other six are vertical, pointing down. The two that leave Get-Aspect start at
its lower edge above each column's centre, and the one that enters it arrives below VariantsConfig. None crosses another, and none carries a
label.

## Legend

A full-width panel at the bottom of the drawing area, in two rows of four, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive folded page | file                       |
| slate rounded box | code unit                  |
| mauve rounded box | named set                  |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds                |
| thick arrow       | to a named set: derives    |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads IMPL. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.

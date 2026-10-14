# docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.md

`An undeclared edge fails with one line: the diagram described`

```text
A 1572 x 640 diagram, read top to bottom through three bands and left to right within each.
Glyphs: 2 runners (slate), 1 result, 2 failures, 1 file (olive); 3 flow edges, 2 failure paths; 6 markers.
Sidebar: axis minimap (main cell AUTO x BUILD), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/undeclared-edge-fails-with-one-line.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled RUN, SEE and FIX, and left to right within each. It holds six glyphs, two runners, one result, two failures and
one file, joined by three flow edges and two failure paths, with six markers and a legend panel along the bottom. The eye lands first on the
two red failures stacked on the right.

## Reading path

1. Marker 1, RUN band, left: the runner Test-Automation.
2. Right to marker 2: the runner Test-ModuleDependency.
3. Right along the failure path to marker 3: the failure Bad dependencies.yml.
4. Down from marker 2 to marker 4, SEE band: the result module-dependency.md.
5. Right along the failure path to marker 5: the failure failed: N issue(s).
6. Down to marker 6, FIX band, right: the file dependencies.yml.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                        |
| --------------------- | ----- | ---------------------------------------------------------------------------- |
| runner                | 2     | Test-Automation (RUN band, left), Test-ModuleDependency (RUN band, centre)   |
| result                | 1     | module-dependency.md (SEE band, centre)                                      |
| failure               | 2     | Bad dependencies.yml (RUN band, right), failed: N issue(s) (SEE band, right) |
| file                  | 1     | dependencies.yml (FIX band, right)                                           |

Runners are slate pills and the file is olive, both with white names; the result is light green and the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                    |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------- |
| flow         | 3     | Test-Automation → Test-ModuleDependency, Test-ModuleDependency → module-dependency.md, failed: N issue(s) → dependencies.yml |
| failure path | 2     | Test-ModuleDependency → Bad dependencies.yml, module-dependency.md → failed: N issue(s)                                      |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate pill              | runner                     |
| light green rounded box | result                     |
| light red rounded box   | failure                    |
| olive folded page       | file                       |
| thin arrow              | flow: then                 |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one stage            |

## Sidebar

- **Axis minimap:** the main cell is AUTO × BUILD, framed and filled in the BUILD purple with the you-are-here dot. One touched cell, AUTO ×
  LOAD, carries a small grey dot. The AUTO and BUILD axis labels carry a purple tick.
- **Tree minimap:** four lit tiles, labelled QualityGates, ModuleSystem, Reports and adr/auto. The adr/auto file is framed in dark ink as an
  ADR file.
- **Lens badge:** OPS, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.

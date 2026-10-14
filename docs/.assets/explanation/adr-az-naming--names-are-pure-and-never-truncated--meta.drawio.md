# docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.md

`Names are pure and never truncated: the diagram described`

```text
A 1572 x 670 diagram, read top to bottom through three bands.
Glyphs: 2 named sets (mauve), 1 gate, 1 failure, 1 result; 3 flow edges, 1 failure path; 5 markers.
Sidebar: axis minimap (main cell CLOUD x DEPLOY), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/names-are-pure-and-never-truncated.md).

## At a glance

A 1572 × 670 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled COMPONENTS, PATTERN and LIMIT. Five glyphs (two named sets, one gate, one failure and one result) stand in one
centred column, with the failure to the right of the gate. Three flow edges and one failure path join them, and five markers and a legend
panel complete the drawing. The eye lands first on the gate in the limit band.

## Reading path

1. Marker 1, components band: the named set fixed components.
2. Down to marker 2, pattern band: the named set type pattern.
3. Down to marker 3, limit band: the gate ≤ limit?, its marker on the gate's upper-left side.
4. Right along the red edge to marker 4: the failure throw.
5. Down from the gate to marker 5: the result the same name.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                           |
| --------------------- | ----- | --------------------------------------------------------------- |
| named set             | 2     | fixed components (components band), type pattern (pattern band) |
| gate                  | 1     | ≤ limit? (limit band, centre)                                   |
| failure               | 1     | throw (limit band, right of the gate)                           |
| result                | 1     | the same name (limit band, below the gate)                      |

Named sets are mauve with white names; the gate is grey with a thick rim.

## Edges

| Edge kind    | Count | From → to                                                  |
| ------------ | ----- | ---------------------------------------------------------- |
| flow         | 3     | fixed components → type pattern → ≤ limit? → the same name |
| failure path | 1     | ≤ limit? → throw                                           |

Every edge is straight; the flow edges are vertical and the failure path horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| mauve rounded box       | named set                  |
| grey rhombus, thick rim | gate                       |
| red rounded box         | failure                    |
| green rounded box       | result                     |
| grey arrow              | flow: the next stage       |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is CLOUD × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. No other cell is
  touched. The CLOUD and DEPLOY axis labels carry a blue tick.
- **Tree minimap:** two lit tiles, labelled Az.Templates and adr/azure. The adr/azure file is framed in dark ink as an ADR file.
- **Lens badge:** META, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.

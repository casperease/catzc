# docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.md

`One declared allow-list, edges point down: the diagram described`

```text
A 1572 x 700 diagram, read top to bottom through three bands, beside one tall band on the right.
Glyphs: 3 named sets (mauve), 1 code unit (slate), 1 failure; 5 downward edges, 1 failure path; 5 markers.
Sidebar: axis minimap (main cell AUTO x BUILD), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/automation/a-declared-allow-list-of-layers.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
bands on the left, labelled TOP LAYER, MIDDLE LAYER and FOUNDATION, beside one tall band on the right labelled INVARIANT. It holds five
glyphs, three named sets, one code unit and one failure, joined by five downward edges and one horizontal failure path, with five markers
and a legend panel along the bottom. The eye lands first on the red failure at the bottom right.

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

- **Axis minimap:** the main cell is AUTO × BUILD, framed and filled in the BUILD purple with the you-are-here dot. One touched cell, AUTO ×
  LOAD, carries a small grey dot. The AUTO and BUILD axis labels carry a purple tick.
- **Tree minimap:** two lit tiles, labelled ModuleSystem and adr/auto. The adr/auto file is framed in dark ink as an ADR file.
- **Lens badge:** META, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.

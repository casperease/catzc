# Dot-source one entry script, and a failed check stops the load with a named error: the diagram described

```text
A 1572 x 690 diagram, read top to bottom down one column, with a failure glyph to its right.
Glyphs: 5 code units (slate), 1 gate, 1 result, 1 failure; 6 flow edges, 3 failure paths; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](dot-source-one-entry-script.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom down one centred
column inside a full-width band labelled RUN AND SEE, with a tall failure glyph to the column's right. It holds eight glyphs, five code
units, one gate, one result and one failure, joined by nine straight edges, with eight markers and a legend panel along the bottom. The eye
lands first on the tall red failure glyph on the right.

## Reading path

1. Markers 1 and 2, top row: the code units `. ./importer.ps1` and `. Import-Catzc.ps1`, side by side.
2. Down the two edges into marker 3, the code unit Session set-up.
3. Marker 4, the code unit Load; marker 5, on the gate's left point, the gate Run-mode check.
4. Marker 6, the code unit Janitors; marker 7, the result Loaded in N seconds, at the bottom of the column.
5. Marker 8, to the right: the failure Stops with a named error, which three red edges enter from the left.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| code unit             | 5     | the two entry scripts (top row); Session set-up, Load, Janitors (column)                          |
| gate                  | 1     | Run-mode check, in the column below Load                                                          |
| result                | 1     | Loaded in N seconds, bottom of the column                                                         |
| failure               | 1     | Stops with a named error, right of the column, level with Session set-up, Load and Run-mode check |

Code units are slate with white names; the result is light green, the failure light red.

## Edges

| Edge kind        | Count | From → to                                                                                                   |
| ---------------- | ----- | ----------------------------------------------------------------------------------------------------------- |
| flow (runs next) | 6     | each entry script → Session set-up; Session set-up → Load → Run-mode check → Janitors → Loaded in N seconds |
| failure path     | 3     | Session set-up, Load and Run-mode check → Stops with a named error                                          |

Every edge is straight: the flow edges vertical, the failure paths horizontal. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| green rounded box       | result                     |
| red rounded box         | failure                    |
| thin grey arrow         | flow: runs next            |
| thin red arrow          | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md),
[tree](../.assets/tree/adr-auto-bundle--dot-source-one-entry-script--operations.tree.md) and
[value-chain map](../.assets/chain/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

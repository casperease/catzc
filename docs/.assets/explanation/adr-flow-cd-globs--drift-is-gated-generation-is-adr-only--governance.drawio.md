# docs/.assets/explanation/adr-flow-cd-globs--drift-is-gated-generation-is-adr-only--governance.drawio.md

`Drift is gated, generation is ADR-only: the diagram described`

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 results (green), 3 gates, 2 ADR-only; 5 flow edges, 2 ADR-only edges; 8 rule chips (2 dashed); 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-globs--drift-is-gated-generation-is-adr-only--governance.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/drift-is-gated-generation-is-adr-only.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `COMPOSE`, `PROJECTION` and `CHECKED BY`. It holds eight glyphs, three results, three gates and two dashed
ADR-only boxes, joined by five flow edges and two dashed ADR-only edges, with eight rule chips, eight markers and a legend panel along the
bottom. The eye lands first on the wide result in the top band, which spans most of the drawing area.

## Reading path

1. Marker 1, top band: the wide result flattened scan program, with the rule chips `#8` and a dashed `#4` at its right end.
2. Down two vertical edges into the middle band: marker 2, left, the result GitHub paths (chip `#6`); marker 3, centre, the wide result ADO
   include and exclude (chip `#6`).
3. Right along the dashed edge to marker 4: the ADR-only box generated YAML filters, with a dashed `#6` chip at its bottom-right corner.
4. Down three vertical edges into the bottom band: marker 5, the gate Test-GitHub…TriggerGlob; marker 6, the gate
   Test-AdoPipelineTriggerGlob; marker 7, the gate Test-GlobSetTriggerCoverage, each with a `T35` chip at its top-right.
5. Right along the dashed edge from the last gate to marker 8: the ADR-only box in-pipeline exact backstop.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                          |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------- |
| result                | 3     | flattened scan program (top band, wide); GitHub paths and ADO include and exclude (middle band)                |
| gate                  | 3     | Test-GitHub…TriggerGlob, Test-AdoPipelineTriggerGlob, Test-GlobSetTriggerCoverage (bottom band, left to right) |
| ADR-only (no code)    | 2     | generated YAML filters (middle band, right); in-pipeline exact backstop (bottom band, right)                   |

Results are green with light names; gates are neutral rhombi with a thick light rim; the ADR-only boxes are dashed outlines on the page
colour.

## Edges

| Edge kind          | Count | From → to                                                                                                                                                                                                                                     |
| ------------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds        | 5     | flattened scan program → GitHub paths, flattened scan program → ADO include and exclude, GitHub paths → Test-GitHub…TriggerGlob, ADO include and exclude → Test-AdoPipelineTriggerGlob, ADO include and exclude → Test-GlobSetTriggerCoverage |
| ADR-only (no code) | 2     | ADO include and exclude → generated YAML filters, Test-GlobSetTriggerCoverage → in-pipeline exact backstop (both dashed, horizontal)                                                                                                          |

Every edge is horizontal or vertical, and none crosses another. Eight rule chips sit beside the glyphs they govern: `#8` and a dashed `#4`
on the program, `#6` on each projection and a dashed `#6` on the generated box, and `T35` on each gate.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                                   |
| ----------------- | -------------------------------------------------------- |
| green rounded box | result                                                   |
| neutral rhombus   | gate                                                     |
| dashed box        | ADR-only (no code)                                       |
| thin arrow        | flow: feeds                                              |
| dashed arrow      | ADR-only (no code)                                       |
| light disc `1`    | marker: a Walkthrough step                               |
| pill `#6`         | rule chip: #n ADR-FLOW-CD-GLOBS#n · T35 ADR-AUTO-TEST#35 |
| dashed pill `#4`  | dashed rule chip: ADR-only (no gate)                     |

## Sidebar

The lens badge reads `GOV`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, lit ADR file, and idle.

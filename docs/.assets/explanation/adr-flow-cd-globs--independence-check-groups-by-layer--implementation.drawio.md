# docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md

`Test-GlobSetIndependence groups by layer: the diagram described`

```text
A 1572 x 700 diagram, read top to bottom through three bands, the checks on the right.
Glyphs: 4 named sets (mauve), 2 gates (grey), 1 code unit (slate), 1 failure (red).
Edges: 4 flow, 1 failure path; 8 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/independence-check-groups-by-layer.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. Named sets sit on the left of each band; a column of two gates and one
code unit on the right joins them, with a failure to its right. It holds four named sets, two gates, one code unit and one failure, joined
by four flow edges and one failure path, with eight markers and a legend panel. The eye lands first on the red failure in the middle band.

## Reading path

1. Markers 1 to 4, down the left: deployable-unit sets (top band), declared loose-filesets and ReservedNames umbrellas (middle band),
   module-layer sets (bottom band).
2. Marker 5, on the right vertex of the gate Overlaps per pair in the top band, fed from deployable-unit sets.
3. Marker 6, on the right vertex of the gate Overlaps per pair in the bottom band, fed from module-layer sets.
4. Marker 7, the code unit Write-QualityGateReport in the middle band, which both gates feed.
5. Marker 8, the failure One throw lists every pair, at the end of the red failure path.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------- |
| named set             | 4     | deployable-unit sets (top), declared loose-filesets and ReservedNames umbrellas (middle), module-layer sets (bottom) |
| gate                  | 2     | Overlaps per pair (top band, right; bottom band, right)                                                              |
| code unit             | 1     | Write-QualityGateReport (middle band, between the gates)                                                             |
| failure               | 1     | One throw lists every pair (middle band, far right)                                                                  |

Named sets are mauve and the code unit slate, both with white names; the gates are grey rhombuses with a 3 px rim; the failure is light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                         |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | deployable-unit sets → the gate in the top band, module-layer sets → the gate in the bottom band, each of the two gates → Write-QualityGateReport |
| failure path | 1     | Write-QualityGateReport → One throw lists every pair                                                                                              |

Every edge is straight; none crosses another. The two named sets in the middle band have no edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| slate rounded box | code unit                  |
| grey rhombus      | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow, in code order        |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md),
[tree](adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md) and
[value-chain map](adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD-GLOBS); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (5 files: 5 cite ADR-FLOW-CD-GLOBS); `automation × .ps1` (41 files: 41 cite ADR-FLOW-CD-GLOBS);
  `automation × .yml` (3 files: 3 cite ADR-FLOW-CD-GLOBS); `docs × .md` (5 files: 4 cite ADR-FLOW-CD-GLOBS; 1 is the ADR file of
  ADR-FLOW-CD-GLOBS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 10 lit groups, `Globs` (38 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files);
  `QualityGates` (4 files); `adr/flow` (2 files); `docs` (2 files); `.github` (1 file); `Docs` (1 file); `Exporter` (1 file); `adr/*` (1
  file). The ADR file `docs/adr/flow/durable-sha-globs.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × AUTOMA`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

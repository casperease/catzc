# docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md

`One artifact climbs to production unchanged: the diagram described`

```text
A 1572 x 600 diagram, read left to right through two bands.
Glyphs: 1 runner (slate), 1 result, 2 environments, 1 ADR-only gate; 3 flow and 2 ADR-only edges; 6 markers.
Sidebar: world-map grid (5 lit cells), tree (7 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/flow/one-artifact-climbs-unchanged.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two
bands, labelled AUTOMATED (wider, left) and GOVERNED (right). Three span bars sit above them: CD and DEPLOY on the upper row, CI on the
lower row. It holds five glyphs (one runner, one result, two environments and one gate), six markers, and a legend panel along the bottom.
The eye lands first on the slate runner and the green result at the left of the AUTOMATED band.

## Reading path

1. Marker 1, AUTOMATED: the runner build & verify.
2. Marker 2, AUTOMATED: the result tagged artifact.
3. Marker 3, AUTOMATED: the environment non-prod.
4. Marker 4, GOVERNED: the gate `human gate`, white with a thin dashed rim, inside a dashed frame.
5. Marker 5, GOVERNED: the environment production.
6. Marker 6, below the bands: beside the lane from tagged artifact to production.

## Glyphs

| Glyph (legend phrase)    | Count | Where                                                     |
| ------------------------ | ----- | --------------------------------------------------------- |
| runner                   | 1     | build & verify (AUTOMATED, left)                          |
| result                   | 1     | tagged artifact (AUTOMATED, centre)                       |
| environment              | 2     | non-prod (AUTOMATED, right), production (GOVERNED, right) |
| gate, ADR-only (no code) | 1     | `human gate` (GOVERNED, left; dashed frame)               |

The runner is slate with a white name; the result is light green; the environments are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                             |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | build & verify → tagged artifact, tagged artifact → non-prod, tagged artifact → production (down, along the lane, up) |
| ADR-only  | 2     | non-prod → `human gate`, `human gate` → production                                                                    |

The top row is one straight horizontal line of edges. The lane leaves the bottom of tagged artifact, runs right below both bands, and rises
into the bottom of production; it is drawn as three straight segments. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                                   |
| ------------------------- | ---------------------------------------- |
| slate pill                | runner                                   |
| green rounded box         | result                                   |
| grey hexagon              | environment                              |
| white rhombus, dashed rim | gate, ADR-only (no code)                 |
| solid arrow               | flow: the artifact moves on              |
| dashed arrow              | ADR-only (no code): dashed line or frame |
| span bar                  | span bar: stages over bands              |
| dark disc `1`             | marker: a Walkthrough step               |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md), [tree](adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md) and
[value-chain map](adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md). A file or ADR lights a minimap when it cites, or is, the ADR
the slide supports (ADR-FLOW-CD); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD);
  `automation × .cs` (2 files: 2 cite ADR-FLOW-CD); `automation × .ps1` (3 files: 3 cite ADR-FLOW-CD); `automation × .yml` (3 files: 3 cite
  ADR-FLOW-CD); `docs × .md` (4 files: 3 cite ADR-FLOW-CD; 1 is the ADR file of ADR-FLOW-CD).
- **Tree** (the repository's files): 7 lit groups, `Docs` (3 files); `Maps` (3 files); `adr/*` (2 files); `adr/flow` (2 files); `.claude` (1
  file); `ModuleSystem` (1 file); `QualityGates` (1 file). The ADR file `docs/adr/flow/cd-discipline-and-promotion-flow.md` carries the
  white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × BUILD`, because ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `DSGN × RELEAS`, because ADR-FLOW-CD: its ADR
  domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

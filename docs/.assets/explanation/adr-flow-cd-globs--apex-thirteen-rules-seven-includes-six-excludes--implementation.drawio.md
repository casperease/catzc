---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--apex-thirteen-rules-seven-includes-six-excludes--implementation.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "49750c4eef2b"
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--apex-thirteen-rules-seven-includes-six-excludes--implementation.drawio.png
      - docs/explanation/flow/apex-thirteen-rules-seven-includes-six-excludes.md
---

# apex: thirteen rules, seven includes, six excludes: the diagram described

```text
A 1572 x 720 diagram, read top to bottom through three bands.
Glyphs: 2 files (olive), 3 code units (slate), 4 results (green), 1 gate; 9 flow edges; 3 count chips; 10 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-globs--apex-thirteen-rules-seven-includes-six-excludes--implementation.drawio.png) draws, in
the vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/flow/apex-thirteen-rules-seven-includes-six-excludes.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `COMPOSE`, `PROJECTION` and `CHECKED BY`. It holds ten glyphs, two files, three code units, four results and one
gate, joined by nine flow edges, with three count chips, ten markers and a legend panel along the bottom. The eye lands first on the two
wide glyphs stacked at the centre: the result in the top band and the code unit below it.

## Reading path

1. Markers 1 to 3, top band, left to right: the file globs.yml, the code unit GlobSet.ScanProgram(), the wide result flattened scan program
   with the count chip 13 at its right end.
2. Down the vertical edge to marker 4, middle band: the wide code unit Get-GlobSetTrigger.
3. Right along one edge to marker 5: the result .GitHub.
4. Down the two edges from the code unit's underside into a thin frame holding markers 6 and 7: the results .AdoInclude (count chip 7) and
   .AdoExclude (count chip 6).
5. Down the one edge that leaves the frame into the bottom band, to marker 10, the gate Test-AdoPipelineTriggerGlob.
6. Markers 8 and 9, bottom band, left of the gate: the file pipelines/cd-apex.yaml and the code unit Get-PipelineTrigger, whose edges run
   right into the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                    |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| file                  | 2     | globs.yml (top band, left); pipelines/cd-apex.yaml (bottom band, left)                                                   |
| code unit             | 3     | GlobSet.ScanProgram() (top band); Get-GlobSetTrigger (middle band, wide); Get-PipelineTrigger (bottom band)              |
| result                | 4     | flattened scan program (top band, wide); .GitHub (middle band, right); .AdoInclude and .AdoExclude (middle band, framed) |
| gate                  | 1     | Test-AdoPipelineTriggerGlob (bottom band, centre)                                                                        |

Files are olive, code units slate, results green, all with light names; the gate is a neutral rhombus with a thick light rim. A thin frame
without fill groups the two ADO results; it is chrome, not a glyph.

## Edges

| Edge kind   | Count | From → to                                                                                                                                                                                                                                                                                                                                                              |
| ----------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds | 9     | globs.yml → GlobSet.ScanProgram(), GlobSet.ScanProgram() → flattened scan program, flattened scan program → Get-GlobSetTrigger, Get-GlobSetTrigger → .GitHub, Get-GlobSetTrigger → .AdoInclude, Get-GlobSetTrigger → .AdoExclude, frame → Test-AdoPipelineTriggerGlob, pipelines/cd-apex.yaml → Get-PipelineTrigger, Get-PipelineTrigger → Test-AdoPipelineTriggerGlob |

Every edge is horizontal or vertical, and none crosses another. Three count chips sit on the top-right corner of a result: 13 on flattened
scan program, 7 on .AdoInclude, 6 on .AdoExclude.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                        |
| ----------------- | ----------------------------- |
| olive page        | file                          |
| slate rounded box | code unit                     |
| green rounded box | result                        |
| neutral rhombus   | gate                          |
| thin arrow        | flow: feeds                   |
| pill `13`         | count chip: rules or patterns |
| light disc `1`    | marker: a Walkthrough step    |

## Sidebar

The lens badge reads `IMPL`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, lit ADR file, and idle.

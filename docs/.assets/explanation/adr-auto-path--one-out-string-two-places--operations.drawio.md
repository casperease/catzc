---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-path--one-out-string-two-places--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-path-one-out-string-two-places-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "5f9c5d88d4fb"
    links:
      - docs/.assets/explanation/adr-auto-path--one-out-string-two-places--operations.drawio.png
      - docs/explanation/automation/one-out-string-two-places.md
---

# One out/ string, two places: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 3 results (green), 2 code units (slate), 1 runner (slate), 1 failure (red); 4 flow edges, 1 failure path; one frame; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-path--one-out-string-two-places--operations.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/automation/one-out-string-two-places.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `COMMUNICATION FORM`, `THE TWO CROSSERS` and `BINDING FORM`. It holds seven glyphs, three results, two code units, one
runner and one failure, joined by four flow edges and one failure path, with a frame around two results, seven markers and a legend panel
along the bottom. The eye lands first on the red failure in the right band.

## Reading path

1. Marker 1, `COMMUNICATION FORM` band: the result out/template/…/main.json.
2. Right along the flow edge to marker 2, `THE TWO CROSSERS` band, top: the code unit Resolve-RepoPath.
3. Marker 3, below it: the code unit Get-OutputRoot, with a flow edge up into Resolve-RepoPath.
4. Marker 4, bottom of the band: the runner pipeline job, with a flow edge up into Get-OutputRoot.
5. Right from Resolve-RepoPath to markers 5 and 6, `BINDING FORM` band, top to bottom inside one frame: the results {root}/out/…/main.json
   and {staging}/…/main.json.
6. Right along the failure path from Get-OutputRoot to marker 7, `BINDING FORM` band, below the frame: the failure Path does not exist.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------ |
| result                | 3     | out/template/…/main.json (`COMMUNICATION FORM`); {root}/out/…/main.json and {staging}/…/main.json (`BINDING FORM`, inside one frame) |
| code unit             | 2     | Resolve-RepoPath and Get-OutputRoot (`THE TWO CROSSERS`, top and middle)                                                             |
| runner                | 1     | pipeline job (`THE TWO CROSSERS`, bottom), a slate pill                                                                              |
| failure               | 1     | Path does not exist (`BINDING FORM`, bottom)                                                                                         |

Results are green, the code units and the runner slate, all with light names; the failure is red. The frame is a thin grey outline with no
fill.

## Edges

| Edge kind    | Count | From → to                                                                                                                               |
| ------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | out/template/…/main.json → Resolve-RepoPath; Resolve-RepoPath → frame; Get-OutputRoot → Resolve-RepoPath; pipeline job → Get-OutputRoot |
| failure path | 1     | Get-OutputRoot → Path does not exist                                                                                                    |

Every edge is straight, horizontal or vertical, and none crosses another. The edge from Resolve-RepoPath ends on the frame's outline, not on
a result. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| green rounded box | result: a path string      |
| slate rounded box | code unit                  |
| slate pill        | runner                     |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds                |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |
| grey band         | band: one stage            |

## Sidebar

The lens badge reads `OPS`. The three minimaps, world map, tree and value-chain map, sit above it, and the map key below it names the four
swatches: lit, lit by passing mentions only, lit ADR file, and idle.

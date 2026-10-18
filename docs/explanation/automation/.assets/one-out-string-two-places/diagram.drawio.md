# One stored out/ string lands in {root}/out on a devbox and in the staging directory in a pipeline: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 3 results (green), 2 code units (slate), 1 runner (slate), 1 failure (red); 4 flow edges, 1 failure path; one frame; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../one-out-string-two-places.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-PATH): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions, [world map](grid.md), [tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AUTO-PATH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

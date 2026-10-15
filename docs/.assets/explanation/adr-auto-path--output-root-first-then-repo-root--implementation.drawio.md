---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-path--output-root-first-then-repo-root--implementation.drawio.md
    kind: asset-description
    body_sha: "629338942465"
    adrs: []
---

# Output root first, then repository root: the diagram described

```text
A 1572 x 700 diagram, read left to right through three bands, then the band below.
Glyphs: 3 results (green), 6 code units (slate), 1 named set (mauve); 7 flow edges; one frame; 10 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-path--output-root-first-then-repo-root--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/automation/output-root-first-then-repo-root.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `COMMUNICATION FORM`, `THE TWO CROSSERS` and `BINDING FORM`, then down to one full-width band labelled `CROSS-STAGE`. It
holds ten glyphs, three results, six code units and one named set, joined by seven flow edges, with a frame around the three results, ten
markers and a legend panel along the bottom. The eye lands first on the three green results stacked in the left band.

## Reading path

1. Markers 1, 2 and 3, `COMMUNICATION FORM` band, top to bottom inside one frame: the results out/template/…/main.json,
   automation/mod/file.ps1 and D:\a\1\ws\sample\main.json.
2. Right along the flow edge that leaves the frame to marker 4, `THE TWO CROSSERS` band, top: the code unit Resolve-RepoPath.
3. Marker 5, below it: the code unit Get-OutputRoot, with one flow edge up into Resolve-RepoPath and one down into
   ConvertTo-RepoRelativePath.
4. Right from Resolve-RepoPath to marker 6, `BINDING FORM` band: the named set Reads, writes, tool calls.
5. Marker 7, `THE TWO CROSSERS` band, bottom: the code unit ConvertTo-RepoRelativePath, whose flow edge runs left into the frame.
6. Down to markers 8, 9 and 10, `CROSS-STAGE` band, left to right: the code units ArtifactRef.Materialize, ArtifactRef and ResolveAt /
   ExistsAt.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                        |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| result                | 3     | out/template/…/main.json, automation/mod/file.ps1, D:\a\1\ws\sample\main.json (`COMMUNICATION FORM`, stacked inside one frame)                                               |
| code unit             | 6     | Resolve-RepoPath, Get-OutputRoot, ConvertTo-RepoRelativePath (`THE TWO CROSSERS`, top to bottom); ArtifactRef.Materialize, ArtifactRef, ResolveAt / ExistsAt (`CROSS-STAGE`) |
| named set             | 1     | Reads, writes, tool calls (`BINDING FORM`)                                                                                                                                   |

Results are green, code units slate and the named set mauve, all with light names. The frame is a thin grey outline with no fill.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                             |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 7     | frame → Resolve-RepoPath; Resolve-RepoPath → Reads, writes, tool calls; Get-OutputRoot → Resolve-RepoPath; Get-OutputRoot → ConvertTo-RepoRelativePath; ConvertTo-RepoRelativePath → frame; ArtifactRef.Materialize → ArtifactRef; ArtifactRef → ResolveAt / ExistsAt |

Every edge is straight, horizontal or vertical, and none crosses another. The two edges at the frame end on its outline, not on a result. No
edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| green rounded box | result: a communicated path |
| slate rounded box | code unit                   |
| mauve rounded box | named set                   |
| grey band         | band: one stage             |
| thin arrow        | flow: passes the path on    |
| light disc `1`    | marker: a Walkthrough step  |

## Sidebar

The lens badge reads `IMPL`. The three minimaps, world map, tree and value-chain map, sit above it, and the map key below it names the four
swatches: lit, lit by passing mentions only, lit ADR file, and idle.

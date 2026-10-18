# Catzc.Base.Globs projects the program, and workflows, pipelines and the branch policy only read it: the diagram described

```text
A 1572 x 660 diagram, read top to bottom through three bands.
Glyphs: 3 files (olive), 3 code units (slate), 2 results (green); 5 flow edges, 2 ADR-only edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--globs-projects-and-three-consumers-read--architecture.drawio.png) draws, in
the vocabulary of the diagram glyphs; what it means is in [the article](globs-projects-and-three-consumers-read.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `COMPOSE`, `PROJECTION` and `TRIGGER`. It holds eight glyphs, three files, three code units and two results,
joined by five flow edges and two dashed ADR-only edges, with eight markers and a legend panel along the bottom. The eye lands first on the
code unit at the centre of the middle band, from which edges leave left and right.

## Reading path

1. Marker 1, top band: the file globs.yml, then right along the edge to marker 2, the code unit GlobSet.
2. Down the vertical edge to marker 3, middle band, centre: the code unit Get-GlobSetTrigger.
3. Left along one edge to marker 4, the result ordered GitHub paths; right along the other to marker 5, the result ADO include and exclude.
4. Down into the bottom band: marker 6, left, the code unit Get-Build…PathFilter, reached by the one diagonal edge from the GitHub result.
5. Marker 7, below the GitHub result: the file .github/workflows/\*.yml, reached by a dashed edge.
6. Marker 8, right, below the ADO result: the file pipelines/\*.yaml, reached by a dashed edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                  |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------ |
| file                  | 3     | globs.yml (top band); .github/workflows/\*.yml and pipelines/\*.yaml (bottom band)                     |
| code unit             | 3     | GlobSet (top band); Get-GlobSetTrigger (middle band, centre); Get-Build…PathFilter (bottom band, left) |
| result                | 2     | ordered GitHub paths (middle band, left); ADO include and exclude (middle band, right)                 |

Files are olive pages with a folded corner, code units slate, results green, all with light names.

## Edges

| Edge kind          | Count | From → to                                                                                                                                                                               |
| ------------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds        | 5     | globs.yml → GlobSet, GlobSet → Get-GlobSetTrigger, Get-GlobSetTrigger → ordered GitHub paths, Get-GlobSetTrigger → ADO include and exclude, ordered GitHub paths → Get-Build…PathFilter |
| ADR-only (no code) | 2     | ordered GitHub paths → .github/workflows/\*.yml, ADO include and exclude → pipelines/\*.yaml (both dashed, vertical)                                                                    |

The edge into Get-Build…PathFilter is the only diagonal; it leaves the underside of the GitHub result near its left end. No edge crosses
another.

## Legend

A full-width panel at the bottom of the drawing area, in two columns, left to right:

| Swatch            | Phrase                                      |
| ----------------- | ------------------------------------------- |
| olive page        | file                                        |
| slate rounded box | code unit                                   |
| green rounded box | result                                      |
| thin arrow        | flow: feeds                                 |
| dashed arrow      | ADR-only (no code): generated into the YAML |
| light disc `1`    | marker: a Walkthrough step                  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--globs-projects-and-three-consumers-read--architecture.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--globs-projects-and-three-consumers-read--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--globs-projects-and-three-consumers-read--architecture.chain.md), which hold the reason
for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

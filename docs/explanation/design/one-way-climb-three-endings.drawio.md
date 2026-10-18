# A commit only climbs, then ends in one of three ways: the diagram described

```text
A 1572 x 600 diagram, read left to right along one row of commits, with three bands stacked top to bottom.
Glyphs: 11 commits (one a ghost); 2 flow edges, 7 ADR-only edges, 1 failure path; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](one-way-climb-three-endings.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three full-width bands stack top to bottom:
SUPERSEDED, THE CLIMB and DISCARDED / RETIRED. Three span bars run above them: CI, CD and DEPLOY. The middle band holds a row of eight
commits read left to right, brown to green; one faded commit sits in the top band and two commits in the bottom band. Every glyph is a
commit in the locked palette. The eye lands first on the row, then on the red line that drops from the third commit.

## Reading path

1. Marker 1, middle band: the brown commit `topic`, then right along the row to the green commit `production`.
2. Up from the light-green commit `release-uat` to marker 2, top band: the faded light-green commit `superseded`.
3. Down the red line from the yellow commit `BVT` to marker 3, bottom band: the red commit `discarded`.
4. Down from `production` to marker 4, bottom band: the green commit `retired`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                       |
| --------------------- | ----- | ------------------------------------------------------------------------------------------- |
| commit                | 11    | eight in the middle band, brown to green; red `discarded` and green `retired` in the bottom |
|                       |       | band; one ghost, `superseded`, in the top band                                              |

The middle row runs brown, grey, yellow, blue, light-blue, light-green, green, green. The ghost `superseded` is light-green, faded, with a
dashed rim. Names sit below the row's commits, except `BVT` and `production`, whose names sit above because an edge leaves them downward;
the three ending names sit to the right of their commits.

## Edges

| Edge kind    | Count | From → to                                                                                                 |
| ------------ | ----- | --------------------------------------------------------------------------------------------------------- |
| flow         | 2     | topic → landed → BVT                                                                                      |
| ADR-only     | 7     | BVT → L3 → main-UAT → release-uat → pre-prod → production; release-uat → superseded; production → retired |
| failure path | 1     | BVT → discarded                                                                                           |

The row edges are straight and horizontal; the three ending edges run straight up or down. None crosses another. No chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                                        | Phrase                               |
| --------------------------------------------- | ------------------------------------ |
| eight small commits, brown to green, then red | commit (locked palette)              |
| faded light-green commit                      | ghost: superseded, last colour faded |
| thin arrow                                    | flow: climbs one rung                |
| dashed arrow                                  | ADR-only (no code)                   |
| red arrow                                     | failure path                         |
| span bar                                      | span bar: stages over bands          |
| dark disc `1`                                 | marker: a Walkthrough step           |
| grey band                                     | band: one lane                       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md),
[tree](../.assets/tree/adr-dsgn-life--one-way-climb-three-endings--meta.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

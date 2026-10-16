---
catzc:
  immutable:
    with_body_sha: "41d4659b92bc"
    path: docs/.assets/explanation/adr-conf-addressing--an-address-is-a-read-only-walk--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-conf-addressing-an-address-is-a-read-only-walk-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-conf-addressing--an-address-is-a-read-only-walk--meta.drawio.png
      - docs/.assets/explanation/chain/adr-conf-addressing--an-address-is-a-read-only-walk--meta.chain.md
      - docs/.assets/explanation/grid/adr-conf-addressing--an-address-is-a-read-only-walk--meta.grid.md
      - docs/.assets/explanation/tree/adr-conf-addressing--an-address-is-a-read-only-walk--meta.tree.md
      - docs/explanation/configuration/an-address-is-a-read-only-walk.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# An address is a read-only walk: the diagram described

```text
A 1572 x 640 diagram, read left to right along one band, with a second band below for the failure.
Glyphs: 2 code units (slate), 1 store (slate), 1 result, 1 failure; 3 flow edges, 1 failure path; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-conf-addressing--an-address-is-a-read-only-walk--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/configuration/an-address-is-a-read-only-walk.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled `RESOLVE`, then down into a full-width band labelled `FAIL FAST`. It holds five glyphs, two code units, one store,
one result and one failure, joined by three flow edges and one failure path, with five markers and a legend panel along the bottom. The eye
lands first on the green result at the right end of the top band.

## Reading path

1. Marker 1, `RESOLVE` band: the code unit caller, at the left.
2. Along the first edge, under its note `global.<config>.<key>`, to marker 2: the code unit one reader.
3. Marker 3: the store session cache, in the middle of the band.
4. Marker 4: the result one node, at the right end of the band.
5. Down the failure path from one reader to marker 5, `FAIL FAST` band: the failure wrong address throws.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                |
| --------------------- | ----- | ---------------------------------------------------- |
| code unit             | 2     | caller (`RESOLVE`, left), one reader (`RESOLVE`)     |
| store                 | 1     | session cache (`RESOLVE`, middle)                    |
| result                | 1     | one node (`RESOLVE`, right)                          |
| failure               | 1     | wrong address throws (`FAIL FAST`, below one reader) |

Code units and the store are slate with white names; the result is green and the failure is the only red.

## Edges

| Edge kind    | Count | From → to                                                                 |
| ------------ | ----- | ------------------------------------------------------------------------- |
| flow         | 3     | caller → one reader, one reader → session cache, session cache → one node |
| failure path | 1     | one reader → wrong address throws                                         |

Every edge is straight: the three flow edges are horizontal and the failure path runs down. None crosses another. A note
`global.<config>.<key>` sits above the first edge.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| slate cylinder    | store                      |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: the walk             |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-CONF-ADDRESSING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid/adr-conf-addressing--an-address-is-a-read-only-walk--meta.grid.md),
[tree](tree/adr-conf-addressing--an-address-is-a-read-only-walk--meta.tree.md) and
[value-chain map](chain/adr-conf-addressing--an-address-is-a-read-only-walk--meta.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-CONF-ADDRESSING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

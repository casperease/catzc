---
catzc:
  immutable:
    with_body_sha: "3b269f439997"
    repo_status: clean
    path: docs/explanation/configuration/one-reader-one-cache-per-session.drawio.md
    folder: docs/explanation/configuration
    name: one-reader-one-cache-per-session-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.png
      - docs/explanation/.assets/chain/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
      - docs/explanation/.assets/grid/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
      - docs/explanation/.assets/tree/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md
      - docs/explanation/configuration/one-reader-one-cache-per-session.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One reader, one cache per session: the diagram described

```text
A 1572 x 600 diagram, read left to right along one band, down into a second band and back up.
Glyphs: 2 code units (slate), 1 store (slate), 1 file (olive), 1 result; 5 flow edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](one-reader-one-cache-per-session.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled READ PATH, then down into a band labelled MISS on the right two thirds and back up. It holds five glyphs (two code
units, one store, one file and one result) joined by five edges, with five markers and a legend panel along the bottom. The eye lands first
on the wide slate code unit at the top left.

## Reading path

1. Marker 1, READ PATH band: the code unit one reader, at the left.
2. Marker 2: the store session cache, in the middle of the band.
3. Marker 3: the result same object, at the right end of the band.
4. Down from the store to marker 4, MISS band: the file config file, directly below the store.
5. Right to marker 5: the code unit parse and type once, and up from its right part into the result.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                           |
| --------------------- | ----- | --------------------------------------------------------------- |
| code unit             | 2     | one reader (READ PATH, left), parse and type once (MISS, right) |
| store                 | 1     | session cache (READ PATH, middle)                               |
| file                  | 1     | config file (MISS, left, below the store)                       |
| result                | 1     | same object (READ PATH, right)                                  |

Code units and the store are slate and the file is olive, all with white names; the result is light green.

## Edges

| Edge kind | Count | From → to                                                                                                                                                  |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | one reader → session cache, session cache → same object, session cache → config file, config file → parse and type once, parse and type once → same object |

Every edge is straight; three are horizontal, one runs down and one runs up. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                                |
| ------------------------- | ------------------------------------- |
| slate rounded box         | code unit                             |
| slate cylinder            | store                                 |
| olive page, folded corner | file                                  |
| light green rounded box   | result                                |
| thin arrow                | flow: the read (hit right, miss down) |
| dark disc `1`             | marker: a Walkthrough step            |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-CONF-LOADING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md),
[tree](../.assets/tree/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md) and
[value-chain map](../.assets/chain/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-CONF-LOADING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

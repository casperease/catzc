---
catzc:
  derived:
    path: docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md
    kind: asset-description
    body_sha: "545cb1dca28b"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# One reader, one cache per session: the diagram described

```text
A 1572 x 600 diagram, read left to right along one band, down into a second band and back up.
Glyphs: 2 code units (slate), 1 store (slate), 1 file (olive), 1 result; 5 flow edges; 5 markers.
Sidebar: world-map grid (4 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/configuration/one-reader-one-cache-per-session.md).

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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md),
[tree](adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md) and
[value-chain map](adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-CONF-LOADING); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (6 files: 6 cite ADR-CONF-LOADING);
  `automation × .ps1` (11 files: 11 cite ADR-CONF-LOADING); `automation × .yml` (1 file: 1 cites ADR-CONF-LOADING); `docs × .md` (5 files: 4
  cite ADR-CONF-LOADING; 1 is the ADR file of ADR-CONF-LOADING).
- **Tree** (the repository's files): 10 lit groups, `Docs` (9 files); `Config` (2 files); `Git` (2 files); `QualityGates` (2 files);
  `adr/conf` (2 files); `docs` (2 files); `Execution` (1 file); `ModuleSystem` (1 file); `RootConfig` (1 file); `adr/*` (1 file). The ADR
  file `docs/adr/configuration/module-config-loading.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × AUTOMA`, because ADR-CONF-LOADING:
  its ADR domain `configuration` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern
  (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-CONF-LOADING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

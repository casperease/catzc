---
catzc:
  derived:
    path: docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "4c4c1279b03a"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
      - docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.png
      - docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
      - docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md
      - docs/explanation/configuration/ask-by-name-get-the-cached-object.md
---

# Ask by name, get the cached object: the diagram described

```text
A 1572 x 700 diagram, read left to right along one band, down into a second band and back up, then down to a band of failures.
Glyphs: 3 code units (slate), 1 store (slate), 1 result, 3 failures; 5 flow edges, 3 failure paths; 8 markers.
Sidebar: world-map grid (4 lit cells), tree (12 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/configuration/ask-by-name-get-the-cached-object.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled WHAT YOU RUN, down into a band labelled FIRST READ on the right and back up, and down again into a full-width band
labelled THROWS at the bottom. It holds eight glyphs (three code units, one store, one result and three failures) joined by eight edges,
five flow and three failure paths, with eight markers and a legend panel along the bottom. The eye lands first on the three red failures
along the bottom band.

## Reading path

1. Markers 1 to 4, WHAT YOU RUN band, left to right: the code units Get-ConfigValue · Get-Config and name → one file, the store session
   cache and the result same object.
2. Down from the store to marker 5, FIRST READ band: the wide code unit parsed and typed, whose right part sends an edge up into the result.
3. Markers 6 to 8, THROWS band, left to right: the failures bad key (under the first code unit), unknown or ambiguous name (under name → one
   file) and malformed config (under parsed and typed), each fed by a red failure path from the glyph above it.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                          |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------- |
| code unit             | 3     | Get-ConfigValue · Get-Config and name → one file (WHAT YOU RUN), parsed and typed (FIRST READ) |
| store                 | 1     | session cache (WHAT YOU RUN, middle)                                                           |
| result                | 1     | same object (WHAT YOU RUN, right)                                                              |
| failure               | 3     | bad key, unknown or ambiguous name, malformed config (THROWS, left to middle)                  |

Code units and the store are slate with white names; the result is light green and the failures light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                      |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow         | 5     | Get-ConfigValue · Get-Config → name → one file, name → one file → session cache, session cache → same object, session cache → parsed and typed, parsed and typed → same object |
| failure path | 3     | Get-ConfigValue · Get-Config → bad key, name → one file → unknown or ambiguous name, parsed and typed → malformed config                                                       |

Every edge is straight; the three failure paths run straight down, and none crosses another edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                      |
| ----------------------- | ------------------------------------------- |
| slate rounded box       | code unit                                   |
| slate cylinder          | store                                       |
| light green rounded box | result                                      |
| light red rounded box   | failure                                     |
| thin grey arrow         | flow: what runs next (hit right, miss down) |
| thin red arrow          | failure path: the call that throws          |
| dark disc `1`           | marker: a Walkthrough step                  |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md),
[tree](adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md) and
[value-chain map](adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-CONF-ADDRESSING, ADR-CONF-LOADING); the explanation articles, these descriptions and the drawing
tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (6 files: 6 cite ADR-CONF-LOADING);
  `automation × .ps1` (15 files: 15 cite ADR-CONF-ADDRESSING, ADR-CONF-LOADING); `automation × .yml` (1 file: 1 cites ADR-CONF-ADDRESSING,
  ADR-CONF-LOADING); `docs × .md` (6 files: 4 cite ADR-CONF-ADDRESSING, ADR-CONF-LOADING; 2 are the ADR file of ADR-CONF-ADDRESSING,
  ADR-CONF-LOADING).
- **Tree** (the repository's files): 12 lit groups, `Docs` (9 files); `Config` (3 files); `adr/conf` (3 files); `Git` (2 files); `Languages`
  (2 files); `QualityGates` (2 files); `docs` (2 files); `Az.Templates` (1 file); `Execution` (1 file); `ModuleSystem` (1 file);
  `RootConfig` (1 file); `adr/*` (1 file). The ADR files `docs/adr/configuration/config-value-addressing.md`,
  `docs/adr/configuration/module-config-loading.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × LOCAL`, because ADR-CONF-ADDRESSING:
  its ADR domain `configuration` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern
  (ADR-DSGN-TRACK#15); ADR-CONF-LOADING: its ADR domain `configuration` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR
  domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-CONF-LOADING" and "ADR-CONF-ADDRESSING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

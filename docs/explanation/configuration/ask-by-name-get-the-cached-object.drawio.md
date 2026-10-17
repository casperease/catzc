---
catzc:
  immutable:
    with_body_sha: "42cf477b72c6"
    repo_status: clean
    path: docs/explanation/configuration/ask-by-name-get-the-cached-object.drawio.md
    folder: docs/explanation/configuration
    name: ask-by-name-get-the-cached-object-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.png
      - docs/explanation/.assets/chain/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
      - docs/explanation/.assets/grid/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
      - docs/explanation/.assets/tree/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md
      - docs/explanation/configuration/ask-by-name-get-the-cached-object.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Ask by name, get the cached object: the diagram described

```text
A 1572 x 700 diagram, read left to right along one band, down into a second band and back up, then down to a band of failures.
Glyphs: 3 code units (slate), 1 store (slate), 1 result, 3 failures; 5 flow edges, 3 failure paths; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](ask-by-name-get-the-cached-object.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-CONF-ADDRESSING and ADR-CONF-LOADING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md),
[tree](../.assets/tree/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md) and
[value-chain map](../.assets/chain/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-CONF-ADDRESSING and ADR-CONF-LOADING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

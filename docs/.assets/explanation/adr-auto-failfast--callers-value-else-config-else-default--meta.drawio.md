---
catzc:
  immutable:
    with_body_sha: "4b3cb5d131b4"
    path: docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-failfast-callers-value-else-config-else-default-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.chain.md
      - docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.drawio.png
      - docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.grid.md
      - docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.tree.md
      - docs/explanation/automation/callers-value-else-config-else-default.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Every wait is bounded: the caller's value, else the config, else the default: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 code units (slate), 2 files (olive), 1 result (green); 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-auto-failfast--callers-value-else-config-else-default--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/automation/callers-value-else-config-else-default.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `LIMIT`, `RAISE` and `CONSUMERS`, the first twice as wide as the others. It holds five glyphs on one row, two code units,
two files and one result, joined by four flow edges into a single chain, with five markers and a legend panel below the bands. The eye lands
first on the green result at the right end of the chain.

## Reading path

1. Marker 1, left of the `LIMIT` band: the code unit the caller.
2. Right along the chain: marker 2, the file the config file; marker 3, the code unit the declared default.
3. Across the band gap to marker 4, `RAISE` band: the file the exemption ceiling.
4. Across the next gap to marker 5, `CONSUMERS` band: the result one bounded wait.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                              |
| --------------------- | ----- | ------------------------------------------------------------------ |
| code unit             | 2     | the caller (`LIMIT`, left), the declared default (`LIMIT`, right)  |
| file                  | 2     | the config file (`LIMIT`, middle), the exemption ceiling (`RAISE`) |
| result                | 1     | one bounded wait (`CONSUMERS`)                                     |

Code units are slate, files olive, and the result green, all with white names.

## Edges

| Edge kind | Count | From → to                                                                                                                                                    |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 4     | the caller → the config file, the config file → the declared default, the declared default → the exemption ceiling, the exemption ceiling → one bounded wait |

Every edge is straight and horizontal on the one row, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel below the bands, in two columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| olive page        | file                       |
| green rounded box | result                     |
| thin arrow        | flow: resolution order     |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-auto-failfast--callers-value-else-config-else-default--meta.grid.md),
[tree](adr-auto-failfast--callers-value-else-config-else-default--meta.tree.md) and [value-chain map](adr-auto-failfast--callers-value-else-config-else-default--meta.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

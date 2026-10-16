---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "1be7d8fdbd51"
    links:
      - docs/.assets/explanation/adr-auto-failfast--callers-value-else-config-else-default--meta.drawio.png
      - docs/explanation/automation/callers-value-else-config-else-default.md
---

# Every wait is bounded: the caller's value, else the config, else the default: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 code units (slate), 2 files (olive), 1 result (green); 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key.
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

The lens badge reads `META`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.

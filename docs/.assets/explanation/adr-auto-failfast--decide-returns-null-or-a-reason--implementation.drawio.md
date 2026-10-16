---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-failfast--decide-returns-null-or-a-reason--implementation.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "5855147b5863"
    links:
      - docs/.assets/explanation/adr-auto-failfast--decide-returns-null-or-a-reason--implementation.drawio.png
      - docs/explanation/automation/decide-returns-null-or-a-reason.md
---

# Decide returns null or a reason: the diagram described

```text
A 1572 x 710 diagram, read top to bottom through four bands.
Glyphs: 2 files (olive), 4 code units (slate), 1 result, 1 failure; 6 flow edges, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-failfast--decide-returns-null-or-a-reason--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/automation/decide-returns-null-or-a-reason.md).

## At a glance

A 1572 × 710 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `LOAD`, `DECIDE`, `VERDICT` and `LOG`. It holds eight glyphs, two files, four code units, one result and one
failure, joined by six flow edges and one failure path, with eight markers and a legend panel along the bottom. The eye lands first on the
wide code unit across the middle of the `DECIDE` band, with two edges coming down into it and three leaving it.

## Reading path

1. Markers 1, 2 and 3, `LOAD` band, left to right: the file timeouts.yml, a flow edge into the code unit TimeoutsConfig, then the code unit
   BashSafeguard.EnvironmentOf.
2. Down two flow edges to marker 4, `DECIDE` band: the wide code unit BashSafeguard.Decide; a flow edge leaves it to the right to marker 5,
   the code unit BoundedCommand.Check.
3. Down from Decide to the `VERDICT` band: a flow edge to marker 6, the result let through, no output, on the left, and a failure path to
   marker 7, the failure DenyOutput: deny + reason, on the right.
4. Down the flow edge from the failure to marker 8, `LOG` band: the file out/time-safeguard.log.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                 |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| file                  | 2     | timeouts.yml (`LOAD` band, left), out/time-safeguard.log (`LOG` band)                                                 |
| code unit             | 4     | TimeoutsConfig, BashSafeguard.EnvironmentOf (`LOAD` band); BashSafeguard.Decide, BoundedCommand.Check (`DECIDE` band) |
| result                | 1     | let through, no output (`VERDICT` band, left)                                                                         |
| failure               | 1     | DenyOutput: deny + reason (`VERDICT` band, right)                                                                     |

Code units are slate and files olive, both with light names; the result is green and the failure red, the only red on the page.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow         | 6     | timeouts.yml → TimeoutsConfig, TimeoutsConfig → Decide, EnvironmentOf → Decide, Decide → BoundedCommand.Check, Decide → let through, DenyOutput → out/time-safeguard.log |
| failure path | 1     | Decide → DenyOutput                                                                                                                                                      |

Every edge is straight, five vertical and two horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| green rounded box | result                     |
| red rounded box   | failure                    |
| light arrow       | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `IMPL`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.

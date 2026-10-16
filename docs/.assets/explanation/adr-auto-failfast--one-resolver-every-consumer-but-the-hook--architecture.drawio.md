---
catzc:
  immutable:
    with_body_sha: "51d044bb6625"
    path: docs/.assets/explanation/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-failfast-one-resolver-every-consumer-but-the-hook-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.png
      - docs/explanation/automation/one-resolver-every-consumer-but-the-hook.md
---

# One resolver serves every consumer but the hook: the diagram described

```text
A 1572 x 640 diagram, read left to right through four bands.
Glyphs: 6 code units (slate), 1 gate (neutral); 1 frame; 5 flow edges; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/automation/one-resolver-every-consumer-but-the-hook.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands, labelled `AXES`, `LIMIT`, `RAISE` and `CONSUMERS`. It holds seven glyphs, six code units and one gate, on three rows; a frame in the
last band groups two of the code units. Five flow edges join them, one of them bent once, with seven markers and a legend panel below the
bands. The eye lands first on the gate, the only rhombus, at the top right.

## Reading path

1. Marker 1, bottom of the `AXES` band: the code unit Get-RunEnvironment.
2. Up to marker 2, top of the `LIMIT` band: the code unit TimeoutsConfig, with one edge leaving right along the top row and one leaving its
   underside.
3. Marker 3, middle row of the `RAISE` band: the code unit TimeoutExemptionsConfig.
4. Down to marker 4, bottom row of the `RAISE` band: the code unit Get-TimeoutSeconds, where three edges arrive.
5. Marker 5, top of the `CONSUMERS` band: the gate Assert-BashTimeout, where the top-row edge ends.
6. Markers 6 and 7, inside the frame below it: the code units Invoke-Executable and Invoke-WithTimeout, where the last edge ends.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                 |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 6     | Get-RunEnvironment (`AXES`), TimeoutsConfig (`LIMIT`), TimeoutExemptionsConfig and Get-TimeoutSeconds (`RAISE`), Invoke-Executable and Invoke-WithTimeout (`CONSUMERS`, in the frame) |
| gate                  | 1     | Assert-BashTimeout (`CONSUMERS`, top)                                                                                                                                                 |

Code units are slate with white names; the gate is a neutral dark rhombus with a light rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                          |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 5     | Get-RunEnvironment → Get-TimeoutSeconds, TimeoutsConfig → Get-TimeoutSeconds (down, then right), TimeoutsConfig → Assert-BashTimeout, TimeoutExemptionsConfig → Get-TimeoutSeconds, Get-TimeoutSeconds → the frame |

Four edges are straight; the one from TimeoutsConfig to Get-TimeoutSeconds turns once. None crosses another, and none carries a label or a
chip. The edge into the frame ends on its left side, not on either code unit inside it.

## Legend

A full-width panel below the bands, in two columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| thin arrow        | flow: feeds                |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `ARCH`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.

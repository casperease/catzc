---
catzc:
  derived:
    path: docs/.assets/explanation/adr-conf-addressing--type-an-address-get-the-value--operations.drawio.md
    kind: asset-description
    body_sha: a3f8ef2c85f5
    adrs: []
---

# Type an address, get the value: the diagram described

```text
A 1572 x 660 diagram, read left to right through three bands side by side, in three rows.
Glyphs: 3 code units (slate), 3 results, 2 failures; 3 flow edges, 2 failure paths; 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-conf-addressing--type-an-address-get-the-value--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/configuration/type-an-address-get-the-value.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled `COMMAND`, `WHAT YOU SEE` and `FAIL FAST`, in three rows. It holds eight glyphs, three code units, three
results and two failures, joined by three flow edges and two failure paths, with eight markers and a legend panel along the bottom. The eye
lands first on the three wide green results in the middle band.

## Reading path

1. Marker 1, `COMMAND` band, top row: the code unit Get-ConfigValue; right, under the note `'global.azure.…'`, to marker 2, `WHAT YOU SEE`
   band: the result '0.43.8'.
2. Marker 3, middle row: the code unit Write-EnvironmentSet; right, under the note `-Set @{ … }`, to marker 4: the result BICEP = 0.43.8 ·
   TOK = \*\*\*.
3. Marker 5, bottom row: the code unit Build-Bicep; right, under the note `{ address: global.… }`, to marker 6: the result
   parameters.&lt;config&gt;.json.
4. Marker 7, `FAIL FAST` band, between the top and middle rows: the failure wrong address throws, reached by the failure path that leaves
   the bottom of Get-ConfigValue and turns right.
5. Marker 8, below the bottom row: the failure invalid addressed parameters, reached by the failure path that leaves the bottom of
   Build-Bicep and turns right.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                   |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------- |
| code unit             | 3     | Get-ConfigValue, Write-EnvironmentSet, Build-Bicep (`COMMAND`, top to bottom)                           |
| result                | 3     | '0.43.8', BICEP = 0.43.8 · TOK = \*\*\*, parameters.&lt;config&gt;.json (`WHAT YOU SEE`, top to bottom) |
| failure               | 2     | wrong address throws (`FAIL FAST`, upper), invalid addressed parameters (`FAIL FAST`, lower)            |

Code units are slate with white names; the results are green and the failures are the only red.

## Edges

| Edge kind    | Count | From → to                                                                                                                      |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------ |
| flow         | 3     | Get-ConfigValue → '0.43.8', Write-EnvironmentSet → BICEP = 0.43.8 · TOK = \*\*\*, Build-Bicep → parameters.&lt;config&gt;.json |
| failure path | 2     | Get-ConfigValue → wrong address throws, Build-Bicep → invalid addressed parameters                                             |

The flow edges are horizontal. Each failure path leaves the bottom of its code unit, turns right once, and runs between the rows of the
middle band to its failure; none crosses a glyph. Three notes sit above the flow edges: `'global.azure.…'`, `-Set @{ … }` and
`{ address: global.… }`.

## Legend

A full-width panel at the bottom of the drawing area, in two columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: prints or writes     |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps sit above it, and the map key below it names the four swatches.

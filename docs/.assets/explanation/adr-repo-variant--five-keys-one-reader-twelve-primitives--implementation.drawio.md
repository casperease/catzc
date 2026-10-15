---
catzc:
  derived:
    path: docs/.assets/explanation/adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.drawio.md
    kind: asset-description
    body_sha: "22fa3dc3233b"
    links:
      - docs/.assets/explanation/adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.drawio.png
      - docs/explanation/repository/five-keys-one-reader-twelve-primitives.md
---

# Five keys, one private reader, twelve exported primitives: the diagram described

```text
A 1572 x 688 diagram, read top to bottom through four bands.
Glyphs: 1 file (olive), 9 code units (slate); 6 downward edges; 10 markers; one frame around the accessor row.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/repository/five-keys-one-reader-twelve-primitives.md).

## At a glance

A 1572 × 688 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `FILE`, `READ PATH`, `ACCESSORS` and `GUARDS`. It holds ten glyphs: a file and two code units in one centred
column through the first two bands, then four code units in a row across the third band, inside a thin frame, and three code units in a row
across the fourth, each under its accessor. Six downward edges join them, with ten markers and a legend panel along the bottom. The eye
lands first on the olive file at the top of the column.

## Reading path

1. Marker 1, top band: the file `variants.yml`, centred.
2. Down one edge to marker 2, second band: the code unit `Get-Config -Config variants`; down again to marker 3, `Get-Variant`.
3. Down one edge to the top of the frame in the third band, then left to right along the row: marker 4 `Get-AdoNaming`, marker 5
   `Get-GitWorkspace`, marker 6 `Get-EnabledCustomers`, marker 7 `Get-Aspect · Get-Track`.
4. Down the three vertical edges to the bottom band, left to right: marker 8 `Test-/Assert-AdoNaming`, marker 9 `Test-GitWorkspace`, marker
   10 `Test-/Assert-HaveCustomer(s)`. The fourth column of the bottom band is empty.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                                                                                                     |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | `variants.yml` (top band)                                                                                                                                                                                                                                                 |
| code unit             | 9     | `Get-Config -Config variants`, `Get-Variant` (second band); `Get-AdoNaming`, `Get-GitWorkspace`, `Get-EnabledCustomers`, `Get-Aspect · Get-Track` (third band, in the frame); `Test-/Assert-AdoNaming`, `Test-GitWorkspace`, `Test-/Assert-HaveCustomer(s)` (bottom band) |

The file is olive and the code units slate, all with light names. The frame around the accessor row is chrome: no fill, a thin dark rim.

## Edges

| Edge kind   | Count | From → to                                                                                                                                                                                                                                         |
| ----------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds | 6     | variants.yml → Get-Config -Config variants; Get-Config -Config variants → Get-Variant; Get-Variant → the frame; Get-AdoNaming → Test-/Assert-AdoNaming; Get-GitWorkspace → Test-GitWorkspace; Get-EnabledCustomers → Test-/Assert-HaveCustomer(s) |

Every edge is straight and vertical, and none crosses another. The edge from `Get-Variant` ends on the frame's top side, between the second
and third accessors. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns over one row, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| thin arrow        | flow: feeds                |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `IMPL`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.

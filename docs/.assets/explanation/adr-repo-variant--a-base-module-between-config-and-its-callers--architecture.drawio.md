# docs/.assets/explanation/adr-repo-variant--a-base-module-between-config-and-its-callers--architecture.drawio.md

`Catzc.Base.Variants sits in Base, over Config, under every real caller: the diagram described`

```text
A 1572 x 648 diagram, read top to bottom through three bands.
Glyphs: 1 file (olive), 5 code units (slate), 1 named set (mauve), 1 ADR-only (dashed); 7 edges; 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-repo-variant--a-base-module-between-config-and-its-callers--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/repository/a-base-module-between-config-and-its-callers.md).

## At a glance

A 1572 × 648 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `FOUNDATION`, `VARIANTS` and `CALLERS`. It holds eight glyphs: a file and three code units in the top band, one
wide code unit spanning the middle band, and a named set, a code unit and an ADR-only glyph in the bottom band, joined by seven edges, with
eight markers and a legend panel along the bottom. The eye lands first on the wide slate code unit in the middle band.

## Reading path

1. Marker 1, top band, left: the file `variants.yml`; one edge runs right to marker 2, the code unit `Catzc.Base.Config`.
2. Markers 3 and 4, top band, centre and right: the code units `Catzc.Base.Objects` and `Catzc.Base.Asserts`.
3. Down the three vertical edges from Config, Objects and Asserts to marker 5, middle band: the wide code unit `Catzc.Base.Variants`.
4. Down the three vertical edges that leave it, to the bottom band: marker 6, the named set `AzureExt` (thick edge); marker 7, the code unit
   `Globs · ModuleSystem · Maps` (thin edge); marker 8, the ADR-only glyph `Tooling` (dashed edge).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | `variants.yml` (top band, left)                                                                                                                                                  |
| code unit             | 5     | `Catzc.Base.Config`, `Catzc.Base.Objects`, `Catzc.Base.Asserts` (top band); `Catzc.Base.Variants` (middle band, full width); `Globs · ModuleSystem · Maps` (bottom band, centre) |
| named set             | 1     | `AzureExt` (bottom band, left)                                                                                                                                                   |
| ADR-only              | 1     | `Tooling` (bottom band, right), a dashed rounded box on the page colour                                                                                                          |

The file is olive, the code units slate and the named set mauve, all with light names; the ADR-only glyph has a dashed light rim.

## Edges

| Edge kind             | Count | From → to                                                                                                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: is used by      | 5     | variants.yml → Catzc.Base.Config; Catzc.Base.Config, Catzc.Base.Objects, Catzc.Base.Asserts → Catzc.Base.Variants; Catzc.Base.Variants → Globs · ModuleSystem · Maps |
| thick, to a named set | 1     | Catzc.Base.Variants → AzureExt                                                                                                                                       |
| ADR-only (no code)    | 1     | Catzc.Base.Variants → Tooling, dashed                                                                                                                                |

One edge is horizontal, the file to Config; the other six are vertical, in three columns, and none crosses another. No edge carries a label
or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns over two rows, left to right:

| Swatch             | Phrase                     |
| ------------------ | -------------------------- |
| olive page         | file                       |
| slate rounded box  | code unit                  |
| mauve rounded box  | named set                  |
| dashed rounded box | ADR-only                   |
| thin arrow         | flow: is used by           |
| thick arrow        | to a named set             |
| dashed arrow       | ADR-only (no code)         |
| light disc `1`     | marker: a Walkthrough step |

## Sidebar

The lens badge reads `ARCH`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.

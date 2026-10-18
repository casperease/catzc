# A repo-wide switch has one home, one read path and one guard vocabulary: the diagram described

```text
A 1572 x 648 diagram, read top to bottom through four bands.
Glyphs: 1 file (olive), 2 code units (slate), 1 named set (mauve); 3 downward edges; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../one-home-one-read-path-one-vocabulary.md).

## At a glance

A 1572 × 648 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `VARIANT`, `READER`, `PRIMITIVES` and `CALLERS`. It holds four glyphs in one centred column, a file, two code
units and a named set, joined by three downward edges, with four markers and a legend panel along the bottom. The eye lands first on the
olive file at the top of the column.

## Reading path

1. Marker 1, top band: the file `one home`, centred.
2. Down one edge to marker 2, second band: the code unit `one read path`.
3. Down one edge to marker 3, third band: the code unit `one guard vocabulary`.
4. Down the thick edge to marker 4, bottom band: the named set `any module above Config`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                              |
| --------------------- | ----- | ------------------------------------------------------------------ |
| file                  | 1     | `one home` (top band)                                              |
| code unit             | 2     | `one read path` (second band), `one guard vocabulary` (third band) |
| named set             | 1     | `any module above Config` (bottom band)                            |

The file is olive, the code units slate and the named set mauve, all with light names.

## Edges

| Edge kind             | Count | From → to                                                      |
| --------------------- | ----- | -------------------------------------------------------------- |
| flow: feeds           | 2     | one home → one read path, one read path → one guard vocabulary |
| thick, to a named set | 1     | one guard vocabulary → any module above Config                 |

Every edge is straight and vertical, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns over two rows, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| mauve rounded box | named set                  |
| thin arrow        | flow: feeds                |
| thick arrow       | to a named set             |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-REPO-VARIANT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-REPO-VARIANT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

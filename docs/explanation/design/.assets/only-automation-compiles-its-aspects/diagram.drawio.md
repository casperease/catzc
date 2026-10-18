# Both tracks' conventions are read, but only the automation track's compiles into globsets: the diagram described

```text
A 1572 x 654 diagram, read top to bottom from a file and a wide code unit into two side-by-side column bands.
Glyphs: 1 file (olive), 3 code units (slate), 2 named sets (mauve), 1 result; 4 flow edges, 1 thick edge; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../only-automation-compiles-its-aspects.md).

## At a glance

A 1572 × 654 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. A file glyph
sits centred at the top, a wide code unit spans the drawing area below it, and under that two column bands sit side by side, labelled
`AUTOMATION` on the left and `INFRASTRUCTURE` on the right. The left band holds a code unit above a frame with two named sets side by side;
the right band holds a code unit above a result. Five edges point down, seven markers number the glyphs, and a legend panel runs along the
bottom. The eye lands first on the wide slate code unit across the top.

## Reading path

1. Marker 1, top centre: the file variants.yml; down one flow edge to marker 2, the wide code unit Catzc.Base.Variants.
2. Down the left flow edge into the left band: marker 3, the code unit Catzc.Base.Globs; then down the thick edge into the frame, markers 4
   and 5, the named sets &lt;module&gt;-live and &lt;module&gt;-tests.
3. Down the right flow edge into the right band: marker 6, the code unit Catzc.Base.Maps; then down to marker 7, the result world map.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                  |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------ |
| file                  | 1     | variants.yml (top centre)                                                                              |
| code unit             | 3     | Catzc.Base.Variants (wide, below the file), Catzc.Base.Globs (left band), Catzc.Base.Maps (right band) |
| named set             | 2     | &lt;module&gt;-live and &lt;module&gt;-tests (left band, bottom, inside one frame)                     |
| result                | 1     | world map (right band, bottom)                                                                         |

The file is olive, the code units slate and the named sets mauve, all with white names; the result is green with a white name. The frame
around the two named sets is a thin grey rounded rim with no fill.

## Edges

| Edge kind              | Count | From → to                                                                                                                                      |
| ---------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| flow                   | 4     | variants.yml → Catzc.Base.Variants; Catzc.Base.Variants → Catzc.Base.Globs; Catzc.Base.Variants → Catzc.Base.Maps; Catzc.Base.Maps → world map |
| thick (to a named set) | 1     | Catzc.Base.Globs → the frame around &lt;module&gt;-live and &lt;module&gt;-tests                                                               |

Every edge is straight and vertical, pointing down. The two that leave the wide code unit start at its lower edge above each column's
centre. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in two rows of up to four, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive folded page | file                       |
| slate rounded box | code unit                  |
| mauve rounded box | named set                  |
| green rounded box | result                     |
| thin arrow        | flow: feeds                |
| thick arrow       | to a named set: derives    |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-ASPECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

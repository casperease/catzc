# One module folder has two independent readers: the diagram described

```text
A 1572 x 722 diagram, read left to right from a tall code unit into two bands.
Glyphs: 4 code units (slate), 1 file (olive), 2 named sets (mauve), 1 ADR-only; 8 edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../one-folder-two-independent-readers.md).

## At a glance

A 1572 × 722 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right. A tall code unit
stands outside the bands on the far left, and two full-width bands sit to its right: VISIBILITY (short, on top) and ASPECTS (tall, below).
It holds eight glyphs (four code units, one file, two named sets and one ADR-only) joined by eight edges, with eight markers and a legend
panel along the bottom. The eye lands first on the tall code unit on the left.

## Reading path

1. Marker 1, left of the bands: the code unit automation/&lt;Module&gt;/.
2. Right along the top edge into VISIBILITY: marker 2, the code unit Catzc.Internal.Bootstrap, then marker 3, the file &lt;Module&gt;.psd1.
3. Back to the left, along the lower edge into ASPECTS: marker 4, the code unit Catzc.Base.Variants, with an edge down to marker 5, the tall
   code unit Catzc.Base.Globs.
4. Right along two thick edges: marker 6, the named set &lt;module&gt;-live, above marker 7, the named set &lt;module&gt;-tests.
5. Right along two dashed edges to marker 8, the ADR-only glyph aspect sha locks.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                            |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 4     | automation/&lt;Module&gt;/ (far left, outside the bands), Catzc.Internal.Bootstrap (VISIBILITY), Catzc.Base.Variants and Catzc.Base.Globs (ASPECTS, left column) |
| file                  | 1     | &lt;Module&gt;.psd1 (VISIBILITY, right of Bootstrap)                                                                                                             |
| named set             | 2     | &lt;module&gt;-live above &lt;module&gt;-tests (ASPECTS, middle column)                                                                                          |
| ADR-only              | 1     | aspect sha locks (ASPECTS, right column; dashed white box, as tall as Globs)                                                                                     |

Code units are slate, the file is olive and the named sets are mauve, all with white names.

## Edges

| Edge kind              | Count | From → to                                                                                                                                                                     |
| ---------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow                   | 4     | automation/&lt;Module&gt;/ → Catzc.Internal.Bootstrap, Bootstrap → &lt;Module&gt;.psd1, automation/&lt;Module&gt;/ → Catzc.Base.Globs, Catzc.Base.Variants → Catzc.Base.Globs |
| thick (to a named set) | 2     | Catzc.Base.Globs → &lt;module&gt;-live, Catzc.Base.Globs → &lt;module&gt;-tests                                                                                               |
| ADR-only               | 2     | &lt;module&gt;-live → aspect sha locks, &lt;module&gt;-tests → aspect sha locks                                                                                               |

Seven edges are straight and horizontal, pointing right; the Variants → Globs edge points straight down. None crosses another, and none
carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in four columns of two rows, left to right:

| Swatch                    | Phrase                     |
| ------------------------- | -------------------------- |
| slate rounded box         | code unit                  |
| olive page, folded corner | file                       |
| mauve rounded box         | named set                  |
| dashed white box          | ADR-only                   |
| thin arrow                | flow: reads, then derives  |
| thick arrow               | thick: to a named set      |
| dashed arrow              | ADR-only (no code)         |
| dark disc `1`             | marker: a Walkthrough step |

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

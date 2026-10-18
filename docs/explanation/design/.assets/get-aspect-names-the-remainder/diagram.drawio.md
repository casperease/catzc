# Get-Aspect names each track's remainder, and a wrong order fails when the variants config loads: the diagram described

```text
A 1572 x 654 diagram, read top to bottom from one wide file into two side-by-side column bands, with a failure beside the file.
Glyphs: 1 file (olive), 2 code units (slate), 4 named sets (mauve), 1 failure; 2 flow edges, 4 thick edges, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../get-aspect-names-the-remainder.md).

## At a glance

A 1572 × 654 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. A wide file
glyph spans most of the top, with a failure to its right, and below them two column bands sit side by side, labelled `PWSH` on the left and
`INFRASTRUCTURE` on the right. Each band stacks a code unit above two named sets. Seven edges join the glyphs, eight markers number them,
and a legend panel runs along the bottom. The eye lands first on the red failure at the top right.

## Reading path

1. Marker 1, top: the wide file variants.yml; right along the failure path to marker 2, the failure the last aspect must be '**'.
2. Down the left flow edge into the left band: marker 3, the code unit Get-Aspect -Track pwsh; then down two thick edges to marker 4, the
   named set live, and marker 5, the named set tests.
3. Down the right flow edge into the right band: marker 6, the code unit Get-Aspect…infrastructure; then down two thick edges to marker 7,
   the named set tests, and marker 8, the named set live.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                         |
| --------------------- | ----- | --------------------------------------------------------------------------------------------- |
| file                  | 1     | variants.yml (top, spanning both columns)                                                     |
| code unit             | 2     | Get-Aspect -Track pwsh (left band, top), Get-Aspect…infrastructure (right band, top)          |
| named set             | 4     | live and tests (left band, middle and bottom), tests and live (right band, middle and bottom) |
| failure               | 1     | the last aspect must be '**' (top right, beside the file)                                     |

The file is olive, the code units slate and the named sets mauve, all with white names; the failure is red with a pale name. The right
band's code unit name is elided in the middle; the article gives it in full.

## Edges

| Edge kind              | Count | From → to                                                                                    |
| ---------------------- | ----- | -------------------------------------------------------------------------------------------- |
| flow                   | 2     | variants.yml → Get-Aspect -Track pwsh; variants.yml → Get-Aspect…infrastructure              |
| thick (to a named set) | 4     | Get-Aspect -Track pwsh → live, live → tests; Get-Aspect…infrastructure → tests, tests → live |
| failure path           | 1     | variants.yml → the last aspect must be '**'                                                  |

The failure path is horizontal, pointing right, from the file's right edge; the other six edges are vertical, pointing down, and the two
that leave the file start at its lower edge above each column's centre. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in two rows of four, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| olive folded page | file                              |
| slate rounded box | code unit                         |
| mauve rounded box | named set                         |
| red rounded box   | failure                           |
| thin arrow        | flow: feeds                       |
| thick arrow       | to a named set: returned in order |
| red arrow         | failure path                      |
| light disc `1`    | marker: a Walkthrough step        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-ASPECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions, [world map](grid.md), [tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

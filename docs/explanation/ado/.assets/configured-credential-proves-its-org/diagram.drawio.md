# The first configured credential wins, and it must prove its org: the diagram described

```text
A 1588 x 796 diagram, read left to right across three bands: RETURNS, FIRST CONFIGURED SOURCE, RAISES.
Glyphs: 3 gates, 1 result, 1 failure; 5 flow edges, 2 failure paths; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../configured-credential-proves-its-org.md). The drawing is put from its declaration, [diagram.yml](diagram.yml).

## At a glance

A 1588 × 796 canvas: a 1300 px drawing area on the left and the sidebar on the right. Three bands stand side by side: RETURNS, FIRST
CONFIGURED SOURCE and RAISES. The middle band holds a column of three gates; the left band holds the result and the right band the failure,
each level with the middle gate. Seven edges join them, five markers number the steps, and a legend panel runs along the bottom. The eye
lands first on the column of gates.

## Reading path

1. Marker 1, middle band, top: the gate Pipeline token.
2. Down a flow edge to marker 2, the gate Personal access token, and down again to marker 3, the gate Interactive login.
3. Left along the three flow edges, which fan in from the gates, to marker 4, the result Authorization header.
4. Right along the two failure paths, from the gates at the top and the bottom, to marker 5, the failure Own error, no fallback.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                 |
| --------------------- | ----- | ------------------------------------------------------------------------------------- |
| gate                  | 3     | Pipeline token, Personal access token, Interactive login (middle band, top to bottom) |
| result                | 1     | Authorization header (left band, level with the middle gate)                          |
| failure               | 1     | Own error, no fallback (right band, level with the middle gate)                       |

Gates are grey with a thick rim, the result is green and the failure is red.

## Edges

| Edge kind    | Count | From → to                                                                                    |
| ------------ | ----- | -------------------------------------------------------------------------------------------- |
| flow         | 5     | Pipeline token → Personal access token → Interactive login; each gate → Authorization header |
| failure path | 2     | Pipeline token → Own error, no fallback; Interactive login → Own error, no fallback          |

Every edge is straight and leaves its gate at the diamond's outline; none crosses another. The gate in the middle has no failure path.

## Legend

A full-width panel at the bottom of the drawing area, derived from the kinds the drawing uses, in two columns:

| Swatch                  | Phrase                       |
| ----------------------- | ---------------------------- |
| green rounded box       | result                       |
| grey rhombus, thick rim | gate                         |
| red rounded box         | failure                      |
| grey arrow              | flow (one meaning per slide) |
| red arrow               | failure path                 |
| dark disc `1`           | marker: a Walkthrough step   |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-ADO-AUTH-FIXEDCREDENTIALPRECEDENCE, ADR-ADO-AUTH-PROVETARGET and ADR-ADO-AUTH-ASSERTWHENNOTOKEN): what `Get-WorldMapHighlight` and
`Get-ValueChainHighlight` return today ([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain
responsibilities; placement by [Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run `Build-Diagrams -Path` on
this folder: it derives the codes from the slide, computes the highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md), [tree](tree.md) and [value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** META. The rule codes are not repeated here; the subtitle is their one place.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

# Clients bridge to one server remote: in through a pull request, out from the verified point: the diagram described

```text
A 1572 x 900 diagram, read top to bottom through four bands: IN, PULL REQUEST, SERVER REMOTE, OUT.
Glyphs: 2 stores (slate), 1 gate, 1 ADR-only gate, 2 commits (locked palette); 1 flow edge, 3 ADR-only edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../clients-bridge-to-one-server.md).

## At a glance

A 1572 × 900 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands labelled IN, PULL REQUEST, SERVER REMOTE and OUT. It holds six glyphs, two stores, two gates (one of them ADR-only) and two
commits, joined by four edges, with six markers and a legend panel along the bottom. The eye lands first on the vertical column at the
right, which runs from the local clone down through both gates to HEAD.

## Reading path

1. Marker 1, IN band, right: the store local clone.
2. Down a dashed edge to marker 2, PULL REQUEST band: the ADR-only gate identity model, inside a dashed frame.
3. Down a dashed edge to marker 3: the gate branch policy.
4. Down a solid edge to marker 4, SERVER REMOTE band: the grey commit HEAD.
5. Left across the band to marker 5: the light blue commit verified point.
6. Down a dashed edge to marker 6, OUT band: the store consumer clones.

## Glyphs

| Glyph (legend phrase)   | Count | Where                                                                                      |
| ----------------------- | ----- | ------------------------------------------------------------------------------------------ |
| store                   | 2     | local clone (IN band, right), consumer clones (OUT band, left)                             |
| gate                    | 1     | branch policy (PULL REQUEST band, right, lower)                                            |
| ADR-only                | 1     | identity model: a white dashed rhombus in a dashed frame (PULL REQUEST band, right, upper) |
| commit (locked palette) | 2     | HEAD (SERVER REMOTE, right, grey), verified point (SERVER REMOTE, left, light blue)        |

Stores are slate with white names. Each commit carries its name in bold to its right. The left half of the IN and PULL REQUEST bands is
empty.

## Edges

| Edge kind | Count | From → to                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------- |
| flow      | 1     | branch policy → HEAD                                                                           |
| ADR-only  | 3     | local clone → identity model, identity model → branch policy, verified point → consumer clones |

Every edge is straight and vertical; none crosses another. HEAD and the verified point are not joined.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                      | Phrase                            |
| --------------------------- | --------------------------------- |
| slate cylinder              | store                             |
| rhombus with a thick rim    | gate                              |
| light blue and grey dots    | commit (locked palette)           |
| grey band                   | band: one side of the boundary    |
| solid arrow                 | flow: a commit moves to           |
| dashed box and dashed arrow | ADR-only (no code): glyph or edge |
| dark disc `1`               | marker: a Walkthrough step        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE and ADR-DSGN-REMOTE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions, [world map](grid.md), [tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE and ADR-DSGN-REMOTE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

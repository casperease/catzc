---
catzc:
  immutable:
    with_body_sha: "73166d39b128"
    repo_status: clean
    path: docs/explanation/design/one-door-in-one-stable-point-out.drawio.md
    folder: docs/explanation/design
    name: one-door-in-one-stable-point-out-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md
      - docs/explanation/design/one-door-in-one-stable-point-out.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One door in, one stable point out: the diagram described

```text
A 1572 x 650 diagram, read top to bottom through three bands: IN, SERVER REMOTE, OUT.
Glyphs: 2 stores (slate), 1 gate, 2 commits (locked palette); 1 flow edge, 2 ADR-only edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](one-door-in-one-stable-point-out.md).

## At a glance

A 1572 × 650 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands labelled IN, SERVER REMOTE and OUT. It holds five glyphs, two stores, one gate and two commits, joined by three edges, with
five markers and a legend panel along the bottom. The eye lands first on the gate at the right of the IN band, with the only solid edge
running down from it.

## Reading path

1. Marker 1, IN band, left of centre: the store local clone.
2. Right along a dashed edge to marker 2: the gate pull request.
3. Down a solid edge into the SERVER REMOTE band, to marker 3: the grey commit HEAD.
4. Left across the band to marker 4: the light blue commit verified point, under the local clone.
5. Down a dashed edge to marker 5, OUT band: the store consumer clones.

## Glyphs

| Glyph (legend phrase)   | Count | Where                                                                               |
| ----------------------- | ----- | ----------------------------------------------------------------------------------- |
| store                   | 2     | local clone (IN band, left), consumer clones (OUT band, left)                       |
| gate                    | 1     | pull request (IN band, right)                                                       |
| commit (locked palette) | 2     | verified point (SERVER REMOTE, left, light blue), HEAD (SERVER REMOTE, right, grey) |

Stores are slate with white names. Each commit carries its name in bold to its right.

## Edges

| Edge kind | Count | From → to                                                    |
| --------- | ----- | ------------------------------------------------------------ |
| flow      | 1     | pull request → HEAD                                          |
| ADR-only  | 2     | local clone → pull request, verified point → consumer clones |

Every edge is straight; none crosses another. The verified point and HEAD are not joined.

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
(ADR-DSGN-REMOTE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md),
[tree](../.assets/tree/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md), which hold the reason for every lit cell or group
as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-REMOTE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

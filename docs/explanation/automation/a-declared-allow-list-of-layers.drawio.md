---
catzc:
  immutable:
    with_body_sha: "7cd5c66ae2f9"
    repo_status: clean
    path: docs/explanation/automation/a-declared-allow-list-of-layers.drawio.md
    folder: docs/explanation/automation
    name: a-declared-allow-list-of-layers-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.png
      - docs/explanation/.assets/chain/adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md
      - docs/explanation/.assets/grid/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md
      - docs/explanation/.assets/tree/adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md
      - docs/explanation/automation/a-declared-allow-list-of-layers.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One declared allow-list, edges point down: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands, beside one tall band on the right.
Glyphs: 3 named sets (mauve), 1 code unit (slate), 1 failure; 5 downward edges, 1 failure path; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](a-declared-allow-list-of-layers.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
bands on the left, labelled `TOP LAYER`, `MIDDLE LAYER` and `FOUNDATION`, beside one tall band on the right labelled `INVARIANT`. It holds
five glyphs, three named sets, one code unit and one failure, joined by five downward edges and one horizontal failure path, with five
markers and a legend panel along the bottom. The eye lands first on the red failure at the bottom right.

## Reading path

1. Marker 1, top band: the named set contosoExt.
2. Down the three edges that leave it.
3. Markers 2 and 3, middle band, left to right: the code unit Catzc.contoso, the named set Tooling.
4. Marker 4, foundation band: the named set Base, which every downward edge reaches.
5. Right along the failure path to marker 5, INVARIANT band: the failure Undeclared edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------- |
| named set             | 3     | contosoExt (top band), Tooling (middle band, right), Base (foundation band, wide) |
| code unit             | 1     | Catzc.contoso (middle band, left)                                                 |
| failure               | 1     | Undeclared edge (INVARIANT band, bottom)                                          |

Named sets are mauve and the code unit is slate, both with white names; the failure is light red.

## Edges

| Edge kind              | Count | From → to                                                                     |
| ---------------------- | ----- | ----------------------------------------------------------------------------- |
| thick, to a named set  | 4     | contosoExt → Base, contosoExt → Tooling, Catzc.contoso → Base, Tooling → Base |
| flow, to one code unit | 1     | contosoExt → Catzc.contoso                                                    |
| failure path           | 1     | Base → Undeclared edge                                                        |

Every edge is straight, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                | Phrase                          |
| --------------------- | ------------------------------- |
| mauve rounded box     | named set                       |
| slate rounded box     | code unit                       |
| thick arrow           | may depend on, to a named set   |
| thin arrow            | may depend on, to one code unit |
| light red rounded box | failure                         |
| red arrow             | failure path                    |
| dark disc `1`         | marker: a Walkthrough step      |
| grey band             | band: one layer                 |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEPM): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md),
[tree](../.assets/tree/adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md) and
[value-chain map](../.assets/chain/adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md), which hold the reason for every lit cell or group as
of that build.

- **Lens badge:** META, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

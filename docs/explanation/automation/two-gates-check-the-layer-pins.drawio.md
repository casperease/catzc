---
catzc:
  immutable:
    with_body_sha: "98c58a149454"
    repo_status: clean
    path: docs/explanation/automation/two-gates-check-the-layer-pins.drawio.md
    folder: docs/explanation/automation
    name: two-gates-check-the-layer-pins-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.png
      - docs/explanation/.assets/chain/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
      - docs/explanation/.assets/grid/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
      - docs/explanation/.assets/tree/adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md
      - docs/explanation/automation/two-gates-check-the-layer-pins.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Two gates check the layer pins: the diagram described

```text
A 1572 x 700 diagram in two columns, each read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 2 gates, 1 ADR-only; 3 thick edges, 1 flow edge; 6 rule chips; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](two-gates-check-the-layer-pins.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two columns, each reading top to
bottom through three bands: on the left `TOP LAYER`, `MIDDLE LAYER` and `FOUNDATION`; on the right `AT LOAD`, `AGAINST THE REPOSITORY` and
`NO GATE`. It holds six glyphs, three named sets, two gates and one ADR-only, joined by three thick edges and one flow edge, with six rule
chips, six markers and a legend panel along the bottom. The eye lands first on the two grey rhombi in the right column.

## Reading path

1. Markers 1, 2 and 3, left column, top to bottom: the named sets AzureExt, Tooling and Base, each with a rule chip `D3 · D4` to its right.
2. Marker 4, AT LOAD band: the gate Load check, rule chip `D4`.
3. Down the flow edge to marker 5, AGAINST THE REPOSITORY band: the gate Quality gate, rule chip `D1 · D2 · D4 · T35`.
4. Marker 6, NO GATE band: the ADR-only glyph Same-change review, dashed rule chip `D5`, joined to nothing.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                       |
| --------------------- | ----- | --------------------------------------------------------------------------- |
| named set             | 3     | AzureExt (`TOP LAYER`), Tooling (`MIDDLE LAYER`, left), Base (`FOUNDATION`) |
| gate                  | 2     | Load check (`AT LOAD`), Quality gate (`AGAINST THE REPOSITORY`), 3 px rims  |
| ADR-only              | 1     | Same-change review (`NO GATE`), dashed outline                              |

Named sets are mauve with white names; the gates are grey rhombi and the ADR-only glyph is a white dashed box.

## Edges

| Edge kind             | Count | From → to                                           |
| --------------------- | ----- | --------------------------------------------------- |
| thick, to a named set | 3     | AzureExt → Tooling, AzureExt → Base, Tooling → Base |
| flow                  | 1     | Load check → Quality gate                           |

Every edge is straight and vertical, and none crosses another. No edge carries a chip. Six white rule chips sit beside the glyphs they
govern, one each; five are solid and the `D5` chip is dashed.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                               |
| ----------------------- | ------------------------------------ |
| mauve rounded box       | named set                            |
| grey rhombus, thick rim | gate                                 |
| dashed white box        | ADR-only                             |
| thick arrow             | may depend on, to a named set        |
| thin arrow              | flow: runs before                    |
| white chip `D4`         | rule chip: D = DEPM, T = TEST        |
| dark disc `1`           | marker: a Walkthrough step           |
| dashed white chip `D5`  | dashed rule chip: ADR-only (no gate) |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEPM and ADR-AUTO-TEST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md),
[tree](../.assets/tree/adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md) and
[value-chain map](../.assets/chain/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-DEPM and ADR-AUTO-TEST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

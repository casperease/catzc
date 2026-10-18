# Values and module edges have a gate; the no-direct-read rule is left to review: the diagram described

```text
A 1572 x 648 diagram, read top to bottom through three bands, each row left to right.
Glyphs: 1 file (olive), 2 code units (slate), 2 gates (neutral), 1 ADR-only (dashed); 2 flow edges, 1 ADR-only edge; 5 rule chips; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-repo-variant--values-and-edges-gated-reads-reviewed--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](values-and-edges-gated-reads-reviewed.md).

## At a glance

A 1572 × 648 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `FILE`, `READER` and `MODULE EDGES`, and each band is one row read left to right: a subject glyph on the left, an
edge, and on the right the thing that checks it. The rows hold a file and a gate, a code unit and an ADR-only glyph, and a code unit and a
gate. Five rule chips sit beside the glyphs, with six markers and a legend panel along the bottom. The eye lands first on the two neutral
rhombi on the right.

## Reading path

1. Marker 1, top band, left: the file `variants.yml`, with the rule chip `#1`; one edge runs right to marker 2, the gate `VariantsConfig`,
   with the rule chip `#1 · #4 · #5 · #6`.
2. Marker 3, middle band, left: the code unit `Get-Variant`, with the dashed rule chip `#2`; one dashed edge runs right to marker 4, the
   ADR-only glyph `Code review`.
3. Marker 5, bottom band, left: the code unit `Catzc.Base.Variants`, with the rule chip `#3`; one edge runs right to marker 6, the gate
   `Test-ModuleDependency`, with the rule chip `#3`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------- |
| file                  | 1     | `variants.yml` (top band, left)                                                  |
| code unit             | 2     | `Get-Variant` (middle band, left), `Catzc.Base.Variants` (bottom band, left)     |
| gate                  | 2     | `VariantsConfig` (top band, right), `Test-ModuleDependency` (bottom band, right) |
| ADR-only              | 1     | `Code review` (middle band, right), a dashed rounded box on the page colour      |

The file is olive, the code units slate, the gates neutral rhombi with a light 3 px rim, and the ADR-only glyph has a dashed light rim. Four
rule chips are solid pills (`#1`; `#1 · #4 · #5 · #6`; `#3`; `#3`) and one is dashed (`#2`).

## Edges

| Edge kind           | Count | From → to                                                                  |
| ------------------- | ----- | -------------------------------------------------------------------------- |
| flow: is checked by | 2     | variants.yml → VariantsConfig; Catzc.Base.Variants → Test-ModuleDependency |
| ADR-only (no code)  | 1     | Get-Variant → Code review, dashed                                          |

Every edge is straight and horizontal, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns over three rows, left to right:

| Swatch             | Phrase                               |
| ------------------ | ------------------------------------ |
| olive page         | file                                 |
| slate rounded box  | code unit                            |
| neutral rhombus    | gate                                 |
| dashed rounded box | ADR-only                             |
| thin arrow         | flow: is checked by                  |
| dashed arrow       | ADR-only (no code)                   |
| pill `#3`          | rule chip: ADR-REPO-VARIANT#n        |
| dashed pill `#2`   | dashed rule chip: ADR-only (no gate) |
| light disc `1`     | marker: a Walkthrough step           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-REPO-VARIANT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-repo-variant--values-and-edges-gated-reads-reviewed--governance.grid.md),
[tree](../.assets/tree/adr-repo-variant--values-and-edges-gated-reads-reviewed--governance.tree.md) and
[value-chain map](../.assets/chain/adr-repo-variant--values-and-edges-gated-reads-reviewed--governance.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-REPO-VARIANT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

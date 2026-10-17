---
catzc:
  immutable:
    with_body_sha: "2dcbafea0c0d"
    repo_status: clean
    path: docs/explanation/flow/two-declared-layers-one-derived.drawio.md
    folder: docs/explanation/flow
    name: two-declared-layers-one-derived-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
      - docs/explanation/flow/two-declared-layers-one-derived.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Two layers declared, the third derived: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands under two span bars.
Glyphs: 6 named sets (mauve); 1 thick edge with a 4/4 fraction chip; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](two-declared-layers-one-derived.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE, under two span bars labelled DECLARED (over the left half) and DERIVED
(over the right half). It holds six named sets, one thick edge with a fraction chip, six markers, and a legend panel along the bottom. The
eye lands first on the short thick edge between the two named sets in the top band.

## Reading path

1. The span bars above the top band: DECLARED on the left, DERIVED on the right.
2. Markers 1 and 2, top band, left half: the named sets Configured units and Base unit, joined by the thick edge.
3. Markers 3 and 4, middle band: Declared loose-filesets under DECLARED, Reserved umbrellas under DERIVED.
4. Markers 5 and 6, bottom band, right half: Module sets and module-leftovers. The left half of the bottom band is empty.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 6     | Configured units, Base unit (top band, left); Declared loose-filesets (middle, left); Reserved umbrellas (middle, right); Module sets, module-leftovers (bottom, right) |

Named sets are mauve with white names.

## Edges

| Edge kind              | Count | From → to                    |
| ---------------------- | ----- | ---------------------------- |
| thick (to a named set) | 1     | Configured units → Base unit |

The edge is short and horizontal, with a bold `4/4` fraction chip just above it.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                             |
| ----------------- | ---------------------------------- |
| mauve rounded box | named set                          |
| grey band         | band: one layer                    |
| thick arrow       | compose, to a named set            |
| bold `4/4`        | fraction chip: units with the edge |
| span bar          | span bar: declared or derived      |
| dark disc `1`     | marker: a Walkthrough step         |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

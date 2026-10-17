---
catzc:
  immutable:
    with_body_sha: "19ba9e6a7cb8"
    repo_status: clean
    path: docs/explanation/design/gate-checks-order-not-liveness.drawio.md
    folder: docs/explanation/design
    name: gate-checks-order-not-liveness-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.tree.md
      - docs/explanation/design/gate-checks-order-not-liveness.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The gate checks order, not liveness: the diagram described

```text
A 1572 x 640 diagram, read top to bottom inside two side-by-side column bands, each with its gate on the right.
Glyphs: 4 named sets (mauve), 2 gates, 1 ADR-only gate; 2 flow edges, 1 ADR-only edge; 6 rule chips; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](gate-checks-order-not-liveness.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two column bands sit side by side under the
title, labelled `AUTOMATION` on the left and `INFRASTRUCTURE` on the right. In each band two named sets are stacked on the left, and a gate
sits to the right of the lower one, pointing at it. The left band also holds a frame around its two named sets and, above its gate, an
ADR-only gate pointing at the frame. Three edges, six rule chips and six markers complete the drawing, with a legend panel along the bottom.
The eye lands first on the two thick-rimmed rhombi.

## Reading path

1. Marker 1, left band, top: the named set live, with a dashed rule chip `#2`; below it marker 2, the named set tests, with a dashed rule
   chip `#3`.
2. Marker 3, left band, right of tests: the gate VariantsConfig, with a rule chip `#3`, and the flow edge from it into tests.
3. Marker 4, left band, above the gate: the ADR-only gate AspectPartition.Validate inside its dashed frame, with a dashed rule chip `#5`,
   and the dashed edge from it to the frame around live and tests.
4. Marker 5, right band, top: the named set tests; below it marker 6, the named set live, with a dashed rule chip `#3`, and to its right the
   second gate VariantsConfig, with a rule chip `#3`, and the flow edge from it into live.

## Glyphs

| Glyph (legend phrase)                             | Count | Where                                                                                       |
| ------------------------------------------------- | ----- | ------------------------------------------------------------------------------------------- |
| named set                                         | 4     | live and tests (left band, top and bottom), tests and live (right band, top and bottom)     |
| gate                                              | 2     | VariantsConfig (left band, right of tests), VariantsConfig (right band, right of live)      |
| gate, ADR-only on the real tree (unit tests only) | 1     | AspectPartition.Validate (left band, right of live; a dashed rhombus inside a dashed frame) |

The named sets are mauve with white names; the gates are dark grey rhombi with a thick light rim, and the ADR-only gate a dashed thin rim on
the page colour. The frame around the left band's two named sets is a thin grey rounded rim with no fill.

## Edges

| Edge kind | Count | From → to                                                              |
| --------- | ----- | ---------------------------------------------------------------------- |
| flow      | 2     | VariantsConfig → tests (left band); VariantsConfig → live (right band) |
| ADR-only  | 1     | AspectPartition.Validate → the frame around live and tests (left band) |

Every edge is straight and horizontal, pointing left. None crosses another, and none carries a label.

**Rule chips.** Six small pills at the top-right corner of their glyphs: dashed `#2` on live and dashed `#3` on tests in the left band; `#3`
above each gate at VariantsConfig; dashed `#5` above AspectPartition.Validate; dashed `#3` on live in the right band.

## Legend

A full-width panel at the bottom of the drawing area, in two rows of four, left to right:

| Swatch                  | Phrase                                            |
| ----------------------- | ------------------------------------------------- |
| mauve rounded box       | named set                                         |
| grey rhombus, thick rim | gate                                              |
| dashed rhombus          | gate, ADR-only on the real tree (unit tests only) |
| thin arrow              | flow: checks                                      |
| dashed arrow            | ADR-only (no code runs it)                        |
| chip `#3`               | rule chip: ADR-DSGN-ASPECT#n                      |
| dashed chip `#3`        | dashed rule chip: ADR-only (no gate)              |
| light disc `1`          | marker: a Walkthrough step                        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-ASPECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.grid.md),
[tree](../.assets/tree/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-aspect--gate-checks-order-not-liveness--governance.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** GOV, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

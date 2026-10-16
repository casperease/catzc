---
catzc:
  immutable:
    with_body_sha: "04cfc9fa317b"
    path: docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-life-sync-point-rules-are-adr-only-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
      - docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
      - docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
      - docs/explanation/design/sync-point-rules-are-adr-only.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Only BVT has a gate; the sync point is ADR-only: the diagram described

```text
A 1572 x 690 diagram, read top to bottom through three bands, with one row of hexagons and a gate in the middle band.
Glyphs: 1 ADR-only box, 5 environments (ADR-only, framed), 1 gate, 5 commits; 6 ADR-only flow edges, 1 failure path.
Marks: 11 rule chips, 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/sync-point-rules-are-adr-only.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three full-width bands run top to bottom,
labelled EXTERNAL, PROMOTION LADDER and TIP OF MAIN. The drawing holds one ADR-only box, five environment hexagons (each white, dashed,
inside a dashed frame), one gate with a thick solid rim, and five commits, joined by six dashed flow edges and one dashed failure path.
Eleven rule chips sit beside the glyphs, eight markers number them, and a legend panel runs along the bottom. The eye lands first on the one
solid shape, the gate at the right end of the ladder.

## Reading path

1. Marker 1, EXTERNAL band: the ADR-only box upstream integrator, with chips `L6` and `L7` to its right.
2. Down its dashed edge into the light-blue commit `6` inside main-UAT.
3. Markers 2 to 6, PROMOTION LADDER band, left to right: production (green `4`, chip `L5`), pre-prod (green, no digit, chip `F11`),
   release-uat (light-green `5`, chip `F9`), main-UAT (light-blue `6`, chips `F9` and `L6`), on-demand (L3) (empty, chip `F5`), each joined
   to the next by a short dashed arrow pointing right.
4. Marker 7, on the gate ci-automation at the right end of the ladder, chip `L2` at its lower right.
5. Down the red dashed failure path from main-UAT to marker 8, TIP OF MAIN band: the blue commit `10`, named dirty HEAD, chips `L7` and
   `L8`.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                                                                  |
| ------------------------------ | ----- | ------------------------------------------------------------------------------------------------------ |
| ADR-only (box)                 | 1     | upstream integrator, EXTERNAL band, centred above main-UAT                                             |
| environment (ADR-only, framed) | 5     | production, pre-prod, release-uat, main-UAT, on-demand (L3), PROMOTION LADDER band                     |
| gate                           | 1     | ci-automation, PROMOTION LADDER band, right end; neutral grey, 3 px rim                                |
| commit (locked palette)        | 5     | green `4`, green (no digit), light-green `5`, light-blue `6` inside hexagons; blue `10` in TIP OF MAIN |

No glyph on this diagram is structural: the environments and the gate are neutral and every commit keeps its locked colour.

## Edges

| Edge kind                            | Count | From → to                                                                                                                                                   |
| ------------------------------------ | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: takes its commit from (dashed) | 6     | upstream integrator → `6`; production → pre-prod; pre-prod → release-uat; release-uat → main-UAT; main-UAT → on-demand (L3); on-demand (L3) → ci-automation |
| failure path (red, dashed)           | 1     | main-UAT → `10`                                                                                                                                             |

Every edge is straight; the five in the ladder are horizontal and the other two vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                        |
| ----------------------- | --------------------------------------------- |
| white hexagon           | environment: its occupant inside              |
| grey rhombus, thick rim | gate                                          |
| four commit dots        | commit (locked palette)                       |
| dashed white box        | ADR-only (no code): glyph or edge             |
| dashed grey arrow       | flow: takes its commit from                   |
| dashed red arrow        | failure path                                  |
| white chip `L6`         | rule chip: L = ADR-DSGN-LIFE, F = ADR-FLOW-CD |
| dark disc `1`           | marker: a Walkthrough step                    |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE and ADR-FLOW-CD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md),
[tree](adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md) and [value-chain map](adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-DSGN-LIFE and ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

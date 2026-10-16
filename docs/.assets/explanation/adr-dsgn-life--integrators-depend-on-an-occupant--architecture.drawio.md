---
catzc:
  immutable:
    with_body_sha: fc08fc2e906d
    repo_status: clean
    path: docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-life-integrators-depend-on-an-occupant-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.png
      - docs/.assets/explanation/chain/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
      - docs/.assets/explanation/grid/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
      - docs/.assets/explanation/tree/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
      - docs/explanation/design/integrators-depend-on-an-occupant.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Integrators depend on the main-UAT occupant: the diagram described

```text
A 1572 x 670 diagram, read top to bottom through three bands, with one row of hexagons in the middle band.
Glyphs: 1 ADR-only box, 4 environments (ADR-only, framed), 5 commits; 4 ADR-only flow edges, 1 failure path; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/integrators-depend-on-an-occupant.md).

## At a glance

A 1572 × 670 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three full-width bands run top to bottom,
labelled EXTERNAL, PROMOTION LADDER and TIP OF MAIN. The drawing holds one ADR-only box, four environment hexagons (each white, dashed,
inside a dashed frame) and five commits, joined by four dashed flow edges and one dashed failure path, with six markers and a legend panel
along the bottom. The eye lands first on the row of four hexagons in the middle band.

## Reading path

1. Marker 1, EXTERNAL band: the ADR-only box upstream integrator, above the right-hand hexagon.
2. Down its dashed edge into the light-blue commit `6` inside main-UAT.
3. Markers 2 to 5, PROMOTION LADDER band, left to right: production (green `4`), pre-prod (green, no digit), release-uat (light-green `5`),
   main-UAT (light-blue `6`), each joined to the next by a short dashed arrow pointing right.
4. Down the red dashed failure path from main-UAT to marker 6, TIP OF MAIN band: the blue commit `10`, named dirty HEAD.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                                                                      |
| ------------------------------ | ----- | ---------------------------------------------------------------------------------------------------------- |
| ADR-only (box)                 | 1     | upstream integrator, EXTERNAL band, centred above main-UAT                                                 |
| environment (ADR-only, framed) | 4     | production, pre-prod, release-uat, main-UAT, PROMOTION LADDER band, left to right                          |
| commit (locked palette)        | 5     | green `4`, green (no digit), light-green `5`, light-blue `6` inside the hexagons; blue `10` in TIP OF MAIN |

No glyph on this diagram is structural: the environments are neutral and every commit keeps its locked colour.

## Edges

| Edge kind                            | Count | From → to                                                                                        |
| ------------------------------------ | ----- | ------------------------------------------------------------------------------------------------ |
| flow: takes its commit from (dashed) | 4     | upstream integrator → `6`; production → pre-prod; pre-prod → release-uat; release-uat → main-UAT |
| failure path (red, dashed)           | 1     | main-UAT → `10`                                                                                  |

Every edge is straight; the three in the ladder are horizontal and the other two vertical. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| white hexagon     | environment: its occupant inside  |
| four commit dots  | commit (locked palette)           |
| dashed white box  | ADR-only (no code): glyph or edge |
| dashed grey arrow | flow: takes its commit from       |
| dashed red arrow  | failure path                      |
| dark disc `1`     | marker: a Walkthrough step        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE and ADR-FLOW-CD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md),
[tree](tree/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md) and
[value-chain map](chain/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE and ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

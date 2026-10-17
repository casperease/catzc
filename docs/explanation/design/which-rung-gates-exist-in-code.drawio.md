---
catzc:
  immutable:
    with_body_sha: ca650935236d
    repo_status: clean
    path: docs/explanation/design/which-rung-gates-exist-in-code.drawio.md
    folder: docs/explanation/design
    name: which-rung-gates-exist-in-code-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
      - docs/explanation/design/which-rung-gates-exist-in-code.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Only PR build validation, the BVT and the failure stop are checked in code: the diagram described

```text
A 1572 x 600 diagram, read left to right along one row of gates and commits, with a second band below.
Glyphs: 8 commits, 3 gates, 4 ADR-only (3 gates, 1 runner); 4 flow, 8 ADR-only, 2 failure-path edges; 12 rule chips; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](which-rung-gates-exist-in-code.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two full-width bands stack: `RUNG GATES` on top
and `ALL RUNGS` below. Three span bars run above them: CI, CD and DEPLOY. The top band holds one left-to-right row that alternates commits
and gates and ends with a runner; the lower band holds one wide rhombus, the gate, and one commit. The eye lands first on the two solid grey
rhombi at the left of the row, then on the three rhombi inside dashed frames.

## Reading path

1. Marker 1, top band: the gate `PR build validation`, after the brown commit `topic`.
2. Marker 2: the grey commit `landed`.
3. Marker 3: the gate `BVT`, then the yellow commit `BVT`.
4. Markers 4, 5 and 6: the ADR-only gates `L3-vertical-AT`, `RC on main-AT` and `RBC on release-AT`, each followed by its commit (blue,
   light-blue, light-green).
5. Marker 7: the ADR-only runner `two-slot activation`, then the green commit `production`.
6. Down the red line from the gate `BVT` to marker 8, lower band: the gate `failure stops downstream`, then right to the red commit
   `discarded`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                        |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------ |
| commit                | 8     | seven in the top row (brown, grey, yellow, blue, light-blue, light-green, green); one red in the lower band  |
| gate                  | 3     | `PR build validation` and `BVT` (top band), `failure stops downstream` (lower band); solid 3 px rims         |
| ADR-only              | 4     | gates `L3-vertical-AT`, `RC on main-AT`, `RBC on release-AT` (white, dashed, each in a dashed frame); runner |
|                       |       | `two-slot activation` (white dashed pill)                                                                    |

No glyph on this diagram is structural: the gates are neutral grey and every commit keeps its locked colour.

## Edges

| Edge kind    | Count | From → to                                                                                                                               |
| ------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | topic → PR build validation → landed → gate `BVT` → yellow commit                                                                       |
| ADR-only     | 8     | yellow commit → L3-vertical-AT → blue → RC on main-AT → light-blue → RBC on release-AT → light-green → two-slot activation → production |
| failure path | 2     | gate `BVT` → failure stops downstream; failure stops downstream → discarded                                                             |

The top row's twelve edges are straight and horizontal; the first failure path drops straight down. Twelve rule chips sit above the glyphs
they govern: `L1` (topic), `F8` (PR build validation), `L9` (landed), `T24` (BVT), `F5` (L3-vertical-AT), `F9` (RC on main-AT), `L6`
(main-UAT commit), `F9` and `L2` (RBC on release-AT), `F12` (two-slot activation), `L3` (production commit), and `L8` beside failure stops
downstream.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                                               | Phrase                                                     |
| ---------------------------------------------------- | ---------------------------------------------------------- |
| eight small commits, brown to green, then red        | commit (locked palette)                                    |
| grey rhombus, 3 px rim                               | gate: a check in code                                      |
| white dashed rhombus in a dashed frame, dashed arrow | ADR-only (no code)                                         |
| thin arrow                                           | flow: next rung                                            |
| red arrow                                            | failure path                                               |
| white chip `L1`                                      | rule chip: L ADR-DSGN-LIFE, F ADR-FLOW-CD, T ADR-AUTO-TEST |
| dark disc `1`                                        | marker: a Walkthrough step                                 |
| span bar                                             | span bar: stages                                           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md),
[tree](../.assets/tree/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

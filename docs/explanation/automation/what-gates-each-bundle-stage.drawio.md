---
catzc:
  immutable:
    with_body_sha: ce7bb18b4f72
    repo_status: clean
    path: docs/explanation/automation/what-gates-each-bundle-stage.drawio.md
    folder: docs/explanation/automation
    name: what-gates-each-bundle-stage-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png
      - docs/explanation/.assets/chain/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
      - docs/explanation/.assets/grid/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
      - docs/explanation/.assets/tree/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
      - docs/explanation/automation/what-gates-each-bundle-stage.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Every stage has a rule, two gates check it: the diagram described

```text
A 1572 x 620 diagram, read left to right through three bands.
Glyphs: 1 code unit (slate), 2 gates, 2 results, 1 ADR-only; 5 flow edges, 1 ADR-only edge; 6 rule chips; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](what-gates-each-bundle-stage.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
tall bands, a wide BUILD band, then BUNDLE and CODE ROOTS. It holds six glyphs (one code unit, two gates, two results and one ADR-only)
joined by five flow edges and one ADR-only edge, with six rule chips, seven markers, and a three-row legend panel along the bottom. Four
glyphs sit on one horizontal line through the middle of the bands; a second gate sits below the code unit and a dashed ADR-only glyph below
the last result. The eye lands first on the two grey rhombuses (the gates) in the BUILD band.

## Reading path

1. Marker 1, BUILD band: the code unit Build-Modules, with the rule chip `#1 #7 M5`.
2. Along the line to marker 2: the gate Assert-CatzcBundle, with the rule chip `#5` beside its upper-right side.
3. Marker 3, BUNDLE band: the result Temporary build, chip `#5`.
4. Marker 4, CODE ROOTS band: the result Installed · saved, chip `#6`.
5. Marker 5, just below the returning edge above the bands, which runs from Installed · saved back down into the top of the first gate.
6. Marker 6, CODE ROOTS band, lower: the ADR-only Cached, chip `R7`, reached by a dashed edge from Temporary build.
7. Marker 7, BUILD band, lower left: the gate Test-CatzcBuild, chip `T30`, with an edge up into Build-Modules.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 1     | Build-Modules (BUILD band, left, on the line)                                                                                     |
| gate                  | 2     | Assert-CatzcBundle (BUILD band, right, on the line), Test-CatzcBuild (BUILD band, below Build-Modules); rhombuses with a 3 px rim |
| result                | 2     | Temporary build (BUNDLE band), Installed · saved (CODE ROOTS band, upper)                                                         |
| ADR-only              | 1     | Cached (CODE ROOTS band, lower), a white box with a dashed outline                                                                |

The code unit is slate with a white name; the gates are grey and the results green.

## Edges

| Edge kind | Count | From → to                                                                                                                                         |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Build-Modules → Assert-CatzcBundle → Temporary build → Installed · saved; Test-CatzcBuild → Build-Modules; Installed · saved → Assert-CatzcBundle |
| ADR-only  | 1     | Temporary build → Cached                                                                                                                          |

The three edges on the line are straight and horizontal, and the edge from Test-CatzcBuild is short and vertical. The returning flow edge
runs above the bands in three straight segments with one arrowhead. The dashed ADR-only edge drops from the bottom of Temporary build and
turns right into Cached, in two segments. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns of up to three rows, left to right:

| Swatch                  | Phrase                                                               |
| ----------------------- | -------------------------------------------------------------------- |
| slate rounded box       | code unit                                                            |
| grey rhombus, thick rim | gate                                                                 |
| green rounded box       | result                                                               |
| white dashed box        | ADR-only                                                             |
| grey arrow              | flow: feeds or runs the next step                                    |
| dashed grey arrow       | ADR-only (no code)                                                   |
| dark disc `1`           | marker: a Walkthrough step                                           |
| white pill `#5`         | rule chip: #n ADR-AUTO-BUNDLE#n, T ADR-AUTO-TEST, R ADR-DSGN-RUNMODE |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md),
[tree](../.assets/tree/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md) and
[value-chain map](../.assets/chain/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

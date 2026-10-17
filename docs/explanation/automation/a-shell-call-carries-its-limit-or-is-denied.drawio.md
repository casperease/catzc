---
catzc:
  immutable:
    with_body_sha: e5638575f5f6
    repo_status: clean
    path: docs/.assets/explanation/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-failfast-a-shell-call-carries-its-limit-or-is-denied-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.drawio.png
      - docs/.assets/explanation/chain/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.chain.md
      - docs/.assets/explanation/grid/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.grid.md
      - docs/.assets/explanation/tree/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.tree.md
      - docs/explanation/automation/a-shell-call-carries-its-limit-or-is-denied.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# A shell call carries its limit or is denied: the diagram described

```text
A 1572 x 650 diagram, read top to bottom through two bands, then left and right from the gate.
Glyphs: 1 actor, 1 gate (neutral), 1 result, 1 failure; 2 flow edges, 1 failure path; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](a-shell-call-carries-its-limit-or-is-denied.md).

## At a glance

A 1572 × 650 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through two
full-width bands, labelled `CALL` and `VERDICT`. It holds four glyphs, an actor, a gate, a result and a failure, joined by two flow edges
and one failure path, with four markers and a legend panel along the bottom. The eye lands first on the gate in the middle of the `VERDICT`
band, with the green result to its left and the red failure to its right.

## Reading path

1. Marker 1, `CALL` band: the actor coding agent, centred.
2. Down the flow edge to marker 2, `VERDICT` band: the gate time safeguard, centred.
3. Left along the flow edge to marker 3: the result call goes ahead.
4. Right along the failure path to marker 4: the failure call denied.

## Glyphs

| Glyph (legend phrase) | Count | Where                                   |
| --------------------- | ----- | --------------------------------------- |
| actor                 | 1     | coding agent (`CALL` band, centre)      |
| gate                  | 1     | time safeguard (`VERDICT` band, centre) |
| result                | 1     | call goes ahead (`VERDICT` band, left)  |
| failure               | 1     | call denied (`VERDICT` band, right)     |

The actor is a neutral circle and the gate a neutral rhombus with a thick rim, both dark with a light rim; the result is green and the
failure red, the only red on the page.

## Edges

| Edge kind    | Count | From → to                                                       |
| ------------ | ----- | --------------------------------------------------------------- |
| flow         | 2     | coding agent → time safeguard, time safeguard → call goes ahead |
| failure path | 1     | time safeguard → call denied                                    |

Every edge is straight, one vertical and two horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral circle    | actor                      |
| neutral rhombus   | gate                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| light arrow       | flow: hands the call on    |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.grid.md),
[tree](../.assets/tree/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.tree.md) and
[value-chain map](../.assets/chain/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

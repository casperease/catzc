---
catzc:
  immutable:
    with_body_sha: "67fd94169912"
    repo_status: clean
    path: docs/explanation/automation/a-stopped-run-names-its-limit.drawio.md
    folder: docs/explanation/automation
    name: a-stopped-run-names-its-limit-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-failfast--a-stopped-run-names-its-limit--operations.drawio.png
      - docs/explanation/.assets/chain/adr-auto-failfast--a-stopped-run-names-its-limit--operations.chain.md
      - docs/explanation/.assets/grid/adr-auto-failfast--a-stopped-run-names-its-limit--operations.grid.md
      - docs/explanation/.assets/tree/adr-auto-failfast--a-stopped-run-names-its-limit--operations.tree.md
      - docs/explanation/automation/a-stopped-run-names-its-limit.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# A run past its limit stops with a message that names the limit: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 actors (neutral), 2 code units (slate), 1 gate (neutral), 2 failures (red); 1 frame; 2 flow edges, 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-failfast--a-stopped-run-names-its-limit--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](a-stopped-run-names-its-limit.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `CALLER`, `CALL` and `STOP`. It holds seven glyphs on two rows: two actors, a gate and two code units in a frame, and two
failures. Two flow edges lead from the actors into the `CALL` band and two failure paths lead out of it into the `STOP` band, with seven
markers and a legend panel below the bands. The eye lands first on the two red failures at the right.

## Reading path

1. Marker 1, top of the `CALLER` band: the actor agent; right along the top row to marker 3, the gate Assert-BashTimeout, and on along the
   red edge to marker 6, the failure Bash call denied in the `STOP` band.
2. Marker 2, lower in the `CALLER` band: the actor developer; right into the frame of the `CALL` band, holding marker 4, the code unit
   Invoke-Executable, above marker 5, the code unit Invoke-WithTimeout.
3. From the frame's right side along the red edge to marker 7, the failure TimeoutException in the `STOP` band.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                            |
| --------------------- | ----- | ---------------------------------------------------------------- |
| actor                 | 2     | agent (`CALLER`, top), developer (`CALLER`, lower)               |
| code unit             | 2     | Invoke-Executable and Invoke-WithTimeout (`CALL`, in the frame)  |
| gate                  | 1     | Assert-BashTimeout (`CALL`, top)                                 |
| failure               | 2     | Bash call denied (`STOP`, top), TimeoutException (`STOP`, lower) |

Actors are neutral dark circles with a light rim, code units slate with white names, the gate a neutral dark rhombus, and the failures red
with a bright rim.

## Edges

| Edge kind    | Count | From → to                                                           |
| ------------ | ----- | ------------------------------------------------------------------- |
| flow         | 2     | agent → Assert-BashTimeout, developer → the frame                   |
| failure path | 2     | Assert-BashTimeout → Bash call denied, the frame → TimeoutException |

Every edge is straight and horizontal, and none crosses another. The flow edge from the developer ends on the frame's left side and the
failure path leaves its right side; neither touches the code units inside. No edge carries a label or a chip.

## Legend

A full-width panel below the bands, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral circle    | actor                      |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: runs                 |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-failfast--a-stopped-run-names-its-limit--operations.grid.md),
[tree](../.assets/tree/adr-auto-failfast--a-stopped-run-names-its-limit--operations.tree.md) and
[value-chain map](../.assets/chain/adr-auto-failfast--a-stopped-run-names-its-limit--operations.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

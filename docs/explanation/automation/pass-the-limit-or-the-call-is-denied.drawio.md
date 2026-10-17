---
catzc:
  immutable:
    with_body_sha: "97faf03409f9"
    repo_status: clean
    path: docs/explanation/automation/pass-the-limit-or-the-call-is-denied.drawio.md
    folder: docs/explanation/automation
    name: pass-the-limit-or-the-call-is-denied-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.drawio.png
      - docs/explanation/.assets/chain/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.chain.md
      - docs/explanation/.assets/grid/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.grid.md
      - docs/explanation/.assets/tree/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.tree.md
      - docs/explanation/automation/pass-the-limit-or-the-call-is-denied.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Pass the limit or the call is denied: the diagram described

```text
A 1572 x 650 diagram, read top to bottom through three bands in two columns.
Glyphs: 1 gate (neutral), 1 result, 2 failures, 1 file (olive); 2 flow edges, 2 failure paths; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](pass-the-limit-or-the-call-is-denied.md).

## At a glance

A 1572 × 650 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `HOOK`, `OUTCOME` and `AFTER`, in two columns: the left column runs the gate, the result and the failure; the
right column runs failure, file. It holds five glyphs, one gate, one result, two failures and one file, joined by two flow edges and two
failure paths, with five markers and a legend panel along the bottom. The eye lands first on the gate at the top left, with a red edge
running right from it.

## Reading path

1. Marker 1, `HOOK` band, left: the gate Assert-BashTimeout.
2. Down the flow edge to marker 2, `OUTCOME` band, left: the result the call runs.
3. Back to the gate and right along the failure path to marker 3, `HOOK` band, right: the failure denied, with the fix.
4. Down the flow edge to marker 4, `OUTCOME` band, right: the file out/time-safeguard.log.
5. Down the failure path from the result to marker 5, `AFTER` band, left: the failure exit 124: stopped.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                       |
| --------------------- | ----- | --------------------------------------------------------------------------- |
| gate                  | 1     | Assert-BashTimeout (`HOOK` band, left)                                      |
| result                | 1     | the call runs (`OUTCOME` band, left)                                        |
| failure               | 2     | denied, with the fix (`HOOK` band, right); exit 124: stopped (`AFTER` band) |
| file                  | 1     | out/time-safeguard.log (`OUTCOME` band, right)                              |

The gate is a neutral rhombus with a thick rim, dark with a light rim; the result is green, the two failures red, the only red on the page,
and the file olive.

## Edges

| Edge kind    | Count | From → to                                                                         |
| ------------ | ----- | --------------------------------------------------------------------------------- |
| flow         | 2     | Assert-BashTimeout → the call runs, denied, with the fix → out/time-safeguard.log |
| failure path | 2     | Assert-BashTimeout → denied, with the fix, the call runs → exit 124: stopped      |

Every edge is straight, three vertical and one horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral rhombus   | gate                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| olive page        | file                       |
| light arrow       | flow: the call goes on     |
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
[world map](../.assets/grid/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.grid.md),
[tree](../.assets/tree/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.tree.md) and
[value-chain map](../.assets/chain/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

---
catzc:
  immutable:
    with_body_sha: fc97167302f1
    repo_status: clean
    path: docs/explanation/pipelines/what-you-set-decides-the-credential.drawio.md
    folder: docs/explanation/pipelines
    name: what-you-set-decides-the-credential-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.png
      - docs/explanation/.assets/chain/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
      - docs/explanation/.assets/grid/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
      - docs/explanation/.assets/tree/adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md
      - docs/explanation/pipelines/what-you-set-decides-the-credential.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# What you set decides the credential: the diagram described

```text
A 1572 x 620 diagram, read top to bottom inside one band, WHAT YOU SET.
Glyphs: 3 gates, 1 result, 4 failures; 5 flow edges, 4 failure paths; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](what-you-set-decides-the-credential.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom inside one
full-width band, WHAT YOU SET, with three column headings: RETURNS, YOU SET and YOU SEE. It holds eight glyphs (three gates, one result,
four failures) joined by nine edges, with eight markers and a legend panel along the bottom. The eye lands first on the column of three
gates in the middle; the gate at the bottom is taller than the other two.

## Reading path

1. Marker 1, centre column, top: the gate ExposeAccessToken: true, with a failure path right to marker 2, the failure does not match
   ado.yml.
2. Down to marker 3, the gate $env:AZURE_DEVOPS_PAT, with nothing on its right.
3. Down to marker 4, the gate az login · Connect-AzCli, with three failure paths right to three stacked failures, markers 5, 6 and 7 on
   their right ends: Not logged in to az CLI, set to the wrong context, No ADO token available.
4. Left along the three flow edges to marker 8, the result Authorization header.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                    |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| gate                  | 3     | ExposeAccessToken: true, $env:AZURE_DEVOPS_PAT, az login · Connect-AzCli (centre column)                                                 |
| result                | 1     | Authorization header (left column, spanning all three rows)                                                                              |
| failure               | 4     | does not match ado.yml (row 1); Not logged in to az CLI, set to the wrong context, No ADO token available (stacked, row 3), right column |

Gates are grey with a thick rim, the result is green and the failures are red.

## Edges

| Edge kind    | Count | From → to                                                                                                    |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------ |
| flow         | 5     | ExposeAccessToken: true → $env:AZURE_DEVOPS_PAT → az login · Connect-AzCli; each gate → Authorization header |
| failure path | 4     | ExposeAccessToken: true → does not match ado.yml; az login · Connect-AzCli → each of its three failures      |

Every edge is straight, horizontal or vertical, and none crosses another. Two of the failure paths from the gate at the bottom leave from
points on its upper-right and lower-right sides.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| grey rhombus, thick rim | gate                       |
| green rounded box       | result                     |
| red rounded box         | failure                    |
| grey arrow              | flow: what comes next      |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-PIPE-AUTH): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md),
[tree](../.assets/tree/adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md) and
[value-chain map](../.assets/chain/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

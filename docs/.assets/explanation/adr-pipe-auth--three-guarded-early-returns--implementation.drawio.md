---
catzc:
  immutable:
    with_body_sha: "98697d129918"
    path: docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-pipe-auth-three-guarded-early-returns-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.drawio.png
      - docs/.assets/explanation/chain/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md
      - docs/.assets/explanation/grid/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md
      - docs/.assets/explanation/tree/adr-pipe-auth--three-guarded-early-returns--implementation.tree.md
      - docs/explanation/pipelines/three-guarded-early-returns.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Four checks, three returns, no fall-through: the diagram described

```text
A 1572 x 690 diagram, read top to bottom inside one band, CODE ORDER.
Glyphs: 4 gates, 3 results, 3 failures; 6 flow edges, 3 failure paths; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-pipe-auth--three-guarded-early-returns--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/pipelines/three-guarded-early-returns.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The title reads "four checks, three returns, no
fall-through". The drawing reads top to bottom inside one full-width band, CODE ORDER, with three column headings: RETURNS, CHECK and
THROWS. It holds ten glyphs (four gates, three results, three failures) joined by nine edges, with seven markers and a legend panel along
the bottom. The eye lands first on the column of four gates in the middle.

## Reading path

1. Marker 1, centre column, first row: the gate Test-IsRunningInPipeline, with a flow edge left to its result and a failure path right to
   marker 2, the failure does not match ado.yml.
2. Down to marker 3, the gate $env:AZURE_DEVOPS_PAT, with a flow edge left to its result and nothing on its right.
3. Down to marker 4, the gate Assert-AzCliConnected, with a failure path right to marker 5, the failure Not logged in, wrong context, and
   nothing on its left.
4. Down to marker 6, the gate Assert-NotNullOrWhitespace, with a flow edge left to its result and a failure path right to marker 7, the
   failure No ADO token available.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                              |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------ |
| gate                  | 4     | Test-IsRunningInPipeline, $env:AZURE_DEVOPS_PAT, Assert-AzCliConnected, Assert-NotNullOrWhitespace (centre column) |
| result                | 3     | Bearer SYSTEM_ACCESSTOKEN (row 1), Basic $base64 (row 2), Bearer $result.Output (row 4), left column               |
| failure               | 3     | does not match ado.yml (row 1), Not logged in, wrong context (row 3), No ADO token available (row 4), right column |

Gates are grey with a thick rim, results are green and failures are red.

## Edges

| Edge kind    | Count | From → to                                                                                           |
| ------------ | ----- | --------------------------------------------------------------------------------------------------- |
| flow         | 6     | gate → gate three times, down the centre column; gates in rows 1, 2 and 4 → the result on their row |
| failure path | 3     | gates in rows 1, 3 and 4 → the failure on their row                                                 |

Every edge is straight, horizontal or vertical, and none crosses another. Every failure has a failure path into it.

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
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](grid/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md),
[tree](tree/adr-pipe-auth--three-guarded-early-returns--implementation.tree.md) and [value-chain map](chain/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

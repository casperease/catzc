# One function owns the credential precedence, and ado.yml anchors every proof: the diagram described

```text
A 1572 x 690 diagram, read top to bottom into one band, HEADER FUNCTION.
Glyphs: 2 code units (slate), 3 gates, 1 runner (slate), 1 file (olive); 5 flow edges, 1 ADR-only edge; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](one-header-function-owns-precedence.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom: a code unit
above a central band, HEADER FUNCTION, which holds three gates stacked in a column. A tall file stands to the left of the band, and a runner
and a code unit stand to its right. It holds seven glyphs (two code units, three gates, one runner, one file) joined by six edges, with
seven markers and a legend panel along the bottom. The eye lands first on the three gates in the band.

## Reading path

1. Marker 1, top centre: the code unit Invoke-AdoRestMethod, with a flow edge down into the band.
2. Marker 2, in the band, top: the gate Pipeline token, with a flow edge right to marker 3, the runner invoke-automation.yaml.
3. Marker 4, in the band, middle: the gate PAT, with an ADR-only edge left to the file.
4. Marker 5, in the band, bottom: the gate az CLI, with a flow edge right to marker 6, the code unit Catzc.Azure.Cli.
5. Marker 7, left: the file ado.yml, which receives one edge from each gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------- |
| code unit             | 2     | Invoke-AdoRestMethod (top centre), Catzc.Azure.Cli (right, bottom row) |
| gate                  | 3     | Pipeline token, PAT, az CLI (inside the band, top to bottom)           |
| runner                | 1     | invoke-automation.yaml (right, top row)                                |
| file                  | 1     | ado.yml (left, spanning the three gate rows)                           |

Code units and the runner are slate, the file is olive, all with white names; the gates are grey with a thick rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Invoke-AdoRestMethod → band top; Pipeline token → invoke-automation.yaml; az CLI → Catzc.Azure.Cli; Pipeline token → ado.yml; az CLI → ado.yml |
| ADR-only  | 1     | PAT → ado.yml (dashed)                                                                                                                         |

Every edge is straight, horizontal or vertical, and none crosses another. The gates have no edges between them.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| slate pill              | runner                     |
| olive page              | file                       |
| grey arrow              | flow: depends on           |
| dashed grey arrow       | ADR-only (no code)         |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-PIPE-AUTH): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md),
[tree](../.assets/tree/adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

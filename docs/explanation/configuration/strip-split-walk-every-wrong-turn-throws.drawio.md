# Strip, split, read once, walk one segment at a time; every wrong turn throws: the diagram described

```text
A 1572 x 640 diagram, read left to right along one band, with a second band below for the failures.
Glyphs: 4 code units (slate), 1 gate, 1 result, 3 failures; 5 flow edges, 3 failure paths; 9 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-conf-addressing--strip-split-walk-every-wrong-turn-throws--implementation.drawio.png)
draws, in the vocabulary of the diagram glyphs; what it means is in [the article](strip-split-walk-every-wrong-turn-throws.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled `RESOLVE`, then down into a full-width band labelled `FAIL FAST`. It holds nine glyphs, four code units, one gate,
one result and three failures, joined by five flow edges and three failure paths, with nine markers and a legend panel along the bottom. The
eye lands first on the gate rhombus second from the left in the top band.

## Reading path

1. Marker 1, `RESOLVE` band: the code unit Write-EnvironmentSet, at the left.
2. Right, under the note `'global.azure.…'`, to marker 2: the gate ValidatePattern.
3. Markers 3, 4 and 5, left to right: the code units Get-ConfigValue, Get-Config and Resolve-ConfigKeyPath, with the notes `-Config azure`
   and `-Node, -Segment` above the edges between them.
4. Marker 6: the result '0.43.8', at the right end of the band.
5. Down the three failure paths to markers 7, 8 and 9, `FAIL FAST` band: the failures rejected at binding (below the gate), unknown or
   ambiguous name (below Get-Config) and key or property not found (below Resolve-ConfigKeyPath).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------- |
| code unit             | 4     | Write-EnvironmentSet, Get-ConfigValue, Get-Config, Resolve-ConfigKeyPath (`RESOLVE`)    |
| gate                  | 1     | ValidatePattern (`RESOLVE`, second from the left), a neutral rhombus with a 3 px rim    |
| result                | 1     | '0.43.8' (`RESOLVE`, right)                                                             |
| failure               | 3     | rejected at binding, unknown or ambiguous name, key or property not found (`FAIL FAST`) |

Code units are slate with white names; the gate is neutral; the result is green and the failures are the only red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                     |
| ------------ | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 5     | Write-EnvironmentSet → ValidatePattern, ValidatePattern → Get-ConfigValue, Get-ConfigValue → Get-Config, Get-Config → Resolve-ConfigKeyPath, Resolve-ConfigKeyPath → '0.43.8' |
| failure path | 3     | ValidatePattern → rejected at binding, Get-Config → unknown or ambiguous name, Resolve-ConfigKeyPath → key or property not found                                              |

Every flow edge is horizontal and every failure path runs straight down; none crosses another. Three notes sit above the flow edges:
`'global.azure.…'`, `-Config azure` and `-Node, -Segment`.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: calls, in code order |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-CONF-ADDRESSING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-conf-addressing--strip-split-walk-every-wrong-turn-throws--implementation.grid.md),
[tree](../.assets/tree/adr-conf-addressing--strip-split-walk-every-wrong-turn-throws--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-conf-addressing--strip-split-walk-every-wrong-turn-throws--implementation.chain.md), which hold the
reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-CONF-ADDRESSING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

# Two sections of dependencies.yml are unioned into one allow-set per source module: the diagram described

```text
A 1572 x 760 diagram, read top to bottom through four bands.
Glyphs: 2 files (olive), 4 code units (slate), 1 gate, 2 failures; 6 flow edges, 2 failure paths; 9 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.drawio.png) draws, in
the vocabulary of the diagram glyphs; what it means is in [the article](two-sections-unioned-into-one-allow-set.md).

## At a glance

A 1572 × 760 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled DEPENDENCIES.YML, AT LOAD, ALLOW-SET and GATE. It holds nine glyphs, two files, four code units, one gate and two
failures, joined by six flow edges and two failure paths, with nine markers and a legend panel along the bottom. The eye lands first on the
wide code units in the middle column, which every flow edge enters or leaves.

## Reading path

1. Markers 1 and 2, DEPENDENCIES.YML band, left to right: the files `groups:` and `modules:`.
2. Down both edges to marker 3, AT LOAD band: the code unit DependenciesConfig.
3. Right along the failure path to marker 4: the failure validation failed.
4. Markers 5, 6 and 7, ALLOW-SET band, left to right: the code units Get-ModuleDependency, $resolveAllowed and Get-CSharpTypeDependency, the
   outer two pointing in to the middle one.
5. Down to marker 8, GATE band: the gate Test-ModuleDependency.
6. Right along the failure path to marker 9: the failure failed: N issue(s).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                      |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| file                  | 2     | `groups:` and `modules:` (DEPENDENCIES.YML band, centre)                                                                                   |
| code unit             | 4     | DependenciesConfig (AT LOAD band, centre); Get-ModuleDependency, $resolveAllowed, Get-CSharpTypeDependency (ALLOW-SET band, left to right) |
| gate                  | 1     | Test-ModuleDependency (GATE band, centre), 3 px rim                                                                                        |
| failure               | 2     | validation failed (AT LOAD band, right); failed: N issue(s) (GATE band, right)                                                             |

Files are olive and code units are slate, both with white names; the gate is a grey rhombus and the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                                                                          |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 6     | `groups:` → DependenciesConfig, `modules:` → DependenciesConfig, DependenciesConfig → $resolveAllowed, Get-ModuleDependency → $resolveAllowed, Get-CSharpTypeDependency → $resolveAllowed, $resolveAllowed → Test-ModuleDependency |
| failure path | 2     | DependenciesConfig → validation failed, Test-ModuleDependency → failed: N issue(s)                                                                                                                                                 |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| olive folded page       | file                       |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| light red rounded box   | failure                    |
| thin arrow              | flow: feeds                |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one stage            |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEPM): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md),
[tree](../.assets/tree/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md), which hold the reason
for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

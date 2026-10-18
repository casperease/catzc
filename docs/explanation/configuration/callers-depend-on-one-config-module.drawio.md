# Callers in any module read config through one module: the diagram described

```text
A 1572 x 700 diagram, read left to right along one band, down into a second band and back up, with a third band below.
Glyphs: 4 code units (slate), 1 store (slate), 1 file (olive), 1 result; 7 flow edges; 7 markers; 1 fraction chip.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](callers-depend-on-one-config-module.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled READ PATH, down into a band labelled MISS on the right, and back up; a band labelled QUALITY GATES sits bottom
left. It holds seven glyphs (four code units, one store, one file and one result) joined by seven edges, with seven markers, one fraction
chip and a legend panel along the bottom. The eye lands first on the READ PATH band and its slate cylinder.

## Reading path

1. Marker 1, READ PATH band: the code unit caller, at the left, with the fraction chip 26/39 above its outgoing edge.
2. Marker 2: the code unit Catzc.Base.Config.
3. Marker 3: the store session cache.
4. Marker 4: the result typed or raw, at the right end of the band.
5. Down from the store to marker 5, MISS band: the file configs/&lt;name&gt;.yml.
6. Right to marker 6: the code unit owner's C# type, and up from its right part into the result.
7. Marker 7, QUALITY GATES band: the code unit Catzc.Base.QualityGates, with a long edge up into Catzc.Base.Config.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------- |
| code unit             | 4     | caller and Catzc.Base.Config (READ PATH, left), owner's C# type (MISS, right), Catzc.Base.QualityGates (QUALITY GATES) |
| store                 | 1     | session cache (READ PATH, middle)                                                                                      |
| file                  | 1     | configs/&lt;name&gt;.yml (MISS, left, below the store)                                                                 |
| result                | 1     | typed or raw (READ PATH, right)                                                                                        |

Code units and the store are slate and the file is olive, all with white names; the result is light green.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 7     | caller → Catzc.Base.Config (fraction chip 26/39), Catzc.Base.Config → session cache, session cache → typed or raw, session cache → configs/&lt;name&gt;.yml, configs/&lt;name&gt;.yml → owner's C# type, owner's C# type → typed or raw, Catzc.Base.QualityGates → Catzc.Base.Config |

Every edge is straight and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                                            |
| ------------------------- | ------------------------------------------------- |
| slate rounded box         | code unit                                         |
| slate cylinder            | store                                             |
| olive page, folded corner | file                                              |
| light green rounded box   | result                                            |
| thin arrow                | flow: calls, or the read (hit right, miss down)   |
| bold `26/39`              | fraction chip: other modules that call the reader |
| dark disc `1`             | marker: a Walkthrough step                        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-CONF-LOADING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md),
[tree](../.assets/tree/adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-CONF-LOADING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

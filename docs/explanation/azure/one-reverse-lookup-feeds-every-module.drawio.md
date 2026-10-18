# One reverse lookup in Catzc.Azure.Cli hands the session to every module: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 external tools (neutral), 3 code units (slate), 2 files (olive), 1 result; 8 flow edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](one-reverse-lookup-feeds-every-module.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, `SESSION`, `IDENTITY` and `TEMPLATES`. It holds eight glyphs, two external tools, three code units, two files and one result, joined
by eight flow edges, with eight markers and a legend panel along the bottom. The eye lands first on the tall code unit in the templates
band, which three edges enter and one leaves.

## Reading path

1. Marker 1, session band: the external tool service connection, then right to marker 2, the external tool az session.
2. Right across the band gap to marker 3, identity band, upper row: the code unit Catzc.Azure.Cli.
3. Down to the lower row: marker 4, the file azure.yml, then right to marker 5, the code unit Catzc.Azure, whose edge goes up into
   Catzc.Azure.Cli.
4. Right into the templates band, to marker 6: the tall code unit Catzc.Azure.Templates, entered from Catzc.Azure.Cli at the top, from
   Catzc.Azure in the middle, and from marker 7 below, the file configuration tree.
5. Right to marker 8: the result resource-group name.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------- |
| external tool         | 2     | service connection, az session (session band, upper row)                                                  |
| code unit             | 3     | Catzc.Azure.Cli (identity, upper), Catzc.Azure (identity, lower), Catzc.Azure.Templates (templates, tall) |
| file                  | 2     | azure.yml (identity band, lower left), configuration tree (templates band, bottom)                        |
| result                | 1     | resource-group name (templates band, upper right)                                                         |

External tools are neutral, code units slate, files olive and the result green, all with light names.

## Edges

| Edge kind   | Count | From → to                                                                                                                                                                                                                   |
| ----------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds | 8     | service connection → az session → Catzc.Azure.Cli → Catzc.Azure.Templates → resource-group name; azure.yml → Catzc.Azure → Catzc.Azure.Cli; Catzc.Azure → Catzc.Azure.Templates; configuration tree → Catzc.Azure.Templates |

Six edges are horizontal and two vertical (Catzc.Azure up into Catzc.Azure.Cli, configuration tree up into Catzc.Azure.Templates). None
crosses another; the three edges into the tall code unit enter it at three different heights.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                        | Phrase                     |
| ----------------------------- | -------------------------- |
| slate rounded box             | code unit                  |
| olive page with folded corner | file                       |
| neutral square box            | external tool              |
| green rounded box             | result                     |
| thin arrow                    | flow: feeds                |
| light disc `1`                | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-DATAMOD and ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.grid.md),
[tree](../.assets/tree/adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AZ-DATAMOD and ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

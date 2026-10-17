---
catzc:
  immutable:
    with_body_sha: "07f2ae6eeacf"
    repo_status: clean
    path: docs/explanation/configuration/callers-in-four-modules-share-one-resolver.drawio.md
    folder: docs/explanation/configuration
    name: callers-in-four-modules-share-one-resolver-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.chain.md
      - docs/explanation/.assets/grid/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.grid.md
      - docs/explanation/.assets/tree/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.tree.md
      - docs/explanation/configuration/callers-in-four-modules-share-one-resolver.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Callers in four modules share one resolver: the diagram described

```text
A 1576 x 654 diagram, read left to right through three bands side by side.
Glyphs: 7 code units (slate), 1 file (olive); 4 flow edges; 5 markers; 1 fraction chip; 1 band group.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.drawio.png)
draws, in the vocabulary of the diagram glyphs; what it means is in [the article](callers-in-four-modules-share-one-resolver.md).

## At a glance

A 1576 × 654 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled `CALLERS`, `CATZC.BASE.CONFIG` and `COMMITTED CONFIG`. It holds eight glyphs, seven code units and one file,
joined by four flow edges, with five markers, one fraction chip and a legend panel along the bottom. The eye lands first on the nested band
`FOUR CONSUMERS` of four stacked code units in the left band.

## Reading path

1. Marker 1, on the top-left corner of the `FOUR CONSUMERS` band inside the `CALLERS` band: four code units stacked top to bottom,
   Catzc.Tooling.Environment, Catzc.Azure.Templates, Catzc.Base.Languages and Catzc.Base.QualityGates.
2. Right along the one edge that leaves the band, carrying the chip `4/4`, to marker 2, `CATZC.BASE.CONFIG` band: the code unit
   Get-ConfigValue.
3. Down to marker 3: the code unit Resolve-ConfigKeyPath, directly below Get-ConfigValue.
4. Right from Get-ConfigValue to marker 4: the code unit Get-Config.
5. Right to marker 5, `COMMITTED CONFIG` band: the file configs/&lt;name&gt;.yml.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                                               |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 7     | Catzc.Tooling.Environment, Catzc.Azure.Templates, Catzc.Base.Languages, Catzc.Base.QualityGates (`CALLERS`, in the `FOUR CONSUMERS` band); Get-ConfigValue, Get-Config, Resolve-ConfigKeyPath (`CATZC.BASE.CONFIG`) |
| file                  | 1     | configs/&lt;name&gt;.yml (`COMMITTED CONFIG`)                                                                                                                                                                       |

Code units are slate and the file is olive, all with white names. The `FOUR CONSUMERS` band is chrome, drawn in the band style like the
three outer bands. The chip `4/4` is a bold fraction just above the edge from the band to Get-ConfigValue.

## Edges

| Edge kind | Count | From → to                                                                                                                                                              |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | the `FOUR CONSUMERS` band → Get-ConfigValue (chip `4/4`), Get-ConfigValue → Get-Config, Get-ConfigValue → Resolve-ConfigKeyPath, Get-Config → configs/&lt;name&gt;.yml |

Every edge is straight; three are horizontal and one runs down. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                    | Phrase                                  |
| ------------------------- | --------------------------------------- |
| slate rounded box         | code unit                               |
| olive page, folded corner | file                                    |
| thin arrow                | flow: depends on                        |
| light disc `1`            | marker: a Walkthrough step              |
| small band swatch         | band: one module group                  |
| bold `4/4`                | fraction chip: callers taking this edge |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-CONF-ADDRESSING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.grid.md),
[tree](../.assets/tree/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.chain.md), which hold the
reason for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-CONF-ADDRESSING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

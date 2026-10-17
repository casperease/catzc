---
catzc:
  immutable:
    with_body_sha: "9113a49c0e0d"
    repo_status: clean
    path: docs/.assets/explanation/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-repo-rootcfg-one-registry-one-writer-two-primitives-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.drawio.png
      - docs/.assets/explanation/chain/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.chain.md
      - docs/.assets/explanation/grid/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.grid.md
      - docs/.assets/explanation/tree/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.tree.md
      - docs/explanation/repository/one-registry-one-writer-two-primitives.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One registry, one writer, two write primitives: the diagram described

```text
A 1572 x 640 diagram, read left to right through four bands under one span bar.
Glyphs: 2 files (olive), 1 named set (mauve), 3 code units (slate), 2 results (green); 7 flow edges, 2 with fraction chips; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](one-registry-one-writer-two-primitives.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands, labelled `SOURCE OF TRUTH`, `CATZC.BASE.ROOTCONFIG`, `CATZC.BASE.FILES` and `TARGET`; a span bar labelled `IMPORTER TAIL` runs over
the two middle bands. It holds eight glyphs, two files, one named set, three code units and two results, joined by seven horizontal flow
edges, with eight markers and a legend panel along the bottom. The two results share a thin frame in the right band. The eye lands first on
the tall slate code unit that fills the second band.

## Reading path

1. Markers 1, 2 and 3, left band, top to bottom: the file "authored source files", the named set "generator functions", the file
   "rootconfig.yml".
2. Along the three edges into marker 4, second band: the tall code unit "Build-RootConfig".
3. Along the upper edge, fraction chip 7/23, to marker 5, third band: the code unit "Set-FileLink"; along the lower edge, fraction chip
   16/23, to marker 6: the code unit "Write-FileIfChanged".
4. Marker 7, right band, upper: the result "gitignored targets", entered from Set-FileLink.
5. Marker 8, right band, lower: the result "tracked targets"; the edge from Write-FileIfChanged ends on the frame that holds both results.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------- |
| file                  | 2     | authored source files (left band, top), rootconfig.yml (left band, bottom)              |
| named set             | 1     | generator functions (left band, middle)                                                 |
| code unit             | 3     | Build-RootConfig (second band, tall), Set-FileLink and Write-FileIfChanged (third band) |
| result                | 2     | gitignored targets and tracked targets (right band, inside one frame)                   |

Files are olive, the named set mauve, code units slate and results green, all with light names. The frame is chrome, not a kind.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                                                               |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 7     | authored source files → Build-RootConfig, generator functions → Build-RootConfig, rootconfig.yml → Build-RootConfig, Build-RootConfig → Set-FileLink (7/23), Build-RootConfig → Write-FileIfChanged (16/23), Set-FileLink → gitignored targets, Write-FileIfChanged → the targets frame |

Every edge is straight and horizontal, and none crosses another. The two edges leaving Build-RootConfig carry a fraction chip each.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                  |
| ----------------- | --------------------------------------- |
| olive page        | file                                    |
| mauve rounded box | named set                               |
| slate rounded box | code unit                               |
| green rounded box | result                                  |
| thin arrow        | flow: feeds the next step               |
| bold `7/23`       | fraction chip: entries taking this edge |
| light disc `1`    | marker: a Walkthrough step              |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-REPO-ROOTCFG): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.grid.md),
[tree](../.assets/tree/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-REPO-ROOTCFG" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/automation/two-crossers-and-three-anchors.drawio.md
    folder: docs/explanation/automation
    name: two-crossers-and-three-anchors-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-path--two-crossers-and-three-anchors--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-auto-path--two-crossers-and-three-anchors--architecture.chain.md
      - docs/explanation/.assets/grid/adr-auto-path--two-crossers-and-three-anchors--architecture.grid.md
      - docs/explanation/.assets/tree/adr-auto-path--two-crossers-and-three-anchors--architecture.tree.md
      - docs/explanation/automation/two-crossers-and-three-anchors.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Two crossers and three anchors: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands, then the band below.
Glyphs: 2 named sets (mauve), 3 code units (slate), 3 stores (slate); 9 flow edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-path--two-crossers-and-three-anchors--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](two-crossers-and-three-anchors.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `COMMUNICATION FORM`, `THE TWO CROSSERS` and `BINDING FORM`, then down to one full-width band labelled `CROSS-STAGE`. It
holds eight glyphs, two named sets, three code units and three stores, joined by nine flow edges, with eight markers and a legend panel
along the bottom. The eye lands first on the two tall named sets that fill the outer bands.

## Reading path

1. Marker 1, `COMMUNICATION FORM` band: the tall named set Returns, records, configs.
2. Right along the upper flow edge to marker 2, `THE TWO CROSSERS` band, top: the code unit Resolve-RepoPath.
3. Right along the upper flow edge to marker 3, `BINDING FORM` band: the tall named set Reads, writes, tool calls.
4. Back along the lower flow edge to marker 4, `THE TWO CROSSERS` band, bottom: the code unit ConvertTo-RepoRelativePath, and on to Returns,
   records, configs.
5. Markers 5 and 6, `THE TWO CROSSERS` band, middle, left to right: the stores output root and repository root, each with one flow edge up
   into Resolve-RepoPath and one down into ConvertTo-RepoRelativePath.
6. Down to markers 7 and 8, `CROSS-STAGE` band, left to right: the store artifact root and the code unit ArtifactRef.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 2     | Returns, records, configs (`COMMUNICATION FORM`), Reads, writes, tool calls (`BINDING FORM`), both the full height of the band   |
| code unit             | 3     | Resolve-RepoPath (`THE TWO CROSSERS`, top), ConvertTo-RepoRelativePath (`THE TWO CROSSERS`, bottom), ArtifactRef (`CROSS-STAGE`) |
| store                 | 3     | output root and repository root (`THE TWO CROSSERS`, middle), artifact root (`CROSS-STAGE`, left of ArtifactRef)                 |

Named sets are mauve; code units and stores are slate, the stores drawn as cylinders. All names are light.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                                                                                                                                           |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 9     | Returns, records, configs → Resolve-RepoPath; Resolve-RepoPath → Reads, writes, tool calls; Reads, writes, tool calls → ConvertTo-RepoRelativePath; ConvertTo-RepoRelativePath → Returns, records, configs; output root → Resolve-RepoPath; output root → ConvertTo-RepoRelativePath; repository root → Resolve-RepoPath; repository root → ConvertTo-RepoRelativePath; artifact root → ArtifactRef |

Every edge is straight, horizontal or vertical, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| slate rounded box | code unit                  |
| slate cylinder    | store: an anchor root      |
| grey band         | band: one stage            |
| thin arrow        | flow: hands a path to      |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-PATH): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-path--two-crossers-and-three-anchors--architecture.grid.md),
[tree](../.assets/tree/adr-auto-path--two-crossers-and-three-anchors--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-auto-path--two-crossers-and-three-anchors--architecture.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AUTO-PATH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

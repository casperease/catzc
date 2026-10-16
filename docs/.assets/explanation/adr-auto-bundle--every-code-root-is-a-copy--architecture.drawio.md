---
catzc:
  immutable:
    with_body_sha: "30ee0a7a9bbc"
    path: docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-bundle-every-code-root-is-a-copy-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
      - docs/explanation/automation/every-code-root-is-a-copy.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One engine builds, every code root is a copy: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 1 store (slate), 2 code units (slate), 1 gate, 3 results; 6 flow edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/every-code-root-is-a-copy.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `CODE ROOTS`. It holds seven glyphs (one store, two code units, one gate and three results)
joined by six flow edges, with eight markers and a legend panel along the bottom. A thin grey frame in the CODE ROOTS band holds two results
stacked one above the other, and a single edge enters the frame. The eye lands first on the grey rhombus (the gate) in the BUILD band.

## Reading path

1. Marker 1, SOURCE band: the store automation/, a cylinder.
2. Along the line to marker 2, BUILD band: the code unit Catzc.Internal.Builder.
3. Marker 3, BUILD band: the gate Assert-CatzcBundle.
4. Marker 4, BUNDLE band: the result Temporary build.
5. Markers 5 and 6, CODE ROOTS band, top to bottom inside the frame: the results Installed and Saved.
6. Marker 7, BUILD band, below the line: the code unit Catzc.Base.Exporter, with an edge up into Catzc.Internal.Builder.
7. Marker 8, just below the returning edge above the bands, which runs from the top of the frame back down into the top of the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                        |
| --------------------- | ----- | -------------------------------------------------------------------------------------------- |
| store                 | 1     | automation/ (SOURCE band)                                                                    |
| code unit             | 2     | Catzc.Internal.Builder (BUILD band, on the line), Catzc.Base.Exporter (BUILD band, below it) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                            |
| result                | 3     | Temporary build (BUNDLE band), Installed and Saved (CODE ROOTS band, in the frame)           |

The store and the code units are slate with white names; the gate is grey and the results are green.

## Edges

| Edge kind | Count | From → to                                                                                                                                                     |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 6     | automation/ → Catzc.Internal.Builder → Assert-CatzcBundle → Temporary build → frame; Catzc.Base.Exporter → Catzc.Internal.Builder; frame → Assert-CatzcBundle |

Five edges are short and straight: four horizontal on the line and one vertical between the two code units. The sixth leaves the top of the
frame, runs left above the bands, and drops into the top point of the gate; it is drawn as three straight segments with one arrowhead. No
edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| slate cylinder          | store                             |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| grey arrow              | flow: feeds or runs the next step |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md),
[tree](adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md) and [value-chain map](adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

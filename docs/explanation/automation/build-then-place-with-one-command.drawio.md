---
catzc:
  immutable:
    with_body_sha: "298bc3b0ca5b"
    repo_status: clean
    path: docs/explanation/automation/build-then-place-with-one-command.drawio.md
    folder: docs/explanation/automation
    name: build-then-place-with-one-command-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.png
      - docs/explanation/.assets/chain/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
      - docs/explanation/.assets/grid/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
      - docs/explanation/.assets/tree/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md
      - docs/explanation/automation/build-then-place-with-one-command.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Build, then place with one command: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 5 code units (slate), 1 gate, 1 result, 1 failure; 4 flow edges, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](build-then-place-with-one-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `TARGETS`. It holds eight glyphs (five code units, one gate, one failure and one result)
joined by four flow edges and one failure path, with eight markers and a legend panel along the bottom. Four glyphs sit on one horizontal
line; the failure hangs below the gate, and a thin grey frame in the TARGETS band holds three code units stacked one above the other,
entered by a single edge. The eye lands first on the red failure below the grey rhombus (the gate).

## Reading path

1. Marker 1, SOURCE band: the code unit . ./importer.ps1.
2. Marker 2, BUILD band: the code unit Build-Modules.
3. Marker 3, BUILD band: the gate Assert-CatzcBundle.
4. Marker 4, below it: the failure Catzc build … is invalid, reached by the red failure path from the bottom point of the gate.
5. Marker 5, BUNDLE band: the result Built Catzc 6.6.666.
6. Markers 6, 7 and 8, TARGETS band, top to bottom inside the frame: the code units Install-Catzc -Scope, Export-Catzc -Root and
   Export-Catzc -To nuget.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | . ./importer.ps1 (SOURCE band), Build-Modules (BUILD band), Install-Catzc -Scope, Export-Catzc -Root, Export-Catzc -To nuget (TARGETS band, in the frame) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                                                                                         |
| failure               | 1     | Catzc build … is invalid (BUILD band, below the gate)                                                                                                     |
| result                | 1     | Built Catzc 6.6.666 (BUNDLE band)                                                                                                                         |

The code units are slate with white names; the gate is grey, the result green and the failure red.

## Edges

| Edge kind    | Count | From → to                                                                           |
| ------------ | ----- | ----------------------------------------------------------------------------------- |
| flow         | 4     | . ./importer.ps1 → Build-Modules → Assert-CatzcBundle → Built Catzc 6.6.666 → frame |
| failure path | 1     | Assert-CatzcBundle → Catzc build … is invalid                                       |

Every edge is short and straight: four horizontal on the line, and one red vertical below the gate. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| red rounded box         | failure                           |
| grey arrow              | flow: feeds or runs the next step |
| red arrow               | failure path                      |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md),
[tree](../.assets/tree/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md) and
[value-chain map](../.assets/chain/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

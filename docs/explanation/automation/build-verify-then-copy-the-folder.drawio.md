---
catzc:
  immutable:
    with_body_sha: e2e53be9ddcf
    repo_status: clean
    path: docs/explanation/automation/build-verify-then-copy-the-folder.drawio.md
    folder: docs/explanation/automation
    name: build-verify-then-copy-the-folder-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.png
      - docs/explanation/.assets/chain/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
      - docs/explanation/.assets/grid/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
      - docs/explanation/.assets/tree/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md
      - docs/explanation/automation/build-verify-then-copy-the-folder.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Build, verify, then copy the folder: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 1 file (olive), 4 code units (slate), 1 gate, 1 result; 6 flow edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](build-verify-then-copy-the-folder.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `TARGETS`. It holds seven glyphs (one file, four code units, one gate and one result) joined
by six flow edges, with eight markers and a legend panel along the bottom. Five glyphs sit on one horizontal line; a thin grey frame in the
TARGETS band holds two more code units stacked one above the other, and a single edge enters the frame. The eye lands first on the grey
rhombus (the gate) at the right end of the BUILD band.

## Reading path

1. Marker 1, SOURCE band: the file exporter.yml, a page with a folded corner.
2. Markers 2 and 3, BUILD band, left to right: the code units Build-Modules and Invoke-ModuleBuild.
3. Marker 4, BUILD band, right: the gate Assert-CatzcBundle.
4. Marker 5, BUNDLE band: the result Catzc/6.6.666/.
5. Markers 6 and 7, TARGETS band, top to bottom inside the frame: the code units Install-Catzc and New-CatzcNuGetPackage.
6. Marker 8, just below the returning edge above the bands, which runs from the top of Install-Catzc back down into the top of the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | exporter.yml (SOURCE band)                                                                                              |
| code unit             | 4     | Build-Modules and Invoke-ModuleBuild (BUILD band), Install-Catzc and New-CatzcNuGetPackage (TARGETS band, in the frame) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                                                       |
| result                | 1     | Catzc/6.6.666/ (BUNDLE band)                                                                                            |

The file is olive and the code units slate, both with white names; the gate is grey and the result is green.

## Edges

| Edge kind | Count | From → to                                                                                                                           |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 6     | exporter.yml → Build-Modules → Invoke-ModuleBuild → Assert-CatzcBundle → Catzc/6.6.666/ → frame; Install-Catzc → Assert-CatzcBundle |

The five edges on the line are short, straight and horizontal. The sixth leaves the top of Install-Catzc, runs left above the bands, and
drops into the top point of the gate; it is drawn as three straight segments with one arrowhead. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| olive page              | file                              |
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
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md),
[tree](../.assets/tree/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

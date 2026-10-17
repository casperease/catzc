---
catzc:
  immutable:
    with_body_sha: b32dc2c0042f
    repo_status: clean
    path: docs/explanation/repository/an-edit-lands-at-the-next-import.drawio.md
    folder: docs/explanation/repository
    name: an-edit-lands-at-the-next-import-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-repo-variant--an-edit-lands-at-the-next-import--operations.drawio.png
      - docs/explanation/.assets/chain/adr-repo-variant--an-edit-lands-at-the-next-import--operations.chain.md
      - docs/explanation/.assets/grid/adr-repo-variant--an-edit-lands-at-the-next-import--operations.grid.md
      - docs/explanation/.assets/tree/adr-repo-variant--an-edit-lands-at-the-next-import--operations.tree.md
      - docs/explanation/repository/an-edit-lands-at-the-next-import.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# An edit to a variant lands at the next import: the diagram described

```text
A 1572 x 736 diagram, read top to bottom through four bands, with failures to the right.
Glyphs: 1 file (olive), 2 code units (slate), 2 gates (neutral), 3 failures (red); 3 flow edges, 3 failure paths; 8 markers; one frame.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-repo-variant--an-edit-lands-at-the-next-import--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](an-edit-lands-at-the-next-import.md).

## At a glance

A 1572 × 736 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `EDIT`, `RE-IMPORT`, `LOAD` and `ASK`. A left column holds the main flow, a file, a code unit, a gate, and then a
gate over a code unit inside a thin frame; a right column holds three red failures, each level with the glyph whose failure path reaches it.
Three flow edges run down the left column and three failure paths run right, with eight markers and a legend panel along the bottom. The eye
lands first on the three red failures on the right.

## Reading path

1. Marker 1, top band: the file `variants.yml`, left column.
2. Down one edge to marker 2, second band: the code unit `importer.ps1`.
3. Down one edge to marker 3, third band: the gate `VariantsConfig`; its failure path runs right to marker 4, the failure
   `validation failed`.
4. Down one edge to the top of the frame in the bottom band: marker 5, the gate `Assert-HaveCustomers`, whose failure path runs right to
   marker 6, the failure `deployments are disabled`; below it marker 7, the code unit `Sync-GeneratedFile`, whose failure path runs right to
   marker 8, the failure `Skipped: main-via-pr on main`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                           |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | `variants.yml` (top band)                                                                                                       |
| code unit             | 2     | `importer.ps1` (second band), `Sync-GeneratedFile` (bottom band, in the frame)                                                  |
| gate                  | 2     | `VariantsConfig` (third band), `Assert-HaveCustomers` (bottom band, in the frame)                                               |
| failure               | 3     | `validation failed` (third band), `deployments are disabled` and `Skipped: main-via-pr on main` (bottom band), all right column |

The file is olive, the code units slate, the gates neutral rhombi with a light 3 px rim, and the failures red with a bright rim. The frame
around the two glyphs of the bottom band is chrome: no fill, a thin dark rim.

## Edges

| Edge kind          | Count | From → to                                                                                                                              |
| ------------------ | ----- | -------------------------------------------------------------------------------------------------------------------------------------- |
| flow: comes before | 3     | variants.yml → importer.ps1; importer.ps1 → VariantsConfig; VariantsConfig → the frame                                                 |
| failure path       | 3     | VariantsConfig → validation failed; Assert-HaveCustomers → deployments are disabled; Sync-GeneratedFile → Skipped: main-via-pr on main |

The flow edges are vertical and the failure paths horizontal; none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns over two rows, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: comes before         |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-REPO-VARIANT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-repo-variant--an-edit-lands-at-the-next-import--operations.grid.md),
[tree](../.assets/tree/adr-repo-variant--an-edit-lands-at-the-next-import--operations.tree.md) and
[value-chain map](../.assets/chain/adr-repo-variant--an-edit-lands-at-the-next-import--operations.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-REPO-VARIANT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

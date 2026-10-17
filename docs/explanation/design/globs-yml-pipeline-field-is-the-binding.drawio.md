---
catzc:
  immutable:
    with_body_sha: a0ffd8272fe5
    repo_status: clean
    path: docs/explanation/design/globs-yml-pipeline-field-is-the-binding.drawio.md
    folder: docs/explanation/design
    name: globs-yml-pipeline-field-is-the-binding-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md
      - docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# globs.yml's pipeline: field is the binding: the diagram described

```text
A 1572 x 640 diagram: one file holding four named sets, read left to right into a band of runners.
Glyphs: 1 file (olive), 4 named sets (mauve), 4 runners (slate); 5 edges; 7 markers; 1 fraction chip.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](globs-yml-pipeline-field-is-the-binding.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The left half is one large file glyph labelled
globs.yml, its name centred at the top, that holds four named sets stacked in a column; the right half is a band labelled PIPELINES with
four runners. It holds nine glyphs (one file, four named sets, four runners) joined by five edges, with seven markers, one fraction chip and
a legend panel along the bottom. The eye lands first on the large olive file page.

## Reading path

1. Marker 1, the top-left corner of the file glyph globs.yml.
2. Markers 2, 3 and 4, down the column inside it: the named sets automation:, infrastructure: and nova: · apex: · flux: · shared:, each with
   an edge right to a runner.
3. Marker 5, bottom of the column: the named set foundation base unit, with a thick edge up into the set above it.
4. Marker 6, PIPELINES band, third row: the runner cd-&lt;unit&gt;.yaml.
5. Marker 7, just below the short edge right to the runner extends/cd-customer.yaml, with the fraction chip 3/4 above it.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                      |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | globs.yml, the large page on the left that holds the named sets                                                            |
| named set             | 4     | automation:, infrastructure:, nova: · apex: · flux: · shared:, foundation base unit (one column, top to bottom)            |
| runner                | 4     | ci-automation.yaml, ci-infrastructure.yaml, cd-&lt;unit&gt;.yaml (one column); extends/cd-customer.yaml (third row, right) |

The file is olive, named sets mauve and runners slate, all with white names.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | automation: → ci-automation.yaml, infrastructure: → ci-infrastructure.yaml, nova: · apex: · flux: · shared: → cd-&lt;unit&gt;.yaml, cd-&lt;unit&gt;.yaml → extends/cd-customer.yaml (marker 7) |
| thick     | 1     | foundation base unit → nova: · apex: · flux: · shared: (vertical, upward)                                                                                                                      |

Every edge is straight and none crosses another. The fourth row holds no runner.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                          |
| ----------------- | ----------------------------------------------- |
| olive page        | file                                            |
| mauve rounded box | named set                                       |
| slate pill        | runner                                          |
| thin arrow        | flow: names the next file by key                |
| thick arrow       | thick: composes into (compose:), to a named set |
| bold `3/4`        | fraction chip: pipelines that extend it         |
| dark disc `1`     | marker: a Walkthrough step                      |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-TRACK): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md),
[tree](../.assets/tree/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

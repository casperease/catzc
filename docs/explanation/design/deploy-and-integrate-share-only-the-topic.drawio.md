---
catzc:
  immutable:
    with_body_sha: "2975ea9f44dd"
    repo_status: clean
    path: docs/explanation/design/deploy-and-integrate-share-only-the-topic.drawio.md
    folder: docs/explanation/design
    name: deploy-and-integrate-share-only-the-topic-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md
      - docs/explanation/design/deploy-and-integrate-share-only-the-topic.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Deploying a topic commit and integrating it share only the topic commit: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 4 commits, 1 gate, 1 environment, 1 ADR-only; 3 flow edges, 2 ADR-only edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](deploy-and-integrate-share-only-the-topic.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING, with a span bar labelled CI above the MAIN and AFTER
LANDING bands. It holds seven glyphs: four commits, one gate, one environment and one ADR-only glyph. A straight flow line runs across the
top row from the brown commit to the yellow one; a dashed path drops from the brown commit into the OUT-OF-BAND band. Six markers number the
reading order, and a legend panel runs along the bottom. The eye lands first on the long top line.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic commit above it.
2. Down the dashed edge and right to marker 2, OUT-OF-BAND band: the dashed white pill, workflow / pipeline.
3. Down the dashed edge to marker 3: the environment hexagon, with a small brown commit inside, above its name.
4. Back to the top row, along the flow edge to marker 4, MAIN band: the grey commit, main.
5. Right to marker 5, AFTER LANDING band: the gate BVT, then on to the yellow commit labelled BVT-verified.
6. Marker 6, just above the top flow edge where it crosses the OUT-OF-BAND band, rim touching the line.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------ |
| commit                | 4     | brown topic commit (TOPIC), grey main (MAIN), yellow BVT-verified (AFTER LANDING), small brown occupant inside the environment |
| gate                  | 1     | BVT (AFTER LANDING, top row), 3 px rim                                                                                         |
| environment           | 1     | environment (OUT-OF-BAND, bottom)                                                                                              |
| ADR-only              | 1     | workflow / pipeline (OUT-OF-BAND, middle), a dashed white pill                                                                 |

The commits keep the locked commit palette; the gate and the environment are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                     |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | topic commit → main (marker 6), main → BVT, BVT → BVT-verified                                                                                                                                |
| ADR-only  | 2     | topic commit → workflow / pipeline (one dashed edge drawn as two cells: a down leg with no arrowhead to a bend point, then a right leg with the arrowhead), workflow / pipeline → environment |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                            |
| --------------------------------- | --------------------------------- |
| brown, grey and yellow discs      | commit (locked palette)           |
| grey rhombus with a thick rim     | gate                              |
| grey hexagon                      | environment: its occupant inside  |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge |
| thin arrow                        | flow: lands, then climbs          |
| dark disc `1`                     | marker: a Walkthrough step        |
| crossbar                          | span bar: stages over bands       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE and ADR-DSGN-VISUAL): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md),
[tree](../.assets/tree/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE and ADR-DSGN-VISUAL" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

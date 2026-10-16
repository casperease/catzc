---
catzc:
  immutable:
    with_body_sha: d5f31c0bb9a1
    path: docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-thinplat-bind-to-one-cli-delegate-the-rest-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.png
      - docs/.assets/explanation/chain/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
      - docs/.assets/explanation/grid/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
      - docs/.assets/explanation/tree/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md
      - docs/explanation/design/bind-to-one-cli-delegate-the-rest.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Bind to one CLI; delegate the rest: the diagram described

```text
A 1572 x 750 diagram, read top to bottom through four bands down one centre spine.
Glyphs: 1 actor, 1 code unit (slate), 1 external tool, 1 environment; 3 flow edges; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/bind-to-one-cli-delegate-the-rest.md).

## At a glance

A 1572 × 750 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled CONSUMERS, CLI SURFACE, DELEGATED and VENDOR SUBSTRATE, down one centre spine. It holds four glyphs, one per band
(an actor, a code unit, an external tool and an environment), joined by three flow edges, with four markers and a legend panel along the
bottom. The eye lands first on the slate code unit in the CLI SURFACE band, the only dark glyph.

## Reading path

1. Marker 1, CONSUMERS band: the actor developer.
2. Down to marker 2, CLI SURFACE band: the code unit one CLI.
3. Down to marker 3, DELEGATED band: the external tool vendor tooling.
4. Down to marker 4, VENDOR SUBSTRATE band: the environment cloud vendor.

## Glyphs

| Glyph (legend phrase) | Count | Where                                   |
| --------------------- | ----- | --------------------------------------- |
| actor                 | 1     | developer (CONSUMERS, centre)           |
| code unit             | 1     | one CLI (CLI SURFACE, centre)           |
| external tool         | 1     | vendor tooling (DELEGATED, centre)      |
| environment           | 1     | cloud vendor (VENDOR SUBSTRATE, centre) |

The code unit is slate with a white name; the others are white or neutral grey.

## Edges

| Edge kind | Count | From → to                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------- |
| flow      | 3     | developer → one CLI, one CLI → vendor tooling, vendor tooling → cloud vendor |

All three edges are straight and vertical on one line.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| white circle      | actor                      |
| slate rounded box | code unit                  |
| grey square box   | external tool              |
| grey hexagon      | environment                |
| grey arrow        | flow: uses                 |
| dark disc `1`     | marker: a Walkthrough step |
| grey band         | band: one layer            |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-THINPLAT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md),
[tree](tree/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md) and
[value-chain map](chain/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-THINPLAT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

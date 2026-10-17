---
catzc:
  immutable:
    with_body_sha: "6112dcf887fa"
    repo_status: clean
    path: docs/explanation/design/four-domains-promote-one-artifact.drawio.md
    folder: docs/explanation/design
    name: four-domains-promote-one-artifact-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
      - docs/explanation/design/four-domains-promote-one-artifact.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Four pipeline kinds promote one artifact: the diagram described

```text
A 1572 x 600 diagram, read left to right through five bands standing side by side.
Glyphs: 8 commits, 1 runner (slate), 5 environments (grey), 1 store (slate); 9 flow edges; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](four-domains-promote-one-artifact.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through five tall
bands standing side by side as columns, labelled GIT, CI, CD, DEPLOY-NON-PROD and DEPLOY-PROD. Three span bars run above them: CI over the
CI band, CD over the CD band, and DEPLOY over the last two bands. One row of glyphs crosses the bands at mid-height: three commits, one
runner and five environments, each environment holding one commit near its top. A wide store lies below the row, from the CI band to the
right edge. The eye lands first on the row of five grey hexagons, each with a coloured commit inside.

## Reading path

1. Marker 1, GIT band: the brown commit `topic`, then the grey commit `main` to its right.
2. Marker 2, CI band: the runner `CI engine`, then the yellow commit `BVT`.
3. Marker 3, CD band: the environment `on-demand env`, holding a blue commit.
4. Markers 4 and 5, DEPLOY-NON-PROD band: the environments `main-uat` (light-blue commit) and `release-uat` (light-green commit).
5. Marker 6, DEPLOY-PROD band: the environments `pre-prod` and `production`, each holding a green commit.
6. Down from the runner to marker 7: the store `tagged artifact`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                           |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------- |
| commit                | 8     | brown and grey in the GIT band, yellow in the CI band, one inside each of the five environments |
| runner                | 1     | `CI engine`, CI band                                                                            |
| environment           | 5     | `on-demand env` (CD band), `main-uat`, `release-uat`, `pre-prod`, `production`                  |
| store                 | 1     | `tagged artifact`, below the row, CI band to DEPLOY-PROD band                                   |

The runner and the store are slate with white names; the environments are neutral grey, each coloured only by the commit it holds.

## Edges

| Edge kind | Count | From → to                                                                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------- |
| flow      | 9     | topic → main → CI engine → BVT → on-demand env → main-uat → release-uat → pre-prod → production; CI engine → tagged artifact |

Eight edges run straight and horizontal along the row; one drops straight down from the runner into the store. None crosses another. No
chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                              | Phrase                            |
| ----------------------------------- | --------------------------------- |
| seven small commits, brown to green | commit (locked palette)           |
| slate pill                          | runner                            |
| grey hexagon                        | environment, holding its occupant |
| slate cylinder                      | store                             |
| thin arrow                          | flow: promotes, or builds         |
| span bar                            | span bar: stages over bands       |
| dark disc `1`                       | marker: a Walkthrough step        |
| grey band                           | `band: one pipeline domain`       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md),
[tree](../.assets/tree/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

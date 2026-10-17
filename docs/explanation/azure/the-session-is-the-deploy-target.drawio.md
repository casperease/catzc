---
catzc:
  immutable:
    with_body_sha: "25b1d77d44db"
    repo_status: clean
    path: docs/explanation/azure/the-session-is-the-deploy-target.drawio.md
    folder: docs/explanation/azure
    name: the-session-is-the-deploy-target-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-az-datamod--the-session-is-the-deploy-target--meta.drawio.png
      - docs/explanation/.assets/chain/adr-az-datamod--the-session-is-the-deploy-target--meta.chain.md
      - docs/explanation/.assets/grid/adr-az-datamod--the-session-is-the-deploy-target--meta.grid.md
      - docs/explanation/.assets/tree/adr-az-datamod--the-session-is-the-deploy-target--meta.tree.md
      - docs/explanation/azure/the-session-is-the-deploy-target.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The session is the deploy target: the diagram described

```text
A 1572 x 640 diagram, read left to right through two bands.
Glyphs: 1 external tool (neutral), 1 gate (neutral), 1 result, 1 failure; 2 flow edges, 1 failure path; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-datamod--the-session-is-the-deploy-target--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](the-session-is-the-deploy-target.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two
bands, `SESSION` on the left and the wider `GUARD` on the right. It holds four glyphs, one external tool, one gate, one result and one
failure, joined by two flow edges and one failure path, with four markers and a legend panel along the bottom. The eye lands first on the
gate in the middle of the guard band, with the green result to its right and the red failure below it.

## Reading path

1. Marker 1, session band: the external tool az session.
2. Right along the flow edge into the guard band, to marker 2: the gate subscription guard.
3. Right along the second flow edge to marker 3: the result deploy target.
4. Down the failure path from the gate to marker 4: the failure mis-wired connection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                             |
| --------------------- | ----- | ------------------------------------------------- |
| external tool         | 1     | az session (session band)                         |
| gate                  | 1     | subscription guard (guard band, centre)           |
| result                | 1     | deploy target (guard band, right)                 |
| failure               | 1     | mis-wired connection (guard band, below the gate) |

The external tool and the gate are neutral, dark with a light rim; the result is green and the failure red, both with light names.

## Edges

| Edge kind                   | Count | From → to                                       |
| --------------------------- | ----- | ----------------------------------------------- |
| flow: decides the next step | 2     | az session → subscription guard → deploy target |
| failure path                | 1     | subscription guard → mis-wired connection       |

Every edge is straight: the two flow edges run horizontally on one line, and the failure path runs vertically down from the gate.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch             | Phrase                      |
| ------------------ | --------------------------- |
| neutral square box | external tool               |
| neutral rhombus    | gate                        |
| green rounded box  | result                      |
| red rounded box    | failure                     |
| thin arrow         | flow: decides the next step |
| red arrow          | failure path                |
| light disc `1`     | marker: a Walkthrough step  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-DATAMOD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-datamod--the-session-is-the-deploy-target--meta.grid.md),
[tree](../.assets/tree/adr-az-datamod--the-session-is-the-deploy-target--meta.tree.md) and
[value-chain map](../.assets/chain/adr-az-datamod--the-session-is-the-deploy-target--meta.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-AZ-DATAMOD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

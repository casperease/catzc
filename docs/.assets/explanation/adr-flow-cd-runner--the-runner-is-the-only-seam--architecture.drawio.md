---
catzc:
  immutable:
    with_body_sha: c438fc80f397
    path: docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-runner-the-runner-is-the-only-seam-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
      - docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.png
      - docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
      - docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md
      - docs/explanation/flow/the-runner-is-the-only-seam.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The runner is the only seam into PowerShell: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands, with a fourth band below.
Glyphs: 2 files (olive), 1 runner, 2 code units (slate), 1 actor; 5 flow edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/the-runner-is-the-only-seam.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands in one row, labelled YAML, ADO TASK and POWERSHELL, with a fourth band, DEVELOPER, below POWERSHELL. It holds six glyphs (two files,
one runner, two code units and one actor) joined by five edges, with six markers and a legend panel along the bottom. The eye lands first on
the slate pill alone in the middle band.

## Reading path

1. Marker 1, YAML band: the file pipeline YAML, at the left edge.
2. Right along the edge with the fraction chip 6/7 to marker 2, the file invoke-automation.yaml.
3. Right into the ADO TASK band: marker 3, the runner task by Mode.
4. Right into the POWERSHELL band: marker 4, the code unit Invoke-AdoScript.ps1, then marker 5, the code unit importer.ps1.
5. Down to marker 6, DEVELOPER band: the actor developer, whose edge rises to importer.ps1.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                |
| --------------------- | ----- | ---------------------------------------------------- |
| file                  | 2     | pipeline YAML, invoke-automation.yaml (YAML band)    |
| runner                | 1     | task by Mode (ADO TASK band)                         |
| code unit             | 2     | Invoke-AdoScript.ps1, importer.ps1 (POWERSHELL band) |
| actor                 | 1     | developer (DEVELOPER band, under importer.ps1)       |

Files are olive pages; the runner and the code units are slate, told apart by the pill and the rounded box; all carry white names.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                         |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | pipeline YAML → invoke-automation.yaml, invoke-automation.yaml → task by Mode, task by Mode → Invoke-AdoScript.ps1, Invoke-AdoScript.ps1 → importer.ps1, developer → importer.ps1 |

Four edges are straight and horizontal along one row; the fifth is vertical, from the actor up to importer.ps1. None crosses another. One
fraction chip, 6/7, sits just above the first edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                      |
| ----------------- | ------------------------------------------- |
| olive page        | file                                        |
| slate pill        | runner                                      |
| slate rounded box | code unit                                   |
| white circle      | actor                                       |
| thin arrow        | flow: calls                                 |
| bold `6/7`        | fraction chip: root pipelines that reach it |
| dark disc `1`     | marker: a Walkthrough step                  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-RUNNER): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md),
[tree](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md) and [value-chain map](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

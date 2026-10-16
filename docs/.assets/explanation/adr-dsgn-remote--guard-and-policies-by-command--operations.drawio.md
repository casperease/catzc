---
catzc:
  immutable:
    with_body_sha: fbefa2a1f591
    path: docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-remote-guard-and-policies-by-command-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.png
      - docs/.assets/explanation/chain/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
      - docs/.assets/explanation/grid/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
      - docs/.assets/explanation/tree/adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md
      - docs/explanation/design/guard-and-policies-by-command.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Flip git_workspace; sync the ADO policies: the diagram described

```text
A 1572 x 600 diagram, read top to bottom through two bands, ON A CLONE and ADMIN, each left to right.
Glyphs: 1 file (olive), 4 code units (slate), 1 gate, 1 failure; 4 flow edges, 1 failure path; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/guard-and-policies-by-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left, which ends with the legend at about 500 px, and a 272 px sidebar on the right,
which runs to about 580 px. The drawing reads top to bottom through two full-width bands labelled ON A CLONE and ADMIN; each band reads left
to right. It holds seven glyphs, one file, four code units, one gate and one failure, joined by five edges, with seven markers and a legend
panel below the bands. The eye lands first on the red failure at the right end of the ON A CLONE row.

## Reading path

1. Marker 1, ON A CLONE, left: the file variants.yml.
2. Right through markers 2 and 3: the code units importer.ps1 and Sync-GeneratedFile.
3. Along the red edge to marker 4: the failure Skipped on main.
4. Marker 5, ADMIN, left: the code unit Sync-AdoBuildValidations.
5. Right to marker 6: the gate ADO branch policy.
6. Right to marker 7: the code unit Get-AdoBuildValidations.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                    |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------- |
| file                  | 1     | variants.yml (ON A CLONE, left)                                                                          |
| code unit             | 4     | importer.ps1, Sync-GeneratedFile (ON A CLONE); Sync-AdoBuildValidations, Get-AdoBuildValidations (ADMIN) |
| gate                  | 1     | ADO branch policy (ADMIN, between the two code units)                                                    |
| failure               | 1     | Skipped on main (ON A CLONE, right)                                                                      |

The file is olive and the code units slate, both with white names.

## Edges

| Edge kind    | Count | From → to                                                                                                                |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| flow         | 4     | variants.yml → importer.ps1 → Sync-GeneratedFile; Sync-AdoBuildValidations → ADO branch policy → Get-AdoBuildValidations |
| failure path | 1     | Sync-GeneratedFile → Skipped on main                                                                                     |

Every edge is straight and horizontal; none crosses another. The right third of both bands is empty.

## Legend

A full-width panel below the bands, in four columns, left to right:

| Swatch                          | Phrase                     |
| ------------------------------- | -------------------------- |
| olive page with a folded corner | file                       |
| slate rounded box               | code unit                  |
| rhombus with a thick rim        | gate                       |
| red rounded box                 | failure                    |
| solid arrow                     | flow: then                 |
| red arrow                       | failure path               |
| dark disc `1`                   | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-REMOTE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](grid/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md),
[tree](tree/adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md) and [value-chain map](chain/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-REMOTE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

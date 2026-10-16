---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: b1e38c2ae347
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md
      - docs/explanation/design/guard-and-policies-by-command.md
---

# Flip git_workspace; sync the ADO policies: the diagram described

```text
A 1572 x 600 diagram, read top to bottom through two bands, ON A CLONE and ADMIN, each left to right.
Glyphs: 1 file (olive), 4 code units (slate), 1 gate, 1 failure; 4 flow edges, 1 failure path; 7 markers.
Sidebar: world-map grid (2 lit cells), tree (3 lit groups), value-chain map (2 lit cells), map key.
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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md),
[tree](adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md) and
[value-chain map](adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-REMOTE); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (1 file: 1 cites ADR-DSGN-REMOTE);
  `docs × .md` (3 files: 2 cite ADR-DSGN-REMOTE; 1 is the ADR file of ADR-DSGN-REMOTE).
- **Tree** (the repository's files): 3 lit groups, `adr/dsgn` (2 files); `Docs` (1 file); `adr/*` (1 file). The ADR file
  `docs/adr/design/server-remote-integration.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × BUILD`, because ADR-DSGN-REMOTE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-DSGN-REMOTE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-DSGN-REMOTE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

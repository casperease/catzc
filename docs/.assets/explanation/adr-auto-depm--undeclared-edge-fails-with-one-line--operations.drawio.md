---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.md
    kind: asset-description
    body_sha: "8a43d969f52d"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
    links:
      - docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md
      - docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.png
      - docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md
      - docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md
      - docs/explanation/automation/undeclared-edge-fails-with-one-line.md
---

# An undeclared edge fails with one line: the diagram described

```text
A 1572 x 640 diagram, read top to bottom through three bands and left to right within each.
Glyphs: 2 runners (slate), 1 result, 2 failures, 1 file (olive); 3 flow edges, 2 failure paths; 6 markers.
Sidebar: world-map grid (3 lit cells), tree (4 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/undeclared-edge-fails-with-one-line.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled RUN, SEE and FIX, and left to right within each. It holds six glyphs, two runners, one result, two failures and
one file, joined by three flow edges and two failure paths, with six markers and a legend panel along the bottom. The eye lands first on the
two red failures stacked on the right.

## Reading path

1. Marker 1, RUN band, left: the runner Test-Automation.
2. Right to marker 2: the runner Test-ModuleDependency.
3. Right along the failure path to marker 3: the failure Bad dependencies.yml.
4. Down from marker 2 to marker 4, SEE band: the result module-dependency.md.
5. Right along the failure path to marker 5: the failure failed: N issue(s).
6. Down to marker 6, FIX band, right: the file dependencies.yml.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                        |
| --------------------- | ----- | ---------------------------------------------------------------------------- |
| runner                | 2     | Test-Automation (RUN band, left), Test-ModuleDependency (RUN band, centre)   |
| result                | 1     | module-dependency.md (SEE band, centre)                                      |
| failure               | 2     | Bad dependencies.yml (RUN band, right), failed: N issue(s) (SEE band, right) |
| file                  | 1     | dependencies.yml (FIX band, right)                                           |

Runners are slate pills and the file is olive, both with white names; the result is light green and the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                    |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------- |
| flow         | 3     | Test-Automation → Test-ModuleDependency, Test-ModuleDependency → module-dependency.md, failed: N issue(s) → dependencies.yml |
| failure path | 2     | Test-ModuleDependency → Bad dependencies.yml, module-dependency.md → failed: N issue(s)                                      |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate pill              | runner                     |
| light green rounded box | result                     |
| light red rounded box   | failure                    |
| olive folded page       | file                       |
| thin arrow              | flow: then                 |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one stage            |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md),
[tree](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md) and
[value-chain map](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-AUTO-DEPM); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `automation × .cs` (3 files: 3 cite ADR-AUTO-DEPM);
  `automation × .yml` (1 file: 1 cites ADR-AUTO-DEPM); `docs × .md` (3 files: 2 cite ADR-AUTO-DEPM; 1 is the ADR file of ADR-AUTO-DEPM).
- **Tree** (the repository's files): 4 lit groups, `ModuleSystem` (3 files); `adr/auto` (2 files); `Docs` (1 file); `adr/*` (1 file). The
  ADR file `docs/adr/automation/controlling-module-dependencies.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × LOCAL`, because ADR-AUTO-DEPM: its
  ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

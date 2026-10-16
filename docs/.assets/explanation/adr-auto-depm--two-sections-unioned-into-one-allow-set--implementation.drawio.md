---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-depm-two-sections-unioned-into-one-allow-set-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "71d34610a4b4"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md
      - docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.drawio.png
      - docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md
      - docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.md
      - docs/explanation/automation/two-sections-unioned-into-one-allow-set.md
---

# Two sections unioned into one allow-set: the diagram described

```text
A 1572 x 760 diagram, read top to bottom through four bands.
Glyphs: 2 files (olive), 4 code units (slate), 1 gate, 2 failures; 6 flow edges, 2 failure paths; 9 markers.
Sidebar: world-map grid (3 lit cells), tree (4 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/automation/two-sections-unioned-into-one-allow-set.md).

## At a glance

A 1572 × 760 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled DEPENDENCIES.YML, AT LOAD, ALLOW-SET and GATE. It holds nine glyphs, two files, four code units, one gate and two
failures, joined by six flow edges and two failure paths, with nine markers and a legend panel along the bottom. The eye lands first on the
wide code units in the middle column, which every flow edge enters or leaves.

## Reading path

1. Markers 1 and 2, DEPENDENCIES.YML band, left to right: the files `groups:` and `modules:`.
2. Down both edges to marker 3, AT LOAD band: the code unit DependenciesConfig.
3. Right along the failure path to marker 4: the failure validation failed.
4. Markers 5, 6 and 7, ALLOW-SET band, left to right: the code units Get-ModuleDependency, $resolveAllowed and Get-CSharpTypeDependency, the
   outer two pointing in to the middle one.
5. Down to marker 8, GATE band: the gate Test-ModuleDependency.
6. Right along the failure path to marker 9: the failure failed: N issue(s).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                      |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| file                  | 2     | `groups:` and `modules:` (DEPENDENCIES.YML band, centre)                                                                                   |
| code unit             | 4     | DependenciesConfig (AT LOAD band, centre); Get-ModuleDependency, $resolveAllowed, Get-CSharpTypeDependency (ALLOW-SET band, left to right) |
| gate                  | 1     | Test-ModuleDependency (GATE band, centre), 3 px rim                                                                                        |
| failure               | 2     | validation failed (AT LOAD band, right); failed: N issue(s) (GATE band, right)                                                             |

Files are olive and code units are slate, both with white names; the gate is a grey rhombus and the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                                                                          |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 6     | `groups:` → DependenciesConfig, `modules:` → DependenciesConfig, DependenciesConfig → $resolveAllowed, Get-ModuleDependency → $resolveAllowed, Get-CSharpTypeDependency → $resolveAllowed, $resolveAllowed → Test-ModuleDependency |
| failure path | 2     | DependenciesConfig → validation failed, Test-ModuleDependency → failed: N issue(s)                                                                                                                                                 |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| olive folded page       | file                       |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| light red rounded box   | failure                    |
| thin arrow              | flow: feeds                |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one stage            |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md),
[tree](adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.md) and
[value-chain map](adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-AUTO-DEPM); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `automation × .cs` (3 files: 3 cite ADR-AUTO-DEPM);
  `automation × .yml` (1 file: 1 cites ADR-AUTO-DEPM); `docs × .md` (3 files: 2 cite ADR-AUTO-DEPM; 1 is the ADR file of ADR-AUTO-DEPM).
- **Tree** (the repository's files): 4 lit groups, `ModuleSystem` (3 files); `adr/auto` (2 files); `Docs` (1 file); `adr/*` (1 file). The
  ADR file `docs/adr/automation/controlling-module-dependencies.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × LOCAL`, because ADR-AUTO-DEPM: its
  ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
    kind: asset-description
    body_sha: "8073d5beee93"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# One commit, one verified, immutable package: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 1 named set (mauve), 1 code unit (slate), 1 gate, 2 results; 5 flow edges; 6 markers.
Sidebar: world-map grid (7 lit cells), tree (17 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/one-commit-one-immutable-package.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands of equal height, labelled `SOURCE`, `BUILD`, `BUNDLE` and `CODE ROOTS`. Five glyphs (one named set, one code unit, one gate and two
results) sit on one horizontal line through the middle of the bands, joined by four flow edges, and one more flow edge returns over the top
of the bands from the last glyph to the gate. Six markers number them, and a legend panel runs along the bottom. The eye lands first on the
grey rhombus (the gate) in the BUILD band, the only diamond on the line.

## Reading path

1. Marker 1, SOURCE band: the named set Selected modules.
2. Along the line to marker 2, BUILD band: the code unit One build.
3. Marker 3, BUILD band: the gate Integrity check.
4. Marker 4, BUNDLE band: the result Temporary build.
5. Marker 5, CODE ROOTS band: the result Installed · saved.
6. Marker 6, just below the returning edge above the bands, which runs from Installed · saved back down into the top of the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                              |
| --------------------- | ----- | ------------------------------------------------------------------ |
| named set             | 1     | Selected modules (SOURCE band)                                     |
| code unit             | 1     | One build (BUILD band, left)                                       |
| gate                  | 1     | Integrity check (BUILD band, right), a rhombus with a 3 px rim     |
| result                | 2     | Temporary build (BUNDLE band), Installed · saved (CODE ROOTS band) |

The named set is mauve and the code unit slate, both with white names; the gate is grey and the results are green.

## Edges

| Edge kind | Count | From → to                                                                                                                 |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Selected modules → One build → Integrity check → Temporary build → Installed · saved; Installed · saved → Integrity check |

The four edges on the line are short, straight and horizontal. The fifth leaves the top of Installed · saved, runs left above the bands in
one straight horizontal stretch, and drops into the top point of the gate; it is drawn as three straight segments with one arrowhead.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| mauve rounded box       | named set                         |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| grey arrow              | flow: feeds or runs the next step |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md),
[tree](adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md) and
[value-chain map](adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 7 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-AUTO-BUNDLE); `automation × .cs` (2 files: 2 cite ADR-AUTO-BUNDLE); `automation × .ps1` (36 files: 36 cite ADR-AUTO-BUNDLE,
  ADR-DSGN-RUNMODE); `automation × .yml` (3 files: 3 cite ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); `docs × .md` (5 files: 3 cite ADR-AUTO-BUNDLE,
  ADR-DSGN-RUNMODE; 2 are the ADR file of ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); `Root files × .ps1` (1 file: 1 is mapped through files.yml to
  ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); `Root files × other` (2 files: 2 are mapped through files.yml to ADR-DSGN-RUNMODE). 1 cell lit only by
  passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 17 lit groups, `Exporter` (10 files); `ModuleSystem` (8 files); `QualityGates` (5 files); `TypesSystem`
  (5 files); `Root files` (3 files); `Repository` (3 files); `.internal` (2 files); `Docs` (2 files); `Vendor` (2 files); `adr/auto` (2
  files); `adr/dsgn` (2 files); `.github` (1 file); `ConfigExtensions` (1 file); `Contracts` (1 file); `Globs` (1 file); `RootConfig` (1
  file); `adr/*` (1 file). The ADR files `docs/adr/automation/platform-bundle.md`, `docs/adr/design/run-modes.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × LOCAL`, because ADR-DSGN-RUNMODE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × BUILD`, because ADR-AUTO-BUNDLE: its ADR domain `automation`
  sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × RELEASE`, because
  ADR-AUTO-BUNDLE: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern
  (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE" beneath it on two lines.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-aspect-partition-integrity-runs-only-in-unit-tests-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "01d84cc2a780"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
      - docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.png
      - docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
      - docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
      - docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md
---

# Partition integrity runs only in unit tests: the diagram described

```text
A 1572 x 602 diagram, read left to right through four column bands.
Glyphs: 4 gates, 2 code units (slate), 2 ADR-only; 6 edges; 11 rule chips; 8 markers.
Sidebar: world-map grid (8 lit cells), tree (21 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/design/partition-integrity-runs-only-in-unit-tests.md).

## At a glance

A 1572 × 602 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
column bands, labelled FOLDER, VISIBILITY, ASPECT and SHA LOCK. It holds eight glyphs (four gates, two code units and two ADR-only) joined
by six edges, with eleven rule chips, eight markers and a legend panel along the bottom. The eye lands first on the wide code unit across
the top of FOLDER.

## Reading path

1. Marker 1, FOLDER, top: the wide code unit automation/&lt;Module&gt;/.
2. Down two edges to markers 2 and 3, FOLDER, bottom row: the gates Test-SourceConventions and Test-FolderConventions.
3. Right along the edge from the code unit into VISIBILITY: marker 4, the gate Assert-Unique…FunctionName, then down to marker 5, the code
   unit New-DynamicManifest.
4. ASPECT: marker 6, the gate VariantsConfig, with a dashed edge down to marker 7, the ADR-only gate AspectPartition.Validate.
5. Right along a dashed edge to marker 8, SHA LOCK: the ADR-only glyph aspect sha lock.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                           |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| gate                  | 4     | Test-SourceConventions and Test-FolderConventions (FOLDER, bottom row), Assert-Unique…FunctionName (VISIBILITY, top), VariantsConfig (ASPECT, top); grey rhombi with a 3 px rim |
| code unit             | 2     | automation/&lt;Module&gt;/ (FOLDER, top, band-wide), New-DynamicManifest (VISIBILITY, bottom)                                                                                   |
| ADR-only              | 2     | AspectPartition.Validate (ASPECT, bottom; a white dashed rhombus inside a dashed frame), aspect sha lock (SHA LOCK, top; a dashed white box)                                    |

Code units are slate with white names; the gates are grey with dark text.

## Edges

| Edge kind | Count | From → to                                                                                                                                                     |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | automation/&lt;Module&gt;/ → Test-SourceConventions, → Test-FolderConventions, → Assert-Unique…FunctionName; Assert-Unique…FunctionName → New-DynamicManifest |
| ADR-only  | 2     | VariantsConfig → AspectPartition.Validate, VariantsConfig → aspect sha lock                                                                                   |

Every edge is straight; three point down and three point right. None crosses another, and none carries a label.

**Rule chips.** Eleven small white pills beside their glyphs: O1 and M4 above-right of Test-SourceConventions; F6 above-right of
Test-FolderConventions; M4 right of Assert-Unique…FunctionName; M2 and M3 right of New-DynamicManifest; A2 and A3 below-right of
VariantsConfig; A5 right of AspectPartition.Validate; A4 and G9 right of aspect sha lock.

## Legend

A full-width panel at the bottom of the drawing area, in three rows, left to right:

| Swatch                  | Phrase                                                                                                             |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------ |
| grey rhombus, thick rim | gate                                                                                                               |
| slate rounded box       | code unit                                                                                                          |
| dashed white box        | ADR-only (a gate: dashed rhombus in a dashed frame)                                                                |
| thin arrow              | flow: reads, then runs                                                                                             |
| dashed arrow            | ADR-only (no code)                                                                                                 |
| dark disc `1`           | marker: a Walkthrough step                                                                                         |
| white chip `#3`         | rule chip: O ADR-PWSH-ONEFUNC · F ADR-REPO-FOLDERS · M ADR-PWSH-MANIFEST · A ADR-DSGN-ASPECT · G ADR-FLOW-CD-GLOBS |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md),
[tree](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md) and
[value-chain map](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-DSGN-ASPECT, ADR-FLOW-CD-GLOBS, ADR-PWSH-MANIFEST, ADR-PWSH-ONEFUNC, ADR-REPO-FOLDERS); the
explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 8 lit cells, `.claude × .md` (1 file: 1 cites ADR-PWSH-ONEFUNC);
  `.github × .yml` (1 file, mentions only: 1 cites ADR-FLOW-CD-GLOBS); `automation × .cs` (10 files: 10 cite ADR-DSGN-ASPECT,
  ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS); `automation × .ps1` (50 files: 50 cite ADR-DSGN-ASPECT, ADR-FLOW-CD-GLOBS, ADR-PWSH-MANIFEST,
  ADR-PWSH-ONEFUNC, ADR-REPO-FOLDERS); `automation × .yml` (7 files: 7 cite ADR-DSGN-ASPECT, ADR-FLOW-CD-GLOBS, ADR-PWSH-MANIFEST,
  ADR-PWSH-ONEFUNC, ADR-REPO-FOLDERS); `docs × .md` (14 files: 9 cite ADR-DSGN-ASPECT, ADR-FLOW-CD-GLOBS, ADR-PWSH-MANIFEST,
  ADR-PWSH-ONEFUNC, ADR-REPO-FOLDERS; 5 are the ADR file of ADR-DSGN-ASPECT, ADR-FLOW-CD-GLOBS, ADR-PWSH-MANIFEST, ADR-PWSH-ONEFUNC,
  ADR-REPO-FOLDERS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS); `Root files × .ps1` (1 file: 1 is mapped through files.yml to
  ADR-PWSH-MANIFEST). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 21 lit groups, `Globs` (40 files); `QualityGates` (6 files); `pipelines` (6 files);
  `Az.DevOps.BuildValidation` (5 files); `Docs` (4 files); `Variants` (4 files); `Languages` (3 files); `adr/pwsh` (3 files); `docs` (3
  files); `adr/*` (2 files); `adr/dsgn` (2 files); `adr/flow` (2 files); `adr/repo` (2 files); `Root files` (1 file); `.claude` (1 file);
  `.github` (1 file); `.internal` (1 file); `Contracts` (1 file); `Exporter` (1 file); `ModuleSystem` (1 file); `Overlay` (1 file). The ADR
  files `docs/adr/design/module-aspects.md`, `docs/adr/flow/durable-sha-globs.md`, `docs/adr/pwsh/dynamic-module-manifests.md`,
  `docs/adr/pwsh/one-function-per-file.md`, `docs/adr/repository/conventional-folders.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 3 lit cells: `DSGN × LOCAL`, because ADR-DSGN-ASPECT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); ADR-FLOW-CD-GLOBS: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own
  value-chain concern (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-ASPECT: its ADR domain `design` sits on the DSGN row
  (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × LOCAL`, because ADR-PWSH-MANIFEST:
  its ADR domain `pwsh` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  ADR-PWSH-ONEFUNC: its ADR domain `pwsh` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern
  (ADR-DSGN-TRACK#15); ADR-REPO-FOLDERS: its ADR domain `repository` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR
  domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV. Beneath it, three tight lines: "Supports ADR-DSGN-ASPECT", "ADR-PWSH-MANIFEST · ADR-PWSH-ONEFUNC" and
  "ADR-REPO-FOLDERS · ADR-FLOW-CD-GLOBS".
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.

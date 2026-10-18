---
catzc:
  immutable:
    with_body_sha: "4a86c7e4bb19"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
    source: docs/explanation/.assets/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A track ships through a deployable-unit, and each unit has one pipeline: the tree minimap

```text
Which files cite ADR-DSGN-TRACK: every file of the world map is a tile, grouped by top-level folder.
120 files lit in 13 groups.
```

![The tree minimap of A track ships through a deployable-unit, and each unit has one pipeline](adr-dsgn-track--one-unit-one-pipeline--meta.tree.png)

This is the tree minimap in the sidebar of the meta diagram of [A track ships through a deployable-unit, and each unit has one
pipeline][121], which explains [ADR-DSGN-TRACK][1]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 120 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 36 lit files
- Maps (automation/Catzc.Base.Maps): 28 lit files
- .claude: 13 lit files
- Variants (automation/Catzc.Base.Variants): 12 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 10 lit files
- Languages (automation/Catzc.Base.Languages): 7 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- Git (automation/Catzc.Base.Git): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Globs (automation/Catzc.Base.Globs): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 36 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/repository-conventions.md][2], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 39 (text), line 45 (text), line 45 (text), line 48 (text), line 48 (text), line 50 (text), line 50
  (text), line 50 (text), line 51 (text), line 52 (text) and line 54 (text).
- [docs/how-to/automation/sort-an-import.md][3], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text) and line 23 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][4], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 40 (text) and line 41 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][5], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 36 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][6], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 21 (text), line 55 (text), line 58 (text) and line 70 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][8], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text) and line 126 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps.md][13], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 15 (text), line 96 (text), line 98 (text) and line 110 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][14], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 57 (text), line 63 (text), line 65 (text) and line 70 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][22], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][23], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (text), line 36 (text), line 37 (text) and line 41 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][24], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][25], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][26], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 17 (text), line 32 (text), line 33 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][27], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][28], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][29], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 39 (text), line 40 (text), line 43 (text) and line 86 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][30], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][31], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][32], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 17 (text), line 33 (text), line 34 (text) and line 35 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][33], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 94 (text), line 97 (text) and line 99 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][34], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][35], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 52 (text), line 55 (text) and line 57 (text).
- [docs/references/note-file-kind.md][36], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 37 (text), line 51 (text) and line 54 (text).
- [docs/references/pipelines/ci-automation.yaml.md][37], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 32 (text).

### Maps (automation/Catzc.Base.Maps, 28 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][38], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (header), line 30 (header), line 31 (header), line 33 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][39], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 21 (header), line 30 (header), line 31 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][40], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (header), line 27 (header), line 29 (header) and line 31 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][41], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 23 (header), line 30 (header), line 31 (header) and line 43 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][42], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (header), line 33 (header) and line 50 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][43], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 23 (header), line 37 (header), line 39 (header), line 42 (header), line 46 (header), line 77 (text), line 78 (text), line
  88 (text), line 91 (text) and line 108 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][44], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 22 (header), line 34 (header), line 37 (header), line 41 (header), line 46 (header), line 47 (header), line 90 (text), line 109
  (text), line 126 (text), line 130 (text) and line 131 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][45], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 21 (header), line 29 (header) and line 30 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][46], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 42 (text), line 48 (text) and line 67 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][47], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 21 (header), line 42 (text), line 61 (text) and line 61 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][48], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (header) and line 112 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][49], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 97 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][50], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 21 (header), line 73 (text), line 73 (body comment), line 77 (text), line 78 (text), line 79 (text), line 80
  (text), line 84 (text), line 87 (text), line 104 (text), line 104 (body comment) and line 104 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][51], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 21 (header), line 81 (text), line 85 (text), line 88 (text), line 92 (text), line 93 (text), line 97 (text), line
  106 (text), line 107 (text), line 111 (text), line 115 (text), line 116 (text), line 135 (text), line 135 (body comment) and line 135
  (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][52], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 40 (text), line 47 (text), line 53 (text), line 70 (text) and line 70
  (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][53], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 42 (text), line 51 (text), line 56 (text) and line 64 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][54], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header), line 91 (text), line 135 (text) and line 149 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][55], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][56], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 22 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][57], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 21 (text), line 33 (body comment) and line 36 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][58], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][59], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][60], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][61], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][62], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][63], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][64], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][65], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (text).

### .claude (13 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][66], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28
  (text), line 51 (text), line 58 (text), line 77 (text), line 85 (text), line 148 (text), line 149 (text), line 153 (text), line 153
  (text), line 155 (text), line 161 (text), line 163 (text) and line 208 (text).
- [.claude/plans/decisions-2026-10-18.md][67], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25
  (text), line 38 (text), line 55 (text) and line 55 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][68], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 32 (text) and line 74 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][69], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 32 (text), line 108 (text), line 109 (text), line 222 (text), line 466 (text), line 507 (text), line 532 (text), line 612
  (text), line 814 (text), line 841 (text), line 945 (text) and line 950 (text).
- [.claude/plans/plan-module-kinds-tracks.md][70], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 36 (text), line 71 (text), line 75 (text), line 101 (text), line 107 (text), line 140 (text), line 160 (text), line 161 (text), line
  182 (text), line 202 (text), line 250 (text), line 363 (text), line 372 (text), line 520 (text), line 534 (text), line 565 (text), line
  570 (text), line 616 (text), line 632 (text), line 632 (text), line 658 (text), line 660 (text), line 662 (text), line 672 (text), line
  680 (text), line 681 (text), line 691 (text), line 710 (text), line 820 (text), line 832 (text), line 837 (text), line 839 (text), line
  868 (text), line 875 (text), line 897 (text), line 936 (text), line 955 (text), line 964 (text), line 1005 (text) and line 1060 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][71], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 24 (text), line 54 (text) and line 214 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][72], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 37 (text), line 48 (text) and line 73 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][73], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 54 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][74], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 37 (text), line 49 (text), line 50 (text), line 89 (text) and line 98 (text).
- [.claude/plans/prompt-module-model-2-implement.md][75], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 26 (text), line 44 (text) and line 56 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][76], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 45 (text).
- [.claude/plans/task-file-head-leftovers.md][77], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 31 (text), line 44 (text) and line 87 (text).
- [.claude/plans/task-import-landing-zone.md][78], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 33 (text), line 54 (text) and line 61 (text).

### Variants (automation/Catzc.Base.Variants, 12 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-PathModule.ps1][79], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][80], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 20 (header), line 24 (header), line 27 (header) and line 31 (header).
- [automation/Catzc.Base.Variants/configs/track-types.yml][81], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 59 (text).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][82], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 19 (header), line 23 (text) and line 74 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][83], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (header) and line 98 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][85], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][86], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][87], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/PathModule.cs][88], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 19 (text).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][89], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][90], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 23 (text) and line 266 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 10 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/source-conventions.yml][91], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][92], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 316 (text) and line 319 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][93], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header) and line 34 (header).
- [automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1][94], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][95], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1][96], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1][97], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][98], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][99], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][100], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 23 (text).

### Languages (automation/Catzc.Base.Languages, 7 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][101], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Languages/Get-PathFileType.ps1][102], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][103], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][104], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 134 (text), line 146 (text) and line 184 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][105], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][106], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][107], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text).

### Docs (automation/Catzc.Base.Docs, 5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][108], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 93 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][109], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (header), line 134 (text) and line 134 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][110], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][111], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 22 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][112], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 27 (text) and line 46 (body comment).

### Git (automation/Catzc.Base.Git, 2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][113], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (header) and line 28 (header).
- [automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][114], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line 23 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][115], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161
  (text), line 178 (text), line 210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329
  (text), line 331 (text), line 346 (text), line 386 (text), line 400 (text), line 409 (text), line 423 (text), line 436 (text), line 470
  (text) and line 482 (text).
- [docs/adr/index.md][116], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][117], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50
  (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][118], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header) and line 66 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][119], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 81 (text), line 89 (text), line 99 (text), line 108 (text), line 114 (text), line 210 (text), line 220
  (text), line 231 (text), line 254 (text), line 267 (text), line 281 (text), line 296 (text), line 309 (text), line 321 (text), line 334
  (text), line 336 (text) and line 348 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][120], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 93 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 134 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 134 (body comment), `automation/Catzc.Base.Docs/types/AdrDomain.cs`
  line 21 (text), `automation/Catzc.Base.Docs/types/AdrRuleSet.cs` line 22 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 27
  (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 46 (body comment),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 24 (header),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 28 (header),
  `automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text), `automation/Catzc.Base.Languages/Get-FileLanguage.ps1`
  line 20 (header), `automation/Catzc.Base.Languages/Get-FileLanguage.ps1` line 25 (header),
  `automation/Catzc.Base.Languages/Get-PathFileType.ps1` line 20 (header), `automation/Catzc.Base.Languages/Get-PathFileType.ps1` line 27
  (header), `automation/Catzc.Base.Languages/configs/glossary.yml` line 24 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 134 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 146 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 184 (text),
  `automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 23 (text), `automation/Catzc.Base.Languages/types/FileLanguage.cs`
  line 22 (text), `automation/Catzc.Base.Languages/types/LanguagesConfig.cs` line 24 (text),
  `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 20 (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 30
  (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 31 (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line
  33 (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 49 (header),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 21 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line
  30 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 31 (header),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 42 (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 20
  (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 27 (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 29
  (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 31 (header), `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 23
  (header), `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 30 (header), `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 31 (header),
  `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 43 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 33 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 50
  (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 23 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line
  37 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 39 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1`
  line 42 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 46 (header),
  `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 77 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 78 (text),
  `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 88 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 91 (text),
  `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 108 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 22 (header),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 34 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 37 (header),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 41 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 46 (header),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 47 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 90 (text),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 109 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 126 (text),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 130 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 131 (text),
  `automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1` line 29 (header),
  `automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1` line 30 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 48 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 67 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 61 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 61 (body comment),
  `automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 20 (header), `automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line
  112 (text), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 97 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 73 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 73 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 79 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 84 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 104 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 104 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 104 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 21 (header), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 81 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 85 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 88 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  92 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 97 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  106 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 107 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 115 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 116 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 135 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 135 (body comment), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 135 (body comment),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 40 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 47 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 53 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 70 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 70 (body comment),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 64 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 91 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 135 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 149 (text), `automation/Catzc.Base.Maps/types/MapCell.cs` line
  21 (text), `automation/Catzc.Base.Maps/types/MapsLabels.cs` line 22 (text), `automation/Catzc.Base.Maps/types/ValueChainCell.cs` line 21
  (text), `automation/Catzc.Base.Maps/types/ValueChainCell.cs` line 33 (body comment), `automation/Catzc.Base.Maps/types/ValueChainCell.cs`
  line 36 (body comment), `automation/Catzc.Base.Maps/types/ValueChainHighlight.cs` line 21 (text),
  `automation/Catzc.Base.Maps/types/ValueChainMap.cs` line 21 (text), `automation/Catzc.Base.Maps/types/ValueChainReason.cs` line 21 (text),
  `automation/Catzc.Base.Maps/types/WorldMap.cs` line 20 (text), `automation/Catzc.Base.Maps/types/WorldMapBuilder.cs` line 22 (text),
  `automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs` line 21 (text), `automation/Catzc.Base.Maps/types/WorldMapHighlight.cs` line 21
  (text), `automation/Catzc.Base.Maps/types/WorldMapPdf.cs` line 21 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  24 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 81 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 89 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  99 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 108 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 114 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  210 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 220 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 231 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  254 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 267 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 281 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  296 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 309 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 321 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  334 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 336 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 348 (text),
  `automation/Catzc.Base.QualityGates/configs/source-conventions.yml` line 26 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 316 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml`
  line 319 (text), `automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1` line 34 (header),
  `automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1` line 32 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Variants/Get-PathModule.ps1` line 20 (header), `automation/Catzc.Base.Variants/Get-PathModule.ps1` line 25
  (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 20 (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 24
  (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 27 (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 31
  (header), `automation/Catzc.Base.Variants/configs/track-types.yml` line 59 (text),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 74 (text), `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 98 (text),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Variants/types/ModulePlace.cs` line 20 (text), `automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs` line 19
  (text), `automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 21 (text), `automation/Catzc.Base.Variants/types/PathModule.cs`
  line 19 (text), `automation/Catzc.Base.Variants/types/VariantTrack.cs` line 21 (text),
  `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line 23 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  266 (text).

## Keywords

- [world map][122]
- [track][123]
- [file language][124]
- [cell][125]
- [lit cell][126]
- [.claude][127]: a track
- [automation][127]: a track
- [docs][127]: a track
- [pipelines][127]: a track
- [csharp][128]: a file language
- [markdown][128]: a file language
- [pipeline-yaml][128]: a file language
- [powershell][128]: a file language
- [yaml][128]: a file language

Terms the cited ADRs define:

- [cell][125], defined by [ADR-DSGN-TRACK#10][129]
- [deployable-unit][130], defined by [ADR-DSGN-TRACK#5][131]
- [file language][124], defined by [ADR-DSGN-TRACK#6][132]
- [import][133], defined by [ADR-DSGN-TRACK#17][134]
- [landing address][135], defined by [ADR-DSGN-TRACK#17][134]
- [lit cell][126], defined by [ADR-DSGN-TRACK#12][136]
- [place][137], defined by [ADR-DSGN-TRACK#1][138]
- [root file][139], defined by [ADR-DSGN-TRACK#7][140]
- [sorting][141], defined by [ADR-DSGN-TRACK#17][134]
- [stack violation][142], defined by [ADR-DSGN-TRACK#11][143]
- [track][123], defined by [ADR-DSGN-TRACK#1][138]
- [unlisted file][144], defined by [ADR-DSGN-TRACK#8][145]
- [unordered track][146], defined by [ADR-DSGN-TRACK#17][134]
- [value-chain concern][147], defined by [ADR-DSGN-TRACK#15][148]
- [value-chain map][149], defined by [ADR-DSGN-TRACK#16][150]
- [value-chain stack][151], defined by [ADR-DSGN-TRACK#14][152]
- [verification track][153], defined by [ADR-DSGN-TRACK#2][154]
- [world map][122], defined by [ADR-DSGN-TRACK#9][155]

[1]: ../../../adr/design/tracks.md
[2]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[3]: ../../../how-to/automation/sort-an-import.md
[4]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[5]: ../../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[6]: ../../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[7]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[8]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[9]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[10]: ../../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[11]: ../../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[12]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[13]: ../../../references/automation/catzc-base-maps.md
[14]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[15]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[16]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[17]: ../../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[18]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[19]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[20]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[21]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[22]: ../../../references/automation/catzc-base-maps/types/MapCell.cs.md
[23]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[24]: ../../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[25]: ../../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[26]: ../../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[27]: ../../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[28]: ../../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[29]: ../../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[30]: ../../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[31]: ../../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[32]: ../../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[33]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[34]: ../../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[35]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[36]: ../../../references/note-file-kind.md
[37]: ../../../references/pipelines/ci-automation.yaml.md
[38]: ../../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[39]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[40]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[41]: ../../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[42]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[43]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[44]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[45]: ../../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[46]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[47]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[48]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[49]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[50]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[51]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[52]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[53]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[54]: ../../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[55]: ../../../../automation/Catzc.Base.Maps/types/MapCell.cs
[56]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[57]: ../../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[58]: ../../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[59]: ../../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[60]: ../../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[61]: ../../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[62]: ../../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[63]: ../../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[64]: ../../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[65]: ../../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[66]: ../../../../.claude/plans/decisions-2026-10-16.md
[67]: ../../../../.claude/plans/decisions-2026-10-18.md
[68]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[69]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[70]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[71]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[72]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[73]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[74]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[75]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[76]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[77]: ../../../../.claude/plans/task-file-head-leftovers.md
[78]: ../../../../.claude/plans/task-import-landing-zone.md
[79]: ../../../../automation/Catzc.Base.Variants/Get-PathModule.ps1
[80]: ../../../../automation/Catzc.Base.Variants/Get-Track.ps1
[81]: ../../../../automation/Catzc.Base.Variants/configs/track-types.yml
[82]: ../../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[83]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[84]: ../../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[85]: ../../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[86]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[87]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[88]: ../../../../automation/Catzc.Base.Variants/types/PathModule.cs
[89]: ../../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[90]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[91]: ../../../../automation/Catzc.Base.QualityGates/configs/source-conventions.yml
[92]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[93]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[94]: ../../../../automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1
[95]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[96]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1
[97]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
[98]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[99]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[100]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[101]: ../../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[102]: ../../../../automation/Catzc.Base.Languages/Get-PathFileType.ps1
[103]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[104]: ../../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[105]: ../../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[106]: ../../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[107]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[108]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[109]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[110]: ../../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[111]: ../../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[112]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[113]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[114]: ../../../../automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[115]: ../../../adr/glossary.md
[116]: ../../../adr/index.md
[117]: ../../../adr/design/dora-explains.md
[118]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[119]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[120]: ../../../../pipelines/ci-automation.yaml
[121]: ../../design/one-unit-one-pipeline.md
[122]: ../../../adr/glossary.md#world-map
[123]: ../../../adr/glossary.md#track
[124]: ../../../adr/glossary.md#file-language
[125]: ../../../adr/glossary.md#cell
[126]: ../../../adr/glossary.md#lit-cell
[127]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[128]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[129]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[130]: ../../../adr/glossary.md#deployable-unit
[131]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[132]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[133]: ../../../adr/glossary.md#import
[134]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[135]: ../../../adr/glossary.md#landing-address
[136]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[137]: ../../../adr/glossary.md#place
[138]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[139]: ../../../adr/glossary.md#root-file
[140]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[141]: ../../../adr/glossary.md#sorting
[142]: ../../../adr/glossary.md#stack-violation
[143]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[144]: ../../../adr/glossary.md#unlisted-file
[145]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[146]: ../../../adr/glossary.md#unordered-track
[147]: ../../../adr/glossary.md#value-chain-concern
[148]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[149]: ../../../adr/glossary.md#value-chain-map
[150]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[151]: ../../../adr/glossary.md#value-chain-stack
[152]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[153]: ../../../adr/glossary.md#verification-track
[154]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[155]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9

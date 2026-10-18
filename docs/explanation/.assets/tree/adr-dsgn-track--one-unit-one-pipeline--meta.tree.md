---
catzc:
  immutable:
    with_body_sha: "65d942775174"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
    source: docs/explanation/.assets/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A track ships through a deployable-unit, and each unit has one pipeline: the tree minimap

```text
Which files cite ADR-DSGN-TRACK: every file of the world map is a tile, grouped by top-level folder.
109 files lit in 13 groups.
```

![The tree minimap of A track ships through a deployable-unit, and each unit has one pipeline](adr-dsgn-track--one-unit-one-pipeline--meta.tree.png)

This is the tree minimap in the sidebar of the meta diagram of [A track ships through a deployable-unit, and each unit has one
pipeline][110], which explains [ADR-DSGN-TRACK][1]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 109 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 55 lit files
- .claude: 14 lit files
- Maps (pwsh/Catzc.Base.Maps): 12 lit files
- Variants (pwsh/Catzc.Base.Variants): 9 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 5 lit files
- Docs (pwsh/Catzc.Base.Docs): 3 lit files
- Languages (pwsh/Catzc.Base.Languages): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Git (pwsh/Catzc.Base.Git): 1 lit file
- Globs (pwsh/Catzc.Base.Globs): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 55 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][2], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 23 (text), line 23 (text), line 26 (text), line 26 (text), line 28 (text), line 28 (text), line 28
  (text), line 29 (text), line 30 (text) and line 32 (text).
- [docs/how-to/automation/sort-an-import.md][3], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4
  (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][4], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 21 (text) and line 22 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md][5], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md][6], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 32 (text), line 35 (text) and line 47 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][9], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 105 (text).
- [docs/references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps.md][16], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 66 (text), line 68 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md][17], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (text), line 21 (text), line 23 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 17 (text) and line 43 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md][19], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 14 (text), line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md][20], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 16 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md][22], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (text), line 22 (text), line 25 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md][23], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 21 (text), line 25 (text), line 28 (text) and line 29 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][24], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 36 (text), line 42 (text), line 44 (text) and line 49 (text).
- [docs/references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][30], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][32], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md][33], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][34], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md][35], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md][36], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md][37], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text), line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md][38], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md][39], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md][40], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 19 (text), line 22 (text) and line 65 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md][41], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md][42], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md][43], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 14 (text), line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][46], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md][47], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md][49], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][50], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 14 (text), line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][51], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 75 (text), line 78 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][52], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][53], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line 35 (text) and line 37 (text).
- [docs/references/pwsh/claude-drawio/minimaps/highlights.ps1.md][54], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 51 (text).
- [docs/references/note-file-kind.md][55], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 34 (text) and line 37 (text).
- [docs/references/pipelines/ci-automation.yaml.md][56], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 13 (text).

### .claude (14 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][57], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text).
- [.claude/plans/decisions-2026-10-16.md][58], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 26 (text), line 45 (text), line 53 (text), line 116 (text), line 117 (text), line 121 (text), line 121 (text), line 123
  (text), line 129 (text), line 131 (text) and line 176 (text).
- [.claude/plans/decisions-2026-10-18.md][59], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 33 (text) and line 33 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][60], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 51 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][61], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 79 (text), line 80 (text), line 193 (text), line 437 (text), line 478 (text), line 503 (text), line 583 (text), line 785
  (text), line 812 (text), line 916 (text) and line 921 (text).
- [.claude/plans/plan-module-kinds-tracks.md][62], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 42 (text), line 46 (text), line 72 (text), line 78 (text), line 119 (text), line 120 (text), line 141 (text), line 142 (text), line
  163 (text), line 183 (text), line 231 (text), line 344 (text), line 353 (text), line 501 (text), line 515 (text), line 546 (text), line
  551 (text), line 597 (text), line 613 (text), line 613 (text), line 639 (text), line 641 (text), line 643 (text), line 653 (text), line
  661 (text), line 662 (text), line 672 (text), line 691 (text), line 801 (text), line 813 (text), line 818 (text), line 820 (text), line
  849 (text), line 856 (text), line 878 (text), line 917 (text), line 936 (text), line 945 (text), line 986 (text) and line 1041 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][63], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 30 (text), line 85 (text) and line 211 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][64], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 28 (text) and line 53 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][65], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 34 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][66], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 17 (text), line 29 (text), line 30 (text), line 69 (text) and line 78 (text).
- [.claude/plans/prompt-module-model-2-implement.md][67], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 9 (text), line 27 (text) and line 39 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][68], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 28 (text).
- [.claude/plans/task-file-head-leftovers.md][69], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 27 (text) and line 70 (text).
- [.claude/plans/task-import-landing-zone.md][70], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 35 (text) and line 42 (text).

### Maps (pwsh/Catzc.Base.Maps, 12 lit files)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1][71], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 15 (text), line 16 (text), line 26 (text), line 29 (text) and line 46 (text).
- [pwsh/Catzc.Base.Maps/Test-WorldMap.ps1][72], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 26 (text), line 45 (text), line 62 (text), line 66 (text) and line 67 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][73], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 23 (text) and line 42 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][74], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 17 (text), line 36 (text) and line 36 (body comment).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][75], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 89 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][76], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][77], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 49 (text), line 49 (body comment), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 60
  (text), line 63 (text), line 80 (text), line 80 (body comment) and line 80 (body comment).
- [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][78], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 57 (text), line 61 (text), line 64 (text), line 68 (text), line 69 (text), line 73 (text), line 82 (text), line 83
  (text), line 87 (text), line 91 (text), line 92 (text), line 111 (text), line 111 (body comment) and line 111 (body comment).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][79], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 22 (text), line 28 (text), line 45 (text) and line 45 (body comment).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][80], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 26 (text), line 31 (text) and line 39 (text).
- [pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][81], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 69 (text), line 113 (text) and line 127 (text).
- [pwsh/Catzc.Base.Maps/types/ValueChainCell.cs][82], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 9 (body comment) and line 12 (body comment) (a passing mention only).

### Variants (pwsh/Catzc.Base.Variants, 9 lit files)

The group holds the files of pwsh/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Variants/configs/track-types.yml][83], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 42 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][84], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 1 (text) and line 52 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][85], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 71 (text).
- [pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Variants/types/ModulePlace.cs][87], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs][88], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 5 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs][89], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 10 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/PathModule.cs][90], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 3 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/VariantsConfig.cs][91], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 268 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 5 lit files)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml][92], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 7 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][93], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 297 (text) and line 300 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][94], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][95], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][96], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).

### Docs (pwsh/Catzc.Base.Docs, 3 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][97], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 74 (text).
- [pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][98], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 108 (text) and line 108 (body comment).
- [pwsh/Catzc.Base.Docs/types/AdrsConfig.cs][99], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 15 (body comment) (a passing mention only).

### Languages (pwsh/Catzc.Base.Languages, 3 lit files)

The group holds the files of pwsh/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Languages/configs/glossary.yml][100], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 5 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][101], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 111 (text), line 123 (text) and line 161 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][102], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][103], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161
  (text), line 178 (text), line 210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329
  (text), line 331 (text), line 346 (text), line 386 (text), line 400 (text), line 409 (text), line 423 (text), line 436 (text), line 470
  (text) and line 482 (text).
- [docs/adr/index.md][104], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][105], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11
  (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### Git (pwsh/Catzc.Base.Git, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][106], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).

### Globs (pwsh/Catzc.Base.Globs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][107], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 41 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][108], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 5 (text), line 62 (text), line 70 (text), line 79 (text), line 88 (text), line 94 (text), line 190 (text), line 200
  (text), line 211 (text), line 234 (text), line 247 (text), line 261 (text), line 276 (text), line 289 (text), line 301 (text), line 314
  (text), line 316 (text) and line 328 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][109], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (body comment), `pwsh/Catzc.Base.Docs/types/AdrsConfig.cs`
  line 15 (body comment), `pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 41 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml`
  line 5 (text), `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 111 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 123 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 161 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line
  15 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 16 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 26
  (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 29 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 46
  (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 26 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 62 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 66 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 67 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line
  17 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 42 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 89 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 74 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 54 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 55 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 56 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 60 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 63 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 57 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  61 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 64 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 68 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  69 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 73 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 82 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  83 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 87 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 91 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  92 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 15 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 22 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (body comment),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 26 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 39 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 69 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 113 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 127 (text), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs`
  line 9 (body comment), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs` line 12 (body comment),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 5 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 62
  (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 70 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 79 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  88 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 94 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 190 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  200 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 211 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 234 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  247 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 261 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 276 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  289 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 301 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 314 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  316 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 328 (text),
  `pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml` line 7 (text),
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 297 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`
  line 300 (text), `pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Variants/configs/track-types.yml` line 42 (text), `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1`
  line 1 (text), `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 52 (text),
  `pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 71 (text),
  `pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Variants/types/ModulePlace.cs` line 6 (body comment), `pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs`
  line 5 (body comment), `pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 10 (body comment),
  `pwsh/Catzc.Base.Variants/types/PathModule.cs` line 3 (body comment) and `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs`
  line 268 (text).

## Keywords

- [world map][111]
- [track][112]
- [file language][113]
- [cell][114]
- [lit cell][115]
- [.claude][116]: a track
- [automation][116]: a track
- [docs][116]: a track
- [pipelines][116]: a track
- [csharp][117]: a file language
- [markdown][117]: a file language
- [pipeline-yaml][117]: a file language
- [powershell][117]: a file language
- [yaml][117]: a file language

Terms the cited ADRs define:

- [cell][114], defined by [ADR-DSGN-TRACK#10][118]
- [deployable-unit][119], defined by [ADR-DSGN-TRACK#5][120]
- [file language][113], defined by [ADR-DSGN-TRACK#6][121]
- [import][122], defined by [ADR-DSGN-TRACK#17][123]
- [landing address][124], defined by [ADR-DSGN-TRACK#17][123]
- [lit cell][115], defined by [ADR-DSGN-TRACK#12][125]
- [place][126], defined by [ADR-DSGN-TRACK#1][127]
- [root file][128], defined by [ADR-DSGN-TRACK#7][129]
- [sorting][130], defined by [ADR-DSGN-TRACK#17][123]
- [stack violation][131], defined by [ADR-DSGN-TRACK#11][132]
- [track][112], defined by [ADR-DSGN-TRACK#1][127]
- [unlisted file][133], defined by [ADR-DSGN-TRACK#8][134]
- [unordered track][135], defined by [ADR-DSGN-TRACK#17][123]
- [value-chain concern][136], defined by [ADR-DSGN-TRACK#15][137]
- [value-chain map][138], defined by [ADR-DSGN-TRACK#16][139]
- [value-chain stack][140], defined by [ADR-DSGN-TRACK#14][141]
- [verification track][142], defined by [ADR-DSGN-TRACK#2][143]
- [world map][111], defined by [ADR-DSGN-TRACK#9][144]

[1]: ../../../adr/design/tracks.md
[2]: ../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[3]: ../../../how-to/automation/sort-an-import.md
[4]: ../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[5]: ../../../references/pwsh/catzc-base-docs/types/AdrDomain.cs.md
[6]: ../../../references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md
[7]: ../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[8]: ../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[9]: ../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[10]: ../../../references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md
[11]: ../../../references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md
[12]: ../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[13]: ../../../references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[14]: ../../../references/pwsh/catzc-base-languages/types/FileLanguage.cs.md
[15]: ../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[16]: ../../../references/pwsh/catzc-base-maps.md
[17]: ../../../references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md
[18]: ../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[19]: ../../../references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md
[20]: ../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
[21]: ../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[22]: ../../../references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
[23]: ../../../references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
[24]: ../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[25]: ../../../references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
[26]: ../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[27]: ../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[28]: ../../../references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[29]: ../../../references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[30]: ../../../references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[31]: ../../../references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[32]: ../../../references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[33]: ../../../references/pwsh/catzc-base-maps/types/MapCell.cs.md
[34]: ../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[35]: ../../../references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md
[36]: ../../../references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md
[37]: ../../../references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md
[38]: ../../../references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md
[39]: ../../../references/pwsh/catzc-base-maps/types/WorldMap.cs.md
[40]: ../../../references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
[41]: ../../../references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md
[42]: ../../../references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
[43]: ../../../references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md
[44]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[45]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md
[46]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[47]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md
[48]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md
[49]: ../../../references/pwsh/catzc-base-variants/Get-PathModule.ps1.md
[50]: ../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[51]: ../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[52]: ../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[53]: ../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[54]: ../../../references/pwsh/claude-drawio/minimaps/highlights.ps1.md
[55]: ../../../references/note-file-kind.md
[56]: ../../../references/pipelines/ci-automation.yaml.md
[57]: ../../../../.claude/CLAUDE.md
[58]: ../../../../.claude/plans/decisions-2026-10-16.md
[59]: ../../../../.claude/plans/decisions-2026-10-18.md
[60]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[61]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[62]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[63]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[64]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[65]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[66]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[67]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[68]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[69]: ../../../../.claude/plans/task-file-head-leftovers.md
[70]: ../../../../.claude/plans/task-import-landing-zone.md
[71]: ../../../../pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
[72]: ../../../../pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
[73]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[74]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[75]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[76]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[77]: ../../../../pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[78]: ../../../../pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[79]: ../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[80]: ../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[81]: ../../../../pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[82]: ../../../../pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
[83]: ../../../../pwsh/Catzc.Base.Variants/configs/track-types.yml
[84]: ../../../../pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[85]: ../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[86]: ../../../../pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[87]: ../../../../pwsh/Catzc.Base.Variants/types/ModulePlace.cs
[88]: ../../../../pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[89]: ../../../../pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[90]: ../../../../pwsh/Catzc.Base.Variants/types/PathModule.cs
[91]: ../../../../pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
[92]: ../../../../pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
[93]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[94]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[95]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[96]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[97]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[98]: ../../../../pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[99]: ../../../../pwsh/Catzc.Base.Docs/types/AdrsConfig.cs
[100]: ../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[101]: ../../../../pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[102]: ../../../../pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[103]: ../../../adr/glossary.md
[104]: ../../../adr/index.md
[105]: ../../../adr/design/dora-explains.md
[106]: ../../../../pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[107]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[108]: ../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[109]: ../../../../pipelines/ci-automation.yaml
[110]: ../../design/one-unit-one-pipeline.md
[111]: ../../../adr/glossary.md#world-map
[112]: ../../../adr/glossary.md#track
[113]: ../../../adr/glossary.md#file-language
[114]: ../../../adr/glossary.md#cell
[115]: ../../../adr/glossary.md#lit-cell
[116]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[117]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[118]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[119]: ../../../adr/glossary.md#deployable-unit
[120]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[121]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[122]: ../../../adr/glossary.md#import
[123]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[124]: ../../../adr/glossary.md#landing-address
[125]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[126]: ../../../adr/glossary.md#place
[127]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[128]: ../../../adr/glossary.md#root-file
[129]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[130]: ../../../adr/glossary.md#sorting
[131]: ../../../adr/glossary.md#stack-violation
[132]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[133]: ../../../adr/glossary.md#unlisted-file
[134]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[135]: ../../../adr/glossary.md#unordered-track
[136]: ../../../adr/glossary.md#value-chain-concern
[137]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[138]: ../../../adr/glossary.md#value-chain-map
[139]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[140]: ../../../adr/glossary.md#value-chain-stack
[141]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[142]: ../../../adr/glossary.md#verification-track
[143]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[144]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9

# docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md

`Tree minimap: adr-dsgn-track--one-unit-one-pipeline--meta`

![Tree minimap of adr-dsgn-track--one-unit-one-pipeline--meta](adr-dsgn-track--one-unit-one-pipeline--meta.tree.png)

The tree minimap of the slide `adr-dsgn-track--one-unit-one-pipeline--meta` (meta lens). The slide supports [ADR-DSGN-TRACK][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 111 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 34 lit files
- Maps (automation/Catzc.Base.Maps): 28 lit files
- Variants (automation/Catzc.Base.Variants): 11 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 8 lit files
- .claude: 7 lit files
- Languages (automation/Catzc.Base.Languages): 7 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- .unordered: 4 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Globs (automation/Catzc.Base.Globs): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 34 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/repository-conventions.md][2], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 38 (text), line 44 (text), line 44 (text), line 47 (text), line 47 (text), line 49 (text), line 49
  (text), line 49 (text), line 50 (text), line 51 (text) and line 53 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][3], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 39 (text) and line 40 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][4], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 35 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][5], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][6], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (text), line 53 (text), line 56 (text) and line 68 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][7], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text) and line 125 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps.md][12], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 15 (text), line 96 (text), line 98 (text) and line 110 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][13], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 56 (text), line 62 (text), line 64 (text) and line 69 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 31 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][21], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 31 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][22], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 35 (text), line 36 (text) and line 40 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][23], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][24], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][25], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 31 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][26], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][27], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][28], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 37 (text), line 38 (text) and line 41 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][29], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][30], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][31], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][32], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 93 (text), line 96 (text) and line 98 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][33], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][34], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 51 (text), line 54 (text) and line 56 (text).
- [docs/references/pipelines/ci-automation.yaml.md][35], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 16 (text) and line 31 (text).

### Maps (automation/Catzc.Base.Maps, 28 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][36], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (header), line 29 (header), line 30 (header), line 32 (header) and line 48 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][37], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (header), line 29 (header), line 30 (header) and line 41 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][38], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (header), line 26 (header), line 28 (header) and line 30 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][39], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 22 (header), line 29 (header), line 30 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][40], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (header), line 32 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][41], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 36 (header), line 38 (header), line 41 (header), line 45 (header), line 76 (text), line 77 (text), line
  87 (text), line 90 (text) and line 107 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][42], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 21 (header), line 33 (header), line 36 (header), line 40 (header), line 45 (header), line 46 (header), line 89 (text), line 108
  (text), line 125 (text), line 129 (text) and line 130 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][43], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (header), line 28 (header) and line 29 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][44], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 41 (text), line 47 (text) and line 66 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][45], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (header), line 41 (text), line 60 (text) and line 60 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][46], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (header) and line 111 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][47], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and line 96 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][48], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (header), line 72 (text), line 72 (body comment), line 76 (text), line 77 (text), line 78 (text), line 79
  (text), line 83 (text), line 86 (text), line 103 (text), line 103 (body comment) and line 103 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][49], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (header), line 80 (text), line 84 (text), line 87 (text), line 91 (text), line 92 (text), line 96 (text), line
  105 (text), line 106 (text), line 110 (text), line 114 (text), line 115 (text), line 134 (text), line 134 (body comment) and line 134
  (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][50], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 39 (text), line 46 (text), line 52 (text), line 69 (text) and line 69
  (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][51], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 41 (text), line 50 (text), line 55 (text) and line 63 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][52], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header), line 90 (text), line 134 (text) and line 148 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][53], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][54], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][55], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 20 (text), line 32 (body comment) and line 35 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][56], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][57], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][58], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][59], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (text).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][60], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text) and line 163 (body comment).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][61], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][62], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][63], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 20 (text).

### Variants (automation/Catzc.Base.Variants, 11 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-PathModule.ps1][64], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (header) and line 24 (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][65], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 19 (header), line 23 (header), line 26 (header) and line 30 (header).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][66], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 18 (header), line 22 (text) and line 73 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][67], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (header) and line 97 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][68], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and line 22 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][69], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][70], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][71], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/PathModule.cs][72], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][73], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][74], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text) and line 265 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 8 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][75], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 312 (text) and line 315 (text).
- [automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1][76], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header) and line 25 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][77], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (header) and line 31 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1][78], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header) and line 25 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1][79], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][80], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and line 22 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][81], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and line 22 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][82], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and line 22 (text).

### .claude (7 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][83], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51
  (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][84], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 123 (text), line 344 (text), line 384 (text), line 408 (text), line 482 (text), line 677 (text), line 700 (text), line
  796 (text) and line 800 (text).
- [.claude/plans/plan-module-kinds-tracks.md][85], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 36 (text), line 56 (text), line 74 (text), line 137 (text), line 254 (text), line 374 (text), line 388 (text), line 419 (text), line
  424 (text), line 472 (text), line 489 (text), line 489 (text), line 514 (text), line 516 (text), line 518 (text), line 528 (text), line
  536 (text), line 537 (text), line 547 (text), line 566 (text), line 677 (text), line 689 (text), line 694 (text), line 697 (text), line
  725 (text), line 733 (text), line 755 (text), line 793 (text), line 812 (text), line 821 (text), line 863 (text) and line 918 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][86], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 30 (text) and line 130 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][87], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text) and line 45 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][88], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 32 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][89], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 18 (text).

### Languages (automation/Catzc.Base.Languages, 7 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][90], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (header) and line 24 (header).
- [automation/Catzc.Base.Languages/Get-PathFileType.ps1][91], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (header) and line 26 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][92], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 23 (text).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][93], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header), line 133 (text), line 145 (text) and line 183 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][94], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and line 22 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][95], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][96], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text).

### Docs (automation/Catzc.Base.Docs, 5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][97], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 91 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][98], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (header), line 119 (text) and line 119 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][99], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 20 (text).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][100], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 20 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][101], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 24 (text) and line 43 (body comment).

### .unordered (4 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][102], in the cell .unordered × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 90 (text) and line 248 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][103], in the cell .unordered × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 32 (text), line 50 (text), line 51 (text), line 51 (text), line 54 (text), line 162 (text) and line 187 (text).
- [.unordered/15-10-2026/plan-diagram-wave-7.md][104], in the cell .unordered × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 101 (text) and line 102 (text).
- [.unordered/15-10-2026/plan-explanation-assets-source.md][105], in the cell .unordered × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 29 (text), line 39 (text), line 41 (text), line 54 (text), line 56 (text) and line 110 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][106], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 103 (text), line 130
  (text), line 147 (text), line 176 (text), line 219 (text), line 229 (text), line 239 (text), line 241 (text), line 256 (text), line 295
  (text), line 309 (text), line 323 (text), line 336 (text), line 370 (text) and line 382 (text).
- [docs/adr/index.md][107], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 103 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][108], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50
  (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][109], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and line 65 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][110], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 23 (text), line 81 (text), line 147 (text), line 155 (text), line 166 (text), line 183 (text), line 196 (text), line 210
  (text), line 225 (text), line 238 (text), line 250 (text), line 263 (text), line 265 (text) and line 277 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][111], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 91 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 119 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 119 (body comment), `automation/Catzc.Base.Docs/types/AdrDomain.cs`
  line 20 (text), `automation/Catzc.Base.Docs/types/AdrRuleSet.cs` line 20 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 24
  (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 43 (body comment),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 65 (text), `automation/Catzc.Base.Languages/Get-FileLanguage.ps1`
  line 19 (header), `automation/Catzc.Base.Languages/Get-FileLanguage.ps1` line 24 (header),
  `automation/Catzc.Base.Languages/Get-PathFileType.ps1` line 19 (header), `automation/Catzc.Base.Languages/Get-PathFileType.ps1` line 26
  (header), `automation/Catzc.Base.Languages/configs/glossary.yml` line 23 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 133 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 145 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 183 (text),
  `automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 22 (text), `automation/Catzc.Base.Languages/types/FileLanguage.cs`
  line 20 (text), `automation/Catzc.Base.Languages/types/LanguagesConfig.cs` line 22 (text),
  `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 19 (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 29
  (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 30 (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line
  32 (header), `automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1` line 48 (header),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 20 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line
  29 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 30 (header),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 41 (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 19
  (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 26 (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 28
  (header), `automation/Catzc.Base.Maps/Get-ValueChainMap.ps1` line 30 (header), `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 22
  (header), `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 29 (header), `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 30 (header),
  `automation/Catzc.Base.Maps/Get-WorldMap.ps1` line 42 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 19 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 32 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49
  (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 22 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line
  36 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 38 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1`
  line 41 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 45 (header),
  `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 76 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 77 (text),
  `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 87 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 90 (text),
  `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 107 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 33 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 36 (header),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 40 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 45 (header),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 46 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 89 (text),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 108 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 125 (text),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 129 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 130 (text),
  `automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1` line 28 (header),
  `automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1` line 29 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 41 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 47 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 41 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 60 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 60 (body comment),
  `automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 19 (header), `automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line
  111 (text), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 96 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 72 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 72 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 76 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 79 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 83 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 86 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 103 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 103 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 103 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 20 (header), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 80 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 84 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 87 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  91 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 92 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 96 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  105 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 106 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 110 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 114 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 115 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 134 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 134 (body comment), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 134 (body comment),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 39 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 46 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 52 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 69 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 69 (body comment),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 41 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 55 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 63 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 90 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 134 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 148 (text), `automation/Catzc.Base.Maps/types/MapCell.cs` line
  20 (text), `automation/Catzc.Base.Maps/types/MapsLabels.cs` line 21 (text), `automation/Catzc.Base.Maps/types/ValueChainCell.cs` line 20
  (text), `automation/Catzc.Base.Maps/types/ValueChainCell.cs` line 32 (body comment), `automation/Catzc.Base.Maps/types/ValueChainCell.cs`
  line 35 (body comment), `automation/Catzc.Base.Maps/types/ValueChainHighlight.cs` line 20 (text),
  `automation/Catzc.Base.Maps/types/ValueChainMap.cs` line 20 (text), `automation/Catzc.Base.Maps/types/ValueChainReason.cs` line 20 (text),
  `automation/Catzc.Base.Maps/types/WorldMap.cs` line 19 (text), `automation/Catzc.Base.Maps/types/WorldMapBuilder.cs` line 21 (text),
  `automation/Catzc.Base.Maps/types/WorldMapBuilder.cs` line 163 (body comment), `automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs`
  line 20 (text), `automation/Catzc.Base.Maps/types/WorldMapHighlight.cs` line 20 (text), `automation/Catzc.Base.Maps/types/WorldMapPdf.cs`
  line 20 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 23 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 81 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  147 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 155 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 166 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  183 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 196 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 210 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  225 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 238 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 250 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  263 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 265 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 277 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml`
  line 312 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 315 (text),
  `automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1` line 24 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1` line 31 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 22 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 22 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 22 (text),
  `automation/Catzc.Base.Variants/Get-PathModule.ps1` line 19 (header), `automation/Catzc.Base.Variants/Get-PathModule.ps1` line 24
  (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 19 (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 23
  (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 26 (header), `automation/Catzc.Base.Variants/Get-Track.ps1` line 30
  (header), `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 22 (text),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 73 (text), `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1`
  line 18 (header), `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 97 (text),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 22 (text),
  `automation/Catzc.Base.Variants/types/ModulePlace.cs` line 19 (text), `automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs` line 18
  (text), `automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 20 (text), `automation/Catzc.Base.Variants/types/PathModule.cs`
  line 18 (text), `automation/Catzc.Base.Variants/types/VariantTrack.cs` line 20 (text),
  `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line 22 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  265 (text).

## Keywords

- [world map][112]
- [track][113]
- [file language][114]
- [cell][115]
- [lit cell][116]
- [.claude][117]: a track
- [.unordered][117]: a track
- [automation][117]: a track
- [docs][117]: a track
- [pipelines][117]: a track
- [csharp][118]: a file language
- [markdown][118]: a file language
- [pipeline-yaml][118]: a file language
- [powershell][118]: a file language
- [yaml][118]: a file language

Terms the cited ADRs define:

- [cell][115], defined by [ADR-DSGN-TRACK#10][119]
- [deployable-unit][120], defined by [ADR-DSGN-TRACK#5][121]
- [file language][114], defined by [ADR-DSGN-TRACK#6][122]
- [lit cell][116], defined by [ADR-DSGN-TRACK#12][123]
- [place][124], defined by [ADR-DSGN-TRACK#1][125]
- [root file][126], defined by [ADR-DSGN-TRACK#7][127]
- [stack violation][128], defined by [ADR-DSGN-TRACK#11][129]
- [track][113], defined by [ADR-DSGN-TRACK#1][125]
- [unlisted file][130], defined by [ADR-DSGN-TRACK#8][131]
- [value-chain concern][132], defined by [ADR-DSGN-TRACK#15][133]
- [value-chain map][134], defined by [ADR-DSGN-TRACK#16][135]
- [value-chain stack][136], defined by [ADR-DSGN-TRACK#14][137]
- [verification track][138], defined by [ADR-DSGN-TRACK#2][139]
- [world map][112], defined by [ADR-DSGN-TRACK#9][140]

[1]: ../../adr/design/tracks.md
[2]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[3]: ../../references/automation/catzc-base-docs/configs/adrs.yml.md
[4]: ../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[5]: ../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[6]: ../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[7]: ../../references/automation/catzc-base-globs/configs/globs.yml.md
[8]: ../../references/automation/catzc-base-languages/configs/languages.yml.md
[9]: ../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[10]: ../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[11]: ../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[12]: ../../references/automation/catzc-base-maps.md
[13]: ../../references/automation/catzc-base-maps/configs/maps.yml.md
[14]: ../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[15]: ../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[16]: ../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[17]: ../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[18]: ../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[19]: ../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[20]: ../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[21]: ../../references/automation/catzc-base-maps/types/MapCell.cs.md
[22]: ../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[23]: ../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[24]: ../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[25]: ../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[26]: ../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[27]: ../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[28]: ../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[29]: ../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[30]: ../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[31]: ../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[32]: ../../references/automation/catzc-base-variants/configs/variants.yml.md
[33]: ../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[34]: ../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[35]: ../../references/pipelines/ci-automation.yaml.md
[36]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[37]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[38]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[39]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[40]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[41]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[42]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[43]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[44]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[45]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[46]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[47]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[48]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[49]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[50]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[51]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[52]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[53]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[54]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[55]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[56]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[57]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[58]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[59]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[60]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[61]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[62]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[63]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[64]: ../../../automation/Catzc.Base.Variants/Get-PathModule.ps1
[65]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[66]: ../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[67]: ../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[68]: ../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[69]: ../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[70]: ../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[71]: ../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[72]: ../../../automation/Catzc.Base.Variants/types/PathModule.cs
[73]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[74]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[75]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[76]: ../../../automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1
[77]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[78]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1
[79]: ../../../automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
[80]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[81]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[82]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[83]: ../../../.claude/plans/decisions-2026-10-16.md
[84]: ../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[85]: ../../../.claude/plans/plan-module-kinds-tracks.md
[86]: ../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[87]: ../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[88]: ../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[89]: ../../../.claude/plans/prompt-module-model-1-prepare.md
[90]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[91]: ../../../automation/Catzc.Base.Languages/Get-PathFileType.ps1
[92]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[93]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[94]: ../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[95]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[96]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[97]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[98]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[99]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[100]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[101]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[102]: ../../../.unordered/15-10-2026/plan-adr-consistency.md
[103]: ../../../.unordered/15-10-2026/plan-concern-axis.md
[104]: ../../../.unordered/15-10-2026/plan-diagram-wave-7.md
[105]: ../../../.unordered/15-10-2026/plan-explanation-assets-source.md
[106]: ../../adr/glossary.md
[107]: ../../adr/index.md
[108]: ../../adr/design/dora-explains.md
[109]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[110]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[111]: ../../../pipelines/ci-automation.yaml
[112]: ../../adr/glossary.md#world-map
[113]: ../../adr/glossary.md#track
[114]: ../../adr/glossary.md#file-language
[115]: ../../adr/glossary.md#cell
[116]: ../../adr/glossary.md#lit-cell
[117]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[118]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[119]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[120]: ../../adr/glossary.md#deployable-unit
[121]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[122]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[123]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[124]: ../../adr/glossary.md#place
[125]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[126]: ../../adr/glossary.md#root-file
[127]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[128]: ../../adr/glossary.md#stack-violation
[129]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[130]: ../../adr/glossary.md#unlisted-file
[131]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[132]: ../../adr/glossary.md#value-chain-concern
[133]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[134]: ../../adr/glossary.md#value-chain-map
[135]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[136]: ../../adr/glossary.md#value-chain-stack
[137]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[138]: ../../adr/glossary.md#verification-track
[139]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[140]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

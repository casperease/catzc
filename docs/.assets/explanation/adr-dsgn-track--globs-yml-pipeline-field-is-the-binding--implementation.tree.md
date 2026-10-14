# docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md

`Tree minimap: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation`

![Tree minimap of adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation` (implementation lens). The slide
supports [ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 62 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Maps (automation/Catzc.Base.Maps): 28 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Languages (automation/Catzc.Base.Languages): 6 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Globs (automation/Catzc.Base.Globs): 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- docs (docs/ outside docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Maps (28 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][2], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (header), line 11 (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][3], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 8 (header), line 9 (header) and line 22 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][4], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header), line 8 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][5], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header), line 7 (header) and line 18 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][6], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 12 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][7], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (header), line 16 (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line
  68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][8], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 11 (header), line 14 (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102
  (text), line 106 (text) and line 107 (text).
- [automation/Catzc.Base.Maps/configs/maps.yml][9], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 26 (header), line 32 (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][10], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 9 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][11], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][12], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][13], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 72 (body comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][14], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line 61 (text), line 62
  (text), line 63 (text), line 64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header), line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81
  (text), line 90 (text), line 91 (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line
  121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][16], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text)
  and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][17], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][18], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 104 (text) and line 119 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][19], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 2 (header), line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][20], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 5 (header), line 6 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][21], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][22], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][23], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][24], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][25], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][26], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 7 (header), line 8 (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][27], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][28], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][29], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 4 (header), line 5 (header) and line 6 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][30], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][31], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][32], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][33], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][34], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][35], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][36], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][37], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Languages (6 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][38], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][39], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][40], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][41], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][42], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][43], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).

### Docs (5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][44], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][45], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][46], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][47], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][48], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][49], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][50], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][51], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][52], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### Globs (2 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/configs/globs.yml][53], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][54], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 50 (text).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][55], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 318 (text) and line 321 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][56], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][57], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text).
- [docs/adr/index.md][58], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text).

### docs (2 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/repository-conventions.md][59], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line 30
  (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps.md][60], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][61], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][62], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header).

## Keywords

- [world map][63]
- [track][64]
- [file language][65]
- [cell][66]
- [lit cell][67]
- [automation][50]: a track
- [docs][50]: a track
- [pipelines][50]: a track
- [csharp][40]: a file language
- [markdown][40]: a file language
- [pipeline-yaml][40]: a file language
- [powershell][40]: a file language
- [yaml][40]: a file language

Terms the cited ADRs define:

- [cell][66], defined by [ADR-DSGN-TRACK#10][68]
- [deployable-unit][69], defined by [ADR-DSGN-TRACK#5][70]
- [file language][65], defined by [ADR-DSGN-TRACK#6][71]
- [lit cell][67], defined by [ADR-DSGN-TRACK#12][72]
- [root file][73], defined by [ADR-DSGN-TRACK#7][74]
- [stack violation][75], defined by [ADR-DSGN-TRACK#11][76]
- [track][64], defined by [ADR-DSGN-TRACK#1][77]
- [unlisted file][78], defined by [ADR-DSGN-TRACK#8][79]
- [value-chain concern][80], defined by [ADR-DSGN-TRACK#15][81]
- [value-chain map][82], defined by [ADR-DSGN-TRACK#16][83]
- [value-chain stack][84], defined by [ADR-DSGN-TRACK#14][85]
- [verification track][86], defined by [ADR-DSGN-TRACK#2][87]
- [world map][63], defined by [ADR-DSGN-TRACK#9][88]

[1]: ../../adr/design/tracks.md
[2]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[3]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[4]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[5]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[6]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[7]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[8]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[9]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[10]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[11]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[12]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[13]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[14]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[15]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[16]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[17]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[18]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[19]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[20]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[21]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[22]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[23]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[24]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[25]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[26]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[27]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[28]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[29]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[30]: ../../adr/design/commit-lifecycle.md
[31]: ../../adr/design/dora-explains.md
[32]: ../../adr/design/module-aspects.md
[33]: ../../adr/design/run-modes.md
[34]: ../../adr/design/self-service.md
[35]: ../../adr/design/server-remote-integration.md
[36]: ../../adr/design/thin-platforms.md
[37]: ../../adr/design/visual-design.md
[38]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[39]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[40]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[41]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[42]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[43]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[44]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[45]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[46]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[47]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[48]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[49]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[50]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[51]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[52]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[53]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[54]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[55]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[56]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[57]: ../../adr/glossary.md
[58]: ../../adr/index.md
[59]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[60]: ../../references/automation/catzc-base-maps.md
[61]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[62]: ../../../pipelines/ci-automation.yaml
[63]: ../../adr/glossary.md#world-map
[64]: ../../adr/glossary.md#track
[65]: ../../adr/glossary.md#file-language
[66]: ../../adr/glossary.md#cell
[67]: ../../adr/glossary.md#lit-cell
[68]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[69]: ../../adr/glossary.md#deployable-unit
[70]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[71]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[72]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[73]: ../../adr/glossary.md#root-file
[74]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[75]: ../../adr/glossary.md#stack-violation
[76]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[77]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[78]: ../../adr/glossary.md#unlisted-file
[79]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[80]: ../../adr/glossary.md#value-chain-concern
[81]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[82]: ../../adr/glossary.md#value-chain-map
[83]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[84]: ../../adr/glossary.md#value-chain-stack
[85]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[86]: ../../adr/glossary.md#verification-track
[87]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[88]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

# docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md

`Tree minimap: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation`

![Tree minimap of adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation` (implementation lens). The slide
supports [ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 69 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Maps (automation/Catzc.Base.Maps): 28 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- docs (docs/ outside docs/adr/): 7 lit files
- Languages (automation/Catzc.Base.Languages): 6 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- .claude: 2 lit files
- Globs (automation/Catzc.Base.Globs): 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
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
  at line 6 (header), line 7 (header) and line 17 (header).
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

### docs (7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][38], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][39], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/one-unit-one-pipeline.md][40], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 14 (text), line 38 (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][41], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][42], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][43], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line 30
  (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps.md][44], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### Languages (6 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][45], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][46], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][47], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][48], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][49], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][50], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).

### Docs (5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][51], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][52], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][53], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][54], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][55], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][56], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][57], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][58], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][59], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/drawio/STYLE.md][60], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 181 (text), line
  182 (text), line 190 (text), line 191 (text), line 199 (text), line 201 (text), line 201 (text) and line 214 (text).
- [.claude/drawio/minimaps/highlights.ps1][61], in the cell .claude × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  52 (body comment) (a passing mention only).

### Globs (2 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/configs/globs.yml][62], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][63], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 50 (text).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][64], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 318 (text) and line 321 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][65], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][66], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text).
- [docs/adr/index.md][67], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][68], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][69], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header).

## Keywords

- [world map][70]
- [track][71]
- [file language][72]
- [cell][73]
- [lit cell][74]
- [.claude][57]: a track
- [automation][57]: a track
- [docs][57]: a track
- [pipelines][57]: a track
- [csharp][47]: a file language
- [markdown][47]: a file language
- [pipeline-yaml][47]: a file language
- [powershell][47]: a file language
- [yaml][47]: a file language

Terms the cited ADRs define:

- [cell][73], defined by [ADR-DSGN-TRACK#10][75]
- [deployable-unit][76], defined by [ADR-DSGN-TRACK#5][77]
- [file language][72], defined by [ADR-DSGN-TRACK#6][78]
- [lit cell][74], defined by [ADR-DSGN-TRACK#12][79]
- [root file][80], defined by [ADR-DSGN-TRACK#7][81]
- [stack violation][82], defined by [ADR-DSGN-TRACK#11][83]
- [track][71], defined by [ADR-DSGN-TRACK#1][84]
- [unlisted file][85], defined by [ADR-DSGN-TRACK#8][86]
- [value-chain concern][87], defined by [ADR-DSGN-TRACK#15][88]
- [value-chain map][89], defined by [ADR-DSGN-TRACK#16][90]
- [value-chain stack][91], defined by [ADR-DSGN-TRACK#14][92]
- [verification track][93], defined by [ADR-DSGN-TRACK#2][94]
- [world map][70], defined by [ADR-DSGN-TRACK#9][95]

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
[38]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[39]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[40]: ../../explanation/design/one-unit-one-pipeline.md
[41]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[42]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[43]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[44]: ../../references/automation/catzc-base-maps.md
[45]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[46]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[47]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[48]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[49]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[50]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[51]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[52]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[53]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[54]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[55]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[56]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[57]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[59]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[60]: ../../../.claude/drawio/STYLE.md
[61]: ../../../.claude/drawio/minimaps/highlights.ps1
[62]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[63]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[64]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[65]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[66]: ../../adr/glossary.md
[67]: ../../adr/index.md
[68]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[69]: ../../../pipelines/ci-automation.yaml
[70]: ../../adr/glossary.md#world-map
[71]: ../../adr/glossary.md#track
[72]: ../../adr/glossary.md#file-language
[73]: ../../adr/glossary.md#cell
[74]: ../../adr/glossary.md#lit-cell
[75]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[76]: ../../adr/glossary.md#deployable-unit
[77]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[78]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[79]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[80]: ../../adr/glossary.md#root-file
[81]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[82]: ../../adr/glossary.md#stack-violation
[83]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[84]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[85]: ../../adr/glossary.md#unlisted-file
[86]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[87]: ../../adr/glossary.md#value-chain-concern
[88]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[89]: ../../adr/glossary.md#value-chain-map
[90]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[91]: ../../adr/glossary.md#value-chain-stack
[92]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[93]: ../../adr/glossary.md#verification-track
[94]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[95]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

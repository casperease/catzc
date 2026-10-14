# docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md

`Tree minimap: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations`

![Tree minimap of adr-dsgn-track--a-push-fires-only-touched-pipelines--operations](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.png)

The tree minimap of the slide `adr-dsgn-track--a-push-fires-only-touched-pipelines--operations` (operations lens). The slide supports
[ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 73 files in 12 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- Maps (automation/Catzc.Base.Maps): 28 lit files
- docs (docs/ outside docs/adr/): 12 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Languages (automation/Catzc.Base.Languages): 6 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- .claude: 2 lit files
- Globs (automation/Catzc.Base.Globs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
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
  at line 6 (header), line 7 (header) and line 15 (header).
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

### docs (12 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md][30], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md][31], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md][32], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 64 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][33], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md][34], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][35], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][36], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/one-unit-one-pipeline.md][37], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 14 (text), line 38 (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][38], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][39], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][40], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (text), line 25 (text), line 25 (text), line 29 (text), line 29 (text), line 31 (text), line 31 (text), line 31
  (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps.md][41], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][42], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][43], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][44], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][45], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][46], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][47], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][48], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][49], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Languages (6 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][50], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][51], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][52], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][53], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][54], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][55], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).

### Docs (5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][56], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][57], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][58], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][59], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][60], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][61], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][62], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][63], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][64], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/drawio/STYLE.md][65], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 180 (text), line
  181 (text), line 186 (text), line 194 (text), line 196 (text) and line 197 (text).
- [.claude/drawio/minimaps/highlights.ps1][66], in the cell .claude × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  44 (body comment) (a passing mention only).

### Globs (2 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/configs/globs.yml][67], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][68], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 50 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][69], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text).
- [docs/adr/index.md][70], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][71], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][72], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][73], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header).

## Keywords

- [world map][74]
- [track][75]
- [file language][76]
- [cell][77]
- [lit cell][78]
- [.claude][62]: a track
- [automation][62]: a track
- [docs][62]: a track
- [pipelines][62]: a track
- [csharp][52]: a file language
- [markdown][52]: a file language
- [pipeline-yaml][52]: a file language
- [powershell][52]: a file language
- [yaml][52]: a file language

Terms the cited ADRs define:

- [cell][77], defined by [ADR-DSGN-TRACK#10][79]
- [deployable-unit][80], defined by [ADR-DSGN-TRACK#5][81]
- [file language][76], defined by [ADR-DSGN-TRACK#6][82]
- [lit cell][78], defined by [ADR-DSGN-TRACK#12][83]
- [root file][84], defined by [ADR-DSGN-TRACK#7][85]
- [stack violation][86], defined by [ADR-DSGN-TRACK#11][87]
- [track][75], defined by [ADR-DSGN-TRACK#1][88]
- [unlisted file][89], defined by [ADR-DSGN-TRACK#8][90]
- [value-chain concern][91], defined by [ADR-DSGN-TRACK#15][92]
- [value-chain map][93], defined by [ADR-DSGN-TRACK#16][94]
- [value-chain stack][95], defined by [ADR-DSGN-TRACK#14][96]
- [verification track][97], defined by [ADR-DSGN-TRACK#2][98]
- [world map][74], defined by [ADR-DSGN-TRACK#9][99]

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
[30]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
[31]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
[32]: adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
[33]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[34]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
[35]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[36]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[37]: ../../explanation/design/one-unit-one-pipeline.md
[38]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[39]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[40]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[41]: ../../references/automation/catzc-base-maps.md
[42]: ../../adr/design/commit-lifecycle.md
[43]: ../../adr/design/dora-explains.md
[44]: ../../adr/design/module-aspects.md
[45]: ../../adr/design/run-modes.md
[46]: ../../adr/design/self-service.md
[47]: ../../adr/design/server-remote-integration.md
[48]: ../../adr/design/thin-platforms.md
[49]: ../../adr/design/visual-design.md
[50]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[51]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[52]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[53]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[54]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[55]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[56]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[57]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[58]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[59]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[60]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[61]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[62]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[63]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[64]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[65]: ../../../.claude/drawio/STYLE.md
[66]: ../../../.claude/drawio/minimaps/highlights.ps1
[67]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[68]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[69]: ../../adr/glossary.md
[70]: ../../adr/index.md
[71]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[72]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[73]: ../../../pipelines/ci-automation.yaml
[74]: ../../adr/glossary.md#world-map
[75]: ../../adr/glossary.md#track
[76]: ../../adr/glossary.md#file-language
[77]: ../../adr/glossary.md#cell
[78]: ../../adr/glossary.md#lit-cell
[79]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[80]: ../../adr/glossary.md#deployable-unit
[81]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[82]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[83]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[84]: ../../adr/glossary.md#root-file
[85]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[86]: ../../adr/glossary.md#stack-violation
[87]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[88]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[89]: ../../adr/glossary.md#unlisted-file
[90]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[91]: ../../adr/glossary.md#value-chain-concern
[92]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[93]: ../../adr/glossary.md#value-chain-map
[94]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[95]: ../../adr/glossary.md#value-chain-stack
[96]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[97]: ../../adr/glossary.md#verification-track
[98]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[99]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

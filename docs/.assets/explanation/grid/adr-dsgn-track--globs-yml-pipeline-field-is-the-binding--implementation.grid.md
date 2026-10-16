# docs/.assets/explanation/grid/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md

`Grid minimap: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation`

![Grid minimap of adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.png)

The grid minimap of the slide `adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation` (implementation lens). The slide
supports [ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 51 files
- .unordered × markdown: 4 lit of 20 files
- automation × csharp: 22 lit of 272 files
- automation × powershell: 35 lit of 1563 files
- automation × yaml: 4 lit of 107 files
- docs × markdown: 38 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (7 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][6]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 123 (text), line
  344 (text), line 384 (text), line 408 (text), line 482 (text), line 677 (text), line 700 (text), line 796 (text) and line 800 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text), line 56 (text), line
  74 (text), line 137 (text), line 254 (text), line 374 (text), line 388 (text), line 419 (text), line 424 (text), line 472 (text), line 489
  (text), line 489 (text), line 514 (text), line 516 (text), line 518 (text), line 528 (text), line 536 (text), line 537 (text), line 547
  (text), line 566 (text), line 677 (text), line 689 (text), line 694 (text), line 697 (text), line 725 (text), line 733 (text), line 755
  (text), line 793 (text), line 812 (text), line 821 (text), line 863 (text) and line 918 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text) and line 130
  (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text) and line 45 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text).

### .unordered × markdown (4 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 90 (text) and line 248
  (text).
- [.unordered/15-10-2026/plan-concern-axis.md][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line 50 (text),
  line 51 (text), line 51 (text), line 54 (text), line 162 (text) and line 187 (text).
- [.unordered/15-10-2026/plan-diagram-wave-7.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 101 (text) and line 102
  (text).
- [.unordered/15-10-2026/plan-explanation-assets-source.md][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line
  39 (text), line 41 (text), line 54 (text), line 56 (text) and line 110 (text).

### automation × csharp (22 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text) and line 43
  (body comment).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text), line 32
  (body comment) and line 35 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text) and line
  163 (body comment).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/PathModule.cs][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text) and
  line 265 (text).

### automation × powershell (35 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header),
  line 119 (text) and line 119 (body comment).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header) and line 65 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and
  line 24 (header).
- [automation/Catzc.Base.Languages/Get-PathFileType.ps1][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and
  line 26 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 133 (text), line 145 (text) and line 183 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (header) and line 22 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header), line 29
  (header), line 30 (header), line 32 (header) and line 48 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][45]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line
  29 (header), line 30 (header) and line 41 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header), line 26
  (header), line 28 (header) and line 30 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line 29
  (header), line 30 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header), line
  32 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line 36
  (header), line 38 (header), line 41 (header), line 45 (header), line 76 (text), line 77 (text), line 87 (text), line 90 (text) and line
  107 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 33
  (header), line 36 (header), line 40 (header), line 45 (header), line 46 (header), line 89 (text), line 108 (text), line 125 (text), line
  129 (text) and line 130 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][51]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header),
  line 28 (header) and line 29 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][52]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 41 (text), line 47 (text) and line 66 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][53]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 41 (text), line 60 (text) and line 60 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][54]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and
  line 111 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][55]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (header) and line 96 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][56]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 72 (text), line 72 (body comment), line 76 (text), line 77 (text), line 78 (text), line 79 (text), line 83 (text), line 86
  (text), line 103 (text), line 103 (body comment) and line 103 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][57]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header),
  line 80 (text), line 84 (text), line 87 (text), line 91 (text), line 92 (text), line 96 (text), line 105 (text), line 106 (text), line 110
  (text), line 114 (text), line 115 (text), line 134 (text), line 134 (body comment) and line 134 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][58]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 39 (text), line 46 (text), line 52 (text), line 69 (text) and line 69 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][59]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 41 (text), line 50 (text), line 55 (text) and line 63 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][60]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (header), line 90 (text), line 134 (text) and line 148 (text).
- [automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1][61]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  21 (header) and line 25 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][62]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  24 (header) and line 31 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1][63]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 21 (header) and line 25 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1][64]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][65]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (header) and line 22 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][66]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (header) and line 22 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][67]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (header) and line 22 (text).
- [automation/Catzc.Base.Variants/Get-PathModule.ps1][68]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and line
  24 (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][69]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header), line 23
  (header), line 26 (header) and line 30 (header).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][70]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (header), line 22 (text) and line 73 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][71]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (header) and
  line 97 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][72]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (header) and line 22 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][73]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text).
- [automation/Catzc.Base.Languages/configs/glossary.yml][74]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][75]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line
  81 (text), line 147 (text), line 155 (text), line 166 (text), line 183 (text), line 196 (text), line 210 (text), line 225 (text), line 238
  (text), line 250 (text), line 263 (text), line 265 (text) and line 277 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 312 (text)
  and line 315 (text).

### docs × markdown (38 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][77]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/glossary.md][78]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 103 (text), line 130 (text), line 147 (text), line
  176 (text), line 219 (text), line 229 (text), line 239 (text), line 241 (text), line 256 (text), line 295 (text), line 309 (text), line
  323 (text), line 336 (text), line 370 (text) and line 382 (text).
- [docs/adr/index.md][79]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 103 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][80]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 38 (text), line 44 (text), line 44 (text), line 47 (text), line 47 (text), line 49 (text), line 49 (text), line 49 (text),
  line 50 (text), line 51 (text) and line 53 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][81]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 39 (text) and line 40 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][82]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 35 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][83]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 53 (text), line 56 (text) and line 68 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][85]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text) and line 125 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][87]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][89]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps.md][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 96 (text),
  line 98 (text) and line 110 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][91]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 56 (text), line 62 (text), line 64 (text) and line 69 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][92]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][93]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 17 (text), line 31 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][97]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][98]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 31 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][100]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 35 (text), line 36 (text) and line 40 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][101]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 16 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][103]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 31 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][105]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][106]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 37 (text), line 38 (text) and line 41 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  16 (text), line 93 (text), line 96 (text) and line 98 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][112]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 51 (text), line 54 (text) and line 56 (text).
- [docs/references/pipelines/ci-automation.yaml.md][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text) and line 31
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][114]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 91 (text),
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

- [world map][115]
- [track][116]
- [file language][117]
- [cell][118]
- [lit cell][119]
- [.claude][120]: a track
- [.unordered][120]: a track
- [automation][120]: a track
- [docs][120]: a track
- [pipelines][120]: a track
- [csharp][121]: a file language
- [markdown][121]: a file language
- [pipeline-yaml][121]: a file language
- [powershell][121]: a file language
- [yaml][121]: a file language

Terms the cited ADRs define:

- [cell][118], defined by [ADR-DSGN-TRACK#10][122]
- [deployable-unit][123], defined by [ADR-DSGN-TRACK#5][124]
- [file language][117], defined by [ADR-DSGN-TRACK#6][3]
- [lit cell][119], defined by [ADR-DSGN-TRACK#12][4]
- [place][125], defined by [ADR-DSGN-TRACK#1][2]
- [root file][126], defined by [ADR-DSGN-TRACK#7][127]
- [stack violation][128], defined by [ADR-DSGN-TRACK#11][129]
- [track][116], defined by [ADR-DSGN-TRACK#1][2]
- [unlisted file][130], defined by [ADR-DSGN-TRACK#8][131]
- [value-chain concern][132], defined by [ADR-DSGN-TRACK#15][133]
- [value-chain map][134], defined by [ADR-DSGN-TRACK#16][135]
- [value-chain stack][136], defined by [ADR-DSGN-TRACK#14][137]
- [verification track][138], defined by [ADR-DSGN-TRACK#2][139]
- [world map][115], defined by [ADR-DSGN-TRACK#9][140]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[9]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[10]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[11]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[12]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[13]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[14]: ../../../../.unordered/15-10-2026/plan-diagram-wave-7.md
[15]: ../../../../.unordered/15-10-2026/plan-explanation-assets-source.md
[16]: ../../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[17]: ../../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[18]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[19]: ../../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[20]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[21]: ../../../../automation/Catzc.Base.Maps/types/MapCell.cs
[22]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[23]: ../../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[24]: ../../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[25]: ../../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[26]: ../../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[27]: ../../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[28]: ../../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[29]: ../../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[30]: ../../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[31]: ../../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[32]: ../../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[33]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[34]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[35]: ../../../../automation/Catzc.Base.Variants/types/PathModule.cs
[36]: ../../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[37]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[38]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[39]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[40]: ../../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[41]: ../../../../automation/Catzc.Base.Languages/Get-PathFileType.ps1
[42]: ../../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[43]: ../../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[44]: ../../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[45]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[46]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[47]: ../../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[48]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[49]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[50]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[51]: ../../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[52]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[53]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[54]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[55]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[56]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[57]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[58]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[59]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[60]: ../../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[61]: ../../../../automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1
[62]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[63]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1
[64]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
[65]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[66]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[67]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[68]: ../../../../automation/Catzc.Base.Variants/Get-PathModule.ps1
[69]: ../../../../automation/Catzc.Base.Variants/Get-Track.ps1
[70]: ../../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[71]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[72]: ../../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[73]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[74]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[75]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[76]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[77]: ../../../adr/design/dora-explains.md
[78]: ../../../adr/glossary.md
[79]: ../../../adr/index.md
[80]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[81]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[82]: ../../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[83]: ../../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[84]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[85]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[86]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[87]: ../../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[88]: ../../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[89]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[90]: ../../../references/automation/catzc-base-maps.md
[91]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[92]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[93]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[94]: ../../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[95]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[96]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[97]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[98]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[99]: ../../../references/automation/catzc-base-maps/types/MapCell.cs.md
[100]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[101]: ../../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[102]: ../../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[103]: ../../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[104]: ../../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[105]: ../../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[106]: ../../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[107]: ../../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[108]: ../../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[109]: ../../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[110]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[111]: ../../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[112]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[113]: ../../../references/pipelines/ci-automation.yaml.md
[114]: ../../../../pipelines/ci-automation.yaml
[115]: ../../../adr/glossary.md#world-map
[116]: ../../../adr/glossary.md#track
[117]: ../../../adr/glossary.md#file-language
[118]: ../../../adr/glossary.md#cell
[119]: ../../../adr/glossary.md#lit-cell
[120]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[121]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[122]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[123]: ../../../adr/glossary.md#deployable-unit
[124]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[125]: ../../../adr/glossary.md#place
[126]: ../../../adr/glossary.md#root-file
[127]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[128]: ../../../adr/glossary.md#stack-violation
[129]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[130]: ../../../adr/glossary.md#unlisted-file
[131]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[132]: ../../../adr/glossary.md#value-chain-concern
[133]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[134]: ../../../adr/glossary.md#value-chain-map
[135]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[136]: ../../../adr/glossary.md#value-chain-stack
[137]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[138]: ../../../adr/glossary.md#verification-track
[139]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[140]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9

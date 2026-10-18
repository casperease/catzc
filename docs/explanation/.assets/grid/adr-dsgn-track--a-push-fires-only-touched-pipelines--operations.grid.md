# A push starts only the pipelines whose globset it touches: the world-map minimap

```text
Where the files that cite ADR-DSGN-TRACK sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 120 files.
```

![The world-map minimap of A push starts only the pipelines whose globset it touches](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [A push starts only the pipelines whose globset it touches][124],
which explains [ADR-DSGN-TRACK][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the
decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 13 lit of 91 files
- automation × csharp: 22 lit of 286 files
- automation × powershell: 38 lit of 1619 files
- automation × yaml: 6 lit of 112 files
- docs × markdown: 40 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (13 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 51 (text), line 58
  (text), line 77 (text), line 85 (text), line 148 (text), line 149 (text), line 153 (text), line 153 (text), line 155 (text), line 161
  (text), line 163 (text) and line 208 (text).
- [.claude/plans/decisions-2026-10-18.md][6]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 38 (text), line 55
  (text) and line 55 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text) and
  line 74 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line
  108 (text), line 109 (text), line 222 (text), line 466 (text), line 507 (text), line 532 (text), line 612 (text), line 814 (text), line
  841 (text), line 945 (text) and line 950 (text).
- [.claude/plans/plan-module-kinds-tracks.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text), line 71 (text), line
  75 (text), line 101 (text), line 107 (text), line 140 (text), line 160 (text), line 161 (text), line 182 (text), line 202 (text), line 250
  (text), line 363 (text), line 372 (text), line 520 (text), line 534 (text), line 565 (text), line 570 (text), line 616 (text), line 632
  (text), line 632 (text), line 658 (text), line 660 (text), line 662 (text), line 672 (text), line 680 (text), line 681 (text), line 691
  (text), line 710 (text), line 820 (text), line 832 (text), line 837 (text), line 839 (text), line 868 (text), line 875 (text), line 897
  (text), line 936 (text), line 955 (text), line 964 (text), line 1005 (text) and line 1060 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 54
  (text) and line 214 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 37 (text), line 48 (text)
  and line 73 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 54 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 37 (text), line 49
  (text), line 50 (text), line 89 (text) and line 98 (text).
- [.claude/plans/prompt-module-model-2-implement.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 44
  (text) and line 56 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (text).
- [.claude/plans/task-file-head-leftovers.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 31 (text), line 44 (text) and
  line 87 (text).
- [.claude/plans/task-import-landing-zone.md][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 33 (text), line 54 (text) and
  line 61 (text).

### automation × csharp (22 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text) and line 46
  (body comment).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text), line 33
  (body comment) and line 36 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/PathModule.cs][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text) and
  line 266 (text).

### automation × powershell (38 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header),
  line 134 (text) and line 134 (body comment).
- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (header)
  and line 28 (header).
- [automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (header) and line 23 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header) and line 66 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 25 (header).
- [automation/Catzc.Base.Languages/Get-PathFileType.ps1][45]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 27 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 134 (text), line 146 (text) and line 184 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header) and line 23 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 30
  (header), line 31 (header), line 33 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line
  30 (header), line 31 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 27
  (header), line 29 (header) and line 31 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][51]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (header), line 30
  (header), line 31 (header) and line 43 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][52]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line
  33 (header) and line 50 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][53]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (header), line 37
  (header), line 39 (header), line 42 (header), line 46 (header), line 77 (text), line 78 (text), line 88 (text), line 91 (text) and line
  108 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][54]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line 34
  (header), line 37 (header), line 41 (header), line 46 (header), line 47 (header), line 90 (text), line 109 (text), line 126 (text), line
  130 (text) and line 131 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][55]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header),
  line 29 (header) and line 30 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][56]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 48 (text) and line 67 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][57]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 61 (text) and line 61 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][58]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 112 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][59]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header) and line 97 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][60]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 73 (text), line 73 (body comment), line 77 (text), line 78 (text), line 79 (text), line 80 (text), line 84 (text), line 87
  (text), line 104 (text), line 104 (body comment) and line 104 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][61]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header),
  line 81 (text), line 85 (text), line 88 (text), line 92 (text), line 93 (text), line 97 (text), line 106 (text), line 107 (text), line 111
  (text), line 115 (text), line 116 (text), line 135 (text), line 135 (body comment) and line 135 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][62]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 40 (text), line 47 (text), line 53 (text), line 70 (text) and line 70 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][63]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 51 (text), line 56 (text) and line 64 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][64]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 91 (text), line 135 (text) and line 149 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][65]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header) and line 34 (header).
- [automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1][66]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][67]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  25 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1][68]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1][69]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22
  (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][70]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][71]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][72]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (header) and line 23 (text).
- [automation/Catzc.Base.Variants/Get-PathModule.ps1][73]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and line
  25 (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][74]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 24
  (header), line 27 (header) and line 31 (header).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][75]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 23 (text) and line 74 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header) and
  line 98 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][77]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (header) and line 23 (text).

### automation × yaml (6 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][78]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 93 (text).
- [automation/Catzc.Base.Languages/configs/glossary.yml][79]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][80]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line
  81 (text), line 89 (text), line 99 (text), line 108 (text), line 114 (text), line 210 (text), line 220 (text), line 231 (text), line 254
  (text), line 267 (text), line 281 (text), line 296 (text), line 309 (text), line 321 (text), line 334 (text), line 336 (text) and line 348
  (text).
- [automation/Catzc.Base.QualityGates/configs/source-conventions.yml][81]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26
  (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][82]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 316 (text)
  and line 319 (text).
- [automation/Catzc.Base.Variants/configs/track-types.yml][83]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 59 (text).

### docs × markdown (40 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/glossary.md][85]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161 (text), line 178 (text), line
  210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329 (text), line 331 (text), line
  346 (text), line 386 (text), line 400 (text), line 409 (text), line 423 (text), line 436 (text), line 470 (text) and line 482 (text).
- [docs/adr/index.md][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][87]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 39 (text), line 45 (text), line 45 (text), line 48 (text), line 48 (text), line 50 (text), line 50 (text), line 50 (text),
  line 51 (text), line 52 (text) and line 54 (text).
- [docs/how-to/automation/sort-an-import.md][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text) and line 23 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][89]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 40 (text) and line 41 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 36 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][91]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][92]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (text), line 55 (text), line 58 (text) and line 70 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][93]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text) and line 126 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][95]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][97]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps.md][98]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 96 (text),
  line 98 (text) and line 110 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 57 (text), line 63 (text), line 65 (text) and line 70 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][100]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][101]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][103]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][105]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][106]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 36 (text), line 37 (text) and line 41 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 32 (text), line 33 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][112]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][114]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 39 (text), line 40 (text), line 43 (text) and line 86 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][115]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][116]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][117]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 33 (text), line 34 (text) and line 35 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][118]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 94 (text), line 97 (text) and line 99 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][119]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][120]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 52 (text), line 55 (text) and line 57 (text).
- [docs/references/note-file-kind.md][121]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 37 (text), line 51
  (text) and line 54 (text).
- [docs/references/pipelines/ci-automation.yaml.md][122]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 32
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][123]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 93 (text),
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

- [world map][125]
- [track][126]
- [file language][127]
- [cell][128]
- [lit cell][129]
- [.claude][130]: a track
- [automation][130]: a track
- [docs][130]: a track
- [pipelines][130]: a track
- [csharp][131]: a file language
- [markdown][131]: a file language
- [pipeline-yaml][131]: a file language
- [powershell][131]: a file language
- [yaml][131]: a file language

Terms the cited ADRs define:

- [cell][128], defined by [ADR-DSGN-TRACK#10][132]
- [deployable-unit][133], defined by [ADR-DSGN-TRACK#5][134]
- [file language][127], defined by [ADR-DSGN-TRACK#6][3]
- [import][135], defined by [ADR-DSGN-TRACK#17][136]
- [landing address][137], defined by [ADR-DSGN-TRACK#17][136]
- [lit cell][129], defined by [ADR-DSGN-TRACK#12][4]
- [place][138], defined by [ADR-DSGN-TRACK#1][2]
- [root file][139], defined by [ADR-DSGN-TRACK#7][140]
- [sorting][141], defined by [ADR-DSGN-TRACK#17][136]
- [stack violation][142], defined by [ADR-DSGN-TRACK#11][143]
- [track][126], defined by [ADR-DSGN-TRACK#1][2]
- [unlisted file][144], defined by [ADR-DSGN-TRACK#8][145]
- [unordered track][146], defined by [ADR-DSGN-TRACK#17][136]
- [value-chain concern][147], defined by [ADR-DSGN-TRACK#15][148]
- [value-chain map][149], defined by [ADR-DSGN-TRACK#16][150]
- [value-chain stack][151], defined by [ADR-DSGN-TRACK#14][152]
- [verification track][153], defined by [ADR-DSGN-TRACK#2][154]
- [world map][125], defined by [ADR-DSGN-TRACK#9][155]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../.claude/plans/decisions-2026-10-18.md
[7]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[8]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[9]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[10]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[11]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[12]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[13]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[14]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[15]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[16]: ../../../../.claude/plans/task-file-head-leftovers.md
[17]: ../../../../.claude/plans/task-import-landing-zone.md
[18]: ../../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[19]: ../../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[20]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[21]: ../../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[22]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[23]: ../../../../automation/Catzc.Base.Maps/types/MapCell.cs
[24]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[25]: ../../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[26]: ../../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[27]: ../../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[28]: ../../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[29]: ../../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[30]: ../../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[31]: ../../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[32]: ../../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[33]: ../../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[34]: ../../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[35]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[36]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[37]: ../../../../automation/Catzc.Base.Variants/types/PathModule.cs
[38]: ../../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[39]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[40]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[41]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[42]: ../../../../automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[43]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[44]: ../../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[45]: ../../../../automation/Catzc.Base.Languages/Get-PathFileType.ps1
[46]: ../../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[47]: ../../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[48]: ../../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[49]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[50]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[51]: ../../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[52]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[53]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[54]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[55]: ../../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[56]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[57]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[58]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[59]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[60]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[61]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[62]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[63]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[64]: ../../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[65]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[66]: ../../../../automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1
[67]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[68]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1
[69]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
[70]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[71]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[72]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[73]: ../../../../automation/Catzc.Base.Variants/Get-PathModule.ps1
[74]: ../../../../automation/Catzc.Base.Variants/Get-Track.ps1
[75]: ../../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[76]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[77]: ../../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[78]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[79]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[80]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[81]: ../../../../automation/Catzc.Base.QualityGates/configs/source-conventions.yml
[82]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[83]: ../../../../automation/Catzc.Base.Variants/configs/track-types.yml
[84]: ../../../adr/design/dora-explains.md
[85]: ../../../adr/glossary.md
[86]: ../../../adr/index.md
[87]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[88]: ../../../how-to/automation/sort-an-import.md
[89]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[90]: ../../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[91]: ../../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[92]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[93]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[94]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[95]: ../../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[96]: ../../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[97]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[98]: ../../../references/automation/catzc-base-maps.md
[99]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[100]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[101]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[102]: ../../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[103]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[104]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[105]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[106]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[107]: ../../../references/automation/catzc-base-maps/types/MapCell.cs.md
[108]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[109]: ../../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[110]: ../../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[111]: ../../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[112]: ../../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[113]: ../../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[114]: ../../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[115]: ../../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[116]: ../../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[117]: ../../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[118]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[119]: ../../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[120]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[121]: ../../../references/note-file-kind.md
[122]: ../../../references/pipelines/ci-automation.yaml.md
[123]: ../../../../pipelines/ci-automation.yaml
[124]: ../../design/a-push-fires-only-touched-pipelines.md
[125]: ../../../adr/glossary.md#world-map
[126]: ../../../adr/glossary.md#track
[127]: ../../../adr/glossary.md#file-language
[128]: ../../../adr/glossary.md#cell
[129]: ../../../adr/glossary.md#lit-cell
[130]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[131]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[132]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[133]: ../../../adr/glossary.md#deployable-unit
[134]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[135]: ../../../adr/glossary.md#import
[136]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[137]: ../../../adr/glossary.md#landing-address
[138]: ../../../adr/glossary.md#place
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

# docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md

`Grid minimap: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture`

![Grid minimap of adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture` (architecture lens). The slide supports
[ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 7 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- .claude × markdown: 1 lit of 9 files
- .claude × powershell: 1 lit of 1 file, touched
- automation × csharp: 18 lit of 219 files
- automation × powershell: 22 lit of 1398 files
- automation × yaml: 7 lit of 95 files
- docs × markdown: 23 lit of 469 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/drawio/STYLE.md][5]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 180 (text), line 181 (text), line 186 (text),
  line 194 (text), line 196 (text) and line 197 (text).

### .claude × powershell (1 lit file, touched)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/drawio/minimaps/highlights.ps1][6]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 44 (body comment) (a passing
  mention only).

### automation × csharp (18 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header) and line 7
  (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 24
  (header), line 43 (body comment) and line 47 (body comment).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header)
  and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 6
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and
  line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and line
  4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and line 4
  (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header), line 8
  (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and
  line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (header), line 5
  (header) and line 6 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (header), line 3
  (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line
  25 (header), line 27 (header) and line 270 (text).

### automation × powershell (22 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 99 (text)
  and line 99 (body comment).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 47
  (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (header), line 11
  (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header), line
  9 (header) and line 22 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 8
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 7 (header)
  and line 15 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12 (header) and
  line 33 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (header), line 16
  (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line 68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 14
  (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102 (text), line 106 (text) and line
  107 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (header)
  and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 72 (body
  comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line 61 (text), line 62 (text), line 63 (text), line
  64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81 (text), line 90 (text), line 91
  (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text) and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 104
  (text) and line 119 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][45]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 7
  (header), line 8 (header) and line 12 (header).

### automation × yaml (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 12
  (header) and line 95 (text).
- [automation/Catzc.Base.Globs/configs/globs.yml][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 113 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.Languages/configs/glossary.yml][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/configs/maps.yml][51]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (header), line 32
  (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][52]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (text), line
  65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152 (text), line 165 (text), line 177
  (text), line 190 (text), line 192 (text) and line 204 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][53]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (body comment),
  line 48 (body comment) and line 50 (body comment) (a passing mention only).

### docs × markdown (23 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md][54]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md][55]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md][56]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 64 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][57]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md][58]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/adr/design/commit-lifecycle.md][59]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][60]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][61]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][62]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][63]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][64]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][65]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][66]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][67]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107 (text), line 121 (text), line
  137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225 (text), line 239 (text), line
  252 (text), line 265 (text) and line 277 (text).
- [docs/adr/index.md][68]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text).
- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][69]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][70]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/one-unit-one-pipeline.md][71]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text), line 38
  (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][72]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][73]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text),
  line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][74]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 25 (text), line 25 (text), line 29 (text), line 29 (text), line 31 (text), line 31 (text), line 31 (text), line 32 (text) and
  line 33 (text).
- [docs/references/automation/catzc-base-maps.md][75]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text), line 70 (text)
  and line 82 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header).

## Keywords

- [world map][77]
- [track][78]
- [file language][79]
- [cell][80]
- [lit cell][81]
- [.claude][53]: a track
- [automation][53]: a track
- [docs][53]: a track
- [pipelines][53]: a track
- [csharp][50]: a file language
- [markdown][50]: a file language
- [pipeline-yaml][50]: a file language
- [powershell][50]: a file language
- [yaml][50]: a file language

Terms the cited ADRs define:

- [cell][80], defined by [ADR-DSGN-TRACK#10][82]
- [deployable-unit][83], defined by [ADR-DSGN-TRACK#5][84]
- [file language][79], defined by [ADR-DSGN-TRACK#6][3]
- [lit cell][81], defined by [ADR-DSGN-TRACK#12][4]
- [root file][85], defined by [ADR-DSGN-TRACK#7][86]
- [stack violation][87], defined by [ADR-DSGN-TRACK#11][88]
- [track][78], defined by [ADR-DSGN-TRACK#1][2]
- [unlisted file][89], defined by [ADR-DSGN-TRACK#8][90]
- [value-chain concern][91], defined by [ADR-DSGN-TRACK#15][92]
- [value-chain map][93], defined by [ADR-DSGN-TRACK#16][94]
- [value-chain stack][95], defined by [ADR-DSGN-TRACK#14][96]
- [verification track][97], defined by [ADR-DSGN-TRACK#2][98]
- [world map][77], defined by [ADR-DSGN-TRACK#9][99]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/drawio/STYLE.md
[6]: ../../../.claude/drawio/minimaps/highlights.ps1
[7]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[8]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[9]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[10]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[11]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[12]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[13]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[14]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[15]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[16]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[17]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[18]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[19]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[20]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[21]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[22]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[23]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[24]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[25]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[26]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[27]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[28]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[29]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[30]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[31]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[32]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[33]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[34]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[35]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[36]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[37]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[38]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[39]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[40]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[41]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[42]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[43]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[44]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[45]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[46]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[47]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[48]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[49]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[50]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[51]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[52]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[53]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[54]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
[55]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
[56]: adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
[57]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[58]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
[59]: ../../adr/design/commit-lifecycle.md
[60]: ../../adr/design/dora-explains.md
[61]: ../../adr/design/module-aspects.md
[62]: ../../adr/design/run-modes.md
[63]: ../../adr/design/self-service.md
[64]: ../../adr/design/server-remote-integration.md
[65]: ../../adr/design/thin-platforms.md
[66]: ../../adr/design/visual-design.md
[67]: ../../adr/glossary.md
[68]: ../../adr/index.md
[69]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[70]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[71]: ../../explanation/design/one-unit-one-pipeline.md
[72]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[73]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[74]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[75]: ../../references/automation/catzc-base-maps.md
[76]: ../../../pipelines/ci-automation.yaml
[77]: ../../adr/glossary.md#world-map
[78]: ../../adr/glossary.md#track
[79]: ../../adr/glossary.md#file-language
[80]: ../../adr/glossary.md#cell
[81]: ../../adr/glossary.md#lit-cell
[82]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[83]: ../../adr/glossary.md#deployable-unit
[84]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[85]: ../../adr/glossary.md#root-file
[86]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[87]: ../../adr/glossary.md#stack-violation
[88]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
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

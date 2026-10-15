# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md

`Grid minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Grid minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.png)

The grid minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 26 lit of 229 files
- automation × powershell: 66 lit of 1445 files
- automation × yaml: 11 lit of 97 files
- docs × markdown: 13 lit of 745 files
- pipelines × pipeline-yaml: 6 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.github/workflows/ci-automation.yml][7]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (body comment) (a passing
  mention only).

### automation × csharp (26 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header) and line 7
  (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 24
  (header), line 43 (body comment) and line 47 (body comment).
- [automation/Catzc.Base.Globs/types/Aspect.cs][11]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][12]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header) and line
  7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][13]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header), line 8
  (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57 (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][14]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 5
  (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32 (body comment), line 41 (body
  comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158 (body comment) and line 180
  (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][15]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 7
  (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text) and line 172 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][16]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][18]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][20]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header)
  and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 6
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and
  line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and line
  4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and line 4
  (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header), line 9
  (header) and line 12 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and
  line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (header), line 5
  (header) and line 6 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (header), line 3
  (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line
  25 (header), line 27 (header) and line 270 (text).

### automation × powershell (66 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][34]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][35]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][36]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][37]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][38]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][39]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 99 (text)
  and line 99 (body comment).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][41]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][42]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header) and
  line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][43]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][44]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header) and line 9
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][45]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header) and line
  10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][46]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header) and
  line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][47]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][48]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72 (body comment),
  line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][49]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][50]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][51]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][52]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][53]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header),
  line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][54]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][55]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][56]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][57]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][58]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][59]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][60]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][61]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][62]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][63]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][65]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][67]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][69]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][70]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][71]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1
  (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][72]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header),
  line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][73]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text);
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75
  (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][74]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][75]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 47
  (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (header), line 11
  (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][77]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header), line
  9 (header) and line 22 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][78]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 8
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][79]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 7 (header)
  and line 19 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][80]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12 (header) and
  line 33 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][81]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (header), line 16
  (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line 68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][82]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 14
  (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102 (text), line 106 (text) and line
  107 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][83]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (header)
  and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][85]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 75 (body
  comment) and line 91 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][87]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74
  (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line 61 (text), line 62 (text), line 63 (text), line
  64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][89]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81 (text), line 90 (text), line 91
  (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text) and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][91]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][92]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 69
  (text), line 113 (text) and line 127 (text).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][93]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 8
  (header) and line 89 (body comment).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][94]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][95]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][97]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][98]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 7
  (header), line 8 (header) and line 12 (header).

### automation × yaml (11 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][100]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][101]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 12
  (header) and line 95 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][3]:
  the file cites it at line 309 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][102]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 32 (body comment) and
  line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][103]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 17 (text).
- [automation/Catzc.Base.Globs/configs/globs.yml][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 113 (body comment) (a
  passing mention only); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header), line 7 (header), line 15 (header), line
  17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.Languages/configs/glossary.yml][105]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][106]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/configs/maps.yml][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (header), line 32
  (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (text), line
  65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152 (text), line 165 (text), line 177
  (text), line 190 (text), line 192 (text) and line 204 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 318 (text)
  and line 321 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (body comment),
  line 48 (body comment) and line 50 (body comment) (a passing mention only).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/design/dora-explains.md][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][112]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 94 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/glossary.md][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107 (text), line 121 (text), line
  137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225 (text), line 239 (text), line
  252 (text), line 265 (text) and line 277 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 765 (text).
- [docs/adr/index.md][114]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 111 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 287 (text).
- [docs/adr/repository/conventional-folders.md][3]: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][115]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 13 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][116]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18
  (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][117]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line 30 (text), line 31 (text) and
  line 32 (text).
- [docs/references/automation/catzc-base-globs.md][118]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][119]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 47 (text) and line
  77 (text).
- [docs/references/automation/catzc-base-maps.md][120]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text), line 70 (text)
  and line 82 (text).

### pipelines × pipeline-yaml (6 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/cd-apex.yaml][121]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (header).
- [pipelines/cd-flux.yaml][122]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (header).
- [pipelines/cd-nova.yaml][123]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (header).
- [pipelines/cd-shared.yaml][124]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29 (header).
- [pipelines/ci-automation.yaml][125]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][126]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (header).

## Keywords

- [world map][127]
- [track][128]
- [file language][129]
- [cell][130]
- [lit cell][131]
- [.github][110]: a track
- [automation][110]: a track
- [docs][110]: a track
- [pipelines][110]: a track
- [csharp][106]: a file language
- [markdown][106]: a file language
- [pipeline-yaml][106]: a file language
- [powershell][106]: a file language
- [yaml][106]: a file language

Terms the cited ADRs define:

- [cell][130], defined by [ADR-DSGN-TRACK#10][132]
- [deployable-unit][133], defined by [ADR-DSGN-TRACK#5][134]
- [domain][135], defined by [ADR-REPO-FOLDERS#5][136]
- [file language][129], defined by [ADR-DSGN-TRACK#6][5]
- [lit cell][131], defined by [ADR-DSGN-TRACK#12][6]
- [root file][137], defined by [ADR-DSGN-TRACK#7][138]
- [stack violation][139], defined by [ADR-DSGN-TRACK#11][140]
- [track][128], defined by [ADR-DSGN-TRACK#1][4]
- [unlisted file][141], defined by [ADR-DSGN-TRACK#8][142]
- [value-chain concern][143], defined by [ADR-DSGN-TRACK#15][144]
- [value-chain map][145], defined by [ADR-DSGN-TRACK#16][146]
- [value-chain stack][147], defined by [ADR-DSGN-TRACK#14][148]
- [verification track][149], defined by [ADR-DSGN-TRACK#2][150]
- [world map][127], defined by [ADR-DSGN-TRACK#9][151]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/repository/conventional-folders.md
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../.github/workflows/ci-automation.yml
[8]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[9]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[10]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[11]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[12]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[13]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[14]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[15]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[16]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[17]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[18]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[19]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[20]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[21]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[22]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[23]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[24]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[25]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[26]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[27]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[28]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[29]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[30]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[31]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[32]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[33]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[34]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[35]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[36]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[37]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[38]: ../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[39]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[40]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[41]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[42]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[43]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[44]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[45]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[46]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[47]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[48]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[49]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[50]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[51]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[52]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[53]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[54]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[55]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[56]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[57]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[58]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[59]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[60]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[61]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[62]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[63]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[64]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[65]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[66]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[67]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[68]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[69]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[70]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[71]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[72]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[73]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[74]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[75]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[76]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[77]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[78]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[79]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[80]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[81]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[82]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[83]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[84]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[85]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[86]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[87]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[88]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[89]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[90]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[91]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[92]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[93]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[94]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[95]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[96]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[97]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[98]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[99]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[100]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[101]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[102]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[103]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[104]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[105]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[106]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[107]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[108]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[109]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[110]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[111]: ../../adr/design/dora-explains.md
[112]: ../../adr/flow/dora-explains.md
[113]: ../../adr/glossary.md
[114]: ../../adr/index.md
[115]: ../../adr/repository/dora-explains.md
[116]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[117]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[118]: ../../references/automation/catzc-base-globs.md
[119]: ../../references/automation/catzc-base-languages.md
[120]: ../../references/automation/catzc-base-maps.md
[121]: ../../../pipelines/cd-apex.yaml
[122]: ../../../pipelines/cd-flux.yaml
[123]: ../../../pipelines/cd-nova.yaml
[124]: ../../../pipelines/cd-shared.yaml
[125]: ../../../pipelines/ci-automation.yaml
[126]: ../../../pipelines/ci-infrastructure.yaml
[127]: ../../adr/glossary.md#world-map
[128]: ../../adr/glossary.md#track
[129]: ../../adr/glossary.md#file-language
[130]: ../../adr/glossary.md#cell
[131]: ../../adr/glossary.md#lit-cell
[132]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[133]: ../../adr/glossary.md#deployable-unit
[134]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[135]: ../../adr/glossary.md#domain
[136]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[137]: ../../adr/glossary.md#root-file
[138]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[139]: ../../adr/glossary.md#stack-violation
[140]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[141]: ../../adr/glossary.md#unlisted-file
[142]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[143]: ../../adr/glossary.md#value-chain-concern
[144]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[145]: ../../adr/glossary.md#value-chain-map
[146]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[147]: ../../adr/glossary.md#value-chain-stack
[148]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[149]: ../../adr/glossary.md#verification-track
[150]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[151]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

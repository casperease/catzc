# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md

`Grid minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Grid minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.png)

The grid minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD][2], [ADR-FLOW-CD-GLOBS][3] and [ADR-REPO-FOLDERS][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 27 lit of 229 files
- automation × powershell: 66 lit of 1443 files
- automation × yaml: 12 lit of 97 files
- docs × markdown: 14 lit of 744 files
- pipelines × pipeline-yaml: 6 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.claude/CLAUDE.md][8]: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.github/workflows/ci-automation.yml][9]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (body comment) (a passing
  mention only).

### automation × csharp (27 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header) and line 7
  (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 24
  (header), line 43 (body comment) and line 47 (body comment); selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][13]: selected by [ADR-FLOW-CD][2]: the file cites it at line 41 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.Globs/types/Aspect.cs][14]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][15]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header) and line
  7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][16]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header), line 8
  (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57 (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][17]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5
  (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32 (body comment), line 41 (body
  comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158 (body comment) and line 180
  (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][18]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 7
  (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text) and line 172 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][19]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][21]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][23]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header)
  and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 6
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and
  line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and line
  4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and line 4
  (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header), line 9
  (header) and line 12 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and
  line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (header), line 5
  (header) and line 6 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (header), line 3
  (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line
  25 (header), line 27 (header) and line 270 (text).

### automation × powershell (66 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][37]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][38]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][39]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][40]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][41]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][42]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 99 (text)
  and line 99 (body comment).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][44]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][45]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header) and
  line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][46]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][47]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header) and line 9
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][48]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header) and line
  10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][49]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header) and
  line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][50]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][51]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 72 (body comment),
  line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][52]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][53]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][54]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][55]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][56]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header),
  line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][57]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][58]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][59]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][60]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][61]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][62]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][63]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][65]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][67]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][69]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][70]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][71]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][72]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][73]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][74]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1
  (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][75]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header),
  line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text);
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75
  (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][77]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][78]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 47
  (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][79]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (header), line 11
  (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][80]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header), line
  9 (header) and line 22 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][81]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 8
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][82]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 7 (header)
  and line 19 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][83]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12 (header) and
  line 33 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (header), line 16
  (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line 68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][85]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 14
  (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102 (text), line 106 (text) and line
  107 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (header)
  and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][87]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][89]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 75 (body
  comment) and line 91 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and line 71 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][91]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line 61 (text), line 62 (text), line 63 (text), line
  64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][92]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81 (text), line 90 (text), line 91
  (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][93]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text) and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68
  (text), line 112 (text) and line 126 (text).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][96]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8
  (header) and line 89 (body comment).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][97]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][98]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][100]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][101]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 7
  (header), line 8 (header) and line 12 (header).

### automation × yaml (12 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][103]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 12
  (header) and line 95 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 308 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][105]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 32 (body comment) and
  line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][106]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 17 (text).
- [automation/Catzc.Base.Globs/configs/globs.yml][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 113 (body comment) (a
  passing mention only); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 7 (header), line 15 (header), line
  17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.Languages/configs/glossary.yml][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/configs/maps.yml][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (header), line 32
  (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (text), line
  65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152 (text), line 165 (text), line 177
  (text), line 190 (text), line 192 (text) and line 204 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][112]: selected by [ADR-FLOW-CD][2]: the file cites it at line 62 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 318 (text)
  and line 321 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][114]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (body comment),
  line 48 (body comment) and line 50 (body comment) (a passing mention only).

### docs × markdown (14 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [docs/adr/design/dora-explains.md][115]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][116]: selected by [ADR-FLOW-CD][2]: the file cites it at line 13 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 94 (text).
- [docs/adr/flow/durable-sha-globs.md][3]: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.
- [docs/adr/glossary.md][117]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107 (text), line 121 (text), line
  137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225 (text), line 239 (text), line
  252 (text), line 265 (text) and line 277 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 292 (text) and line 305 (text);
  selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 765 (text).
- [docs/adr/index.md][118]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 107 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 111 (text); selected by [ADR-REPO-FOLDERS][4]:
  the file cites it at line 286 (text).
- [docs/adr/repository/conventional-folders.md][4]: selected by [ADR-REPO-FOLDERS][4]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][119]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 13 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][120]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18
  (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][121]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line 30 (text), line 31 (text) and
  line 32 (text).
- [docs/references/automation/catzc-base-globs.md][122]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][123]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 47 (text) and line
  77 (text).
- [docs/references/automation/catzc-base-maps.md][124]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text), line 70 (text)
  and line 82 (text).

### pipelines × pipeline-yaml (6 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][5]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [pipelines/cd-apex.yaml][125]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (header).
- [pipelines/cd-flux.yaml][126]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (header).
- [pipelines/cd-nova.yaml][127]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (header).
- [pipelines/cd-shared.yaml][128]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29 (header).
- [pipelines/ci-automation.yaml][129]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][130]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (header).

## Keywords

- [world map][131]
- [track][132]
- [file language][133]
- [cell][134]
- [lit cell][135]
- [.claude][114]: a track
- [.github][114]: a track
- [automation][114]: a track
- [docs][114]: a track
- [pipelines][114]: a track
- [csharp][109]: a file language
- [markdown][109]: a file language
- [pipeline-yaml][109]: a file language
- [powershell][109]: a file language
- [yaml][109]: a file language

Terms the cited ADRs define:

- [cell][134], defined by [ADR-DSGN-TRACK#10][136]
- [deployable-unit][137], defined by [ADR-DSGN-TRACK#5][138]
- [domain][139], defined by [ADR-REPO-FOLDERS#5][140]
- [file language][133], defined by [ADR-DSGN-TRACK#6][6]
- [gate][141], defined by [ADR-FLOW-CD#13][142]
- [lit cell][135], defined by [ADR-DSGN-TRACK#12][7]
- [release candidate][143], defined by [ADR-FLOW-CD#14][144]
- [root file][145], defined by [ADR-DSGN-TRACK#7][146]
- [stack violation][147], defined by [ADR-DSGN-TRACK#11][148]
- [track][132], defined by [ADR-DSGN-TRACK#1][5]
- [unlisted file][149], defined by [ADR-DSGN-TRACK#8][150]
- [value-chain concern][151], defined by [ADR-DSGN-TRACK#15][152]
- [value-chain map][153], defined by [ADR-DSGN-TRACK#16][154]
- [value-chain stack][155], defined by [ADR-DSGN-TRACK#14][156]
- [verification track][157], defined by [ADR-DSGN-TRACK#2][158]
- [world map][131], defined by [ADR-DSGN-TRACK#9][159]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/flow/durable-sha-globs.md
[4]: ../../adr/repository/conventional-folders.md
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[8]: ../../../.claude/CLAUDE.md
[9]: ../../../.github/workflows/ci-automation.yml
[10]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[11]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[12]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[13]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[14]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[15]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[16]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[17]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[18]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[19]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[20]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[21]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[22]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[23]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[24]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[25]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[26]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[27]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[28]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[29]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[30]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[31]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[32]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[33]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[34]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[35]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[36]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[37]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[38]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[39]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[40]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[41]: ../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[42]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[43]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[44]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[45]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[46]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[47]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[48]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[49]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[50]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[51]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[52]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[53]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[54]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[55]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[56]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[57]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[58]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[59]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[60]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[61]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[62]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[63]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[64]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[65]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[66]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[67]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[68]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[69]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[70]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[71]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[72]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[73]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[74]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[75]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[76]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[77]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[78]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[79]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[80]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[81]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[82]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[83]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[84]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[85]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[86]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[87]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[88]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[89]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[90]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[91]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[92]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[93]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[94]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[95]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[96]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[97]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[98]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[99]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[100]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[101]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[102]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[103]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[104]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[105]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[106]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[107]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[108]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[109]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[110]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[111]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[112]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[113]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[114]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[115]: ../../adr/design/dora-explains.md
[116]: ../../adr/flow/dora-explains.md
[117]: ../../adr/glossary.md
[118]: ../../adr/index.md
[119]: ../../adr/repository/dora-explains.md
[120]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[121]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[122]: ../../references/automation/catzc-base-globs.md
[123]: ../../references/automation/catzc-base-languages.md
[124]: ../../references/automation/catzc-base-maps.md
[125]: ../../../pipelines/cd-apex.yaml
[126]: ../../../pipelines/cd-flux.yaml
[127]: ../../../pipelines/cd-nova.yaml
[128]: ../../../pipelines/cd-shared.yaml
[129]: ../../../pipelines/ci-automation.yaml
[130]: ../../../pipelines/ci-infrastructure.yaml
[131]: ../../adr/glossary.md#world-map
[132]: ../../adr/glossary.md#track
[133]: ../../adr/glossary.md#file-language
[134]: ../../adr/glossary.md#cell
[135]: ../../adr/glossary.md#lit-cell
[136]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[137]: ../../adr/glossary.md#deployable-unit
[138]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[139]: ../../adr/glossary.md#domain
[140]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[141]: ../../adr/glossary.md#gate
[142]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[143]: ../../adr/glossary.md#release-candidate
[144]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[145]: ../../adr/glossary.md#root-file
[146]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[147]: ../../adr/glossary.md#stack-violation
[148]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[149]: ../../adr/glossary.md#unlisted-file
[150]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[151]: ../../adr/glossary.md#value-chain-concern
[152]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[153]: ../../adr/glossary.md#value-chain-map
[154]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[155]: ../../adr/glossary.md#value-chain-stack
[156]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[157]: ../../adr/glossary.md#verification-track
[158]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[159]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

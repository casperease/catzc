# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md

`Grid minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Grid minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.png)

The grid minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD][2], [ADR-FLOW-CD-GLOBS][3] and [ADR-REPO-FOLDERS][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 9 files
- .claude × powershell: 1 lit of 1 file, touched
- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 27 lit of 219 files
- automation × powershell: 65 lit of 1400 files
- automation × yaml: 11 lit of 95 files
- docs × markdown: 294 lit of 741 files
- pipelines × pipeline-yaml: 6 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.claude/CLAUDE.md][8]: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 181 (text), line 182 (text), line 188 (text),
  line 196 (text), line 198 (text), line 199 (text) and line 210 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).

### .claude × powershell (1 lit file, touched)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][5]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.claude/drawio/minimaps/highlights.ps1][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 52 (body comment) (a passing
  mention only).

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.github/workflows/ci-automation.yml][11]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (body comment) (a passing
  mention only).

### automation × csharp (27 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header) and line 7
  (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line 24
  (header), line 43 (body comment) and line 47 (body comment); selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][15]: selected by [ADR-FLOW-CD][2]: the file cites it at line 41 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.Globs/types/Aspect.cs][16]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][17]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header) and line
  7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][18]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header), line 8
  (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57 (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][19]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5
  (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32 (body comment), line 41 (body
  comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158 (body comment) and line 180
  (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][20]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 7
  (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text) and line 172 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][21]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][23]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][25]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header)
  and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 6
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and
  line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3
  (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header) and line
  4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and line 4
  (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header), line 8
  (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (header) and
  line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (header), line 5
  (header) and line 6 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (header), line 3
  (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line
  25 (header), line 27 (header) and line 270 (text).

### automation × powershell (65 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][39]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][40]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][41]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][42]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][43]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 99 (text)
  and line 99 (body comment).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][45]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][46]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header) and
  line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][47]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][48]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header) and line 9
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][49]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header) and line
  10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][50]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header) and
  line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][51]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][52]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 72 (body comment),
  line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][53]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][54]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][55]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][56]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][57]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header),
  line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][58]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][59]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][60]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][61]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][62]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][63]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][65]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][67]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][69]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][70]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][71]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][72]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][73]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][74]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][75]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1
  (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][76]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header),
  line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][77]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text);
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75
  (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][78]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][79]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 47
  (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][80]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (header), line 11
  (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][81]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (header), line
  9 (header) and line 22 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][82]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 8
  (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][83]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header), line 7 (header)
  and line 15 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12 (header) and
  line 33 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][85]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (header), line 16
  (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line 68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 14
  (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102 (text), line 106 (text) and line
  107 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][87]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (header)
  and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][89]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 72 (body
  comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][91]: selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text)
  and line 71 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][92]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line 61 (text), line 62 (text), line 63 (text), line
  64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][93]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header),
  line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81 (text), line 90 (text), line 91
  (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text) and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2
  (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 104
  (text) and line 119 (text).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][97]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8
  (header) and line 89 (body comment).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][98]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][99]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][100]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][101]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][102]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][103]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (header), line 7
  (header), line 8 (header) and line 12 (header).

### automation × yaml (11 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][104]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][105]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (header), line 12
  (header) and line 95 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 307 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][106]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 32 (body comment) and
  line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][107]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 17 (text).
- [automation/Catzc.Base.Globs/configs/globs.yml][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 113 (body comment) (a
  passing mention only); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 7 (header), line 15 (header), line
  17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.Languages/configs/glossary.yml][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Maps/configs/maps.yml][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (header), line 32
  (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][112]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (text), line
  65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152 (text), line 165 (text), line 177
  (text), line 190 (text), line 192 (text) and line 204 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][113]: selected by [ADR-FLOW-CD][2]: the file cites it at line 62 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][114]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (body comment),
  line 48 (body comment) and line 50 (body comment) (a passing mention only).

### docs × markdown (294 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][115]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][116]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 42 (text), line
  43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68 (text), line 192
  (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][117]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][118]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68
  (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][119]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][120]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 42 (text), line 43
  (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68 (text), line 192 (text),
  line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][121]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text), line 42 (text), line 45
  (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][122]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 28 (text), line 29 (text), line 29 (text), line 36 (text), line 37 (text), line 37 (text), line 44 (text), line 45
  (text), line 45 (text), line 102 (text), line 103 (text), line 103 (text), line 112 (text), line 113 (text), line 113 (text), line 280
  (text), line 281 (text), line 281 (text), line 290 (text), line 291 (text) and line 291 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][123]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][124]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 42 (text), line 43
  (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68 (text), line 192 (text),
  line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][125]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][126]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 42 (text), line
  43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68 (text), line 192
  (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][127]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text), line 42 (text), line 45
  (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][128]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 27 (text), line 28 (text), line 28 (text), line 35 (text), line 36 (text), line 36 (text), line 43 (text), line 44
  (text), line 44 (text), line 101 (text), line 102 (text), line 102 (text), line 111 (text), line 112 (text), line 112 (text), line 279
  (text), line 280 (text), line 280 (text), line 289 (text), line 290 (text) and line 290 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][129]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 28 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40 (text), line 44 (text), line 47
  (text), line 48 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 59 (text), line 61 (text), line 62 (text),
  line 66 (text), line 69 (text), line 70 (text), line 72 (text), line 73 (text), line 77 (text), line 80 (text) and line 81 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][130]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 29 (text), line 30 (text), line 30 (text), line 38 (text), line 39 (text), line 39 (text), line 46 (text), line 47
  (text), line 47 (text), line 175 (text), line 176 (text), line 176 (text), line 306 (text), line 307 (text), line 307 (text), line 330
  (text), line 331 (text), line 331 (text), line 613 (text), line 614 (text), line 614 (text), line 629 (text), line 630 (text) and line 630
  (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][131]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][132]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 42 (text), line 43
  (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68 (text), line 192 (text),
  line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][133]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 28 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40 (text), line 44 (text), line 47
  (text), line 48 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 59 (text), line 63 (text), line 66 (text),
  line 67 (text), line 71 (text), line 74 (text) and line 75 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][134]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 30 (text), line 31 (text), line 31 (text), line 41 (text), line 42 (text), line 42 (text), line 49 (text), line 50
  (text), line 50 (text), line 68 (text), line 69 (text), line 69 (text), line 755 (text), line 756 (text), line 756 (text), line 790
  (text), line 791 (text), line 791 (text), line 1039 (text), line 1040 (text), line 1040 (text), line 1047 (text), line 1048 (text), line
  1048 (text), line 1061 (text), line 1062 (text) and line 1062 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md][135]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md][136]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text), line 40 (text), line 41
  (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.chain.md][137]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.grid.md][138]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text), line 40 (text), line 41
  (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md][139]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md][140]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 29 (text), line 30 (text), line 30 (text), line 41 (text), line 42 (text), line 42 (text), line 62 (text), line 63
  (text), line 63 (text), line 672 (text), line 673 (text), line 673 (text), line 703 (text), line 704 (text), line 704 (text), line 844
  (text), line 845 (text), line 845 (text), line 852 (text), line 853 (text), line 853 (text), line 863 (text), line 864 (text) and line 864
  (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md][141]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md][142]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text),
  line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md][143]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md][144]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text), line 40 (text), line
  41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.chain.md][145]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.grid.md][146]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 54 (text), line 55
  (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md][147]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md][148]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 54 (text), line
  55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.chain.md][149]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.grid.md][150]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 54 (text), line 55
  (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md][151]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md][152]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 54 (text), line 55
  (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md][153]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md][154]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 54 (text), line 55
  (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md][155]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md][156]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line 36 (text), line 58 (text), line
  59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md][157]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md][158]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line 36 (text),
  line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][159]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text) and line
  39 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][160]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 29 (text), line 30 (text), line 30 (text), line 40 (text), line 41 (text), line 41 (text), line 62 (text), line 63
  (text), line 63 (text), line 693 (text), line 694 (text), line 694 (text), line 724 (text), line 725 (text), line 725 (text), line 879
  (text), line 880 (text), line 880 (text), line 887 (text), line 888 (text), line 888 (text), line 898 (text), line 899 (text) and line 899
  (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md][161]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md][162]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line 36 (text), line 58 (text), line 59
  (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.chain.md][163]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md][164]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line 36 (text), line 58 (text), line
  59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md][165]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md][166]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 47 (text), line
  48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md][167]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md][168]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 47 (text), line 48
  (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md][169]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text) and line 36
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md][170]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md][171]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md][172]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][173]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36 (text),
  line 39 (text), line 40 (text), line 44 (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text) and line 54
  (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 30 (text) and line 30 (text); selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 52 (text), line 52 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][174]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 66 (text) and line 76 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at
  line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][175]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 29 (text), line 29 (text), line 35 (text), line 36 (text), line 36 (text),
  line 43 (text), line 44 (text), line 44 (text), line 66 (text), line 67 (text), line 67 (text), line 157 (text), line 158 (text), line 158
  (text), line 177 (text), line 178 (text), line 178 (text), line 381 (text), line 382 (text) and line 382 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 38 (text), line 47 (text), line 48 (text), line 50 (text), line 52
  (text), line 56 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 78 (text), line 79 (text), line 81 (text),
  line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 93 (text), line 95 (text), line 97
  (text), line 98 (text), line 100 (text), line 102 (text), line 103 (text), line 104 (text), line 106 (text), line 108 (text), line 110
  (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 122 (text), line 124 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 135 (text), line 137 (text), line 139 (text), line 143 (text), line 146 (text), line 149
  (text), line 151 (text), line 160 (text), line 163 (text), line 169 (text), line 191 (text), line 196 (text), line 199 (text), line 201
  (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 212 (text), line 215 (text), line 217
  (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 247 (text), line 338
  (text), line 342 (text), line 346 (text), line 350 (text), line 352 (text), line 354 (text), line 356 (text), line 359 (text), line 361
  (text), line 363 (text), line 365 (text), line 367 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line 384
  (text), line 385 (text), line 386 (text), line 387 (text), line 388 (text) and line 389 (text); selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 8 (text), line 58 (text), line 59 (text), line 60 (text), line 77 (text), line 141 (text), line 164 (text), line 166
  (text), line 168 (text), line 193 (text), line 196 (text), line 246 (text), line 249 (text), line 302 (text), line 304 (text), line 306
  (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text), line 320 (text), line 322
  (text), line 324 (text), line 326 (text), line 328 (text), line 330 (text), line 335 (text), line 348 (text), line 351 (text), line 376
  (text) and line 411 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md][176]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48
  (text), line 50 (text), line 53 (text), line 55 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 66 (text),
  line 67 (text), line 70 (text), line 72 (text), line 75 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85
  (text), line 87 (text), line 89 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text),
  line 107 (text), line 108 (text), line 111 (text), line 114 (text), line 115 (text), line 117 (text), line 120 (text), line 124 (text),
  line 143 (text), line 148 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text),
  line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 177 (text), line 183 (text), line 186 (text), line 190 (text),
  line 193 (text), line 195 (text), line 197 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text),
  line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 356 (text), line 363 (text), line 365 (text), line 368 (text),
  line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 384 (text), line 391 (text), line 393 (text),
  line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 409 (text), line 411 (text), line 413 (text), line 415 (text),
  line 417 (text), line 424 (text), line 464 (text), line 478 (text) and line 485 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 8 (text), line 145 (text), line 148 (text), line 173 (text), line 189 (text), line 191 (text), line 218 (text), line 298
  (text), line 300 (text), line 302 (text), line 304 (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314
  (text), line 316 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 326 (text), line 425 (text), line 427
  (text), line 429 (text), line 431 (text), line 451 (text), line 453 (text), line 455 (text), line 462 (text), line 465 (text), line 493
  (text) and line 515 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][177]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text), line 36 (text), line 40 (text), line
  43 (text) and line 44 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][178]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 24 (text), line 24 (text), line 30 (text), line 31 (text), line 31 (text), line 38 (text), line
  39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][179]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36 (text),
  line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and line 54
  (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][180]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][181]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39
  (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][182]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 23 (text), line 24 (text), line 24 (text), line 33 (text), line 34 (text), line 34 (text), line 44 (text), line 45 (text) and
  line 45 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][183]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text), line 59
  (text), line 60 (text), line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28
  (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and
  line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][184]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][185]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line 36 (text), line 45 (text), line
  46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text) and line 67 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line
  49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text),
  line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line
  128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line
  156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][186]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line
  67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109
  (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153
  (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179
  (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233
  (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][187]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line
  40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][188]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 45 (text), line
  46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][189]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text), line 40 (text), line
  41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text), line 59 (text), line 60 (text),
  line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line
  39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][190]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][191]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line 36 (text), line 45 (text), line
  46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text) and line 67 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line
  49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text),
  line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line
  128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line
  156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][192]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text),
  line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text),
  line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and
  line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][193]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text), line 40 (text), line
  41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text), line 59 (text), line 60 (text),
  line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line
  39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][194]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][195]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line 36 (text), line 45 (text), line
  46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text) and line 67 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line
  49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text),
  line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line
  128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line
  156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][196]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text),
  line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text),
  line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and
  line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][197]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40
  (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][198]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 45 (text), line 46
  (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][199]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39 (text), line
  41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][200]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 23 (text), line 24 (text), line 24 (text), line 33 (text), line 34 (text), line 34 (text), line 44 (text), line 45 (text) and
  line 45 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][201]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40
  (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][202]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text), line 45 (text), line 46
  (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][203]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text), line 36 (text), line 40 (text), line 43
  (text) and line 44 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][204]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 24 (text), line 24 (text), line 30 (text), line 31 (text), line 31 (text), line 38 (text), line 39
  (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][205]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text), line 40 (text), line 41
  (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text), line 59 (text), line 60 (text),
  line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line
  39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][206]: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][207]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line 36 (text), line 45 (text), line 46
  (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text) and line 67 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line
  49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text),
  line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line
  128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line
  156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][208]: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67 (text),
  line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text), line 110
  (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text), line 155
  (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text), line 186
  (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and line 235
  (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][209]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39 (text), line 41 (text), line 42
  (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text), line 53 (text), line 55 (text), line 56 (text), line 58 (text),
  line 59 (text), line 63 (text), line 66 (text), line 67 (text), line 69 (text), line 70 (text), line 72 (text), line 73 (text), line 77
  (text), line 80 (text) and line 81 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 29
  (text), line 43 (text), line 43 (text), line 57 (text), line 57 (text), line 71 (text), line 71 (text), line 96 (text) and line 100
  (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][210]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][211]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 29 (text), line 30 (text), line 30 (text), line 46 (text), line 47 (text), line 47 (text), line 65 (text), line 66
  (text), line 66 (text), line 679 (text), line 680 (text), line 680 (text), line 714 (text), line 715 (text), line 715 (text), line 959
  (text), line 960 (text), line 960 (text), line 967 (text), line 968 (text), line 968 (text), line 978 (text), line 979 (text) and line 979
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 32 (text), line 42 (text), line 49 (text), line 52 (text),
  line 309 (text), line 310 (text), line 316 (text), line 688 (text), line 700 (text), line 705 (text), line 730 (text), line 734 (text),
  line 736 (text), line 747 (text), line 750 (text), line 756 (text), line 759 (text), line 760 (text), line 762 (text), line 764 (text),
  line 867 (text), line 869 (text), line 870 (text), line 872 (text), line 874 (text), line 876 (text), line 879 (text), line 882 (text),
  line 901 (text), line 905 (text), line 911 (text), line 925 (text), line 930 (text), line 931 (text), line 933 (text), line 935 (text),
  line 939 (text), line 943 (text), line 1012 (text) and line 1016 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][212]: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 114 (text), line 343 (text), line 348 (text), line 350 (text), line 362 (text), line 366 (text), line 373
  (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line 405 (text), line 409 (text), line 415 (text), line 429
  (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 446 (text), line 450 (text), line 568 (text), line 632
  (text), line 635 (text), line 730 (text), line 846 (text), line 847 (text), line 858 (text), line 1016 (text), line 1027 (text), line 1033
  (text), line 1035 (text), line 1037 (text), line 1039 (text), line 1041 (text), line 1043 (text), line 1211 (text), line 1214 (text), line
  1296 (text) and line 1300 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][213]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text), line 40 (text), line 41
  (text), line 45 (text), line 48 (text), line 49 (text), line 53 (text), line 56 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][214]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text), line 40 (text), line 41
  (text) and line 41 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md][215]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md][216]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][217]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39 (text), line 41 (text), line
  42 (text), line 46 (text), line 49 (text), line 50 (text), line 54 (text), line 57 (text), line 58 (text), line 62 (text), line 65 (text)
  and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][218]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 33 (text), line 34 (text), line 34 (text), line 40 (text), line
  41 (text), line 41 (text), line 48 (text), line 49 (text), line 49 (text), line 58 (text), line 59 (text) and line 59 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md][219]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md][220]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md][221]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md][222]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][223]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][224]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text), line 79 (text), line 80
  (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][225]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][226]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text), line 79 (text), line
  80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][227]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][228]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text),
  line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and
  line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][229]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][230]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text), line 79 (text), line
  80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][231]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][232]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text), line 79 (text), line
  80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][233]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][234]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][235]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][236]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][237]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][238]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 39 (text), line 40 (text), line 40 (text),
  line 50 (text), line 51 (text) and line 51 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][239]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][240]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][241]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39 (text), line 43 (text), line 46
  (text), line 47 (text), line 51 (text), line 54 (text), line 55 (text), line 59 (text), line 62 (text) and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][242]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 25 (text), line 26 (text), line 26 (text), line 41 (text), line 42 (text), line 42 (text), line 52 (text), line 53
  (text), line 53 (text), line 209 (text), line 210 (text) and line 210 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md][243]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line 26 (text), line 38 (text), line
  39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text),
  line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md][244]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md][245]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line 35 (text), line 36 (text), line
  36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text),
  line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text), line 82 (text), line 82 (text),
  line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98
  (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 116
  (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132 (text), line 133 (text), line 133
  (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143 (text), line 146 (text), line 151
  (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161 (text), line 163 (text), line 164
  (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 178
  (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194
  (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226 (text), line 227 (text), line 228
  (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234 (text), line 235 (text), line 236
  (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md][246]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line
  47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 63 (text), line 68 (text),
  line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text), line 106 (text), line 108
  (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 124
  (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145
  (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text), line 164 (text), line 171
  (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text), line 226 (text), line 235
  (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text), line 268 (text), line 269
  (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md][247]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 23 (text), line 25 (text), line 25 (text), line 26 (text), line 27 (text),
  line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47
  (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md][248]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md][249]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line 35 (text),
  line 36 (text), line 36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text),
  line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text), line 82
  (text), line 82 (text), line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text),
  line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line
  113 (text), line 116 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132 (text), line
  133 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143 (text), line
  146 (text), line 151 (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161 (text), line
  163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175 (text), line
  177 (text), line 178 (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line
  192 (text), line 194 (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226 (text), line
  227 (text), line 228 (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234 (text), line
  235 (text), line 236 (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md][250]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text),
  line 44 (text), line 47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 63
  (text), line 68 (text), line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 124 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143
  (text), line 145 (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text), line 164
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text), line 226
  (text), line 235 (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text), line 268
  (text), line 269 (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.chain.md][251]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 7 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line 26 (text), line 38 (text), line 39 (text), line 40
  (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text), line 48 (text),
  line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md][252]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 64 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.grid.md][253]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 7 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line 35 (text), line 36 (text), line 36 (text), line 38
  (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text),
  line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69
  (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text), line 82 (text), line 82 (text), line 84 (text),
  line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100
  (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 116 (text), line 119
  (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132 (text), line 133 (text), line 133 (text), line 135
  (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143 (text), line 146 (text), line 151 (text), line 152
  (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161 (text), line 163 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 178 (text), line 180
  (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197
  (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226 (text), line 227 (text), line 228 (text), line 229
  (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234 (text), line 235 (text), line 236 (text), line 237
  (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md][254]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 7 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 47 (text), line 50
  (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 63 (text), line 68 (text), line 71 (text),
  line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 124 (text), line 131
  (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147
  (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text), line 164 (text), line 171 (text), line 173
  (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 199
  (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text), line 226 (text), line 235 (text), line 241
  (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text), line 268 (text), line 269 (text), line 270
  (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][255]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 30 (text), line 31 (text), line 32 (text),
  line 34 (text), line 35 (text), line 39 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 55
  (text), line 58 (text), line 59 (text), line 63 (text), line 66 (text), line 67 (text), line 71 (text), line 74 (text), line 75 (text),
  line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98
  (text), line 99 (text), line 100 (text), line 101 (text) and line 102 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8
  (text), line 41 (text), line 41 (text), line 49 (text), line 49 (text), line 57 (text), line 57 (text), line 65 (text), line 65 (text),
  line 91 (text) and line 93 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 33 (text) and line 33
  (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 73 (text), line 73 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][256]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 60 (text) and line 68 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  60 (text) and line 68 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][257]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 29 (text), line 30 (text), line 30 (text), line 33 (text), line 38 (text), line 39 (text), line
  39 (text), line 41 (text), line 46 (text), line 47 (text), line 47 (text), line 54 (text), line 55 (text), line 55 (text), line 57 (text),
  line 59 (text), line 60 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89
  (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102 (text), line 104 (text),
  line 109 (text), line 110 (text), line 110 (text), line 121 (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text),
  line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 201 (text), line 203 (text),
  line 205 (text), line 207 (text), line 211 (text), line 214 (text), line 217 (text), line 219 (text), line 221 (text), line 228 (text),
  line 234 (text), line 239 (text), line 240 (text), line 240 (text), line 244 (text), line 250 (text), line 253 (text), line 254 (text),
  line 255 (text), line 257 (text), line 261 (text), line 266 (text), line 267 (text), line 267 (text), line 283 (text), line 285 (text),
  line 286 (text), line 289 (text), line 292 (text), line 323 (text), line 325 (text), line 327 (text), line 329 (text), line 330 (text),
  line 332 (text), line 334 (text), line 336 (text), line 337 (text), line 351 (text), line 355 (text), line 388 (text), line 398 (text),
  line 404 (text), line 411 (text), line 415 (text), line 452 (text), line 458 (text), line 463 (text), line 464 (text), line 464 (text),
  line 470 (text), line 494 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 502 (text), line 503 (text),
  line 504 (text), line 505 (text), line 506 (text), line 507 (text), line 508 (text) and line 509 (text); selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 61 (text), line 63 (text), line 189 (text), line 195 (text), line 209
  (text), line 245 (text), line 259 (text), line 260 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line 280
  (text), line 293 (text), line 296 (text), line 297 (text), line 299 (text), line 301 (text), line 339 (text), line 341 (text), line 343
  (text), line 345 (text), line 347 (text), line 349 (text), line 353 (text), line 355 (text), line 392 (text), line 396 (text), line 400
  (text), line 409 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 436 (text), line 444 (text), line 498
  (text) and line 500 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 49 (text), line 65 (text), line
  66 (text), line 68 (text), line 70 (text), line 74 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 123
  (text), line 124 (text), line 126 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136
  (text), line 137 (text), line 139 (text), line 141 (text), line 142 (text), line 144 (text), line 146 (text), line 147 (text), line 148
  (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164
  (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 181
  (text), line 225 (text), line 226 (text), line 230 (text), line 232 (text), line 242 (text), line 246 (text), line 251 (text), line 270
  (text), line 289 (text), line 304 (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316
  (text), line 317 (text), line 320 (text), line 322 (text), line 340 (text), line 342 (text), line 344 (text), line 346 (text), line 348
  (text), line 350 (text), line 356 (text), line 394 (text), line 402 (text), line 406 (text), line 413 (text), line 425 (text), line 427
  (text), line 429 (text), line 432 (text), line 434 (text), line 438 (text), line 440 (text), line 442 (text), line 446 (text), line 448
  (text), line 450 (text), line 455 (text), line 466 (text), line 467 (text), line 468 (text), line 469 (text), line 471 (text) and line 472
  (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 76 (text), line 78 (text), line 80 (text), line 120
  (text), line 223 (text), line 246 (text), line 247 (text), line 249 (text), line 270 (text), line 290 (text), line 354 (text), line 356
  (text), line 358 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 368 (text), line 370 (text), line 372
  (text), line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text), line 390
  (text), line 407 (text), line 413 (text), line 456 (text) and line 496 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][258]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 63 (text), line 94 (text), line
  104 (text), line 110 (text), line 117 (text), line 121 (text), line 159 (text), line 166 (text), line 199 (text), line 238 (text), line
  260 (text), line 262 (text), line 265 (text), line 267 (text), line 269 (text), line 271 (text), line 274 (text), line 277 (text), line
  279 (text), line 282 (text), line 283 (text), line 285 (text), line 290 (text), line 293 (text), line 298 (text), line 301 (text), line
  303 (text), line 304 (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line
  318 (text), line 320 (text), line 322 (text), line 324 (text), line 366 (text), line 376 (text), line 378 (text), line 380 (text), line
  382 (text), line 392 (text), line 394 (text), line 396 (text), line 399 (text), line 402 (text), line 406 (text), line 415 (text), line
  417 (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line
  445 (text), line 483 (text), line 507 (text), line 509 (text), line 511 (text), line 513 (text), line 521 (text), line 524 (text), line
  533 (text), line 542 (text), line 546 (text), line 584 (text), line 585 (text), line 587 (text), line 589 (text), line 591 (text), line
  592 (text), line 593 (text), line 594 (text), line 595 (text), line 596 (text), line 597 (text), line 598 (text) and line 599 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 98 (text), line 102 (text), line 106 (text),
  line 115 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 143 (text), line 151 (text), line 263 (text),
  line 270 (text), line 288 (text), line 367 (text), line 383 (text), line 385 (text), line 440 (text), line 455 (text), line 458 (text),
  line 460 (text), line 462 (text), line 465 (text), line 468 (text), line 520 (text), line 522 (text), line 535 (text), line 544 (text),
  line 547 (text), line 588 (text) and line 590 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 41
  (text), line 60 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 100 (text), line 108 (text), line 113 (text), line 119 (text), line 132 (text), line
  134 (text), line 136 (text), line 139 (text), line 141 (text), line 145 (text), line 147 (text), line 149 (text), line 153 (text), line
  155 (text), line 157 (text), line 162 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  183 (text), line 185 (text), line 187 (text), line 190 (text), line 192 (text), line 193 (text), line 195 (text), line 198 (text), line
  200 (text), line 202 (text), line 204 (text), line 207 (text), line 208 (text), line 211 (text), line 213 (text), line 215 (text), line
  217 (text), line 219 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line
  233 (text), line 235 (text), line 236 (text), line 239 (text), line 241 (text), line 243 (text), line 245 (text), line 248 (text), line
  252 (text), line 368 (text), line 438 (text), line 443 (text), line 447 (text), line 449 (text), line 456 (text), line 459 (text), line
  461 (text), line 463 (text), line 466 (text), line 469 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line
  484 (text), line 485 (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 547 (text), line
  554 (text) and line 561 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 41 (text), line 61 (text),
  line 96 (text), line 113 (text), line 119 (text), line 164 (text), line 331 (text), line 333 (text), line 335 (text), line 337 (text),
  line 339 (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 351 (text), line 353 (text),
  line 355 (text), line 357 (text), line 359 (text), line 368 (text), line 370 (text), line 372 (text), line 374 (text), line 400 (text),
  line 404 (text), line 408 (text), line 532 (text), line 545 (text), line 548 (text) and line 586 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md][259]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line 26 (text),
  line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text), line 46
  (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md][260]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md][261]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line 35 (text), line 36 (text), line
  36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text),
  line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text), line 82 (text), line 82 (text),
  line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98
  (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 116
  (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132 (text), line 133 (text), line 133
  (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143 (text), line 146 (text), line 151
  (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161 (text), line 163 (text), line 164
  (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 178
  (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194
  (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226 (text), line 227 (text), line 228
  (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234 (text), line 235 (text), line 236
  (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md][262]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 8 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line
  47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 63 (text), line 68 (text),
  line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text), line 106 (text), line 108
  (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 124
  (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145
  (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text), line 164 (text), line 171
  (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text), line 226 (text), line 235
  (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text), line 268 (text), line 269
  (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md][263]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text), line 41 (text), line 44 (text), line
  45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27
  (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51 (text), line 65 (text) and
  line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][264]: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md][265]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text), line 43 (text), line 44 (text), line
  44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line
  47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89
  (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text),
  line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and
  line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md][266]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text), line 115
  (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md][267]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text),
  line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text),
  line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][268]: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md][269]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text),
  line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text),
  line 46 (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70
  (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98
  (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114
  (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md][270]: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text),
  line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and
  line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md][271]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 26 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 37 (text), line 40 (text), line 41
  (text), line 43 (text), line 44 (text), line 48 (text), line 51 (text), line 52 (text), line 54 (text), line 55 (text), line 59 (text),
  line 62 (text), line 63 (text), line 65 (text) and line 66 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line
  28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 78 (text)
  and line 79 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][272]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md][273]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 27 (text), line 28 (text), line 28 (text), line 35 (text), line 36 (text), line 36 (text), line 49 (text), line 50
  (text), line 50 (text), line 68 (text), line 69 (text), line 69 (text), line 80 (text), line 81 (text), line 81 (text), line 141 (text),
  line 142 (text) and line 142 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 30 (text), line 31 (text),
  line 42 (text), line 44 (text), line 61 (text), line 62 (text), line 63 (text), line 73 (text), line 75 (text), line 76 (text), line 83
  (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 96 (text), line 97 (text), line 99 (text),
  line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text),
  line 116 (text), line 118 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text),
  line 131 (text), line 134 (text), line 136 (text), line 166 (text) and line 167 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md][274]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48
  (text), line 50 (text), line 53 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 74 (text), line 76 (text), line 100 (text), line 103 (text), line 105 (text), line
  107 (text), line 109 (text), line 111 (text), line 118 (text), line 120 (text), line 122 (text), line 129 (text), line 131 (text), line
  133 (text), line 140 (text), line 141 (text), line 147 (text), line 149 (text), line 179 (text), line 186 (text), line 208 (text) and line
  209 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md][275]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text), line 41 (text), line 44 (text), line
  45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 27
  (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51 (text), line 65 (text) and
  line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][276]: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md][277]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text), line 43 (text), line 44 (text), line
  44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line
  47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89
  (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text),
  line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and
  line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md][278]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text), line 115
  (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md][279]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text), line 41 (text), line
  44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8
  (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51 (text),
  line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][280]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md][281]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text), line 43 (text), line
  44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line
  47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89
  (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text),
  line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and
  line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md][282]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43
  (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text),
  line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md][283]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][284]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md][285]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md][286]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md][287]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][288]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md][289]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md][290]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][291]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text), line 41 (text), line
  44 (text) and line 45 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 27 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][292]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][293]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 30 (text), line 31 (text), line 31 (text), line 41 (text), line 42 (text), line 42 (text), line 49 (text), line
  50 (text), line 50 (text), line 78 (text), line 79 (text), line 79 (text), line 774 (text), line 775 (text), line 775 (text), line 811
  (text), line 812 (text), line 812 (text), line 1000 (text), line 1001 (text), line 1001 (text), line 1013 (text), line 1014 (text), line
  1014 (text), line 1024 (text), line 1025 (text) and line 1025 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8
  (text), line 44 (text), line 54 (text), line 55 (text), line 57 (text), line 59 (text), line 63 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 280 (text), line 290 (text), line 292 (text), line 294 (text), line 296 (text), line 298 (text), line
  300 (text), line 302 (text), line 305 (text), line 309 (text), line 311 (text), line 312 (text), line 315 (text), line 319 (text), line
  320 (text), line 321 (text), line 323 (text), line 325 (text), line 327 (text), line 330 (text), line 333 (text), line 335 (text), line
  337 (text), line 339 (text), line 343 (text), line 345 (text), line 347 (text), line 350 (text), line 351 (text), line 360 (text), line
  366 (text), line 368 (text), line 371 (text), line 446 (text), line 481 (text), line 489 (text), line 513 (text), line 777 (text), line
  784 (text), line 793 (text), line 821 (text), line 825 (text), line 827 (text), line 829 (text), line 831 (text), line 834 (text), line
  836 (text), line 838 (text), line 840 (text), line 842 (text), line 845 (text), line 847 (text), line 926 (text), line 928 (text), line
  930 (text), line 932 (text), line 934 (text), line 936 (text), line 941 (text), line 949 (text), line 951 (text), line 954 (text), line
  956 (text), line 959 (text), line 961 (text), line 964 (text), line 967 (text), line 969 (text), line 971 (text), line 975 (text), line
  977 (text), line 979 (text), line 981 (text), line 986 (text), line 993 (text), line 1003 (text), line 1004 (text), line 1005 (text), line
  1006 (text), line 1007 (text) and line 1009 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][294]: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 8 (text), line 71 (text), line 126 (text), line 134 (text), line 158 (text), line 346 (text), line 348 (text),
  line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 364 (text), line 369 (text), line 371 (text),
  line 372 (text), line 375 (text), line 380 (text), line 381 (text), line 384 (text), line 386 (text), line 389 (text), line 391 (text),
  line 393 (text), line 395 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text), line 411 (text), line 413 (text),
  line 415 (text), line 417 (text), line 419 (text), line 429 (text), line 435 (text), line 436 (text), line 439 (text), line 442 (text),
  line 444 (text), line 446 (text), line 449 (text), line 454 (text), line 469 (text), line 473 (text), line 475 (text), line 477 (text),
  line 479 (text), line 482 (text), line 484 (text), line 486 (text), line 488 (text), line 491 (text), line 493 (text), line 495 (text),
  line 502 (text), line 504 (text), line 509 (text), line 510 (text), line 515 (text), line 517 (text), line 520 (text), line 523 (text),
  line 525 (text), line 527 (text), line 531 (text), line 533 (text), line 536 (text), line 537 (text), line 543 (text), line 552 (text),
  line 695 (text), line 1071 (text), line 1073 (text), line 1075 (text), line 1077 (text), line 1079 (text), line 1087 (text), line 1089
  (text), line 1091 (text), line 1093 (text), line 1095 (text), line 1097 (text), line 1104 (text), line 1106 (text), line 1108 (text), line
  1110 (text), line 1112 (text), line 1115 (text), line 1178 (text), line 1296 (text) and line 1302 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md][295]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][296]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md][297]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md][298]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md][299]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][300]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md][301]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md][302]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md][303]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][304]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md][305]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md][306]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][307]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 8 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][308]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][309]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 42 (text), line 43 (text), line 43 (text),
  line 50 (text), line 51 (text), line 51 (text), line 79 (text), line 80 (text), line 80 (text), line 776 (text), line 777 (text), line 777
  (text), line 815 (text), line 816 (text), line 816 (text), line 1025 (text), line 1026 (text), line 1026 (text), line 1038 (text), line
  1039 (text), line 1039 (text), line 1049 (text), line 1050 (text) and line 1050 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 8 (text), line 45 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 64 (text), line 90 (text), line
  92 (text), line 94 (text), line 96 (text), line 281 (text), line 292 (text), line 294 (text), line 296 (text), line 298 (text), line 300
  (text), line 302 (text), line 304 (text), line 307 (text), line 311 (text), line 313 (text), line 314 (text), line 317 (text), line 321
  (text), line 322 (text), line 323 (text), line 325 (text), line 327 (text), line 329 (text), line 332 (text), line 335 (text), line 337
  (text), line 339 (text), line 341 (text), line 345 (text), line 347 (text), line 349 (text), line 352 (text), line 353 (text), line 362
  (text), line 368 (text), line 370 (text), line 373 (text), line 448 (text), line 483 (text), line 491 (text), line 515 (text), line 779
  (text), line 786 (text), line 796 (text), line 827 (text), line 831 (text), line 833 (text), line 835 (text), line 837 (text), line 840
  (text), line 842 (text), line 844 (text), line 846 (text), line 849 (text), line 852 (text), line 854 (text), line 933 (text), line 935
  (text), line 937 (text), line 939 (text), line 941 (text), line 943 (text), line 948 (text), line 973 (text), line 975 (text), line 978
  (text), line 980 (text), line 983 (text), line 985 (text), line 988 (text), line 991 (text), line 993 (text), line 995 (text), line 999
  (text), line 1002 (text), line 1004 (text), line 1006 (text), line 1011 (text), line 1018 (text), line 1028 (text), line 1029 (text), line
  1030 (text), line 1031 (text), line 1032 (text) and line 1034 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][310]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 72 (text), line 128 (text), line 136 (text), line 160 (text), line 348
  (text), line 350 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 362 (text), line 366 (text), line 371
  (text), line 373 (text), line 374 (text), line 377 (text), line 382 (text), line 383 (text), line 386 (text), line 388 (text), line 391
  (text), line 393 (text), line 395 (text), line 397 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 413
  (text), line 415 (text), line 417 (text), line 419 (text), line 421 (text), line 431 (text), line 437 (text), line 438 (text), line 441
  (text), line 444 (text), line 446 (text), line 448 (text), line 451 (text), line 456 (text), line 473 (text), line 477 (text), line 479
  (text), line 481 (text), line 483 (text), line 486 (text), line 488 (text), line 490 (text), line 492 (text), line 496 (text), line 498
  (text), line 500 (text), line 509 (text), line 511 (text), line 516 (text), line 517 (text), line 522 (text), line 524 (text), line 527
  (text), line 530 (text), line 532 (text), line 534 (text), line 538 (text), line 541 (text), line 544 (text), line 545 (text), line 551
  (text), line 560 (text), line 703 (text), line 1098 (text), line 1100 (text), line 1102 (text), line 1104 (text), line 1106 (text), line
  1114 (text), line 1116 (text), line 1118 (text), line 1120 (text), line 1122 (text), line 1124 (text), line 1131 (text), line 1133 (text),
  line 1135 (text), line 1137 (text), line 1139 (text), line 1142 (text), line 1205 (text), line 1333 (text) and line 1340 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md][311]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8
  (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][312]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md][313]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 51 (text), line 52
  (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line 143 (text), line 217
  (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 29 (text), line
  37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75
  (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105
  (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148
  (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163
  (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179
  (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194
  (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211
  (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md][314]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44
  (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text), line 58 (text), line 61 (text),
  line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text),
  line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line 120 (text), line 122 (text),
  line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text),
  line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text),
  line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text),
  line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line 216 (text), line 218 (text),
  line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line 237 (text), line 243 (text),
  line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md][315]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][316]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md][317]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md][318]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md][319]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][320]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md][321]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text), line 51 (text), line
  52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line 143 (text), line 217
  (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 29 (text), line
  37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75
  (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105
  (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148
  (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163
  (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179
  (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194
  (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211
  (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md][322]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md][323]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md][324]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text), line 38 (text), line 39
  (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md][325]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39 (text),
  line 43 (text), line 46 (text), line 47 (text), line 51 (text), line 54 (text), line 55 (text), line 59 (text), line 62 (text) and line 63
  (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md][326]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 33 (text), line 34 (text), line 34 (text),
  line 49 (text), line 50 (text), line 50 (text), line 61 (text), line 62 (text), line 62 (text), line 114 (text), line 115 (text) and line
  115 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md][327]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md][328]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text), line 38 (text), line
  39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md][329]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md][330]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text),
  line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md][331]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md][332]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 32 (text), line 33 (text), line 33 (text),
  line 39 (text), line 40 (text), line 40 (text), line 78 (text), line 79 (text) and line 79 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md][333]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md][334]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md][335]: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md][336]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md][337]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md][338]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md][339]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md][340]: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md][341]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md][342]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30 (text).
- [docs/adr/design/commit-lifecycle.md][343]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][344]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][345]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][346]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][347]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][348]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][349]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][350]: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][351]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][3]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][352]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][353]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][354]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][355]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107 (text), line 121 (text), line
  137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225 (text), line 239 (text), line
  252 (text), line 265 (text) and line 277 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 292 (text) and line 305 (text);
  selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 752 (text).
- [docs/adr/index.md][356]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 107 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 111 (text); selected by [ADR-REPO-FOLDERS][4]:
  the file cites it at line 286 (text).
- [docs/adr/repository/agent-definitions.md][357]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/api-contracts.md][358]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/controlled-vocabulary.md][359]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][4]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][360]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][361]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][362]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][363]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/generated-readmes.md][364]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/generated-root-configs.md][365]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/inspiration.md][366]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/markdown-links.md][367]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/output-formats.md][368]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/repo-variants.md][369]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/uniform-formatting.md][370]: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][371]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][372]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 52
  (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][373]: selected by [ADR-FLOW-CD][2]: the file cites it at line 55
  (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][374]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 51
  (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][375]: selected by [ADR-FLOW-CD][2]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][376]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][377]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text),
  line 50 (text) and line 51 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][378]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 59
  (text).
- [docs/explanation/design/one-unit-one-pipeline.md][379]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text), line 38
  (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][380]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 49 (text) and line 67 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 38 (text), line 57 (text) and line 71
  (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][381]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text), line
  34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][382]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 59 (text) and line 59 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at
  line 54 (text) and line 55 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][383]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][384]: selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text), line
  60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][385]: selected by [ADR-FLOW-CD][2]: the file cites it at line 16 (text), line 48
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][386]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15
  (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][387]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text),
  line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][388]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][389]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17
  (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][390]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text),
  line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text), line 59
  (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][391]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15
  (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][392]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17
  (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][393]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][394]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18
  (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][395]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16
  (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][396]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text),
  line 38 (text) and line 40 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][397]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][398]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][399]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text),
  line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][400]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18
  (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][401]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line 30 (text), line 31 (text) and
  line 32 (text).
- [docs/references/automation/catzc-base-globs.md][402]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][403]: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 47 (text) and line
  77 (text).
- [docs/references/automation/catzc-base-maps.md][404]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text), line 70 (text)
  and line 82 (text).

### pipelines × pipeline-yaml (6 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][5]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [pipelines/cd-apex.yaml][405]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (header).
- [pipelines/cd-flux.yaml][406]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (header).
- [pipelines/cd-nova.yaml][407]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (header).
- [pipelines/cd-shared.yaml][408]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29 (header).
- [pipelines/ci-automation.yaml][409]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (header); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][410]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (header).

## Keywords

- [world map][411]
- [track][412]
- [file language][413]
- [cell][414]
- [lit cell][415]
- [.claude][114]: a track
- [.github][114]: a track
- [automation][114]: a track
- [docs][114]: a track
- [pipelines][114]: a track
- [csharp][110]: a file language
- [markdown][110]: a file language
- [pipeline-yaml][110]: a file language
- [powershell][110]: a file language
- [yaml][110]: a file language

Terms the cited ADRs define:

- [cell][414], defined by [ADR-DSGN-TRACK#10][416]
- [deployable-unit][417], defined by [ADR-DSGN-TRACK#5][418]
- [domain][419], defined by [ADR-REPO-FOLDERS#5][420]
- [file language][413], defined by [ADR-DSGN-TRACK#6][6]
- [gate][421], defined by [ADR-FLOW-CD#13][422]
- [lit cell][415], defined by [ADR-DSGN-TRACK#12][7]
- [release candidate][423], defined by [ADR-FLOW-CD#14][424]
- [root file][425], defined by [ADR-DSGN-TRACK#7][426]
- [stack violation][427], defined by [ADR-DSGN-TRACK#11][428]
- [track][412], defined by [ADR-DSGN-TRACK#1][5]
- [unlisted file][429], defined by [ADR-DSGN-TRACK#8][430]
- [value-chain concern][431], defined by [ADR-DSGN-TRACK#15][432]
- [value-chain map][433], defined by [ADR-DSGN-TRACK#16][434]
- [value-chain stack][435], defined by [ADR-DSGN-TRACK#14][436]
- [verification track][437], defined by [ADR-DSGN-TRACK#2][438]
- [world map][411], defined by [ADR-DSGN-TRACK#9][439]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/flow/durable-sha-globs.md
[4]: ../../adr/repository/conventional-folders.md
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[8]: ../../../.claude/CLAUDE.md
[9]: ../../../.claude/drawio/STYLE.md
[10]: ../../../.claude/drawio/minimaps/highlights.ps1
[11]: ../../../.github/workflows/ci-automation.yml
[12]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[13]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[14]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[15]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[16]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[17]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[18]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[19]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[20]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[21]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[22]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[23]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[24]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[25]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[26]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[27]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[28]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[29]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[30]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[31]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[32]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[33]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[34]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[35]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[36]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[37]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[38]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[39]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[40]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[41]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[42]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[43]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[44]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[45]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[46]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[47]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[48]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[49]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[50]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[51]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[52]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[53]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[54]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[55]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[56]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[57]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[58]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[59]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[60]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[61]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[62]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[63]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[64]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[65]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[66]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[67]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[68]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[69]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[70]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[71]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[72]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[73]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[74]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[75]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[76]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[77]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[78]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[79]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[80]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[81]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[82]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[83]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[84]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[85]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[86]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[87]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[88]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[89]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[90]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[91]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[92]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[93]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[94]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[95]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[96]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[97]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[98]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[99]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[100]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[101]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[102]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[103]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[104]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[105]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[106]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[107]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[108]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[109]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[110]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[111]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[112]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[113]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[114]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[115]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[116]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[117]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[118]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[119]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[120]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[121]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[122]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[123]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[124]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[125]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[126]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[127]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[128]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[129]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[130]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[131]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[132]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[133]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[134]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[135]: adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md
[136]: adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md
[137]: adr-auto-depm--three-layers-edges-point-down--architecture.chain.md
[138]: adr-auto-depm--three-layers-edges-point-down--architecture.grid.md
[139]: adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
[140]: adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
[141]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md
[142]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md
[143]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md
[144]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md
[145]: adr-az-naming--how-each-naming-rule-is-held--governance.chain.md
[146]: adr-az-naming--how-each-naming-rule-is-held--governance.grid.md
[147]: adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md
[148]: adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md
[149]: adr-az-naming--names-are-derived-never-typed--operations.chain.md
[150]: adr-az-naming--names-are-derived-never-typed--operations.grid.md
[151]: adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md
[152]: adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md
[153]: adr-az-naming--one-namer-assembles-every-name--architecture.chain.md
[154]: adr-az-naming--one-namer-assembles-every-name--architecture.grid.md
[155]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
[156]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
[157]: adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
[158]: adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
[159]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[160]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[161]: adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
[162]: adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
[163]: adr-conf-loading--three-caches-back-one-reader--implementation.chain.md
[164]: adr-conf-loading--three-caches-back-one-reader--implementation.grid.md
[165]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md
[166]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md
[167]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md
[168]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md
[169]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md
[170]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md
[171]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md
[172]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md
[173]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[174]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[175]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[176]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
[177]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[178]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[179]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[180]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[181]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[182]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[183]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[184]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[185]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[186]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[187]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[188]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[189]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[190]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[191]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[192]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[193]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[194]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[195]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[196]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[197]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[198]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[199]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[200]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[201]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[202]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[203]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[204]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[205]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[206]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[207]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[208]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[209]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[210]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[211]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[212]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[213]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[214]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[215]: adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
[216]: adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
[217]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[218]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[219]: adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md
[220]: adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md
[221]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
[222]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
[223]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[224]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[225]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[226]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[227]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[228]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[229]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[230]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[231]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[232]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[233]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[234]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[235]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[236]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[237]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[238]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[239]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[240]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[241]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[242]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[243]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md
[244]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
[245]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md
[246]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md
[247]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md
[248]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
[249]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md
[250]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md
[251]: adr-dsgn-track--one-unit-one-pipeline--meta.chain.md
[252]: adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
[253]: adr-dsgn-track--one-unit-one-pipeline--meta.grid.md
[254]: adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
[255]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[256]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[257]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[258]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[259]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md
[260]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
[261]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md
[262]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md
[263]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md
[264]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[265]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md
[266]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md
[267]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
[268]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[269]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
[270]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
[271]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md
[272]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[273]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md
[274]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md
[275]: adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md
[276]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[277]: adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md
[278]: adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md
[279]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
[280]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[281]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
[282]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md
[283]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
[284]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[285]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
[286]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
[287]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
[288]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[289]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
[290]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
[291]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[292]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[293]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[294]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[295]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
[296]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[297]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
[298]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
[299]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
[300]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[301]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
[302]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md
[303]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md
[304]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[305]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md
[306]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md
[307]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[308]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[309]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[310]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[311]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
[312]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[313]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md
[314]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md
[315]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
[316]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[317]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
[318]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
[319]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
[320]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[321]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
[322]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
[323]: adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
[324]: adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
[325]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
[326]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
[327]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
[328]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
[329]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
[330]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
[331]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md
[332]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
[333]: adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md
[334]: adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
[335]: adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md
[336]: adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md
[337]: adr-pipe-auth--three-guarded-early-returns--implementation.chain.md
[338]: adr-pipe-auth--three-guarded-early-returns--implementation.grid.md
[339]: adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
[340]: adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
[341]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
[342]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
[343]: ../../adr/design/commit-lifecycle.md
[344]: ../../adr/design/dora-explains.md
[345]: ../../adr/design/module-aspects.md
[346]: ../../adr/design/run-modes.md
[347]: ../../adr/design/self-service.md
[348]: ../../adr/design/server-remote-integration.md
[349]: ../../adr/design/thin-platforms.md
[350]: ../../adr/design/visual-design.md
[351]: ../../adr/flow/dora-explains.md
[352]: ../../adr/flow/pipeline-detection.md
[353]: ../../adr/flow/pipeline-runner-pattern.md
[354]: ../../adr/flow/pipeline-types.md
[355]: ../../adr/glossary.md
[356]: ../../adr/index.md
[357]: ../../adr/repository/agent-definitions.md
[358]: ../../adr/repository/api-contracts.md
[359]: ../../adr/repository/controlled-vocabulary.md
[360]: ../../adr/repository/dedicated-output-directory.md
[361]: ../../adr/repository/documentation-examples.md
[362]: ../../adr/repository/domain-language-separation.md
[363]: ../../adr/repository/dora-explains.md
[364]: ../../adr/repository/generated-readmes.md
[365]: ../../adr/repository/generated-root-configs.md
[366]: ../../adr/repository/inspiration.md
[367]: ../../adr/repository/markdown-links.md
[368]: ../../adr/repository/output-formats.md
[369]: ../../adr/repository/repo-variants.md
[370]: ../../adr/repository/uniform-formatting.md
[371]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[372]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[373]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[374]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[375]: ../../explanation/design/four-domains-promote-one-artifact.md
[376]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[377]: ../../explanation/design/integrators-depend-on-an-occupant.md
[378]: ../../explanation/design/one-folder-two-independent-readers.md
[379]: ../../explanation/design/one-unit-one-pipeline.md
[380]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[381]: ../../explanation/design/sync-point-rules-are-adr-only.md
[382]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[383]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[384]: ../../explanation/design/which-rung-gates-exist-in-code.md
[385]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[386]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[387]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[388]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[389]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[390]: ../../explanation/flow/gates-check-source-and-trigger.md
[391]: ../../explanation/flow/globs-module-owns-config-and-types.md
[392]: ../../explanation/flow/independence-check-groups-by-layer.md
[393]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[394]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[395]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[396]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[397]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[398]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[399]: ../../explanation/flow/two-declared-layers-one-derived.md
[400]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[401]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[402]: ../../references/automation/catzc-base-globs.md
[403]: ../../references/automation/catzc-base-languages.md
[404]: ../../references/automation/catzc-base-maps.md
[405]: ../../../pipelines/cd-apex.yaml
[406]: ../../../pipelines/cd-flux.yaml
[407]: ../../../pipelines/cd-nova.yaml
[408]: ../../../pipelines/cd-shared.yaml
[409]: ../../../pipelines/ci-automation.yaml
[410]: ../../../pipelines/ci-infrastructure.yaml
[411]: ../../adr/glossary.md#world-map
[412]: ../../adr/glossary.md#track
[413]: ../../adr/glossary.md#file-language
[414]: ../../adr/glossary.md#cell
[415]: ../../adr/glossary.md#lit-cell
[416]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[417]: ../../adr/glossary.md#deployable-unit
[418]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[419]: ../../adr/glossary.md#domain
[420]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[421]: ../../adr/glossary.md#gate
[422]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[423]: ../../adr/glossary.md#release-candidate
[424]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[425]: ../../adr/glossary.md#root-file
[426]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[427]: ../../adr/glossary.md#stack-violation
[428]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[429]: ../../adr/glossary.md#unlisted-file
[430]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[431]: ../../adr/glossary.md#value-chain-concern
[432]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[433]: ../../adr/glossary.md#value-chain-map
[434]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[435]: ../../adr/glossary.md#value-chain-stack
[436]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[437]: ../../adr/glossary.md#verification-track
[438]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[439]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

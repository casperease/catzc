# docs/explanation/.assets/grid/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md

`Grid minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Grid minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.png)

The grid minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 10 lit of 71 files
- .unordered × markdown: 8 lit of 20 files
- automation × csharp: 30 lit of 274 files
- automation × powershell: 78 lit of 1579 files
- automation × yaml: 7 lit of 109 files
- docs × markdown: 79 lit of 2165 files
- github-workflows × yaml: 1 lit of 2 files, touched
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (10 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 51 (text), line 58
  (text), line 77 (text), line 85 (text), line 148 (text), line 149 (text), line 153 (text), line 153 (text), line 155 (text), line 161
  (text), line 163 (text) and line 208 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 54 (text), line 225 (text) and
  line 225 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line
  162 (text), line 406 (text), line 447 (text), line 472 (text), line 552 (text), line 754 (text), line 781 (text), line 889 (text) and line
  894 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 890 (text).
- [.claude/plans/plan-minimal-robots-agents.md][9]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 33 (text) and line 66
  (text).
- [.claude/plans/plan-module-kinds-tracks.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 39 (text), line 74 (text),
  line 78 (text), line 104 (text), line 110 (text), line 135 (text), line 153 (text), line 154 (text), line 175 (text), line 195 (text),
  line 243 (text), line 356 (text), line 365 (text), line 510 (text), line 524 (text), line 555 (text), line 560 (text), line 606 (text),
  line 622 (text), line 622 (text), line 648 (text), line 650 (text), line 652 (text), line 662 (text), line 670 (text), line 671 (text),
  line 681 (text), line 700 (text), line 810 (text), line 822 (text), line 827 (text), line 829 (text), line 858 (text), line 865 (text),
  line 887 (text), line 926 (text), line 945 (text), line 954 (text), line 995 (text) and line 1050 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 54
  (text) and line 162 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 83 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 40 (text),
  line 51 (text) and line 76 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 57 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 40
  (text), line 52 (text), line 53 (text), line 92 (text) and line 101 (text).
- [.claude/plans/prompt-module-model-2-implement.md][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 47
  (text) and line 59 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 46 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 97 (text) and line 108 (text).

### .unordered × markdown (8 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 90 (text) and line 248
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 43 (text), line 96 (text), line 124 (text) and line 167 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 105 (text), line 117 (text), line 248 (text) and line 324 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][18]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line 50 (text),
  line 51 (text), line 51 (text), line 54 (text), line 162 (text) and line 187 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 97 (text).
- [.unordered/15-10-2026/plan-contracts.md][20]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23 (text), line 76 (text),
  line 122 (text) and line 294 (text).
- [.unordered/15-10-2026/plan-diagram-wave-7.md][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 101 (text) and line 102
  (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 31 (text).
- [.unordered/15-10-2026/plan-diagram-wave-9.md][22]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 45 (text), line 74 (text)
  and line 150 (text).
- [.unordered/15-10-2026/plan-explanation-assets-source.md][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line
  39 (text), line 41 (text), line 54 (text), line 56 (text) and line 110 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 74 (text) and line 101 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 38 (text), line 39
  (text), line 58 (text), line 77 (text), line 103 (text) and line 103 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  63 (text), line 63 (text), line 78 (text) and line 78 (text).

### automation × csharp (30 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text) and line 44
  (body comment).
- [automation/Catzc.Base.Globs/types/Aspect.cs][28]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][29]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][30]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (text), line 47
  (text), line 51 (text), line 55 (text), line 67 (text), line 71 (text) and line 80 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][31]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (text) and line 79
  (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][32]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (text), line 98
  (text), line 161 (text), line 165 (text) and line 179 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][33]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][35]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][37]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text), line 33
  (body comment) and line 36 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][45]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text) and line
  164 (body comment).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][51]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/PathModule.cs][52]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][53]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][54]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text) and
  line 266 (text).

### automation × powershell (78 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][55]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 20 (header) and line 30 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][56]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 22 (header) and line 28 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][57]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][58]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][59]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 23 (header) and line 29 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][60]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23 (header) and
  line 29 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][61]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header),
  line 120 (text) and line 120 (body comment).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][62]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header)
  and line 27 (header).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][63]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and
  line 26 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and line 25
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][65]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header), line 25
  (header) and line 28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and line
  28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][67]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and
  line 25 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and
  line 27 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][69]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 26 (header).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][70]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and line
  26 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][71]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][72]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][73]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (header) and
  line 33 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][74]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 23 (header),
  line 36 (header) and line 95 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][75]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header) and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][76]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header)
  and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][77]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header)
  and line 26 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][78]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][79]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21
  (header) and line 31 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][80]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][81]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][82]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][83]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][84]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][85]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][86]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][87]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][88]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header), line 25 (text) and line 27 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][89]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  21 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][90]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  20 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][91]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  21 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][92]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header) and line 81 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][93]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header)
  and line 32 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header) and line 66 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (header), line 78 (text), line 91 (text),
  line 102 (text) and line 114 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 25 (header).
- [automation/Catzc.Base.Languages/Get-PathFileType.ps1][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 27 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][97]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 134 (text), line 146 (text) and line 184 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][98]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header) and line 23 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 30
  (header), line 31 (header), line 33 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][100]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header),
  line 30 (header), line 31 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][101]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 27
  (header), line 29 (header) and line 31 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (header), line 30
  (header), line 31 (header) and line 43 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][103]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line
  33 (header) and line 50 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (header), line 37
  (header), line 39 (header), line 42 (header), line 46 (header), line 77 (text), line 78 (text), line 88 (text), line 91 (text) and line
  108 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][105]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line 34
  (header), line 37 (header), line 41 (header), line 46 (header), line 47 (header), line 90 (text), line 109 (text), line 126 (text), line
  130 (text) and line 131 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][106]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 29 (header) and line 30 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 48 (text) and line 67 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 61 (text) and line 61 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 112 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header) and line 97 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 73 (text), line 73 (body comment), line 77 (text), line 78 (text), line 79 (text), line 80 (text), line 84 (text), line 87
  (text), line 104 (text), line 104 (body comment) and line 104 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][112]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header),
  line 81 (text), line 85 (text), line 88 (text), line 92 (text), line 93 (text), line 97 (text), line 106 (text), line 107 (text), line 111
  (text), line 115 (text), line 116 (text), line 135 (text), line 135 (body comment) and line 135 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 40 (text), line 47 (text), line 53 (text), line 70 (text) and line 70 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][114]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 51 (text), line 56 (text) and line 64 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][115]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 91 (text), line 135 (text) and line 149 (text).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][116]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23
  (header) and line 30 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][117]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 23 (header)
  and line 102 (header).
- [automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1][118]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][119]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][120]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  25 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][121]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 23 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1][122]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1][123]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22
  (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][124]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header) and line 31 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][125]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][126]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][127]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (header) and line 23 (text).
- [automation/Catzc.Base.Variants/Get-PathModule.ps1][128]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and line
  25 (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][129]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 24
  (header), line 27 (header) and line 31 (header).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][130]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 23 (text) and line 74 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][131]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header)
  and line 98 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][132]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (header) and line 23 (text).

### automation × yaml (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][133]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 92 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 119 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 308 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][134]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 47 (body comment), line
  53 (body comment) and line 58 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][135]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 73 (body comment)
  and line 83 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][136]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 63 (text).
- [automation/Catzc.Base.Languages/configs/glossary.yml][137]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][138]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line
  82 (text), line 166 (text), line 174 (text), line 185 (text), line 202 (text), line 215 (text), line 229 (text), line 244 (text), line 257
  (text), line 269 (text), line 282 (text), line 284 (text) and line 296 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][139]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 313 (text)
  and line 316 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1212 (text).

### docs × markdown (79 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/design/dora-explains.md][140]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][141]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 124 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/glossary.md][142]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 106 (text), line 133 (text), line 150 (text), line
  179 (text), line 236 (text), line 246 (text), line 256 (text), line 258 (text), line 273 (text), line 313 (text), line 327 (text), line
  341 (text), line 354 (text), line 388 (text) and line 400 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 938 (text).
- [docs/adr/index.md][143]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 106 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 131 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 312 (text).
- [docs/adr/repository/conventional-folders.md][3]: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][144]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 62 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][145]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16
  (text) and line 36 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][146]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 39 (text), line 45 (text), line 45 (text), line 48 (text), line 48 (text), line 50 (text), line 50 (text), line 50 (text),
  line 51 (text), line 52 (text) and line 54 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][147]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][148]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 35 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][149]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 40 (text) and line 41 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][150]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 36 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][151]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][152]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (text), line 54 (text), line 57 (text) and line 69 (text).
- [docs/references/automation/catzc-base-globs.md][153]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 51 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][154]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  20 (text), line 35 (text), line 38 (text) and line 86 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][155]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 17 (text), line 31 (text) and line 41 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][156]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text) and line 126 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18 (text), line 33 (text), line 38 (text), line
  46 (text), line 48 (text), line 62 (text), line 92 (text) and line 106 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][157]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][158]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][159]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][160]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][161]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][162]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][163]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][164]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][165]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][166]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][167]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][168]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][169]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][170]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][171]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 18 (text), line 34 (text), line 36 (text) and line 45 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][172]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18
  (text) and line 39 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][173]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 30 (text) and line 36 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][174]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 36 (text), line 37 (text) and line 38 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][175]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text), line 32 (text), line 34 (text), line 35 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 57 (text),
  line 66 (text), line 84 (text), line 101 (text), line 111 (text), line 135 (text) and line 143 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][176]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 32 (text), line 36 (text), line 39 (text) and line 58 (text).
- [docs/references/automation/catzc-base-languages.md][177]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 79 (text) and line
  109 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][178]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][179]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/BashConfig.cs.md][180]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 18 (text) and line 42 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][181]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][182]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  19 (text) and line 46 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][183]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/types/PythonConfig.cs.md][184]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 18 (text) and line 45 (text).
- [docs/references/automation/catzc-base-maps.md][185]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 97
  (text), line 99 (text) and line 111 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][186]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 57 (text), line 63 (text), line 65 (text) and line 70 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][187]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][188]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][189]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][190]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][191]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][192]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][193]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][194]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][195]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 36 (text), line 37 (text) and line 41 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][196]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][197]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][198]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 32 (text), line 33 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][199]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][200]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][201]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 38 (text), line 39 (text) and line 42 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][202]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][203]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][204]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 33 (text), line 34 (text) and line 35 (text).
- [docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md][205]: selected by [ADR-REPO-FOLDERS][3]: the file cites
  it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][206]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 17 (text) and line 70 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][207]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 94 (text), line 97 (text) and line 99 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][208]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][209]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 52 (text), line 55 (text) and line 57 (text).
- [docs/references/pipelines/cd-apex.yaml.md][210]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 47 (text).
- [docs/references/pipelines/cd-flux.yaml.md][211]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 46 (text).
- [docs/references/pipelines/cd-nova.yaml.md][212]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 46 (text).
- [docs/references/pipelines/cd-shared.yaml.md][213]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 41 (text).
- [docs/references/pipelines/ci-automation.yaml.md][214]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 32
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][215]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 33 (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.github/workflows/ci-automation.yml][216]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/ci-automation.yaml][217]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 92 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 120 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 120 (body comment), `automation/Catzc.Base.Docs/types/AdrDomain.cs`
  line 21 (text), `automation/Catzc.Base.Docs/types/AdrRuleSet.cs` line 21 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 25
  (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 44 (body comment),
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
  `automation/Catzc.Base.Maps/types/WorldMapBuilder.cs` line 164 (body comment), `automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs`
  line 21 (text), `automation/Catzc.Base.Maps/types/WorldMapHighlight.cs` line 21 (text), `automation/Catzc.Base.Maps/types/WorldMapPdf.cs`
  line 21 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 24 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 82 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  166 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 174 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 185 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  202 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 215 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 229 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  244 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 257 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 269 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  282 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 284 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 296 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml`
  line 313 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 316 (text),
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
  (header), `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 74 (text), `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 98 (text),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Variants/types/ModulePlace.cs` line 20 (text), `automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs` line 19
  (text), `automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 21 (text), `automation/Catzc.Base.Variants/types/PathModule.cs`
  line 19 (text), `automation/Catzc.Base.Variants/types/VariantTrack.cs` line 21 (text),
  `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line 23 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  266 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 30 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 22 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 28 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 26 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 28 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 119 (text), `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 21 (header),
  `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 27 (header), `automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1` line 26 (header), `automation/Catzc.Base.Globs/Get-GlobSet.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-GlobSet.ps1` line 25 (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 25 (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 28
  (header), `automation/Catzc.Base.Globs/Get-GlobSetHash.ps1` line 20 (header), `automation/Catzc.Base.Globs/Get-GlobSetHash.ps1` line 28
  (header), `automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1` line 20 (header), `automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1` line
  25 (header), `automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1` line 27 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 26
  (header), `automation/Catzc.Base.Globs/Get-TrackedFile.ps1` line 21 (header), `automation/Catzc.Base.Globs/Get-TrackedFile.ps1` line 26
  (header), `automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1` line 22 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 22 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 33 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 23 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1`
  line 36 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 95 (text),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 28 (header), `automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1`
  line 21 (header), `automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1` line 28 (header),
  `automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1` line 21 (header), `automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1`
  line 26 (header), `automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1` line 27 (header),
  `automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1` line 31 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 81 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 20 (header), `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1`
  line 32 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 91 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 102 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 114 (text), `automation/Catzc.Base.Globs/types/Aspect.cs` line 22
  (text), `automation/Catzc.Base.Globs/types/DurableHash.cs` line 20 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 21
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 47 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 51
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 55 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 67
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 71 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 80
  (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 21 (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 79 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 21 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 98 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 161 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 165 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 179 (text), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 23
  (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 102 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 1212 (text),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 22 (header) and
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 31 (header); selected by [ADR-REPO-FOLDERS][3]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1` line 23 (header),
  `automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1` line 29 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 308 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 47 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 53 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 58 (body
  comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 73 (body comment),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 83 (body comment), `automation/Catzc.Base.Docs/configs/glossary.yml` line 63
  (text), `automation/Catzc.Base.Docs/private/Get-CatsModules.ps1` line 23 (header),
  `automation/Catzc.Base.Docs/private/Get-CatsModules.ps1` line 29 (header), `automation/Catzc.Base.Languages/types/BashConfig.cs` line 22
  (text), `automation/Catzc.Base.Languages/types/GoConfig.cs` line 23 (text), `automation/Catzc.Base.Languages/types/PythonConfig.cs` line
  22 (text), `automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1` line 23 (header) and
  `automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1` line 30 (header).

## Keywords

- [world map][218]
- [track][219]
- [file language][220]
- [cell][221]
- [lit cell][222]
- [.claude][223]: a track
- [.unordered][223]: a track
- [automation][223]: a track
- [docs][223]: a track
- [github-workflows][223]: a track
- [pipelines][223]: a track
- [csharp][224]: a file language
- [markdown][224]: a file language
- [pipeline-yaml][224]: a file language
- [powershell][224]: a file language
- [yaml][224]: a file language

Terms the cited ADRs define:

- [cell][221], defined by [ADR-DSGN-TRACK#10][225]
- [deployable-unit][226], defined by [ADR-DSGN-TRACK#5][227]
- [domain][228], defined by [ADR-REPO-FOLDERS#5][229]
- [file language][220], defined by [ADR-DSGN-TRACK#6][5]
- [lit cell][222], defined by [ADR-DSGN-TRACK#12][6]
- [place][230], defined by [ADR-DSGN-TRACK#1][4]
- [root file][231], defined by [ADR-DSGN-TRACK#7][232]
- [stack violation][233], defined by [ADR-DSGN-TRACK#11][234]
- [track][219], defined by [ADR-DSGN-TRACK#1][4]
- [unlisted file][235], defined by [ADR-DSGN-TRACK#8][236]
- [value-chain concern][237], defined by [ADR-DSGN-TRACK#15][238]
- [value-chain map][239], defined by [ADR-DSGN-TRACK#16][240]
- [value-chain stack][241], defined by [ADR-DSGN-TRACK#14][242]
- [verification track][243], defined by [ADR-DSGN-TRACK#2][244]
- [world map][218], defined by [ADR-DSGN-TRACK#9][245]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/repository/conventional-folders.md
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../../.claude/plans/decisions-2026-10-16.md
[8]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[9]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[10]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[11]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[12]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[13]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[14]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[15]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[16]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[17]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[18]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[19]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[20]: ../../../../.unordered/15-10-2026/plan-contracts.md
[21]: ../../../../.unordered/15-10-2026/plan-diagram-wave-7.md
[22]: ../../../../.unordered/15-10-2026/plan-diagram-wave-9.md
[23]: ../../../../.unordered/15-10-2026/plan-explanation-assets-source.md
[24]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[25]: ../../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[26]: ../../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[27]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[28]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[29]: ../../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[30]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[31]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[32]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[33]: ../../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[34]: ../../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[35]: ../../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[36]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[37]: ../../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[38]: ../../../../automation/Catzc.Base.Maps/types/MapCell.cs
[39]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[40]: ../../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[41]: ../../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[42]: ../../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[43]: ../../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[44]: ../../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[45]: ../../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[46]: ../../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[47]: ../../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[48]: ../../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[49]: ../../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[50]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[51]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[52]: ../../../../automation/Catzc.Base.Variants/types/PathModule.cs
[53]: ../../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[54]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[55]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[56]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[57]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[58]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[59]: ../../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[60]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[61]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[62]: ../../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[63]: ../../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[64]: ../../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[65]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[66]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[67]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[68]: ../../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[69]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[70]: ../../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[71]: ../../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[72]: ../../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[73]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[74]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[75]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[76]: ../../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[77]: ../../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[78]: ../../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[79]: ../../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[80]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[81]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[82]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[83]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[84]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[85]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[86]: ../../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[87]: ../../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[88]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[89]: ../../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[90]: ../../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[91]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[92]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[93]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[94]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[95]: ../../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[96]: ../../../../automation/Catzc.Base.Languages/Get-PathFileType.ps1
[97]: ../../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[98]: ../../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[99]: ../../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[100]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[101]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[102]: ../../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[103]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[104]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[105]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[106]: ../../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[107]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[108]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[109]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[110]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[111]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[112]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[113]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[114]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[115]: ../../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[116]: ../../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[117]: ../../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[118]: ../../../../automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1
[119]: ../../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[120]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[121]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[122]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1
[123]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1
[124]: ../../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[125]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[126]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[127]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[128]: ../../../../automation/Catzc.Base.Variants/Get-PathModule.ps1
[129]: ../../../../automation/Catzc.Base.Variants/Get-Track.ps1
[130]: ../../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[131]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[132]: ../../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[133]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[134]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[135]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[136]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[137]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[138]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[139]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[140]: ../../../adr/design/dora-explains.md
[141]: ../../../adr/flow/dora-explains.md
[142]: ../../../adr/glossary.md
[143]: ../../../adr/index.md
[144]: ../../../adr/repository/dora-explains.md
[145]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[146]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[147]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[148]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[149]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[150]: ../../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[151]: ../../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[152]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[153]: ../../../references/automation/catzc-base-globs.md
[154]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[155]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[156]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[157]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[158]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[159]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[160]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[161]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[162]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[163]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[164]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[165]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[166]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[167]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[168]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[169]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[170]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[171]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[172]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[173]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[174]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[175]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[176]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[177]: ../../../references/automation/catzc-base-languages.md
[178]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[179]: ../../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[180]: ../../../references/automation/catzc-base-languages/types/BashConfig.cs.md
[181]: ../../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[182]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[183]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[184]: ../../../references/automation/catzc-base-languages/types/PythonConfig.cs.md
[185]: ../../../references/automation/catzc-base-maps.md
[186]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[187]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[188]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[189]: ../../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[190]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[191]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[192]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[193]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[194]: ../../../references/automation/catzc-base-maps/types/MapCell.cs.md
[195]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[196]: ../../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[197]: ../../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[198]: ../../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[199]: ../../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[200]: ../../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[201]: ../../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[202]: ../../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[203]: ../../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[204]: ../../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[205]: ../../../references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[206]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[207]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[208]: ../../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[209]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[210]: ../../../references/pipelines/cd-apex.yaml.md
[211]: ../../../references/pipelines/cd-flux.yaml.md
[212]: ../../../references/pipelines/cd-nova.yaml.md
[213]: ../../../references/pipelines/cd-shared.yaml.md
[214]: ../../../references/pipelines/ci-automation.yaml.md
[215]: ../../../references/pipelines/ci-infrastructure.yaml.md
[216]: ../../../../.github/workflows/ci-automation.yml
[217]: ../../../../pipelines/ci-automation.yaml
[218]: ../../../adr/glossary.md#world-map
[219]: ../../../adr/glossary.md#track
[220]: ../../../adr/glossary.md#file-language
[221]: ../../../adr/glossary.md#cell
[222]: ../../../adr/glossary.md#lit-cell
[223]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[224]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[225]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[226]: ../../../adr/glossary.md#deployable-unit
[227]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[228]: ../../../adr/glossary.md#domain
[229]: ../../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[230]: ../../../adr/glossary.md#place
[231]: ../../../adr/glossary.md#root-file
[232]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[233]: ../../../adr/glossary.md#stack-violation
[234]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[235]: ../../../adr/glossary.md#unlisted-file
[236]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[237]: ../../../adr/glossary.md#value-chain-concern
[238]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[239]: ../../../adr/glossary.md#value-chain-map
[240]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[241]: ../../../adr/glossary.md#value-chain-stack
[242]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[243]: ../../../adr/glossary.md#verification-track
[244]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[245]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9

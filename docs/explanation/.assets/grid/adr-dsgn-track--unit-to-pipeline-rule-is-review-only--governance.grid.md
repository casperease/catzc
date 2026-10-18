# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the world-map minimap

```text
Where the files that cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS sit in the repository: tracks down, file languages across.
7 of 324 cells lit, holding 221 files.
```

![The world-map minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to
one pipeline is held by review alone][225], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 14 lit of 91 files
- automation × csharp: 30 lit of 286 files
- automation × powershell: 83 lit of 1619 files
- automation × yaml: 9 lit of 112 files
- docs × markdown: 83 lit of 2220 files
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

### .claude × markdown (14 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 51 (text), line 58
  (text), line 77 (text), line 85 (text), line 148 (text), line 149 (text), line 153 (text), line 153 (text), line 155 (text), line 161
  (text), line 163 (text) and line 208 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 54 (text), line 225 (text) and
  line 225 (text).
- [.claude/plans/decisions-2026-10-18.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 38 (text), line 55
  (text) and line 55 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text) and
  line 74 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line
  108 (text), line 109 (text), line 222 (text), line 466 (text), line 507 (text), line 532 (text), line 612 (text), line 814 (text), line
  841 (text), line 945 (text) and line 950 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 946 (text).
- [.claude/plans/plan-master.md][11]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 24 (text), line 41 (text) and line 59
  (text).
- [.claude/plans/plan-module-kinds-tracks.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text), line 71 (text),
  line 75 (text), line 101 (text), line 107 (text), line 140 (text), line 160 (text), line 161 (text), line 182 (text), line 202 (text),
  line 250 (text), line 363 (text), line 372 (text), line 520 (text), line 534 (text), line 565 (text), line 570 (text), line 616 (text),
  line 632 (text), line 632 (text), line 658 (text), line 660 (text), line 662 (text), line 672 (text), line 680 (text), line 681 (text),
  line 691 (text), line 710 (text), line 820 (text), line 832 (text), line 837 (text), line 839 (text), line 868 (text), line 875 (text),
  line 897 (text), line 936 (text), line 955 (text), line 964 (text), line 1005 (text) and line 1060 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 54
  (text) and line 214 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 26 (text), line 82 (text) and line 135 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 37 (text), line 48 (text)
  and line 73 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 54 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 37 (text), line 49
  (text), line 50 (text), line 89 (text) and line 98 (text).
- [.claude/plans/prompt-module-model-2-implement.md][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 44
  (text) and line 56 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 96 (text) and line 107 (text).
- [.claude/plans/task-file-head-leftovers.md][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 31 (text), line 44 (text) and
  line 87 (text).
- [.claude/plans/task-import-landing-zone.md][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 33 (text), line 54 (text) and
  line 61 (text).

### automation × csharp (30 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/types/AdrDomain.cs][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text) and line 46
  (body comment).
- [automation/Catzc.Base.Globs/types/Aspect.cs][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][25]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][26]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (text), line 47
  (text), line 51 (text), line 55 (text), line 67 (text), line 71 (text) and line 80 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][27]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (text) and line 79
  (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][28]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (text), line 98
  (text), line 161 (text), line 165 (text) and line 179 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][29]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][31]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][33]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text), line 33
  (body comment) and line 36 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][45]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/PathModule.cs][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text) and
  line 266 (text).

### automation × powershell (83 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][51]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 20 (header) and line 30 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][52]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 22 (header) and line 28 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][53]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][54]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][55]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 23 (header) and line 29 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][56]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23 (header) and
  line 29 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][57]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header),
  line 134 (text) and line 134 (body comment).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][58]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header)
  and line 27 (header).
- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][59]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (header)
  and line 28 (header).
- [automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][60]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (header) and line 23 (text).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][61]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and
  line 26 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][62]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and line 25
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][63]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header), line 25
  (header) and line 28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and line
  28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][65]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and
  line 25 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and
  line 27 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][67]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 26 (header).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and line
  26 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][69]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][70]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][71]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (header) and
  line 33 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][72]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 23 (header),
  line 36 (header) and line 95 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][73]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22
  (header) and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][74]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header)
  and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][75]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header)
  and line 26 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][76]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][77]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21
  (header) and line 31 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][78]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][79]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][80]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][81]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][82]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][83]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][84]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][85]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][86]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header), line 25 (text) and line 27 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][87]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  21 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][88]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  20 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][89]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  21 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][90]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (header) and line 81 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][91]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header)
  and line 32 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][92]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header) and line 66 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (header), line 78 (text), line 91 (text),
  line 102 (text) and line 114 (text).
- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][93]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 25 (header).
- [automation/Catzc.Base.Languages/Get-PathFileType.ps1][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 27 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (header), line 134 (text), line 146 (text) and line 184 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header) and line 23 (text).
- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][97]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 30
  (header), line 31 (header), line 33 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][98]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header), line
  30 (header), line 31 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 27
  (header), line 29 (header) and line 31 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][100]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (header), line 30
  (header), line 31 (header) and line 43 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][101]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line
  33 (header) and line 50 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (header), line 37
  (header), line 39 (header), line 42 (header), line 46 (header), line 77 (text), line 78 (text), line 88 (text), line 91 (text) and line
  108 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][103]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (header), line 34
  (header), line 37 (header), line 41 (header), line 46 (header), line 47 (header), line 90 (text), line 109 (text), line 126 (text), line
  130 (text) and line 131 (text).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 29 (header) and line 30 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][105]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 48 (text) and line 67 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][106]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 61 (text) and line 61 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and
  line 112 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header) and line 97 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 73 (text), line 73 (body comment), line 77 (text), line 78 (text), line 79 (text), line 80 (text), line 84 (text), line 87
  (text), line 104 (text), line 104 (body comment) and line 104 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (header),
  line 81 (text), line 85 (text), line 88 (text), line 92 (text), line 93 (text), line 97 (text), line 106 (text), line 107 (text), line 111
  (text), line 115 (text), line 116 (text), line 135 (text), line 135 (body comment) and line 135 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 40 (text), line 47 (text), line 53 (text), line 70 (text) and line 70 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][112]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header), line 42 (text), line 51 (text), line 56 (text) and line 64 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 91 (text), line 135 (text) and line 149 (text).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][114]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23
  (header) and line 30 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][115]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 23 (header)
  and line 102 (header).
- [automation/Catzc.Base.QualityGates/Test-Plans.ps1][116]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (header), line
  30 (header) and line 102 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][117]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (header) and line 34 (header).
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
- [automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1][128]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 20
  (header), line 71 (body comment), line 113 (body comment) and line 117 (body comment).
- [automation/Catzc.Base.Variants/Get-PathModule.ps1][129]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header) and line
  25 (header).
- [automation/Catzc.Base.Variants/Get-Track.ps1][130]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (header), line 24
  (header), line 27 (header) and line 31 (header).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][131]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (header), line 23 (text) and line 74 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][132]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (header)
  and line 98 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][133]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (header) and line 23 (text).

### automation × yaml (9 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][134]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 93 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 120 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 313 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][135]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 47 (body comment), line
  53 (body comment) and line 58 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][136]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 86 (body comment)
  and line 96 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][137]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 62 (text).
- [automation/Catzc.Base.Languages/configs/glossary.yml][138]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][139]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line
  81 (text), line 89 (text), line 99 (text), line 108 (text), line 114 (text), line 210 (text), line 220 (text), line 231 (text), line 254
  (text), line 267 (text), line 281 (text), line 296 (text), line 309 (text), line 321 (text), line 334 (text), line 336 (text) and line 348
  (text).
- [automation/Catzc.Base.QualityGates/configs/source-conventions.yml][140]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26
  (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][141]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 316 (text)
  and line 319 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1235 (text).
- [automation/Catzc.Base.Variants/configs/track-types.yml][142]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 59 (text).

### docs × markdown (83 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/design/dora-explains.md][143]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][144]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 123 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/glossary.md][145]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161 (text), line 178 (text), line
  210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329 (text), line 331 (text), line
  346 (text), line 386 (text), line 400 (text), line 409 (text), line 423 (text), line 436 (text), line 470 (text) and line 482 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 1162 (text).
- [docs/adr/index.md][146]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 133 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 318 (text).
- [docs/adr/repository/conventional-folders.md][3]: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][147]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 67 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][148]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (text) and line 35 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][149]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 39 (text), line 45 (text), line 45 (text), line 48 (text), line 48 (text), line 50 (text), line 50 (text), line 50 (text),
  line 51 (text), line 52 (text) and line 54 (text).
- [docs/how-to/automation/sort-an-import.md][150]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text) and line 23 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][151]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 75 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][152]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][153]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 35 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][154]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 40 (text) and line 41 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][155]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 36 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][156]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][157]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21
  (text), line 55 (text), line 58 (text) and line 70 (text).
- [docs/references/automation/catzc-base-globs.md][158]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 50 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][159]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  20 (text), line 35 (text), line 38 (text) and line 86 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][160]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 17 (text), line 31 (text) and line 41 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][161]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text) and line 126 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18 (text), line 33 (text), line 38 (text), line
  46 (text), line 48 (text), line 62 (text), line 92 (text) and line 106 (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][162]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 16 (text), line 55 (text) and line 130 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][163]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][164]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][165]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][166]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][167]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][168]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][169]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][170]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][171]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][172]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][173]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][174]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][175]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][176]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][177]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 18 (text), line 34 (text), line 36 (text) and line 45 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][178]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18
  (text) and line 39 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][179]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 30 (text) and line 36 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][180]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 36 (text), line 37 (text) and line 38 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][181]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text), line 32 (text), line 34 (text), line 35 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 57 (text),
  line 66 (text), line 84 (text), line 101 (text), line 111 (text), line 135 (text) and line 143 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][182]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 32 (text), line 36 (text), line 39 (text) and line 58 (text).
- [docs/references/automation/catzc-base-languages.md][183]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 78 (text) and line
  108 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][184]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][185]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/BashConfig.cs.md][186]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 18 (text) and line 42 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][187]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][188]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  19 (text) and line 46 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][189]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 19 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/types/PythonConfig.cs.md][190]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 18 (text) and line 45 (text).
- [docs/references/automation/catzc-base-maps.md][191]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 96
  (text), line 98 (text) and line 110 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][192]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 57 (text), line 63 (text), line 65 (text) and line 70 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][193]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][194]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][195]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][196]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][197]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][198]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][199]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][200]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 32 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][201]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19
  (text), line 36 (text), line 37 (text) and line 41 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][202]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][203]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][204]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 32 (text), line 33 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][205]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][206]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][207]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 39 (text), line 40 (text), line 43 (text) and line 86 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][208]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][209]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][210]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 33 (text), line 34 (text) and line 35 (text).
- [docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md][211]: selected by [ADR-REPO-FOLDERS][3]: the file cites
  it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][212]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 17 (text) and line 70 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][213]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text), line 94 (text), line 97 (text) and line 99 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][214]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][215]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 18 (text), line 52 (text), line 55 (text) and line 57 (text).
- [docs/references/note-file-kind.md][216]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 37 (text), line 51
  (text) and line 54 (text).
- [docs/references/pipelines/cd-apex.yaml.md][217]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 47 (text).
- [docs/references/pipelines/cd-flux.yaml.md][218]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 46 (text).
- [docs/references/pipelines/cd-nova.yaml.md][219]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 46 (text).
- [docs/references/pipelines/cd-shared.yaml.md][220]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 41 (text).
- [docs/references/pipelines/ci-automation.yaml.md][221]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 32
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][222]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 33 (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.github/workflows/ci-automation.yml][223]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/ci-automation.yaml][224]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's
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
  266 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 30 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 22 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 28 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 26 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 28 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 120 (text), `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 21 (header),
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
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 1235 (text),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 22 (header) and
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 31 (header); selected by [ADR-REPO-FOLDERS][3]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1` line 23 (header),
  `automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1` line 29 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 313 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 47 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 53 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 58 (body
  comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 86 (body comment),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 96 (body comment), `automation/Catzc.Base.Docs/configs/glossary.yml` line 62
  (text), `automation/Catzc.Base.Docs/private/Get-CatsModules.ps1` line 23 (header),
  `automation/Catzc.Base.Docs/private/Get-CatsModules.ps1` line 29 (header), `automation/Catzc.Base.Languages/types/BashConfig.cs` line 22
  (text), `automation/Catzc.Base.Languages/types/GoConfig.cs` line 23 (text), `automation/Catzc.Base.Languages/types/PythonConfig.cs` line
  22 (text), `automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1` line 23 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1` line 30 (header), `automation/Catzc.Base.QualityGates/Test-Plans.ps1` line
  22 (header), `automation/Catzc.Base.QualityGates/Test-Plans.ps1` line 30 (header), `automation/Catzc.Base.QualityGates/Test-Plans.ps1`
  line 102 (text), `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 71 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 113 (body comment) and
  `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 117 (body comment).

## Keywords

- [world map][226]
- [track][227]
- [file language][228]
- [cell][229]
- [lit cell][230]
- [.claude][231]: a track
- [automation][231]: a track
- [docs][231]: a track
- [github-workflows][231]: a track
- [pipelines][231]: a track
- [csharp][232]: a file language
- [markdown][232]: a file language
- [pipeline-yaml][232]: a file language
- [powershell][232]: a file language
- [yaml][232]: a file language

Terms the cited ADRs define:

- [cell][229], defined by [ADR-DSGN-TRACK#10][233]
- [deployable-unit][234], defined by [ADR-DSGN-TRACK#5][235]
- [domain][236], defined by [ADR-REPO-FOLDERS#5][237]
- [file language][228], defined by [ADR-DSGN-TRACK#6][5]
- [import][238], defined by [ADR-DSGN-TRACK#17][239]
- [landing address][240], defined by [ADR-DSGN-TRACK#17][239]
- [lit cell][230], defined by [ADR-DSGN-TRACK#12][6]
- [place][241], defined by [ADR-DSGN-TRACK#1][4]
- [root file][242], defined by [ADR-DSGN-TRACK#7][243]
- [sorting][244], defined by [ADR-DSGN-TRACK#17][239]
- [stack violation][245], defined by [ADR-DSGN-TRACK#11][246]
- [track][227], defined by [ADR-DSGN-TRACK#1][4]
- [unlisted file][247], defined by [ADR-DSGN-TRACK#8][248]
- [unordered track][249], defined by [ADR-DSGN-TRACK#17][239]
- [value-chain concern][250], defined by [ADR-DSGN-TRACK#15][251]
- [value-chain map][252], defined by [ADR-DSGN-TRACK#16][253]
- [value-chain stack][254], defined by [ADR-DSGN-TRACK#14][255]
- [verification track][256], defined by [ADR-DSGN-TRACK#2][257]
- [world map][226], defined by [ADR-DSGN-TRACK#9][258]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/repository/conventional-folders.md
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../../.claude/plans/decisions-2026-10-16.md
[8]: ../../../../.claude/plans/decisions-2026-10-18.md
[9]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[10]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[11]: ../../../../.claude/plans/plan-master.md
[12]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[13]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[14]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[15]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[16]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[17]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[18]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[19]: ../../../../.claude/plans/task-file-head-leftovers.md
[20]: ../../../../.claude/plans/task-import-landing-zone.md
[21]: ../../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[22]: ../../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[23]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[24]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[25]: ../../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[26]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[27]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[28]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[29]: ../../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[30]: ../../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[31]: ../../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[32]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[33]: ../../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[34]: ../../../../automation/Catzc.Base.Maps/types/MapCell.cs
[35]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[36]: ../../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[37]: ../../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[38]: ../../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[39]: ../../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[40]: ../../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[41]: ../../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[42]: ../../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[43]: ../../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[44]: ../../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[45]: ../../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[46]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[47]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[48]: ../../../../automation/Catzc.Base.Variants/types/PathModule.cs
[49]: ../../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[50]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[51]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[52]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[53]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[54]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[55]: ../../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[56]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[57]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[58]: ../../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[59]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[60]: ../../../../automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[61]: ../../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[62]: ../../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[63]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[64]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[65]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[66]: ../../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[67]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[68]: ../../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[69]: ../../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[70]: ../../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[71]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[72]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[73]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[74]: ../../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[75]: ../../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[76]: ../../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[77]: ../../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[78]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[79]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[80]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[81]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[82]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[83]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[84]: ../../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[85]: ../../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[86]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[87]: ../../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[88]: ../../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[89]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[90]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[91]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[92]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[93]: ../../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[94]: ../../../../automation/Catzc.Base.Languages/Get-PathFileType.ps1
[95]: ../../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[96]: ../../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[97]: ../../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[98]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[99]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[100]: ../../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[101]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[102]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[103]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[104]: ../../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[105]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[106]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[107]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[108]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[109]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[110]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[111]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[112]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[113]: ../../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[114]: ../../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[115]: ../../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[116]: ../../../../automation/Catzc.Base.QualityGates/Test-Plans.ps1
[117]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
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
[128]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
[129]: ../../../../automation/Catzc.Base.Variants/Get-PathModule.ps1
[130]: ../../../../automation/Catzc.Base.Variants/Get-Track.ps1
[131]: ../../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[132]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[133]: ../../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[134]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[135]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[136]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[137]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[138]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[139]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[140]: ../../../../automation/Catzc.Base.QualityGates/configs/source-conventions.yml
[141]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[142]: ../../../../automation/Catzc.Base.Variants/configs/track-types.yml
[143]: ../../../adr/design/dora-explains.md
[144]: ../../../adr/flow/dora-explains.md
[145]: ../../../adr/glossary.md
[146]: ../../../adr/index.md
[147]: ../../../adr/repository/dora-explains.md
[148]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[149]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[150]: ../../../how-to/automation/sort-an-import.md
[151]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[152]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[153]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[154]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[155]: ../../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[156]: ../../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[157]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[158]: ../../../references/automation/catzc-base-globs.md
[159]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[160]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[161]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[162]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[163]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[164]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[165]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[166]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[167]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[168]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[169]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[170]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[171]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[172]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[173]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[174]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[175]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[176]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[177]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[178]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[179]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[180]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[181]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[182]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[183]: ../../../references/automation/catzc-base-languages.md
[184]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[185]: ../../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[186]: ../../../references/automation/catzc-base-languages/types/BashConfig.cs.md
[187]: ../../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[188]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[189]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[190]: ../../../references/automation/catzc-base-languages/types/PythonConfig.cs.md
[191]: ../../../references/automation/catzc-base-maps.md
[192]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[193]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[194]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[195]: ../../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[196]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[197]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[198]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[199]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[200]: ../../../references/automation/catzc-base-maps/types/MapCell.cs.md
[201]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[202]: ../../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[203]: ../../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[204]: ../../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[205]: ../../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[206]: ../../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[207]: ../../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[208]: ../../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[209]: ../../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[210]: ../../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[211]: ../../../references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[212]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[213]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[214]: ../../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[215]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[216]: ../../../references/note-file-kind.md
[217]: ../../../references/pipelines/cd-apex.yaml.md
[218]: ../../../references/pipelines/cd-flux.yaml.md
[219]: ../../../references/pipelines/cd-nova.yaml.md
[220]: ../../../references/pipelines/cd-shared.yaml.md
[221]: ../../../references/pipelines/ci-automation.yaml.md
[222]: ../../../references/pipelines/ci-infrastructure.yaml.md
[223]: ../../../../.github/workflows/ci-automation.yml
[224]: ../../../../pipelines/ci-automation.yaml
[225]: ../../design/unit-to-pipeline-rule-is-review-only.md
[226]: ../../../adr/glossary.md#world-map
[227]: ../../../adr/glossary.md#track
[228]: ../../../adr/glossary.md#file-language
[229]: ../../../adr/glossary.md#cell
[230]: ../../../adr/glossary.md#lit-cell
[231]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[232]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[233]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[234]: ../../../adr/glossary.md#deployable-unit
[235]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[236]: ../../../adr/glossary.md#domain
[237]: ../../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[238]: ../../../adr/glossary.md#import
[239]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[240]: ../../../adr/glossary.md#landing-address
[241]: ../../../adr/glossary.md#place
[242]: ../../../adr/glossary.md#root-file
[243]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[244]: ../../../adr/glossary.md#sorting
[245]: ../../../adr/glossary.md#stack-violation
[246]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[247]: ../../../adr/glossary.md#unlisted-file
[248]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[249]: ../../../adr/glossary.md#unordered-track
[250]: ../../../adr/glossary.md#value-chain-concern
[251]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[252]: ../../../adr/glossary.md#value-chain-map
[253]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[254]: ../../../adr/glossary.md#value-chain-stack
[255]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[256]: ../../../adr/glossary.md#verification-track
[257]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[258]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9

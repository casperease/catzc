# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md

`Tree minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Tree minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.png)

The tree minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD][2], [ADR-FLOW-CD-GLOBS][3] and [ADR-REPO-FOLDERS][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 151 files in 18 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 38 lit files
- Maps (automation/Catzc.Base.Maps): 29 lit files
- adr/repo (docs/adr/repository): 16 lit files
- Docs (automation/Catzc.Base.Docs): 9 lit files
- Languages (automation/Catzc.Base.Languages): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 7 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- .github: 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file

## Why each group is lit

### Globs (38 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][5], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][8], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][9], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 72 (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][12], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][13], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][14], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][15], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][16], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][17], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][18], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 7
  (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][19], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][20], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][21], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][22], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][23], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][26], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][27], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][28], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][29], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][30], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][33], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][35], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][36], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][37], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 50 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5 (header), line 13
  (body comment), line 62 (text), line 75 (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][38], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][39], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][40], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][41], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][42], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### Maps (29 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][43], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (header), line 11 (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][44], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 8 (header), line 9 (header) and line 22 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][45], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header), line 8 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][46], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header), line 7 (header) and line 18 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][47], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 12 (header) and line 33 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][48], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (header), line 16 (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line
  68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][49], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 11 (header), line 14 (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102
  (text), line 106 (text) and line 107 (text).
- [automation/Catzc.Base.Maps/configs/maps.yml][50], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 26 (header), line 32 (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][51], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 9 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][52], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][53], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][54], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 72 (body comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][55], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 70 (text) and line 71 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][56], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line 61 (text), line 62
  (text), line 63 (text), line 64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][57], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header), line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81
  (text), line 90 (text), line 91 (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line
  121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][58], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text)
  and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][59], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][60], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 104 (text) and line 119 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][61], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 2 (header), line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][62], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 5 (header), line 6 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][63], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][64], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][65], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][66], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][67], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][68], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 7 (header), line 8 (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][69], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][70], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][71], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 4 (header), line 5 (header) and line 6 (header).

### adr/repo (16 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][72], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][73], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][74], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][4], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][75], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][76], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][77], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][78], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][79], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][80], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][81], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][82], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][83], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/protected-globs.md][84], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][85], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][86], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### Docs (9 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][87], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line
  118 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 308 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][88], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][89], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][90], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][91], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][92], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][93], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][94], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment); selected by [ADR-FLOW-CD][2]: the file cites it
  at line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][95], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Languages (9 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][96], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][97], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][98], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][99], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][100], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][101], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][102], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][103], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][104], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][105], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][106], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][107], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][108], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][109], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][110], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][111], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][112], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### QualityGates (7 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][113], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][114], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 62 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][115], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 318 (text) and line 321 (text).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][116], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][117], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][118], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][119], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9 (header).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][120], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][121], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][122], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-types.md][123], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][124], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][125], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][126], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][127], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][128], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][129], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][130], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][131], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][132], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][133], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][134], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (header).

### docs (5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][135], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 18 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][136], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 19 (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line
  30 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs.md][137], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][138], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 47 (text) and line 77 (text).
- [docs/references/automation/catzc-base-maps.md][139], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][140], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][141], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][142], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][143], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### ModuleSystem (2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][144], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (header) and line 89 (body comment).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][145], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 21 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][146], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 292
  (text) and line 305 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 765 (text).
- [docs/adr/index.md][147], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 111 (text); selected
  by [ADR-REPO-FOLDERS][4]: the file cites it at line 286 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][148], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][149], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (body comment) (a passing mention only).

### Contracts (1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][150], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 7 (header).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][151], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).

## Keywords

- [world map][152]
- [track][153]
- [file language][154]
- [cell][155]
- [lit cell][156]
- [.claude][141]: a track
- [.github][141]: a track
- [automation][141]: a track
- [docs][141]: a track
- [pipelines][141]: a track
- [csharp][98]: a file language
- [markdown][98]: a file language
- [pipeline-yaml][98]: a file language
- [powershell][98]: a file language
- [yaml][98]: a file language

Terms the cited ADRs define:

- [cell][155], defined by [ADR-DSGN-TRACK#10][157]
- [deployable-unit][158], defined by [ADR-DSGN-TRACK#5][159]
- [domain][160], defined by [ADR-REPO-FOLDERS#5][161]
- [file language][154], defined by [ADR-DSGN-TRACK#6][162]
- [gate][163], defined by [ADR-FLOW-CD#13][164]
- [lit cell][156], defined by [ADR-DSGN-TRACK#12][165]
- [release candidate][166], defined by [ADR-FLOW-CD#14][167]
- [root file][168], defined by [ADR-DSGN-TRACK#7][169]
- [stack violation][170], defined by [ADR-DSGN-TRACK#11][171]
- [track][153], defined by [ADR-DSGN-TRACK#1][172]
- [unlisted file][173], defined by [ADR-DSGN-TRACK#8][174]
- [value-chain concern][175], defined by [ADR-DSGN-TRACK#15][176]
- [value-chain map][177], defined by [ADR-DSGN-TRACK#16][178]
- [value-chain stack][179], defined by [ADR-DSGN-TRACK#14][180]
- [verification track][181], defined by [ADR-DSGN-TRACK#2][182]
- [world map][152], defined by [ADR-DSGN-TRACK#9][183]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/flow/durable-sha-globs.md
[4]: ../../adr/repository/conventional-folders.md
[5]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[6]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[7]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[8]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[10]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[11]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[12]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[13]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[14]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[15]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[16]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[17]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[18]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[19]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[20]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[21]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[22]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[23]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[24]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[25]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[26]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[27]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[28]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[29]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[30]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[31]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[32]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[33]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[34]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[35]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[36]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[37]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[38]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[39]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[40]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[41]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[42]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[43]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[44]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[45]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[46]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[47]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[48]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[49]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[50]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[51]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[52]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[53]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[54]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[55]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[56]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[57]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[58]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[59]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[60]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[61]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[62]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[63]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[64]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[65]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[66]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[67]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[68]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[69]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[70]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[71]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[72]: ../../adr/repository/agent-definitions.md
[73]: ../../adr/repository/api-contracts.md
[74]: ../../adr/repository/controlled-vocabulary.md
[75]: ../../adr/repository/dedicated-output-directory.md
[76]: ../../adr/repository/documentation-examples.md
[77]: ../../adr/repository/domain-language-separation.md
[78]: ../../adr/repository/dora-explains.md
[79]: ../../adr/repository/generated-readmes.md
[80]: ../../adr/repository/generated-root-configs.md
[81]: ../../adr/repository/inspiration.md
[82]: ../../adr/repository/markdown-links.md
[83]: ../../adr/repository/output-formats.md
[84]: ../../adr/repository/protected-globs.md
[85]: ../../adr/repository/repo-variants.md
[86]: ../../adr/repository/uniform-formatting.md
[87]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[88]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[89]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[90]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[91]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[92]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[93]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[94]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[95]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[96]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[97]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[98]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[99]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[100]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[101]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[102]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[103]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[104]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[105]: ../../adr/design/commit-lifecycle.md
[106]: ../../adr/design/dora-explains.md
[107]: ../../adr/design/module-aspects.md
[108]: ../../adr/design/run-modes.md
[109]: ../../adr/design/self-service.md
[110]: ../../adr/design/server-remote-integration.md
[111]: ../../adr/design/thin-platforms.md
[112]: ../../adr/design/visual-design.md
[113]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[114]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[115]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[116]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[117]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[118]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[119]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[120]: ../../adr/flow/dora-explains.md
[121]: ../../adr/flow/pipeline-detection.md
[122]: ../../adr/flow/pipeline-runner-pattern.md
[123]: ../../adr/flow/pipeline-types.md
[124]: ../../../pipelines/cd-apex.yaml
[125]: ../../../pipelines/cd-flux.yaml
[126]: ../../../pipelines/cd-nova.yaml
[127]: ../../../pipelines/cd-shared.yaml
[128]: ../../../pipelines/ci-automation.yaml
[129]: ../../../pipelines/ci-infrastructure.yaml
[130]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[131]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[132]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[133]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[134]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[135]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[136]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[137]: ../../references/automation/catzc-base-globs.md
[138]: ../../references/automation/catzc-base-languages.md
[139]: ../../references/automation/catzc-base-maps.md
[140]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[141]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[142]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[143]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[144]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[145]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[146]: ../../adr/glossary.md
[147]: ../../adr/index.md
[148]: ../../../.claude/CLAUDE.md
[149]: ../../../.github/workflows/ci-automation.yml
[150]: ../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[151]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[152]: ../../adr/glossary.md#world-map
[153]: ../../adr/glossary.md#track
[154]: ../../adr/glossary.md#file-language
[155]: ../../adr/glossary.md#cell
[156]: ../../adr/glossary.md#lit-cell
[157]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[158]: ../../adr/glossary.md#deployable-unit
[159]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[160]: ../../adr/glossary.md#domain
[161]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[162]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[163]: ../../adr/glossary.md#gate
[164]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[165]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[166]: ../../adr/glossary.md#release-candidate
[167]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[168]: ../../adr/glossary.md#root-file
[169]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[170]: ../../adr/glossary.md#stack-violation
[171]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[172]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[173]: ../../adr/glossary.md#unlisted-file
[174]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[175]: ../../adr/glossary.md#value-chain-concern
[176]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[177]: ../../adr/glossary.md#value-chain-map
[178]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[179]: ../../adr/glossary.md#value-chain-stack
[180]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[181]: ../../adr/glossary.md#verification-track
[182]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[183]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

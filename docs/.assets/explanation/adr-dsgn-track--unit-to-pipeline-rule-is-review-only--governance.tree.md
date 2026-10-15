# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md

`Tree minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Tree minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.png)

The tree minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD][2], [ADR-FLOW-CD-GLOBS][3] and [ADR-REPO-FOLDERS][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 127 files in 18 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 38 lit files
- Maps (automation/Catzc.Base.Maps): 29 lit files
- Docs (automation/Catzc.Base.Docs): 9 lit files
- Languages (automation/Catzc.Base.Languages): 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 7 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- adr/flow (docs/adr/flow): 3 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- .claude: 1 lit file
- .github: 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file

## Why each group is lit

### Globs (automation/Catzc.Base.Globs, 38 lit files)

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

### Maps (automation/Catzc.Base.Maps, 29 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][43], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (header), line 11 (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][44], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 8 (header), line 9 (header) and line 22 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][45], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header), line 8 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][46], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header), line 7 (header) and line 19 (header).
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
  file cites it at line 75 (body comment) and line 91 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][55], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and line 71
  (text).
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
  [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text), line 112 (text) and line 126 (text).
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
  cites it at line 8 (header), line 9 (header) and line 12 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][69], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][70], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][71], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 4 (header), line 5 (header) and line 6 (header).

### Docs (automation/Catzc.Base.Docs, 9 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][72], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line
  118 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 308 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][73], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][74], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][75], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][76], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][77], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][78], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][79], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment); selected by [ADR-FLOW-CD][2]: the file cites it
  at line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][80], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Languages (automation/Catzc.Base.Languages, 9 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][81], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][82], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][83], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][85], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][86], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][87], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][88], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][89], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 7 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][90], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][91], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 62 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][92], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 318 (text) and line 321 (text).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][93], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][94], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][95], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][96], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9 (header).

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][97], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][98], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][99], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][100], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][101], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][102], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation, 5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][103], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][104], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][105], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][106], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][107], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (header).

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][108], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 18 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][109], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 19 (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line
  30 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs.md][110], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][111], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 47 (text) and line 77 (text).
- [docs/references/automation/catzc-base-maps.md][112], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### Variants (automation/Catzc.Base.Variants, 4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][113], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][114], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][115], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][116], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### adr/flow (docs/adr/flow, 3 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][117], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 13 (text);
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 94 (text).
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][118], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (header) and line 89 (body comment).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][119], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 21 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][120], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 292
  (text) and line 305 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 765 (text).
- [docs/adr/index.md][121], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 111 (text); selected
  by [ADR-REPO-FOLDERS][4]: the file cites it at line 286 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][122], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13
  (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/conventional-folders.md][4], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][123], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 13
  (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][124], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][125], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (body comment) (a passing mention only).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][126], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 7 (header).

### Exporter (automation/Catzc.Base.Exporter, 1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][127], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).

## Keywords

- [world map][128]
- [track][129]
- [file language][130]
- [cell][131]
- [lit cell][132]
- [.claude][114]: a track
- [.github][114]: a track
- [automation][114]: a track
- [docs][114]: a track
- [pipelines][114]: a track
- [csharp][83]: a file language
- [markdown][83]: a file language
- [pipeline-yaml][83]: a file language
- [powershell][83]: a file language
- [yaml][83]: a file language

Terms the cited ADRs define:

- [cell][131], defined by [ADR-DSGN-TRACK#10][133]
- [deployable-unit][134], defined by [ADR-DSGN-TRACK#5][135]
- [domain][136], defined by [ADR-REPO-FOLDERS#5][137]
- [file language][130], defined by [ADR-DSGN-TRACK#6][138]
- [gate][139], defined by [ADR-FLOW-CD#13][140]
- [lit cell][132], defined by [ADR-DSGN-TRACK#12][141]
- [release candidate][142], defined by [ADR-FLOW-CD#14][143]
- [root file][144], defined by [ADR-DSGN-TRACK#7][145]
- [stack violation][146], defined by [ADR-DSGN-TRACK#11][147]
- [track][129], defined by [ADR-DSGN-TRACK#1][148]
- [unlisted file][149], defined by [ADR-DSGN-TRACK#8][150]
- [value-chain concern][151], defined by [ADR-DSGN-TRACK#15][152]
- [value-chain map][153], defined by [ADR-DSGN-TRACK#16][154]
- [value-chain stack][155], defined by [ADR-DSGN-TRACK#14][156]
- [verification track][157], defined by [ADR-DSGN-TRACK#2][158]
- [world map][128], defined by [ADR-DSGN-TRACK#9][159]

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
[72]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[73]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[74]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[75]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[76]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[77]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[78]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[79]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[80]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[81]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[82]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[83]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[84]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[85]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[86]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[87]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[88]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[89]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[90]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[91]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[92]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[93]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[94]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[95]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[96]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[97]: ../../../pipelines/cd-apex.yaml
[98]: ../../../pipelines/cd-flux.yaml
[99]: ../../../pipelines/cd-nova.yaml
[100]: ../../../pipelines/cd-shared.yaml
[101]: ../../../pipelines/ci-automation.yaml
[102]: ../../../pipelines/ci-infrastructure.yaml
[103]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[104]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[105]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[106]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[107]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[108]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[109]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[110]: ../../references/automation/catzc-base-globs.md
[111]: ../../references/automation/catzc-base-languages.md
[112]: ../../references/automation/catzc-base-maps.md
[113]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[114]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[115]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[116]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[117]: ../../adr/flow/dora-explains.md
[118]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[119]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[120]: ../../adr/glossary.md
[121]: ../../adr/index.md
[122]: ../../adr/design/dora-explains.md
[123]: ../../adr/repository/dora-explains.md
[124]: ../../../.claude/CLAUDE.md
[125]: ../../../.github/workflows/ci-automation.yml
[126]: ../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[127]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[128]: ../../adr/glossary.md#world-map
[129]: ../../adr/glossary.md#track
[130]: ../../adr/glossary.md#file-language
[131]: ../../adr/glossary.md#cell
[132]: ../../adr/glossary.md#lit-cell
[133]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[134]: ../../adr/glossary.md#deployable-unit
[135]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[136]: ../../adr/glossary.md#domain
[137]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[138]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[139]: ../../adr/glossary.md#gate
[140]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[141]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[142]: ../../adr/glossary.md#release-candidate
[143]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[144]: ../../adr/glossary.md#root-file
[145]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[146]: ../../adr/glossary.md#stack-violation
[147]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[148]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
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

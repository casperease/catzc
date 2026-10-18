# Test-GlobSetIndependence groups every set by layer and tests each same-layer pair: the tree minimap

```text
Which files cite ADR-FLOW-CD-GLOBS: every file of the world map is a tile, grouped by top-level folder.
74 files lit in 8 groups.
```

![The tree minimap of Test-GlobSetIndependence groups every set by layer and tests each same-layer pair](adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Test-GlobSetIndependence groups every set by layer and tests each
same-layer pair][75], which explains [ADR-FLOW-CD-GLOBS][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 74 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 59 lit files
- Globs (automation/Catzc.Base.Globs): 8 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .github: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 59 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 16 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][3], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 55 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][4], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][5], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][6], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][7], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][8], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 27 (text).
- [docs/references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text) and line 27 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSet.ps1.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 14 (text) and line 16 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 20 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetTrigger.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text), line 29 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/automation/catzc-base-globs/Get-TrackedFile.ps1.md][19], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (text) and line 20 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][30], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 33 (text) and line 108 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][32], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][33], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][34], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][35], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][36], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][37], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][38], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 11 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][39], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][40], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][41], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][43], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][46], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 19 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][47], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 11 (text) and line 17 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][48], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][49], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line
  38 (text), line 47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][50], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md][51], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 97 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][53], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 80 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (text).
- [docs/references/pipelines/cd-apex.yaml.md][55], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][56], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][57], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][58], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][59], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 13 (text).

### Globs (automation/Catzc.Base.Globs, 8 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][61], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 42 (text).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][62], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (text) and line 4 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][63], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 58 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][64], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 9 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][65], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][66], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 23 (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][67], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 54 (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][68], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 73 (text), line 136 (text), line 140 (text) and line 154 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][69], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 92
  (text).
- [docs/adr/flow/durable-sha-globs.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the ADR's own file.

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][70], in the cell github-workflows × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 4 (body comment) (a passing mention only).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][71], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 101 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][72], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 1216 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][73], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 133 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][74], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 101 (text),
  `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42 (text),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 4 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 58 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1`
  line 53 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 89 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 23
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 31
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 47
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 1216 (text).

## Keywords

- [world map][76]
- [track][77]
- [file language][78]
- [cell][79]
- [lit cell][80]
- [automation][81]: a track
- [docs][81]: a track
- [github-workflows][81]: a track
- [pipelines][81]: a track
- [csharp][82]: a file language
- [markdown][82]: a file language
- [pipeline-yaml][82]: a file language
- [powershell][82]: a file language
- [yaml][82]: a file language

[1]: ../../../adr/flow/durable-sha-globs.md
[2]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[3]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[4]: ../../../references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[5]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[6]: ../../../references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[7]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[8]: ../../../references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[9]: ../../../references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[10]: ../../../references/automation/catzc-base-globs.md
[11]: ../../../references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[12]: ../../../references/automation/catzc-base-globs/Get-GlobSet.ps1.md
[13]: ../../../references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[14]: ../../../references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md
[15]: ../../../references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md
[16]: ../../../references/automation/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[17]: ../../../references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[18]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[19]: ../../../references/automation/catzc-base-globs/Get-TrackedFile.ps1.md
[20]: ../../../references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[21]: ../../../references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[22]: ../../../references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md
[23]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[24]: ../../../references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[25]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[26]: ../../../references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md
[27]: ../../../references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[28]: ../../../references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[29]: ../../../references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[30]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[31]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[32]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[33]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[34]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[35]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[36]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[37]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[38]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[39]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[40]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[41]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[42]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[43]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[44]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[45]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[46]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[47]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[48]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[49]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[50]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[51]: ../../../references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
[52]: ../../../references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[53]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[54]: ../../../references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[55]: ../../../references/pipelines/cd-apex.yaml.md
[56]: ../../../references/pipelines/cd-flux.yaml.md
[57]: ../../../references/pipelines/cd-nova.yaml.md
[58]: ../../../references/pipelines/cd-shared.yaml.md
[59]: ../../../references/pipelines/ci-automation.yaml.md
[60]: ../../../references/pipelines/ci-infrastructure.yaml.md
[61]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[62]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[63]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[64]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[65]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[66]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[67]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[68]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[69]: ../../../adr/flow/dora-explains.md
[70]: ../../../../.github/workflows/ci-automation.yml
[71]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[72]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[73]: ../../../adr/index.md
[74]: ../../../../pipelines/ci-automation.yaml
[75]: ../../flow/independence-check-groups-by-layer.md
[76]: ../../../adr/glossary.md#world-map
[77]: ../../../adr/glossary.md#track
[78]: ../../../adr/glossary.md#file-language
[79]: ../../../adr/glossary.md#cell
[80]: ../../../adr/glossary.md#lit-cell
[81]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[82]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

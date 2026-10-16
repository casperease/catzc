# docs/.assets/explanation/tree/adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture.tree.md

`Tree minimap: adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture`

![Tree minimap of adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture](adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture.tree.png)

The tree minimap of the slide `adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture` (architecture lens). The
slide supports [ADR-FLOW-CD-DETECT][1] and [ADR-FLOW-CD-GLOBS][2]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 99 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 39 lit files
- docs (docs/ outside docs/adr/): 36 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 6 lit files
- .unordered: 5 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 4 lit files
- adr/flow (docs/adr/flow): 3 lit files
- .github: 1 lit file
- Az.Templates (automation/Catzc.Azure.Templates): 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Globs (automation/Catzc.Base.Globs, 39 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][3], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 19 (header) and line 25 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][4], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 19 (header) and line 24 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1][5], in the cell automation × powershell: selected by [ADR-FLOW-CD-DETECT][1]: the
  file cites it at line 19 (header) and line 25 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 19 (header), line 24 (header) and line 27 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 19 (header) and line 27 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][8], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 19 (header) and line 24 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][9], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 25 (header).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][12], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][13], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][14], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 21 (header) and line 32 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][15], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 22 (header), line 35 (header) and line 94 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][16], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][17], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][18], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][19], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][20], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 20 (header) and line 30 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][21], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][22], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1][23], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][26], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][27], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][28], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][29], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][30], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header), line 24 (text) and line 26 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][33], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header) and line 80 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][35], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 19 (header) and line 31 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header), line 77 (text), line 90 (text), line 101 (text) and line 113 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][37], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 21 (text).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][38], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 19 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][39], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 20 (text), line 46 (text), line 50 (text), line 54 (text), line 66 (text), line 70 (text) and line 79 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][40], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 20 (text) and line 78 (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][41], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 20 (text), line 97 (text), line 160 (text), line 164 (text) and line 178 (text).

### docs (docs/ outside docs/adr/, 36 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text) and line 35 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][43], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][44], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 34 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs.md][46], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 50 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][47], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (text), line 34 (text), line 37 (text) and line 85 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 30 (text) and line 40 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][49], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 17 (text), line 32 (text), line 37 (text), line 45 (text), line 47 (text), line 61 (text), line 91 (text) and
  line 105 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][50], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][51], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][53], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 30 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][55], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][57], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][58], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 29 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][60], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][63], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 29 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][65], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text), line 33 (text), line 35 (text) and line 44 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][66], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][67], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 29 (text) and line 35 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][68], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 35 (text), line 36 (text) and line 37 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][69], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 16 (text), line 31 (text), line 33 (text), line 34 (text), line 40 (text), line 43 (text), line 45 (text), line
  48 (text), line 56 (text), line 65 (text), line 83 (text), line 100 (text), line 110 (text), line 134 (text) and line 142 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][70], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text), line 31 (text), line 35 (text), line 38 (text) and line 57 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][71], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text) and line 69 (text).
- [docs/references/pipelines/cd-apex.yaml.md][72], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 46 (text).
- [docs/references/pipelines/cd-flux.yaml.md][73], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 45 (text).
- [docs/references/pipelines/cd-nova.yaml.md][74], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 45 (text).
- [docs/references/pipelines/cd-shared.yaml.md][75], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 40 (text).
- [docs/references/pipelines/ci-automation.yaml.md][76], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 30 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][77], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 32 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 6 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][78], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 22 (header) and line 101 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][79], in the cell automation × yaml: selected by [ADR-FLOW-CD-DETECT][1]:
  the file cites it at line 29 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][80], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 1211 (text).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][81], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][82], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][83], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and line 30 (header).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][84], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 43 (text), line 96 (text), line 124 (text) and line 167 (text).
- [.unordered/15-10-2026/plan-adr-pwsh-followups.md][85], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file
  cites it at line 111 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][86], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 101 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][87], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 96 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 97 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][88], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 38 (text), line 39 (text), line 58 (text), line 77 (text), line 103 (text) and line 103 (text).

### Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation, 4 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][89], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header) and line 29 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][90], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][91], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][92], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (header) and line 27 (header).

### adr/flow (docs/adr/flow, 3 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][93], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 80
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 123 (text).
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][94], in the cell github-workflows × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 19 (body comment) (a passing mention only).

### Az.Templates (automation/Catzc.Azure.Templates, 1 lit file)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1][95], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 20 (header).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][96], in the cell automation × yaml: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it
  at line 116 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 118 (text).

### Exporter (automation/Catzc.Base.Exporter, 1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][97], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 20 (header) and line 26 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][98], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 126 (text); selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 128 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][99], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1` line 20
  (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text), `automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1` line 19
  (header), `automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1` line 25 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1` line 19 (header) and
  `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 29 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 19 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 29 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 27 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 25 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 19 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 27 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 118 (text), `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 20 (header),
  `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 26 (header), `automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1` line 19
  (header), `automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1` line 25 (header), `automation/Catzc.Base.Globs/Get-GlobSet.ps1` line 19
  (header), `automation/Catzc.Base.Globs/Get-GlobSet.ps1` line 24 (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 19
  (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 24 (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 27
  (header), `automation/Catzc.Base.Globs/Get-GlobSetHash.ps1` line 19 (header), `automation/Catzc.Base.Globs/Get-GlobSetHash.ps1` line 27
  (header), `automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1` line 19 (header), `automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1` line
  24 (header), `automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1` line 26 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 25
  (header), `automation/Catzc.Base.Globs/Get-TrackedFile.ps1` line 20 (header), `automation/Catzc.Base.Globs/Get-TrackedFile.ps1` line 25
  (header), `automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1` line 21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 32 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 22 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1`
  line 35 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 94 (text),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 27 (header), `automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1`
  line 20 (header), `automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1` line 27 (header),
  `automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1` line 20 (header), `automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1`
  line 25 (header), `automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1` line 26 (header),
  `automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1` line 30 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 80 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 19 (header), `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1`
  line 31 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 90 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 101 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 113 (text), `automation/Catzc.Base.Globs/types/Aspect.cs` line 21
  (text), `automation/Catzc.Base.Globs/types/DurableHash.cs` line 19 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 20
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 46 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 50
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 54 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 66
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 70 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 79
  (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 20 (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 78 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 20 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 97 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 160 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 164 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 178 (text), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 22
  (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 101 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 1211 (text),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 21 (header) and
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 30 (header).

## Keywords

- [world map][100]
- [track][101]
- [file language][102]
- [cell][103]
- [lit cell][104]
- [.unordered][105]: a track
- [automation][105]: a track
- [docs][105]: a track
- [github-workflows][105]: a track
- [pipelines][105]: a track
- [csharp][106]: a file language
- [markdown][106]: a file language
- [pipeline-yaml][106]: a file language
- [powershell][106]: a file language
- [yaml][106]: a file language

[1]: ../../../adr/flow/pipeline-detection.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[4]: ../../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[5]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
[6]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[7]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[8]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[9]: ../../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[10]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[11]: ../../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[12]: ../../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[13]: ../../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[14]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[15]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[16]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[17]: ../../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[18]: ../../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[19]: ../../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[20]: ../../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[21]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[22]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[23]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
[24]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[25]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[26]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[27]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[28]: ../../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[29]: ../../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[30]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[31]: ../../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[32]: ../../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[33]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[34]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[35]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[36]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[37]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[38]: ../../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[39]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[40]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[41]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[42]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[43]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[44]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[45]: ../../../references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[46]: ../../../references/automation/catzc-base-globs.md
[47]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[48]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[49]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[50]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[51]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[52]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[53]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[54]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[55]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[56]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[57]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[58]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[59]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[60]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[61]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[62]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[63]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[64]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[65]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[66]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[67]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[68]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[69]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[70]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[71]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[72]: ../../../references/pipelines/cd-apex.yaml.md
[73]: ../../../references/pipelines/cd-flux.yaml.md
[74]: ../../../references/pipelines/cd-nova.yaml.md
[75]: ../../../references/pipelines/cd-shared.yaml.md
[76]: ../../../references/pipelines/ci-automation.yaml.md
[77]: ../../../references/pipelines/ci-infrastructure.yaml.md
[78]: ../../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[79]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[80]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[81]: ../../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[82]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[83]: ../../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[84]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[85]: ../../../../.unordered/15-10-2026/plan-adr-pwsh-followups.md
[86]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[87]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[88]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[89]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[90]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[91]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[92]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[93]: ../../../adr/flow/dora-explains.md
[94]: ../../../../.github/workflows/ci-automation.yml
[95]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
[96]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[97]: ../../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[98]: ../../../adr/index.md
[99]: ../../../../pipelines/ci-automation.yaml
[100]: ../../../adr/glossary.md#world-map
[101]: ../../../adr/glossary.md#track
[102]: ../../../adr/glossary.md#file-language
[103]: ../../../adr/glossary.md#cell
[104]: ../../../adr/glossary.md#lit-cell
[105]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[106]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

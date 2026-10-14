# docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md

`Tree minimap: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation`

![Tree minimap of adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation](adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.png)

The tree minimap of the slide `adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation` (implementation lens). The slide
supports [ADR-FLOW-CD-GLOBS][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 65 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 38 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 4 lit files
- docs (docs/ outside docs/adr/): 2 lit files
- .github: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Globs (38 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][2], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][3], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][4], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][5], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][8], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 72 (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][9], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][10], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][11], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][12], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][13], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][14], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][15], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 2 (header), line 7 (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body
  comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][16], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][17], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][18], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][19], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][20], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][21], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][22], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][23], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][26], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][27], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][28], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][29], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][30], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][33], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text),
  line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][35], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][36], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][37], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][38], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][39], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][43], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow`
  ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][44], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][45], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][46], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][47], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][48], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][49], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (header).
- [pipelines/ci-infrastructure.yaml][50], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][51], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][52], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][53], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][54], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][55], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (header).

### QualityGates (4 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][56], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][57], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][58], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][59], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 9 (header).

### docs (2 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs.md][61], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 29 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][62], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (body comment) (a passing mention only).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][63], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 122 (text).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][64], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 6 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][65], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 111 (text).

## Keywords

- [world map][66]
- [track][67]
- [file language][68]
- [cell][69]
- [lit cell][70]
- [.github][71]: a track
- [automation][71]: a track
- [docs][71]: a track
- [pipelines][71]: a track
- [csharp][72]: a file language
- [markdown][72]: a file language
- [pipeline-yaml][72]: a file language
- [powershell][72]: a file language
- [yaml][72]: a file language

[1]: ../../adr/flow/durable-sha-globs.md
[2]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[3]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[4]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[5]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[6]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[7]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[8]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[10]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[11]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[12]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[13]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[14]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[15]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[16]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[17]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[18]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[19]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[20]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[21]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[22]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[23]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[24]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[25]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[26]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[27]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[28]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[29]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[30]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[31]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[32]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[33]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[34]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[35]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[36]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[37]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[38]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[39]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[40]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[41]: ../../adr/flow/dora-explains.md
[42]: ../../adr/flow/pipeline-detection.md
[43]: ../../adr/flow/pipeline-runner-pattern.md
[44]: ../../adr/flow/pipeline-types.md
[45]: ../../../pipelines/cd-apex.yaml
[46]: ../../../pipelines/cd-flux.yaml
[47]: ../../../pipelines/cd-nova.yaml
[48]: ../../../pipelines/cd-shared.yaml
[49]: ../../../pipelines/ci-automation.yaml
[50]: ../../../pipelines/ci-infrastructure.yaml
[51]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[52]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[53]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[54]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[55]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[56]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[57]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[58]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[59]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[60]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[61]: ../../references/automation/catzc-base-globs.md
[62]: ../../../.github/workflows/ci-automation.yml
[63]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[64]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[65]: ../../adr/index.md
[66]: ../../adr/glossary.md#world-map
[67]: ../../adr/glossary.md#track
[68]: ../../adr/glossary.md#file-language
[69]: ../../adr/glossary.md#cell
[70]: ../../adr/glossary.md#lit-cell
[71]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[72]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

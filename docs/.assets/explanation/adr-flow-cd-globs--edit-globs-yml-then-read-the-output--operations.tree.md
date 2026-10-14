# docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md

`Tree minimap: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations`

![Tree minimap of adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations](adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.png)

The tree minimap of the slide `adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations` (operations lens). The slide supports
[ADR-FLOW-CD-GLOBS][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 91 files in 10 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- Globs (automation/Catzc.Base.Globs): 38 lit files
- docs (docs/ outside docs/adr/): 28 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 4 lit files
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

### docs (28 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][40], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][41], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][42], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][43], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][44], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][45], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][46], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][47], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][48], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][49], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][50], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][51], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][52], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 51 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][53], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 59 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 49 (text) and line 67 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][55], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 59 (text) and line 59 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][56], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][57], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 17 (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][58], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57
  (text), line 58 (text), line 59 (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][59], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][61], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 18 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][62], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 16 (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][63], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 13 (text), line 38 (text) and line 40 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][64], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][65], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 15 (text), line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][66], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs.md][67], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 29 (text).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][68], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][69], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][70], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][71], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow`
  ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][72], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][73], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][74], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][75], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][76], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][77], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (header).
- [pipelines/ci-infrastructure.yaml][78], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][79], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][80], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][81], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][82], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][83], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (header).

### QualityGates (4 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][84], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][85], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][86], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][87], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 9 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][88], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (body comment) (a passing mention only).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][89], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 122 (text).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][90], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 6 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][91], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 111 (text).

## Keywords

- [world map][92]
- [track][93]
- [file language][94]
- [cell][95]
- [lit cell][96]
- [.github][97]: a track
- [automation][97]: a track
- [docs][97]: a track
- [pipelines][97]: a track
- [csharp][98]: a file language
- [markdown][98]: a file language
- [pipeline-yaml][98]: a file language
- [powershell][98]: a file language
- [yaml][98]: a file language

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
[40]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[41]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[42]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[43]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[44]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[45]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[46]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[47]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[48]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[49]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[50]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[51]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[52]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[53]: ../../explanation/design/one-folder-two-independent-readers.md
[54]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[55]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[56]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[57]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[58]: ../../explanation/flow/gates-check-source-and-trigger.md
[59]: ../../explanation/flow/globs-module-owns-config-and-types.md
[60]: ../../explanation/flow/independence-check-groups-by-layer.md
[61]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[62]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[63]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[64]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[65]: ../../explanation/flow/two-declared-layers-one-derived.md
[66]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[67]: ../../references/automation/catzc-base-globs.md
[68]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[69]: ../../adr/flow/dora-explains.md
[70]: ../../adr/flow/pipeline-detection.md
[71]: ../../adr/flow/pipeline-runner-pattern.md
[72]: ../../adr/flow/pipeline-types.md
[73]: ../../../pipelines/cd-apex.yaml
[74]: ../../../pipelines/cd-flux.yaml
[75]: ../../../pipelines/cd-nova.yaml
[76]: ../../../pipelines/cd-shared.yaml
[77]: ../../../pipelines/ci-automation.yaml
[78]: ../../../pipelines/ci-infrastructure.yaml
[79]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[80]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[81]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[82]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[83]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[84]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[85]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[86]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[87]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[88]: ../../../.github/workflows/ci-automation.yml
[89]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[90]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[91]: ../../adr/index.md
[92]: ../../adr/glossary.md#world-map
[93]: ../../adr/glossary.md#track
[94]: ../../adr/glossary.md#file-language
[95]: ../../adr/glossary.md#cell
[96]: ../../adr/glossary.md#lit-cell
[97]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[98]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

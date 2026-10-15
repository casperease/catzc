# docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md

`Tree minimap: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance`

![Tree minimap of adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance` (governance lens). The slide
supports [ADR-DSGN-ASPECT][1], [ADR-FLOW-CD-GLOBS][2], [ADR-PWSH-MANIFEST][3], [ADR-PWSH-ONEFUNC][4] and [ADR-REPO-FOLDERS][5]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 90 files in 21 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 40 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- Docs (automation/Catzc.Base.Docs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Languages (automation/Catzc.Base.Languages): 3 lit files
- adr/pwsh (docs/adr/pwsh): 3 lit files
- docs (docs/ outside docs/adr/): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- Root files: 1 lit file
- .claude: 1 lit file
- .github: 1 lit file
- .internal (automation/.internal): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- Overlay (automation/Catzc.Base.Overlay): 1 lit file

## Why each group is lit

### Globs (automation/Catzc.Base.Globs, 40 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][8], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][9], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][12], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72
  (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][13], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][14], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][15], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][16], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][17], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][18], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][19], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 2 (header), line 7 (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body
  comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][20], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][21], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][22], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][23], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][26], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][27], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][28], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][29], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][30], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][33], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][35], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][37], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][38], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][39], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][40], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text),
  line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][41], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 1 (header), line 14 (header) and line 92 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][42], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][43], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][44], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][45], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 6 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][46], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][47], in the cell automation × yaml: selected by [ADR-PWSH-ONEFUNC][4]: the
  file cites it at line 590 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1][48], in the cell automation × powershell: selected by
  [ADR-PWSH-ONEFUNC][4]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][49], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][50], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][51], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][52], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][53], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][54], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][55], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][56], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (header).
- [pipelines/ci-infrastructure.yaml][57], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation, 5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][58], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][59], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][60], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][61], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][62], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (header).

### Docs (automation/Catzc.Base.Docs, 4 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][63], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 122 (text); selected by [ADR-PWSH-MANIFEST][3]: the file
  cites it at line 188 (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 186 (text); selected by [ADR-REPO-FOLDERS][5]:
  the file cites it at line 308 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][64], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][5]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][65], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][5]: the file cites it
  at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][66], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][5]: the
  file cites it at line 7 (header).

### Variants (automation/Catzc.Base.Variants, 4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][67], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][68], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][69], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][70], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### Languages (automation/Catzc.Base.Languages, 3 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/types/BashConfig.cs][71], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][72], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][73], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 15 (header).

### adr/pwsh (docs/adr/pwsh, 3 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/dora-explains.md][74], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 63
  (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 29 (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][3], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: the ADR's own file.
- [docs/adr/pwsh/one-function-per-file.md][4], in the cell docs × markdown: selected by [ADR-PWSH-ONEFUNC][4]: the ADR's own file.

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][75], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs.md][76], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][77], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites
  it at line 47 (text) and line 77 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][78], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 765 (text).
- [docs/adr/index.md][79], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 111 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 174 (text);
  selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 172 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 286
  (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][80], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 142
  (text).
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][81], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 94
  (text).
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/conventional-folders.md][5], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][82], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 13
  (text).

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][83], in the cell Root files × powershell: selected by [ADR-PWSH-MANIFEST][3]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][84], in the cell .claude × markdown: selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 45 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][85], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (body comment) (a passing mention only).

### .internal (automation/.internal, 1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-ModuleFiles.ps1][86], in the cell automation × powershell: selected by [ADR-PWSH-MANIFEST][3]: the
  file cites it at line 1 (header).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][87], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 7 (header).

### Exporter (automation/Catzc.Base.Exporter, 1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][88], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 6 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][89], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (header) and line 89 (body comment).

### Overlay (automation/Catzc.Base.Overlay, 1 lit file)

The group holds the files of automation/Catzc.Base.Overlay; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][90], in the cell automation × powershell: selected by
  [ADR-PWSH-MANIFEST][3]: the file cites it at line 8 (header).

## Keywords

- [world map][91]
- [track][92]
- [file language][93]
- [cell][94]
- [lit cell][95]
- [root file][96]
- [.claude][68]: a track
- [.github][68]: a track
- [automation][68]: a track
- [docs][68]: a track
- [pipelines][68]: a track
- [csharp][97]: a file language
- [markdown][97]: a file language
- [pipeline-yaml][97]: a file language
- [powershell][97]: a file language
- [yaml][97]: a file language

Terms the cited ADRs define:

- [domain][98], defined by [ADR-REPO-FOLDERS#5][99]

[1]: ../../adr/design/module-aspects.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/pwsh/dynamic-module-manifests.md
[4]: ../../adr/pwsh/one-function-per-file.md
[5]: ../../adr/repository/conventional-folders.md
[6]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[7]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[8]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[10]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[11]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[12]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[13]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[14]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[15]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[16]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[17]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[18]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[19]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[20]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[21]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[22]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[23]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[24]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[25]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[26]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[27]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[28]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[29]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[30]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[31]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[32]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[33]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[34]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[35]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[36]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[37]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[38]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[39]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[40]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[41]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[42]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[43]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[44]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[45]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[46]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[47]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[48]: ../../../automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
[49]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[50]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[51]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[52]: ../../../pipelines/cd-apex.yaml
[53]: ../../../pipelines/cd-flux.yaml
[54]: ../../../pipelines/cd-nova.yaml
[55]: ../../../pipelines/cd-shared.yaml
[56]: ../../../pipelines/ci-automation.yaml
[57]: ../../../pipelines/ci-infrastructure.yaml
[58]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[59]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[60]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[61]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[62]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[63]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[64]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[65]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[66]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[67]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[68]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[69]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[70]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[71]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[72]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[73]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[74]: ../../adr/pwsh/dora-explains.md
[75]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[76]: ../../references/automation/catzc-base-globs.md
[77]: ../../references/automation/catzc-base-languages.md
[78]: ../../adr/glossary.md
[79]: ../../adr/index.md
[80]: ../../adr/design/dora-explains.md
[81]: ../../adr/flow/dora-explains.md
[82]: ../../adr/repository/dora-explains.md
[83]: ../../../importer.ps1
[84]: ../../../.claude/CLAUDE.md
[85]: ../../../.github/workflows/ci-automation.yml
[86]: ../../../automation/.internal/assets/Import-ModuleFiles.ps1
[87]: ../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[88]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[89]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[90]: ../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[91]: ../../adr/glossary.md#world-map
[92]: ../../adr/glossary.md#track
[93]: ../../adr/glossary.md#file-language
[94]: ../../adr/glossary.md#cell
[95]: ../../adr/glossary.md#lit-cell
[96]: ../../adr/glossary.md#root-file
[97]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[98]: ../../adr/glossary.md#domain
[99]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5

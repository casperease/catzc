# docs/.assets/explanation/tree/adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.tree.md

`Tree minimap: adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance`

![Tree minimap of adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance](adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.tree.png)

The tree minimap of the slide `adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance` (governance lens). The slide
supports [ADR-AUTO-FAILFAST][1], [ADR-FLOW-CD-DETECT][2] and [ADR-FLOW-CD-GLOBS][3]; the highlight of those ADR codes selects what is lit,
and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 137 files in 20 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 41 lit files
- Globs (automation/Catzc.Base.Globs): 39 lit files
- .claude: 10 lit files
- .unordered: 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 8 lit files
- Docs (automation/Catzc.Base.Docs): 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 4 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 3 lit files
- adr/flow (docs/adr/flow): 3 lit files
- Folders (automation/Catzc.Base.Folders): 2 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- .github: 1 lit file
- Az.Cli (automation/Catzc.Azure.Cli): 1 lit file
- Az.Templates (automation/Catzc.Azure.Templates): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- adr/repo (docs/adr/repository): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 41 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 16 (text) and line 36 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][5], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][6], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 35 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-globs.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 51 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (text), line 35 (text), line 38 (text) and line 86 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 31 (text) and line 41 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 18 (text), line 33 (text), line 38 (text), line 46 (text), line 48 (text), line 62 (text), line 92 (text) and
  line 106 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 27 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text), line 34 (text), line 36 (text) and line 45 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 18 (text) and line 39 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][31], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 30 (text) and line 36 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][32], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 36 (text), line 37 (text) and line 38 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][33], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 17 (text), line 32 (text), line 34 (text), line 35 (text), line 41 (text), line 44 (text), line 46 (text), line
  49 (text), line 57 (text), line 66 (text), line 84 (text), line 101 (text), line 111 (text), line 135 (text) and line 143 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][34], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 32 (text), line 36 (text), line 39 (text) and line 58 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][35], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 70 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][36], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-typessystem.md][37], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 16 (text) and line 89 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][38], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/pipelines/cd-apex.yaml.md][39], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 47 (text).
- [docs/references/pipelines/cd-flux.yaml.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 46 (text).
- [docs/references/pipelines/cd-nova.yaml.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 46 (text).
- [docs/references/pipelines/cd-shared.yaml.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 41 (text).
- [docs/references/pipelines/ci-automation.yaml.md][43], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][44], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 33 (text).

### Globs (automation/Catzc.Base.Globs, 39 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][45], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][46], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1][47], in the cell automation × powershell: selected by [ADR-FLOW-CD-DETECT][2]:
  the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][48], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 20 (header), line 25 (header) and line 28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][49], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][50], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][51], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][52], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 26 (header).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][53], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][54], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][55], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][56], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 21 (header) and line 43 (header); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header) and line
  33 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][57], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 23 (header), line 36 (header) and line 95 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][58], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][59], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][60], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][61], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][62], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 21 (header) and line 31 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][63], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][64], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1][65], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][66], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][67], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][68], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][69], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][70], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][71], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][72], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header), line 25 (text) and line 27 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][73], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][74], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][75], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][76], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and line 81 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][77], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 20 (header) and line 32 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][78], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header), line 78 (text), line 91 (text), line 102 (text) and line 114 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][79], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 22 (text).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][80], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][81], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 21 (text), line 47 (text), line 51 (text), line 55 (text), line 67 (text), line 71 (text) and line 80 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][82], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 21 (text) and line 79 (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][83], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 21 (text), line 98 (text), line 161 (text), line 165 (text) and line 179 (text).

### .claude (10 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][84], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 113 (text).
- [.claude/plans/decisions-2026-10-16.md][85], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  25 (text), line 71 (text), line 71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-assert-wait.md][86], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32
  (text), line 44 (text), line 57 (text), line 65 (text) and line 115 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][87], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 27 (text), line 56 (text), line 302 (text) and line 303 (text).
- [.claude/plans/plan-config-defaults.md][88], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  62 (text) and line 266 (text).
- [.claude/plans/plan-lazy-types-load.md][89], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  204 (text).
- [.claude/plans/plan-minimal-robots-agents.md][90], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 25 (text) and line 91 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][91], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 25 (text) and line 131 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][92], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 19 (text) and line 40 (text).
- [.claude/plans/questionnaire-2026-10-16.md][93], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 141 (text).

### .unordered (9 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][94], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 43 (text), line 96 (text), line 124 (text) and line 167 (text).
- [.unordered/15-10-2026/plan-adr-pwsh-followups.md][95], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file
  cites it at line 111 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][96], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 13 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][97], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 101 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][98], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites
  it at line 96 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 97 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][99], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 14 (text) and line 16 (text).
- [.unordered/15-10-2026/plan-duration-categories.md][100], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][101], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 129 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 38 (text), line 39 (text), line 58 (text), line
  77 (text), line 103 (text) and line 103 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][102], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 70 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 8 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][103], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 23 (header) and line 102 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][104], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 30 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][105], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 599 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1212 (text).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][106], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][107], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 23 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][108], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header) and line 31 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][109], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][110], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (header) and line 43 (header).

### Docs (automation/Catzc.Base.Docs, 6 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-Glossary.ps1][111], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][112], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 148 (text); selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 117 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 119 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][113], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 74 (body comment) and line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][114], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 23 (text).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][115], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][116], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 20 (header).

### Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation, 4 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][117], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and line 30 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][118], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][119], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][120], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and line 28 (header).

### Timeouts (automation/Catzc.Base.Timeouts, 3 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][121], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][122], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][123], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 21 (text).

### adr/flow (docs/adr/flow, 3 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][124], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 81
  (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 124 (text).
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the ADR's own file.

### Folders (automation/Catzc.Base.Folders, 2 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][125], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][126], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 87 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][127], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][128], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (header) and line 29 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][129], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  310 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][130], in the cell github-workflows × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 20 (body comment) (a passing mention only).

### Az.Cli (automation/Catzc.Azure.Cli, 1 lit file)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][131], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 36 (header).

### Az.Templates (automation/Catzc.Azure.Templates, 1 lit file)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1][132], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 21 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][133], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 22 (text).

### Exporter (automation/Catzc.Base.Exporter, 1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][134], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 21 (header) and line 27 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][135], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 159 (text); selected
  by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 129 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 131
  (text).

### adr/repo (docs/adr/repository, 1 lit file)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/ai-agent-contract.md][136], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 18 (text) and line 55 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][137], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line
  21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 148 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 95 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 26 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 20 (header), `automation/Catzc.Base.Engines/types/ExecutionEngine.cs` line
  22 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 87 (text), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 43 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 599 (text),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 43 (header),
  `automation/Catzc.Base.Timeouts/Assert-Wait.ps1` line 20 (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 20
  (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 26 (header),
  `automation/Catzc.Base.Timeouts/types/BashSafeguard.cs` line 21 (text), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1`
  line 21 (header), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 27 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 22 (header) and
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 29 (header); selected by [ADR-FLOW-CD-DETECT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1` line 21
  (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 117 (text), `automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1` line 26 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1` line 20 (header) and
  `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 30 (text); selected by [ADR-FLOW-CD-GLOBS][3]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at
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
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 31 (header).

## Keywords

- [world map][138]
- [track][139]
- [file language][140]
- [cell][141]
- [lit cell][142]
- [.claude][143]: a track
- [.unordered][143]: a track
- [automation][143]: a track
- [docs][143]: a track
- [github-workflows][143]: a track
- [pipelines][143]: a track
- [csharp][144]: a file language
- [markdown][144]: a file language
- [pipeline-yaml][144]: a file language
- [powershell][144]: a file language
- [yaml][144]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../adr/flow/pipeline-detection.md
[3]: ../../../adr/flow/durable-sha-globs.md
[4]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[5]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[6]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[7]: ../../../references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[8]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[9]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[10]: ../../../references/automation/catzc-base-globs.md
[11]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[12]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[13]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[14]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[15]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[16]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[17]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[18]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[19]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[20]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[21]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[22]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[23]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[24]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[25]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[26]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[27]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[28]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[29]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[30]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[31]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[32]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[33]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[34]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[35]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[36]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[37]: ../../../references/automation/catzc-base-typessystem.md
[38]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[39]: ../../../references/pipelines/cd-apex.yaml.md
[40]: ../../../references/pipelines/cd-flux.yaml.md
[41]: ../../../references/pipelines/cd-nova.yaml.md
[42]: ../../../references/pipelines/cd-shared.yaml.md
[43]: ../../../references/pipelines/ci-automation.yaml.md
[44]: ../../../references/pipelines/ci-infrastructure.yaml.md
[45]: ../../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[46]: ../../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[47]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
[48]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[49]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[50]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[51]: ../../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[52]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[53]: ../../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[54]: ../../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[55]: ../../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[56]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[57]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[58]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[59]: ../../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[60]: ../../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[61]: ../../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[62]: ../../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[63]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[64]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[65]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
[66]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[67]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[68]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[69]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[70]: ../../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[71]: ../../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[72]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[73]: ../../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[74]: ../../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[75]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[76]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[77]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[78]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[79]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[80]: ../../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[81]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[82]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[83]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[84]: ../../../../.claude/CLAUDE.md
[85]: ../../../../.claude/plans/decisions-2026-10-16.md
[86]: ../../../../.claude/plans/plan-assert-wait.md
[87]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[88]: ../../../../.claude/plans/plan-config-defaults.md
[89]: ../../../../.claude/plans/plan-lazy-types-load.md
[90]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[91]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[92]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[93]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[94]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[95]: ../../../../.unordered/15-10-2026/plan-adr-pwsh-followups.md
[96]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[97]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[98]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[99]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[100]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[101]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[102]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[103]: ../../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[104]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[105]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[106]: ../../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[107]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[108]: ../../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[109]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[110]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[111]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[112]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[113]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[114]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[115]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[116]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[117]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[118]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[119]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[120]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[121]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[122]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[123]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[124]: ../../../adr/flow/dora-explains.md
[125]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[126]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[127]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[128]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[129]: ../../../adr/automation/dora-explains.md
[130]: ../../../../.github/workflows/ci-automation.yml
[131]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[132]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
[133]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[134]: ../../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[135]: ../../../adr/index.md
[136]: ../../../adr/repository/ai-agent-contract.md
[137]: ../../../../pipelines/ci-automation.yaml
[138]: ../../../adr/glossary.md#world-map
[139]: ../../../adr/glossary.md#track
[140]: ../../../adr/glossary.md#file-language
[141]: ../../../adr/glossary.md#cell
[142]: ../../../adr/glossary.md#lit-cell
[143]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[144]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

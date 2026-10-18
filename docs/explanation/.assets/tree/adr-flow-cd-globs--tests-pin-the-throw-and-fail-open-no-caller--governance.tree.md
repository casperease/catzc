# Tests pin the throw and the fail-open, a rule pins detection, and no pipeline calls it: the tree minimap

```text
Which files cite ADR-AUTO-FAILFAST, ADR-FLOW-CD-DETECT and ADR-FLOW-CD-GLOBS: every file of the world map is a tile, grouped by top-level folder.
117 files lit in 12 groups.
```

![The tree minimap of Tests pin the throw and the fail-open, a rule pins detection, and no pipeline calls it](adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Tests pin the throw and the fail-open, a rule pins detection, and no
pipeline calls it][118], which explains [ADR-AUTO-FAILFAST][1], [ADR-FLOW-CD-DETECT][2] and [ADR-FLOW-CD-GLOBS][3]. It lights every file
that cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 117 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 80 lit files
- .claude: 12 lit files
- Globs (automation/Catzc.Base.Globs): 8 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- adr/flow (docs/adr/flow): 3 lit files
- Folders (automation/Catzc.Base.Folders): 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Slides (automation/Catzc.Base.Slides): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- .github: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 80 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 16 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][5], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][6], in the cell docs ×
  markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line
  62 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][7], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 55 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 55
  (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 102 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][10], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][11], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][12], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][13], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][14], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 58 (text).
- [docs/references/automation/catzc-base-docs/Test-Glossary.ps1.md][16], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 27 (text).
- [docs/references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][19], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 37 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][20], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text) and line 100 (text).
- [docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-base-globs.md][23], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 27 (text).
- [docs/references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text) and line 27 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSet.ps1.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 15 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md][27], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 14 (text) and line 16 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md][28], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 20 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetTrigger.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text), line 29 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][30], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/automation/catzc-base-globs/Get-TrackedFile.ps1.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][33], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][34], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md][35], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and
  line 20 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][36], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][37], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md][39], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md][40], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][41], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][43], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 26 (text) and line 109 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 33 (text) and line 108 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][46], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 11 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][47], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][49], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][50], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][51], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][53], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][55], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][57], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][58], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 19 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text) and line 17 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][63], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line
  38 (text), line 47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][64], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md][65], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 97 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][67], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 80 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][68], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][69], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][70], in the cell docs × markdown: selected
  by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-timeouts/Assert-Wait.ps1.md][71], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 23 (text) and line 24 (text).
- [docs/references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][72], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][73], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-typessystem.md][74], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 64 (text).
- [docs/references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][75], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][76], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][77], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/cd-apex.yaml.md][78], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][79], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][80], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][81], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][82], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][83], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 13 (text).

### .claude (12 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][84], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 118 (text).
- [.claude/plans/decisions-2026-10-16.md][85], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  39 (text), line 39 (text), line 161 (text) and line 168 (text).
- [.claude/plans/plan-assert-wait.md][86], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 24
  (text), line 38 (text), line 46 (text), line 91 (text), line 93 (text), line 94 (text), line 133 (text) and line 140 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][87], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 33 (text), line 281 (text) and line 282 (text).
- [.claude/plans/plan-config-defaults.md][88], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  35 (text) and line 259 (text).
- [.claude/plans/plan-lazy-types-load.md][89], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  90 (text).
- [.claude/plans/plan-master.md][90], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 84
  (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][91], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 17 (text).
- [.claude/plans/questionnaire-2026-10-16.md][92], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 121 (text).
- [.claude/plans/task-assert-wait.md][93], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 53
  (text).
- [.claude/plans/task-config-defaults-postures.md][94], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 24 (text).
- [.claude/plans/task-import-landing-zone.md][95], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 42 (text).

### Globs (automation/Catzc.Base.Globs, 8 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][96], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 42 (text).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][97], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (text) and line 4 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][98], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 58 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][99], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 9 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][100], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][101], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 23 (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][102], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 54 (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][103], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 73 (text), line 136 (text), line 140 (text) and line 154 (text).

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][104], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 132 (text); selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 99 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 101 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][105], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 55 (body comment) and line 76 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][106], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 4 (text).

### adr/flow (docs/adr/flow, 3 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][107], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 49
  (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the ADR's own file.

### Folders (automation/Catzc.Base.Folders, 2 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][108], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 47 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][109], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][110], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 11 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][111], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 583 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1216 (text).

### Slides (automation/Catzc.Base.Slides, 2 lit files)

The group holds the files of automation/Catzc.Base.Slides; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][112], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 145 (text) and line 153 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][113], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 44 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][114], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][115], in the cell github-workflows × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 4 (body comment) (a passing mention only).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][116], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text); selected
  by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 131 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 133
  (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][117], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 132 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 55 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47
  (text), `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 583 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 145 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 153 (text) and
  `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44 (text); selected by [ADR-FLOW-CD-DETECT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 99 (text) and
  `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text); selected by [ADR-FLOW-CD-GLOBS][3]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 101 (text),
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

- [world map][119]
- [track][120]
- [file language][121]
- [cell][122]
- [lit cell][123]
- [.claude][124]: a track
- [automation][124]: a track
- [docs][124]: a track
- [github-workflows][124]: a track
- [pipelines][124]: a track
- [csharp][125]: a file language
- [markdown][125]: a file language
- [pipeline-yaml][125]: a file language
- [powershell][125]: a file language
- [yaml][125]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../adr/flow/pipeline-detection.md
[3]: ../../../adr/flow/durable-sha-globs.md
[4]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[5]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[6]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[7]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[8]: ../../../references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[9]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[10]: ../../../references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[11]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[12]: ../../../references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[13]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[14]: ../../../references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[15]: ../../../references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[16]: ../../../references/automation/catzc-base-docs/Test-Glossary.ps1.md
[17]: ../../../references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[18]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[19]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[20]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[21]: ../../../references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[22]: ../../../references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[23]: ../../../references/automation/catzc-base-globs.md
[24]: ../../../references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[25]: ../../../references/automation/catzc-base-globs/Get-GlobSet.ps1.md
[26]: ../../../references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[27]: ../../../references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md
[28]: ../../../references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md
[29]: ../../../references/automation/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[30]: ../../../references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[31]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[32]: ../../../references/automation/catzc-base-globs/Get-TrackedFile.ps1.md
[33]: ../../../references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[34]: ../../../references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[35]: ../../../references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md
[36]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[37]: ../../../references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[38]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[39]: ../../../references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md
[40]: ../../../references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[41]: ../../../references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[42]: ../../../references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[43]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[44]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[45]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[46]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[47]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[48]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[49]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[50]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[51]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[52]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[53]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[54]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[55]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[56]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[57]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[58]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[59]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[60]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[61]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[62]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[63]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[64]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[65]: ../../../references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
[66]: ../../../references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[67]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[68]: ../../../references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[69]: ../../../references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[70]: ../../../references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[71]: ../../../references/automation/catzc-base-timeouts/Assert-Wait.ps1.md
[72]: ../../../references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[73]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[74]: ../../../references/automation/catzc-base-typessystem.md
[75]: ../../../references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[76]: ../../../references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[77]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[78]: ../../../references/pipelines/cd-apex.yaml.md
[79]: ../../../references/pipelines/cd-flux.yaml.md
[80]: ../../../references/pipelines/cd-nova.yaml.md
[81]: ../../../references/pipelines/cd-shared.yaml.md
[82]: ../../../references/pipelines/ci-automation.yaml.md
[83]: ../../../references/pipelines/ci-infrastructure.yaml.md
[84]: ../../../../.claude/CLAUDE.md
[85]: ../../../../.claude/plans/decisions-2026-10-16.md
[86]: ../../../../.claude/plans/plan-assert-wait.md
[87]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[88]: ../../../../.claude/plans/plan-config-defaults.md
[89]: ../../../../.claude/plans/plan-lazy-types-load.md
[90]: ../../../../.claude/plans/plan-master.md
[91]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[92]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[93]: ../../../../.claude/plans/task-assert-wait.md
[94]: ../../../../.claude/plans/task-config-defaults-postures.md
[95]: ../../../../.claude/plans/task-import-landing-zone.md
[96]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[97]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[98]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[99]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[100]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[101]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[102]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[103]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[104]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[105]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[106]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[107]: ../../../adr/flow/dora-explains.md
[108]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[109]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[110]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[111]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[112]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[113]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[114]: ../../../adr/automation/dora-explains.md
[115]: ../../../../.github/workflows/ci-automation.yml
[116]: ../../../adr/index.md
[117]: ../../../../pipelines/ci-automation.yaml
[118]: ../../flow/tests-pin-the-throw-and-fail-open-no-caller.md
[119]: ../../../adr/glossary.md#world-map
[120]: ../../../adr/glossary.md#track
[121]: ../../../adr/glossary.md#file-language
[122]: ../../../adr/glossary.md#cell
[123]: ../../../adr/glossary.md#lit-cell
[124]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[125]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "89aa823d2d76"
    repo_status: locked
    path: docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself/tree.md
    source: docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The customer CD pipeline builds once, then deploys the prod tier itself: the tree minimap

```text
Which files cite ADR-FLOW-CD: every file of the world map is a tile, grouped by top-level folder.
106 files lit in 10 groups.
```

![The tree minimap of The customer CD pipeline builds once, then deploys the prod tier itself](tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [The customer CD pipeline builds once, then deploys the prod tier
itself][107], which explains [ADR-FLOW-CD][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 106 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 78 lit files
- Globs (pwsh/Catzc.Base.Globs): 8 lit files
- .claude: 7 lit files
- pipelines: 3 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 78 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 16 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][4], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text), line 55 (text) and line 55 (text).
- [docs/references/pipelines/cd-apex.yaml.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 31
  (text).
- [docs/references/pipelines/cd-flux.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-nova.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 12
  (text) and line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line
  12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 12 (text) and line 13 (text).
- [docs/references/pipelines/deploy-apex.yaml.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line
  12 (text) and line 21 (text).
- [docs/references/pipelines/deploy-nova.yaml.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line
  12 (text).
- [docs/references/pipelines/deploy-shared.yaml.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 12 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 12 (text).
- [docs/references/pipelines/stages/deploy-unit.yaml.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 11 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 12 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 14 (text), line 16 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][20], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text) and line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][22], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][23], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][24], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 58 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][29], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 27
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][33], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][35], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 15 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][36], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 14 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][37], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text), line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][39], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][43], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][44], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 17 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][45], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][46], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][47], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][48], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][49], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][50], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][51], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 26 (text), line 33 (text), line 108 (text), line 108 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][53], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][55], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][56], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][57], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][58], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][60], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][61], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][63], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][65], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][67], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][68], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][69], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][70], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 11 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][71], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][72], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38 (text), line
  47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][73], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][74], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][75], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 54 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][76], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][77], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][78], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][79], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 17 (text).

### Globs (pwsh/Catzc.Base.Globs, 8 lit files)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][80], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][81], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 2 (text) and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][82], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][83], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][84], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][85], in the cell pwsh × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at line 23
  (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][86], in the cell pwsh × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at line 54
  (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][87], in the cell pwsh × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at line 73
  (text), line 136 (text), line 140 (text) and line 154 (text).

### .claude (7 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][88], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text) and line 56
  (text).
- [.claude/plans/plan-adr-code-language.md][89], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 126
  (text), line 126 (text), line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][90], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 36 (text), line 60 (text), line 79 (text), line 97 (text) and line 109 (text).
- [.claude/plans/plan-promotion-ladder.md][91], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 12
  (text), line 35 (text), line 60 (text) and line 94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][92], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 20 (text).
- [.claude/plans/task-loose-ends.md][93], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][94], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 35 (text).

### pipelines (3 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-shared.yaml][95], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line 45 (body
  comment) (a passing mention only).
- [pipelines/ci-automation.yaml][96], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 100 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text),
  `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42 (text), `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2
  (text), `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 4 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 58 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9
  (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line
  77 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 89 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 23
  (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 31 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 47 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text), `pwsh/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1`
  line 71 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text),
  `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 58
  (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).
- [pipelines/extends/cd-customer.yaml][97], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  21 (body comment) (a passing mention only).

### QualityGates (pwsh/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][98], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 11 (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][99], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  58 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][100], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 1076 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][101], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 506 (text) and line 519
  (text).
- [docs/adr/index.md][102], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text), line 130
  (text), line 131 (text), line 132 (text) and line 133 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][103], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text),
  line 31 (text), line 49 (text), line 67 (text) and line 92 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][104], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text),
  line 98 (text), line 99 (text), line 100 (text) and line 101 (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][105], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 70 (text) and line 71 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][106], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  18 (text).

## Keywords

- [world map][108]
- [track][109]
- [file language][110]
- [cell][111]
- [lit cell][112]
- [.claude][113]: a track
- [docs][113]: a track
- [pipelines][113]: a track
- [pwsh][113]: a track
- [csharp][114]: a file language
- [markdown][114]: a file language
- [pipeline-yaml][114]: a file language
- [powershell][114]: a file language
- [yaml][114]: a file language

[1]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../how-to/automation/apply-environment-approvals.md
[3]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[4]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[5]: ../../../../references/pipelines/cd-apex.yaml.md
[6]: ../../../../references/pipelines/cd-flux.yaml.md
[7]: ../../../../references/pipelines/cd-nova.yaml.md
[8]: ../../../../references/pipelines/cd-shared.yaml.md
[9]: ../../../../references/pipelines/ci-automation.yaml.md
[10]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[11]: ../../../../references/pipelines/deploy-apex.yaml.md
[12]: ../../../../references/pipelines/deploy-nova.yaml.md
[13]: ../../../../references/pipelines/deploy-shared.yaml.md
[14]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[15]: ../../../../references/pipelines/stages/deploy-unit.yaml.md
[16]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[17]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[18]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[19]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[22]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[24]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[25]: ../../../../references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md
[26]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[27]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[29]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[30]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[31]: ../../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[32]: ../../../../references/pwsh/catzc-base-globs.md
[33]: ../../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[34]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[35]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[36]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[37]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[38]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[39]: ../../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[40]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[41]: ../../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[42]: ../../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[43]: ../../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[44]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[45]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[46]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[47]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[48]: ../../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[49]: ../../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[50]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[51]: ../../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[52]: ../../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[53]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[54]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[55]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[56]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[57]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[58]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[59]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[60]: ../../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[61]: ../../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[62]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[63]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[64]: ../../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[65]: ../../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[66]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[67]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[68]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[69]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[70]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[71]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[72]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[73]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[74]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[75]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[76]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[77]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[78]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[79]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[80]: ../../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[81]: ../../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[82]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[83]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[84]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[85]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[86]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[87]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[88]: ../../../../../.claude/CLAUDE.md
[89]: ../../../../../.claude/plans/plan-adr-code-language.md
[90]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[91]: ../../../../../.claude/plans/plan-promotion-ladder.md
[92]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[93]: ../../../../../.claude/plans/task-loose-ends.md
[94]: ../../../../../.claude/plans/value-of-plan.md
[95]: ../../../../../pipelines/cd-shared.yaml
[96]: ../../../../../pipelines/ci-automation.yaml
[97]: ../../../../../pipelines/extends/cd-customer.yaml
[98]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[99]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[100]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[101]: ../../../../adr/glossary.md
[102]: ../../../../adr/index.md
[103]: ../../../../adr/flow/dora-explains.md
[104]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[105]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[106]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[107]: ../../cd-builds-once-then-deploys-prod-itself.md
[108]: ../../../../adr/glossary.md#world-map
[109]: ../../../../adr/glossary.md#track
[110]: ../../../../adr/glossary.md#file-language
[111]: ../../../../adr/glossary.md#cell
[112]: ../../../../adr/glossary.md#lit-cell
[113]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[114]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

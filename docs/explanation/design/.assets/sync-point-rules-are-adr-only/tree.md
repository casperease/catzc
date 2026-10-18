---
catzc:
  immutable:
    with_body_sha: "96fc65f64bc9"
    repo_status: locked
    path: docs/explanation/design/.assets/sync-point-rules-are-adr-only/tree.md
    source: docs/explanation/design/.assets/sync-point-rules-are-adr-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only BVT has a gate in code; the sync-point rules are ADR-only: the tree minimap

```text
Which files cite ADR-DSGN-LIFE and ADR-FLOW-CD: every file of the world map is a tile, grouped by top-level folder.
111 files lit in 11 groups.
```

![The tree minimap of Only BVT has a gate in code; the sync-point rules are ADR-only](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Only BVT has a gate in code; the sync-point rules are ADR-only][112],
which explains [ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 111 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 79 lit files
- .claude: 8 lit files
- Globs (pwsh/Catzc.Base.Globs): 8 lit files
- pipelines: 3 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 79 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 16 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][5], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text), line 55 (text) and line 55 (text).
- [docs/references/pipelines/cd-apex.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 31
  (text).
- [docs/references/pipelines/cd-flux.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-nova.yaml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 12
  (text) and line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 12 (text) and line 13 (text).
- [docs/references/pipelines/deploy-apex.yaml.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line
  12 (text) and line 21 (text).
- [docs/references/pipelines/deploy-nova.yaml.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line
  12 (text).
- [docs/references/pipelines/deploy-shared.yaml.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 12 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 12 (text).
- [docs/references/pipelines/stages/deploy-unit.yaml.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 11 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 12 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 14 (text), line 16 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][21], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][22], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text) and line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][23], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][24], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][25], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md][26], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 58 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][33], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 27
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][35], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][36], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][37], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 15 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 14 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][39], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text), line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][43], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][44], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][46], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 17 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][47], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][48], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][49], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][50], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][51], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][52], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][53], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 26 (text), line 33 (text), line 108 (text), line 108 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][55], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][57], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][58], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][59], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][60], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][63], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][65], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][67], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][68], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][69], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][70], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][71], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][72], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 11 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][73], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][74], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38 (text), line
  47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][75], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][76], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][77], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 54 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][78], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][79], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][80], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][81], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 17 (text).

### .claude (8 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][82], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text) and line 56
  (text).
- [.claude/plans/plan-adr-code-language.md][83], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 126
  (text), line 126 (text), line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][84], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 36 (text), line 60 (text), line 79 (text), line 97 (text) and line 109 (text).
- [.claude/plans/plan-fast-push-followups.md][85], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][86], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12
  (text), line 34 (text) and line 94 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 12 (text), line 35 (text), line 60
  (text) and line 94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][87], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 20 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][88], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 57
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][89], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 35 (text),
  line 42 (text) and line 42 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 35 (text).

### Globs (pwsh/Catzc.Base.Globs, 8 lit files)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][90], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][91], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 2 (text) and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][92], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][93], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][94], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][95], in the cell pwsh × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at line 23
  (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][96], in the cell pwsh × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at line 54
  (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][97], in the cell pwsh × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at line 73
  (text), line 136 (text), line 140 (text) and line 154 (text).

### pipelines (3 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-shared.yaml][98], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][2]: the file cites it at line 45 (body
  comment) (a passing mention only).
- [pipelines/ci-automation.yaml][99], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text);
  selected by [ADR-FLOW-CD][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 100 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text), `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42 (text),
  `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2 (text), `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1`
  line 4 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 58 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 53
  (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line
  89 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 23 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 31 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 47 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text),
  `pwsh/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18
  (text), `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
  line 58 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).
- [pipelines/extends/cd-customer.yaml][100], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][2]: the file cites it at line
  21 (body comment) (a passing mention only).

### QualityGates (pwsh/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][101], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 11 (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][102], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][2]: the file cites it at line
  58 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][103], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 1076 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][104], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line
  346 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 506 (text) and line 519 (text).
- [docs/adr/index.md][105], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 129 (text), line 130 (text), line 131 (text), line 132 (text) and line 133 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][106], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][107], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 11 (text),
  line 31 (text), line 49 (text), line 67 (text) and line 92 (text).

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][108], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 97 (text), line 98 (text), line 99 (text), line 100 (text) and line 101
  (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][109], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484
  (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][110], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 70 (text) and line 71 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][111], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 49 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 18 (text).

## Keywords

- [world map][113]
- [track][114]
- [file language][115]
- [cell][116]
- [lit cell][117]
- [.claude][118]: a track
- [docs][118]: a track
- [pipelines][118]: a track
- [pwsh][118]: a track
- [csharp][119]: a file language
- [markdown][119]: a file language
- [pipeline-yaml][119]: a file language
- [powershell][119]: a file language
- [yaml][119]: a file language

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../../../how-to/automation/apply-environment-approvals.md
[4]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[5]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[6]: ../../../../references/pipelines/cd-apex.yaml.md
[7]: ../../../../references/pipelines/cd-flux.yaml.md
[8]: ../../../../references/pipelines/cd-nova.yaml.md
[9]: ../../../../references/pipelines/cd-shared.yaml.md
[10]: ../../../../references/pipelines/ci-automation.yaml.md
[11]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[12]: ../../../../references/pipelines/deploy-apex.yaml.md
[13]: ../../../../references/pipelines/deploy-nova.yaml.md
[14]: ../../../../references/pipelines/deploy-shared.yaml.md
[15]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[16]: ../../../../references/pipelines/stages/deploy-unit.yaml.md
[17]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[18]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[19]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[23]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[24]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[25]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[26]: ../../../../references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md
[27]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[30]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[31]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[32]: ../../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[33]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[34]: ../../../../references/pwsh/catzc-base-globs.md
[35]: ../../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[36]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[37]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[38]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[39]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[40]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[41]: ../../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[42]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[43]: ../../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[44]: ../../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[45]: ../../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[46]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[47]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[48]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[49]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[50]: ../../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[51]: ../../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[52]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[53]: ../../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[54]: ../../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[55]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[56]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[57]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[58]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[59]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[60]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[61]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[62]: ../../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[63]: ../../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[64]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[65]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[66]: ../../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[67]: ../../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[68]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[69]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[70]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[71]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[72]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[73]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[74]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[75]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[76]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[77]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[78]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[79]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[80]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[81]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[82]: ../../../../../.claude/CLAUDE.md
[83]: ../../../../../.claude/plans/plan-adr-code-language.md
[84]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[85]: ../../../../../.claude/plans/plan-fast-push-followups.md
[86]: ../../../../../.claude/plans/plan-promotion-ladder.md
[87]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[88]: ../../../../../.claude/plans/task-loose-ends.md
[89]: ../../../../../.claude/plans/value-of-plan.md
[90]: ../../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[91]: ../../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[92]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[93]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[94]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[95]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[96]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[97]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[98]: ../../../../../pipelines/cd-shared.yaml
[99]: ../../../../../pipelines/ci-automation.yaml
[100]: ../../../../../pipelines/extends/cd-customer.yaml
[101]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[102]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[103]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[104]: ../../../../adr/glossary.md
[105]: ../../../../adr/index.md
[106]: ../../../../adr/design/dora-explains.md
[107]: ../../../../adr/flow/dora-explains.md
[108]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[109]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[110]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[111]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[112]: ../../sync-point-rules-are-adr-only.md
[113]: ../../../../adr/glossary.md#world-map
[114]: ../../../../adr/glossary.md#track
[115]: ../../../../adr/glossary.md#file-language
[116]: ../../../../adr/glossary.md#cell
[117]: ../../../../adr/glossary.md#lit-cell
[118]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[119]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: e059f67760af
    repo_status: locked
    path: docs/explanation/flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it/tree.md
    source: docs/explanation/flow/.assets/tests-pin-the-throw-and-fail-open-cd-calls-it/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tests pin the throw and the fail-open, a rule pins detection, and the CD stages call it with no gate: the tree minimap

```text
Which files cite ADR-AUTO-FAILFAST, ADR-FLOW-CD-DETECT and ADR-FLOW-CD-GLOBS: every file of the world map is a tile, grouped by top-level folder.
119 files lit in 14 groups.
```

![The tree minimap of Tests pin the throw and the fail-open, a rule pins detection, and the CD stages call it with no gate](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Tests pin the throw and the fail-open, a rule pins detection, and the
CD stages call it with no gate][120], which explains [ADR-AUTO-FAILFAST][1], [ADR-FLOW-CD-DETECT][2] and [ADR-FLOW-CD-GLOBS][3]. It lights
every file that cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below,
naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 119 files in 14 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 86 lit files
- Globs (pwsh/Catzc.Base.Globs): 8 lit files
- .claude: 4 lit files
- adr/flow (docs/adr/flow): 3 lit files
- pipelines: 3 lit files
- Docs (pwsh/Catzc.Base.Docs): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Folders (pwsh/Catzc.Base.Folders): 2 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 2 lit files
- Slides (pwsh/Catzc.Base.Slides): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- Languages (pwsh/Catzc.Base.Languages): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- Timeouts (pwsh/Catzc.Base.Timeouts): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 86 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file
  cites it at line 4 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 16 (text).
- [docs/references/pipelines/cd-apex.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 102 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md][14], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 63 (text).
- [docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md][15], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.verify.md][16], in the cell docs × markdown: selected
  by [ADR-AUTO-FAILFAST][1]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md][17], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 25 (text) and line 109 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 33 (text), line 108 (text) and line 108 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 55 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 55 (text) and
  line 55 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][22], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][23], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][24], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 15 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 58 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][27], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the
  file cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][31], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][32], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][33], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-globs.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  28 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][35], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 15 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][36], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][37], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 15 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][39], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 15 (text), line 30 (text) and line 31 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][43], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][46], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][47], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][49], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][50], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][51], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][53], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][55], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][57], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][58], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][60], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][63], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][65], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][67], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][68], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][69], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][70], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][71], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 11 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][72], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][73], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38
  (text), line 47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][74], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][75], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 37 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][76], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]:
  the file cites it at line 54 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 54 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][77], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 98 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][78], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][79], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][80], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][81], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][82], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][83], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md][84], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 24 (text), line 25 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][85], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-typessystem.md][86], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][87], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][88], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][89], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 12 (text) and line 39 (text).

### Globs (pwsh/Catzc.Base.Globs, 8 lit files)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][90], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][91], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 2 (text) and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][92], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][93], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][94], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][95], in the cell pwsh × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  23 (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][96], in the cell pwsh × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 54
  (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][97], in the cell pwsh × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  73 (text), line 136 (text), line 140 (text) and line 154 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][98], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text);
  selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 55 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 55
  (text).
- [.claude/plans/plan-explanation-drift-gaps.md][99], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it
  at line 17 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17 (text).
- [.claude/plans/plan-promotion-ladder.md][100], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at
  line 11 (text) and line 38 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text) and line 38 (text).
- [.claude/plans/value-of-plan.md][101], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 32
  (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 32 (text).

### adr/flow (docs/adr/flow, 3 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][102], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 11
  (text) and line 49 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (text) and line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][2]: the ADR's own file.

### pipelines (3 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-shared.yaml][103], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 45
  (body comment) (a passing mention only).
- [pipelines/ci-automation.yaml][104], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 55 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1` line 30 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1`
  line 152 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 160 (text),
  `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 46 (text) and `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1`
  line 133 (text); selected by [ADR-FLOW-CD-DETECT][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it
  at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1`
  line 71 (text) and `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text); selected by [ADR-FLOW-CD-GLOBS][3]: a
  pipeline that cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97
  (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text), `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42 (text),
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
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`
  line 1078 (text).
- [pipelines/extends/cd-customer.yaml][105], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 21 (body comment) (a passing mention only).

### Docs (pwsh/Catzc.Base.Docs, 3 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][106], in the cell pwsh × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 132
  (text); selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 97 (text) and line 99 (text); selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 97 (text) and line 101 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][107], in the cell pwsh × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 55
  (text) and line 76 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][108], in the cell pwsh × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 4 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][109], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### Folders (pwsh/Catzc.Base.Folders, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][110], in the cell pwsh × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 47 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][111], in the cell pwsh × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 64 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][112], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-DETECT][2]: the file
  cites it at line 11 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][113], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 1078 (text).

### Slides (pwsh/Catzc.Base.Slides, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Slides; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][114], in the cell pwsh × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 152 (text) and line 160 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][115], in the cell pwsh × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 46 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][116], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text); selected
  by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 129 (text) and line 131 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 129 (text) and line 133 (text).

### Languages (pwsh/Catzc.Base.Languages, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][117], in the cell pwsh × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 30 (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][118], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-DETECT][2]: the
  file cites it at line 70 (text) and line 71 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text) and line 71
  (text).

### Timeouts (pwsh/Catzc.Base.Timeouts, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][119], in the cell pwsh × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 133 (text).

## Keywords

- [world map][121]
- [track][122]
- [file language][123]
- [cell][124]
- [lit cell][125]
- [.claude][126]: a track
- [docs][126]: a track
- [pipelines][126]: a track
- [pwsh][126]: a track
- [csharp][127]: a file language
- [markdown][127]: a file language
- [pipeline-yaml][127]: a file language
- [powershell][127]: a file language
- [yaml][127]: a file language

[1]: ../../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../adr/flow/pipeline-detection.md
[3]: ../../../../adr/flow/durable-sha-globs.md
[4]: ../../../../how-to/automation/apply-environment-approvals.md
[5]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[6]: ../../../../references/pipelines/cd-apex.yaml.md
[7]: ../../../../references/pipelines/cd-flux.yaml.md
[8]: ../../../../references/pipelines/cd-nova.yaml.md
[9]: ../../../../references/pipelines/cd-shared.yaml.md
[10]: ../../../../references/pipelines/ci-automation.yaml.md
[11]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[12]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[13]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md
[14]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md
[15]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md
[16]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.verify.md
[17]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md
[18]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md
[19]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[24]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[25]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[26]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[27]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[28]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[29]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[30]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[31]: ../../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[32]: ../../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[33]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
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
[54]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[55]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[56]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[57]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[58]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[59]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[60]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[61]: ../../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[62]: ../../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[63]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[64]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[65]: ../../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[66]: ../../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[67]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[68]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[69]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[70]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[71]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[72]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[73]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[74]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[75]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[76]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[77]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[78]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[79]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[80]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[81]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[82]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[83]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[84]: ../../../../references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
[85]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[86]: ../../../../references/pwsh/catzc-base-typessystem.md
[87]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[88]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[89]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[90]: ../../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[91]: ../../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[92]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[93]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[94]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[95]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[96]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[97]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[98]: ../../../../../.claude/CLAUDE.md
[99]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[100]: ../../../../../.claude/plans/plan-promotion-ladder.md
[101]: ../../../../../.claude/plans/value-of-plan.md
[102]: ../../../../adr/flow/dora-explains.md
[103]: ../../../../../pipelines/cd-shared.yaml
[104]: ../../../../../pipelines/ci-automation.yaml
[105]: ../../../../../pipelines/extends/cd-customer.yaml
[106]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[107]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[108]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[109]: ../../../../adr/automation/dora-explains.md
[110]: ../../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[111]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[112]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[113]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[114]: ../../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[115]: ../../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[116]: ../../../../adr/index.md
[117]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[118]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[119]: ../../../../../pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[120]: ../../tests-pin-the-throw-and-fail-open-cd-calls-it.md
[121]: ../../../../adr/glossary.md#world-map
[122]: ../../../../adr/glossary.md#track
[123]: ../../../../adr/glossary.md#file-language
[124]: ../../../../adr/glossary.md#cell
[125]: ../../../../adr/glossary.md#lit-cell
[126]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[127]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

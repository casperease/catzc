---
catzc:
  immutable:
    with_body_sha: fdcde4beec30
    repo_status: locked
    path: docs/explanation/flow/.assets/ci-budget-is-the-only-quality-gate/grid.md
    source: docs/explanation/flow/.assets/ci-budget-is-the-only-quality-gate/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The CI budget is the only promotion rule a quality gate checks: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD and ADR-FLOW-CD-TYPE sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 107 files.
```

![The world-map minimap of The CI budget is the only promotion rule a quality gate checks](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [The CI budget is the only promotion rule a quality gate
checks][109], which explains [ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 83 lit of 2767 files
- pipelines × pipeline-yaml: 3 lit of 14 files
- pwsh × csharp: 3 lit of 293 files
- pwsh × powershell: 6 lit of 1651 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (7 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text) and line 56 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][5]: selected by [ADR-FLOW-CD][1]: the file cites it at line 126 (text), line 126 (text), line
  127 (text), line 128 (text), line 181 (text) and line 184 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 126 (text),
  line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 36 (text), line 61 (text), line
  81 (text), line 99 (text), line 112 (text) and line 184 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text), line 35 (text), line 60
  (text) and line 87 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text), line 35 (text), line 60 (text) and line
  87 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 21 (text).
- [.claude/plans/task-loose-ends.md][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 59 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 59 (text).
- [.claude/plans/value-of-plan.md][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 34 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 34 (text).

### docs × markdown (83 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text), line 31 (text), line 49 (text),
  line 67 (text) and line 92 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 11 (text) and line 67 (text).
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD-TYPE][2]: the ADR's own file.
- [docs/adr/glossary.md][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 506 (text) and line 519 (text).
- [docs/adr/index.md][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text), line 130 (text), line 131 (text), line 132
  (text) and line 133 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 129 (text) and line 132 (text).
- [docs/how-to/automation/apply-environment-approvals.md][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 4 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][15]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][16]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 55 (text), line 55 (text) and line 55 (text).
- [docs/references/pipelines/cd-apex.yaml.md][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text) and line 22 (text);
  selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-automation.yaml.md][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text) and line 13
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/deploy-apex.yaml.md][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text) and line 21 (text).
- [docs/references/pipelines/deploy-nova.yaml.md][24]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/deploy-shared.yaml.md][25]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][26]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/stages/deploy-unit.yaml.md][27]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 11 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][28]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][29]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][30]: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 15 (text) and line 17 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][31]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 14 (text), line 16 (text) and line 74 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][32]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][33]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 12 (text) and line 15 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][34]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 16 (text) and line 19 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][35]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 13 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][36]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 12 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md][37]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][38]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  15 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][39]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  58 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][40]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 26 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][41]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text), line
  29 (text), line 57 (text) and line 58 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 28 (text), line 29 (text), line
  57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][42]: selected by [ADR-FLOW-CD][1]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][43]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs.md][44]: selected by [ADR-FLOW-CD][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][45]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text)
  and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][46]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][47]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15
  (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][48]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14 (text) and
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][49]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][50]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][51]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][52]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text),
  line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][53]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][54]: selected by [ADR-FLOW-CD][1]: the file cites it at line 24
  (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][55]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][56]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text)
  and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][57]: selected by [ADR-FLOW-CD][1]: the file cites it at line 18
  (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][58]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][59]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text), line
  17 (text), line 25 (text), line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][60]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][61]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][62]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][63]: selected by [ADR-FLOW-CD][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][64]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 26 (text), line 33 (text), line 108 (text), line 108 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][65]: selected by [ADR-FLOW-CD][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][66]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][67]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][68]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][69]: selected by [ADR-FLOW-CD][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][70]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][71]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][72]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][73]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][74]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][75]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][76]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][77]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][78]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][79]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12
  (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][80]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][81]: selected by [ADR-FLOW-CD][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][82]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text) and
  line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][83]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text),
  line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][84]: selected by [ADR-FLOW-CD][1]: the file cites it at line 13 (text), line
  15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38 (text), line 47 (text), line 65 (text),
  line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][85]: selected by [ADR-FLOW-CD][1]: the file cites it at line 13 (text),
  line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][86]: selected by [ADR-FLOW-CD][1]: the file cites it at line 37
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][87]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 54 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][88]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][89]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][90]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][91]: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 17 (text).

### pipelines × pipeline-yaml (3 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/cd-shared.yaml][92]: selected by [ADR-FLOW-CD][1]: the file cites it at line 45 (body comment) (a passing mention only).
- [pipelines/ci-automation.yaml][93]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text),
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
  line 58 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text); selected by [ADR-FLOW-CD-TYPE][2]: a pipeline
  that cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 100 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text) and
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text).
- [pipelines/extends/cd-customer.yaml][94]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (body comment) (a passing mention
  only).

### pwsh × csharp (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][95]: selected by [ADR-FLOW-CD][1]: the file cites it at line 23 (text), line 27 (text), line
  31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][96]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54 (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][97]: selected by [ADR-FLOW-CD][1]: the file cites it at line 73 (text), line 136 (text), line
  140 (text) and line 154 (text).

### pwsh × powershell (6 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][98]: selected by [ADR-FLOW-CD][1]: the file cites it at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][99]: selected by [ADR-FLOW-CD][1]: the file cites it at line 2 (text) and
  line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][100]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][101]: selected by [ADR-FLOW-CD][1]: the file cites it at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][102]: selected by [ADR-FLOW-CD][1]: the file cites it at line 53 (text), line 66
  (text), line 77 (text) and line 89 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][103]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text) and
  line 71 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 70 (text) and line 71 (text).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][104]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text), line 98 (text), line 99
  (text), line 100 (text) and line 101 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 97 (text) and line 100 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][105]: selected by [ADR-FLOW-CD][1]: the file cites it at line 18 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][106]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][107]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][108]: selected by [ADR-FLOW-CD][1]: the file cites it at line 1076 (text).

## Keywords

- [world map][110]
- [track][111]
- [file language][112]
- [cell][113]
- [lit cell][114]
- [.claude][115]: a track
- [docs][115]: a track
- [pipelines][115]: a track
- [pwsh][115]: a track
- [csharp][116]: a file language
- [markdown][116]: a file language
- [pipeline-yaml][116]: a file language
- [powershell][116]: a file language
- [yaml][116]: a file language

[1]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../adr/flow/pipeline-types.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/plan-adr-code-language.md
[6]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[7]: ../../../../../.claude/plans/plan-promotion-ladder.md
[8]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[9]: ../../../../../.claude/plans/task-loose-ends.md
[10]: ../../../../../.claude/plans/value-of-plan.md
[11]: ../../../../adr/flow/dora-explains.md
[12]: ../../../../adr/glossary.md
[13]: ../../../../adr/index.md
[14]: ../../../../how-to/automation/apply-environment-approvals.md
[15]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[16]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[17]: ../../../../references/pipelines/cd-apex.yaml.md
[18]: ../../../../references/pipelines/cd-flux.yaml.md
[19]: ../../../../references/pipelines/cd-nova.yaml.md
[20]: ../../../../references/pipelines/cd-shared.yaml.md
[21]: ../../../../references/pipelines/ci-automation.yaml.md
[22]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[23]: ../../../../references/pipelines/deploy-apex.yaml.md
[24]: ../../../../references/pipelines/deploy-nova.yaml.md
[25]: ../../../../references/pipelines/deploy-shared.yaml.md
[26]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[27]: ../../../../references/pipelines/stages/deploy-unit.yaml.md
[28]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[29]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[30]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[31]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[32]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[33]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[34]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[35]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[36]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[37]: ../../../../references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md
[38]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[39]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[40]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[41]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[42]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[43]: ../../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[44]: ../../../../references/pwsh/catzc-base-globs.md
[45]: ../../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[46]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[47]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[48]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[49]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[50]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[51]: ../../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[52]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[53]: ../../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[54]: ../../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[55]: ../../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[56]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[57]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[58]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[59]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[60]: ../../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[61]: ../../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[62]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[63]: ../../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[64]: ../../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[65]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[66]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[67]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[68]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[69]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[70]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[71]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[72]: ../../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[73]: ../../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[74]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[75]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[76]: ../../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[77]: ../../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[78]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[79]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[80]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[81]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[82]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[83]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[84]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[85]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[86]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[87]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[88]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[89]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[90]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[91]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[92]: ../../../../../pipelines/cd-shared.yaml
[93]: ../../../../../pipelines/ci-automation.yaml
[94]: ../../../../../pipelines/extends/cd-customer.yaml
[95]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[96]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[97]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[98]: ../../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[99]: ../../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[100]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[101]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[102]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[103]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[104]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[105]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[106]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[107]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[108]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[109]: ../../ci-budget-is-the-only-quality-gate.md
[110]: ../../../../adr/glossary.md#world-map
[111]: ../../../../adr/glossary.md#track
[112]: ../../../../adr/glossary.md#file-language
[113]: ../../../../adr/glossary.md#cell
[114]: ../../../../adr/glossary.md#lit-cell
[115]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[116]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

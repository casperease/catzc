---
catzc:
  immutable:
    with_body_sha: "16c35b88926c"
    repo_status: locked
    path: docs/explanation/flow/.assets/gates-check-source-and-trigger/grid.md
    source: docs/explanation/flow/.assets/gates-check-source-and-trigger/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Gates check the source of each globset and the trigger, but not the git reflection or the identity: the world-map minimap

```text
Where the files that cite ADR-AUTO-TEST and ADR-FLOW-CD-GLOBS sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 42 files.
```

![The world-map minimap of Gates check the source of each globset and the trigger, but not the git reflection or the identity](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Gates check the source of each globset and the trigger, but not
the git reflection or the identity][44], which explains [ADR-AUTO-TEST][1] and [ADR-FLOW-CD-GLOBS][2]. It lights every cell of the world map
that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the
code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 6 lit of 89 files
- docs × markdown: 32 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1651 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (6 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 54 (text).
- [.claude/agents/test-optimization.md][5]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (text).
- [.claude/plans/decisions-2026-10-16.md][6]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 80 (text) and line 83 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][7]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 109 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][8]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 204 (text).
- [.claude/skills/test-speed/SKILL.md][9]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (text).

### docs × markdown (32 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][10]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 140 (text).
- [docs/adr/automation/test-automation.md][1]: selected by [ADR-AUTO-TEST][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][11]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/index.md][12]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 158 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 135 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][13]: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 44 (text).
- [docs/references/pipelines/cd-apex.yaml.md][14]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][15]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][16]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][17]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][18]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][19]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][20]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][21]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][22]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][23]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][25]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md][26]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 136
  (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][27]: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 95 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][28]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][29]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][30]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][31]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][32]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][33]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][34]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 43
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md][35]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md][36]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  42 (text).
- [docs/references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md][37]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 101 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md][38]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md][39]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][40]: selected by [ADR-AUTO-TEST][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 125 (text) and `pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1`
  line 1 (header); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it
  at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1][41]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1 (header).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][42]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 125 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][43]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1076 (text).

## Keywords

- [world map][45]
- [track][46]
- [file language][47]
- [cell][48]
- [lit cell][49]
- [.claude][50]: a track
- [docs][50]: a track
- [pipelines][50]: a track
- [pwsh][50]: a track
- [markdown][51]: a file language
- [pipeline-yaml][51]: a file language
- [powershell][51]: a file language
- [yaml][51]: a file language

[1]: ../../../../adr/automation/test-automation.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/agents/test-optimization.md
[6]: ../../../../../.claude/plans/decisions-2026-10-16.md
[7]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[8]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[9]: ../../../../../.claude/skills/test-speed/SKILL.md
[10]: ../../../../adr/automation/dora-explains.md
[11]: ../../../../adr/flow/dora-explains.md
[12]: ../../../../adr/index.md
[13]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[14]: ../../../../references/pipelines/cd-apex.yaml.md
[15]: ../../../../references/pipelines/cd-flux.yaml.md
[16]: ../../../../references/pipelines/cd-nova.yaml.md
[17]: ../../../../references/pipelines/cd-shared.yaml.md
[18]: ../../../../references/pipelines/ci-automation.yaml.md
[19]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[20]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[21]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[24]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[25]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[26]: ../../../../references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md
[27]: ../../../../references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[28]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[29]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[30]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[31]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[32]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[33]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[34]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[35]: ../../../../references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md
[36]: ../../../../references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md
[37]: ../../../../references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md
[38]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md
[39]: ../../../../references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md
[40]: ../../../../../pipelines/ci-automation.yaml
[41]: ../../../../../pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1
[42]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[43]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[44]: ../../gates-check-source-and-trigger.md
[45]: ../../../../adr/glossary.md#world-map
[46]: ../../../../adr/glossary.md#track
[47]: ../../../../adr/glossary.md#file-language
[48]: ../../../../adr/glossary.md#cell
[49]: ../../../../adr/glossary.md#lit-cell
[50]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[51]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

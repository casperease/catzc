---
catzc:
  immutable:
    with_body_sha: ae81579e13f6
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
5 of 342 cells lit, holding 38 files.
```

![The world-map minimap of The CI budget is the only promotion rule a quality gate checks](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [The CI budget is the only promotion rule a quality gate
checks][42], which explains [ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 24 lit of 2761 files
- pipelines × pipeline-yaml: 3 lit of 13 files
- pwsh × powershell: 1 lit of 1649 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (7 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 126 (text), line 127 (text), line
  128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 36 (text) and line 79 (text).
- [.claude/plans/plan-promotion-ladder.md][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text), line 34 (text) and line 82
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 60 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 36 (text).

### docs × markdown (24 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 67 (text).
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD-TYPE][2]: the ADR's own file.
- [docs/adr/glossary.md][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 505 (text) and line 518 (text).
- [docs/adr/index.md][15]: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 132 (text).
- [docs/how-to/automation/apply-environment-approvals.md][16]: selected by [ADR-FLOW-CD][1]: the file cites it at line 4 (text).
- [docs/references/pipelines/cd-shared.yaml.md][17]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][18]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/stages/deploy-unit.yaml.md][19]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 11 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][21]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][22]: selected by [ADR-FLOW-CD-TYPE][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][23]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][24]: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][25]: selected by [ADR-FLOW-CD-TYPE][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][26]: selected by [ADR-FLOW-CD-TYPE][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md][27]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][28]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][29]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites
  it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][30]: selected by [ADR-FLOW-CD][1]: the file cites it at line 40 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][31]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text), line
  29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][32]: selected by [ADR-FLOW-CD][1]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][33]: selected by [ADR-FLOW-CD][1]: the file cites it at line 37
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][34]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (3 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][35]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line
  70 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text) and `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 58 (text);
  selected by [ADR-FLOW-CD-TYPE][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 100 (text).
- [pipelines/deploy-apex.yaml][36]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14 (body comment) (a passing mention only).
- [pipelines/deploy-shared.yaml][37]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14 (body comment) (a passing mention only).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][38]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text) and
  line 71 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][39]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 100 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][40]: selected by [ADR-FLOW-CD][1]: the file cites it at line 18 (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][41]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text).

## Keywords

- [world map][43]
- [track][44]
- [file language][45]
- [cell][46]
- [lit cell][47]
- [.claude][48]: a track
- [docs][48]: a track
- [pipelines][48]: a track
- [pwsh][48]: a track
- [markdown][49]: a file language
- [pipeline-yaml][49]: a file language
- [powershell][49]: a file language
- [yaml][49]: a file language

Terms the cited ADRs define:

- [gate][50], defined by [ADR-FLOW-CD#13][51]
- [release candidate][52], defined by [ADR-FLOW-CD#14][53]

[1]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../adr/flow/pipeline-types.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/CLAUDE.md
[7]: ../../../../../.claude/plans/plan-adr-code-language.md
[8]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[9]: ../../../../../.claude/plans/plan-promotion-ladder.md
[10]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[11]: ../../../../../.claude/plans/task-loose-ends.md
[12]: ../../../../../.claude/plans/value-of-plan.md
[13]: ../../../../adr/flow/dora-explains.md
[14]: ../../../../adr/glossary.md
[15]: ../../../../adr/index.md
[16]: ../../../../how-to/automation/apply-environment-approvals.md
[17]: ../../../../references/pipelines/cd-shared.yaml.md
[18]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[19]: ../../../../references/pipelines/stages/deploy-unit.yaml.md
[20]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[21]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[24]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[25]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[26]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[27]: ../../../../references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[30]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[31]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[32]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[33]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[34]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[35]: ../../../../../pipelines/ci-automation.yaml
[36]: ../../../../../pipelines/deploy-apex.yaml
[37]: ../../../../../pipelines/deploy-shared.yaml
[38]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[39]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[40]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[41]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[42]: ../../ci-budget-is-the-only-quality-gate.md
[43]: ../../../../adr/glossary.md#world-map
[44]: ../../../../adr/glossary.md#track
[45]: ../../../../adr/glossary.md#file-language
[46]: ../../../../adr/glossary.md#cell
[47]: ../../../../adr/glossary.md#lit-cell
[48]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[49]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[50]: ../../../../adr/glossary.md#gate
[51]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[52]: ../../../../adr/glossary.md#release-candidate
[53]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

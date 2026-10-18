---
catzc:
  immutable:
    with_body_sha: "8ca894d40931"
    repo_status: locked
    path: docs/explanation/flow/.assets/ci-budget-is-the-only-quality-gate/tree.md
    source: docs/explanation/flow/.assets/ci-budget-is-the-only-quality-gate/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The CI budget is the only promotion rule a quality gate checks: the tree minimap

```text
Which files cite ADR-FLOW-CD and ADR-FLOW-CD-TYPE: every file of the world map is a tile, grouped by top-level folder.
36 files lit in 9 groups.
```

![The tree minimap of The CI budget is the only promotion rule a quality gate checks](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [The CI budget is the only promotion rule a quality gate checks][37],
which explains [ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 36 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 19 lit files
- .claude: 7 lit files
- adr/flow (docs/adr/flow): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 19 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 4 (text).
- [docs/references/pipelines/cd-shared.yaml.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-TYPE][2]: the file cites
  it at line 12 (text).
- [docs/references/pipelines/stages/deploy-unit.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-TYPE][2]: the file cites
  it at line 11 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][10], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][11], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][12], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][13], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 40 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][19], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 54 (text).

### .claude (7 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][22], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][23], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 126
  (text), line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][24], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 36 (text) and line 79 (text).
- [.claude/plans/plan-promotion-ladder.md][25], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 12
  (text), line 34 (text) and line 78 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 60 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][26], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 20 (text).
- [.claude/plans/task-loose-ends.md][27], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][28], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 36 (text).

### adr/flow (docs/adr/flow, 3 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][29], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text);
  selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 67 (text).
- [docs/adr/flow/pipeline-types.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-TYPE][2]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 505 (text) and line 518
  (text).
- [docs/adr/index.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 132 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][32], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1`
  line 71 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text) and `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
  line 58 (text); selected by [ADR-FLOW-CD-TYPE][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 100 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][33], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text);
  selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 100 (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][34], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 70 (text) and line 71 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][35], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  18 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][36], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  58 (text).

## Keywords

- [world map][38]
- [track][39]
- [file language][40]
- [cell][41]
- [lit cell][42]
- [.claude][43]: a track
- [docs][43]: a track
- [pipelines][43]: a track
- [pwsh][43]: a track
- [markdown][44]: a file language
- [pipeline-yaml][44]: a file language
- [powershell][44]: a file language
- [yaml][44]: a file language

Terms the cited ADRs define:

- [gate][45], defined by [ADR-FLOW-CD#13][46]
- [release candidate][47], defined by [ADR-FLOW-CD#14][48]

[1]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../adr/flow/pipeline-types.md
[3]: ../../../../how-to/automation/apply-environment-approvals.md
[4]: ../../../../references/pipelines/cd-shared.yaml.md
[5]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[6]: ../../../../references/pipelines/stages/deploy-unit.yaml.md
[7]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[8]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[9]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[10]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[11]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[12]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[13]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[14]: ../../../../references/pwsh/catzc-azure-devops/New-AdoPullRequest.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[16]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[17]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[18]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[19]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[20]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[21]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[22]: ../../../../../.claude/CLAUDE.md
[23]: ../../../../../.claude/plans/plan-adr-code-language.md
[24]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[25]: ../../../../../.claude/plans/plan-promotion-ladder.md
[26]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[27]: ../../../../../.claude/plans/task-loose-ends.md
[28]: ../../../../../.claude/plans/value-of-plan.md
[29]: ../../../../adr/flow/dora-explains.md
[30]: ../../../../adr/glossary.md
[31]: ../../../../adr/index.md
[32]: ../../../../../pipelines/ci-automation.yaml
[33]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[35]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[36]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[37]: ../../ci-budget-is-the-only-quality-gate.md
[38]: ../../../../adr/glossary.md#world-map
[39]: ../../../../adr/glossary.md#track
[40]: ../../../../adr/glossary.md#file-language
[41]: ../../../../adr/glossary.md#cell
[42]: ../../../../adr/glossary.md#lit-cell
[43]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[44]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[45]: ../../../../adr/glossary.md#gate
[46]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[47]: ../../../../adr/glossary.md#release-candidate
[48]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

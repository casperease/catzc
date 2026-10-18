---
catzc:
  immutable:
    with_body_sha: af6db6f5f25f
    repo_status: locked
    path: docs/explanation/flow/.assets/gates-check-source-and-trigger/tree.md
    source: docs/explanation/flow/.assets/gates-check-source-and-trigger/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Gates check the source of each globset and the trigger, but not the git reflection or the identity: the tree minimap

```text
Which files cite ADR-AUTO-TEST and ADR-FLOW-CD-GLOBS: every file of the world map is a tile, grouped by top-level folder.
42 files lit in 9 groups.
```

![The tree minimap of Gates check the source of each globset and the trigger, but not the git reflection or the identity](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Gates check the source of each globset and the trigger, but not the
git reflection or the identity][43], which explains [ADR-AUTO-TEST][1] and [ADR-FLOW-CD-GLOBS][2]. It lights every file that cites those
codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 42 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 27 lit files
- .claude: 6 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Modules (pwsh/Catzc.Base.Modules): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 27 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][3], in the cell docs ×
  markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 44 (text).
- [docs/references/pipelines/cd-apex.yaml.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][13], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][14], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][15], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md][16], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 136 (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][17], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 95 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][23], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][24], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 43 (text).
- [docs/references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md][25], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md][26], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 42 (text).
- [docs/references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md][27], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 101 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 15 (text).

### .claude (6 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][30], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 54 (text).
- [.claude/agents/test-optimization.md][31], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (text).
- [.claude/plans/decisions-2026-10-16.md][32], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 80
  (text) and line 83 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][33], in the cell .claude × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 109 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][34], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 204 (text).
- [.claude/skills/test-speed/SKILL.md][35], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][36], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 140
  (text).
- [docs/adr/automation/test-automation.md][1], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the ADR's own file.

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][37], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92
  (text).
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][38], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 158 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 135 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][39], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-TEST][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 125 (text) and
  `pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1` line 1 (header); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][40], in the cell pwsh × yaml: selected by [ADR-AUTO-TEST][1]: the file cites it at line 125
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text).

### Modules (pwsh/Catzc.Base.Modules, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Modules; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1][41], in the cell pwsh × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 1 (header).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][42], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 1076 (text).

## Keywords

- [world map][44]
- [track][45]
- [file language][46]
- [cell][47]
- [lit cell][48]
- [.claude][49]: a track
- [docs][49]: a track
- [pipelines][49]: a track
- [pwsh][49]: a track
- [markdown][50]: a file language
- [pipeline-yaml][50]: a file language
- [powershell][50]: a file language
- [yaml][50]: a file language

[1]: ../../../../adr/automation/test-automation.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[4]: ../../../../references/pipelines/cd-apex.yaml.md
[5]: ../../../../references/pipelines/cd-flux.yaml.md
[6]: ../../../../references/pipelines/cd-nova.yaml.md
[7]: ../../../../references/pipelines/cd-shared.yaml.md
[8]: ../../../../references/pipelines/ci-automation.yaml.md
[9]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[10]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[11]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[12]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[13]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[14]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[15]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[16]: ../../../../references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md
[17]: ../../../../references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[18]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[19]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[20]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[21]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[22]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[23]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[24]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[25]: ../../../../references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md
[26]: ../../../../references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md
[27]: ../../../../references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md
[28]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md
[29]: ../../../../references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md
[30]: ../../../../../.claude/CLAUDE.md
[31]: ../../../../../.claude/agents/test-optimization.md
[32]: ../../../../../.claude/plans/decisions-2026-10-16.md
[33]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[34]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[35]: ../../../../../.claude/skills/test-speed/SKILL.md
[36]: ../../../../adr/automation/dora-explains.md
[37]: ../../../../adr/flow/dora-explains.md
[38]: ../../../../adr/index.md
[39]: ../../../../../pipelines/ci-automation.yaml
[40]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[41]: ../../../../../pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1
[42]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[43]: ../../gates-check-source-and-trigger.md
[44]: ../../../../adr/glossary.md#world-map
[45]: ../../../../adr/glossary.md#track
[46]: ../../../../adr/glossary.md#file-language
[47]: ../../../../adr/glossary.md#cell
[48]: ../../../../adr/glossary.md#lit-cell
[49]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[50]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

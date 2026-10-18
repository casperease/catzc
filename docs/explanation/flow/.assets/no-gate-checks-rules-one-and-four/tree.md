---
catzc:
  immutable:
    with_body_sha: "3048d49e1674"
    repo_status: locked
    path: docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four/tree.md
    source: docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# No gate checks the runner rules 1 or 4, and the step template breaks rule 3: the tree minimap

```text
Which files cite ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME: every file of the world map is a tile, grouped by top-level folder.
30 files lit in 10 groups.
```

![The tree minimap of No gate checks the runner rules 1 or 4, and the step template breaks rule 3](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [No gate checks the runner rules 1 or 4, and the step template breaks
rule 3][31], which explains [ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]. It lights every file that cites those codes, grouped by folder,
so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 30 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 11 lit files
- .claude: 7 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/pipe (docs/adr/pipelines): 2 lit files
- Az.DevOps (pwsh/Catzc.Azure.DevOps): 2 lit files
- RootConfig (pwsh/Catzc.Base.RootConfig): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 11 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][4], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 14 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][5], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it
  at line 13 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md][8], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 15 (text), line 22 (text), line 25 (text), line 29 (text), line 32 (text), line 34 (text), line 40 (text), line 76
  (text), line 86 (text), line 96 (text), line 105 (text), line 114 (text) and line 123 (text).
- [docs/references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][11], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 45 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]:
  the file cites it at line 54 (text).

### .claude (7 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][14], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 55 (text) and line
  56 (text).
- [.claude/plans/plan-adr-code-language.md][15], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 126 (text), line 126 (text), line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][16], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][17], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 12 (text), line 35 (text) and line 87 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][18], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 21 (text).
- [.claude/plans/task-loose-ends.md][19], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 59
  (text).
- [.claude/plans/value-of-plan.md][20], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 34
  (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 11
  (text) and line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/pipe (docs/adr/pipelines, 2 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/dora-explains.md][22], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45
  (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the ADR's own file.

### Az.DevOps (pwsh/Catzc.Azure.DevOps, 2 lit files)

The group holds the files of pwsh/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1][23], in the cell pwsh × powershell: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  51 (text), line 56 (text), line 63 (text), line 68 (text), line 71 (text), line 75 (text), line 78 (text) and line 85 (text).
- [pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][24], in the cell pwsh × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 47 (text), line 48 (text), line 57 (text), line 60 (text), line 64 (text), line 72 (text), line 74 (text), line 77
  (text), line 79 (text), line 82 (text), line 84 (text), line 87 (text), line 89 (text), line 92 (text), line 94 (text), line 102 (text),
  line 105 (text), line 116 (text) and line 121 (text).

### RootConfig (pwsh/Catzc.Base.RootConfig, 2 lit files)

The group holds the files of pwsh/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][25], in the cell pwsh × yaml: selected by [ADR-PIPE-NAME][2]: the file cites it
  at line 9 (header).
- [pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][26], in the cell pwsh × yaml: selected by [ADR-PIPE-NAME][2]: the file cites it
  at line 8 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][27], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 129 (text) and line
  130 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 252 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][28], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text) and
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 56 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 63 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 68 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 71 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 75 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 78 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 85 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 48 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 57
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 60 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 64 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 72 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 74 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 77
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 79 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 82 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 84 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 87 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 89
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 92 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 94 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 102 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 105 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line
  116 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 121 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 225
  (text), `pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 9 (header) and
  `pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml` line 8 (header).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][29], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 97
  (text) and line 98 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 225 (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][30], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 70 (text) and line 71 (text).

## Keywords

- [world map][32]
- [track][33]
- [file language][34]
- [cell][35]
- [lit cell][36]
- [.claude][37]: a track
- [docs][37]: a track
- [pipelines][37]: a track
- [pwsh][37]: a track
- [markdown][38]: a file language
- [pipeline-yaml][38]: a file language
- [powershell][38]: a file language
- [yaml][38]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../../how-to/automation/apply-environment-approvals.md
[4]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[5]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[6]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[7]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[8]: ../../../../references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md
[9]: ../../../../references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md
[10]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[11]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[12]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[13]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[14]: ../../../../../.claude/CLAUDE.md
[15]: ../../../../../.claude/plans/plan-adr-code-language.md
[16]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[17]: ../../../../../.claude/plans/plan-promotion-ladder.md
[18]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[19]: ../../../../../.claude/plans/task-loose-ends.md
[20]: ../../../../../.claude/plans/value-of-plan.md
[21]: ../../../../adr/flow/dora-explains.md
[22]: ../../../../adr/pipelines/dora-explains.md
[23]: ../../../../../pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1
[24]: ../../../../../pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[25]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[26]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[27]: ../../../../adr/index.md
[28]: ../../../../../pipelines/ci-automation.yaml
[29]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[30]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[31]: ../../no-gate-checks-rules-one-and-four.md
[32]: ../../../../adr/glossary.md#world-map
[33]: ../../../../adr/glossary.md#track
[34]: ../../../../adr/glossary.md#file-language
[35]: ../../../../adr/glossary.md#cell
[36]: ../../../../adr/glossary.md#lit-cell
[37]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[38]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

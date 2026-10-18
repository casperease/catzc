---
catzc:
  immutable:
    with_body_sha: "9359a856bc6d"
    repo_status: locked
    path: docs/explanation/flow/.assets/the-step-is-named-after-its-command/tree.md
    source: docs/explanation/flow/.assets/the-step-is-named-after-its-command/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The Azure DevOps step is named after its command, and its log echoes the command before it runs: the tree minimap

```text
Which files cite ADR-FLOW-CD-RUNNER: every file of the world map is a tile, grouped by top-level folder.
19 files lit in 7 groups.
```

![The tree minimap of The Azure DevOps step is named after its command, and its log echoes the command before it runs](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [The Azure DevOps step is named after its command, and its log echoes
the command before it runs][20], which explains [ADR-FLOW-CD-RUNNER][1]. It lights every file that cites those codes, grouped by folder, so
it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 19 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 7 lit files
- docs (docs/ outside docs/adr/): 6 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file

## Why each group is lit

### .claude (7 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][2], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 55 (text) and line
  56 (text).
- [.claude/plans/plan-adr-code-language.md][3], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 126 (text), line 126 (text), line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][4], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][5], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 12 (text), line 35 (text) and line 87 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][6], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 21 (text).
- [.claude/plans/task-loose-ends.md][7], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 59
  (text).
- [.claude/plans/value-of-plan.md][8], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 34
  (text).

### docs (docs/ outside docs/adr/, 6 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 4 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]:
  the file cites it at line 54 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 11
  (text) and line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 129 (text) and line
  130 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][17], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text) and
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][18], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 97
  (text) and line 98 (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][19], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 70 (text) and line 71 (text).

## Keywords

- [world map][21]
- [track][22]
- [file language][23]
- [cell][24]
- [lit cell][25]
- [.claude][26]: a track
- [docs][26]: a track
- [pipelines][26]: a track
- [pwsh][26]: a track
- [markdown][27]: a file language
- [pipeline-yaml][27]: a file language
- [powershell][27]: a file language
- [yaml][27]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../../.claude/CLAUDE.md
[3]: ../../../../../.claude/plans/plan-adr-code-language.md
[4]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[5]: ../../../../../.claude/plans/plan-promotion-ladder.md
[6]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[7]: ../../../../../.claude/plans/task-loose-ends.md
[8]: ../../../../../.claude/plans/value-of-plan.md
[9]: ../../../../how-to/automation/apply-environment-approvals.md
[10]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[11]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[12]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[13]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[14]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[15]: ../../../../adr/flow/dora-explains.md
[16]: ../../../../adr/index.md
[17]: ../../../../../pipelines/ci-automation.yaml
[18]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[19]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[20]: ../../the-step-is-named-after-its-command.md
[21]: ../../../../adr/glossary.md#world-map
[22]: ../../../../adr/glossary.md#track
[23]: ../../../../adr/glossary.md#file-language
[24]: ../../../../adr/glossary.md#cell
[25]: ../../../../adr/glossary.md#lit-cell
[26]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[27]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

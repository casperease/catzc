---
catzc:
  immutable:
    with_body_sha: "639225f2de53"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md
    source: docs/explanation/.assets/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# No gate checks the runner rules 1 or 4, and the step template breaks rule 3: the tree minimap

```text
Which files cite ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME: every file of the world map is a tile, grouped by top-level folder.
21 files lit in 9 groups.
```

![The tree minimap of No gate checks the runner rules 1 or 4, and the step template breaks rule 3](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [No gate checks the runner rules 1 or 4, and the step template breaks
rule 3][22], which explains [ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]. It lights every file that cites those codes, grouped by folder,
so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 21 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 6 lit files
- .claude: 4 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 2 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/pipe (docs/adr/pipelines): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 6 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][3], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 14 (text).
- [docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md][4], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 15 (text), line 22 (text), line 25 (text), line 29 (text), line 32 (text), line 34 (text), line 40 (text), line 76
  (text), line 86 (text), line 96 (text), line 105 (text), line 114 (text) and line 123 (text).
- [docs/references/automation/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 23 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][6], in the cell docs × markdown: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 45 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][7], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it
  at line 13 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 28 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][9], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][10], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 279 (text).
- [.claude/plans/prompt-adr-links-and-plans-continue.md][11], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 53 (text) and line 53 (text).
- [.claude/plans/task-adr-link-cleanup.md][12], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 54
  (text) and line 54 (text).

### Az.DevOps (automation/Catzc.Azure.DevOps, 2 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][13], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 51 (text), line 56 (text), line 63 (text), line 68 (text), line 71 (text), line 75 (text), line 78 (text) and line 85
  (text).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][14], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 47 (text), line 48 (text), line 57 (text), line 60 (text), line 64 (text), line 72 (text), line 74 (text), line
  77 (text), line 79 (text), line 82 (text), line 84 (text), line 87 (text), line 89 (text), line 92 (text), line 94 (text), line 102
  (text), line 105 (text), line 116 (text) and line 121 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][15], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][16], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 8 (header).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/pipe (docs/adr/pipelines, 2 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45
  (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][19], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 98 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 225 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 130 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 252 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][21], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 98 (text); selected by
  [ADR-PIPE-NAME][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 56 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 63 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 68 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 71 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 75 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 78 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 85 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 47 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 48 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 57 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 60 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 64 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 72 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 74 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 77 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 79 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 82 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 84 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 87 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 89 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 92 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 94 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 102 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 105 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 116 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 121 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 225
  (text), `automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 9 (header) and
  `automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml` line 8 (header).

## Keywords

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [.claude][28]: a track
- [automation][28]: a track
- [docs][28]: a track
- [pipelines][28]: a track
- [markdown][29]: a file language
- [pipeline-yaml][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

[1]: ../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[4]: ../../../references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
[5]: ../../../references/automation/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md
[6]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[7]: ../../../references/pipelines/extends/cd-customer.yaml.md
[8]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[9]: ../../../../.claude/CLAUDE.md
[10]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[11]: ../../../../.claude/plans/prompt-adr-links-and-plans-continue.md
[12]: ../../../../.claude/plans/task-adr-link-cleanup.md
[13]: ../../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[14]: ../../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[15]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[16]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[17]: ../../../adr/flow/dora-explains.md
[18]: ../../../adr/pipelines/dora-explains.md
[19]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../adr/index.md
[21]: ../../../../pipelines/ci-automation.yaml
[22]: ../../flow/no-gate-checks-rules-one-and-four.md
[23]: ../../../adr/glossary.md#world-map
[24]: ../../../adr/glossary.md#track
[25]: ../../../adr/glossary.md#file-language
[26]: ../../../adr/glossary.md#cell
[27]: ../../../adr/glossary.md#lit-cell
[28]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

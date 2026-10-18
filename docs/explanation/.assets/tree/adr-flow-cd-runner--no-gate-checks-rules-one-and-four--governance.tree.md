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

- docs (docs/ outside docs/adr/): 5 lit files
- .claude: 4 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/pipe (docs/adr/pipelines): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][3], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 33 (text).
- [docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md][4], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 17 (text), line 30 (text), line 40 (text), line 50 (text), line 59 (text), line 68 (text) and line 77 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][5], in the cell docs × markdown: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 19 (text) and line 68 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][6], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it
  at line 32 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 44 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][8], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 53 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][9], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 306 (text).
- [.claude/plans/prompt-adr-links-and-plans-continue.md][10], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 18 (text), line 74 (text) and line 74 (text).
- [.claude/plans/task-adr-link-cleanup.md][11], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 24
  (text), line 73 (text) and line 73 (text).

### Az.DevOps (automation/Catzc.Azure.DevOps, 3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][12], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 23 (header), line 28 (header), line 35 (header), line 38 (header), line 42 (header), line 45 (header), line 47 (header),
  line 52 (header), line 115 (text), line 120 (text), line 127 (text), line 132 (text), line 135 (text), line 139 (text), line 142 (text)
  and line 149 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][13], in the cell automation × powershell: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][14], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 21 (header), line 72 (text), line 73 (text), line 82 (text), line 85 (text), line 89 (text), line 97 (text),
  line 99 (text), line 102 (text), line 104 (text), line 107 (text), line 109 (text), line 112 (text), line 114 (text), line 117 (text),
  line 119 (text), line 127 (text), line 130 (text), line 141 (text) and line 146 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][15], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][16], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 8 (header).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/pipe (docs/adr/pipelines, 2 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 73
  (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][19], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 117 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 244 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 130 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 252 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][21], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 117 (text); selected
  by [ADR-PIPE-NAME][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 23 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 28 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 35 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 38 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 42 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 45 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 47 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 52 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 115 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 120 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 127 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 132 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 135 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 139 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 142 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 149 (text),
  `automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 72 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 73 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 82 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 85 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 89 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 97 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 99 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 102 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 104 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 107 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 109 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 112 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 114 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 117 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 119 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 127 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 130 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 141 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 146 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 244
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
[5]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[6]: ../../../references/pipelines/extends/cd-customer.yaml.md
[7]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[8]: ../../../../.claude/CLAUDE.md
[9]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[10]: ../../../../.claude/plans/prompt-adr-links-and-plans-continue.md
[11]: ../../../../.claude/plans/task-adr-link-cleanup.md
[12]: ../../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[13]: ../../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
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

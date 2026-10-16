# docs/.assets/explanation/tree/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md

`Tree minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Tree minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 25 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- .claude: 3 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/pipe (docs/adr/pipelines): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][3], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 109 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][4], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 13 (text), line 254 (text) and line 277 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][5], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 55 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][6], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 95 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][7], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 79 (text) and line 106 (text).

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][8], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 33 (text).
- [docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md][9], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 16 (text), line 29 (text), line 39 (text), line 49 (text), line 58 (text), line 67 (text) and line 76 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][10], in the cell docs × markdown: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 18 (text) and line 67 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][11], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 31 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 43 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][13], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 51 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][14], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 258 (text).
- [.claude/plans/prompt-adr-links-and-plans-continue.md][15], in the cell .claude × markdown: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 52 (text) and line 52 (text).

### Az.DevOps (automation/Catzc.Azure.DevOps, 3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][16], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 22 (header), line 27 (header), line 34 (header), line 37 (header), line 41 (header), line 44 (header), line 46 (header),
  line 51 (header), line 114 (text), line 119 (text), line 126 (text), line 131 (text), line 134 (text), line 138 (text), line 141 (text)
  and line 148 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][17], in the cell automation × powershell: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][18], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 20 (header), line 71 (text), line 72 (text), line 81 (text), line 84 (text), line 88 (text), line 96 (text),
  line 98 (text), line 101 (text), line 103 (text), line 106 (text), line 108 (text), line 111 (text), line 113 (text), line 116 (text),
  line 118 (text), line 126 (text), line 129 (text), line 140 (text) and line 145 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][19], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][20], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 8 (header).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/pipe (docs/adr/pipelines, 2 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/dora-explains.md][22], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 73
  (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][23], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 115 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 237 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][24], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 125 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 242 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][25], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 115 (text); selected
  by [ADR-PIPE-NAME][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 22 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 27 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 34 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 37 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 41 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 44 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 46 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 114 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 119 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 126 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 131 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 134 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 138 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 141 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 148 (text),
  `automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 71 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 72 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 81 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 84 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 88 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 96 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 98 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 101 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 103 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 106 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 108 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 111 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 113 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 116 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 118 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 126 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 129 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 140 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 145 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 237
  (text), `automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 9 (header) and
  `automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml` line 8 (header).

## Keywords

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [.claude][31]: a track
- [.unordered][31]: a track
- [automation][31]: a track
- [docs][31]: a track
- [pipelines][31]: a track
- [markdown][32]: a file language
- [pipeline-yaml][32]: a file language
- [powershell][32]: a file language
- [yaml][32]: a file language

[1]: ../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[4]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[5]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[6]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[7]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[8]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[9]: ../../../references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
[10]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[11]: ../../../references/pipelines/extends/cd-customer.yaml.md
[12]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[13]: ../../../../.claude/CLAUDE.md
[14]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[15]: ../../../../.claude/plans/prompt-adr-links-and-plans-continue.md
[16]: ../../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[17]: ../../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[18]: ../../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[19]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[20]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[21]: ../../../adr/flow/dora-explains.md
[22]: ../../../adr/pipelines/dora-explains.md
[23]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../adr/index.md
[25]: ../../../../pipelines/ci-automation.yaml
[26]: ../../../adr/glossary.md#world-map
[27]: ../../../adr/glossary.md#track
[28]: ../../../adr/glossary.md#file-language
[29]: ../../../adr/glossary.md#cell
[30]: ../../../adr/glossary.md#lit-cell
[31]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[32]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

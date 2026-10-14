# docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md

`Tree minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Tree minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 28 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/flow (docs/adr/flow): 6 lit files
- docs (docs/ outside docs/adr/): 6 lit files
- adr/pipe (docs/adr/pipelines): 5 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- pipelines: 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Languages (automation/Catzc.Base.Languages): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow`
  ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### docs (6 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/flow/a-step-only-names-a-command.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 14 (text), line 41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 12 (text), line 39 (text), line 40 (text) and line 55 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 15 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 17 (text), line 57 (text), line 58 (text) and line 59 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][13], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 16 (text).

### adr/pipe (5 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/custom-template-discipline.md][14], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR
  domain, the ADR domain of that code.
- [docs/adr/pipelines/dual-authentication.md][16], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][17], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.

### Az.DevOps (3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][18], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 4 (header), line 7 (header), line 14 (header), line 17 (header), line 21 (header), line 24 (header), line 26 (header),
  line 31 (header), line 96 (text), line 100 (body comment), line 103 (text), line 109 (body comment), line 113 (text), line 118 (body
  comment), line 121 (text), line 124 (text), line 127 (body comment), line 130 (text), line 132 (body comment), line 135 (text), line 140
  (body comment) and line 144 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][19], in the cell automation × powershell: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][20], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 49 (text), line 50 (text), line 59 (text), line 62 (text), line 66 (text), line 74 (text), line 76 (text), line
  79 (text), line 81 (text), line 84 (text), line 86 (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 104
  (text), line 107 (text), line 118 (text) and line 123 (text).

### RootConfig (2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][21], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][22], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 8 (header).

### pipelines (2 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/extends/cd-customer.yaml][23], in the cell pipelines × pipeline-yaml: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  3 (header).
- [pipelines/steps/invoke-automation.yaml][24], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 18 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][25], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][26], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 119 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 238 (text).

### Languages (1 lit file)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/configs/languages.yml][27], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 35 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][28], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 222 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [.claude][34]: a track
- [automation][34]: a track
- [docs][34]: a track
- [pipelines][34]: a track
- [markdown][27]: a file language
- [pipeline-yaml][27]: a file language
- [powershell][27]: a file language
- [yaml][27]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[4]: ../../adr/flow/dora-explains.md
[5]: ../../adr/flow/durable-sha-globs.md
[6]: ../../adr/flow/pipeline-detection.md
[7]: ../../adr/flow/pipeline-types.md
[8]: ../../explanation/flow/a-step-only-names-a-command.md
[9]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[10]: ../../explanation/flow/the-runner-is-the-only-seam.md
[11]: ../../explanation/flow/the-step-is-named-after-its-command.md
[12]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[13]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[14]: ../../adr/pipelines/custom-template-discipline.md
[15]: ../../adr/pipelines/dora-explains.md
[16]: ../../adr/pipelines/dual-authentication.md
[17]: ../../adr/pipelines/pipeline-variables.md
[18]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[19]: ../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[20]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[21]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[22]: ../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[23]: ../../../pipelines/extends/cd-customer.yaml
[24]: ../../../pipelines/steps/invoke-automation.yaml
[25]: ../../../.claude/CLAUDE.md
[26]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[27]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[28]: ../../adr/index.md
[29]: ../../adr/glossary.md#world-map
[30]: ../../adr/glossary.md#track
[31]: ../../adr/glossary.md#file-language
[32]: ../../adr/glossary.md#cell
[33]: ../../adr/glossary.md#lit-cell
[34]: ../../../automation/Catzc.Base.Variants/configs/variants.yml

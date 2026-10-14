# docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md

`Tree minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Tree minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 23 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/flow (docs/adr/flow): 6 lit files
- adr/pipe (docs/adr/pipelines): 5 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- pipelines: 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Languages (automation/Catzc.Base.Languages): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file

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

### adr/pipe (5 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/custom-template-discipline.md][8], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/dora-explains.md][9], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR
  domain, the ADR domain of that code.
- [docs/adr/pipelines/dual-authentication.md][10], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][11], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.

### Az.DevOps (3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][12], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 4 (header), line 7 (header), line 14 (header), line 17 (header), line 21 (header), line 24 (header), line 26 (header),
  line 31 (header), line 96 (text), line 100 (body comment), line 103 (text), line 109 (body comment), line 113 (text), line 118 (body
  comment), line 121 (text), line 124 (text), line 127 (body comment), line 130 (text), line 132 (body comment), line 135 (text), line 140
  (body comment) and line 144 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][13], in the cell automation × powershell: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][14], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 49 (text), line 50 (text), line 59 (text), line 62 (text), line 66 (text), line 74 (text), line 76 (text), line
  79 (text), line 81 (text), line 84 (text), line 86 (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 104
  (text), line 107 (text), line 118 (text) and line 123 (text).

### RootConfig (2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][15], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][16], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 8 (header).

### pipelines (2 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/extends/cd-customer.yaml][17], in the cell pipelines × pipeline-yaml: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  3 (header).
- [pipelines/steps/invoke-automation.yaml][18], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 18 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][19], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 119 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 237 (text).

### Languages (1 lit file)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/configs/languages.yml][21], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 35 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 221 (text).

### docs (1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][23], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 16 (text).

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [.claude][29]: a track
- [automation][29]: a track
- [docs][29]: a track
- [pipelines][29]: a track
- [markdown][21]: a file language
- [pipeline-yaml][21]: a file language
- [powershell][21]: a file language
- [yaml][21]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[4]: ../../adr/flow/dora-explains.md
[5]: ../../adr/flow/durable-sha-globs.md
[6]: ../../adr/flow/pipeline-detection.md
[7]: ../../adr/flow/pipeline-types.md
[8]: ../../adr/pipelines/custom-template-discipline.md
[9]: ../../adr/pipelines/dora-explains.md
[10]: ../../adr/pipelines/dual-authentication.md
[11]: ../../adr/pipelines/pipeline-variables.md
[12]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[13]: ../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[14]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[15]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[16]: ../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[17]: ../../../pipelines/extends/cd-customer.yaml
[18]: ../../../pipelines/steps/invoke-automation.yaml
[19]: ../../../.claude/CLAUDE.md
[20]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[22]: ../../adr/index.md
[23]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[24]: ../../adr/glossary.md#world-map
[25]: ../../adr/glossary.md#track
[26]: ../../adr/glossary.md#file-language
[27]: ../../adr/glossary.md#cell
[28]: ../../adr/glossary.md#lit-cell
[29]: ../../../automation/Catzc.Base.Variants/configs/variants.yml

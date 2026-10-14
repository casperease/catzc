# docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md

`Tree minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Tree minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 48 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 26 lit files
- adr/flow (docs/adr/flow): 6 lit files
- adr/pipe (docs/adr/pipelines): 5 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- pipelines: 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Languages (automation/Catzc.Base.Languages): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (26 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md][3], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md][4], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md][5], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text), line 46
  (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text),
  line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md][6], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37
  (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md][7], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text) and line 29 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 8 (text), line 37 (text), line 37 (text), line 45 (text), line 45 (text), line 53 (text),
  line 53 (text), line 61 (text) and line 61 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62 (text) and line 71 (text); selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 62 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md][9], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 52 (text), line 64 (text), line 67 (text),
  line 70 (text), line 72 (text), line 74 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85
  (text), line 87 (text), line 99 (text), line 101 (text), line 104 (text), line 106 (text), line 108 (text) and line 118 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 8 (text), line 36 (text), line 40 (text), line 42 (text), line 53 (text), line 54 (text),
  line 55 (text), line 57 (text), line 67 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97
  (text), line 102 (text), line 110 (text) and line 117 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md][10], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 39 (text), line 41 (text),
  line 43 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 53 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 72 (text), line 121 (text), line 128 (text), line 134 (text) and line 148 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 8 (text), line 36 (text), line 47 (text), line 55 (text), line 79 (text), line 81 (text),
  line 83 (text), line 85 (text), line 87 (text), line 94 (text), line 100 (text), line 101 (text), line 110 (text), line 112 (text), line
  119 (text), line 135 (text), line 141 (text) and line 149 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md][11], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md][12], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md][13], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md][14], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md][15], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md][16], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md][17], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md][18], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md][19], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md][20], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md][21], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 28 (text), line 35 (text), line 42 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text) and line 81 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md][22], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text),
  line 38 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 64 (text), line 71 (text), line 77 (text), line 84 (text) and line 90 (text).
- [docs/explanation/flow/a-step-only-names-a-command.md][23], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 14 (text), line 41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][24], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 12 (text), line 39 (text), line 40 (text) and line 55 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 15 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][26], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][27], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 17 (text), line 57 (text), line 58 (text) and line 59 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][28], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 16 (text).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][29], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow`
  ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][33], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### adr/pipe (5 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/custom-template-discipline.md][34], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/dora-explains.md][35], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR
  domain, the ADR domain of that code.
- [docs/adr/pipelines/dual-authentication.md][36], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][37], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.

### Az.DevOps (3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][38], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 4 (header), line 7 (header), line 14 (header), line 17 (header), line 21 (header), line 24 (header), line 26 (header),
  line 31 (header), line 96 (text), line 100 (body comment), line 103 (text), line 109 (body comment), line 113 (text), line 118 (body
  comment), line 121 (text), line 124 (text), line 127 (body comment), line 130 (text), line 132 (body comment), line 135 (text), line 140
  (body comment) and line 144 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][39], in the cell automation × powershell: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][40], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 49 (text), line 50 (text), line 59 (text), line 62 (text), line 66 (text), line 74 (text), line 76 (text), line
  79 (text), line 81 (text), line 84 (text), line 86 (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 104
  (text), line 107 (text), line 118 (text) and line 123 (text).

### RootConfig (2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][41], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][42], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 8 (header).

### pipelines (2 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/extends/cd-customer.yaml][43], in the cell pipelines × pipeline-yaml: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  3 (header).
- [pipelines/steps/invoke-automation.yaml][44], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 18 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][45], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][46], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 119 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 237 (text).

### Languages (1 lit file)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/configs/languages.yml][47], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 35 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][48], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 221 (text).

## Keywords

- [world map][49]
- [track][50]
- [file language][51]
- [cell][52]
- [lit cell][53]
- [.claude][54]: a track
- [automation][54]: a track
- [docs][54]: a track
- [pipelines][54]: a track
- [markdown][47]: a file language
- [pipeline-yaml][47]: a file language
- [powershell][47]: a file language
- [yaml][47]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/pipelines/pipeline-naming-and-placement.md
[3]: adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
[4]: adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md
[5]: adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
[6]: adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md
[7]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
[8]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md
[9]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
[10]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md
[11]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
[12]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md
[13]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
[14]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md
[15]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
[16]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md
[17]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
[18]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md
[19]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md
[20]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md
[21]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
[22]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md
[23]: ../../explanation/flow/a-step-only-names-a-command.md
[24]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[25]: ../../explanation/flow/the-runner-is-the-only-seam.md
[26]: ../../explanation/flow/the-step-is-named-after-its-command.md
[27]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[28]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[29]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[30]: ../../adr/flow/dora-explains.md
[31]: ../../adr/flow/durable-sha-globs.md
[32]: ../../adr/flow/pipeline-detection.md
[33]: ../../adr/flow/pipeline-types.md
[34]: ../../adr/pipelines/custom-template-discipline.md
[35]: ../../adr/pipelines/dora-explains.md
[36]: ../../adr/pipelines/dual-authentication.md
[37]: ../../adr/pipelines/pipeline-variables.md
[38]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[39]: ../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[40]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[41]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[42]: ../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[43]: ../../../pipelines/extends/cd-customer.yaml
[44]: ../../../pipelines/steps/invoke-automation.yaml
[45]: ../../../.claude/CLAUDE.md
[46]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[47]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[48]: ../../adr/index.md
[49]: ../../adr/glossary.md#world-map
[50]: ../../adr/glossary.md#track
[51]: ../../adr/glossary.md#file-language
[52]: ../../adr/glossary.md#cell
[53]: ../../adr/glossary.md#lit-cell
[54]: ../../../automation/Catzc.Base.Variants/configs/variants.yml

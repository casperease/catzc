# docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md

`Tree minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Tree minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 16 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/pipe (docs/adr/pipelines): 2 lit files
- pipelines: 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Languages (automation/Catzc.Base.Languages): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file

## Why each group is lit

### Az.DevOps (automation/Catzc.Azure.DevOps, 3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][3], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 4 (header), line 7 (header), line 14 (header), line 17 (header), line 21 (header), line 24 (header), line 26 (header), line 31
  (header), line 96 (text), line 100 (body comment), line 103 (text), line 109 (body comment), line 113 (text), line 118 (body comment),
  line 121 (text), line 124 (text), line 127 (body comment), line 130 (text), line 132 (body comment), line 135 (text), line 140 (body
  comment) and line 144 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][4], in the cell automation × powershell: selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][5], in the cell automation × powershell: selected by [ADR-PIPE-NAME][2]:
  the file cites it at line 49 (text), line 50 (text), line 59 (text), line 62 (text), line 66 (text), line 74 (text), line 76 (text), line
  79 (text), line 81 (text), line 84 (text), line 86 (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 104
  (text), line 107 (text), line 118 (text) and line 123 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 2 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][6], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 9 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][7], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 8 (header).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 33
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/pipe (docs/adr/pipelines, 2 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/dora-explains.md][9], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the file cites it at line 47
  (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the ADR's own file.

### pipelines (2 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/extends/cd-customer.yaml][10], in the cell pipelines × pipeline-yaml: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  3 (header).
- [pipelines/steps/invoke-automation.yaml][11], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 18 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][12], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 119 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 237 (text).

### Languages (automation/Catzc.Base.Languages, 1 lit file)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/configs/languages.yml][14], in the cell automation × yaml: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 35 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text); selected
  by [ADR-PIPE-NAME][2]: the file cites it at line 221 (text).

### docs (docs/ outside docs/adr/, 1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][16], in the cell docs × markdown: selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 16 (text).

## Keywords

- [world map][17]
- [track][18]
- [file language][19]
- [cell][20]
- [lit cell][21]
- [.claude][22]: a track
- [automation][22]: a track
- [docs][22]: a track
- [pipelines][22]: a track
- [markdown][14]: a file language
- [pipeline-yaml][14]: a file language
- [powershell][14]: a file language
- [yaml][14]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[4]: ../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[5]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[6]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[7]: ../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[8]: ../../adr/flow/dora-explains.md
[9]: ../../adr/pipelines/dora-explains.md
[10]: ../../../pipelines/extends/cd-customer.yaml
[11]: ../../../pipelines/steps/invoke-automation.yaml
[12]: ../../../.claude/CLAUDE.md
[13]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[15]: ../../adr/index.md
[16]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[17]: ../../adr/glossary.md#world-map
[18]: ../../adr/glossary.md#track
[19]: ../../adr/glossary.md#file-language
[20]: ../../adr/glossary.md#cell
[21]: ../../adr/glossary.md#lit-cell
[22]: ../../../automation/Catzc.Base.Variants/configs/variants.yml

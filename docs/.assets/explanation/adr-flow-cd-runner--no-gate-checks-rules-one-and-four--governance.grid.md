# docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md

`Grid minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Grid minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.png)

The grid minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 5 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- .claude × markdown: 1 lit of 9 files
- automation × powershell: 3 lit of 1398 files
- automation × yaml: 4 lit of 95 files
- docs × markdown: 23 lit of 469 files
- pipelines × pipeline-yaml: 2 lit of 9 files

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][7]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 4 (header), line 7
  (header), line 14 (header), line 17 (header), line 21 (header), line 24 (header), line 26 (header), line 31 (header), line 96 (text), line
  100 (body comment), line 103 (text), line 109 (body comment), line 113 (text), line 118 (body comment), line 121 (text), line 124 (text),
  line 127 (body comment), line 130 (text), line 132 (body comment), line 135 (text), line 140 (body comment) and line 144 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][8]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][9]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 49 (text),
  line 50 (text), line 59 (text), line 62 (text), line 66 (text), line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 84
  (text), line 86 (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 104 (text), line 107 (text), line 118 (text)
  and line 123 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][10]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 119 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 237 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][11]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 35 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][12]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][13]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 8 (header).

### docs × markdown (23 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md][14]: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 65 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md][15]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62 (text) and line 71 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line
  62 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md][16]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md][17]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md][18]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 70 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][19]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/dora-explains.md][20]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/durable-sha-globs.md][21]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-detection.md][22]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/pipeline-types.md][23]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][24]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 221 (text).
- [docs/adr/pipelines/custom-template-discipline.md][25]: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR domain, the ADR
  domain of that code.
- [docs/adr/pipelines/dora-explains.md][26]: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR domain, the ADR domain of
  that code.
- [docs/adr/pipelines/dual-authentication.md][27]: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR domain, the ADR domain
  of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR domain, the
  ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][28]: selected by [ADR-PIPE-NAME][2]: an ADR file of the `pipelines` ADR domain, the ADR domain
  of that code.
- [docs/explanation/flow/a-step-only-names-a-command.md][29]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 14 (text), line
  41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][30]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 16
  (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text); selected by [ADR-PIPE-NAME][2]: the file cites it at line 12
  (text), line 39 (text), line 40 (text) and line 55 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][31]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 15 (text), line
  47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][32]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 16
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][33]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 17 (text),
  line 57 (text), line 58 (text) and line 59 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][34]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 16 (text).

### pipelines × pipeline-yaml (2 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/extends/cd-customer.yaml][35]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 3 (header).
- [pipelines/steps/invoke-automation.yaml][36]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 18 (header).

## Keywords

- [world map][37]
- [track][38]
- [file language][39]
- [cell][40]
- [lit cell][41]
- [.claude][42]: a track
- [automation][42]: a track
- [docs][42]: a track
- [pipelines][42]: a track
- [markdown][11]: a file language
- [pipeline-yaml][11]: a file language
- [powershell][11]: a file language
- [yaml][11]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[8]: ../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[9]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[10]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[12]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[13]: ../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[14]: adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md
[15]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md
[16]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md
[17]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md
[18]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md
[19]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[20]: ../../adr/flow/dora-explains.md
[21]: ../../adr/flow/durable-sha-globs.md
[22]: ../../adr/flow/pipeline-detection.md
[23]: ../../adr/flow/pipeline-types.md
[24]: ../../adr/index.md
[25]: ../../adr/pipelines/custom-template-discipline.md
[26]: ../../adr/pipelines/dora-explains.md
[27]: ../../adr/pipelines/dual-authentication.md
[28]: ../../adr/pipelines/pipeline-variables.md
[29]: ../../explanation/flow/a-step-only-names-a-command.md
[30]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[31]: ../../explanation/flow/the-runner-is-the-only-seam.md
[32]: ../../explanation/flow/the-step-is-named-after-its-command.md
[33]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[34]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[35]: ../../../pipelines/extends/cd-customer.yaml
[36]: ../../../pipelines/steps/invoke-automation.yaml
[37]: ../../adr/glossary.md#world-map
[38]: ../../adr/glossary.md#track
[39]: ../../adr/glossary.md#file-language
[40]: ../../adr/glossary.md#cell
[41]: ../../adr/glossary.md#lit-cell
[42]: ../../../automation/Catzc.Base.Variants/configs/variants.yml

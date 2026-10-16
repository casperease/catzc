# docs/.assets/explanation/grid/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md

`Grid minimap: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance`

![Grid minimap of adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.png)

The grid minimap of the slide `adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance` (governance lens). The slide supports
[ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 51 files
- .unordered × markdown: 5 lit of 20 files
- automation × powershell: 3 lit of 1563 files
- automation × yaml: 3 lit of 107 files
- docs × markdown: 10 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 51 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][7]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 258 (text).
- [.claude/plans/prompt-adr-links-and-plans-continue.md][8]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 52 (text) and line 52
  (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 109 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][10]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 13 (text), line 254
  (text) and line 277 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][11]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 55 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][12]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 95 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][13]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 79 (text) and line
  106 (text).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][14]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 22 (header), line 27
  (header), line 34 (header), line 37 (header), line 41 (header), line 44 (header), line 46 (header), line 51 (header), line 114 (text),
  line 119 (text), line 126 (text), line 131 (text), line 134 (text), line 138 (text), line 141 (text) and line 148 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][15]: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  20 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][16]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 20 (header),
  line 71 (text), line 72 (text), line 81 (text), line 84 (text), line 88 (text), line 96 (text), line 98 (text), line 101 (text), line 103
  (text), line 106 (text), line 108 (text), line 111 (text), line 113 (text), line 116 (text), line 118 (text), line 126 (text), line 129
  (text), line 140 (text) and line 145 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 115 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 237 (text).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][18]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][19]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 8 (header).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/dora-explains.md][20]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][21]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 125 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 242 (text).
- [docs/adr/pipelines/dora-explains.md][22]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 73 (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: the ADR's own file.
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][23]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 33 (text).
- [docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md][24]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 16
  (text), line 29 (text), line 39 (text), line 49 (text), line 58 (text), line 67 (text) and line 76 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][25]: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  18 (text) and line 67 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][26]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][27]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 43 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][28]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 115 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 22
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 27 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 34
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 37 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 41
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 44 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 46
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 114
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 119 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 126
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 131 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 134
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 138 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 141
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 148 (text),
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

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [.claude][34]: a track
- [.unordered][34]: a track
- [automation][34]: a track
- [docs][34]: a track
- [pipelines][34]: a track
- [markdown][35]: a file language
- [pipeline-yaml][35]: a file language
- [powershell][35]: a file language
- [yaml][35]: a file language

[1]: ../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[8]: ../../../../.claude/plans/prompt-adr-links-and-plans-continue.md
[9]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[10]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[11]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[12]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[13]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[14]: ../../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[15]: ../../../../automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
[16]: ../../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[17]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[19]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[20]: ../../../adr/flow/dora-explains.md
[21]: ../../../adr/index.md
[22]: ../../../adr/pipelines/dora-explains.md
[23]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[24]: ../../../references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
[25]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[26]: ../../../references/pipelines/extends/cd-customer.yaml.md
[27]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[28]: ../../../../pipelines/ci-automation.yaml
[29]: ../../../adr/glossary.md#world-map
[30]: ../../../adr/glossary.md#track
[31]: ../../../adr/glossary.md#file-language
[32]: ../../../adr/glossary.md#cell
[33]: ../../../adr/glossary.md#lit-cell
[34]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[35]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

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

- .claude × markdown: 3 lit of 71 files
- .unordered × markdown: 5 lit of 20 files
- automation × powershell: 3 lit of 1579 files
- automation × yaml: 3 lit of 109 files
- docs × markdown: 10 lit of 2165 files
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
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][7]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 299 (text).
- [.claude/plans/prompt-adr-links-and-plans-continue.md][8]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 19 (text), line 75
  (text) and line 75 (text).

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

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][14]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 23 (header), line 28
  (header), line 35 (header), line 38 (header), line 42 (header), line 45 (header), line 47 (header), line 52 (header), line 115 (text),
  line 120 (text), line 127 (text), line 132 (text), line 135 (text), line 139 (text), line 142 (text) and line 149 (text).
- [automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1][15]: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  21 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][16]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 21 (header),
  line 72 (text), line 73 (text), line 82 (text), line 85 (text), line 89 (text), line 97 (text), line 99 (text), line 102 (text), line 104
  (text), line 107 (text), line 109 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 127 (text), line 130
  (text), line 141 (text) and line 146 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 116 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 239 (text).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][18]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][19]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 8 (header).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/dora-explains.md][20]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 63 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][21]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 128 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 246 (text).
- [docs/adr/pipelines/dora-explains.md][22]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 74 (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: the ADR's own file.
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][23]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 34 (text).
- [docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md][24]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 17
  (text), line 30 (text), line 40 (text), line 50 (text), line 59 (text), line 68 (text) and line 77 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][25]: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  19 (text) and line 68 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][26]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 32 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][27]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 44 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][28]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 23
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 28 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 35
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 38 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 42
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 45 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 47
  (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 52 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 115
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 120 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 127
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 132 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 135
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 139 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 142
  (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 149 (text),
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
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 146 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 239
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

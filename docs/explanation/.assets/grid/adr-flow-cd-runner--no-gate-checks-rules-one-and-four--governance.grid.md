# No gate checks the runner rules 1 or 4, and the step template breaks rule 3: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 21 files.
```

![The world-map minimap of No gate checks the runner rules 1 or 4, and the step template breaks rule 3](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [No gate checks the runner rules 1 or 4, and the step template
breaks rule 3][25], which explains [ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 4 lit of 90 files
- automation × powershell: 2 lit of 1629 files
- automation × yaml: 3 lit of 112 files
- docs × markdown: 11 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (4 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][7]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 279 (text).
- [.claude/plans/prompt-adr-links-and-plans-continue.md][8]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 53 (text) and line 53
  (text).
- [.claude/plans/task-adr-link-cleanup.md][9]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 54 (text) and line 54 (text).

### automation × powershell (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][10]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 51 (text), line 56
  (text), line 63 (text), line 68 (text), line 71 (text), line 75 (text), line 78 (text) and line 85 (text).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][11]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 47 (text),
  line 48 (text), line 57 (text), line 60 (text), line 64 (text), line 72 (text), line 74 (text), line 77 (text), line 79 (text), line 82
  (text), line 84 (text), line 87 (text), line 89 (text), line 92 (text), line 94 (text), line 102 (text), line 105 (text), line 116 (text)
  and line 121 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][12]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 98 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 225 (text).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][13]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][14]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 8 (header).

### docs × markdown (11 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/dora-explains.md][15]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][16]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 130 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 252 (text).
- [docs/adr/pipelines/dora-explains.md][17]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45 (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: the ADR's own file.
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][18]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md][19]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 15
  (text), line 22 (text), line 25 (text), line 29 (text), line 32 (text), line 34 (text), line 40 (text), line 76 (text), line 86 (text),
  line 96 (text), line 105 (text), line 114 (text) and line 123 (text).
- [docs/references/automation/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md][20]: selected by [ADR-PIPE-NAME][2]: the file
  cites it at line 23 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][21]: selected by [ADR-PIPE-NAME][2]: the file cites it at line
  45 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][22]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][23]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][24]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 98 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 56 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 63 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 68 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 71 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 75 (text), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 78 (text),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 85 (text), `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 47
  (text), `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 48 (text),
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

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [.claude][31]: a track
- [automation][31]: a track
- [docs][31]: a track
- [pipelines][31]: a track
- [markdown][32]: a file language
- [pipeline-yaml][32]: a file language
- [powershell][32]: a file language
- [yaml][32]: a file language

[1]: ../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[8]: ../../../../.claude/plans/prompt-adr-links-and-plans-continue.md
[9]: ../../../../.claude/plans/task-adr-link-cleanup.md
[10]: ../../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[11]: ../../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[12]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[13]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[14]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[15]: ../../../adr/flow/dora-explains.md
[16]: ../../../adr/index.md
[17]: ../../../adr/pipelines/dora-explains.md
[18]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[19]: ../../../references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
[20]: ../../../references/automation/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md
[21]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[22]: ../../../references/pipelines/extends/cd-customer.yaml.md
[23]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[24]: ../../../../pipelines/ci-automation.yaml
[25]: ../../flow/no-gate-checks-rules-one-and-four.md
[26]: ../../../adr/glossary.md#world-map
[27]: ../../../adr/glossary.md#track
[28]: ../../../adr/glossary.md#file-language
[29]: ../../../adr/glossary.md#cell
[30]: ../../../adr/glossary.md#lit-cell
[31]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[32]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

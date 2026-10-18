---
catzc:
  immutable:
    with_body_sha: "93639756f7cc"
    repo_status: locked
    path: docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four/grid.md
    source: docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# No gate checks the runner rules 1 or 4, and the step template breaks rule 3: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 19 files.
```

![The world-map minimap of No gate checks the runner rules 1 or 4, and the step template breaks rule 3](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [No gate checks the runner rules 1 or 4, and the step template
breaks rule 3][23], which explains [ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 89 files
- docs × markdown: 11 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 2 lit of 1651 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).
- [.claude/plans/plan-adr-code-language.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 126 (text).

### docs × markdown (11 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/dora-explains.md][8]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 130 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 252 (text).
- [docs/adr/pipelines/dora-explains.md][10]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45 (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: the ADR's own file.
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][11]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 14 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][12]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][13]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md][14]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 15 (text),
  line 22 (text), line 25 (text), line 29 (text), line 32 (text), line 34 (text), line 40 (text), line 76 (text), line 86 (text), line 96
  (text), line 105 (text), line 114 (text) and line 123 (text).
- [docs/references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md][15]: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 23 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][16]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][17]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 56 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 63 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 68 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 71 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 75 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 78 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 85 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 48 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 57
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 60 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 64 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 72 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 74 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 77
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 79 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 82 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 84 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 87 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 89
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 92 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 94 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 102 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 105 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line
  116 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 121 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 225
  (text), `pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 9 (header) and
  `pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml` line 8 (header).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1][18]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 51 (text), line 56 (text),
  line 63 (text), line 68 (text), line 71 (text), line 75 (text), line 78 (text) and line 85 (text).
- [pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][19]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 47 (text), line 48
  (text), line 57 (text), line 60 (text), line 64 (text), line 72 (text), line 74 (text), line 77 (text), line 79 (text), line 82 (text),
  line 84 (text), line 87 (text), line 89 (text), line 92 (text), line 94 (text), line 102 (text), line 105 (text), line 116 (text) and line
  121 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][20]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 98 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 225 (text).
- [pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][21]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 9 (header).
- [pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][22]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 8 (header).

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [.claude][29]: a track
- [docs][29]: a track
- [pipelines][29]: a track
- [pwsh][29]: a track
- [markdown][30]: a file language
- [pipeline-yaml][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/CLAUDE.md
[7]: ../../../../../.claude/plans/plan-adr-code-language.md
[8]: ../../../../adr/flow/dora-explains.md
[9]: ../../../../adr/index.md
[10]: ../../../../adr/pipelines/dora-explains.md
[11]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[12]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[13]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[14]: ../../../../references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md
[16]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[17]: ../../../../../pipelines/ci-automation.yaml
[18]: ../../../../../pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1
[19]: ../../../../../pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[20]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[22]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[23]: ../../no-gate-checks-rules-one-and-four.md
[24]: ../../../../adr/glossary.md#world-map
[25]: ../../../../adr/glossary.md#track
[26]: ../../../../adr/glossary.md#file-language
[27]: ../../../../adr/glossary.md#cell
[28]: ../../../../adr/glossary.md#lit-cell
[29]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

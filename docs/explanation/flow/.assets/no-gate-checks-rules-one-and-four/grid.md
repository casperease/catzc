---
catzc:
  immutable:
    with_body_sha: bba443b91b4a
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
5 of 342 cells lit, holding 15 files.
```

![The world-map minimap of No gate checks the runner rules 1 or 4, and the step template breaks rule 3](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [No gate checks the runner rules 1 or 4, and the step template
breaks rule 3][17], which explains [ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 89 files
- docs × markdown: 9 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 2 lit of 1651 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).
- [.claude/plans/plan-adr-code-language.md][5]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 126 (text).

### docs × markdown (9 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/flow/dora-explains.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 132 (text); selected by [ADR-PIPE-NAME][2]: the
  file cites it at line 254 (text).
- [docs/adr/pipelines/dora-explains.md][8]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45 (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: the ADR's own file.
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][9]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 14 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][10]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][11]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md][12]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][13]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 116 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line
  121 (text) and `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 225 (text).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1][14]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 51 (text).
- [pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][15]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 116 (text) and
  line 121 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 98 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 225 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [.claude][23]: a track
- [docs][23]: a track
- [pipelines][23]: a track
- [pwsh][23]: a track
- [markdown][24]: a file language
- [pipeline-yaml][24]: a file language
- [powershell][24]: a file language
- [yaml][24]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/plan-adr-code-language.md
[6]: ../../../../adr/flow/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../adr/pipelines/dora-explains.md
[9]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[10]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[11]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[12]: ../../../../references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md
[13]: ../../../../../pipelines/ci-automation.yaml
[14]: ../../../../../pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1
[15]: ../../../../../pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[16]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../no-gate-checks-rules-one-and-four.md
[18]: ../../../../adr/glossary.md#world-map
[19]: ../../../../adr/glossary.md#track
[20]: ../../../../adr/glossary.md#file-language
[21]: ../../../../adr/glossary.md#cell
[22]: ../../../../adr/glossary.md#lit-cell
[23]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

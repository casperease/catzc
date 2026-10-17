# docs/explanation/.assets/grid/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md

`Grid minimap: adr-dsgn-life--every-deploy-stage-is-main-only--implementation`

![Grid minimap of adr-dsgn-life--every-deploy-stage-is-main-only--implementation](adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.png)

The grid minimap of the slide `adr-dsgn-life--every-deploy-stage-is-main-only--implementation` (implementation lens). The slide supports
[ADR-DSGN-LIFE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .unordered × markdown: 3 lit of 20 files
- automation × powershell: 1 lit of 1579 files
- automation × yaml: 2 lit of 109 files
- docs × markdown: 4 lit of 2165 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .unordered × markdown (3 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 100 (text), line 183 (text)
  and line 268 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 91 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text), line 86 (text),
  line 86 (text), line 97 (text), line 99 (text), line 101 (text) and line 101 (text).

### automation × powershell (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Git/Push-Dirty.ps1][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 21 (header) and line 26 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 96 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 69 (text).

### docs × markdown (4 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 122 (text).
- [docs/adr/glossary.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 218 (text).
- [docs/adr/index.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 110 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][14]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 96 (text), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 21
  (header), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 26 (header) and `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  69 (text).

## Keywords

- [world map][15]
- [track][16]
- [file language][17]
- [cell][18]
- [lit cell][19]
- [.unordered][20]: a track
- [automation][20]: a track
- [docs][20]: a track
- [pipelines][20]: a track
- [markdown][21]: a file language
- [pipeline-yaml][21]: a file language
- [powershell][21]: a file language
- [yaml][21]: a file language

Terms the cited ADRs define:

- [occupant][22], defined by [ADR-DSGN-LIFE#5][23]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[6]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[7]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[8]: ../../../../automation/Catzc.Base.Git/Push-Dirty.ps1
[9]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[11]: ../../../adr/design/dora-explains.md
[12]: ../../../adr/glossary.md
[13]: ../../../adr/index.md
[14]: ../../../../pipelines/ci-automation.yaml
[15]: ../../../adr/glossary.md#world-map
[16]: ../../../adr/glossary.md#track
[17]: ../../../adr/glossary.md#file-language
[18]: ../../../adr/glossary.md#cell
[19]: ../../../adr/glossary.md#lit-cell
[20]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[21]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[22]: ../../../adr/glossary.md#occupant
[23]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

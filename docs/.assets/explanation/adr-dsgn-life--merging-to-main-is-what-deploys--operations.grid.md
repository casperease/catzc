# docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md

`Grid minimap: adr-dsgn-life--merging-to-main-is-what-deploys--operations`

![Grid minimap of adr-dsgn-life--merging-to-main-is-what-deploys--operations](adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.png)

The grid minimap of the slide `adr-dsgn-life--merging-to-main-is-what-deploys--operations` (operations lens). The slide supports
[ADR-DSGN-LIFE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .unordered × markdown: 3 lit of 20 files
- automation × yaml: 2 lit of 107 files
- docs × markdown: 4 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
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

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 95 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).

### docs × markdown (4 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 121 (text).
- [docs/adr/glossary.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 201 (text).
- [docs/adr/index.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 107 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][13]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 95 (text) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 68 (text).

## Keywords

- [world map][14]
- [track][15]
- [file language][16]
- [cell][17]
- [lit cell][18]
- [.unordered][19]: a track
- [automation][19]: a track
- [docs][19]: a track
- [pipelines][19]: a track
- [markdown][20]: a file language
- [pipeline-yaml][20]: a file language
- [yaml][20]: a file language

Terms the cited ADRs define:

- [occupant][21], defined by [ADR-DSGN-LIFE#5][22]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.unordered/15-10-2026/plan-adr-consistency.md
[6]: ../../../.unordered/15-10-2026/plan-concern-axis.md
[7]: ../../../.unordered/15-10-2026/plan-explanation-drift.md
[8]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[10]: ../../adr/design/dora-explains.md
[11]: ../../adr/glossary.md
[12]: ../../adr/index.md
[13]: ../../../pipelines/ci-automation.yaml
[14]: ../../adr/glossary.md#world-map
[15]: ../../adr/glossary.md#track
[16]: ../../adr/glossary.md#file-language
[17]: ../../adr/glossary.md#cell
[18]: ../../adr/glossary.md#lit-cell
[19]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[20]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[21]: ../../adr/glossary.md#occupant
[22]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

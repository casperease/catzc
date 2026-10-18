# Sync from the last certified commit, not from the tip of main: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE sit in the repository: tracks down, file languages across.
5 of 324 cells lit, holding 10 files.
```

![The world-map minimap of Sync from the last certified commit, not from the tip of main](adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [Sync from the last certified commit, not from the tip of main][14],
which explains [ADR-DSGN-LIFE][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the
decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 91 files
- automation × powershell: 1 lit of 1619 files
- automation × yaml: 2 lit of 112 files
- docs × markdown: 4 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-fast-push-followups.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 26 (text) and line 47 (text).
- [.claude/plans/value-of-plan.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 22 (text) and line 63 (text).

### automation × powershell (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Git/Push-Dirty.ps1][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 21 (header) and line 26 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 97 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).

### docs × markdown (4 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 121 (text).
- [docs/adr/glossary.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text).
- [docs/adr/index.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][13]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 21
  (header), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 26 (header) and `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  68 (text).

## Keywords

- [world map][15]
- [track][16]
- [file language][17]
- [cell][18]
- [lit cell][19]
- [.claude][20]: a track
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
[5]: ../../../../.claude/plans/plan-fast-push-followups.md
[6]: ../../../../.claude/plans/value-of-plan.md
[7]: ../../../../automation/Catzc.Base.Git/Push-Dirty.ps1
[8]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[10]: ../../../adr/design/dora-explains.md
[11]: ../../../adr/glossary.md
[12]: ../../../adr/index.md
[13]: ../../../../pipelines/ci-automation.yaml
[14]: ../../design/sync-from-the-last-certified-commit.md
[15]: ../../../adr/glossary.md#world-map
[16]: ../../../adr/glossary.md#track
[17]: ../../../adr/glossary.md#file-language
[18]: ../../../adr/glossary.md#cell
[19]: ../../../adr/glossary.md#lit-cell
[20]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[21]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[22]: ../../../adr/glossary.md#occupant
[23]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

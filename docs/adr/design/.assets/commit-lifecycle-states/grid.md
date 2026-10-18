---
catzc:
  immutable:
    with_body_sha: d70a8918c506
    repo_status: locked
    path: docs/adr/design/.assets/commit-lifecycle-states/grid.md
    source: docs/adr/design/.assets/commit-lifecycle-states/diagram.drawio.png
    role: adr
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# ADR: The commit lifecycle — states, environment occupancy, and the stable sync point: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 17 files.
```

![The world-map minimap of ADR: The commit lifecycle — states, environment occupancy, and the stable sync point](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [ADR: The commit lifecycle — states, environment occupancy, and
the stable sync point][1], which explains [ADR-DSGN-LIFE][1]. It lights every cell of the world map that holds a file citing those codes, so
it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 57 files
- docs × markdown: 11 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-promotion-ladder.md][3]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text) and line 38 (text).
- [.claude/plans/value-of-plan.md][4]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 33 (text).

### docs × markdown (11 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/design/.assets/commit-lifecycle-states/chain.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line
  25 (text), line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/grid.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25
  (text), line 55 (text), line 56 (text), line 57 (text), line 64 (text), line 66 (text), line 70 (text), line 74 (text), line 76 (text),
  line 80 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 88 (text), line 95 (text), line 104 (text), line 105
  (text) and line 106 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/tree.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25
  (text), line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text), line 69 (text),
  line 75 (text), line 77 (text), line 79 (text), line 85 (text), line 87 (text), line 93 (text), line 94 (text), line 101 (text), line 108
  (text) and line 116 (text).
- [docs/adr/design/.assets/sync-point/chain.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/sync-point/grid.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text), line
  55 (text), line 56 (text), line 57 (text), line 64 (text), line 66 (text), line 70 (text), line 74 (text), line 76 (text), line 80 (text),
  line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 88 (text), line 95 (text), line 104 (text), line 105 (text) and line
  106 (text).
- [docs/adr/design/.assets/sync-point/tree.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text), line 69 (text), line 75
  (text), line 77 (text), line 79 (text), line 85 (text), line 87 (text), line 93 (text), line 94 (text), line 101 (text), line 108 (text)
  and line 116 (text).
- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).
- [docs/adr/glossary.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 273 (text) and line 347 (text).
- [docs/adr/index.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][15]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][17]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][18]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text).

## Keywords

- [world map][19]
- [track][20]
- [file language][21]
- [cell][22]
- [lit cell][23]
- [.claude][24]: a track
- [docs][24]: a track
- [pipelines][24]: a track
- [pwsh][24]: a track
- [markdown][25]: a file language
- [pipeline-yaml][25]: a file language
- [yaml][25]: a file language

[1]: ../../commit-lifecycle.md
[2]: ../../tracks.md
[3]: ../../../../../.claude/plans/plan-promotion-ladder.md
[4]: ../../../../../.claude/plans/value-of-plan.md
[5]: chain.md
[6]: grid.md
[7]: tree.md
[8]: ../sync-point/chain.md
[9]: ../sync-point/grid.md
[10]: ../sync-point/tree.md
[11]: ../../dora-explains.md
[12]: ../../../glossary.md
[13]: ../../../index.md
[14]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[15]: ../../../../../pipelines/ci-automation.yaml
[16]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[18]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[19]: ../../../glossary.md#world-map
[20]: ../../../glossary.md#track
[21]: ../../../glossary.md#file-language
[22]: ../../../glossary.md#cell
[23]: ../../../glossary.md#lit-cell
[24]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[25]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

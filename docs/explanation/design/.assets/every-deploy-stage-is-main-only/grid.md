---
catzc:
  immutable:
    with_body_sha: a4dc96b9a213
    repo_status: locked
    path: docs/explanation/design/.assets/every-deploy-stage-is-main-only/grid.md
    source: docs/explanation/design/.assets/every-deploy-stage-is-main-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every Deploy stage in cats runs only from main, so no topic commit is deployed: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 17 files.
```

![The world-map minimap of Every Deploy stage in cats runs only from main, so no topic commit is deployed](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Every Deploy stage in cats runs only from main, so no topic
commit is deployed][19], which explains [ADR-DSGN-LIFE][1]. It lights every cell of the world map that holds a file citing those codes, so
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
  (text), line 55 (text), line 56 (text), line 63 (text), line 65 (text), line 69 (text), line 73 (text), line 75 (text), line 79 (text),
  line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 94 (text), line 103 (text), line 104 (text) and line
  105 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/tree.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25
  (text), line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text), line 69 (text),
  line 75 (text), line 77 (text), line 83 (text), line 85 (text), line 91 (text), line 92 (text), line 99 (text), line 106 (text) and line
  114 (text).
- [docs/adr/design/.assets/sync-point/chain.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/sync-point/grid.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text), line
  55 (text), line 56 (text), line 63 (text), line 65 (text), line 69 (text), line 73 (text), line 75 (text), line 79 (text), line 83 (text),
  line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 94 (text), line 103 (text), line 104 (text) and line 105 (text).
- [docs/adr/design/.assets/sync-point/tree.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text), line 69 (text), line 75
  (text), line 77 (text), line 83 (text), line 85 (text), line 91 (text), line 92 (text), line 99 (text), line 106 (text) and line 114
  (text).
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

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [pwsh][25]: a track
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [yaml][26]: a file language

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-promotion-ladder.md
[4]: ../../../../../.claude/plans/value-of-plan.md
[5]: ../../../../adr/design/.assets/commit-lifecycle-states/chain.md
[6]: ../../../../adr/design/.assets/commit-lifecycle-states/grid.md
[7]: ../../../../adr/design/.assets/commit-lifecycle-states/tree.md
[8]: ../../../../adr/design/.assets/sync-point/chain.md
[9]: ../../../../adr/design/.assets/sync-point/grid.md
[10]: ../../../../adr/design/.assets/sync-point/tree.md
[11]: ../../../../adr/design/dora-explains.md
[12]: ../../../../adr/glossary.md
[13]: ../../../../adr/index.md
[14]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[15]: ../../../../../pipelines/ci-automation.yaml
[16]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[18]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[19]: ../../every-deploy-stage-is-main-only.md
[20]: ../../../../adr/glossary.md#world-map
[21]: ../../../../adr/glossary.md#track
[22]: ../../../../adr/glossary.md#file-language
[23]: ../../../../adr/glossary.md#cell
[24]: ../../../../adr/glossary.md#lit-cell
[25]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

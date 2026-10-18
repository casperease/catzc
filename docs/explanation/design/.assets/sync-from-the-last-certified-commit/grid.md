---
catzc:
  immutable:
    with_body_sha: bab66429f1cd
    repo_status: locked
    path: docs/explanation/design/.assets/sync-from-the-last-certified-commit/grid.md
    source: docs/explanation/design/.assets/sync-from-the-last-certified-commit/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Sync from the last certified commit, not from the tip of main: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 14 files.
```

![The world-map minimap of Sync from the last certified commit, not from the tip of main](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [Sync from the last certified commit, not from the tip of main][16],
which explains [ADR-DSGN-LIFE][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the
decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 89 files
- docs × markdown: 5 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-fast-push-followups.md][3]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][4]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text), line 34 (text) and line
  94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 35 (text), line 42 (text) and line 42
  (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).
- [docs/adr/glossary.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line 346 (text).
- [docs/adr/index.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][12]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text).

## Keywords

- [world map][17]
- [track][18]
- [file language][19]
- [cell][20]
- [lit cell][21]
- [.claude][22]: a track
- [docs][22]: a track
- [pipelines][22]: a track
- [pwsh][22]: a track
- [markdown][23]: a file language
- [pipeline-yaml][23]: a file language
- [yaml][23]: a file language

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-fast-push-followups.md
[4]: ../../../../../.claude/plans/plan-promotion-ladder.md
[5]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[6]: ../../../../../.claude/plans/task-loose-ends.md
[7]: ../../../../../.claude/plans/value-of-plan.md
[8]: ../../../../adr/design/dora-explains.md
[9]: ../../../../adr/glossary.md
[10]: ../../../../adr/index.md
[11]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[12]: ../../../../../pipelines/ci-automation.yaml
[13]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[15]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[16]: ../../sync-from-the-last-certified-commit.md
[17]: ../../../../adr/glossary.md#world-map
[18]: ../../../../adr/glossary.md#track
[19]: ../../../../adr/glossary.md#file-language
[20]: ../../../../adr/glossary.md#cell
[21]: ../../../../adr/glossary.md#lit-cell
[22]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[23]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

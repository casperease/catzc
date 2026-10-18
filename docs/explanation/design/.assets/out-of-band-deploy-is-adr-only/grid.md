---
catzc:
  immutable:
    with_body_sha: "3bfee451514c"
    repo_status: locked
    path: docs/explanation/design/.assets/out-of-band-deploy-is-adr-only/grid.md
    source: docs/explanation/design/.assets/out-of-band-deploy-is-adr-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# No gate checks the out-of-band deploy rule, and the only gate on deploys in code is main-only: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE and ADR-DSGN-VISUAL sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 17 files.
```

![The world-map minimap of No gate checks the out-of-band deploy rule, and the only gate on deploys in code is main-only](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [No gate checks the out-of-band deploy rule, and the only gate on
deploys in code is main-only][19], which explains [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]. It lights every cell of the world map that
holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code
that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 89 files
- docs × markdown: 6 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/plan-fast-push-followups.md][4]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text), line 34 (text) and line
  94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 35 (text), line 42 (text) and line 42
  (text).

### docs × markdown (6 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).
- [docs/adr/design/visual-design.md][2]: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.
- [docs/adr/glossary.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line 346 (text).
- [docs/adr/index.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 111 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][13]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text); selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 77 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 34 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 39 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 67 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 72 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (text) and
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 82 (text).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 77 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][15]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 28 (text), line 28 (text), line
  34 (text) and line 39 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][16]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 67 (text), line 72
  (text), line 77 (text), line 77 (text) and line 82 (text).
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
[2]: ../../../../adr/design/visual-design.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/plan-fast-push-followups.md
[5]: ../../../../../.claude/plans/plan-promotion-ladder.md
[6]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[7]: ../../../../../.claude/plans/task-loose-ends.md
[8]: ../../../../../.claude/plans/value-of-plan.md
[9]: ../../../../adr/design/dora-explains.md
[10]: ../../../../adr/glossary.md
[11]: ../../../../adr/index.md
[12]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[13]: ../../../../../pipelines/ci-automation.yaml
[14]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[16]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[17]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[18]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[19]: ../../out-of-band-deploy-is-adr-only.md
[20]: ../../../../adr/glossary.md#world-map
[21]: ../../../../adr/glossary.md#track
[22]: ../../../../adr/glossary.md#file-language
[23]: ../../../../adr/glossary.md#cell
[24]: ../../../../adr/glossary.md#lit-cell
[25]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

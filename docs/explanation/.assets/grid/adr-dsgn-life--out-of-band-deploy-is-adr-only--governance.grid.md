---
catzc:
  immutable:
    with_body_sha: "25bdc7aa8e5a"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
    source: docs/explanation/.assets/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# No gate checks the out-of-band deploy rule, and the only gate on deploys in code is main-only: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE and ADR-DSGN-VISUAL sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 13 files.
```

![The world-map minimap of No gate checks the out-of-band deploy rule, and the only gate on deploys in code is main-only](adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [No gate checks the out-of-band deploy rule, and the only gate on
deploys in code is main-only][17], which explains [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]. It lights every cell of the world map that
holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code
that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 90 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 6 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-fast-push-followups.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text) and line 37 (text).
- [.claude/plans/value-of-plan.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 44 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 77 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][9]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 28 (text), line 28 (body
  comment), line 34 (text) and line 39 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][10]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 67 (text), line 72
  (text), line 77 (text), line 77 (body comment) and line 82 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text).

### docs × markdown (6 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).
- [docs/adr/design/visual-design.md][2]: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.
- [docs/adr/glossary.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text).
- [docs/adr/index.md][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 111 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][16]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text) and `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49
  (text); selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 77 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 34 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 39 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 67 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 72 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (body comment) and `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 82 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [.claude][23]: a track
- [automation][23]: a track
- [docs][23]: a track
- [pipelines][23]: a track
- [markdown][24]: a file language
- [pipeline-yaml][24]: a file language
- [yaml][24]: a file language

Terms the cited ADRs define:

- [occupant][25], defined by [ADR-DSGN-LIFE#5][26]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/visual-design.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-fast-push-followups.md
[7]: ../../../../.claude/plans/value-of-plan.md
[8]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[10]: ../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[11]: ../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[12]: ../../../adr/design/dora-explains.md
[13]: ../../../adr/glossary.md
[14]: ../../../adr/index.md
[15]: ../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[16]: ../../../../pipelines/ci-automation.yaml
[17]: ../../design/out-of-band-deploy-is-adr-only.md
[18]: ../../../adr/glossary.md#world-map
[19]: ../../../adr/glossary.md#track
[20]: ../../../adr/glossary.md#file-language
[21]: ../../../adr/glossary.md#cell
[22]: ../../../adr/glossary.md#lit-cell
[23]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[25]: ../../../adr/glossary.md#occupant
[26]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

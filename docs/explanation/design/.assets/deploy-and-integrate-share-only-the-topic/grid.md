---
catzc:
  immutable:
    with_body_sha: "3502be565925"
    repo_status: locked
    path: docs/explanation/design/.assets/deploy-and-integrate-share-only-the-topic/grid.md
    source: docs/explanation/design/.assets/deploy-and-integrate-share-only-the-topic/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Deploying a topic commit and integrating it share only the topic commit: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE and ADR-DSGN-VISUAL sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 17 files.
```

![The world-map minimap of Deploying a topic commit and integrating it share only the topic commit](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [Deploying a topic commit and integrating it share only the
topic commit][21], which explains [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 89 files
- docs × markdown: 6 lit of 2761 files
- pipelines × pipeline-yaml: 1 lit of 11 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-fast-push-followups.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text), line 34 (text) and line
  78 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 36 (text) and line 43 (text).

### docs × markdown (6 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).
- [docs/adr/design/visual-design.md][2]: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.
- [docs/adr/glossary.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line 345 (text).
- [docs/adr/index.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 111 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][15]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text); selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 77 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (body comment),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 34 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 39 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 67 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 72 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (body comment) and
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 82 (text).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 77 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][17]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 28 (text), line 28 (body
  comment), line 34 (text) and line 39 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][18]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 67 (text), line 72
  (text), line 77 (text), line 77 (body comment) and line 82 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][19]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][20]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [.claude][27]: a track
- [docs][27]: a track
- [pipelines][27]: a track
- [pwsh][27]: a track
- [markdown][28]: a file language
- [pipeline-yaml][28]: a file language
- [yaml][28]: a file language

Terms the cited ADRs define:

- [occupant][29], defined by [ADR-DSGN-LIFE#5][30]
- [staging slot][31], defined by [ADR-DSGN-LIFE#5][30]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/visual-design.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/plans/plan-fast-push-followups.md
[7]: ../../../../../.claude/plans/plan-promotion-ladder.md
[8]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[9]: ../../../../../.claude/plans/task-loose-ends.md
[10]: ../../../../../.claude/plans/value-of-plan.md
[11]: ../../../../adr/design/dora-explains.md
[12]: ../../../../adr/glossary.md
[13]: ../../../../adr/index.md
[14]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[15]: ../../../../../pipelines/ci-automation.yaml
[16]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[18]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[19]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[20]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[21]: ../../deploy-and-integrate-share-only-the-topic.md
[22]: ../../../../adr/glossary.md#world-map
[23]: ../../../../adr/glossary.md#track
[24]: ../../../../adr/glossary.md#file-language
[25]: ../../../../adr/glossary.md#cell
[26]: ../../../../adr/glossary.md#lit-cell
[27]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[29]: ../../../../adr/glossary.md#occupant
[30]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[31]: ../../../../adr/glossary.md#staging-slot

---
catzc:
  immutable:
    with_body_sha: f90e6bc89e2b
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
    source: docs/explanation/.assets/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Three tasks share one guard, and one runner imports, traps, sanitizes and invokes: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-RUNNER sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 7 files.
```

![The world-map minimap of Three tasks share one guard, and one runner imports, traps, sanitizes and invokes](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Three tasks share one guard, and one runner imports, traps,
sanitizes and invokes][11], which explains [ADR-FLOW-CD-RUNNER][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 90 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 4 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 98 (text).

### docs × markdown (4 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/dora-explains.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][8]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 130 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][10]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text).

## Keywords

- [world map][12]
- [track][13]
- [file language][14]
- [cell][15]
- [lit cell][16]
- [.claude][17]: a track
- [automation][17]: a track
- [docs][17]: a track
- [pipelines][17]: a track
- [markdown][18]: a file language
- [pipeline-yaml][18]: a file language
- [yaml][18]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../.claude/CLAUDE.md
[6]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../../adr/flow/dora-explains.md
[8]: ../../../../adr/index.md
[9]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[10]: ../../../../../pipelines/ci-automation.yaml
[11]: ../../three-tasks-one-guard-one-runner.md
[12]: ../../../../adr/glossary.md#world-map
[13]: ../../../../adr/glossary.md#track
[14]: ../../../../adr/glossary.md#file-language
[15]: ../../../../adr/glossary.md#cell
[16]: ../../../../adr/glossary.md#lit-cell
[17]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[18]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

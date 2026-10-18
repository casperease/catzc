---
catzc:
  immutable:
    with_body_sha: ab03e84b2f19
    repo_status: locked
    path: docs/explanation/automation/.assets/undeclared-edge-fails-with-one-line/grid.md
    source: docs/explanation/automation/.assets/undeclared-edge-fails-with-one-line/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# An undeclared module edge fails the gate with one line per issue: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEPM sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 11 files.
```

![The world-map minimap of An undeclared module edge fails the gate with one line per issue](grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [An undeclared module edge fails the gate with one line per
issue][15], which explains [ADR-AUTO-DEPM][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where
the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 8 lit of 2759 files
- pipelines × pipeline-yaml: 1 lit of 9 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-assert-wait.md][5]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 57 (text).

### docs × markdown (8 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/controlling-module-dependencies.md][1]: selected by [ADR-AUTO-DEPM][1]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][6]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 365 (text).
- [docs/adr/index.md][7]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 169 (text).
- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][8]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 47 (text), line 54 (text), line 54 (text), line 71 (text) and line 73 (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][9]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 110 (text) and line 114 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md][10]: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md][11]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md][12]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 13
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][13]: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 138 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 138 (text).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [.claude][21]: a track
- [docs][21]: a track
- [pipelines][21]: a track
- [pwsh][21]: a track
- [markdown][22]: a file language
- [pipeline-yaml][22]: a file language
- [yaml][22]: a file language

[1]: ../../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../.claude/plans/plan-assert-wait.md
[6]: ../../../../adr/automation/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[9]: ../../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[10]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[11]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md
[12]: ../../../../references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md
[13]: ../../../../../pipelines/ci-automation.yaml
[14]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../undeclared-edge-fails-with-one-line.md
[16]: ../../../../adr/glossary.md#world-map
[17]: ../../../../adr/glossary.md#track
[18]: ../../../../adr/glossary.md#file-language
[19]: ../../../../adr/glossary.md#cell
[20]: ../../../../adr/glossary.md#lit-cell
[21]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

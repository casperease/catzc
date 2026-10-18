---
catzc:
  immutable:
    with_body_sha: "207b94ae2bf9"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md
    source: docs/explanation/.assets/adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One declared allow-list says what may depend on what, and every edge points down: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEPM sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 15 files.
```

![The world-map minimap of One declared allow-list says what may depend on what, and every edge points down](adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [One declared allow-list says what may depend on what, and every edge
points down][19], which explains [ADR-AUTO-DEPM][1]. It lights every cell of the world map that holds a file citing those codes, so it shows
where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 90 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 8 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][5]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 157 (text).
- [.claude/plans/plan-assert-wait.md][6]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 62 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 207 (text), line 290 (text),
  line 294 (text), line 357 (text), line 363 (text), line 367 (text), line 386 (text), line 542 (text) and line 579 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][8]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][9]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 18 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][10]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 138 (text).

### docs × markdown (8 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/controlling-module-dependencies.md][1]: selected by [ADR-AUTO-DEPM][1]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][11]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 365 (text).
- [docs/adr/index.md][12]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 169 (text).
- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][13]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 47 (text), line 54 (text), line 54 (text), line 71 (text) and line 73 (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][14]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 110 (text) and line 114 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md][15]: selected by [ADR-AUTO-DEPM][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md][16]: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md][17]: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 13 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][18]: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 138 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [yaml][26]: a file language

[1]: ../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[6]: ../../../../.claude/plans/plan-assert-wait.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[9]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[10]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../adr/automation/dora-explains.md
[12]: ../../../adr/index.md
[13]: ../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[14]: ../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[15]: ../../../references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[16]: ../../../references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md
[17]: ../../../references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md
[18]: ../../../../pipelines/ci-automation.yaml
[19]: ../../automation/a-declared-allow-list-of-layers.md
[20]: ../../../adr/glossary.md#world-map
[21]: ../../../adr/glossary.md#track
[22]: ../../../adr/glossary.md#file-language
[23]: ../../../adr/glossary.md#cell
[24]: ../../../adr/glossary.md#lit-cell
[25]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

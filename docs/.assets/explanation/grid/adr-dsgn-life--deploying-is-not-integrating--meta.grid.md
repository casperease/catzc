# docs/.assets/explanation/grid/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md

`Grid minimap: adr-dsgn-life--deploying-is-not-integrating--meta`

![Grid minimap of adr-dsgn-life--deploying-is-not-integrating--meta](adr-dsgn-life--deploying-is-not-integrating--meta.grid.png)

The grid minimap of the slide `adr-dsgn-life--deploying-is-not-integrating--meta` (meta lens). The slide supports [ADR-DSGN-LIFE][1] and
[ADR-DSGN-VISUAL][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 51 files
- .unordered × markdown: 4 lit of 20 files
- automation × yaml: 3 lit of 107 files
- docs × markdown: 5 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/agents/drawio-diagram-waves.md][6]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 26 (text) and line 67 (text).
- [.claude/plans/plan-minimal-robots-agents.md][7]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 39 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][8]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 60 (text) and line 103
  (text).

### .unordered × markdown (4 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 100 (text), line 183 (text)
  and line 268 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 46 (text), line 108 (text), line 184 (text) and line 268
  (text).
- [.unordered/15-10-2026/plan-concern-axis.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 91 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 90 (text).
- [.unordered/15-10-2026/plan-diagram-wave-7.md][11]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text), line 86
  (text), line 86 (text), line 97 (text), line 99 (text), line 101 (text) and line 101 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 83 (text), line 83 (text), line 102 (text) and line 102 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 95 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 94 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][14]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 39 (text), line 39 (body
  comment), line 44 (text) and line 49 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 121 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 102 (text).
- [docs/adr/design/visual-design.md][2]: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.
- [docs/adr/glossary.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 201 (text).
- [docs/adr/index.md][18]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 107 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 106 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][19]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 95 (text) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 68 (text); selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 94 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 39 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 39 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 44 (text) and `automation/Catzc.Base.Docs/configs/agents.yml` line 49 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [.unordered][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [yaml][26]: a file language

Terms the cited ADRs define:

- [occupant][27], defined by [ADR-DSGN-LIFE#5][28]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/visual-design.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/agents/drawio-diagram-waves.md
[7]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[8]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[9]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[10]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[11]: ../../../../.unordered/15-10-2026/plan-diagram-wave-7.md
[12]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[13]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[15]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[16]: ../../../adr/design/dora-explains.md
[17]: ../../../adr/glossary.md
[18]: ../../../adr/index.md
[19]: ../../../../pipelines/ci-automation.yaml
[20]: ../../../adr/glossary.md#world-map
[21]: ../../../adr/glossary.md#track
[22]: ../../../adr/glossary.md#file-language
[23]: ../../../adr/glossary.md#cell
[24]: ../../../adr/glossary.md#lit-cell
[25]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[27]: ../../../adr/glossary.md#occupant
[28]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

# docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md

`Grid minimap: adr-dsgn-life--merging-to-main-is-what-deploys--operations`

![Grid minimap of adr-dsgn-life--merging-to-main-is-what-deploys--operations](adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.png)

The grid minimap of the slide `adr-dsgn-life--merging-to-main-is-what-deploys--operations` (operations lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 9 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 5 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/agents/drawio-diagram-waves.md][6]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 48 (text).
- [.claude/agents/write-drawio-files.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 43 (text) and line 129 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 98 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][9]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 32 (text), line 32 (body
  comment) and line 37 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 65 (text).
- [docs/adr/design/visual-design.md][2]: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.
- [docs/adr/glossary.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 91 (text).

## Keywords

- [world map][14]
- [track][15]
- [file language][16]
- [cell][17]
- [lit cell][18]
- [.claude][19]: a track
- [automation][19]: a track
- [docs][19]: a track
- [markdown][20]: a file language
- [yaml][20]: a file language

Terms the cited ADRs define:

- [occupant][21], defined by [ADR-DSGN-LIFE#5][22]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/visual-design.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/agents/drawio-diagram-waves.md
[7]: ../../../.claude/agents/write-drawio-files.md
[8]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[10]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[11]: ../../adr/design/dora-explains.md
[12]: ../../adr/glossary.md
[13]: ../../adr/index.md
[14]: ../../adr/glossary.md#world-map
[15]: ../../adr/glossary.md#track
[16]: ../../adr/glossary.md#file-language
[17]: ../../adr/glossary.md#cell
[18]: ../../adr/glossary.md#lit-cell
[19]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[20]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[21]: ../../adr/glossary.md#occupant
[22]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

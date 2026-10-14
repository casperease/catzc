# docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md

`Grid minimap: adr-dsgn-life--sync-from-the-last-certified-commit--meta`

![Grid minimap of adr-dsgn-life--sync-from-the-last-certified-commit--meta](adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.png)

The grid minimap of the slide `adr-dsgn-life--sync-from-the-last-certified-commit--meta` (meta lens). The slide supports [ADR-DSGN-LIFE][1];
the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 2 lit of 97 files
- docs × markdown: 11 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/agents/write-drawio-files.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).

### docs × markdown (11 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][8]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][9]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][10]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][11]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][12]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][13]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][14]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][15]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [.claude][23]: a track
- [automation][23]: a track
- [docs][23]: a track
- [markdown][24]: a file language
- [yaml][24]: a file language

Terms the cited ADRs define:

- [occupant][25], defined by [ADR-DSGN-LIFE#5][26]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/agents/write-drawio-files.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[8]: ../../adr/design/dora-explains.md
[9]: ../../adr/design/module-aspects.md
[10]: ../../adr/design/run-modes.md
[11]: ../../adr/design/self-service.md
[12]: ../../adr/design/server-remote-integration.md
[13]: ../../adr/design/thin-platforms.md
[14]: ../../adr/design/tracks.md
[15]: ../../adr/design/visual-design.md
[16]: ../../adr/glossary.md
[17]: ../../adr/index.md
[18]: ../../adr/glossary.md#world-map
[19]: ../../adr/glossary.md#track
[20]: ../../adr/glossary.md#file-language
[21]: ../../adr/glossary.md#cell
[22]: ../../adr/glossary.md#lit-cell
[23]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[25]: ../../adr/glossary.md#occupant
[26]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

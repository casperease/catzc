# docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md

`Grid minimap: adr-dsgn-life--code-wires-only-the-first-rungs--implementation`

![Grid minimap of adr-dsgn-life--code-wires-only-the-first-rungs--implementation](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.png)

The grid minimap of the slide `adr-dsgn-life--code-wires-only-the-first-rungs--implementation` (implementation lens). The slide supports
[ADR-DSGN-LIFE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 2 lit of 97 files
- docs × markdown: 4 lit of 744 files

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

### docs × markdown (4 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text).
- [docs/adr/glossary.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text).

## Keywords

- [world map][11]
- [track][12]
- [file language][13]
- [cell][14]
- [lit cell][15]
- [.claude][16]: a track
- [automation][16]: a track
- [docs][16]: a track
- [markdown][17]: a file language
- [yaml][17]: a file language

Terms the cited ADRs define:

- [occupant][18], defined by [ADR-DSGN-LIFE#5][19]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/agents/write-drawio-files.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[8]: ../../adr/design/dora-explains.md
[9]: ../../adr/glossary.md
[10]: ../../adr/index.md
[11]: ../../adr/glossary.md#world-map
[12]: ../../adr/glossary.md#track
[13]: ../../adr/glossary.md#file-language
[14]: ../../adr/glossary.md#cell
[15]: ../../adr/glossary.md#lit-cell
[16]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[17]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[18]: ../../adr/glossary.md#occupant
[19]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

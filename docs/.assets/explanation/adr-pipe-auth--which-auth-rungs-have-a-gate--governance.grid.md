# docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md

`Grid minimap: adr-pipe-auth--which-auth-rungs-have-a-gate--governance`

![Grid minimap of adr-pipe-auth--which-auth-rungs-have-a-gate--governance](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.png)

The grid minimap of the slide `adr-pipe-auth--which-auth-rungs-have-a-gate--governance` (governance lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 2 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 1 lit of 97 files
- docs × markdown: 3 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 235 (text).

### docs × markdown (3 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/index.md][6]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 219 (text).
- [docs/adr/pipelines/dora-explains.md][7]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 13 (text).
- [docs/adr/pipelines/dual-authentication.md][1]: selected by [ADR-PIPE-AUTH][1]: the ADR's own file.

## Keywords

- [world map][8]
- [track][9]
- [file language][10]
- [cell][11]
- [lit cell][12]
- [automation][13]: a track
- [docs][13]: a track
- [markdown][14]: a file language
- [yaml][14]: a file language

[1]: ../../adr/pipelines/dual-authentication.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../adr/index.md
[7]: ../../adr/pipelines/dora-explains.md
[8]: ../../adr/glossary.md#world-map
[9]: ../../adr/glossary.md#track
[10]: ../../adr/glossary.md#file-language
[11]: ../../adr/glossary.md#cell
[12]: ../../adr/glossary.md#lit-cell
[13]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[14]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

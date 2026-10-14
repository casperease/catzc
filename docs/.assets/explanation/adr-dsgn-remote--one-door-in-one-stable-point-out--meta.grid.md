# docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md

`Grid minimap: adr-dsgn-remote--one-door-in-one-stable-point-out--meta`

![Grid minimap of adr-dsgn-remote--one-door-in-one-stable-point-out--meta](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.png)

The grid minimap of the slide `adr-dsgn-remote--one-door-in-one-stable-point-out--meta` (meta lens). The slide supports
[ADR-DSGN-REMOTE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 2 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 1 lit of 97 files
- docs × markdown: 10 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 100 (text).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][6]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][7]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][8]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][9]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][10]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][1]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][11]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][12]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][13]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][14]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 93 (text).

## Keywords

- [world map][15]
- [track][16]
- [file language][17]
- [cell][18]
- [lit cell][19]
- [automation][20]: a track
- [docs][20]: a track
- [markdown][21]: a file language
- [yaml][21]: a file language

[1]: ../../adr/design/server-remote-integration.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../adr/design/commit-lifecycle.md
[7]: ../../adr/design/dora-explains.md
[8]: ../../adr/design/module-aspects.md
[9]: ../../adr/design/run-modes.md
[10]: ../../adr/design/self-service.md
[11]: ../../adr/design/thin-platforms.md
[12]: ../../adr/design/tracks.md
[13]: ../../adr/design/visual-design.md
[14]: ../../adr/index.md
[15]: ../../adr/glossary.md#world-map
[16]: ../../adr/glossary.md#track
[17]: ../../adr/glossary.md#file-language
[18]: ../../adr/glossary.md#cell
[19]: ../../adr/glossary.md#lit-cell
[20]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[21]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

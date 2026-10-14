# docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md

`Grid minimap: adr-pipe-auth--three-guarded-early-returns--implementation`

![Grid minimap of adr-pipe-auth--three-guarded-early-returns--implementation](adr-pipe-auth--three-guarded-early-returns--implementation.grid.png)

The grid minimap of the slide `adr-pipe-auth--three-guarded-early-returns--implementation` (implementation lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 2 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 1 lit of 95 files
- docs × markdown: 11 lit of 742 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 236 (text).

### docs × markdown (11 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/index.md][6]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 220 (text).
- [docs/adr/pipelines/custom-template-discipline.md][7]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR
  domain of that code.
- [docs/adr/pipelines/dora-explains.md][8]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR domain of
  that code.
- [docs/adr/pipelines/dual-authentication.md][1]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR domain
  of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][9]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the
  ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][10]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR domain
  of that code.
- [docs/explanation/pipelines/configured-credential-proves-its-org.md][11]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 14
  (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/pipelines/one-header-function-owns-precedence.md][12]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 16
  (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/pipelines/three-guarded-early-returns.md][13]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 16 (text), line
  54 (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/pipelines/what-you-set-decides-the-credential.md][14]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 17
  (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text).
- [docs/explanation/pipelines/which-auth-rungs-have-a-gate.md][15]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 14 (text),
  line 17 (text), line 42 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51 (text), line 52 (text), line 53
  (text), line 57 (text) and line 58 (text).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [automation][21]: a track
- [docs][21]: a track
- [markdown][22]: a file language
- [yaml][22]: a file language

[1]: ../../adr/pipelines/dual-authentication.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../adr/index.md
[7]: ../../adr/pipelines/custom-template-discipline.md
[8]: ../../adr/pipelines/dora-explains.md
[9]: ../../adr/pipelines/pipeline-naming-and-placement.md
[10]: ../../adr/pipelines/pipeline-variables.md
[11]: ../../explanation/pipelines/configured-credential-proves-its-org.md
[12]: ../../explanation/pipelines/one-header-function-owns-precedence.md
[13]: ../../explanation/pipelines/three-guarded-early-returns.md
[14]: ../../explanation/pipelines/what-you-set-decides-the-credential.md
[15]: ../../explanation/pipelines/which-auth-rungs-have-a-gate.md
[16]: ../../adr/glossary.md#world-map
[17]: ../../adr/glossary.md#track
[18]: ../../adr/glossary.md#file-language
[19]: ../../adr/glossary.md#cell
[20]: ../../adr/glossary.md#lit-cell
[21]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

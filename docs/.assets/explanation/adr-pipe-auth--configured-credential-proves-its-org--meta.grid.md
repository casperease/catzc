# docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md

`Grid minimap: adr-pipe-auth--configured-credential-proves-its-org--meta`

![Grid minimap of adr-pipe-auth--configured-credential-proves-its-org--meta](adr-pipe-auth--configured-credential-proves-its-org--meta.grid.png)

The grid minimap of the slide `adr-pipe-auth--configured-credential-proves-its-org--meta` (meta lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 2 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 1 lit of 95 files
- docs × markdown: 31 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 235 (text).

### docs × markdown (31 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md][6]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md][7]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 65 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md][8]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text),
  line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59
  (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md][9]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 67
  (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md][10]: selected by [ADR-PIPE-AUTH][1]:
  the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md][11]: selected by [ADR-PIPE-AUTH][1]:
  the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md][12]: selected by [ADR-PIPE-AUTH][1]:
  the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line
  42 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md][13]: selected by [ADR-PIPE-AUTH][1]:
  the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line
  38 (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md][14]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md][15]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md][16]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.tree.md][17]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md][18]: selected by [ADR-PIPE-AUTH][1]:
  the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md][19]: selected by [ADR-PIPE-AUTH][1]:
  the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md][20]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md][21]: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md][22]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md][23]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 57 (text) and line 67 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md][24]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text),
  line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59
  (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md][25]: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 67
  (text) and line 74 (text).
- [docs/adr/index.md][26]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 219 (text).
- [docs/adr/pipelines/custom-template-discipline.md][27]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR
  domain of that code.
- [docs/adr/pipelines/dora-explains.md][28]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR domain of
  that code.
- [docs/adr/pipelines/dual-authentication.md][1]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR domain
  of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][29]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the
  ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][30]: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR domain, the ADR domain
  of that code.
- [docs/explanation/pipelines/configured-credential-proves-its-org.md][31]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 14
  (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/pipelines/one-header-function-owns-precedence.md][32]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 16
  (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/pipelines/three-guarded-early-returns.md][33]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 16 (text), line
  54 (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/pipelines/what-you-set-decides-the-credential.md][34]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 17
  (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text).
- [docs/explanation/pipelines/which-auth-rungs-have-a-gate.md][35]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 14 (text),
  line 17 (text), line 42 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51 (text), line 52 (text), line 53
  (text), line 57 (text) and line 58 (text).

## Keywords

- [world map][36]
- [track][37]
- [file language][38]
- [cell][39]
- [lit cell][40]
- [automation][41]: a track
- [docs][41]: a track
- [markdown][42]: a file language
- [yaml][42]: a file language

[1]: ../../adr/pipelines/dual-authentication.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md
[7]: adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md
[8]: adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
[9]: adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md
[10]: adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md
[11]: adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md
[12]: adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md
[13]: adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md
[14]: adr-pipe-auth--three-guarded-early-returns--implementation.chain.md
[15]: adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md
[16]: adr-pipe-auth--three-guarded-early-returns--implementation.grid.md
[17]: adr-pipe-auth--three-guarded-early-returns--implementation.tree.md
[18]: adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
[19]: adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md
[20]: adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
[21]: adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md
[22]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
[23]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md
[24]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
[25]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md
[26]: ../../adr/index.md
[27]: ../../adr/pipelines/custom-template-discipline.md
[28]: ../../adr/pipelines/dora-explains.md
[29]: ../../adr/pipelines/pipeline-naming-and-placement.md
[30]: ../../adr/pipelines/pipeline-variables.md
[31]: ../../explanation/pipelines/configured-credential-proves-its-org.md
[32]: ../../explanation/pipelines/one-header-function-owns-precedence.md
[33]: ../../explanation/pipelines/three-guarded-early-returns.md
[34]: ../../explanation/pipelines/what-you-set-decides-the-credential.md
[35]: ../../explanation/pipelines/which-auth-rungs-have-a-gate.md
[36]: ../../adr/glossary.md#world-map
[37]: ../../adr/glossary.md#track
[38]: ../../adr/glossary.md#file-language
[39]: ../../adr/glossary.md#cell
[40]: ../../adr/glossary.md#lit-cell
[41]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[42]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

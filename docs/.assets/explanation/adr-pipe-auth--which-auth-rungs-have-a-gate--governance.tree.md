# docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md

`Tree minimap: adr-pipe-auth--which-auth-rungs-have-a-gate--governance`

![Tree minimap of adr-pipe-auth--which-auth-rungs-have-a-gate--governance](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.png)

The tree minimap of the slide `adr-pipe-auth--which-auth-rungs-have-a-gate--governance` (governance lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 32 files in 4 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 25 lit files
- adr/pipe (docs/adr/pipelines): 5 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (25 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md][2], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md][3], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md][4], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md][5], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md][6], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md][8], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md][9], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line
  35 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md][10], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md][11], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md][12], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.tree.md][13], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md][14], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md][15], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md][16], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md][17], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line
  35 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md][18], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md][19], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 57 (text) and line 67 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md][20], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text) and line 61 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md][21], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 52 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 67 (text) and line 74 (text).
- [docs/explanation/pipelines/configured-credential-proves-its-org.md][22], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 14 (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/pipelines/one-header-function-owns-precedence.md][23], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 16 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/pipelines/three-guarded-early-returns.md][24], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 16 (text), line 54 (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/pipelines/what-you-set-decides-the-credential.md][25], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 17 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text).
- [docs/explanation/pipelines/which-auth-rungs-have-a-gate.md][26], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 14 (text), line 17 (text), line 42 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51
  (text), line 52 (text), line 53 (text), line 57 (text) and line 58 (text).

### adr/pipe (5 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/custom-template-discipline.md][27], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/dora-explains.md][28], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR
  domain, the ADR domain of that code.
- [docs/adr/pipelines/dual-authentication.md][1], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][29], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][30], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][31], in the cell automation × yaml: selected by [ADR-PIPE-AUTH][1]: the file cites it at
  line 235 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][32], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 219 (text).

## Keywords

- [world map][33]
- [track][34]
- [file language][35]
- [cell][36]
- [lit cell][37]
- [automation][38]: a track
- [docs][38]: a track
- [markdown][39]: a file language
- [yaml][39]: a file language

[1]: ../../adr/pipelines/dual-authentication.md
[2]: adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md
[3]: adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md
[4]: adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
[5]: adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md
[6]: adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md
[7]: adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md
[8]: adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md
[9]: adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md
[10]: adr-pipe-auth--three-guarded-early-returns--implementation.chain.md
[11]: adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md
[12]: adr-pipe-auth--three-guarded-early-returns--implementation.grid.md
[13]: adr-pipe-auth--three-guarded-early-returns--implementation.tree.md
[14]: adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
[15]: adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md
[16]: adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
[17]: adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md
[18]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
[19]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md
[20]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
[21]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md
[22]: ../../explanation/pipelines/configured-credential-proves-its-org.md
[23]: ../../explanation/pipelines/one-header-function-owns-precedence.md
[24]: ../../explanation/pipelines/three-guarded-early-returns.md
[25]: ../../explanation/pipelines/what-you-set-decides-the-credential.md
[26]: ../../explanation/pipelines/which-auth-rungs-have-a-gate.md
[27]: ../../adr/pipelines/custom-template-discipline.md
[28]: ../../adr/pipelines/dora-explains.md
[29]: ../../adr/pipelines/pipeline-naming-and-placement.md
[30]: ../../adr/pipelines/pipeline-variables.md
[31]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[32]: ../../adr/index.md
[33]: ../../adr/glossary.md#world-map
[34]: ../../adr/glossary.md#track
[35]: ../../adr/glossary.md#file-language
[36]: ../../adr/glossary.md#cell
[37]: ../../adr/glossary.md#lit-cell
[38]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

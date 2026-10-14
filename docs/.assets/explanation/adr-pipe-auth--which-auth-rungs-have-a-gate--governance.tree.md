# docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md

`Tree minimap: adr-pipe-auth--which-auth-rungs-have-a-gate--governance`

![Tree minimap of adr-pipe-auth--which-auth-rungs-have-a-gate--governance](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.png)

The tree minimap of the slide `adr-pipe-auth--which-auth-rungs-have-a-gate--governance` (governance lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 17 files in 4 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 10 lit files
- adr/pipe (docs/adr/pipelines): 5 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md][2], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md][3], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md][4], in the cell docs × markdown: selected
  by [ADR-PIPE-AUTH][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md][5], in the cell docs × markdown:
  selected by [ADR-PIPE-AUTH][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md][6], in the cell docs × markdown: selected by
  [ADR-PIPE-AUTH][1]: the file cites it at line 57 (text) and line 67 (text).
- [docs/explanation/pipelines/configured-credential-proves-its-org.md][7], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 14 (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/pipelines/one-header-function-owns-precedence.md][8], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 16 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/pipelines/three-guarded-early-returns.md][9], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 16 (text), line 54 (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/pipelines/what-you-set-decides-the-credential.md][10], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 17 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text).
- [docs/explanation/pipelines/which-auth-rungs-have-a-gate.md][11], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 14 (text), line 17 (text), line 42 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51
  (text), line 52 (text), line 53 (text), line 57 (text) and line 58 (text).

### adr/pipe (5 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/custom-template-discipline.md][12], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR
  domain, the ADR domain of that code.
- [docs/adr/pipelines/dual-authentication.md][1], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][14], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][15], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16], in the cell automation × yaml: selected by [ADR-PIPE-AUTH][1]: the file cites it at
  line 235 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 219 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [automation][23]: a track
- [docs][23]: a track
- [markdown][24]: a file language
- [yaml][24]: a file language

[1]: ../../adr/pipelines/dual-authentication.md
[2]: adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md
[3]: adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md
[4]: adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md
[5]: adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md
[6]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md
[7]: ../../explanation/pipelines/configured-credential-proves-its-org.md
[8]: ../../explanation/pipelines/one-header-function-owns-precedence.md
[9]: ../../explanation/pipelines/three-guarded-early-returns.md
[10]: ../../explanation/pipelines/what-you-set-decides-the-credential.md
[11]: ../../explanation/pipelines/which-auth-rungs-have-a-gate.md
[12]: ../../adr/pipelines/custom-template-discipline.md
[13]: ../../adr/pipelines/dora-explains.md
[14]: ../../adr/pipelines/pipeline-naming-and-placement.md
[15]: ../../adr/pipelines/pipeline-variables.md
[16]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../adr/index.md
[18]: ../../adr/glossary.md#world-map
[19]: ../../adr/glossary.md#track
[20]: ../../adr/glossary.md#file-language
[21]: ../../adr/glossary.md#cell
[22]: ../../adr/glossary.md#lit-cell
[23]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

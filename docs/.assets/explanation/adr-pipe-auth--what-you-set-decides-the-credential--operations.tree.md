# docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md

`Tree minimap: adr-pipe-auth--what-you-set-decides-the-credential--operations`

![Tree minimap of adr-pipe-auth--what-you-set-decides-the-credential--operations](adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.png)

The tree minimap of the slide `adr-pipe-auth--what-you-set-decides-the-credential--operations` (operations lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 12 files in 4 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/pipe (docs/adr/pipelines): 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/pipe (5 lit files)

The group holds the files of docs/adr/pipelines; each sits in its world-map cell and is lit by:

- [docs/adr/pipelines/custom-template-discipline.md][2], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines` ADR
  domain, the ADR domain of that code.
- [docs/adr/pipelines/dual-authentication.md][1], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-naming-and-placement.md][4], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the
  `pipelines` ADR domain, the ADR domain of that code.
- [docs/adr/pipelines/pipeline-variables.md][5], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: an ADR file of the `pipelines`
  ADR domain, the ADR domain of that code.

### docs (5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/pipelines/configured-credential-proves-its-org.md][6], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 14 (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/pipelines/one-header-function-owns-precedence.md][7], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 16 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/pipelines/three-guarded-early-returns.md][8], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 16 (text), line 54 (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/pipelines/what-you-set-decides-the-credential.md][9], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the
  file cites it at line 17 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text).
- [docs/explanation/pipelines/which-auth-rungs-have-a-gate.md][10], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file
  cites it at line 14 (text), line 17 (text), line 42 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51
  (text), line 52 (text), line 53 (text), line 57 (text) and line 58 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][11], in the cell automation × yaml: selected by [ADR-PIPE-AUTH][1]: the file cites it at
  line 236 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][12], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 220 (text).

## Keywords

- [world map][13]
- [track][14]
- [file language][15]
- [cell][16]
- [lit cell][17]
- [automation][18]: a track
- [docs][18]: a track
- [markdown][19]: a file language
- [yaml][19]: a file language

[1]: ../../adr/pipelines/dual-authentication.md
[2]: ../../adr/pipelines/custom-template-discipline.md
[3]: ../../adr/pipelines/dora-explains.md
[4]: ../../adr/pipelines/pipeline-naming-and-placement.md
[5]: ../../adr/pipelines/pipeline-variables.md
[6]: ../../explanation/pipelines/configured-credential-proves-its-org.md
[7]: ../../explanation/pipelines/one-header-function-owns-precedence.md
[8]: ../../explanation/pipelines/three-guarded-early-returns.md
[9]: ../../explanation/pipelines/what-you-set-decides-the-credential.md
[10]: ../../explanation/pipelines/which-auth-rungs-have-a-gate.md
[11]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../adr/index.md
[13]: ../../adr/glossary.md#world-map
[14]: ../../adr/glossary.md#track
[15]: ../../adr/glossary.md#file-language
[16]: ../../adr/glossary.md#cell
[17]: ../../adr/glossary.md#lit-cell
[18]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[19]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

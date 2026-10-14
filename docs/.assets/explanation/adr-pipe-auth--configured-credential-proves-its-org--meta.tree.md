# docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md

`Tree minimap: adr-pipe-auth--configured-credential-proves-its-org--meta`

![Tree minimap of adr-pipe-auth--configured-credential-proves-its-org--meta](adr-pipe-auth--configured-credential-proves-its-org--meta.tree.png)

The tree minimap of the slide `adr-pipe-auth--configured-credential-proves-its-org--meta` (meta lens). The slide supports
[ADR-PIPE-AUTH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 7 files in 3 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/pipe (docs/adr/pipelines): 5 lit files
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

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6], in the cell automation × yaml: selected by [ADR-PIPE-AUTH][1]: the file cites it at line
  235 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][7], in the cell docs × markdown: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 219 (text).

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
[2]: ../../adr/pipelines/custom-template-discipline.md
[3]: ../../adr/pipelines/dora-explains.md
[4]: ../../adr/pipelines/pipeline-naming-and-placement.md
[5]: ../../adr/pipelines/pipeline-variables.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../adr/index.md
[8]: ../../adr/glossary.md#world-map
[9]: ../../adr/glossary.md#track
[10]: ../../adr/glossary.md#file-language
[11]: ../../adr/glossary.md#cell
[12]: ../../adr/glossary.md#lit-cell
[13]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[14]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

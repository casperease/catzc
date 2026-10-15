# docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md

`Tree minimap: adr-dsgn-remote--local-guard-and-server-policies--implementation`

![Tree minimap of adr-dsgn-remote--local-guard-and-server-policies--implementation](adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-remote--local-guard-and-server-policies--implementation` (implementation lens). The slide supports
[ADR-DSGN-REMOTE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 4 files in 3 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 105
  (text).
- [docs/adr/design/server-remote-integration.md][1], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][3], in the cell automation × yaml: selected by [ADR-DSGN-REMOTE][1]: the file cites it at
  line 100 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][4], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 93 (text).

## Keywords

- [world map][5]
- [track][6]
- [file language][7]
- [cell][8]
- [lit cell][9]
- [automation][10]: a track
- [docs][10]: a track
- [markdown][11]: a file language
- [yaml][11]: a file language

[1]: ../../adr/design/server-remote-integration.md
[2]: ../../adr/design/dora-explains.md
[3]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[4]: ../../adr/index.md
[5]: ../../adr/glossary.md#world-map
[6]: ../../adr/glossary.md#track
[7]: ../../adr/glossary.md#file-language
[8]: ../../adr/glossary.md#cell
[9]: ../../adr/glossary.md#lit-cell
[10]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[11]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

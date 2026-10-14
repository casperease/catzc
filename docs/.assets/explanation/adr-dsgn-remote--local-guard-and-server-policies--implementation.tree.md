# docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md

`Tree minimap: adr-dsgn-remote--local-guard-and-server-policies--implementation`

![Tree minimap of adr-dsgn-remote--local-guard-and-server-policies--implementation](adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-remote--local-guard-and-server-policies--implementation` (implementation lens). The slide supports
[ADR-DSGN-REMOTE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 11 files in 3 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 9 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][4], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][5], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][6], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][1], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][7], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][8], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][9], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][10], in the cell automation × yaml: selected by [ADR-DSGN-REMOTE][1]: the file cites it at
  line 100 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][11], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 93 (text).

## Keywords

- [world map][12]
- [track][13]
- [file language][14]
- [cell][15]
- [lit cell][16]
- [automation][17]: a track
- [docs][17]: a track
- [markdown][18]: a file language
- [yaml][18]: a file language

[1]: ../../adr/design/server-remote-integration.md
[2]: ../../adr/design/commit-lifecycle.md
[3]: ../../adr/design/dora-explains.md
[4]: ../../adr/design/module-aspects.md
[5]: ../../adr/design/run-modes.md
[6]: ../../adr/design/self-service.md
[7]: ../../adr/design/thin-platforms.md
[8]: ../../adr/design/tracks.md
[9]: ../../adr/design/visual-design.md
[10]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../adr/index.md
[12]: ../../adr/glossary.md#world-map
[13]: ../../adr/glossary.md#track
[14]: ../../adr/glossary.md#file-language
[15]: ../../adr/glossary.md#cell
[16]: ../../adr/glossary.md#lit-cell
[17]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[18]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

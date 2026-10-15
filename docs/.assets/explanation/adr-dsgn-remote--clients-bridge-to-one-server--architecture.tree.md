# docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md

`Tree minimap: adr-dsgn-remote--clients-bridge-to-one-server--architecture`

![Tree minimap of adr-dsgn-remote--clients-bridge-to-one-server--architecture](adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-remote--clients-bridge-to-one-server--architecture` (architecture lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-DSGN-REMOTE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 8 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 105 (text).
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][5], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 93 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/write-drawio-files.md][6], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][7], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  99 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][8], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

## Keywords

- [world map][9]
- [track][10]
- [file language][11]
- [cell][12]
- [lit cell][13]
- [.claude][14]: a track
- [automation][14]: a track
- [docs][14]: a track
- [markdown][15]: a file language
- [yaml][15]: a file language

Terms the cited ADRs define:

- [occupant][16], defined by [ADR-DSGN-LIFE#5][17]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/design/dora-explains.md
[4]: ../../adr/glossary.md
[5]: ../../adr/index.md
[6]: ../../../.claude/agents/write-drawio-files.md
[7]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[9]: ../../adr/glossary.md#world-map
[10]: ../../adr/glossary.md#track
[11]: ../../adr/glossary.md#file-language
[12]: ../../adr/glossary.md#cell
[13]: ../../adr/glossary.md#lit-cell
[14]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[15]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[16]: ../../adr/glossary.md#occupant
[17]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

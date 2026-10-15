# docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.md

`Tree minimap: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation`

![Tree minimap of adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation](adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.png)

The tree minimap of the slide `adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation` (implementation lens). The slide
supports [ADR-AUTO-DEPM][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 7 files in 4 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- ModuleSystem (automation/Catzc.Base.ModuleSystem): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 3 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][2], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][3], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][4], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 3 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][5], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 349
  (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at line
  157 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][7], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 145 (text).

## Keywords

- [world map][8]
- [track][9]
- [file language][10]
- [cell][11]
- [lit cell][12]
- [automation][13]: a track
- [docs][13]: a track
- [csharp][14]: a file language
- [markdown][14]: a file language
- [yaml][14]: a file language

[1]: ../../adr/automation/controlling-module-dependencies.md
[2]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[3]: ../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[4]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[5]: ../../adr/automation/dora-explains.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../adr/index.md
[8]: ../../adr/glossary.md#world-map
[9]: ../../adr/glossary.md#track
[10]: ../../adr/glossary.md#file-language
[11]: ../../adr/glossary.md#cell
[12]: ../../adr/glossary.md#lit-cell
[13]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[14]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

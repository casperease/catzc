# docs/.assets/explanation/tree/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md

`Tree minimap: adr-auto-depm--undeclared-edge-fails-with-one-line--operations`

![Tree minimap of adr-auto-depm--undeclared-edge-fails-with-one-line--operations](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.png)

The tree minimap of the slide `adr-auto-depm--undeclared-edge-fails-with-one-line--operations` (operations lens). The slide supports
[ADR-AUTO-DEPM][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 15 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 4 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 3 lit files
- docs (docs/ outside docs/adr/): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][2], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites
  it at line 136 (text).
- [.claude/plans/plan-module-kinds-tracks.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line
  113 (text), line 195 (text), line 199 (text), line 258 (text), line 264 (text), line 268 (text), line 286 (text), line 415 (text) and line
  454 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 17 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][5], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 18 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 3 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][6], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][7], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][8], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 19 (text).

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 30 (text).
- [docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 16 (text) and line 33 (text).
- [docs/references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 16 (text) and line 31 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][12], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 413
  (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 153 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][14], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 162 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][15], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 153 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs` line 20 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs` line 19 (text) and `automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs`
  line 19 (text).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [.claude][21]: a track
- [automation][21]: a track
- [docs][21]: a track
- [pipelines][21]: a track
- [csharp][22]: a file language
- [markdown][22]: a file language
- [pipeline-yaml][22]: a file language
- [yaml][22]: a file language

[1]: ../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[3]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[4]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[5]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[6]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[7]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[8]: ../../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[9]: ../../../references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[10]: ../../../references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
[11]: ../../../references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md
[12]: ../../../adr/automation/dora-explains.md
[13]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../adr/index.md
[15]: ../../../../pipelines/ci-automation.yaml
[16]: ../../../adr/glossary.md#world-map
[17]: ../../../adr/glossary.md#track
[18]: ../../../adr/glossary.md#file-language
[19]: ../../../adr/glossary.md#cell
[20]: ../../../adr/glossary.md#lit-cell
[21]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

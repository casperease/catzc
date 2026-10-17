# docs/explanation/.assets/tree/adr-auto-depm--three-layers-edges-point-down--architecture.tree.md

`Tree minimap: adr-auto-depm--three-layers-edges-point-down--architecture`

![Tree minimap of adr-auto-depm--three-layers-edges-point-down--architecture](adr-auto-depm--three-layers-edges-point-down--architecture.tree.png)

The tree minimap of the slide `adr-auto-depm--three-layers-edges-point-down--architecture` (architecture lens). The slide supports
[ADR-AUTO-DEPM][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 16 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 5 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 3 lit files
- docs (docs/ outside docs/adr/): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (5 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][2], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites
  it at line 177 (text).
- [.claude/plans/plan-assert-wait.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 80
  (text).
- [.claude/plans/plan-module-kinds-tracks.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line
  35 (text), line 219 (text), line 302 (text), line 306 (text), line 369 (text), line 375 (text), line 379 (text), line 398 (text), line 551
  (text) and line 588 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][5], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 40 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 41 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 3 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][7], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][8], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][9], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 20 (text).

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text) and line 32 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 415
  (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][14], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 154 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][15], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 165 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][16], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 154 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs` line 21 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs` line 20 (text) and `automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs`
  line 20 (text).

## Keywords

- [world map][17]
- [track][18]
- [file language][19]
- [cell][20]
- [lit cell][21]
- [.claude][22]: a track
- [automation][22]: a track
- [docs][22]: a track
- [pipelines][22]: a track
- [csharp][23]: a file language
- [markdown][23]: a file language
- [pipeline-yaml][23]: a file language
- [yaml][23]: a file language

[1]: ../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[3]: ../../../../.claude/plans/plan-assert-wait.md
[4]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[5]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[6]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[7]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[8]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[9]: ../../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[10]: ../../../references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[11]: ../../../references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
[12]: ../../../references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md
[13]: ../../../adr/automation/dora-explains.md
[14]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../adr/index.md
[16]: ../../../../pipelines/ci-automation.yaml
[17]: ../../../adr/glossary.md#world-map
[18]: ../../../adr/glossary.md#track
[19]: ../../../adr/glossary.md#file-language
[20]: ../../../adr/glossary.md#cell
[21]: ../../../adr/glossary.md#lit-cell
[22]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[23]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

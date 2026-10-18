---
catzc:
  immutable:
    with_body_sha: "4b2497b47069"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-auto-depm--three-layers-edges-point-down--architecture.tree.md
    source: docs/explanation/.assets/adr-auto-depm--three-layers-edges-point-down--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Module dependencies form three layers, and every edge points down: the tree minimap

```text
Which files cite ADR-AUTO-DEPM: every file of the world map is a tile, grouped by top-level folder.
18 files lit in 7 groups.
```

![The tree minimap of Module dependencies form three layers, and every edge points down](adr-auto-depm--three-layers-edges-point-down--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Module dependencies form three layers, and every edge points
down][19], which explains [ADR-AUTO-DEPM][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 18 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (5 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][2], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites
  it at line 184 (text).
- [.claude/plans/plan-assert-wait.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 87
  (text).
- [.claude/plans/plan-module-kinds-tracks.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line
  32 (text), line 226 (text), line 309 (text), line 313 (text), line 376 (text), line 382 (text), line 386 (text), line 405 (text), line 561
  (text) and line 598 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][5], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 37 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 38 (text).

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][7], in the cell docs ×
  markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 16 (text), line 68 (text), line 75 (text), line 75 (text), line 92
  (text) and line 94 (text).
- [docs/references/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][8], in the cell docs × markdown: selected
  by [ADR-AUTO-DEPM][1]: the file cites it at line 16 (text), line 133 (text) and line 137 (text).
- [docs/references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text) and line 32 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 3 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][12], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][13], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][14], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 20 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 435
  (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 157 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 169 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][18], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 157 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs` line 21 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs` line 20 (text) and `automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs`
  line 20 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [csharp][26]: a file language
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [yaml][26]: a file language

[1]: ../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[3]: ../../../../.claude/plans/plan-assert-wait.md
[4]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[5]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[6]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[7]: ../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[8]: ../../../references/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[9]: ../../../references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[10]: ../../../references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
[11]: ../../../references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md
[12]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[13]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[14]: ../../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[15]: ../../../adr/automation/dora-explains.md
[16]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../adr/index.md
[18]: ../../../../pipelines/ci-automation.yaml
[19]: ../../automation/three-layers-edges-point-down.md
[20]: ../../../adr/glossary.md#world-map
[21]: ../../../adr/glossary.md#track
[22]: ../../../adr/glossary.md#file-language
[23]: ../../../adr/glossary.md#cell
[24]: ../../../adr/glossary.md#lit-cell
[25]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

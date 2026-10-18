---
catzc:
  immutable:
    with_body_sha: e50e3b2df365
    repo_status: locked
    path: docs/explanation/automation/.assets/three-layers-edges-point-down/tree.md
    source: docs/explanation/automation/.assets/three-layers-edges-point-down/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Module dependencies form three layers, and every edge points down: the tree minimap

```text
Which files cite ADR-AUTO-DEPM: every file of the world map is a tile, grouped by top-level folder.
10 files lit in 5 groups.
```

![The tree minimap of Module dependencies form three layers, and every edge points down](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Module dependencies form three layers, and every edge points
down][11], which explains [ADR-AUTO-DEPM][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 10 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/.assets/module-graph-declared-vs-observed/diagram.drawio.md][2], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 110 (text) and line 114 (text).
- [docs/references/pwsh/.assets/module-graph-declared-vs-observed/diagram.drawio.verify.md][3], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 47 (text), line 54 (text), line 54 (text), line 71 (text) and line 73 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md][4], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md][5], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md][6], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]:
  the file cites it at line 13 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][7], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 365
  (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][8], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 169 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][9], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 138 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][10], in the cell pwsh × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 138
  (text).

## Keywords

- [world map][12]
- [track][13]
- [file language][14]
- [cell][15]
- [lit cell][16]
- [docs][17]: a track
- [pipelines][17]: a track
- [pwsh][17]: a track
- [markdown][18]: a file language
- [pipeline-yaml][18]: a file language
- [yaml][18]: a file language

[1]: ../../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../references/pwsh/.assets/module-graph-declared-vs-observed/diagram.drawio.md
[3]: ../../../../references/pwsh/.assets/module-graph-declared-vs-observed/diagram.drawio.verify.md
[4]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[5]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md
[6]: ../../../../references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md
[7]: ../../../../adr/automation/dora-explains.md
[8]: ../../../../adr/index.md
[9]: ../../../../../pipelines/ci-automation.yaml
[10]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../three-layers-edges-point-down.md
[12]: ../../../../adr/glossary.md#world-map
[13]: ../../../../adr/glossary.md#track
[14]: ../../../../adr/glossary.md#file-language
[15]: ../../../../adr/glossary.md#cell
[16]: ../../../../adr/glossary.md#lit-cell
[17]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[18]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

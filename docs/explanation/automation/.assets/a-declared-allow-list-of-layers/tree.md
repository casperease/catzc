# One declared allow-list says what may depend on what, and every edge points down: the tree minimap

```text
Which files cite ADR-AUTO-DEPM: every file of the world map is a tile, grouped by top-level folder.
11 files lit in 6 groups.
```

![The tree minimap of One declared allow-list says what may depend on what, and every edge points down](tree.png)

This is the tree minimap in the sidebar of the meta diagram of [One declared allow-list says what may depend on what, and every edge points
down][12], which explains [ADR-AUTO-DEPM][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 11 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- adr/auto (docs/adr/automation): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][2], in the cell docs ×
  markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 47 (text), line 54 (text), line 54 (text), line 71 (text) and line 73
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 110 (text) and line 114 (text).
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

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-assert-wait.md][8], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 57
  (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][9], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 169 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][10], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 138 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][11], in the cell pwsh × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 138
  (text).

## Keywords

- [world map][13]
- [track][14]
- [file language][15]
- [cell][16]
- [lit cell][17]
- [.claude][18]: a track
- [docs][18]: a track
- [pipelines][18]: a track
- [pwsh][18]: a track
- [markdown][19]: a file language
- [pipeline-yaml][19]: a file language
- [yaml][19]: a file language

[1]: ../../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[3]: ../../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[4]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[5]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md
[6]: ../../../../references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md
[7]: ../../../../adr/automation/dora-explains.md
[8]: ../../../../../.claude/plans/plan-assert-wait.md
[9]: ../../../../adr/index.md
[10]: ../../../../../pipelines/ci-automation.yaml
[11]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../a-declared-allow-list-of-layers.md
[13]: ../../../../adr/glossary.md#world-map
[14]: ../../../../adr/glossary.md#track
[15]: ../../../../adr/glossary.md#file-language
[16]: ../../../../adr/glossary.md#cell
[17]: ../../../../adr/glossary.md#lit-cell
[18]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[19]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

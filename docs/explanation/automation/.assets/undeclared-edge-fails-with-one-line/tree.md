---
catzc:
  immutable:
    with_body_sha: "1a23278d7780"
    repo_status: locked
    path: docs/explanation/automation/.assets/undeclared-edge-fails-with-one-line/tree.md
    source: docs/explanation/automation/.assets/undeclared-edge-fails-with-one-line/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# An undeclared module edge fails the gate with one line per issue: the tree minimap

```text
Which files cite ADR-AUTO-DEPM: every file of the world map is a tile, grouped by top-level folder.
9 files lit in 6 groups.
```

![The tree minimap of An undeclared module edge fails the gate with one line per issue](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [An undeclared module edge fails the gate with one line per issue][10],
which explains [ADR-AUTO-DEPM][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the
decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 9 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][2], in the cell docs ×
  markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 54 (text), line 54 (text) and line 73 (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 114 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md][4], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 12 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][5], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 365
  (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-assert-wait.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 57
  (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][7], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 171 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][8], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 138 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][9], in the cell pwsh × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 138 (text).

## Keywords

- [world map][11]
- [track][12]
- [file language][13]
- [cell][14]
- [lit cell][15]
- [.claude][16]: a track
- [docs][16]: a track
- [pipelines][16]: a track
- [pwsh][16]: a track
- [markdown][17]: a file language
- [pipeline-yaml][17]: a file language
- [yaml][17]: a file language

[1]: ../../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[3]: ../../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[4]: ../../../../references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[5]: ../../../../adr/automation/dora-explains.md
[6]: ../../../../../.claude/plans/plan-assert-wait.md
[7]: ../../../../adr/index.md
[8]: ../../../../../pipelines/ci-automation.yaml
[9]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../undeclared-edge-fails-with-one-line.md
[11]: ../../../../adr/glossary.md#world-map
[12]: ../../../../adr/glossary.md#track
[13]: ../../../../adr/glossary.md#file-language
[14]: ../../../../adr/glossary.md#cell
[15]: ../../../../adr/glossary.md#lit-cell
[16]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[17]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

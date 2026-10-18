---
catzc:
  immutable:
    with_body_sha: "27c6e018667f"
    repo_status: locked
    path: docs/explanation/design/.assets/deploy-and-integrate-share-only-the-topic/tree.md
    source: docs/explanation/design/.assets/deploy-and-integrate-share-only-the-topic/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Deploying a topic commit and integrating it share only the topic commit: the tree minimap

```text
Which files cite ADR-DSGN-LIFE and ADR-DSGN-VISUAL: every file of the world map is a tile, grouped by top-level folder.
20 files lit in 7 groups.
```

![The tree minimap of Deploying a topic commit and integrating it share only the topic commit](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Deploying a topic commit and integrating it share only the topic
commit][21], which explains [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]. It lights every file that cites those codes, grouped by folder, so
it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 20 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 9 lit files
- Docs (pwsh/Catzc.Base.Docs): 4 lit files
- .claude: 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- docs (docs/ outside docs/adr/): 1 lit file
- pipelines: 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/.assets/commit-lifecycle-states/chain.md][3], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 18 (text), line 25 (text), line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/grid.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 18 (text), line 25 (text), line 55 (text), line 56 (text), line 63 (text), line 65 (text), line 69 (text), line 73 (text), line
  75 (text), line 79 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 94 (text), line 103
  (text), line 104 (text) and line 105 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/tree.md][5], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 18 (text), line 25 (text), line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line
  68 (text), line 69 (text), line 75 (text), line 77 (text), line 83 (text), line 85 (text), line 91 (text), line 92 (text), line 99 (text),
  line 106 (text) and line 114 (text).
- [docs/adr/design/.assets/sync-point/chain.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  18 (text), line 25 (text), line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/sync-point/grid.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18
  (text), line 25 (text), line 55 (text), line 56 (text), line 63 (text), line 65 (text), line 69 (text), line 73 (text), line 75 (text),
  line 79 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 94 (text), line 103 (text), line 104
  (text) and line 105 (text).
- [docs/adr/design/.assets/sync-point/tree.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18
  (text), line 25 (text), line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text),
  line 69 (text), line 75 (text), line 77 (text), line 83 (text), line 85 (text), line 91 (text), line 92 (text), line 99 (text), line 106
  (text) and line 114 (text).
- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text);
  selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).
- [docs/adr/design/visual-design.md][2], in the cell docs × markdown: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 4 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][10], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text);
  selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 77 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][11], in the cell pwsh × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 28
  (text), line 28 (text), line 34 (text) and line 39 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][12], in the cell pwsh × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  74 (text), line 79 (text), line 84 (text), line 84 (text) and line 89 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][13], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484
  (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-promotion-ladder.md][14], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11
  (text) and line 38 (text).
- [.claude/plans/value-of-plan.md][15], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 33 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][16], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 273 (text) and line 347
  (text).
- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 111 (text).

### docs (docs/ outside docs/adr/, 1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][18], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][19], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text);
  selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 77 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 34 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 39 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 74 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 79 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 84 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 84 (text) and `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 89 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][20], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 49 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [.claude][27]: a track
- [docs][27]: a track
- [pipelines][27]: a track
- [pwsh][27]: a track
- [markdown][28]: a file language
- [pipeline-yaml][28]: a file language
- [yaml][28]: a file language

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/visual-design.md
[3]: ../../../../adr/design/.assets/commit-lifecycle-states/chain.md
[4]: ../../../../adr/design/.assets/commit-lifecycle-states/grid.md
[5]: ../../../../adr/design/.assets/commit-lifecycle-states/tree.md
[6]: ../../../../adr/design/.assets/sync-point/chain.md
[7]: ../../../../adr/design/.assets/sync-point/grid.md
[8]: ../../../../adr/design/.assets/sync-point/tree.md
[9]: ../../../../adr/design/dora-explains.md
[10]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[12]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[13]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[14]: ../../../../../.claude/plans/plan-promotion-ladder.md
[15]: ../../../../../.claude/plans/value-of-plan.md
[16]: ../../../../adr/glossary.md
[17]: ../../../../adr/index.md
[18]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[19]: ../../../../../pipelines/ci-automation.yaml
[20]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[21]: ../../deploy-and-integrate-share-only-the-topic.md
[22]: ../../../../adr/glossary.md#world-map
[23]: ../../../../adr/glossary.md#track
[24]: ../../../../adr/glossary.md#file-language
[25]: ../../../../adr/glossary.md#cell
[26]: ../../../../adr/glossary.md#lit-cell
[27]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

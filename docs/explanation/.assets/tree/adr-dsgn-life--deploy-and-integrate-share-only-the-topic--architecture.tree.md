---
catzc:
  immutable:
    with_body_sha: e0e66422b6c8
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md
    source: docs/explanation/.assets/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Deploying a topic commit and integrating it share only the topic commit: the tree minimap

```text
Which files cite ADR-DSGN-LIFE and ADR-DSGN-VISUAL: every file of the world map is a tile, grouped by top-level folder.
13 files lit in 7 groups.
```

![The tree minimap of Deploying a topic commit and integrating it share only the topic commit](adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Deploying a topic commit and integrating it share only the topic
commit][14], which explains [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]. It lights every file that cites those codes, grouped by folder, so
it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 13 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Docs (automation/Catzc.Base.Docs): 3 lit files
- adr/dsgn (docs/adr/design): 3 lit files
- .claude: 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][3], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  78 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 77 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][4], in the cell automation × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites it at
  line 28 (text), line 28 (body comment), line 34 (text) and line 39 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][5], in the cell automation × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites
  it at line 67 (text), line 72 (text), line 77 (text), line 77 (body comment) and line 82 (text).

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text);
  selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).
- [docs/adr/design/visual-design.md][2], in the cell docs × markdown: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-fast-push-followups.md][7], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  12 (text) and line 37 (text).
- [.claude/plans/value-of-plan.md][8], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 44 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text).
- [docs/adr/index.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 111 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][11], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 49 (text).

### docs (docs/ outside docs/adr/, 1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-git/Push-Dirty.ps1.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 14 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][13], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 78 (text) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text); selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 77 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 28 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 28 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 34 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 39 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 67 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 72
  (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 77 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line
  77 (body comment) and `automation/Catzc.Base.Docs/configs/capabilities.yml` line 82 (text).

## Keywords

- [world map][15]
- [track][16]
- [file language][17]
- [cell][18]
- [lit cell][19]
- [.claude][20]: a track
- [automation][20]: a track
- [docs][20]: a track
- [pipelines][20]: a track
- [markdown][21]: a file language
- [pipeline-yaml][21]: a file language
- [yaml][21]: a file language

Terms the cited ADRs define:

- [occupant][22], defined by [ADR-DSGN-LIFE#5][23]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/visual-design.md
[3]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[4]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[5]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[6]: ../../../adr/design/dora-explains.md
[7]: ../../../../.claude/plans/plan-fast-push-followups.md
[8]: ../../../../.claude/plans/value-of-plan.md
[9]: ../../../adr/glossary.md
[10]: ../../../adr/index.md
[11]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[12]: ../../../references/automation/catzc-base-git/Push-Dirty.ps1.md
[13]: ../../../../pipelines/ci-automation.yaml
[14]: ../../design/deploy-and-integrate-share-only-the-topic.md
[15]: ../../../adr/glossary.md#world-map
[16]: ../../../adr/glossary.md#track
[17]: ../../../adr/glossary.md#file-language
[18]: ../../../adr/glossary.md#cell
[19]: ../../../adr/glossary.md#lit-cell
[20]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[21]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[22]: ../../../adr/glossary.md#occupant
[23]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

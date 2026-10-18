---
catzc:
  immutable:
    with_body_sha: dfc035425611
    repo_status: locked
    path: docs/explanation/design/.assets/guard-and-policies-by-command/tree.md
    source: docs/explanation/design/.assets/guard-and-policies-by-command/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A person turns on the local guard with one variant; an admin syncs the server policies with one command: the tree minimap

```text
Which files cite ADR-DSGN-REMOTE: every file of the world map is a tile, grouped by top-level folder.
5 files lit in 4 groups.
```

![The tree minimap of A person turns on the local guard with one variant; an admin syncs the server policies with one command](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [A person turns on the local guard with one variant; an admin syncs the
server policies with one command][6], which explains [ADR-DSGN-REMOTE][1]. It lights every file that cites those codes, grouped by folder,
so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 5 files in 4 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 103
  (text).
- [docs/adr/design/server-remote-integration.md][1], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][3], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 115 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][4], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-REMOTE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 79 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][5], in the cell pwsh × yaml: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 79
  (text).

## Keywords

- [world map][7]
- [track][8]
- [file language][9]
- [cell][10]
- [lit cell][11]
- [docs][12]: a track
- [pipelines][12]: a track
- [pwsh][12]: a track
- [markdown][13]: a file language
- [pipeline-yaml][13]: a file language
- [yaml][13]: a file language

[1]: ../../../../adr/design/server-remote-integration.md
[2]: ../../../../adr/design/dora-explains.md
[3]: ../../../../adr/index.md
[4]: ../../../../../pipelines/ci-automation.yaml
[5]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../guard-and-policies-by-command.md
[7]: ../../../../adr/glossary.md#world-map
[8]: ../../../../adr/glossary.md#track
[9]: ../../../../adr/glossary.md#file-language
[10]: ../../../../adr/glossary.md#cell
[11]: ../../../../adr/glossary.md#lit-cell
[12]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[13]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

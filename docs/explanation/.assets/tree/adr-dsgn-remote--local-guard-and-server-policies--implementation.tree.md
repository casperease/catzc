---
catzc:
  immutable:
    with_body_sha: db673fc44135
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md
    source: docs/explanation/.assets/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The code carries both halves of ingress, but nothing finds the last verified commit: the tree minimap

```text
Which files cite ADR-DSGN-REMOTE: every file of the world map is a tile, grouped by top-level folder.
5 files lit in 4 groups.
```

![The tree minimap of The code carries both halves of ingress, but nothing finds the last verified commit](adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [The code carries both halves of ingress, but nothing finds the
last verified commit][6], which explains [ADR-DSGN-REMOTE][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 5 files in 4 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 103
  (text).
- [docs/adr/design/server-remote-integration.md][1], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][3], in the cell automation × yaml: selected by [ADR-DSGN-REMOTE][1]: the file cites it at
  line 79 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][4], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 113 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][5], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-REMOTE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 79 (text).

## Keywords

- [world map][7]
- [track][8]
- [file language][9]
- [cell][10]
- [lit cell][11]
- [automation][12]: a track
- [docs][12]: a track
- [pipelines][12]: a track
- [markdown][13]: a file language
- [pipeline-yaml][13]: a file language
- [yaml][13]: a file language

[1]: ../../../adr/design/server-remote-integration.md
[2]: ../../../adr/design/dora-explains.md
[3]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[4]: ../../../adr/index.md
[5]: ../../../../pipelines/ci-automation.yaml
[6]: ../../design/local-guard-and-server-policies.md
[7]: ../../../adr/glossary.md#world-map
[8]: ../../../adr/glossary.md#track
[9]: ../../../adr/glossary.md#file-language
[10]: ../../../adr/glossary.md#cell
[11]: ../../../adr/glossary.md#lit-cell
[12]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[13]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

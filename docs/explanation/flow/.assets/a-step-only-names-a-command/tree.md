---
catzc:
  immutable:
    with_body_sha: c7fb5db46ef4
    repo_status: locked
    path: docs/explanation/flow/.assets/a-step-only-names-a-command/tree.md
    source: docs/explanation/flow/.assets/a-step-only-names-a-command/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A pipeline step only names a command that a developer can run locally: the tree minimap

```text
Which files cite ADR-FLOW-CD-RUNNER: every file of the world map is a tile, grouped by top-level folder.
8 files lit in 6 groups.
```

![The tree minimap of A pipeline step only names a command that a developer can run locally](tree.png)

This is the tree minimap in the sidebar of the meta diagram of [A pipeline step only names a command that a developer can run locally][9],
which explains [ADR-FLOW-CD-RUNNER][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the
decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 8 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][2], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).
- [.claude/plans/plan-adr-code-language.md][3], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 126 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 130 (text).

### docs (docs/ outside docs/adr/, 1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pipelines/steps/invoke-automation.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 28 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][7], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][8], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 98
  (text).

## Keywords

- [world map][10]
- [track][11]
- [file language][12]
- [cell][13]
- [lit cell][14]
- [.claude][15]: a track
- [docs][15]: a track
- [pipelines][15]: a track
- [pwsh][15]: a track
- [markdown][16]: a file language
- [pipeline-yaml][16]: a file language
- [yaml][16]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../../.claude/CLAUDE.md
[3]: ../../../../../.claude/plans/plan-adr-code-language.md
[4]: ../../../../adr/flow/dora-explains.md
[5]: ../../../../adr/index.md
[6]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[7]: ../../../../../pipelines/ci-automation.yaml
[8]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../a-step-only-names-a-command.md
[10]: ../../../../adr/glossary.md#world-map
[11]: ../../../../adr/glossary.md#track
[12]: ../../../../adr/glossary.md#file-language
[13]: ../../../../adr/glossary.md#cell
[14]: ../../../../adr/glossary.md#lit-cell
[15]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[16]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

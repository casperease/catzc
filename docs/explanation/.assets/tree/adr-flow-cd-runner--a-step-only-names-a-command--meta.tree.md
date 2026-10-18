# A pipeline step only names a command that a developer can run locally: the tree minimap

```text
Which files cite ADR-FLOW-CD-RUNNER: every file of the world map is a tile, grouped by top-level folder.
7 files lit in 6 groups.
```

![The tree minimap of A pipeline step only names a command that a developer can run locally](adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.png)

This is the tree minimap in the sidebar of the meta diagram of [A pipeline step only names a command that a developer can run locally][8],
which explains [ADR-FLOW-CD-RUNNER][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the
decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 7 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 31
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][3], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 56 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][4], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 98 (text).

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
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 98 (text).

## Keywords

- [world map][9]
- [track][10]
- [file language][11]
- [cell][12]
- [lit cell][13]
- [.claude][14]: a track
- [automation][14]: a track
- [docs][14]: a track
- [pipelines][14]: a track
- [markdown][15]: a file language
- [pipeline-yaml][15]: a file language
- [yaml][15]: a file language

[1]: ../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../adr/flow/dora-explains.md
[3]: ../../../../.claude/CLAUDE.md
[4]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[5]: ../../../adr/index.md
[6]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[7]: ../../../../pipelines/ci-automation.yaml
[8]: ../../flow/a-step-only-names-a-command.md
[9]: ../../../adr/glossary.md#world-map
[10]: ../../../adr/glossary.md#track
[11]: ../../../adr/glossary.md#file-language
[12]: ../../../adr/glossary.md#cell
[13]: ../../../adr/glossary.md#lit-cell
[14]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[15]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

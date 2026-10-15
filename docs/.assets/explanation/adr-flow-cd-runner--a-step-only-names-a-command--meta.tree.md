# docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md

`Tree minimap: adr-flow-cd-runner--a-step-only-names-a-command--meta`

![Tree minimap of adr-flow-cd-runner--a-step-only-names-a-command--meta](adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--a-step-only-names-a-command--meta` (meta lens). The slide supports
[ADR-FLOW-CD-RUNNER][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 6 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 33
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][3], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][4], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 119 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/steps/invoke-automation.yaml][6], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 18 (header).

## Keywords

- [world map][7]
- [track][8]
- [file language][9]
- [cell][10]
- [lit cell][11]
- [.claude][12]: a track
- [automation][12]: a track
- [docs][12]: a track
- [pipelines][12]: a track
- [markdown][13]: a file language
- [pipeline-yaml][13]: a file language
- [yaml][13]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/flow/dora-explains.md
[3]: ../../../.claude/CLAUDE.md
[4]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[5]: ../../adr/index.md
[6]: ../../../pipelines/steps/invoke-automation.yaml
[7]: ../../adr/glossary.md#world-map
[8]: ../../adr/glossary.md#track
[9]: ../../adr/glossary.md#file-language
[10]: ../../adr/glossary.md#cell
[11]: ../../adr/glossary.md#lit-cell
[12]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[13]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

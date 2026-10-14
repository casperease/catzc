# docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md

`Tree minimap: adr-flow-cd-runner--the-step-is-named-after-its-command--operations`

![Tree minimap of adr-flow-cd-runner--the-step-is-named-after-its-command--operations](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--the-step-is-named-after-its-command--operations` (operations lens). The slide supports
[ADR-FLOW-CD-RUNNER][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 15 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/flow (docs/adr/flow): 6 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow`
  ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### docs (5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/flow/a-step-only-names-a-command.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 14 (text), line 41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 15 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 17 (text), line 57 (text), line 58 (text) and line 59 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][12], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 119 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/steps/invoke-automation.yaml][15], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 18 (header).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [.claude][21]: a track
- [automation][21]: a track
- [docs][21]: a track
- [pipelines][21]: a track
- [markdown][22]: a file language
- [pipeline-yaml][22]: a file language
- [yaml][22]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/flow/dora-explains.md
[4]: ../../adr/flow/durable-sha-globs.md
[5]: ../../adr/flow/pipeline-detection.md
[6]: ../../adr/flow/pipeline-types.md
[7]: ../../explanation/flow/a-step-only-names-a-command.md
[8]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[9]: ../../explanation/flow/the-runner-is-the-only-seam.md
[10]: ../../explanation/flow/the-step-is-named-after-its-command.md
[11]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[12]: ../../../.claude/CLAUDE.md
[13]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../adr/index.md
[15]: ../../../pipelines/steps/invoke-automation.yaml
[16]: ../../adr/glossary.md#world-map
[17]: ../../adr/glossary.md#track
[18]: ../../adr/glossary.md#file-language
[19]: ../../adr/glossary.md#cell
[20]: ../../adr/glossary.md#lit-cell
[21]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

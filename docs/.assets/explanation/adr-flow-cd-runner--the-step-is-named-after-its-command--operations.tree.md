# docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md

`Tree minimap: adr-flow-cd-runner--the-step-is-named-after-its-command--operations`

![Tree minimap of adr-flow-cd-runner--the-step-is-named-after-its-command--operations](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--the-step-is-named-after-its-command--operations` (operations lens). The slide supports
[ADR-FLOW-CD-RUNNER][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 35 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 25 lit files
- adr/flow (docs/adr/flow): 6 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (25 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md][2], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md][4], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text), line 46
  (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text),
  line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md][5], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37
  (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md][6], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text) and line 29 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md][8], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 52 (text), line 64 (text), line 67 (text),
  line 70 (text), line 72 (text), line 74 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85
  (text), line 87 (text), line 99 (text), line 101 (text), line 104 (text), line 106 (text), line 108 (text) and line 118 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md][9], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 39 (text), line 41 (text),
  line 43 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 53 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 72 (text), line 121 (text), line 128 (text), line 134 (text) and line 148 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md][10], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md][11], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md][12], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md][13], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md][14], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md][15], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md][16], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md][17], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md][18], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md][19], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md][20], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 28 (text), line 35 (text), line 42 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text) and line 81 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md][21], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text),
  line 38 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 64 (text), line 71 (text), line 77 (text), line 84 (text) and line 90 (text).
- [docs/explanation/flow/a-step-only-names-a-command.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 14 (text), line 41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][23], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][24], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 15 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][26], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 17 (text), line 57 (text), line 58 (text) and line 59 (text).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][27], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][28], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][29], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow`
  ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][32], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][33], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 119 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/steps/invoke-automation.yaml][35], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 18 (header).

## Keywords

- [world map][36]
- [track][37]
- [file language][38]
- [cell][39]
- [lit cell][40]
- [.claude][41]: a track
- [automation][41]: a track
- [docs][41]: a track
- [pipelines][41]: a track
- [markdown][42]: a file language
- [pipeline-yaml][42]: a file language
- [yaml][42]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
[3]: adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md
[4]: adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
[5]: adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md
[6]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
[7]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md
[8]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
[9]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md
[10]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
[11]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md
[12]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
[13]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md
[14]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
[15]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md
[16]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
[17]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md
[18]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md
[19]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md
[20]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
[21]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md
[22]: ../../explanation/flow/a-step-only-names-a-command.md
[23]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[24]: ../../explanation/flow/the-runner-is-the-only-seam.md
[25]: ../../explanation/flow/the-step-is-named-after-its-command.md
[26]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[27]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[28]: ../../adr/flow/dora-explains.md
[29]: ../../adr/flow/durable-sha-globs.md
[30]: ../../adr/flow/pipeline-detection.md
[31]: ../../adr/flow/pipeline-types.md
[32]: ../../../.claude/CLAUDE.md
[33]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../adr/index.md
[35]: ../../../pipelines/steps/invoke-automation.yaml
[36]: ../../adr/glossary.md#world-map
[37]: ../../adr/glossary.md#track
[38]: ../../adr/glossary.md#file-language
[39]: ../../adr/glossary.md#cell
[40]: ../../adr/glossary.md#lit-cell
[41]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[42]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

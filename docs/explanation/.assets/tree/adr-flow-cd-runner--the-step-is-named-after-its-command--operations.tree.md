# docs/explanation/.assets/tree/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md

`Tree minimap: adr-flow-cd-runner--the-step-is-named-after-its-command--operations`

![Tree minimap of adr-flow-cd-runner--the-step-is-named-after-its-command--operations](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.png)

The tree minimap of the slide `adr-flow-cd-runner--the-step-is-named-after-its-command--operations` (operations lens). The slide supports
[ADR-FLOW-CD-RUNNER][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 12 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 5 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][2], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites
  it at line 109 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][3], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 13 (text), line 254 (text) and line 277 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][4], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 55 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][5], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 95 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][6], in the cell .unordered × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 79 (text) and line 106 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 63
  (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][8], in the cell .claude × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 51 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9], in the cell automation × yaml: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at
  line 116 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 128 (text).

### docs (docs/ outside docs/adr/, 1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pipelines/steps/invoke-automation.yaml.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 44 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][12], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text).

## Keywords

- [world map][13]
- [track][14]
- [file language][15]
- [cell][16]
- [lit cell][17]
- [.claude][18]: a track
- [.unordered][18]: a track
- [automation][18]: a track
- [docs][18]: a track
- [pipelines][18]: a track
- [markdown][19]: a file language
- [pipeline-yaml][19]: a file language
- [yaml][19]: a file language

[1]: ../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[3]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[4]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[5]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[6]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[7]: ../../../adr/flow/dora-explains.md
[8]: ../../../../.claude/CLAUDE.md
[9]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../../adr/index.md
[11]: ../../../references/pipelines/steps/invoke-automation.yaml.md
[12]: ../../../../pipelines/ci-automation.yaml
[13]: ../../../adr/glossary.md#world-map
[14]: ../../../adr/glossary.md#track
[15]: ../../../adr/glossary.md#file-language
[16]: ../../../adr/glossary.md#cell
[17]: ../../../adr/glossary.md#lit-cell
[18]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[19]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

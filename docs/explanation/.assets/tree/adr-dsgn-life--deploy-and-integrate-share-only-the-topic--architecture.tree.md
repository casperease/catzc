# docs/explanation/.assets/tree/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md

`Tree minimap: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture`

![Tree minimap of adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture](adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture` (architecture lens). The slide
supports [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]; the highlight of those ADR codes selects what is lit, and each reason below names the
code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 17 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 4 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- adr/dsgn (docs/adr/design): 3 lit files
- .claude: 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- Git (automation/Catzc.Base.Git): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (4 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][3], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 100 (text), line 183 (text) and line 268 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 46 (text), line 108
  (text), line 184 (text) and line 268 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][4], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 91 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 90 (text).
- [.unordered/15-10-2026/plan-diagram-wave-7.md][5], in the cell .unordered × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it
  at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][6], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 84 (text), line 86 (text), line 86 (text), line 97 (text), line 99 (text), line 101 (text) and line 101 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 83 (text), line 83 (text), line 102 (text) and line 102 (text).

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][7], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  96 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 95 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][8], in the cell automation × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites it at
  line 47 (text), line 47 (body comment), line 53 (text) and line 58 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][9], in the cell automation × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites
  it at line 73 (text), line 78 (text), line 83 (text), line 83 (body comment) and line 88 (text).

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 122 (text);
  selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 103 (text).
- [docs/adr/design/visual-design.md][2], in the cell docs × markdown: selected by [ADR-DSGN-VISUAL][2]: the ADR's own file.

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-minimal-robots-agents.md][11], in the cell .claude × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it at
  line 27 (text) and line 66 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][12], in the cell .claude × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites
  it at line 26 (text), line 90 (text) and line 133 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][13], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 218 (text).
- [docs/adr/index.md][14], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 110 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 109 (text).

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/Push-Dirty.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 21 (header) and line 26 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][16], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 69 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][17], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 96 (text),
  `automation/Catzc.Base.Git/Push-Dirty.ps1` line 21 (header), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 26 (header) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 69 (text); selected by [ADR-DSGN-VISUAL][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 95 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 47 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 47 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 53 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 58 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 73 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 78
  (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 83 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line
  83 (body comment) and `automation/Catzc.Base.Docs/configs/capabilities.yml` line 88 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [.claude][23]: a track
- [.unordered][23]: a track
- [automation][23]: a track
- [docs][23]: a track
- [pipelines][23]: a track
- [markdown][24]: a file language
- [pipeline-yaml][24]: a file language
- [powershell][24]: a file language
- [yaml][24]: a file language

Terms the cited ADRs define:

- [occupant][25], defined by [ADR-DSGN-LIFE#5][26]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/visual-design.md
[3]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[4]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[5]: ../../../../.unordered/15-10-2026/plan-diagram-wave-7.md
[6]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[7]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[9]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[10]: ../../../adr/design/dora-explains.md
[11]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[12]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[13]: ../../../adr/glossary.md
[14]: ../../../adr/index.md
[15]: ../../../../automation/Catzc.Base.Git/Push-Dirty.ps1
[16]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[17]: ../../../../pipelines/ci-automation.yaml
[18]: ../../../adr/glossary.md#world-map
[19]: ../../../adr/glossary.md#track
[20]: ../../../adr/glossary.md#file-language
[21]: ../../../adr/glossary.md#cell
[22]: ../../../adr/glossary.md#lit-cell
[23]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[25]: ../../../adr/glossary.md#occupant
[26]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

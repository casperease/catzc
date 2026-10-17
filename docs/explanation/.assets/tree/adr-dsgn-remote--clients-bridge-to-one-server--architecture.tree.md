# docs/explanation/.assets/tree/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md

`Tree minimap: adr-dsgn-remote--clients-bridge-to-one-server--architecture`

![Tree minimap of adr-dsgn-remote--clients-bridge-to-one-server--architecture](adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-remote--clients-bridge-to-one-server--architecture` (architecture lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-DSGN-REMOTE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 12 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 3 lit files
- adr/dsgn (docs/adr/design): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Git (automation/Catzc.Base.Git): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (3 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][3], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 100 (text), line 183 (text) and line 268 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][4], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 91 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 92 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][5], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 84 (text), line 86 (text), line 86 (text), line 97 (text), line 99 (text), line 101 (text) and line 101 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text).

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 122 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 143 (text).
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 218 (text).
- [docs/adr/index.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 110 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 111 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  96 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 97 (text).

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/Push-Dirty.ps1][10], in the cell automation × powershell: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 21 (header) and line 26 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][11], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 69 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][12], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 96 (text),
  `automation/Catzc.Base.Git/Push-Dirty.ps1` line 21 (header), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 26 (header) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 69 (text); selected by [ADR-DSGN-REMOTE][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text).

## Keywords

- [world map][13]
- [track][14]
- [file language][15]
- [cell][16]
- [lit cell][17]
- [.unordered][18]: a track
- [automation][18]: a track
- [docs][18]: a track
- [pipelines][18]: a track
- [markdown][19]: a file language
- [pipeline-yaml][19]: a file language
- [powershell][19]: a file language
- [yaml][19]: a file language

Terms the cited ADRs define:

- [occupant][20], defined by [ADR-DSGN-LIFE#5][21]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/design/server-remote-integration.md
[3]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[4]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[5]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[6]: ../../../adr/design/dora-explains.md
[7]: ../../../adr/glossary.md
[8]: ../../../adr/index.md
[9]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../../../automation/Catzc.Base.Git/Push-Dirty.ps1
[11]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[12]: ../../../../pipelines/ci-automation.yaml
[13]: ../../../adr/glossary.md#world-map
[14]: ../../../adr/glossary.md#track
[15]: ../../../adr/glossary.md#file-language
[16]: ../../../adr/glossary.md#cell
[17]: ../../../adr/glossary.md#lit-cell
[18]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[19]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[20]: ../../../adr/glossary.md#occupant
[21]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

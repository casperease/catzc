# docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md

`Tree minimap: adr-flow-cd--a-merge-runs-cd-to-prod--operations`

![Tree minimap of adr-flow-cd--a-merge-runs-cd-to-prod--operations](adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.png)

The tree minimap of the slide `adr-flow-cd--a-merge-runs-cd-to-prod--operations` (operations lens). The slide supports [ADR-FLOW-CD][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 17 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/flow (docs/adr/flow): 6 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.

### Docs (3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][7], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][8], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][9], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 41 (body comment) (a passing mention only).

### Maps (3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][12], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 70 (text) and line 71 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305
  (text).
- [docs/adr/index.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][15], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][16], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 21 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][17], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 62 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [.claude][23]: a track
- [automation][23]: a track
- [docs][23]: a track
- [csharp][24]: a file language
- [markdown][24]: a file language
- [powershell][24]: a file language
- [yaml][24]: a file language

Terms the cited ADRs define:

- [gate][25], defined by [ADR-FLOW-CD#13][26]
- [release candidate][27], defined by [ADR-FLOW-CD#14][28]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/flow/dora-explains.md
[3]: ../../adr/flow/durable-sha-globs.md
[4]: ../../adr/flow/pipeline-detection.md
[5]: ../../adr/flow/pipeline-runner-pattern.md
[6]: ../../adr/flow/pipeline-types.md
[7]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[9]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[10]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[11]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[12]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[13]: ../../adr/glossary.md
[14]: ../../adr/index.md
[15]: ../../../.claude/CLAUDE.md
[16]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[17]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[18]: ../../adr/glossary.md#world-map
[19]: ../../adr/glossary.md#track
[20]: ../../adr/glossary.md#file-language
[21]: ../../adr/glossary.md#cell
[22]: ../../adr/glossary.md#lit-cell
[23]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[25]: ../../adr/glossary.md#gate
[26]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[27]: ../../adr/glossary.md#release-candidate
[28]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

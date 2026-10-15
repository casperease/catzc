# docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md

`Tree minimap: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation`

![Tree minimap of adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.png)

The tree minimap of the slide `adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation` (implementation lens). The slide
supports [ADR-FLOW-CD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 13 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][2], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][3], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][4], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 41 (body comment) (a passing mention only).

### Maps (automation/Catzc.Base.Maps, 3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][5], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 70 (text) and line 71 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305
  (text).
- [docs/adr/index.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 13 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][11], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][12], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 21 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][13], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 62 (text).

## Keywords

- [world map][14]
- [track][15]
- [file language][16]
- [cell][17]
- [lit cell][18]
- [.claude][19]: a track
- [automation][19]: a track
- [docs][19]: a track
- [csharp][20]: a file language
- [markdown][20]: a file language
- [powershell][20]: a file language
- [yaml][20]: a file language

Terms the cited ADRs define:

- [gate][21], defined by [ADR-FLOW-CD#13][22]
- [release candidate][23], defined by [ADR-FLOW-CD#14][24]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[3]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[4]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[5]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[6]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[7]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[8]: ../../adr/glossary.md
[9]: ../../adr/index.md
[10]: ../../adr/flow/dora-explains.md
[11]: ../../../.claude/CLAUDE.md
[12]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[13]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[14]: ../../adr/glossary.md#world-map
[15]: ../../adr/glossary.md#track
[16]: ../../adr/glossary.md#file-language
[17]: ../../adr/glossary.md#cell
[18]: ../../adr/glossary.md#lit-cell
[19]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[20]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[21]: ../../adr/glossary.md#gate
[22]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[23]: ../../adr/glossary.md#release-candidate
[24]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

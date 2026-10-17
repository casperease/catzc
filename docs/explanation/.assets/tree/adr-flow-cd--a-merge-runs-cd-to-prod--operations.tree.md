# docs/explanation/.assets/tree/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md

`Tree minimap: adr-flow-cd--a-merge-runs-cd-to-prod--operations`

![Tree minimap of adr-flow-cd--a-merge-runs-cd-to-prod--operations](adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.png)

The tree minimap of the slide `adr-flow-cd--a-merge-runs-cd-to-prod--operations` (operations lens). The slide supports [ADR-FLOW-CD][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 22 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 5 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- docs (docs/ outside docs/adr/): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][2], in the cell .unordered × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 44 (text), line 99 (text), line 152 (text), line 173 (text), line 178 (text), line 183 (text), line 291 (text) and line 291 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][3], in the cell .unordered × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 13 (text), line 255 (text) and line 277 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][4], in the cell .unordered × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 16 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][5], in the cell .unordered × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 22 (text), line 23 (text) and line 24 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][6], in the cell .unordered × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 97 (text).

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][7], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  115 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][8], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 26 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][9], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 23 (text).

### Maps (automation/Catzc.Base.Maps, 3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 22 (header) and line 41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 21 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][12], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 20 (header), line 93 (text) and line 94 (text).

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 58 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 50 (text), line 51 (text), line 79 (text) and line 80 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 20 (text) and line 57 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 415 (text) and line 428
  (text).
- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 127 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 43 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][19], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 50 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][20], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 38 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][21], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 77 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][22], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 115 (text),
  `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 26 (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 23 (text),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 22 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line
  41 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 38 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 77 (text).

## Keywords

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [.claude][28]: a track
- [.unordered][28]: a track
- [automation][28]: a track
- [docs][28]: a track
- [pipelines][28]: a track
- [csharp][29]: a file language
- [markdown][29]: a file language
- [pipeline-yaml][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

Terms the cited ADRs define:

- [gate][30], defined by [ADR-FLOW-CD#13][31]
- [release candidate][32], defined by [ADR-FLOW-CD#14][33]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[3]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[4]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[5]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[6]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[7]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[9]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[10]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[11]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[12]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[13]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[14]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[15]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[16]: ../../../adr/glossary.md
[17]: ../../../adr/index.md
[18]: ../../../adr/flow/dora-explains.md
[19]: ../../../../.claude/CLAUDE.md
[20]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[21]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[22]: ../../../../pipelines/ci-automation.yaml
[23]: ../../../adr/glossary.md#world-map
[24]: ../../../adr/glossary.md#track
[25]: ../../../adr/glossary.md#file-language
[26]: ../../../adr/glossary.md#cell
[27]: ../../../adr/glossary.md#lit-cell
[28]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[30]: ../../../adr/glossary.md#gate
[31]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[32]: ../../../adr/glossary.md#release-candidate
[33]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

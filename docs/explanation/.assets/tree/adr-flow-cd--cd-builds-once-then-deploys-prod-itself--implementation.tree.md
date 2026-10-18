---
catzc:
  immutable:
    with_body_sha: cbd4f64c67f6
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
    source: docs/explanation/.assets/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The customer CD pipeline builds once, then deploys the prod tier itself: the tree minimap

```text
Which files cite ADR-FLOW-CD: every file of the world map is a tile, grouped by top-level folder.
17 files lit in 9 groups.
```

![The tree minimap of The customer CD pipeline builds once, then deploys the prod tier itself](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [The customer CD pipeline builds once, then deploys the prod tier
itself][18], which explains [ADR-FLOW-CD][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 17 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

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

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][2], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  116 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][3], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 28 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][4], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 23 (text).

### Maps (automation/Catzc.Base.Maps, 3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][5], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 22 (header) and line 41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 21 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 20 (header), line 93 (text) and line 94 (text).

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 59 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 51 (text), line 52 (text), line 80 (text) and line 81 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 20 (text) and line 57 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 497 (text) and line 510
  (text).
- [docs/adr/index.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 42 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][14], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 52 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][15], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 37 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][16], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 77 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][17], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text),
  `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 28 (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 23 (text),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 22 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line
  41 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 21 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 37 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 77 (text).

## Keywords

- [world map][19]
- [track][20]
- [file language][21]
- [cell][22]
- [lit cell][23]
- [.claude][24]: a track
- [automation][24]: a track
- [docs][24]: a track
- [pipelines][24]: a track
- [csharp][25]: a file language
- [markdown][25]: a file language
- [pipeline-yaml][25]: a file language
- [powershell][25]: a file language
- [yaml][25]: a file language

Terms the cited ADRs define:

- [gate][26], defined by [ADR-FLOW-CD#13][27]
- [release candidate][28], defined by [ADR-FLOW-CD#14][29]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[3]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[4]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[5]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[6]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[7]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[8]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[9]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[10]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[11]: ../../../adr/glossary.md
[12]: ../../../adr/index.md
[13]: ../../../adr/flow/dora-explains.md
[14]: ../../../../.claude/CLAUDE.md
[15]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[16]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[17]: ../../../../pipelines/ci-automation.yaml
[18]: ../../flow/cd-builds-once-then-deploys-prod-itself.md
[19]: ../../../adr/glossary.md#world-map
[20]: ../../../adr/glossary.md#track
[21]: ../../../adr/glossary.md#file-language
[22]: ../../../adr/glossary.md#cell
[23]: ../../../adr/glossary.md#lit-cell
[24]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[25]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[26]: ../../../adr/glossary.md#gate
[27]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[28]: ../../../adr/glossary.md#release-candidate
[29]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

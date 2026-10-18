# Upstream integrators depend on the main-UAT occupant, never on the tip of main: the tree minimap

```text
Which files cite ADR-DSGN-LIFE and ADR-FLOW-CD: every file of the world map is a tile, grouped by top-level folder.
22 files lit in 11 groups.
```

![The tree minimap of Upstream integrators depend on the main-UAT occupant, never on the tip of main](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Upstream integrators depend on the main-UAT occupant, never on the
tip of main][23], which explains [ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]. It lights every file that cites those codes, grouped by folder, so
it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 22 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- docs (docs/ outside docs/adr/): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- Git (automation/Catzc.Base.Git): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][3], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 52 (text).
- [.claude/plans/plan-fast-push-followups.md][4], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  26 (text) and line 47 (text).
- [.claude/plans/value-of-plan.md][5], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 22 (text)
  and line 63 (text).

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  97 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 116 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][7], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 28 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][8], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 23 (text).

### Maps (automation/Catzc.Base.Maps, 3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][9], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 22 (header) and line 41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 21 (header) and line 49 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 20 (header), line 93 (text) and line 94 (text).

### docs (docs/ outside docs/adr/, 3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 59 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 51 (text), line 52 (text), line 80 (text) and line 81 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 20 (text) and line 57 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][15], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 497 (text) and line 510 (text).
- [docs/adr/index.md][16], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 129 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 121 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 42 (text).

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/Push-Dirty.ps1][19], in the cell automation × powershell: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 21 (header) and line 26 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][20], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 68 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 37 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][21], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 77 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][22], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `automation/Catzc.Base.Git/Push-Dirty.ps1` line 21 (header), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 26 (header) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 68 (text); selected by [ADR-FLOW-CD][2]: a pipeline that cites nothing
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

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [.claude][29]: a track
- [automation][29]: a track
- [docs][29]: a track
- [pipelines][29]: a track
- [csharp][30]: a file language
- [markdown][30]: a file language
- [pipeline-yaml][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

Terms the cited ADRs define:

- [gate][31], defined by [ADR-FLOW-CD#13][32]
- [occupant][33], defined by [ADR-DSGN-LIFE#5][34]
- [release candidate][35], defined by [ADR-FLOW-CD#14][36]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../../../.claude/CLAUDE.md
[4]: ../../../../.claude/plans/plan-fast-push-followups.md
[5]: ../../../../.claude/plans/value-of-plan.md
[6]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[8]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[9]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[10]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[11]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[12]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[13]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[14]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[15]: ../../../adr/glossary.md
[16]: ../../../adr/index.md
[17]: ../../../adr/design/dora-explains.md
[18]: ../../../adr/flow/dora-explains.md
[19]: ../../../../automation/Catzc.Base.Git/Push-Dirty.ps1
[20]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[21]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[22]: ../../../../pipelines/ci-automation.yaml
[23]: ../../design/integrators-depend-on-an-occupant.md
[24]: ../../../adr/glossary.md#world-map
[25]: ../../../adr/glossary.md#track
[26]: ../../../adr/glossary.md#file-language
[27]: ../../../adr/glossary.md#cell
[28]: ../../../adr/glossary.md#lit-cell
[29]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[31]: ../../../adr/glossary.md#gate
[32]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[33]: ../../../adr/glossary.md#occupant
[34]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[35]: ../../../adr/glossary.md#release-candidate
[36]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

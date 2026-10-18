---
catzc:
  immutable:
    with_body_sha: fd5a42edeacb
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
15 files lit in 9 groups.
```

![The tree minimap of The customer CD pipeline builds once, then deploys the prod tier itself](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [The customer CD pipeline builds once, then deploys the prod tier
itself][16], which explains [ADR-FLOW-CD][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 15 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Maps (automation/Catzc.Base.Maps): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 40 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 34 (text).
- [docs/references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 37 (text).
- [docs/references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 54 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 497 (text) and line 510
  (text).
- [docs/adr/index.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][10], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][11], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  97 (text).

### Maps (automation/Catzc.Base.Maps, 1 lit file)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][12], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 70 (text) and line 71 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][13], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 18 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][14], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 58 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][15], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 58 (text).

## Keywords

- [world map][17]
- [track][18]
- [file language][19]
- [cell][20]
- [lit cell][21]
- [.claude][22]: a track
- [automation][22]: a track
- [docs][22]: a track
- [pipelines][22]: a track
- [markdown][23]: a file language
- [pipeline-yaml][23]: a file language
- [powershell][23]: a file language
- [yaml][23]: a file language

Terms the cited ADRs define:

- [gate][24], defined by [ADR-FLOW-CD#13][25]
- [release candidate][26], defined by [ADR-FLOW-CD#14][27]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[3]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[4]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[5]: ../../../references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[6]: ../../../references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[7]: ../../../adr/glossary.md
[8]: ../../../adr/index.md
[9]: ../../../adr/flow/dora-explains.md
[10]: ../../../../.claude/CLAUDE.md
[11]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[13]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[14]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[15]: ../../../../pipelines/ci-automation.yaml
[16]: ../../flow/cd-builds-once-then-deploys-prod-itself.md
[17]: ../../../adr/glossary.md#world-map
[18]: ../../../adr/glossary.md#track
[19]: ../../../adr/glossary.md#file-language
[20]: ../../../adr/glossary.md#cell
[21]: ../../../adr/glossary.md#lit-cell
[22]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[23]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[24]: ../../../adr/glossary.md#gate
[25]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[26]: ../../../adr/glossary.md#release-candidate
[27]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

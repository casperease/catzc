---
catzc:
  immutable:
    with_body_sha: "38f02b185c90"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md
    source: docs/explanation/.assets/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A merge to main runs the CD pipeline all the way to prod, with no approval: the tree minimap

```text
Which files cite ADR-FLOW-CD: every file of the world map is a tile, grouped by top-level folder.
15 files lit in 9 groups.
```

![The tree minimap of A merge to main runs the CD pipeline all the way to prod, with no approval](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [A merge to main runs the CD pipeline all the way to prod, with no
approval][16], which explains [ADR-FLOW-CD][1]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 15 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 40 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 54 (text).

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

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][11], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line 97
  (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][12], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 70 (text) and line 71 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][13], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 18 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][14], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 58 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][15], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1`
  line 71 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text) and `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`
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

[1]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[3]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[4]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[5]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[6]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[7]: ../../../../adr/glossary.md
[8]: ../../../../adr/index.md
[9]: ../../../../adr/flow/dora-explains.md
[10]: ../../../../../.claude/CLAUDE.md
[11]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[13]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[14]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[15]: ../../../../../pipelines/ci-automation.yaml
[16]: ../../a-merge-runs-cd-to-prod.md
[17]: ../../../../adr/glossary.md#world-map
[18]: ../../../../adr/glossary.md#track
[19]: ../../../../adr/glossary.md#file-language
[20]: ../../../../adr/glossary.md#cell
[21]: ../../../../adr/glossary.md#lit-cell
[22]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[23]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[24]: ../../../../adr/glossary.md#gate
[25]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[26]: ../../../../adr/glossary.md#release-candidate
[27]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

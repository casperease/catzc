# docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md

`Tree minimap: adr-flow-cd--a-merge-runs-cd-to-prod--operations`

![Tree minimap of adr-flow-cd--a-merge-runs-cd-to-prod--operations](adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.png)

The tree minimap of the slide `adr-flow-cd--a-merge-runs-cd-to-prod--operations` (operations lens). The slide supports [ADR-FLOW-CD][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 28 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 10 lit files
- adr/flow (docs/adr/flow): 6 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- .claude: 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 55 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][13], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.

### Docs (3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][18], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][19], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Maps (3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][20], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][21], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][22], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 70 (text) and line 71 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][23], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][24], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305
  (text).
- [docs/adr/index.md][26], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][27], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 21 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][28], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 62 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [.claude][34]: a track
- [automation][34]: a track
- [docs][34]: a track
- [csharp][35]: a file language
- [markdown][35]: a file language
- [powershell][35]: a file language
- [yaml][35]: a file language

Terms the cited ADRs define:

- [gate][36], defined by [ADR-FLOW-CD#13][37]
- [release candidate][38], defined by [ADR-FLOW-CD#14][39]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[3]: ../../explanation/design/four-domains-promote-one-artifact.md
[4]: ../../explanation/design/integrators-depend-on-an-occupant.md
[5]: ../../explanation/design/sync-point-rules-are-adr-only.md
[6]: ../../explanation/design/which-rung-gates-exist-in-code.md
[7]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[8]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[9]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[10]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[11]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[12]: ../../adr/flow/dora-explains.md
[13]: ../../adr/flow/durable-sha-globs.md
[14]: ../../adr/flow/pipeline-detection.md
[15]: ../../adr/flow/pipeline-runner-pattern.md
[16]: ../../adr/flow/pipeline-types.md
[17]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[19]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[20]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[21]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[22]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[23]: ../../../.claude/CLAUDE.md
[24]: ../../../.claude/drawio/STYLE.md
[25]: ../../adr/glossary.md
[26]: ../../adr/index.md
[27]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[28]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[29]: ../../adr/glossary.md#world-map
[30]: ../../adr/glossary.md#track
[31]: ../../adr/glossary.md#file-language
[32]: ../../adr/glossary.md#cell
[33]: ../../adr/glossary.md#lit-cell
[34]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[35]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[36]: ../../adr/glossary.md#gate
[37]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[38]: ../../adr/glossary.md#release-candidate
[39]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

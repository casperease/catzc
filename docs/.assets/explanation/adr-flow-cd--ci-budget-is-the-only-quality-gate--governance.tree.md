# docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md

`Tree minimap: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance`

![Tree minimap of adr-flow-cd--ci-budget-is-the-only-quality-gate--governance](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.png)

The tree minimap of the slide `adr-flow-cd--ci-budget-is-the-only-quality-gate--governance` (governance lens). The slide supports
[ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 38 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 10 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 6 lit files
- adr/flow (docs/adr/flow): 6 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- .claude: 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- pipelines: 2 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 1 lit file
- Az.Templates (automation/Catzc.Azure.Templates): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 55 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 17 (text), line 51 (text), line 56 (text) and line 56
  (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### Az.DevOps.BuildValidation (6 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][13], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 7 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][14], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 9 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][15], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 2 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][16], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][17], in the cell automation × csharp: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 3 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][18], in the cell automation × csharp: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 2 (header).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/dora-explains.md][19], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.

### Docs (3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][23], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites it at line
  105 (body comment) and line 118 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 121 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][24], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][25], in the cell automation × csharp: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Maps (3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][26], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][27], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][28], in the cell automation × powershell: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 70 (text) and line 71 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][29], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][30], in the cell .claude × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305
  (text).
- [docs/adr/index.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 110 (text).

### pipelines (2 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-shared.yaml][33], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 3
  (header).
- [pipelines/ci-infrastructure.yaml][34], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 4 (header).

### Az.DevOps (1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1][35], in the cell automation × powershell: selected by [ADR-FLOW-CD-TYPE][2]: the
  file cites it at line 5 (header).

### Az.Templates (1 lit file)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][36], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5 (header).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][37], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 21 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][38], in the cell automation × yaml: selected by [ADR-FLOW-CD][1]: the file cites
  it at line 62 (text).

## Keywords

- [world map][39]
- [track][40]
- [file language][41]
- [cell][42]
- [lit cell][43]
- [.claude][44]: a track
- [automation][44]: a track
- [docs][44]: a track
- [pipelines][44]: a track
- [csharp][45]: a file language
- [markdown][45]: a file language
- [pipeline-yaml][45]: a file language
- [powershell][45]: a file language
- [yaml][45]: a file language

Terms the cited ADRs define:

- [gate][46], defined by [ADR-FLOW-CD#13][47]
- [release candidate][48], defined by [ADR-FLOW-CD#14][49]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/flow/pipeline-types.md
[3]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[4]: ../../explanation/design/four-domains-promote-one-artifact.md
[5]: ../../explanation/design/integrators-depend-on-an-occupant.md
[6]: ../../explanation/design/sync-point-rules-are-adr-only.md
[7]: ../../explanation/design/which-rung-gates-exist-in-code.md
[8]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[9]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[10]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[11]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[12]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[13]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[14]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[15]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[16]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[17]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[18]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[19]: ../../adr/flow/dora-explains.md
[20]: ../../adr/flow/durable-sha-globs.md
[21]: ../../adr/flow/pipeline-detection.md
[22]: ../../adr/flow/pipeline-runner-pattern.md
[23]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[25]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[26]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[27]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[28]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[29]: ../../../.claude/CLAUDE.md
[30]: ../../../.claude/drawio/STYLE.md
[31]: ../../adr/glossary.md
[32]: ../../adr/index.md
[33]: ../../../pipelines/cd-shared.yaml
[34]: ../../../pipelines/ci-infrastructure.yaml
[35]: ../../../automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
[36]: ../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[37]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[38]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[39]: ../../adr/glossary.md#world-map
[40]: ../../adr/glossary.md#track
[41]: ../../adr/glossary.md#file-language
[42]: ../../adr/glossary.md#cell
[43]: ../../adr/glossary.md#lit-cell
[44]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[45]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[46]: ../../adr/glossary.md#gate
[47]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[48]: ../../adr/glossary.md#release-candidate
[49]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

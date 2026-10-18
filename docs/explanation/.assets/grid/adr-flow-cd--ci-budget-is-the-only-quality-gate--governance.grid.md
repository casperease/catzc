# The CI budget is the only promotion rule a quality gate checks: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD and ADR-FLOW-CD-TYPE sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 31 files.
```

![The world-map minimap of The CI budget is the only promotion rule a quality gate checks](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [The CI budget is the only promotion rule a quality gate
checks][35], which explains [ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 91 files
- automation × csharp: 4 lit of 286 files
- automation × powershell: 8 lit of 1619 files
- automation × yaml: 3 lit of 112 files
- docs × markdown: 13 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 52 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 565 (text) and line 568
  (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][8]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 22 (text).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][9]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 22 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 23 (text).

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][12]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 21 (header) and line 27 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][13]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it
  at line 23 (header) and line 31 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][14]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 21 (header) and line 32 (header).
- [automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1][15]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 22 (header) and
  line 26 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][16]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 23
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 22 (header) and line
  41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (header) and line
  49 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20
  (header), line 93 (text) and line 94 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 116 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 119 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 37 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 77 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 42 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 98 (text).
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD-TYPE][2]: the ADR's own file.
- [docs/adr/glossary.md][24]: selected by [ADR-FLOW-CD][1]: the file cites it at line 497 (text) and line 510 (text).
- [docs/adr/index.md][25]: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 132 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][26]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][27]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][28]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 19 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][29]: selected by [ADR-FLOW-CD][1]: the file cites it at line 59 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][30]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51
  (text), line 52 (text), line 80 (text) and line 81 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][31]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20
  (text) and line 57 (text).
- [docs/references/pipelines/cd-shared.yaml.md][32]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][33]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 32 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][34]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 28
  (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 23 (text), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1`
  line 22 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 41 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 21 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49
  (header), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 37 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 77 (text); selected by [ADR-FLOW-CD-TYPE][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 27 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 23 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 31 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 32 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs` line 22 (text),
  `automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs` line 22 (text),
  `automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1` line 22 (header), `automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1` line 26
  (header), `automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1` line 23 (header) and
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 119 (text).

## Keywords

- [world map][36]
- [track][37]
- [file language][38]
- [cell][39]
- [lit cell][40]
- [.claude][41]: a track
- [automation][41]: a track
- [docs][41]: a track
- [pipelines][41]: a track
- [csharp][42]: a file language
- [markdown][42]: a file language
- [pipeline-yaml][42]: a file language
- [powershell][42]: a file language
- [yaml][42]: a file language

Terms the cited ADRs define:

- [gate][43], defined by [ADR-FLOW-CD#13][44]
- [release candidate][45], defined by [ADR-FLOW-CD#14][46]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../adr/flow/pipeline-types.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[9]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[10]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[11]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[12]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[13]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[14]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[15]: ../../../../automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
[16]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[17]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[18]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[19]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[20]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[22]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[23]: ../../../adr/flow/dora-explains.md
[24]: ../../../adr/glossary.md
[25]: ../../../adr/index.md
[26]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[27]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[28]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[29]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[30]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[31]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[32]: ../../../references/pipelines/cd-shared.yaml.md
[33]: ../../../references/pipelines/ci-infrastructure.yaml.md
[34]: ../../../../pipelines/ci-automation.yaml
[35]: ../../flow/ci-budget-is-the-only-quality-gate.md
[36]: ../../../adr/glossary.md#world-map
[37]: ../../../adr/glossary.md#track
[38]: ../../../adr/glossary.md#file-language
[39]: ../../../adr/glossary.md#cell
[40]: ../../../adr/glossary.md#lit-cell
[41]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[42]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[43]: ../../../adr/glossary.md#gate
[44]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[45]: ../../../adr/glossary.md#release-candidate
[46]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

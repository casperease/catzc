# docs/.assets/explanation/grid/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md

`Grid minimap: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance`

![Grid minimap of adr-flow-cd--ci-budget-is-the-only-quality-gate--governance](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.png)

The grid minimap of the slide `adr-flow-cd--ci-budget-is-the-only-quality-gate--governance` (governance lens). The slide supports
[ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 71 files
- .unordered × markdown: 5 lit of 20 files
- automation × csharp: 4 lit of 274 files
- automation × powershell: 8 lit of 1579 files
- automation × yaml: 3 lit of 109 files
- docs × markdown: 13 lit of 2165 files
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

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 50 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 555 (text) and line 558
  (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 44 (text), line 99 (text),
  line 152 (text), line 173 (text), line 178 (text), line 183 (text), line 291 (text) and line 291 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 174 (text) and line 294 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 13 (text), line 255 (text) and
  line 277 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 22 (text), line 23 (text) and
  line 24 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][13]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it
  at line 22 (text).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][14]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 22 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][15]: selected by [ADR-FLOW-CD][1]: the file cites it at line 26 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][16]: selected by [ADR-FLOW-CD][1]: the file cites it at line 23 (text).

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][17]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 21 (header) and line 27 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][18]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it
  at line 23 (header) and line 31 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][19]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 21 (header) and line 32 (header).
- [automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1][20]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 22 (header) and
  line 26 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][21]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 23
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 22 (header) and line
  41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (header) and line
  49 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][24]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20
  (header), line 93 (text) and line 94 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][25]: selected by [ADR-FLOW-CD][1]: the file cites it at line 115 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 118 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][26]: selected by [ADR-FLOW-CD][1]: the file cites it at line 38 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][27]: selected by [ADR-FLOW-CD][1]: the file cites it at line 77 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][28]: selected by [ADR-FLOW-CD][1]: the file cites it at line 43 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 99 (text).
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD-TYPE][2]: the ADR's own file.
- [docs/adr/glossary.md][29]: selected by [ADR-FLOW-CD][1]: the file cites it at line 415 (text) and line 428 (text).
- [docs/adr/index.md][30]: selected by [ADR-FLOW-CD][1]: the file cites it at line 127 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 130 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][31]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][32]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][33]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 19 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][34]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][35]: selected by [ADR-FLOW-CD][1]: the file cites it at line 50
  (text), line 51 (text), line 79 (text) and line 80 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][36]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20
  (text) and line 57 (text).
- [docs/references/pipelines/cd-shared.yaml.md][37]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][38]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 32 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][39]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 115 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 26
  (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 23 (text), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1`
  line 22 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 41 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 21 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49
  (header), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 38 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
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
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 118 (text).

## Keywords

- [world map][40]
- [track][41]
- [file language][42]
- [cell][43]
- [lit cell][44]
- [.claude][45]: a track
- [.unordered][45]: a track
- [automation][45]: a track
- [docs][45]: a track
- [pipelines][45]: a track
- [csharp][46]: a file language
- [markdown][46]: a file language
- [pipeline-yaml][46]: a file language
- [powershell][46]: a file language
- [yaml][46]: a file language

Terms the cited ADRs define:

- [gate][47], defined by [ADR-FLOW-CD#13][48]
- [release candidate][49], defined by [ADR-FLOW-CD#14][50]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../adr/flow/pipeline-types.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[9]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[10]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[11]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[12]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[13]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[14]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[15]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[16]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[17]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[18]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[19]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[20]: ../../../../automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
[21]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[22]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[23]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[24]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[25]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[26]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[27]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[28]: ../../../adr/flow/dora-explains.md
[29]: ../../../adr/glossary.md
[30]: ../../../adr/index.md
[31]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[32]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[33]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[34]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[35]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[36]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[37]: ../../../references/pipelines/cd-shared.yaml.md
[38]: ../../../references/pipelines/ci-infrastructure.yaml.md
[39]: ../../../../pipelines/ci-automation.yaml
[40]: ../../../adr/glossary.md#world-map
[41]: ../../../adr/glossary.md#track
[42]: ../../../adr/glossary.md#file-language
[43]: ../../../adr/glossary.md#cell
[44]: ../../../adr/glossary.md#lit-cell
[45]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[46]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[47]: ../../../adr/glossary.md#gate
[48]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[49]: ../../../adr/glossary.md#release-candidate
[50]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

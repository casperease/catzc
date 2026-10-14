# docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md

`Grid minimap: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance`

![Grid minimap of adr-flow-cd--ci-budget-is-the-only-quality-gate--governance](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.png)

The grid minimap of the slide `adr-flow-cd--ci-budget-is-the-only-quality-gate--governance` (governance lens). The slide supports
[ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × csharp: 4 lit of 229 files
- automation × powershell: 8 lit of 1443 files
- automation × yaml: 4 lit of 97 files
- docs × markdown: 8 lit of 744 files
- pipelines × pipeline-yaml: 2 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][7]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 3 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][8]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][11]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][12]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it
  at line 9 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][13]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 12 (header).
- [automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1][14]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][15]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][16]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][19]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 105 (body comment) and line 118
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 121 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 62 (text).

### docs × markdown (8 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][23]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][24]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][25]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][26]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][27]: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][28]: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 110 (text).

### pipelines × pipeline-yaml (2 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/cd-shared.yaml][29]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 3 (header).
- [pipelines/ci-infrastructure.yaml][30]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 4 (header).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.claude][36]: a track
- [automation][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [csharp][37]: a file language
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [powershell][37]: a file language
- [yaml][37]: a file language

Terms the cited ADRs define:

- [gate][38], defined by [ADR-FLOW-CD#13][39]
- [release candidate][40], defined by [ADR-FLOW-CD#14][41]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/flow/pipeline-types.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[8]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[9]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[10]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[11]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[12]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[13]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[14]: ../../../automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
[15]: ../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[16]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[17]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[18]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[19]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[20]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[22]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[23]: ../../adr/flow/dora-explains.md
[24]: ../../adr/flow/durable-sha-globs.md
[25]: ../../adr/flow/pipeline-detection.md
[26]: ../../adr/flow/pipeline-runner-pattern.md
[27]: ../../adr/glossary.md
[28]: ../../adr/index.md
[29]: ../../../pipelines/cd-shared.yaml
[30]: ../../../pipelines/ci-infrastructure.yaml
[31]: ../../adr/glossary.md#world-map
[32]: ../../adr/glossary.md#track
[33]: ../../adr/glossary.md#file-language
[34]: ../../adr/glossary.md#cell
[35]: ../../adr/glossary.md#lit-cell
[36]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[38]: ../../adr/glossary.md#gate
[39]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[40]: ../../adr/glossary.md#release-candidate
[41]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

# docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md

`Grid minimap: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance`

![Grid minimap of adr-flow-cd--ci-budget-is-the-only-quality-gate--governance](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.png)

The grid minimap of the slide `adr-flow-cd--ci-budget-is-the-only-quality-gate--governance` (governance lens). The slide supports
[ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 9 files
- automation × csharp: 4 lit of 219 files
- automation × powershell: 8 lit of 1412 files
- automation × yaml: 4 lit of 95 files
- docs × markdown: 18 lit of 742 files
- pipelines × pipeline-yaml: 2 lit of 9 files

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

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][8]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 3 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][9]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][12]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][13]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it
  at line 9 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][14]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 12 (header).
- [automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1][15]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][16]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][20]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 105 (body comment) and line 118
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 121 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 62 (text).

### docs × markdown (18 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][24]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][25]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][26]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][27]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][28]: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][29]: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 110 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][30]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][31]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][32]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 50 (text) and line 51 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][33]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text), line 34
  (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][34]: selected by [ADR-FLOW-CD][1]: the file cites it at line 60 (text), line
  60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][35]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text), line 48 (text),
  line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][36]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][37]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text), line
  47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 17 (text), line 51 (text), line 56 (text) and line 56 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][38]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][39]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### pipelines × pipeline-yaml (2 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/cd-shared.yaml][40]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 3 (header).
- [pipelines/ci-infrastructure.yaml][41]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 4 (header).

## Keywords

- [world map][42]
- [track][43]
- [file language][44]
- [cell][45]
- [lit cell][46]
- [.claude][47]: a track
- [automation][47]: a track
- [docs][47]: a track
- [pipelines][47]: a track
- [csharp][48]: a file language
- [markdown][48]: a file language
- [pipeline-yaml][48]: a file language
- [powershell][48]: a file language
- [yaml][48]: a file language

Terms the cited ADRs define:

- [gate][49], defined by [ADR-FLOW-CD#13][50]
- [release candidate][51], defined by [ADR-FLOW-CD#14][52]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/flow/pipeline-types.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../.claude/drawio/STYLE.md
[8]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[9]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[10]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[11]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[12]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[13]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[14]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[15]: ../../../automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
[16]: ../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[17]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[18]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[19]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[20]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[21]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[23]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[24]: ../../adr/flow/dora-explains.md
[25]: ../../adr/flow/durable-sha-globs.md
[26]: ../../adr/flow/pipeline-detection.md
[27]: ../../adr/flow/pipeline-runner-pattern.md
[28]: ../../adr/glossary.md
[29]: ../../adr/index.md
[30]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[31]: ../../explanation/design/four-domains-promote-one-artifact.md
[32]: ../../explanation/design/integrators-depend-on-an-occupant.md
[33]: ../../explanation/design/sync-point-rules-are-adr-only.md
[34]: ../../explanation/design/which-rung-gates-exist-in-code.md
[35]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[36]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[37]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[38]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[39]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[40]: ../../../pipelines/cd-shared.yaml
[41]: ../../../pipelines/ci-infrastructure.yaml
[42]: ../../adr/glossary.md#world-map
[43]: ../../adr/glossary.md#track
[44]: ../../adr/glossary.md#file-language
[45]: ../../adr/glossary.md#cell
[46]: ../../adr/glossary.md#lit-cell
[47]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[48]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[49]: ../../adr/glossary.md#gate
[50]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[51]: ../../adr/glossary.md#release-candidate
[52]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

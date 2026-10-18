# The CI budget is the only promotion rule a quality gate checks: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD and ADR-FLOW-CD-TYPE sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 27 files.
```

![The world-map minimap of The CI budget is the only promotion rule a quality gate checks](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [The CI budget is the only promotion rule a quality gate
checks][31], which explains [ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 90 files
- automation × powershell: 1 lit of 1629 files
- automation × yaml: 3 lit of 112 files
- docs × markdown: 20 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 546 (text) and line 549
  (text).

### automation × powershell (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 100 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 18 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text).

### docs × markdown (20 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 67 (text).
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD-TYPE][2]: the ADR's own file.
- [docs/adr/glossary.md][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 497 (text) and line 510 (text).
- [docs/adr/index.md][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 132 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][15]: selected by [ADR-FLOW-CD-TYPE][2]: the
  file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][16]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 16 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][17]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 12 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][18]: selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md][19]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 13 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][20]: selected by [ADR-FLOW-CD-TYPE][2]:
  the file cites it at line 12 (text).
- [docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md][21]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 14 (text).
- [docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][22]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 26 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 40 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][24]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28
  (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][25]: selected by [ADR-FLOW-CD][1]: the file cites it at line 34
  (text).
- [docs/references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md][26]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  37 (text).
- [docs/references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md][27]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][28]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][29]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 12 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][30]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 58 (text); selected by [ADR-FLOW-CD-TYPE][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 100 (text).

## Keywords

- [world map][32]
- [track][33]
- [file language][34]
- [cell][35]
- [lit cell][36]
- [.claude][37]: a track
- [automation][37]: a track
- [docs][37]: a track
- [pipelines][37]: a track
- [markdown][38]: a file language
- [pipeline-yaml][38]: a file language
- [powershell][38]: a file language
- [yaml][38]: a file language

Terms the cited ADRs define:

- [gate][39], defined by [ADR-FLOW-CD#13][40]
- [release candidate][41], defined by [ADR-FLOW-CD#14][42]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../adr/flow/pipeline-types.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[9]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[11]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[12]: ../../../adr/flow/dora-explains.md
[13]: ../../../adr/glossary.md
[14]: ../../../adr/index.md
[15]: ../../../references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[16]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[17]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[18]: ../../../references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[19]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md
[20]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[21]: ../../../references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md
[22]: ../../../references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[23]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[24]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[25]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[26]: ../../../references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[27]: ../../../references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[28]: ../../../references/pipelines/cd-shared.yaml.md
[29]: ../../../references/pipelines/ci-infrastructure.yaml.md
[30]: ../../../../pipelines/ci-automation.yaml
[31]: ../../flow/ci-budget-is-the-only-quality-gate.md
[32]: ../../../adr/glossary.md#world-map
[33]: ../../../adr/glossary.md#track
[34]: ../../../adr/glossary.md#file-language
[35]: ../../../adr/glossary.md#cell
[36]: ../../../adr/glossary.md#lit-cell
[37]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[38]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[39]: ../../../adr/glossary.md#gate
[40]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[41]: ../../../adr/glossary.md#release-candidate
[42]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

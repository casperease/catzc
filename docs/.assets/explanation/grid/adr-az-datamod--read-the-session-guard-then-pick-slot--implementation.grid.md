# docs/.assets/explanation/grid/adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.grid.md

`Grid minimap: adr-az-datamod--read-the-session-guard-then-pick-slot--implementation`

![Grid minimap of adr-az-datamod--read-the-session-guard-then-pick-slot--implementation](adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.grid.png)

The grid minimap of the slide `adr-az-datamod--read-the-session-guard-then-pick-slot--implementation` (implementation lens). The slide
supports [ADR-AZ-DATAMOD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 51 files
- .unordered × markdown: 5 lit of 20 files
- automation × csharp: 4 lit of 272 files
- automation × powershell: 27 lit of 1563 files
- automation × yaml: 4 lit of 107 files
- docs × markdown: 23 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][5]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 134 (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][6]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 72 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][7]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 66 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][8]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text) and line 28
  (text).
- [.unordered/15-10-2026/plan-concern-axis.md][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 110 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 18
  (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure/types/AzureConfig.cs][11]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 23 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).

### automation × powershell (27 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and
  line 34 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and
  line 28 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line
  33 (header).
- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][20]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line
  33 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][21]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 19
  (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][22]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 45 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][23]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 29 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][24]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header),
  line 34 (header) and line 60 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][25]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][26]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 19 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 19
  (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][28]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 20 (header) and line 25 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  20 (header) and line 33 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 20 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 19
  (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 20 (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 20 (header) and line 29 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][34]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 20 (header), line 48 (text), line 54 (text), line 71 (text), line 77 (text), line 82 (text), line 88 (text), line 125 (text), line
  129 (text), line 129 (body comment), line 134 (text) and line 138 (text).
- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][35]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 19 (header) and line 28
  (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 31
  (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][37]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 19 (header)
  and line 24 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][38]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header),
  line 249 (text), line 284 (text), line 290 (text), line 298 (text), line 306 (text), line 312 (text) and line 320 (text).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][39]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 23 (header) and line 119
  (text).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][40]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 21 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][41]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/configs/glossary.yml][42]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 23 (text) and line
  115 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][43]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 267 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][44]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 626 (text).
- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][45]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (body
  comment) (a passing mention only).

### docs × markdown (23 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][46]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 40 (text).
- [docs/adr/glossary.md][47]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 755 (text) and line 800 (text).
- [docs/adr/index.md][48]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 270 (text) and line 390 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][49]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text), line 36
  (text) and line 79 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][50]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 16 (text) and line 58 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][51]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 16
  (text) and line 79 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][52]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 41
  (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][53]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 78 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][54]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][55]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text),
  line 74 (text) and line 119 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][56]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 48 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][57]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 19
  (text), line 33 (text), line 48 (text), line 58 (text) and line 64 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][58]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 29 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][59]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 30 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][60]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 29
  (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][61]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 41 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][62]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 29
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][63]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][64]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 29
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][65]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][66]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line
  43 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][67]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 38 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][68]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 34 (header), `automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1` line 20
  (header), `automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1` line 28 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1`
  line 21 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1` line 33 (header),
  `automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1` line 21 (header), `automation/Catzc.Azure.Templates/Build-Bicep.ps1` line 21
  (header), `automation/Catzc.Azure.Templates/Deploy-Bicep.ps1` line 21 (header), `automation/Catzc.Azure.Templates/Deploy-Bicep.ps1` line
  33 (header), `automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1` line 19 (header),
  `automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1` line 27 (header),
  `automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1` line 45 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1` line 29 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line 22 (header), `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line
  34 (header), `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line 60 (header),
  `automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/configs/glossary.yml` line 23 (text), `automation/Catzc.Azure.Templates/configs/glossary.yml` line 115
  (text), `automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1` line 19 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1` line 19 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1` line 26 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1` line 25 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1` line 33 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1` line 19 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1` line 27 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 27 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 29 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 48 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 54 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 71 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 77 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 82 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 88 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 125 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 129 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 129 (body comment),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 134 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 138 (text),
  `automation/Catzc.Azure/Get-AzureEnvironment.ps1` line 19 (header), `automation/Catzc.Azure/Get-AzureEnvironment.ps1` line 28 (header),
  `automation/Catzc.Azure/Get-AzureSubscription.ps1` line 21 (header), `automation/Catzc.Azure/Get-AzureSubscription.ps1` line 31 (header),
  `automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1` line 19 (header),
  `automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1` line 24 (header), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 21 (header), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 249 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 284 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 290 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 298 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 306 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 312 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 320 (text), `automation/Catzc.Azure/types/AzureConfig.cs`
  line 23 (text), `automation/Catzc.Azure/types/AzureEnvironmentRecord.cs` line 20 (text),
  `automation/Catzc.Azure/types/AzureSubscriptionRecord.cs` line 21 (text), `automation/Catzc.Azure/types/AzureTenantRecord.cs` line 20
  (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 23 (header), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 119 (text),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 267 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 626
  (text), `automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1` line 20 (header) and
  `automation/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment).

## Keywords

- [world map][69]
- [track][70]
- [file language][71]
- [cell][72]
- [lit cell][73]
- [.claude][74]: a track
- [.unordered][74]: a track
- [automation][74]: a track
- [docs][74]: a track
- [pipelines][74]: a track
- [csharp][75]: a file language
- [markdown][75]: a file language
- [pipeline-yaml][75]: a file language
- [powershell][75]: a file language
- [yaml][75]: a file language

Terms the cited ADRs define:

- [environment class][76], defined by [ADR-AZ-DATAMOD#11][77]
- [slot][78], defined by [ADR-AZ-DATAMOD#2][79]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[6]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[7]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[8]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[9]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[10]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[11]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[12]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[13]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[14]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[15]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[16]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[17]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[18]: ../../../../automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
[19]: ../../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[20]: ../../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[21]: ../../../../automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
[22]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[23]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[24]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[25]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[26]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[27]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[28]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[29]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[30]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[31]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[32]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[33]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[34]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[35]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[36]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[37]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[38]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[39]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[40]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[41]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[42]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[43]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[44]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[45]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[46]: ../../../adr/azure/dora-explains.md
[47]: ../../../adr/glossary.md
[48]: ../../../adr/index.md
[49]: ../../../how-to/automation/manual-test-plan/azure.md
[50]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[51]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[52]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[53]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[54]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[55]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[56]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[57]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[58]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[59]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[60]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[61]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[62]: ../../../references/infrastructure/templates/discovery/options.yml.md
[63]: ../../../references/infrastructure/templates/expedition/options.yml.md
[64]: ../../../references/infrastructure/templates/foundation/options.yml.md
[65]: ../../../references/pipelines/cd-shared.yaml.md
[66]: ../../../references/pipelines/ci-infrastructure.yaml.md
[67]: ../../../references/pipelines/extends/cd-customer.yaml.md
[68]: ../../../../pipelines/ci-automation.yaml
[69]: ../../../adr/glossary.md#world-map
[70]: ../../../adr/glossary.md#track
[71]: ../../../adr/glossary.md#file-language
[72]: ../../../adr/glossary.md#cell
[73]: ../../../adr/glossary.md#lit-cell
[74]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[75]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[76]: ../../../adr/glossary.md#environment-class
[77]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[78]: ../../../adr/glossary.md#slot
[79]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

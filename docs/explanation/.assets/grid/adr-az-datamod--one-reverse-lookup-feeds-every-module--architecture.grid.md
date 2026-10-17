# docs/explanation/.assets/grid/adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.grid.md

`Grid minimap: adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture`

![Grid minimap of adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture](adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.grid.png)

The grid minimap of the slide `adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture` (architecture lens). The slide supports
[ADR-AZ-DATAMOD][1] and [ADR-AZ-NAMING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 71 files
- .unordered × markdown: 5 lit of 20 files
- automation × csharp: 5 lit of 274 files
- automation × powershell: 32 lit of 1579 files
- automation × yaml: 4 lit of 109 files
- docs × markdown: 31 lit of 2165 files
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

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][6]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 27 (text) and line
  175 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 175 (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][8]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 72 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 66 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text) and line 28
  (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 21 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][11]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 110 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 18
  (text).

### automation × csharp (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][13]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureConfig.cs][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 25 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (text);
  selected by [ADR-AZ-NAMING][2]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (text).

### automation × powershell (32 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and
  line 35 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and
  line 29 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][20]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line
  34 (header).
- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][21]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][22]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][23]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line
  34 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][24]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][25]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][26]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 20
  (header), line 37 (header) and line 40 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header) and line 46 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][28]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header) and line 30 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 23 (header),
  line 35 (header) and line 61 (header); selected by [ADR-AZ-NAMING][2]: the file cites it at line 24 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22
  (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 20 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][34]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][35]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  21 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 21 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][37]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][38]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 21 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][39]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 21
  (header) and line 70 (text).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][40]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 21 (header) and line 30 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][41]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 21 (header), line 49 (text), line 55 (text), line 72 (text), line 78 (text), line 83 (text), line 89 (text), line 126 (text), line
  130 (text), line 130 (body comment), line 135 (text) and line 139 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][42]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 21
  (header).
- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][43]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 29
  (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][44]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line 32
  (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][45]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header)
  and line 25 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][46]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header),
  line 250 (text), line 285 (text), line 291 (text), line 299 (text), line 307 (text), line 313 (text) and line 321 (text).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][47]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (header) and line 134
  (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 25 (header) and line 104 (body comment).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][48]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][49]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/configs/glossary.yml][50]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text) and line
  116 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][51]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 269 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 271 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][52]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 627 (text).
- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][53]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (body
  comment) (a passing mention only).

### docs × markdown (31 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/azure-naming-standard.md][2]: selected by [ADR-AZ-NAMING][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][54]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 41 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 75 (text).
- [docs/adr/glossary.md][55]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 784 (text) and line 829 (text).
- [docs/adr/index.md][56]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 274 (text) and line 394 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 31 (text) and line 276 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][57]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text), line 37
  (text) and line 80 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][58]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 90 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][59]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 17 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][60]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text) and line 80 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][61]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 42
  (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md][62]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 17 (text), line 34 (text), line 45 (text) and line 64 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md][63]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][64]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 79 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 17 (text) and line 104 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][65]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][66]: selected by [ADR-AZ-NAMING][2]: the file
  cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md][67]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 18 (text), line 32 (text), line 52 (text) and line 84 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][68]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text),
  line 75 (text) and line 120 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 51 (text), line 96 (text) and line 129
  (text).
- [docs/references/automation/catzc-azure/configs/customer.yml.md][69]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 35 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][70]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 49 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][71]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (text), line 34 (text), line 49 (text), line 59 (text) and line 65 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 21
  (text) and line 51 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][72]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 30 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][73]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][74]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][75]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 42 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][76]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 42
  (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][77]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][78]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 31
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][79]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][80]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 32 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][81]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text) and line
  44 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][82]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][83]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 22 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 35 (header), `automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1` line 21
  (header), `automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1` line 29 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1`
  line 22 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1` line 34 (header),
  `automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1` line 22 (header), `automation/Catzc.Azure.Templates/Build-Bicep.ps1` line 22
  (header), `automation/Catzc.Azure.Templates/Deploy-Bicep.ps1` line 22 (header), `automation/Catzc.Azure.Templates/Deploy-Bicep.ps1` line
  34 (header), `automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1` line 28 (header),
  `automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1` line 46 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1` line 30 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line 23 (header), `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line
  35 (header), `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line 61 (header),
  `automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1` line 22 (header),
  `automation/Catzc.Azure.Templates/configs/glossary.yml` line 24 (text), `automation/Catzc.Azure.Templates/configs/glossary.yml` line 116
  (text), `automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1` line 27 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1` line 26 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1` line 34 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1` line 28 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 28 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 30 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 49 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 55 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 72 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 78 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 83 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 89 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 126 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 130 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 130 (body comment),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 135 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 139 (text),
  `automation/Catzc.Azure/Get-AzureEnvironment.ps1` line 20 (header), `automation/Catzc.Azure/Get-AzureEnvironment.ps1` line 29 (header),
  `automation/Catzc.Azure/Get-AzureSubscription.ps1` line 22 (header), `automation/Catzc.Azure/Get-AzureSubscription.ps1` line 32 (header),
  `automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1` line 20 (header),
  `automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1` line 25 (header), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 22 (header), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 250 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 285 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 291 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 299 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 307 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 313 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 321 (text), `automation/Catzc.Azure/types/AzureConfig.cs`
  line 24 (text), `automation/Catzc.Azure/types/AzureEnvironmentRecord.cs` line 21 (text),
  `automation/Catzc.Azure/types/AzureSubscriptionRecord.cs` line 22 (text), `automation/Catzc.Azure/types/AzureTenantRecord.cs` line 21
  (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 24 (header), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 134 (text),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 269 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 627
  (text), `automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1` line 21 (header) and
  `automation/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment); selected by [ADR-AZ-NAMING][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1` line 21
  (header), `automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1` line 37 (header),
  `automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1` line 40 (header),
  `automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1` line 21 (header), `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1`
  line 24 (header), `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 70 (text),
  `automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/types/BicepShortName.cs` line 22 (text), `automation/Catzc.Azure/types/AzureConfig.cs` line 25 (text),
  `automation/Catzc.Azure/types/AzureEnvironmentRecord.cs` line 22 (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 25 (header),
  `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 104 (body comment) and `automation/Catzc.Base.Docs/configs/adrs.yml` line 271 (text).

## Keywords

- [world map][84]
- [track][85]
- [file language][86]
- [cell][87]
- [lit cell][88]
- [.claude][89]: a track
- [.unordered][89]: a track
- [automation][89]: a track
- [docs][89]: a track
- [pipelines][89]: a track
- [csharp][90]: a file language
- [markdown][90]: a file language
- [pipeline-yaml][90]: a file language
- [powershell][90]: a file language
- [yaml][90]: a file language

Terms the cited ADRs define:

- [environment class][91], defined by [ADR-AZ-DATAMOD#11][92]
- [slot][93], defined by [ADR-AZ-DATAMOD#2][94]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../adr/azure/azure-naming-standard.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[9]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[10]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[11]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[12]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[13]: ../../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[14]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[15]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[16]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[17]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[18]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[19]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[20]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[21]: ../../../../automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
[22]: ../../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[23]: ../../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[24]: ../../../../automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
[25]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[26]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[27]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[28]: ../../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[29]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[30]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[31]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[32]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[33]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[34]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[35]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[36]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[37]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[38]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[39]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[40]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[41]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[42]: ../../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[43]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[44]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[45]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[46]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[47]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[48]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[49]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[50]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[51]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[52]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[53]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[54]: ../../../adr/azure/dora-explains.md
[55]: ../../../adr/glossary.md
[56]: ../../../adr/index.md
[57]: ../../../how-to/automation/manual-test-plan/azure.md
[58]: ../../../how-to/getting-started/automation/add-a-doc-chapter.md
[59]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[60]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[61]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[62]: ../../../references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
[63]: ../../../references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
[64]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[65]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[66]: ../../../references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[67]: ../../../references/automation/catzc-azure-templates/types/BicepShortName.cs.md
[68]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[69]: ../../../references/automation/catzc-azure/configs/customer.yml.md
[70]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[71]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[72]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[73]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[74]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[75]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[76]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[77]: ../../../references/infrastructure/templates/discovery/options.yml.md
[78]: ../../../references/infrastructure/templates/expedition/options.yml.md
[79]: ../../../references/infrastructure/templates/foundation/options.yml.md
[80]: ../../../references/pipelines/cd-shared.yaml.md
[81]: ../../../references/pipelines/ci-infrastructure.yaml.md
[82]: ../../../references/pipelines/extends/cd-customer.yaml.md
[83]: ../../../../pipelines/ci-automation.yaml
[84]: ../../../adr/glossary.md#world-map
[85]: ../../../adr/glossary.md#track
[86]: ../../../adr/glossary.md#file-language
[87]: ../../../adr/glossary.md#cell
[88]: ../../../adr/glossary.md#lit-cell
[89]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[90]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[91]: ../../../adr/glossary.md#environment-class
[92]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[93]: ../../../adr/glossary.md#slot
[94]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

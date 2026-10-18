# A pipeline pins the subscription it expects; a devbox picks the target with az account set: the world-map minimap

```text
Where the files that cite ADR-AZ-DATAMOD sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 69 files.
```

![The world-map minimap of A pipeline pins the subscription it expects; a devbox picks the target with az account set](adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [A pipeline pins the subscription it expects; a devbox picks the
target with az account set][73], which explains [ADR-AZ-DATAMOD][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 91 files
- automation × csharp: 4 lit of 286 files
- automation × powershell: 27 lit of 1618 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 31 lit of 2220 files
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

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][5]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 26 (text) and line
  182 (text).
- [.claude/plans/plan-module-kinds-tracks.md][6]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 182 (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure/types/AzureConfig.cs][7]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][8]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (text).

### automation × powershell (27 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][11]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and
  line 35 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and
  line 29 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line
  34 (header).
- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line
  34 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header) and line 46 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header) and line 30 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][20]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 23 (header),
  line 35 (header) and line 61 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][21]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22
  (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][22]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 20 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][23]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][24]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][25]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  21 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][26]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 21 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][28]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 21 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 21 (header) and line 30 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 21 (header), line 49 (text), line 55 (text), line 72 (text), line 78 (text), line 83 (text), line 89 (text), line 126 (text), line
  130 (text), line 130 (body comment), line 135 (text) and line 139 (text).
- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 29
  (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line 32
  (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header)
  and line 25 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][34]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header),
  line 250 (text), line 285 (text), line 291 (text), line 299 (text), line 307 (text), line 313 (text) and line 321 (text).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][35]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (header) and line 132
  (text).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][37]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/configs/glossary.yml][38]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text) and line
  120 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][39]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 274 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][40]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 632 (text).
- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][41]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (body
  comment) (a passing mention only).

### docs × markdown (31 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][42]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 40 (text).
- [docs/adr/glossary.md][43]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 965 (text) and line 1013 (text).
- [docs/adr/index.md][44]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 280 (text) and line 404 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][45]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text), line 36
  (text) and line 79 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][46]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text), line 80 (text) and line 80 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][47]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 76 (text) and line 91 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][48]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text), line 64 (text) and line 70 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][49]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text), line 73 (text) and line 95 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][50]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 17 (text) and line 122 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][51]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 17 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][52]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text) and line 80 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][53]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 42
  (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][54]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 79 (text).
- [docs/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][55]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 15 (text), line 45 (text), line 51 (text), line 122 (text) and line 129 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][56]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 16 (text), line 56 (text), line 118 (text) and line 124 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][57]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md][58]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 16 (text) and line 123 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][59]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text),
  line 75 (text) and line 120 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][60]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 49 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][61]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (text), line 34 (text), line 49 (text), line 59 (text) and line 65 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][62]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 30 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][63]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][64]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][65]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 42 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][66]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][67]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 31
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][68]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][69]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 32 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][70]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text) and line
  44 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][71]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][72]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
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
  `automation/Catzc.Azure.Templates/configs/glossary.yml` line 24 (text), `automation/Catzc.Azure.Templates/configs/glossary.yml` line 120
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
  (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 24 (header), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 132 (text),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 274 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 632
  (text), `automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1` line 21 (header) and
  `automation/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment).

## Keywords

- [world map][74]
- [track][75]
- [file language][76]
- [cell][77]
- [lit cell][78]
- [.claude][79]: a track
- [automation][79]: a track
- [docs][79]: a track
- [pipelines][79]: a track
- [csharp][80]: a file language
- [markdown][80]: a file language
- [pipeline-yaml][80]: a file language
- [powershell][80]: a file language
- [yaml][80]: a file language

Terms the cited ADRs define:

- [environment class][81], defined by [ADR-AZ-DATAMOD#11][82]
- [slot][83], defined by [ADR-AZ-DATAMOD#2][84]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[6]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[7]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[8]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[9]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[10]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[11]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[12]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[13]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[14]: ../../../../automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
[15]: ../../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[16]: ../../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[17]: ../../../../automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
[18]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[19]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[20]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[21]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[22]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[23]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[24]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[25]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[26]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[27]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[28]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[29]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[30]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[31]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[32]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[33]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[34]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[35]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[36]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[37]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[38]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[39]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[40]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[41]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[42]: ../../../adr/azure/dora-explains.md
[43]: ../../../adr/glossary.md
[44]: ../../../adr/index.md
[45]: ../../../how-to/automation/manual-test-plan/azure.md
[46]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[47]: ../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[48]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[49]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[50]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[51]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[52]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[53]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[54]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[55]: ../../../references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[56]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[57]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[58]: ../../../references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md
[59]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[60]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[61]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[62]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[63]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[64]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[65]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[66]: ../../../references/infrastructure/templates/discovery/options.yml.md
[67]: ../../../references/infrastructure/templates/expedition/options.yml.md
[68]: ../../../references/infrastructure/templates/foundation/options.yml.md
[69]: ../../../references/pipelines/cd-shared.yaml.md
[70]: ../../../references/pipelines/ci-infrastructure.yaml.md
[71]: ../../../references/pipelines/extends/cd-customer.yaml.md
[72]: ../../../../pipelines/ci-automation.yaml
[73]: ../../azure/pipeline-pins-devbox-picks-the-target.md
[74]: ../../../adr/glossary.md#world-map
[75]: ../../../adr/glossary.md#track
[76]: ../../../adr/glossary.md#file-language
[77]: ../../../adr/glossary.md#cell
[78]: ../../../adr/glossary.md#lit-cell
[79]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[80]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[81]: ../../../adr/glossary.md#environment-class
[82]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[83]: ../../../adr/glossary.md#slot
[84]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

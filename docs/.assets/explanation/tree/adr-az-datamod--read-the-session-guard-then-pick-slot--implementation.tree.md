# docs/.assets/explanation/tree/adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.tree.md

`Tree minimap: adr-az-datamod--read-the-session-guard-then-pick-slot--implementation`

![Tree minimap of adr-az-datamod--read-the-session-guard-then-pick-slot--implementation](adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.tree.png)

The tree minimap of the slide `adr-az-datamod--read-the-session-guard-then-pick-slot--implementation` (implementation lens). The slide
supports [ADR-AZ-DATAMOD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 65 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 19 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 18 lit files
- Azure (automation/Catzc.Azure): 8 lit files
- .unordered: 5 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 3 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- .claude: 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 19 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/azure.md][2], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 16 (text), line 36 (text) and line 79 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text) and line 58 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][4], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 16 (text) and line 79 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][5], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 41 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 78 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][7], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][8], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 16 (text), line 74 (text) and line 119 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 48 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][10], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 19 (text), line 33 (text), line 48 (text), line 58 (text) and line 64 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][11], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][12], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 30 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][13], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 41 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][15], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 29 (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][16], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 30 (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][17], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 29 (text).
- [docs/references/pipelines/cd-shared.yaml.md][18], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][19], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 17 (text) and line 43 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][20], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 38 (text).

### Az.Templates (automation/Catzc.Azure.Templates, 18 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][21], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][22], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][23], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (header) and line 33 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][24], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 19 (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][25], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 45 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][26], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 29 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][27], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 22 (header), line 34 (header) and line 60 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][28], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/configs/glossary.yml][29], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 23 (text) and line 115 (text).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][30], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 19 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][31], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 19 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][32], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][33], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 33 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][34], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][35], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 19 (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][36], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][37], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 29 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][38], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header), line 48 (text), line 54 (text), line 71 (text), line 77 (text), line 82
  (text), line 88 (text), line 125 (text), line 129 (text), line 129 (body comment), line 134 (text) and line 138 (text).

### Azure (automation/Catzc.Azure, 8 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][39], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 19 (header) and line 28 (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][40], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (header) and line 31 (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][41], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 19 (header) and line 24 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][42], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 21 (header), line 249 (text), line 284 (text), line 290 (text), line 298 (text), line 306 (text), line 312 (text)
  and line 320 (text).
- [automation/Catzc.Azure/types/AzureConfig.cs][43], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 23 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][44], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][45], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][46], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 20 (text).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][47], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 72 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][48], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 66 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][49], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 20 (text) and line 28 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][50], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 110 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][51], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 17 (text) and line 18 (text).

### Az.Cli (automation/Catzc.Azure.Cli, 3 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][52], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (header) and line 34 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][53], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][54], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (header) and line 33 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][55], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 626 (text).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][56], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][57], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][58], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 23 (header) and line 119 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][59], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 267 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][60], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 755 (text) and line
  800 (text).
- [docs/adr/index.md][61], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 270 (text) and line 390
  (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-data-model.md][1], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][62], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 40 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][63], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 134 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][64], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (body comment) (a passing mention only).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][65], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 21 (header),
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

- [world map][66]
- [track][67]
- [file language][68]
- [cell][69]
- [lit cell][70]
- [.claude][71]: a track
- [.unordered][71]: a track
- [automation][71]: a track
- [docs][71]: a track
- [pipelines][71]: a track
- [csharp][72]: a file language
- [markdown][72]: a file language
- [pipeline-yaml][72]: a file language
- [powershell][72]: a file language
- [yaml][72]: a file language

Terms the cited ADRs define:

- [environment class][73], defined by [ADR-AZ-DATAMOD#11][74]
- [slot][75], defined by [ADR-AZ-DATAMOD#2][76]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../how-to/automation/manual-test-plan/azure.md
[3]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[4]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[5]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[6]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[7]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[8]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[9]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[10]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[11]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[12]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[13]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[14]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[15]: ../../../references/infrastructure/templates/discovery/options.yml.md
[16]: ../../../references/infrastructure/templates/expedition/options.yml.md
[17]: ../../../references/infrastructure/templates/foundation/options.yml.md
[18]: ../../../references/pipelines/cd-shared.yaml.md
[19]: ../../../references/pipelines/ci-infrastructure.yaml.md
[20]: ../../../references/pipelines/extends/cd-customer.yaml.md
[21]: ../../../../automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
[22]: ../../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[23]: ../../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[24]: ../../../../automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
[25]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[26]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[27]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[28]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[29]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[30]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[31]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[32]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[33]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[34]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[35]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[36]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[37]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[38]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[39]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[40]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[41]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[42]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[43]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[44]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[45]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[46]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[47]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[48]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[49]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[50]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[51]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[52]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[53]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[54]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[55]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[56]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[57]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[58]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[59]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[60]: ../../../adr/glossary.md
[61]: ../../../adr/index.md
[62]: ../../../adr/azure/dora-explains.md
[63]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[64]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[65]: ../../../../pipelines/ci-automation.yaml
[66]: ../../../adr/glossary.md#world-map
[67]: ../../../adr/glossary.md#track
[68]: ../../../adr/glossary.md#file-language
[69]: ../../../adr/glossary.md#cell
[70]: ../../../adr/glossary.md#lit-cell
[71]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[72]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[73]: ../../../adr/glossary.md#environment-class
[74]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[75]: ../../../adr/glossary.md#slot
[76]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

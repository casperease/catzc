# docs/.assets/explanation/tree/adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.tree.md

`Tree minimap: adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture`

![Tree minimap of adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture](adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture.tree.png)

The tree minimap of the slide `adr-az-datamod--one-reverse-lookup-feeds-every-module--architecture` (architecture lens). The slide supports
[ADR-AZ-DATAMOD][1] and [ADR-AZ-NAMING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 80 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 26 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 24 lit files
- Azure (automation/Catzc.Azure): 8 lit files
- .unordered: 5 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 3 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- adr/azure (docs/adr/azure): 3 lit files
- .claude: 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 26 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/azure.md][3], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 17 (text), line 37 (text) and line 80 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][4], in the cell docs × markdown: selected by [ADR-AZ-NAMING][2]: the file
  cites it at line 90 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][6], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 17 (text) and line 80 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][7], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 42 (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 17 (text), line 34 (text), line 45 (text) and line 64 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 79 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 17 (text) and line 104
  (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][11], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md][13], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 18 (text), line 32 (text), line 52 (text) and line 84 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][14], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 17 (text), line 75 (text) and line 120 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 51 (text), line
  96 (text) and line 129 (text).
- [docs/references/automation/catzc-azure/configs/customer.yml.md][15], in the cell docs × markdown: selected by [ADR-AZ-NAMING][2]: the
  file cites it at line 35 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 49 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][17], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 20 (text), line 34 (text), line 49 (text), line 59 (text) and line 65 (text); selected by [ADR-AZ-NAMING][2]: the
  file cites it at line 21 (text) and line 51 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][18], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 30 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][19], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][20], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 42 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][22], in the cell docs × markdown: selected by [ADR-AZ-NAMING][2]:
  the file cites it at line 42 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][23], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 30 (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][24], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 31 (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][25], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][26], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  32 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][27], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 18 (text) and line 44 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][28], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 39 (text).

### Az.Templates (automation/Catzc.Azure.Templates, 24 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][29], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][30], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][31], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][32], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][33], in the cell automation × powershell: selected by [ADR-AZ-NAMING][2]: the
  file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][34], in the cell automation × powershell: selected by [ADR-AZ-NAMING][2]:
  the file cites it at line 20 (header), line 37 (header) and line 40 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][35], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 46 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][36], in the cell automation × powershell: selected by [ADR-AZ-NAMING][2]: the
  file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][37], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][38], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 23 (header), line 35 (header) and line 61 (header); selected by [ADR-AZ-NAMING][2]: the file cites it at line 24
  (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][39], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/configs/glossary.yml][40], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 24 (text) and line 116 (text).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][41], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][42], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][43], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][44], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][45], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][46], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][47], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][48], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 21 (header) and line 70 (text).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][49], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 30 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][50], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header), line 49 (text), line 55 (text), line 72 (text), line 78 (text), line 83
  (text), line 89 (text), line 126 (text), line 130 (text), line 130 (body comment), line 135 (text) and line 139 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][51], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][52], in the cell automation × csharp: selected by [ADR-AZ-NAMING][2]: the file
  cites it at line 22 (text).

### Azure (automation/Catzc.Azure, 8 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][53], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (header) and line 29 (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][54], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 32 (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][55], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][56], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 22 (header), line 250 (text), line 285 (text), line 291 (text), line 299 (text), line 307 (text), line 313 (text)
  and line 321 (text).
- [automation/Catzc.Azure/types/AzureConfig.cs][57], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 24 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 25 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][58], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][59], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][60], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 21 (text).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][61], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 72 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][62], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 66 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][63], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 20 (text) and line 28 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 21 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][64], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 110 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][65], in the cell .unordered × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 17 (text) and line 18 (text).

### Az.Cli (automation/Catzc.Azure.Cli, 3 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][66], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 35 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][67], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 21 (header) and line 29 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][68], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 34 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][69], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 627 (text).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][70], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][71], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).

### adr/azure (docs/adr/azure, 3 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-data-model.md][1], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/azure-naming-standard.md][2], in the cell docs × markdown: selected by [ADR-AZ-NAMING][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][72], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 41 (text);
  selected by [ADR-AZ-NAMING][2]: the file cites it at line 75 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][73], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 27 (text) and line 175 (text).
- [.claude/plans/plan-module-kinds-tracks.md][74], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 175 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][75], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 24 (header) and line 134 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 25 (header) and line 104 (body
  comment).
- [automation/Catzc.Base.Docs/configs/adrs.yml][76], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 269 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 271 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][77], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 784 (text) and line
  829 (text).
- [docs/adr/index.md][78], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 274 (text) and line 394
  (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 31 (text) and line 276 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][79], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (body comment) (a passing mention only).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][80], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 22 (header),
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

- [world map][81]
- [track][82]
- [file language][83]
- [cell][84]
- [lit cell][85]
- [.claude][86]: a track
- [.unordered][86]: a track
- [automation][86]: a track
- [docs][86]: a track
- [pipelines][86]: a track
- [csharp][87]: a file language
- [markdown][87]: a file language
- [pipeline-yaml][87]: a file language
- [powershell][87]: a file language
- [yaml][87]: a file language

Terms the cited ADRs define:

- [environment class][88], defined by [ADR-AZ-DATAMOD#11][89]
- [slot][90], defined by [ADR-AZ-DATAMOD#2][91]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../adr/azure/azure-naming-standard.md
[3]: ../../../how-to/automation/manual-test-plan/azure.md
[4]: ../../../how-to/getting-started/automation/add-a-doc-chapter.md
[5]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[6]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[7]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[8]: ../../../references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
[9]: ../../../references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
[10]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[11]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[12]: ../../../references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[13]: ../../../references/automation/catzc-azure-templates/types/BicepShortName.cs.md
[14]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[15]: ../../../references/automation/catzc-azure/configs/customer.yml.md
[16]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[17]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[18]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[19]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[20]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[21]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[22]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[23]: ../../../references/infrastructure/templates/discovery/options.yml.md
[24]: ../../../references/infrastructure/templates/expedition/options.yml.md
[25]: ../../../references/infrastructure/templates/foundation/options.yml.md
[26]: ../../../references/pipelines/cd-shared.yaml.md
[27]: ../../../references/pipelines/ci-infrastructure.yaml.md
[28]: ../../../references/pipelines/extends/cd-customer.yaml.md
[29]: ../../../../automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
[30]: ../../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[31]: ../../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[32]: ../../../../automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
[33]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[34]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[35]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[36]: ../../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[37]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[38]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[39]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[40]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[41]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[42]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[43]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[44]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[45]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[46]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[47]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[48]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[49]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[50]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[51]: ../../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[52]: ../../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[53]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[54]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[55]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[56]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[57]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[58]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[59]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[60]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[61]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[62]: ../../../../.unordered/15-10-2026/plan-caf-code-segments.md
[63]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[64]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[65]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[66]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[67]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[68]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[69]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[70]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[71]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[72]: ../../../adr/azure/dora-explains.md
[73]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[74]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[75]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[76]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[77]: ../../../adr/glossary.md
[78]: ../../../adr/index.md
[79]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[80]: ../../../../pipelines/ci-automation.yaml
[81]: ../../../adr/glossary.md#world-map
[82]: ../../../adr/glossary.md#track
[83]: ../../../adr/glossary.md#file-language
[84]: ../../../adr/glossary.md#cell
[85]: ../../../adr/glossary.md#lit-cell
[86]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[87]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[88]: ../../../adr/glossary.md#environment-class
[89]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[90]: ../../../adr/glossary.md#slot
[91]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

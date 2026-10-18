---
catzc:
  immutable:
    with_body_sha: e9c8b99d96cc
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.tree.md
    source: docs/explanation/.assets/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A pipeline pins the subscription it expects; a devbox picks the target with az account set: the tree minimap

```text
Which files cite ADR-AZ-DATAMOD: every file of the world map is a tile, grouped by top-level folder.
69 files lit in 11 groups.
```

![The tree minimap of A pipeline pins the subscription it expects; a devbox picks the target with az account set](adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.tree.png)

This is the tree minimap in the sidebar of the operations diagram of [A pipeline pins the subscription it expects; a devbox picks the target
with az account set][70], which explains [ADR-AZ-DATAMOD][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 69 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 27 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 18 lit files
- Azure (automation/Catzc.Azure): 8 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 3 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- .claude: 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 27 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/azure.md][2], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 16 (text), line 36 (text) and line 79 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][3], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text), line 80 (text) and line 80 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][4], in the cell docs ×
  markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 76 (text) and line 91 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][5], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text), line 64 (text) and line 70 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][6], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text), line 73 (text) and line 95 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][7], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 122 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][9], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 17 (text) and line 80 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][10], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 42 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 79 (text).
- [docs/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][12], in the cell docs × markdown: selected
  by [ADR-AZ-DATAMOD][1]: the file cites it at line 15 (text), line 45 (text), line 51 (text), line 122 (text) and line 129 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][13], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text), line 56 (text), line 118 (text) and line 124 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][14], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md][15], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 16 (text) and line 123 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][16], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 17 (text), line 75 (text) and line 120 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 49 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][18], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 20 (text), line 34 (text), line 49 (text), line 59 (text) and line 65 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][19], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 30 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][20], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][21], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 42 (text).
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

### Az.Templates (automation/Catzc.Azure.Templates, 18 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][29], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][30], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][31], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][32], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][33], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 46 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][34], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][35], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 23 (header), line 35 (header) and line 61 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][36], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/configs/glossary.yml][37], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 24 (text) and line 120 (text).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][38], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][39], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][40], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][41], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][42], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][43], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][44], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][45], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header) and line 30 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][46], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header), line 49 (text), line 55 (text), line 72 (text), line 78 (text), line 83
  (text), line 89 (text), line 126 (text), line 130 (text), line 130 (body comment), line 135 (text) and line 139 (text).

### Azure (automation/Catzc.Azure, 8 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][47], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (header) and line 29 (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][48], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 32 (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][49], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][50], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 22 (header), line 250 (text), line 285 (text), line 291 (text), line 299 (text), line 307 (text), line 313 (text)
  and line 321 (text).
- [automation/Catzc.Azure/types/AzureConfig.cs][51], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 24 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][52], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][53], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][54], in the cell automation × csharp: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 21 (text).

### Az.Cli (automation/Catzc.Azure.Cli, 3 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][55], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 35 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][56], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 21 (header) and line 29 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][57], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (header) and line 34 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][58], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 632 (text).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][59], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][60], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (header).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][61], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 26 (text) and line 182 (text).
- [.claude/plans/plan-module-kinds-tracks.md][62], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 182 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][63], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 24 (header) and line 132 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][64], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 274 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][65], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 965 (text) and line
  1013 (text).
- [docs/adr/index.md][66], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 280 (text) and line 404
  (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-data-model.md][1], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][67], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 40 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][68], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 21 (body comment) (a passing mention only).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][69], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing
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

- [world map][71]
- [track][72]
- [file language][73]
- [cell][74]
- [lit cell][75]
- [.claude][76]: a track
- [automation][76]: a track
- [docs][76]: a track
- [pipelines][76]: a track
- [csharp][77]: a file language
- [markdown][77]: a file language
- [pipeline-yaml][77]: a file language
- [powershell][77]: a file language
- [yaml][77]: a file language

Terms the cited ADRs define:

- [environment class][78], defined by [ADR-AZ-DATAMOD#11][79]
- [slot][80], defined by [ADR-AZ-DATAMOD#2][81]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../how-to/automation/manual-test-plan/azure.md
[3]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[4]: ../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[5]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[6]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[7]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[8]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[9]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[10]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[11]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[12]: ../../../references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[13]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[14]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[15]: ../../../references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md
[16]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[17]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[18]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[19]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[20]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[21]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[22]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
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
[33]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[34]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[35]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[36]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[37]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[38]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[39]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[40]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[41]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[42]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[43]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[44]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[45]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[46]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[47]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[48]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[49]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[50]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[51]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[52]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[53]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[54]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[55]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[56]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[57]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[58]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[59]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[60]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[61]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[62]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[63]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[64]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[65]: ../../../adr/glossary.md
[66]: ../../../adr/index.md
[67]: ../../../adr/azure/dora-explains.md
[68]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[69]: ../../../../pipelines/ci-automation.yaml
[70]: ../../azure/pipeline-pins-devbox-picks-the-target.md
[71]: ../../../adr/glossary.md#world-map
[72]: ../../../adr/glossary.md#track
[73]: ../../../adr/glossary.md#file-language
[74]: ../../../adr/glossary.md#cell
[75]: ../../../adr/glossary.md#lit-cell
[76]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[77]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[78]: ../../../adr/glossary.md#environment-class
[79]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[80]: ../../../adr/glossary.md#slot
[81]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

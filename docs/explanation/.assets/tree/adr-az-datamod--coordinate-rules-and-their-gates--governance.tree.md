---
catzc:
  immutable:
    with_body_sha: dd12b03deb0a
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-az-datamod--coordinate-rules-and-their-gates--governance.tree.md
    source: docs/explanation/.assets/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two ADRs rule the coordinate; one shared check and the integrity tests hold them: the tree minimap

```text
Which files cite ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD: every file of the world map is a tile, grouped by top-level folder.
77 files lit in 10 groups.
```

![The tree minimap of Two ADRs rule the coordinate; one shared check and the integrity tests hold them](adr-az-datamod--coordinate-rules-and-their-gates--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Two ADRs rule the coordinate; one shared check and the integrity tests
hold them][78], which explains [ADR-AZ-CUSTOMER][1] and [ADR-AZ-DATAMOD][2]. It lights every file that cites those codes, grouped by folder,
so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 77 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 60 lit files
- Az.Templates (pwsh/Catzc.Azure.Templates): 3 lit files
- adr/azure (docs/adr/azure): 3 lit files
- .claude: 2 lit files
- Azure (pwsh/Catzc.Azure): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file
- RootConfig (pwsh/Catzc.Base.RootConfig): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 60 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/pwsh/manual-test-plan/azure.md][3], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 15 (text) and line 58 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][4], in the cell docs × markdown:
  selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 62 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 61
  (text) and line 61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][5], in the cell docs ×
  markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 59 (text) and line 74 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][6], in the cell docs × markdown:
  selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 44 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 42
  (text) and line 48 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][7], in the cell docs × markdown:
  selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 50 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 50
  (text) and line 72 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][10], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][11], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 101 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 101 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][12], in the cell docs × markdown: selected
  by [ADR-AZ-CUSTOMER][1]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md][13], in the cell docs ×
  markdown: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][14], in the cell docs × markdown:
  selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 94 (text).
- [docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md][16], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 129 (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][17], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 17 (text) and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 128 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text), line 46
  (text) and line 117 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][23], in the cell docs × markdown: selected
  by [ADR-AZ-DATAMOD][2]: the file cites it at line 24 (text), line 30 (text), line 101 (text) and line 108 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][24], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 94 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 32 (text), line 94
  (text) and line 100 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md][25], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][27], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md][28], in the cell docs × markdown:
  selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][29], in the cell docs × markdown: selected
  by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md][30], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][32], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][33], in the cell docs × markdown:
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md][34], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md][35], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md][36], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md][37], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]:
  the file cites it at line 19 (text) and line 46 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][38], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure/azure-identity-resolves-from-config.drawio.md][39], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 103 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][40], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the file
  cites it at line 66 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 56 (text) and line 101 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][41], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 26 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][43], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 40 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11 (text), line 26 (text), line 36 (text) and
  line 42 (text).
- [docs/references/pwsh/catzc-azure/types/AzureCustomer.cs.md][44], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][45], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][46], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 22 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][47], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/CustomerConfig.cs.md][48], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]:
  the file cites it at line 11 (text), line 23 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][49], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]:
  the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][50], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md][51], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md][52], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][53], in the cell docs × markdown: selected
  by [ADR-AZ-DATAMOD][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 53 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md][55], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][56], in the cell docs × markdown: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 51 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][57], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the
  file cites it at line 14 (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][58], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 15 (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][59], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 14 (text).
- [docs/references/pipelines/cd-shared.yaml.md][60], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line
  13 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][61], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 24 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][62], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 20 (text).

### Az.Templates (pwsh/Catzc.Azure.Templates, 3 lit files)

The group holds the files of pwsh/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Azure.Templates/configs/glossary.yml][63], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 5 (text) and line 101 (text).
- [pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][64], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 5 (text).
- [pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][65], in the cell automation × powershell: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 25 (text), line 31 (text), line 48 (text), line 54 (text), line 59 (text), line 65 (text),
  line 102 (text), line 106 (text), line 106 (body comment), line 111 (text) and line 115 (text).

### adr/azure (docs/adr/azure, 3 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-customer-model.md][1], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the ADR's own file.
- [docs/adr/azure/azure-data-model.md][2], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][66], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 60 (text);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 9 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][67], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 155 (text).
- [.claude/plans/plan-module-kinds-tracks.md][68], in the cell .claude × markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 163 (text).

### Azure (pwsh/Catzc.Azure, 2 lit files)

The group holds the files of pwsh/Catzc.Azure; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][69], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][2]: the
  file cites it at line 225 (text), line 260 (text), line 266 (text), line 274 (text), line 282 (text), line 288 (text) and line 296 (text).
- [pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1][70], in the cell automation × powershell: selected by [ADR-AZ-CUSTOMER][1]:
  the file cites it at line 57 (text).

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1][71], in the cell automation × powershell: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 69 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][72], in the cell automation × yaml: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 260 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 255 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][73], in the cell docs × markdown: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 965 (text) and line
  1013 (text).
- [docs/adr/index.md][74], in the cell docs × markdown: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 285 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 280 (text) and line 404 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][75], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 613 (text).

### RootConfig (pwsh/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of pwsh/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml][76], in the cell automation × yaml: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 21 (body comment) (a passing mention only).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][77], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-CUSTOMER][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1` line 57 (text) and
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 260 (text); selected by [ADR-AZ-DATAMOD][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Azure.Templates/configs/glossary.yml` line 5 (text),
  `pwsh/Catzc.Azure.Templates/configs/glossary.yml` line 101 (text),
  `pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 5 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 25 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 48 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 54 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 59 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 65 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 102 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 106 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 106 (body comment),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 111 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 115 (text),
  `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 225 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 260 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 266 (text),
  `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 274 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 282 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 288 (text),
  `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 296 (text), `pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1` line 69
  (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line
  613 (text) and `pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment).

## Keywords

- [world map][79]
- [track][80]
- [file language][81]
- [cell][82]
- [lit cell][83]
- [.claude][84]: a track
- [automation][84]: a track
- [docs][84]: a track
- [pipelines][84]: a track
- [markdown][85]: a file language
- [pipeline-yaml][85]: a file language
- [powershell][85]: a file language
- [yaml][85]: a file language

Terms the cited ADRs define:

- [environment class][86], defined by [ADR-AZ-DATAMOD#11][87]
- [slot][88], defined by [ADR-AZ-DATAMOD#2][89]

[1]: ../../../adr/azure/azure-customer-model.md
[2]: ../../../adr/azure/azure-data-model.md
[3]: ../../../how-to/pwsh/manual-test-plan/azure.md
[4]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[5]: ../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[6]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[7]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[8]: ../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[9]: ../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[10]: ../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[11]: ../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[12]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[13]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md
[14]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[15]: ../../../references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[16]: ../../../references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
[17]: ../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[18]: ../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[19]: ../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[20]: ../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[21]: ../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[22]: ../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[23]: ../../../references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[24]: ../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[25]: ../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
[26]: ../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
[27]: ../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[28]: ../../../references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md
[29]: ../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[30]: ../../../references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
[31]: ../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
[32]: ../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[33]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[34]: ../../../references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md
[35]: ../../../references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md
[36]: ../../../references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
[37]: ../../../references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
[38]: ../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[39]: ../../../references/pwsh/catzc-azure/azure-identity-resolves-from-config.drawio.md
[40]: ../../../references/pwsh/catzc-azure/configs/azure.yml.md
[41]: ../../../references/pwsh/catzc-azure/configs/customer.yml.md
[42]: ../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[43]: ../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[44]: ../../../references/pwsh/catzc-azure/types/AzureCustomer.cs.md
[45]: ../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[46]: ../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[47]: ../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[48]: ../../../references/pwsh/catzc-azure/types/CustomerConfig.cs.md
[49]: ../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[50]: ../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[51]: ../../../references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md
[52]: ../../../references/pwsh/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md
[53]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[54]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[55]: ../../../references/pwsh/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md
[56]: ../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[57]: ../../../references/infrastructure/templates/discovery/options.yml.md
[58]: ../../../references/infrastructure/templates/expedition/options.yml.md
[59]: ../../../references/infrastructure/templates/foundation/options.yml.md
[60]: ../../../references/pipelines/cd-shared.yaml.md
[61]: ../../../references/pipelines/ci-infrastructure.yaml.md
[62]: ../../../references/pipelines/extends/cd-customer.yaml.md
[63]: ../../../../pwsh/Catzc.Azure.Templates/configs/glossary.yml
[64]: ../../../../pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[65]: ../../../../pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[66]: ../../../adr/azure/dora-explains.md
[67]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[68]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[69]: ../../../../pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[70]: ../../../../pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1
[71]: ../../../../pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1
[72]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[73]: ../../../adr/glossary.md
[74]: ../../../adr/index.md
[75]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[76]: ../../../../pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml
[77]: ../../../../pipelines/ci-automation.yaml
[78]: ../../azure/coordinate-rules-and-their-gates.md
[79]: ../../../adr/glossary.md#world-map
[80]: ../../../adr/glossary.md#track
[81]: ../../../adr/glossary.md#file-language
[82]: ../../../adr/glossary.md#cell
[83]: ../../../adr/glossary.md#lit-cell
[84]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[85]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[86]: ../../../adr/glossary.md#environment-class
[87]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[88]: ../../../adr/glossary.md#slot
[89]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

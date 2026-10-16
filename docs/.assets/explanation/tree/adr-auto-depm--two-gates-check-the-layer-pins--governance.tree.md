# docs/.assets/explanation/tree/adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md

`Tree minimap: adr-auto-depm--two-gates-check-the-layer-pins--governance`

![Tree minimap of adr-auto-depm--two-gates-check-the-layer-pins--governance](adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.png)

The tree minimap of the slide `adr-auto-depm--two-gates-check-the-layer-pins--governance` (governance lens). The slide supports
[ADR-AUTO-DEPM][1] and [ADR-AUTO-TEST][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 692 files in 42 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 283 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 140 lit files
- Docs (automation/Catzc.Base.Docs): 50 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 29 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 21 lit files
- .claude: 15 lit files
- Globs (automation/Catzc.Base.Globs): 14 lit files
- Languages (automation/Catzc.Base.Languages): 11 lit files
- Tool.Core (automation/Catzc.Tooling.Core): 11 lit files
- Azure (automation/Catzc.Azure): 10 lit files
- Execution (automation/Catzc.Base.Execution): 10 lit files
- .unordered: 9 lit files
- Maps (automation/Catzc.Base.Maps): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 8 lit files
- Contracts (automation/Catzc.Base.Contracts): 7 lit files
- Tool.Provisioning (automation/Catzc.Tooling.Provisioning): 7 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- Reports (automation/Catzc.Base.Reports): 4 lit files
- Repository (automation/Catzc.Base.Repository): 4 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 4 lit files
- Root files: 3 lit files
- .internal (automation/.internal): 3 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 3 lit files
- Config (automation/Catzc.Base.Config): 3 lit files
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 3 lit files
- Exporter (automation/Catzc.Base.Exporter): 3 lit files
- Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler): 3 lit files
- adr/auto (docs/adr/automation): 3 lit files
- Objects (automation/Catzc.Base.Objects): 2 lit files
- Tool.Toolchain (automation/Catzc.Tooling.Toolchain): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .scriptanalyzer (automation/.scriptanalyzer): 1 lit file
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Environment (automation/Catzc.Base.Environment): 1 lit file
- Files (automation/Catzc.Base.Files): 1 lit file
- Modules (automation/Catzc.Base.Modules): 1 lit file
- Overlay (automation/Catzc.Base.Overlay): 1 lit file
- Timeouts (automation/Catzc.Base.Timeouts): 1 lit file
- Tool.Python (automation/Catzc.Tooling.Python): 1 lit file
- adr/repo (docs/adr/repository): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 283 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan.md][3], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 84
  (text) and line 90 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][4], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 16 (text), line 37 (text) and line 89 (text).
- [docs/how-to/automation/manual-test-plan/test-harness.md][5], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 16 (text) and line 35 (text).
- [docs/how-to/getting-started/automation/run-tests-and-checks.md][6], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 16 (text) and line 56 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md][7], in the cell docs ×
  markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 44 (text).
- [docs/references/automation/catzc-azure-devops/configs/identity-tokens.yml.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-azure-devops/tests/Get-AdoYamlFiles.Tests.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 46 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 37 (text), line 39 (text) and line 42 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 48 (text) and line 56 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleCustomer.Tests.ps1.md][13], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text), line 35 (text), line 47 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleIndexed.Tests.ps1.md][14], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 34 (text), line 34 (text) and line 54 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleSubscription.Tests.ps1.md][15], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 33 (text), line 33 (text), line 45 (text) and line 57 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithModule.Tests.ps1.md][16], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text), line 35 (text), line 47 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md][17], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 40 (text) and line 49 (text).
- [docs/references/automation/catzc-azure-templates/tests/Build-Bicep.Tests.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 34 (text), line 34 (text), line 44 (text) and line 54 (text).
- [docs/references/automation/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md][19], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 42 (text), line 60 (text) and line 69 (text).
- [docs/references/automation/catzc-azure-templates/tests/Deploy-Bicep.Tests.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 77 (text), line 77 (text) and line 87 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepDeploymentContext.Tests.ps1.md][21], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text), line 35 (text), line 46 (text) and line 76 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][22], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 40 (text), line 43 (text), line 46 (text), line 51 (text) and
  line 60 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Tests.ps1.md][23], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterViolations.Tests.ps1.md][24], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md][25], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepResourceName.Tests.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 36 (text) and line 36 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplateConfiguration.Tests.ps1.md][28], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 34 (text) and line 34 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplateCustomers.Tests.ps1.md][29], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text), line 32 (text), line 42 (text) and line 42 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplateNames.Tests.ps1.md][30], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text), line 32 (text), line 51 (text) and line 51 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTemplates.Tests.ps1.md][32], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 36 (text) and line 36 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepTrackTagNameSet.Tests.ps1.md][33], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md][34], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-azure-templates/tests/Set-BicepTemplateConfiguration.Tests.ps1.md][35], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 78 (text).
- [docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][36], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-azure/configs/identity-tokens.yml.md][37], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md][38], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md][39], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md][40], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Get-AzureEnvironment.Tests.ps1.md][41], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1.md][43], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 32 (text).
- [docs/references/automation/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 34 (text) and line 35 (text).
- [docs/references/automation/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md][46], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 33 (text) and line 34 (text).
- [docs/references/automation/catzc-base-config/tests/Config-Conventions.Tests.ps1.md][47], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 41 (text).
- [docs/references/automation/catzc-base-config/tests/Get-Config.Tests.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text), line 42 (text), line 45 (text) and line 63 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][49], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 42 (text).
- [docs/references/automation/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md][50], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-configextensions/tests/Test-ConfigValidators.Tests.ps1.md][51], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md][53], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-contracts/tests/Get-ContractAssetNote.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-contracts/tests/Get-ContractFreezeFindings.Tests.ps1.md][55], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md][57], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs.md][58], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 16 (text) and line 59 (text).
- [docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md][59], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 18 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md][60], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1.md][61], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md][62], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrCitationMap.Tests.ps1.md][63], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md][65], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrFileIndex.Tests.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md][67], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 41 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSummaryLines.Tests.ps1.md][68], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md][69], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md][70], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md][71], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md][72], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossaryAnchorViolations.Tests.ps1.md][73], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md][74], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1.md][75], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossaryFormViolations.Tests.ps1.md][76], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md][77], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md][78], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md][79], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md][80], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/tests/Resolve-AdrLinkTarget.Tests.ps1.md][81], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md][82], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 27 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-AdrRegistry.Tests.ps1.md][83], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 27 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md][84], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-GeneratedReadmes.Tests.ps1.md][85], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][86], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 44 (text) and line 45 (text).
- [docs/references/automation/catzc-base-docs/tests/Update-AdrCitation.Tests.ps1.md][87], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/types/AdrChecksConfig.Tests.ps1.md][88], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md][89], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md][90], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md][91], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md][92], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md][93], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md][94], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][95], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 18 (text) and line 46 (text).
- [docs/references/automation/catzc-base-docs/types/CheckMode.cs.md][96], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 18 (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][97], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 17 (text) and line 56 (text).
- [docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md][98], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 43 (text).
- [docs/references/automation/catzc-base-execution/tests/Find-Executable.Tests.ps1.md][99], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md][100], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md][101], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md][102], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md][103], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md][104], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md][105], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md][106], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text), line 40 (text) and line 42 (text).
- [docs/references/automation/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md][107], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md][108], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md][109], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 33 (text) and line 35 (text).
- [docs/references/automation/catzc-base-files/tests/Get-GitChangedPath.Tests.ps1.md][110], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs.md][111], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 16 (text) and line 66 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][112], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 42 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md][113], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md][114], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][115], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1.md][116], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1.md][117], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md][118], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 42 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][119], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 35 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md][120], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][121], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 55 (text).
- [docs/references/automation/catzc-base-languages.md][122], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 16 (text) and line 71 (text).
- [docs/references/automation/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md][123], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md][124], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md][125], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md][126], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-languages/tests/Invoke-GoTest.Tests.ps1.md][127], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md][128], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md][129], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md][130], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/BashTestResult.cs.md][131], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/catzc-base-languages/types/GoTestResult.cs.md][132], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/catzc-base-languages/types/PythonTestResult.cs.md][133], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 39 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][134], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][135], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][136], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text) and line 37 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][137], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text) and line 37 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][138], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][139], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-modulesystem.md][140], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 16 (text) and line 63 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][141], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 40 (text).
- [docs/references/automation/catzc-base-modulesystem/configs/artifacts.yml.md][142], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 30 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md][143], in the cell docs ×
  markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Tests.ps1.md][144], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 35 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md][145], in the cell docs ×
  markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 37 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Test-CheckedInBinaries.Tests.ps1.md][146], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 41 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md][147], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md][148], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Test-InternalAssetDependency.Tests.ps1.md][149], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Test-ModuleCycles.Tests.ps1.md][150], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-modulesystem/tests/Test-ModuleDependency.Tests.ps1.md][151], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-modulesystem/types/ArtifactsConfig.cs.md][152], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md][153], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md][154], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md][155], in the cell docs × markdown: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md][156], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md][157], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-overlay/tests/Overlay.Fixture.ps1.md][158], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md][159], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 41 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/generated-files.yml.md][160], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md][161], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (text) and line 63 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/terminology.yml.md][162], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 61 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md][163], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md][164], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 136 (text) and line 216 (text).
- [docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md][165], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 62 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Build-EnglishDictionary.Tests.ps1.md][166], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md][167], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Enter-SystemTestLock.Tests.ps1.md][168], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 27 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Format-Code.Tests.ps1.md][169], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text), line 33 (text), line 35 (text) and line 82 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Format-Links.Tests.ps1.md][170], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Format-Types.Tests.ps1.md][171], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md][172], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-BashTestCases.Tests.ps1.md][173], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md][174], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-ChangeTestFile.Tests.ps1.md][175], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-EngineSetFinding.Tests.ps1.md][176], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md][177], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-FormatEngineStamp.Tests.ps1.md][178], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-FormatScope.Tests.ps1.md][179], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-GoTestCases.Tests.ps1.md][180], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestExecutable.Tests.ps1.md][181], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md][182], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md][183], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-LiveIdentityTokens.Tests.ps1.md][184], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-NeutralCodeFinding.Tests.ps1.md][185], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-ParameterTypeConflict.Tests.ps1.md][186], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md][187], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-PythonTestCases.Tests.ps1.md][188], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-RepositoryGuids.Tests.ps1.md][189], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 41 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md][190], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-TestFileModule.Tests.ps1.md][191], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-TestRunContext.Tests.ps1.md][192], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-TestRunFile.Tests.ps1.md][193], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md][194], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-BicepFormat.Tests.ps1.md][195], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-DotnetFormat.Tests.ps1.md][196], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-Gofmt.Tests.ps1.md][197], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-ImprintStep.Tests.ps1.md][198], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-Prettier.Tests.ps1.md][199], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-PythonWorkspaceTool.Tests.ps1.md][200], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-RuffFormat.Tests.ps1.md][201], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Invoke-TestFile.Tests.ps1.md][202], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 40 (text), line 46 (text), line 55 (text) and line 60 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Language.Bridge.ps1.md][203], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text), line 38 (text), line 43 (text) and line 45 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md][204], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Measure-QualityGates.Tests.ps1.md][205], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/New-TestAutomationShardScript.Tests.ps1.md][206], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/New-TestRunFinalManifest.Tests.ps1.md][207], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Save-TestDurationHistory.Tests.ps1.md][208], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Select-TestShardAssignment.Tests.ps1.md][209], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Split-CachedFile.Tests.ps1.md][210], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-AnalyzerAdrMap.Tests.ps1.md][211], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Automation.Tests.ps1.md][212], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-BuildArtifact.Tests.ps1.md][213], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Change.Tests.ps1.md][214], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-ConfigIdentityHygiene.Tests.ps1.md][215], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md][216], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Formatting.Tests.ps1.md][217], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text), line 32 (text) and line 43 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md][218], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Links.Tests.ps1.md][219], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 33 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Links.Untracked.Tests.ps1.md][220], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-LogicTestIdentity.Tests.ps1.md][221], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text), line 35 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-ManagedGuids.Tests.ps1.md][222], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md][223], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Markdownlint.Tests.ps1.md][224], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-ParameterConsistency.Tests.ps1.md][225], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-PythonLint.Tests.ps1.md][226], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text), line 32 (text) and line 42 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md][227], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text), line 33 (text) and line 42 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-ShippedConfigs.Tests.ps1.md][228], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-SourceConventions.Tests.ps1.md][229], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Spelling.Tests.ps1.md][230], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 43 (text) and line 45 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-TestTitles.Tests.ps1.md][231], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md][232], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Write-TestRunFailures.Tests.ps1.md][233], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/EngineSetCheck.Tests.ps1.md][234], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SpellingOracle.Tests.ps1.md][235], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/types/IdentityTokenRule.cs.md][236], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][237], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][238], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-reports/configs/reports.yml.md][239], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md][240], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-reports/types/ReportsConfig.cs.md][241], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md][242], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md][243], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-repository/tests/types/ParsedScripts.Tests.ps1.md][244], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md][245], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-rootconfig.md][246], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 16 (text) and line 76 (text).
- [docs/references/automation/catzc-base-rootconfig/tests/Build-RootConfig.Tests.ps1.md][247], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 65 (text) and line 76 (text).
- [docs/references/automation/catzc-base-rootconfig/tests/Get-RootConfigRenderedFile.Tests.ps1.md][248], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-rootconfig/tests/Test-RootAnalyzerSettings.Tests.ps1.md][249], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigFiles.Tests.ps1.md][250], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md][251], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-timeouts/types/TestTiers.cs.md][252], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md][253], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md][254], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md][255], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 34 (text).
- [docs/references/automation/catzc-base-typessystem/tests/Test-ShippedTypes.Tests.ps1.md][256], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md][257], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-core/tests/Assert-ToolVersion.Tests.ps1.md][258], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-core/tests/Get-ToolConfig.Tests.ps1.md][259], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-tooling-core/tests/Get-ToolInstallOrder.Tests.ps1.md][260], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 35 (text) and line 46 (text).
- [docs/references/automation/catzc-tooling-core/tests/Remove-LinuxToolInstall.Tests.ps1.md][261], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md][262], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md][263], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 27 (text).
- [docs/references/automation/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md][264], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 30 (text) and line 39 (text).
- [docs/references/automation/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md][265], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md][266], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md][267], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][268], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 19 (text) and line 33 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md][269], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-keyhandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1.md][270], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-keyhandler/tests/Select-SupportedKeyHandler.Tests.ps1.md][271], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 27 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md][272], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md][273], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md][274], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md][275], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md][276], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md][277], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md][278], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-tooling-python/tests/Install-PipTool.Tests.ps1.md][279], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-tooling-toolchain/tests/Install-BicepStandalone.Tests.ps1.md][280], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md][281], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/internal/tests/Import-AllModules.Tests.ps1.md][282], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text) and line 102 (text).
- [docs/references/automation/internal/tests/New-BuiltCatzcRoot.Tests.ps1.md][283], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 27 (text).
- [docs/references/automation/internal/tests/Test-FolderConventions.Tests.ps1.md][284], in the cell docs × markdown: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][285], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 17 (text) and line 42 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 140 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1][286], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 25 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1][287], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header), line 35 (header), line 46 (header), line 50 (header), line 56 (header) and line 57 (header).
- [automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1][288], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][289], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header), line 37 (header), line 47 (header), line 49 (header), line 101 (header) and line 113 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][290], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header), line 27 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][291], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header), line 28 (header), line 38 (header) and line 57 (header).
- [automation/Catzc.Base.QualityGates/Test-Change.ps1][292], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-Comments.ps1][293], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1][294], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Base.QualityGates/Test-FileMeta.ps1][295], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1][296], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/Test-Formatting.ps1][297], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1][298], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/Test-Links.ps1][299], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 40 (header).
- [automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1][300], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 22 (header) and line 38 (header).
- [automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1][301], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1][302], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header), line 25 (header) and line 30 (header).
- [automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1][303], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1][304], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header) and line 34 (header).
- [automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1][305], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1][306], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 24 (header) and line 39 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][307], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1][308], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 23 (header), line 28 (header) and line 55 (header).
- [automation/Catzc.Base.QualityGates/Test-Spelling.ps1][309], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 23 (header) and line 31 (header).
- [automation/Catzc.Base.QualityGates/Test-Terminology.ps1][310], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 23 (header) and line 45 (header).
- [automation/Catzc.Base.QualityGates/Test-TestTitles.ps1][311], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header), line 25 (header) and line 30 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][312], in the cell automation × yaml: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 34 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][313], in the cell automation × yaml: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 24 (text), line 40 (text), line 49 (text), line 59 (text), line 86 (text), line 101 (text), line 124 (text), line 136
  (text), line 146 (text), line 156 (text), line 171 (text) and line 185 (text).
- [automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1][314], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1][315], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header), line 27 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1][316], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 24 (header) and line 29 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1][317], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][318], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 25 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][319], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 48 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1][320], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 35 (header).
- [automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1][321], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1][322], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1][323], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1][324], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1][325], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1][326], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 22 (header), line 29 (header) and line 40 (header).
- [automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1][327], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 33 (header).
- [automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1][328], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 23 (header), line 33 (header) and line 61 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1][329], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header), line 28 (header) and line 41 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][330], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header), line 29 (header) and line 50 (text).
- [automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1][331], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1][332], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header), line 40 (header) and line 44 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][333], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1][334], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1][335], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 46 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1][336], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1][337], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1][338], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1][339], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1][340], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1][341], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1][342], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header) and line 118 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1][343], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1][344], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 76 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1][345], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1][346], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 25 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1][347], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1][348], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1][349], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1][350], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1][351], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1][352], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1][353], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1][354], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1][355], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1][356], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1][357], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1][358], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1][359], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 36 (text), line 48 (text), line 60 (text), line 72 (text), line 85 (text),
  line 95 (text) and line 108 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1][360], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1][361], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1][362], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1][363], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1][364], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1][365], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 45 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1][366], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 42 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1][367], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1][368], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][369], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1][370], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1][371], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1][372], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 25 (text), line 25 (body comment) and line 123 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1][373], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1][374], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1][375], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1][376], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1][377], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1][378], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1][379], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1][380], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1][381], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1][382], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 151 (text), line 176 (text), line 249 (text), line 264 (text), line 264
  (body comment) and line 304 (text).
- [automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1][383], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1][384], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1][385], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1][386], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1][387], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1][388], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header), line 24 (text) and line 35 (text).
- [automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1][389], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1][390], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).
- [automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1][391], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1][392], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1][393], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header) and line 38 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1][394], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1][395], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 38 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1][396], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 75 (text), line 84 (text) and line 99 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1][397], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1][398], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1][399], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 72 (text), line 76 (text) and line 94 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1][400], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1][401], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 49 (text) and line 56 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1][402], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 42 (text), line 48 (text), line 62 (text), line 72 (text) and line 85
  (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1][403], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header), line 44 (body comment), line 49 (body comment) and line 62 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1][404], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1][405], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 60 (text), line 64 (text) and line 69 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1][406], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1][407], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1][408], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 43 (text), line 53 (text) and line 63 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1][409], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1][410], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 49 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1][411], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header), line 57 (text), line 66 (text) and line 78 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1][412], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][413], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1][414], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header), line 114 (body comment) and line 125 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1][415], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 44 (text), line 53 (text), line 67 (text) and line 77 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1][416], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1][417], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1][418], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1][419], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1][420], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][421], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1][422], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs][423], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][424], in the cell automation × csharp: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 23 (text).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][425], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (text).

### Docs (automation/Catzc.Base.Docs, 50 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1][426], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/Test-AdrRegistry.ps1][427], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1][428], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1][429], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][430], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 22 (header) and line 39 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][431], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 154 (text); selected by [ADR-AUTO-TEST][2]: the file cites it at line 142 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][432], in the cell automation × yaml: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 95 (body comment), line 116 (text), line 116 (body comment) and line 116 (body comment).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][433], in the cell automation × yaml: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 28 (text), line 33 (body comment), line 38 (text), line 38 (body comment), line 38 (body comment) and line 43 (body comment).
- [automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1][434], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 39 (header).
- [automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1][435], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1][436], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1][437], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1][438], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1][439], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1][440], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 25 (text).
- [automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1][441], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][442], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1][443], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1][444], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1][445], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1][446], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1][447], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1][448], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1][449], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1][450], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1][451], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1][452], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1][453], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1][454], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1][455], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1][456], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1][457], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header), line 26 (text) and line 149 (text).
- [automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1][458], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header), line 25 (text) and line 158 (text).
- [automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1][459], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 77 (text), line 205 (text) and line 214 (text).
- [automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1][460], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][461], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header), line 68 (body comment) and line 110 (text).
- [automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1][462], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 22 (header).
- [automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml][463], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml][464], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 1 (header), line 8 (text) and line 16 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][465], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][466], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1][467], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1][468], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1][469], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][470], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1][471], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1][472], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][473], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 22 (text).
- [automation/Catzc.Base.Docs/types/CheckMode.cs][474], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 21 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][475], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 20 (text).

### Az.Templates (automation/Catzc.Azure.Templates, 29 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1][476], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 30 (header).
- [automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1][477], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][478], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1][479], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1][480], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1][481], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1][482], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1][483], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1][484], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1][485], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1][486], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1][487], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1][488], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][489], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 30 (body comment).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1][490], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1][491], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1][492], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1][493], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1][494], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1][495], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1][496], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1][497], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1][498], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1][499], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1][500], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][501], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1][502], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml][503], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 7 (header).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][504], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 21 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][505], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1][506], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header) and line 25 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][507], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][508], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 38 (header).
- [automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1][509], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1][510], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header) and line 25 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1][511], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1][512], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 36 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1][513], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1][514], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1][515], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1][516], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1][517], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1][518], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 50 (text), line 56 (text) and line 66 (text).
- [automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1][519], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1][520], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1][521], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 39 (text) and line 51 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][522], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][523], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]:
  the file cites it at line 21 (text).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][524], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][525], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 20 (text).

### .claude (15 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][526], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 49 (text).
- [.claude/agents/test-optimization.md][527], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 5
  (text).
- [.claude/plans/decisions-2026-10-16.md][528], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  112 (text) and line 115 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][529], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 177 (text); selected by [ADR-AUTO-TEST][2]: the file cites it at line 26 (text) and line 176 (text).
- [.claude/plans/plan-assert-wait.md][530], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 80
  (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][531], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 164 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][532], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 475 (text).
- [.claude/plans/plan-lazy-types-load.md][533], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  217 (text).
- [.claude/plans/plan-minimal-robots-agents.md][534], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 26 (text) and line 91 (text).
- [.claude/plans/plan-module-kinds-tracks.md][535], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 35 (text), line 219 (text), line 302 (text), line 306 (text), line 369 (text), line 375 (text), line 379 (text), line 398 (text),
  line 551 (text) and line 588 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][536], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 40 (text); selected by [ADR-AUTO-TEST][2]: the file cites it at line 40 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][537], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it
  at line 41 (text).
- [.claude/plans/prompt-module-model-2-implement.md][538], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 35 (text).
- [.claude/skills/catzc-module/SKILL.md][539], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 29
  (text) and line 42 (text).
- [.claude/skills/test-speed/SKILL.md][540], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 4
  (text), line 27 (text), line 39 (text), line 40 (text), line 41 (text), line 43 (text) and line 46 (text).

### Globs (automation/Catzc.Base.Globs, 14 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][541], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header) and line 36 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][542], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 36 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][543], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header) and line 41 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][544], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][545], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1][546], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][547], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 23 (header).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][548], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1][549], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 38 (text), line 49 (text) and line 61 (text).
- [automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1][550], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 37 (text), line 44 (text) and line 55 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1][551], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][552], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 48 (text), line 56 (text) and line 69 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1][553], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][554], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header) and line 66 (body comment).

### Languages (automation/Catzc.Base.Languages, 11 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1][555], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1][556], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][557], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1][558], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1][559], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1][560], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1][561], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1][562], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][563], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][564], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][565], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (text).

### Tool.Core (automation/Catzc.Tooling.Core, 11 lit files)

The group holds the files of automation/Catzc.Tooling.Core; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1][566], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header) and line 32 (header).
- [automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1][567], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1][568], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1][569], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1][570], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1][571], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1][572], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1][573], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).
- [automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1][574], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1][575], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 97 (body comment).
- [automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1][576], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Azure (automation/Catzc.Azure, 10 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/Test-AzureNetworkPlan.ps1][577], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1][578], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1][579], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1][580], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1][581], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1][582], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1][583], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1][584], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][585], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1][586], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).

### Execution (automation/Catzc.Base.Execution, 10 lit files)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Invoke-Executable.ps1][587], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1][588], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1][589], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1][590], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 102 (text) and line 102 (body comment).
- [automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1][591], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1][592], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1][593], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1][594], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1][595], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1][596], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).

### .unordered (9 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][597], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 263 (text).
- [.unordered/15-10-2026/plan-adr-pwsh-followups.md][598], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 45 (text) and line 72 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][599], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text) and line 276 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][600], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 98 (text).
- [.unordered/15-10-2026/plan-contracts.md][601], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 158 (text).
- [.unordered/15-10-2026/plan-explanation-assets-source.md][602], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 82 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][603], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 98 (text) and line 98 (text).
- [.unordered/15-10-2026/plan-strip-comments.md][604], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 113 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][605], in the cell .unordered × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 100 (text) and line 208 (text).

### Maps (automation/Catzc.Base.Maps, 9 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][606], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header) and line 42 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][607], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 22 (header) and line 29 (header).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][608], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 21 (header) and line 29 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][609], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][610], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][611], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header), line 61 (text), line 90 (text), line 96 (text) and line 104 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][612], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header), line 69 (text), line 120 (text), line 127 (text) and line 135 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][613], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][614], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 8 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][615], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][616], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][617], in the cell automation × yaml: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 120 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1][618], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1][619], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1][620], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1][621], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][622], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Contracts (automation/Catzc.Base.Contracts, 7 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Test-Contracts.ps1][623], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1][624], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1][625], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1][626], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1][627], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1][628], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1][629], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 50 (text), line 70 (body comment), line 94 (text) and line 221 (body
  comment).

### Tool.Provisioning (automation/Catzc.Tooling.Provisioning, 7 lit files)

The group holds the files of automation/Catzc.Tooling.Provisioning; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1][630], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1][631], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1][632], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1][633], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1][634], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1][635], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1][636], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### TypesSystem (automation/Catzc.Base.TypesSystem, 5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1][637], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header) and line 25 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][638], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1][639], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][640], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1][641], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Reports (automation/Catzc.Base.Reports, 4 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/Write-QualityGateReport.ps1][642], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1][643], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header), line 33 (text), line 43 (text), line 51 (text) and line 61 (text).
- [automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1][644], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (header), line 24 (text), line 32 (text) and line 39 (text).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][645], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (text).

### Repository (automation/Catzc.Base.Repository, 4 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1][646], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1][647], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1][648], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1][649], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Tool.Inspiration (automation/Catzc.Tooling.Inspiration, 4 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1][650], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1][651], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][652], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1][653], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][654], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TEST][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1` line 20 (header) and
  `automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1` line 20 (header).
- [.gitignore][655], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TEST][2]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1` line 20 (header) and
  `automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1` line 20 (header).
- [importer.ps1][656], in the cell Root files × powershell: selected by [ADR-AUTO-TEST][2]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/tests/Import-AllModules.Tests.ps1` line 20 (header),
  `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 19 (header), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line
  23 (text), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 99 (text) and
  `automation/.internal/tests/Test-FolderConventions.Tests.ps1` line 19 (header).

### .internal (automation/.internal, 3 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/tests/Import-AllModules.Tests.ps1][657], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).
- [automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1][658], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 19 (header), line 23 (text) and line 99 (text).
- [automation/.internal/tests/Test-FolderConventions.Tests.ps1][659], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 19 (header).

### Az.DevOps (automation/Catzc.Azure.DevOps, 3 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][660], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 22 (header) and line 30 (header).
- [automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1][661], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][662], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header), line 67 (text) and line 76 (text).

### Config (automation/Catzc.Base.Config, 3 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1][663], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1][664], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][665], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).

### ConfigExtensions (automation/Catzc.Base.ConfigExtensions, 3 lit files)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][666], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1][667], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1][668], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Exporter (automation/Catzc.Base.Exporter, 3 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1][669], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1][670], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1][671], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler, 3 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1][672], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1][673], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1][674], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).

### adr/auto (docs/adr/automation, 3 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the ADR's own
  file.
- [docs/adr/automation/dora-explains.md][675], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 415
  (text); selected by [ADR-AUTO-TEST][2]: the file cites it at line 208 (text).
- [docs/adr/automation/test-automation.md][2], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the ADR's own file.

### Objects (automation/Catzc.Base.Objects, 2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][676], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][677], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Tool.Toolchain (automation/Catzc.Tooling.Toolchain, 2 lit files)

The group holds the files of automation/Catzc.Tooling.Toolchain; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1][678], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1][679], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][680], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 452 (text), line 490
  (text), line 512 (text), line 558 (text), line 604 (text), line 622 (text), line 634 (text), line 648 (text), line 670 (text), line 684
  (text), line 695 (text) and line 715 (text).
- [docs/adr/index.md][681], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 165 (text); selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 153 (text).

### .scriptanalyzer (automation/.scriptanalyzer, 1 lit file)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1][682], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (header) and line 168 (text).

### Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation, 1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1][683], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml][684], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 5 (header).

### Environment (automation/Catzc.Base.Environment, 1 lit file)

The group holds the files of automation/Catzc.Base.Environment; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1][685], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 20 (header) and line 24 (text).

### Files (automation/Catzc.Base.Files, 1 lit file)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1][686], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### Modules (automation/Catzc.Base.Modules, 1 lit file)

The group holds the files of automation/Catzc.Base.Modules; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1][687], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 20 (header).

### Overlay (automation/Catzc.Base.Overlay, 1 lit file)

The group holds the files of automation/Catzc.Base.Overlay; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1][688], in the cell automation × powershell: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (header).

### Timeouts (automation/Catzc.Base.Timeouts, 1 lit file)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TestTiers.cs][689], in the cell automation × csharp: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 21 (text).

### Tool.Python (automation/Catzc.Tooling.Python, 1 lit file)

The group holds the files of automation/Catzc.Tooling.Python; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1][690], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 20 (header).

### adr/repo (docs/adr/repository, 1 lit file)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/ai-agent-contract.md][691], in the cell docs × markdown: selected by [ADR-AUTO-TEST][2]: the file cites it at line 51
  (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][692], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 154 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs` line 21 (text),
  `automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs` line 20 (text) and `automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs`
  line 20 (text); selected by [ADR-AUTO-TEST][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/.internal/tests/Import-AllModules.Tests.ps1` line 20 (header), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line
  19 (header), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 23 (text),
  `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 99 (text), `automation/.internal/tests/Test-FolderConventions.Tests.ps1`
  line 19 (header), `automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1` line 17 (header),
  `automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1` line 168 (text),
  `automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 22 (header), `automation/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 30 (header),
  `automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 67 (text),
  `automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 76 (text),
  `automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1` line 30 (header),
  `automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 30 (body comment),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml` line 7 (header),
  `automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure/Test-AzureNetworkPlan.ps1` line 21 (header), `automation/Catzc.Azure/Test-AzureNetworkPlan.ps1` line 26 (header),
  `automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1` line 20 (header), `automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1`
  line 20 (header), `automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1` line 20 (header),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 20 (header), `automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1`
  line 20 (header), `automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1` line 21 (header), `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1`
  line 20 (header), `automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1` line 21 (header),
  `automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1` line 26 (header),
  `automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/Test-Contracts.ps1` line 21 (header), `automation/Catzc.Base.Contracts/Test-Contracts.ps1` line 30
  (header), `automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 70 (body comment),
  `automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 221 (body comment),
  `automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1` line 22 (header), `automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1` line
  26 (header), `automation/Catzc.Base.Docs/Test-AdrRegistry.ps1` line 22 (header), `automation/Catzc.Base.Docs/Test-AdrRegistry.ps1` line 27
  (header), `automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1` line 21 (header), `automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1`
  line 26 (header), `automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1` line 26 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 22 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 39 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 142 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 95 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 116 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 116 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 116 (body
  comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 28 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line
  33 (body comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 38 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 38 (body comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line
  38 (body comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 43 (body comment),
  `automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1` line 39 (header),
  `automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1` line 149 (text),
  `automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1` line 158 (text),
  `automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 205 (text),
  `automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 214 (text),
  `automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 21 (header), `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1`
  line 68 (body comment), `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 110 (text),
  `automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml` line 1 (header),
  `automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml` line 6 (text),
  `automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml` line 1 (header),
  `automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml` line 8 (text),
  `automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml` line 16 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1` line 20 (header), `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs`
  line 22 (text), `automation/Catzc.Base.Docs/types/CheckMode.cs` line 21 (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line
  20 (text), `automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml` line 5 (header),
  `automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.Execution/Invoke-Executable.ps1` line 22 (header),
  `automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1` line 102 (text),
  `automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1` line 102 (body comment),
  `automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1` line 36 (header),
  `automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1` line 36 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 22 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1`
  line 41 (header), `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 26 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 23 (header),
  `automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 38 (text),
  `automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 49 (text),
  `automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 61 (text),
  `automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 37 (text),
  `automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 44 (text),
  `automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 55 (text),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 48 (text),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 69 (text),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (body comment),
  `automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/types/BashTestResult.cs` line 21 (text), `automation/Catzc.Base.Languages/types/GoTestResult.cs` line 21
  (text), `automation/Catzc.Base.Languages/types/PythonTestResult.cs` line 21 (text),
  `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 20 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line
  42 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 22 (header), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1`
  line 29 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 21 (header), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 29
  (header), `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 61 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 90 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 96 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 104 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 20 (header), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 69 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 120 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 127 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 135 (body comment), `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1` line 21 (header),
  `automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1` line 25 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1` line 27 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1` line 38 (header),
  `automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1` line 26 (header),
  `automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1` line 21 (header), `automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1`
  line 25 (header), `automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1` line 21 (header),
  `automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1` line 28 (header),
  `automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1` line 36 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1` line 39 (text),
  `automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs` line 21 (text),
  `automation/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1` line 22 (header), `automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1` line
  35 (header), `automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1` line 46 (header),
  `automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1` line 50 (header), `automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1` line
  56 (header), `automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1` line 57 (header),
  `automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1` line 27 (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1`
  line 22 (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 37 (header),
  `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 47 (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line
  49 (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 101 (header),
  `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 113 (header), `automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1`
  line 21 (header), `automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1` line 28 (header), `automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1`
  line 22 (header), `automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1` line 38 (header), `automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1` line
  57 (header), `automation/Catzc.Base.QualityGates/Test-Change.ps1` line 21 (header), `automation/Catzc.Base.QualityGates/Test-Change.ps1`
  line 28 (header), `automation/Catzc.Base.QualityGates/Test-Comments.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-Comments.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1` line 41 (header),
  `automation/Catzc.Base.QualityGates/Test-FileMeta.ps1` line 20 (header), `automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1`
  line 21 (header), `automation/Catzc.Base.QualityGates/Test-Formatting.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-Formatting.ps1` line 26 (header), `automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1`
  line 21 (header), `automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/Test-Links.ps1` line 21 (header), `automation/Catzc.Base.QualityGates/Test-Links.ps1` line 40
  (header), `automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1` line 38 (header),
  `automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1` line 22 (header), `automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1`
  line 27 (header), `automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1` line 30 (header), `automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1`
  line 20 (header), `automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1` line 32 (header),
  `automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1` line 22 (header), `automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1`
  line 34 (header), `automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1` line 24 (header),
  `automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1` line 39 (header),
  `automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1` line 55 (header), `automation/Catzc.Base.QualityGates/Test-Spelling.ps1`
  line 23 (header), `automation/Catzc.Base.QualityGates/Test-Spelling.ps1` line 31 (header),
  `automation/Catzc.Base.QualityGates/Test-Terminology.ps1` line 23 (header), `automation/Catzc.Base.QualityGates/Test-Terminology.ps1` line
  45 (header), `automation/Catzc.Base.QualityGates/Test-TestTitles.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-TestTitles.ps1` line 25 (header), `automation/Catzc.Base.QualityGates/Test-TestTitles.ps1` line
  30 (header), `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 34 (text),
  `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 24 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line
  40 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 49 (text),
  `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 59 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line
  86 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 101 (text),
  `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 124 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line
  136 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 146 (text),
  `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 156 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line
  171 (text), `automation/Catzc.Base.QualityGates/configs/glossary.yml` line 185 (text),
  `automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1` line 32 (header),
  `automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1` line 24 (header),
  `automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1` line 29 (header),
  `automation/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 36 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1` line 48 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1` line 35 (header),
  `automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1` line 25 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1` line 29 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1` line 40 (header),
  `automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1` line 33 (header),
  `automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1` line 33 (header),
  `automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1` line 61 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1` line 41 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 29 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 50 (text),
  `automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1` line 36 (header),
  `automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1` line 40 (header),
  `automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1` line 44 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1` line 36 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1` line 46 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1` line 118 (text),
  `automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1` line 76 (text),
  `automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 36 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 48 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 60 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 72 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 85 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 95 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 108 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1` line 45 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 25 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 123 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 151 (text),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 176 (text),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 249 (text),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 264 (text),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 264 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 304 (text),
  `automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1` line 35 (text),
  `automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1` line 38 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` line 38 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 75 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 84 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 99 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 72 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 76 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` line 49 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 48 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 62 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 72 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 85 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 44 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 49 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 62 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 60 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 64 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 69 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 43 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 53 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 63 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1` line 49 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 57 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1` line 114 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1` line 125 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 44 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 53 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 67 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs` line 23 (text),
  `automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs` line 22 (text), `automation/Catzc.Base.Reports/Write-QualityGateReport.ps1`
  line 21 (header), `automation/Catzc.Base.Reports/Write-QualityGateReport.ps1` line 27 (header),
  `automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 33 (text),
  `automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 43 (text),
  `automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 61 (text),
  `automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 32 (text),
  `automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 39 (text), `automation/Catzc.Base.Reports/types/ReportsConfig.cs`
  line 21 (text), `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1` line 21 (header),
  `automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1` line 26 (header),
  `automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1` line 21 (header), `automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1`
  line 28 (header), `automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 120 (body comment),
  `automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Timeouts/types/TestTiers.cs` line 21 (text), `automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1` line 21
  (header), `automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1` line 25 (header),
  `automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1` line 32 (header),
  `automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1` line 21 (header),
  `automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1` line 21 (header),
  `automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1` line 24 (text),
  `automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1` line 21 (header),
  `automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1` line 97 (body comment),
  `automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1` line 21 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1` line 22 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1` line 21 (header),
  `automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1` line 22 (header),
  `automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1` line 28 (header),
  `automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1` line 24 (text),
  `automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1` line 21 (header),
  `automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1` line 20 (header) and
  `automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1` line 20 (header).

## Keywords

- [world map][693]
- [track][694]
- [file language][695]
- [cell][696]
- [lit cell][697]
- [root file][698]
- [unlisted file][699]
- [.claude][700]: a track
- [.unordered][700]: a track
- [automation][700]: a track
- [docs][700]: a track
- [pipelines][700]: a track
- [csharp][701]: a file language
- [markdown][701]: a file language
- [pipeline-yaml][701]: a file language
- [powershell][701]: a file language
- [yaml][701]: a file language

Terms the cited ADRs define:

- [all tests][702], defined by [ADR-AUTO-TEST#36][703]
- [build verification test][704], defined by [ADR-AUTO-TEST#24][705]
- [category][706], defined by [ADR-AUTO-TEST#1][707]
- [phase][708], defined by [ADR-AUTO-TEST#26][709]
- [quality gate][710], defined by [ADR-AUTO-TEST#35][711]
- [test][712], defined by [ADR-AUTO-TEST#42][713]
- [test file][714], defined by [ADR-AUTO-TEST#43][715]
- [test run][716], defined by [ADR-AUTO-TEST#34][717]
- [test suite][718], defined by [ADR-AUTO-TEST#37][719]
- [testing in production][720], defined by [ADR-AUTO-TEST#41][721]
- [tier][722], defined by [ADR-AUTO-TEST#13][723]
- [vertical test][724], defined by [ADR-AUTO-TEST#38][725]

[1]: ../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../adr/automation/test-automation.md
[3]: ../../../how-to/automation/manual-test-plan.md
[4]: ../../../how-to/automation/manual-test-plan/azure.md
[5]: ../../../how-to/automation/manual-test-plan/test-harness.md
[6]: ../../../how-to/getting-started/automation/run-tests-and-checks.md
[7]: ../../../references/automation/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md
[8]: ../../../references/automation/catzc-azure-devops/configs/identity-tokens.yml.md
[9]: ../../../references/automation/catzc-azure-devops/tests/Get-AdoYamlFiles.Tests.ps1.md
[10]: ../../../references/automation/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md
[11]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md
[12]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md
[13]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.SampleCustomer.Tests.ps1.md
[14]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.SampleIndexed.Tests.ps1.md
[15]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.SampleSubscription.Tests.ps1.md
[16]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithModule.Tests.ps1.md
[17]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md
[18]: ../../../references/automation/catzc-azure-templates/tests/Build-Bicep.Tests.ps1.md
[19]: ../../../references/automation/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md
[20]: ../../../references/automation/catzc-azure-templates/tests/Deploy-Bicep.Tests.ps1.md
[21]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepDeploymentContext.Tests.ps1.md
[22]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[23]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Tests.ps1.md
[24]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterViolations.Tests.ps1.md
[25]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md
[26]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepResourceName.Tests.ps1.md
[27]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md
[28]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTemplateConfiguration.Tests.ps1.md
[29]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTemplateCustomers.Tests.ps1.md
[30]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTemplateNames.Tests.ps1.md
[31]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md
[32]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTemplates.Tests.ps1.md
[33]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepTrackTagNameSet.Tests.ps1.md
[34]: ../../../references/automation/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md
[35]: ../../../references/automation/catzc-azure-templates/tests/Set-BicepTemplateConfiguration.Tests.ps1.md
[36]: ../../../references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[37]: ../../../references/automation/catzc-azure/configs/identity-tokens.yml.md
[38]: ../../../references/automation/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md
[39]: ../../../references/automation/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md
[40]: ../../../references/automation/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md
[41]: ../../../references/automation/catzc-azure/tests/Get-AzureEnvironment.Tests.ps1.md
[42]: ../../../references/automation/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md
[43]: ../../../references/automation/catzc-azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1.md
[44]: ../../../references/automation/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md
[45]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[46]: ../../../references/automation/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md
[47]: ../../../references/automation/catzc-base-config/tests/Config-Conventions.Tests.ps1.md
[48]: ../../../references/automation/catzc-base-config/tests/Get-Config.Tests.ps1.md
[49]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[50]: ../../../references/automation/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md
[51]: ../../../references/automation/catzc-base-configextensions/tests/Test-ConfigValidators.Tests.ps1.md
[52]: ../../../references/automation/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md
[53]: ../../../references/automation/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md
[54]: ../../../references/automation/catzc-base-contracts/tests/Get-ContractAssetNote.Tests.ps1.md
[55]: ../../../references/automation/catzc-base-contracts/tests/Get-ContractFreezeFindings.Tests.ps1.md
[56]: ../../../references/automation/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md
[57]: ../../../references/automation/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md
[58]: ../../../references/automation/catzc-base-docs.md
[59]: ../../../references/automation/catzc-base-docs/configs/adr-checks.yml.md
[60]: ../../../references/automation/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md
[61]: ../../../references/automation/catzc-base-docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1.md
[62]: ../../../references/automation/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md
[63]: ../../../references/automation/catzc-base-docs/tests/Get-AdrCitationMap.Tests.ps1.md
[64]: ../../../references/automation/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md
[65]: ../../../references/automation/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md
[66]: ../../../references/automation/catzc-base-docs/tests/Get-AdrFileIndex.Tests.ps1.md
[67]: ../../../references/automation/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md
[68]: ../../../references/automation/catzc-base-docs/tests/Get-AdrRuleSummaryLines.Tests.ps1.md
[69]: ../../../references/automation/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md
[70]: ../../../references/automation/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md
[71]: ../../../references/automation/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md
[72]: ../../../references/automation/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md
[73]: ../../../references/automation/catzc-base-docs/tests/Get-GlossaryAnchorViolations.Tests.ps1.md
[74]: ../../../references/automation/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md
[75]: ../../../references/automation/catzc-base-docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1.md
[76]: ../../../references/automation/catzc-base-docs/tests/Get-GlossaryFormViolations.Tests.ps1.md
[77]: ../../../references/automation/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md
[78]: ../../../references/automation/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md
[79]: ../../../references/automation/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md
[80]: ../../../references/automation/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md
[81]: ../../../references/automation/catzc-base-docs/tests/Resolve-AdrLinkTarget.Tests.ps1.md
[82]: ../../../references/automation/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md
[83]: ../../../references/automation/catzc-base-docs/tests/Test-AdrRegistry.Tests.ps1.md
[84]: ../../../references/automation/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md
[85]: ../../../references/automation/catzc-base-docs/tests/Test-GeneratedReadmes.Tests.ps1.md
[86]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[87]: ../../../references/automation/catzc-base-docs/tests/Update-AdrCitation.Tests.ps1.md
[88]: ../../../references/automation/catzc-base-docs/tests/types/AdrChecksConfig.Tests.ps1.md
[89]: ../../../references/automation/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md
[90]: ../../../references/automation/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md
[91]: ../../../references/automation/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md
[92]: ../../../references/automation/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
[93]: ../../../references/automation/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md
[94]: ../../../references/automation/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md
[95]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[96]: ../../../references/automation/catzc-base-docs/types/CheckMode.cs.md
[97]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[98]: ../../../references/automation/catzc-base-execution/Invoke-Executable.ps1.md
[99]: ../../../references/automation/catzc-base-execution/tests/Find-Executable.Tests.ps1.md
[100]: ../../../references/automation/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md
[101]: ../../../references/automation/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md
[102]: ../../../references/automation/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md
[103]: ../../../references/automation/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md
[104]: ../../../references/automation/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md
[105]: ../../../references/automation/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md
[106]: ../../../references/automation/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md
[107]: ../../../references/automation/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md
[108]: ../../../references/automation/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md
[109]: ../../../references/automation/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md
[110]: ../../../references/automation/catzc-base-files/tests/Get-GitChangedPath.Tests.ps1.md
[111]: ../../../references/automation/catzc-base-globs.md
[112]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[113]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md
[114]: ../../../references/automation/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md
[115]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[116]: ../../../references/automation/catzc-base-globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1.md
[117]: ../../../references/automation/catzc-base-globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1.md
[118]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md
[119]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[120]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md
[121]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[122]: ../../../references/automation/catzc-base-languages.md
[123]: ../../../references/automation/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md
[124]: ../../../references/automation/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md
[125]: ../../../references/automation/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md
[126]: ../../../references/automation/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md
[127]: ../../../references/automation/catzc-base-languages/tests/Invoke-GoTest.Tests.ps1.md
[128]: ../../../references/automation/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md
[129]: ../../../references/automation/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md
[130]: ../../../references/automation/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md
[131]: ../../../references/automation/catzc-base-languages/types/BashTestResult.cs.md
[132]: ../../../references/automation/catzc-base-languages/types/GoTestResult.cs.md
[133]: ../../../references/automation/catzc-base-languages/types/PythonTestResult.cs.md
[134]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[135]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[136]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[137]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[138]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[139]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[140]: ../../../references/automation/catzc-base-modulesystem.md
[141]: ../../../references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[142]: ../../../references/automation/catzc-base-modulesystem/configs/artifacts.yml.md
[143]: ../../../references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md
[144]: ../../../references/automation/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Tests.ps1.md
[145]: ../../../references/automation/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md
[146]: ../../../references/automation/catzc-base-modulesystem/tests/Test-CheckedInBinaries.Tests.ps1.md
[147]: ../../../references/automation/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md
[148]: ../../../references/automation/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md
[149]: ../../../references/automation/catzc-base-modulesystem/tests/Test-InternalAssetDependency.Tests.ps1.md
[150]: ../../../references/automation/catzc-base-modulesystem/tests/Test-ModuleCycles.Tests.ps1.md
[151]: ../../../references/automation/catzc-base-modulesystem/tests/Test-ModuleDependency.Tests.ps1.md
[152]: ../../../references/automation/catzc-base-modulesystem/types/ArtifactsConfig.cs.md
[153]: ../../../references/automation/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[154]: ../../../references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
[155]: ../../../references/automation/catzc-base-modulesystem/types/ModuleGroup.cs.md
[156]: ../../../references/automation/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
[157]: ../../../references/automation/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md
[158]: ../../../references/automation/catzc-base-overlay/tests/Overlay.Fixture.ps1.md
[159]: ../../../references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
[160]: ../../../references/automation/catzc-base-qualitygates/configs/generated-files.yml.md
[161]: ../../../references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
[162]: ../../../references/automation/catzc-base-qualitygates/configs/terminology.yml.md
[163]: ../../../references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
[164]: ../../../references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md
[165]: ../../../references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md
[166]: ../../../references/automation/catzc-base-qualitygates/tests/Build-EnglishDictionary.Tests.ps1.md
[167]: ../../../references/automation/catzc-base-qualitygates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md
[168]: ../../../references/automation/catzc-base-qualitygates/tests/Enter-SystemTestLock.Tests.ps1.md
[169]: ../../../references/automation/catzc-base-qualitygates/tests/Format-Code.Tests.ps1.md
[170]: ../../../references/automation/catzc-base-qualitygates/tests/Format-Links.Tests.ps1.md
[171]: ../../../references/automation/catzc-base-qualitygates/tests/Format-Types.Tests.ps1.md
[172]: ../../../references/automation/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md
[173]: ../../../references/automation/catzc-base-qualitygates/tests/Get-BashTestCases.Tests.ps1.md
[174]: ../../../references/automation/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md
[175]: ../../../references/automation/catzc-base-qualitygates/tests/Get-ChangeTestFile.Tests.ps1.md
[176]: ../../../references/automation/catzc-base-qualitygates/tests/Get-EngineSetFinding.Tests.ps1.md
[177]: ../../../references/automation/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md
[178]: ../../../references/automation/catzc-base-qualitygates/tests/Get-FormatEngineStamp.Tests.ps1.md
[179]: ../../../references/automation/catzc-base-qualitygates/tests/Get-FormatScope.Tests.ps1.md
[180]: ../../../references/automation/catzc-base-qualitygates/tests/Get-GoTestCases.Tests.ps1.md
[181]: ../../../references/automation/catzc-base-qualitygates/tests/Get-LanguageTestExecutable.Tests.ps1.md
[182]: ../../../references/automation/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md
[183]: ../../../references/automation/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md
[184]: ../../../references/automation/catzc-base-qualitygates/tests/Get-LiveIdentityTokens.Tests.ps1.md
[185]: ../../../references/automation/catzc-base-qualitygates/tests/Get-NeutralCodeFinding.Tests.ps1.md
[186]: ../../../references/automation/catzc-base-qualitygates/tests/Get-ParameterTypeConflict.Tests.ps1.md
[187]: ../../../references/automation/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md
[188]: ../../../references/automation/catzc-base-qualitygates/tests/Get-PythonTestCases.Tests.ps1.md
[189]: ../../../references/automation/catzc-base-qualitygates/tests/Get-RepositoryGuids.Tests.ps1.md
[190]: ../../../references/automation/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md
[191]: ../../../references/automation/catzc-base-qualitygates/tests/Get-TestFileModule.Tests.ps1.md
[192]: ../../../references/automation/catzc-base-qualitygates/tests/Get-TestRunContext.Tests.ps1.md
[193]: ../../../references/automation/catzc-base-qualitygates/tests/Get-TestRunFile.Tests.ps1.md
[194]: ../../../references/automation/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md
[195]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-BicepFormat.Tests.ps1.md
[196]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-DotnetFormat.Tests.ps1.md
[197]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-Gofmt.Tests.ps1.md
[198]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-ImprintStep.Tests.ps1.md
[199]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-Prettier.Tests.ps1.md
[200]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-PythonWorkspaceTool.Tests.ps1.md
[201]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-RuffFormat.Tests.ps1.md
[202]: ../../../references/automation/catzc-base-qualitygates/tests/Invoke-TestFile.Tests.ps1.md
[203]: ../../../references/automation/catzc-base-qualitygates/tests/Language.Bridge.ps1.md
[204]: ../../../references/automation/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md
[205]: ../../../references/automation/catzc-base-qualitygates/tests/Measure-QualityGates.Tests.ps1.md
[206]: ../../../references/automation/catzc-base-qualitygates/tests/New-TestAutomationShardScript.Tests.ps1.md
[207]: ../../../references/automation/catzc-base-qualitygates/tests/New-TestRunFinalManifest.Tests.ps1.md
[208]: ../../../references/automation/catzc-base-qualitygates/tests/Save-TestDurationHistory.Tests.ps1.md
[209]: ../../../references/automation/catzc-base-qualitygates/tests/Select-TestShardAssignment.Tests.ps1.md
[210]: ../../../references/automation/catzc-base-qualitygates/tests/Split-CachedFile.Tests.ps1.md
[211]: ../../../references/automation/catzc-base-qualitygates/tests/Test-AnalyzerAdrMap.Tests.ps1.md
[212]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Automation.Tests.ps1.md
[213]: ../../../references/automation/catzc-base-qualitygates/tests/Test-BuildArtifact.Tests.ps1.md
[214]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Change.Tests.ps1.md
[215]: ../../../references/automation/catzc-base-qualitygates/tests/Test-ConfigIdentityHygiene.Tests.ps1.md
[216]: ../../../references/automation/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md
[217]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Formatting.Tests.ps1.md
[218]: ../../../references/automation/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md
[219]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Links.Tests.ps1.md
[220]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Links.Untracked.Tests.ps1.md
[221]: ../../../references/automation/catzc-base-qualitygates/tests/Test-LogicTestIdentity.Tests.ps1.md
[222]: ../../../references/automation/catzc-base-qualitygates/tests/Test-ManagedGuids.Tests.ps1.md
[223]: ../../../references/automation/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md
[224]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Markdownlint.Tests.ps1.md
[225]: ../../../references/automation/catzc-base-qualitygates/tests/Test-ParameterConsistency.Tests.ps1.md
[226]: ../../../references/automation/catzc-base-qualitygates/tests/Test-PythonLint.Tests.ps1.md
[227]: ../../../references/automation/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md
[228]: ../../../references/automation/catzc-base-qualitygates/tests/Test-ShippedConfigs.Tests.ps1.md
[229]: ../../../references/automation/catzc-base-qualitygates/tests/Test-SourceConventions.Tests.ps1.md
[230]: ../../../references/automation/catzc-base-qualitygates/tests/Test-Spelling.Tests.ps1.md
[231]: ../../../references/automation/catzc-base-qualitygates/tests/Test-TestTitles.Tests.ps1.md
[232]: ../../../references/automation/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md
[233]: ../../../references/automation/catzc-base-qualitygates/tests/Write-TestRunFailures.Tests.ps1.md
[234]: ../../../references/automation/catzc-base-qualitygates/tests/types/EngineSetCheck.Tests.ps1.md
[235]: ../../../references/automation/catzc-base-qualitygates/tests/types/SpellingOracle.Tests.ps1.md
[236]: ../../../references/automation/catzc-base-qualitygates/types/IdentityTokenRule.cs.md
[237]: ../../../references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[238]: ../../../references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[239]: ../../../references/automation/catzc-base-reports/configs/reports.yml.md
[240]: ../../../references/automation/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md
[241]: ../../../references/automation/catzc-base-reports/types/ReportsConfig.cs.md
[242]: ../../../references/automation/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md
[243]: ../../../references/automation/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md
[244]: ../../../references/automation/catzc-base-repository/tests/types/ParsedScripts.Tests.ps1.md
[245]: ../../../references/automation/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md
[246]: ../../../references/automation/catzc-base-rootconfig.md
[247]: ../../../references/automation/catzc-base-rootconfig/tests/Build-RootConfig.Tests.ps1.md
[248]: ../../../references/automation/catzc-base-rootconfig/tests/Get-RootConfigRenderedFile.Tests.ps1.md
[249]: ../../../references/automation/catzc-base-rootconfig/tests/Test-RootAnalyzerSettings.Tests.ps1.md
[250]: ../../../references/automation/catzc-base-rootconfig/tests/Test-RootConfigFiles.Tests.ps1.md
[251]: ../../../references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md
[252]: ../../../references/automation/catzc-base-timeouts/types/TestTiers.cs.md
[253]: ../../../references/automation/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md
[254]: ../../../references/automation/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md
[255]: ../../../references/automation/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md
[256]: ../../../references/automation/catzc-base-typessystem/tests/Test-ShippedTypes.Tests.ps1.md
[257]: ../../../references/automation/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md
[258]: ../../../references/automation/catzc-tooling-core/tests/Assert-ToolVersion.Tests.ps1.md
[259]: ../../../references/automation/catzc-tooling-core/tests/Get-ToolConfig.Tests.ps1.md
[260]: ../../../references/automation/catzc-tooling-core/tests/Get-ToolInstallOrder.Tests.ps1.md
[261]: ../../../references/automation/catzc-tooling-core/tests/Remove-LinuxToolInstall.Tests.ps1.md
[262]: ../../../references/automation/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md
[263]: ../../../references/automation/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md
[264]: ../../../references/automation/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md
[265]: ../../../references/automation/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md
[266]: ../../../references/automation/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md
[267]: ../../../references/automation/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md
[268]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[269]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md
[270]: ../../../references/automation/catzc-tooling-keyhandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1.md
[271]: ../../../references/automation/catzc-tooling-keyhandler/tests/Select-SupportedKeyHandler.Tests.ps1.md
[272]: ../../../references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md
[273]: ../../../references/automation/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md
[274]: ../../../references/automation/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md
[275]: ../../../references/automation/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md
[276]: ../../../references/automation/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md
[277]: ../../../references/automation/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md
[278]: ../../../references/automation/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md
[279]: ../../../references/automation/catzc-tooling-python/tests/Install-PipTool.Tests.ps1.md
[280]: ../../../references/automation/catzc-tooling-toolchain/tests/Install-BicepStandalone.Tests.ps1.md
[281]: ../../../references/automation/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md
[282]: ../../../references/automation/internal/tests/Import-AllModules.Tests.ps1.md
[283]: ../../../references/automation/internal/tests/New-BuiltCatzcRoot.Tests.ps1.md
[284]: ../../../references/automation/internal/tests/Test-FolderConventions.Tests.ps1.md
[285]: ../../../references/pipelines/ci-infrastructure.yaml.md
[286]: ../../../../automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
[287]: ../../../../automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1
[288]: ../../../../automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
[289]: ../../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[290]: ../../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[291]: ../../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[292]: ../../../../automation/Catzc.Base.QualityGates/Test-Change.ps1
[293]: ../../../../automation/Catzc.Base.QualityGates/Test-Comments.ps1
[294]: ../../../../automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
[295]: ../../../../automation/Catzc.Base.QualityGates/Test-FileMeta.ps1
[296]: ../../../../automation/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1
[297]: ../../../../automation/Catzc.Base.QualityGates/Test-Formatting.ps1
[298]: ../../../../automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
[299]: ../../../../automation/Catzc.Base.QualityGates/Test-Links.ps1
[300]: ../../../../automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
[301]: ../../../../automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
[302]: ../../../../automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
[303]: ../../../../automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
[304]: ../../../../automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1
[305]: ../../../../automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
[306]: ../../../../automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
[307]: ../../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[308]: ../../../../automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1
[309]: ../../../../automation/Catzc.Base.QualityGates/Test-Spelling.ps1
[310]: ../../../../automation/Catzc.Base.QualityGates/Test-Terminology.ps1
[311]: ../../../../automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
[312]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[313]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[314]: ../../../../automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
[315]: ../../../../automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
[316]: ../../../../automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
[317]: ../../../../automation/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1
[318]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[319]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[320]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
[321]: ../../../../automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1
[322]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
[323]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
[324]: ../../../../automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
[325]: ../../../../automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
[326]: ../../../../automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
[327]: ../../../../automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
[328]: ../../../../automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
[329]: ../../../../automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
[330]: ../../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[331]: ../../../../automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
[332]: ../../../../automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
[333]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[334]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
[335]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1
[336]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
[337]: ../../../../automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
[338]: ../../../../automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
[339]: ../../../../automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
[340]: ../../../../automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
[341]: ../../../../automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
[342]: ../../../../automation/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1
[343]: ../../../../automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
[344]: ../../../../automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
[345]: ../../../../automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
[346]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
[347]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
[348]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
[349]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
[350]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1
[351]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
[352]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1
[353]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
[354]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
[355]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
[356]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
[357]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
[358]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
[359]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1
[360]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
[361]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
[362]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
[363]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
[364]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
[365]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
[366]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
[367]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
[368]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
[369]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[370]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
[371]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
[372]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
[373]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
[374]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
[375]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
[376]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
[377]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
[378]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
[379]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
[380]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
[381]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
[382]: ../../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
[383]: ../../../../automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
[384]: ../../../../automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
[385]: ../../../../automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
[386]: ../../../../automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
[387]: ../../../../automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
[388]: ../../../../automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
[389]: ../../../../automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
[390]: ../../../../automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
[391]: ../../../../automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
[392]: ../../../../automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
[393]: ../../../../automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
[394]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
[395]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
[396]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
[397]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
[398]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
[399]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
[400]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
[401]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
[402]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
[403]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
[404]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
[405]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
[406]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
[407]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
[408]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
[409]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
[410]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
[411]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
[412]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
[413]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[414]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
[415]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
[416]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
[417]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
[418]: ../../../../automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
[419]: ../../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
[420]: ../../../../automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
[421]: ../../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[422]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
[423]: ../../../../automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
[424]: ../../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[425]: ../../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[426]: ../../../../automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1
[427]: ../../../../automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
[428]: ../../../../automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
[429]: ../../../../automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
[430]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[431]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[432]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[433]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[434]: ../../../../automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
[435]: ../../../../automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
[436]: ../../../../automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
[437]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1
[438]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
[439]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
[440]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1
[441]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1
[442]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[443]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1
[444]: ../../../../automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
[445]: ../../../../automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
[446]: ../../../../automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
[447]: ../../../../automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
[448]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
[449]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
[450]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
[451]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
[452]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
[453]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
[454]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
[455]: ../../../../automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
[456]: ../../../../automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1
[457]: ../../../../automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1
[458]: ../../../../automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
[459]: ../../../../automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
[460]: ../../../../automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
[461]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[462]: ../../../../automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
[463]: ../../../../automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
[464]: ../../../../automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
[465]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[466]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[467]: ../../../../automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
[468]: ../../../../automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
[469]: ../../../../automation/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1
[470]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[471]: ../../../../automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
[472]: ../../../../automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
[473]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[474]: ../../../../automation/Catzc.Base.Docs/types/CheckMode.cs
[475]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[476]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
[477]: ../../../../automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
[478]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[479]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
[480]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
[481]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
[482]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
[483]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
[484]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
[485]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
[486]: ../../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
[487]: ../../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
[488]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
[489]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[490]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
[491]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
[492]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
[493]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
[494]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
[495]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
[496]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
[497]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
[498]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
[499]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
[500]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
[501]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[502]: ../../../../automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
[503]: ../../../../automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
[504]: ../../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[505]: ../../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[506]: ../../../../automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
[507]: ../../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[508]: ../../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[509]: ../../../../automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
[510]: ../../../../automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
[511]: ../../../../automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
[512]: ../../../../automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
[513]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
[514]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
[515]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
[516]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
[517]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
[518]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
[519]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
[520]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
[521]: ../../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
[522]: ../../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[523]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[524]: ../../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[525]: ../../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[526]: ../../../../.claude/CLAUDE.md
[527]: ../../../../.claude/agents/test-optimization.md
[528]: ../../../../.claude/plans/decisions-2026-10-16.md
[529]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[530]: ../../../../.claude/plans/plan-assert-wait.md
[531]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[532]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[533]: ../../../../.claude/plans/plan-lazy-types-load.md
[534]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[535]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[536]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[537]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[538]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[539]: ../../../../.claude/skills/catzc-module/SKILL.md
[540]: ../../../../.claude/skills/test-speed/SKILL.md
[541]: ../../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[542]: ../../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[543]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[544]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[545]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[546]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
[547]: ../../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[548]: ../../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[549]: ../../../../automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
[550]: ../../../../automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
[551]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
[552]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[553]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
[554]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[555]: ../../../../automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
[556]: ../../../../automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
[557]: ../../../../automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[558]: ../../../../automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
[559]: ../../../../automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
[560]: ../../../../automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
[561]: ../../../../automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
[562]: ../../../../automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
[563]: ../../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[564]: ../../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[565]: ../../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[566]: ../../../../automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
[567]: ../../../../automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
[568]: ../../../../automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
[569]: ../../../../automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
[570]: ../../../../automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
[571]: ../../../../automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
[572]: ../../../../automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
[573]: ../../../../automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
[574]: ../../../../automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
[575]: ../../../../automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
[576]: ../../../../automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
[577]: ../../../../automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
[578]: ../../../../automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
[579]: ../../../../automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
[580]: ../../../../automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
[581]: ../../../../automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
[582]: ../../../../automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
[583]: ../../../../automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
[584]: ../../../../automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
[585]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[586]: ../../../../automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
[587]: ../../../../automation/Catzc.Base.Execution/Invoke-Executable.ps1
[588]: ../../../../automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
[589]: ../../../../automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
[590]: ../../../../automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
[591]: ../../../../automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
[592]: ../../../../automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
[593]: ../../../../automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
[594]: ../../../../automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
[595]: ../../../../automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
[596]: ../../../../automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
[597]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[598]: ../../../../.unordered/15-10-2026/plan-adr-pwsh-followups.md
[599]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[600]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[601]: ../../../../.unordered/15-10-2026/plan-contracts.md
[602]: ../../../../.unordered/15-10-2026/plan-explanation-assets-source.md
[603]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[604]: ../../../../.unordered/15-10-2026/plan-strip-comments.md
[605]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[606]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[607]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[608]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[609]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[610]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[611]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[612]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[613]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[614]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[615]: ../../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[616]: ../../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[617]: ../../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[618]: ../../../../automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
[619]: ../../../../automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
[620]: ../../../../automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
[621]: ../../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
[622]: ../../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[623]: ../../../../automation/Catzc.Base.Contracts/Test-Contracts.ps1
[624]: ../../../../automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
[625]: ../../../../automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
[626]: ../../../../automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
[627]: ../../../../automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
[628]: ../../../../automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
[629]: ../../../../automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
[630]: ../../../../automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
[631]: ../../../../automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
[632]: ../../../../automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
[633]: ../../../../automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
[634]: ../../../../automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
[635]: ../../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
[636]: ../../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
[637]: ../../../../automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
[638]: ../../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[639]: ../../../../automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
[640]: ../../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[641]: ../../../../automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
[642]: ../../../../automation/Catzc.Base.Reports/Write-QualityGateReport.ps1
[643]: ../../../../automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
[644]: ../../../../automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
[645]: ../../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[646]: ../../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
[647]: ../../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
[648]: ../../../../automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1
[649]: ../../../../automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1
[650]: ../../../../automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
[651]: ../../../../automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
[652]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[653]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
[654]: ../../../../.gitattributes
[655]: ../../../../.gitignore
[656]: ../../../../importer.ps1
[657]: ../../../../automation/.internal/tests/Import-AllModules.Tests.ps1
[658]: ../../../../automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
[659]: ../../../../automation/.internal/tests/Test-FolderConventions.Tests.ps1
[660]: ../../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[661]: ../../../../automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
[662]: ../../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[663]: ../../../../automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
[664]: ../../../../automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[665]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[666]: ../../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[667]: ../../../../automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
[668]: ../../../../automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
[669]: ../../../../automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
[670]: ../../../../automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
[671]: ../../../../automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
[672]: ../../../../automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
[673]: ../../../../automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
[674]: ../../../../automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
[675]: ../../../adr/automation/dora-explains.md
[676]: ../../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[677]: ../../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[678]: ../../../../automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
[679]: ../../../../automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
[680]: ../../../adr/glossary.md
[681]: ../../../adr/index.md
[682]: ../../../../automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1
[683]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
[684]: ../../../../automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml
[685]: ../../../../automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
[686]: ../../../../automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
[687]: ../../../../automation/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1
[688]: ../../../../automation/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1
[689]: ../../../../automation/Catzc.Base.Timeouts/types/TestTiers.cs
[690]: ../../../../automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1
[691]: ../../../adr/repository/ai-agent-contract.md
[692]: ../../../../pipelines/ci-automation.yaml
[693]: ../../../adr/glossary.md#world-map
[694]: ../../../adr/glossary.md#track
[695]: ../../../adr/glossary.md#file-language
[696]: ../../../adr/glossary.md#cell
[697]: ../../../adr/glossary.md#lit-cell
[698]: ../../../adr/glossary.md#root-file
[699]: ../../../adr/glossary.md#unlisted-file
[700]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[701]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[702]: ../../../adr/glossary.md#all-tests
[703]: ../../../adr/automation/test-automation.md#rule-adr-auto-test36
[704]: ../../../adr/glossary.md#build-verification-test
[705]: ../../../adr/automation/test-automation.md#rule-adr-auto-test24
[706]: ../../../adr/glossary.md#category
[707]: ../../../adr/automation/test-automation.md#rule-adr-auto-test1
[708]: ../../../adr/glossary.md#phase
[709]: ../../../adr/automation/test-automation.md#rule-adr-auto-test26
[710]: ../../../adr/glossary.md#quality-gate
[711]: ../../../adr/automation/test-automation.md#rule-adr-auto-test35
[712]: ../../../adr/glossary.md#test
[713]: ../../../adr/automation/test-automation.md#rule-adr-auto-test42
[714]: ../../../adr/glossary.md#test-file
[715]: ../../../adr/automation/test-automation.md#rule-adr-auto-test43
[716]: ../../../adr/glossary.md#test-run
[717]: ../../../adr/automation/test-automation.md#rule-adr-auto-test34
[718]: ../../../adr/glossary.md#test-suite
[719]: ../../../adr/automation/test-automation.md#rule-adr-auto-test37
[720]: ../../../adr/glossary.md#testing-in-production
[721]: ../../../adr/automation/test-automation.md#rule-adr-auto-test41
[722]: ../../../adr/glossary.md#tier
[723]: ../../../adr/automation/test-automation.md#rule-adr-auto-test13
[724]: ../../../adr/glossary.md#vertical-test
[725]: ../../../adr/automation/test-automation.md#rule-adr-auto-test38

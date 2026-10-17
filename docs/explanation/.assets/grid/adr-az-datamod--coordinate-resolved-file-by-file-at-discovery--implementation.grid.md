# docs/explanation/.assets/grid/adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation.grid.md

`Grid minimap: adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation`

![Grid minimap of adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation](adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation.grid.png)

The grid minimap of the slide `adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation` (implementation lens). The
slide supports [ADR-AZ-CUSTOMER][1] and [ADR-AZ-DATAMOD][2]; the highlight of those ADR codes selects what is lit, and each reason below
names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 71 files
- .unordered × markdown: 5 lit of 20 files
- automation × csharp: 12 lit of 274 files
- automation × powershell: 31 lit of 1579 files
- automation × yaml: 4 lit of 109 files
- docs × markdown: 38 lit of 2165 files
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

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][6]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 27 (text) and line
  175 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 175 (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][8]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 72 (text).
- [.unordered/15-10-2026/plan-caf-code-segments.md][9]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 66 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][10]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text) and line 28
  (text).
- [.unordered/15-10-2026/plan-concern-axis.md][11]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 110 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][12]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text) and line 18
  (text).

### automation × csharp (12 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][13]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 21 (text).
- [automation/Catzc.Azure.Templates/types/BicepTemplate.cs][14]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 20 (text).
- [automation/Catzc.Azure/types/AzureConfig.cs][15]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 23 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 24 (text).
- [automation/Catzc.Azure/types/AzureCustomer.cs][16]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 21 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][17]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][18]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 21 (text);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][19]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Azure/types/CustomerConfig.cs][20]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][21]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][22]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConfig.cs][23]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs][24]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 22
  (text).

### automation × powershell (31 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][25]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header) and
  line 35 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1][26]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21 (header) and
  line 29 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][27]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header) and line
  34 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1][28]: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1][29]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][30]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][31]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header) and line
  34 (header).
- [automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1][32]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1][33]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (header) and line 46 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1][34]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (header) and line 30 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][35]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 22 (header);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 23 (header), line 35 (header) and line 61 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][36]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22
  (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1][37]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 20 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1][38]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20
  (header) and line 27 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1][39]: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1][40]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it
  at line 21 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1][41]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line
  21 (header) and line 34 (header).
- [automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1][42]: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 21 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1][43]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][44]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 21 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][45]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 21 (header) and line 30 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][46]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 21 (header), line 49 (text), line 55 (text), line 72 (text), line 78 (text), line 83 (text), line 89 (text), line 126 (text), line
  130 (text), line 130 (body comment), line 135 (text) and line 139 (text).
- [automation/Catzc.Azure/Get-AzureCustomers.ps1][47]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 20 (header) and line 27
  (header).
- [automation/Catzc.Azure/Get-AzureEnvironment.ps1][48]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (header) and line 29
  (header).
- [automation/Catzc.Azure/Get-AzureSubscription.ps1][49]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 21 (header) and line
  33 (header); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header) and line 32 (header).
- [automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1][50]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (header)
  and line 25 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][51]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 21 (header);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 22 (header), line 250 (text), line 285 (text), line 291 (text), line 299
  (text), line 307 (text), line 313 (text) and line 321 (text).
- [automation/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1][52]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 19 (header)
  and line 79 (text).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][53]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 24 (header) and line 134
  (text).
- [automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1][54]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1][55]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/configs/glossary.yml][56]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 24 (text) and line
  116 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][57]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 274 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 269 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][58]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 627 (text).
- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][59]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21 (body
  comment) (a passing mention only).

### docs × markdown (38 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/azure-customer-model.md][1]: selected by [ADR-AZ-CUSTOMER][1]: the ADR's own file.
- [docs/adr/azure/azure-data-model.md][2]: selected by [ADR-AZ-DATAMOD][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][60]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 92 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 41 (text).
- [docs/adr/glossary.md][61]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 784 (text) and line 829 (text).
- [docs/adr/index.md][62]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 279 (text); selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 274 (text) and line 394 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][63]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text), line 37
  (text) and line 80 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][64]: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 17 (text) and line 44 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md][65]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][66]: selected by [ADR-AZ-CUSTOMER][1]:
  the file cites it at line 18 (text) and line 41 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][67]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 17 (text) and line 59 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][68]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17
  (text) and line 80 (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][69]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 42
  (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][70]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 90 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 79 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][71]: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-azure-templates/types/BicepTemplate.cs.md][72]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 43 (text).
- [docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md][73]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 29
  (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][74]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 85 (text);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text), line 75 (text) and line 120 (text).
- [docs/references/automation/catzc-azure/configs/customer.yml.md][75]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 28
  (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][76]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 45 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 49 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][77]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 19
  (text) and line 63 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text), line 34 (text), line 49 (text), line 59
  (text) and line 65 (text).
- [docs/references/automation/catzc-azure/types/AzureCustomer.cs.md][78]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 30
  (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][79]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 30 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][80]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 18 (text) and line 42 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][81]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 30
  (text).
- [docs/references/automation/catzc-azure/types/CustomerConfig.cs.md][82]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 18
  (text), line 31 (text), line 43 (text) and line 45 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][83]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 19
  (text) and line 43 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][84]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  19 (text) and line 47 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConfig.cs.md][85]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  17 (text) and line 46 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md][86]: selected by [ADR-AZ-CUSTOMER][1]: the file cites
  it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][87]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 42 (text).
- [docs/references/automation/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md][88]: selected by [ADR-AZ-CUSTOMER][1]: the file
  cites it at line 18 (text) and line 45 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][89]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  70 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][90]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 30
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][91]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 31
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][92]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 30
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][93]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 32 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][94]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 18 (text) and line
  44 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][95]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][96]: selected by [ADR-AZ-CUSTOMER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs` line 21 (text),
  `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1` line 22 (header),
  `automation/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/types/BicepTemplate.cs` line 20 (text), `automation/Catzc.Azure/Get-AzureCustomers.ps1` line 20
  (header), `automation/Catzc.Azure/Get-AzureCustomers.ps1` line 27 (header), `automation/Catzc.Azure/Get-AzureSubscription.ps1` line 21
  (header), `automation/Catzc.Azure/Get-AzureSubscription.ps1` line 33 (header), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 21 (header), `automation/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1` line 79 (text), `automation/Catzc.Azure/types/AzureConfig.cs` line 23
  (text), `automation/Catzc.Azure/types/AzureCustomer.cs` line 21 (text), `automation/Catzc.Azure/types/AzureSubscriptionRecord.cs` line 21
  (text), `automation/Catzc.Azure/types/CustomerConfig.cs` line 22 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 274 (text),
  `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 23 (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 22 (text),
  `automation/Catzc.Base.Docs/types/GlossaryConfig.cs` line 21 (text) and `automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs`
  line 22 (text); selected by [ADR-AZ-DATAMOD][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 22 (header), `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 35
  (header), `automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1` line 29 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1` line 22
  (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1` line 34 (header),
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
  `automation/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment).

## Keywords

- [world map][97]
- [track][98]
- [file language][99]
- [cell][100]
- [lit cell][101]
- [.claude][102]: a track
- [.unordered][102]: a track
- [automation][102]: a track
- [docs][102]: a track
- [pipelines][102]: a track
- [csharp][103]: a file language
- [markdown][103]: a file language
- [pipeline-yaml][103]: a file language
- [powershell][103]: a file language
- [yaml][103]: a file language

Terms the cited ADRs define:

- [environment class][104], defined by [ADR-AZ-DATAMOD#11][105]
- [slot][106], defined by [ADR-AZ-DATAMOD#2][107]

[1]: ../../../adr/azure/azure-customer-model.md
[2]: ../../../adr/azure/azure-data-model.md
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
[13]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[14]: ../../../../automation/Catzc.Azure.Templates/types/BicepTemplate.cs
[15]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[16]: ../../../../automation/Catzc.Azure/types/AzureCustomer.cs
[17]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[18]: ../../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[19]: ../../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[20]: ../../../../automation/Catzc.Azure/types/CustomerConfig.cs
[21]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[22]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[23]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConfig.cs
[24]: ../../../../automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
[25]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[26]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
[27]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[28]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
[29]: ../../../../automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
[30]: ../../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[31]: ../../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[32]: ../../../../automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
[33]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
[34]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
[35]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[36]: ../../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[37]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
[38]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
[39]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
[40]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1
[41]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
[42]: ../../../../automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
[43]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
[44]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[45]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[46]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[47]: ../../../../automation/Catzc.Azure/Get-AzureCustomers.ps1
[48]: ../../../../automation/Catzc.Azure/Get-AzureEnvironment.ps1
[49]: ../../../../automation/Catzc.Azure/Get-AzureSubscription.ps1
[50]: ../../../../automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
[51]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[52]: ../../../../automation/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1
[53]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[54]: ../../../../automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
[55]: ../../../../automation/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1
[56]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[57]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[58]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[59]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[60]: ../../../adr/azure/dora-explains.md
[61]: ../../../adr/glossary.md
[62]: ../../../adr/index.md
[63]: ../../../how-to/automation/manual-test-plan/azure.md
[64]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[65]: ../../../references/automation/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md
[66]: ../../../references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[67]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[68]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[69]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[70]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[71]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[72]: ../../../references/automation/catzc-azure-templates/types/BicepTemplate.cs.md
[73]: ../../../references/automation/catzc-azure/Get-AzureSubscription.ps1.md
[74]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[75]: ../../../references/automation/catzc-azure/configs/customer.yml.md
[76]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[77]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[78]: ../../../references/automation/catzc-azure/types/AzureCustomer.cs.md
[79]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[80]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[81]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[82]: ../../../references/automation/catzc-azure/types/CustomerConfig.cs.md
[83]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[84]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[85]: ../../../references/automation/catzc-base-docs/types/GlossaryConfig.cs.md
[86]: ../../../references/automation/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md
[87]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[88]: ../../../references/automation/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md
[89]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[90]: ../../../references/infrastructure/templates/discovery/options.yml.md
[91]: ../../../references/infrastructure/templates/expedition/options.yml.md
[92]: ../../../references/infrastructure/templates/foundation/options.yml.md
[93]: ../../../references/pipelines/cd-shared.yaml.md
[94]: ../../../references/pipelines/ci-infrastructure.yaml.md
[95]: ../../../references/pipelines/extends/cd-customer.yaml.md
[96]: ../../../../pipelines/ci-automation.yaml
[97]: ../../../adr/glossary.md#world-map
[98]: ../../../adr/glossary.md#track
[99]: ../../../adr/glossary.md#file-language
[100]: ../../../adr/glossary.md#cell
[101]: ../../../adr/glossary.md#lit-cell
[102]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[103]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[104]: ../../../adr/glossary.md#environment-class
[105]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[106]: ../../../adr/glossary.md#slot
[107]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

---
catzc:
  immutable:
    with_body_sha: "00c8490f2a17"
    repo_status: locked
    path: docs/explanation/azure/.assets/two-layers-join-through-one-resolver/grid.md
    source: docs/explanation/azure/.assets/two-layers-join-through-one-resolver/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Templating and identity join through one shared check and one resolver: the world-map minimap

```text
Where the files that cite ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 76 files.
```

![The world-map minimap of Templating and identity join through one shared check and one resolver](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [Templating and identity join through one shared check and one
resolver][80], which explains [ADR-AZ-CUSTOMER][1] and [ADR-AZ-DATAMOD][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 65 lit of 2761 files
- pipelines × pipeline-yaml: 1 lit of 11 files
- pwsh × powershell: 4 lit of 1649 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-promotion-ladder.md][6]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 56 (text).

### docs × markdown (65 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/azure-customer-model.md][1]: selected by [ADR-AZ-CUSTOMER][1]: the ADR's own file.
- [docs/adr/azure/azure-data-model.md][2]: selected by [ADR-AZ-DATAMOD][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][7]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 60 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 9 (text).
- [docs/adr/glossary.md][8]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 1005 (text) and line 1053 (text).
- [docs/adr/index.md][9]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 285 (text); selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 280 (text) and line 405 (text).
- [docs/how-to/pwsh/manual-test-plan/azure.md][10]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 15 (text) and line 58 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][11]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 62 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 61 (text) and line
  61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][12]: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 58 (text) and line 73 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][13]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 44 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 42 (text) and line
  48 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][14]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 50 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 50 (text) and line
  72 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][15]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][16]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][17]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][18]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][19]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 24 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][20]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][21]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][22]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][23]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][24]: selected by [ADR-AZ-CUSTOMER][1]: the file cites
  it at line 101 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 101 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][25]: selected by [ADR-AZ-CUSTOMER][1]: the file
  cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md][26]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md][27]: selected by [ADR-AZ-CUSTOMER][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md][28]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line
  94 (text).
- [docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md][29]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 129
  (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][30]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text)
  and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][31]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][32]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][33]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][34]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  128 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text), line 46 (text) and line 117 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][35]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][36]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 24 (text), line 30 (text), line 101 (text) and line 108 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][37]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it
  at line 94 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 32 (text), line 94 (text) and line 100 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md][38]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 22 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md][39]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][40]: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md][41]: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][42]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md][43]: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md][44]: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][45]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][46]: selected by [ADR-AZ-DATAMOD][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md][47]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 27
  (text).
- [docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md][48]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md][49]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md][50]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 19 (text)
  and line 46 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][51]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-azure/azure-identity-resolves-from-config.drawio.md][52]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it
  at line 103 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][53]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 66 (text);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 56 (text), line 83 (text) and line 102 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][54]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][55]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  26 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][56]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 43 (text);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11 (text), line 26 (text), line 37 (text), line 39 (text) and line 45 (text).
- [docs/references/pwsh/catzc-azure/types/AzureCustomer.cs.md][57]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][58]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11
  (text) and line 20 (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][59]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 22
  (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][60]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/CustomerConfig.cs.md][61]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 11 (text),
  line 23 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][62]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][63]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 24
  (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md][64]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 26
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md][65]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at
  line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][66]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][67]: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 53 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md][68]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it
  at line 25 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][69]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 51
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][70]: selected by [ADR-AZ-CUSTOMER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1` line 57 (text) and
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 260 (text); selected by [ADR-AZ-DATAMOD][2]: a pipeline that cites nothing itself carries its
  globset's citations, which cite it at `pwsh/Catzc.Azure.Templates/configs/glossary.yml` line 5 (text),
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
  `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 255 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 290
  (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 296 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line
  304 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 312 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 318 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 326 (text), `pwsh/Catzc.Base.Docs/configs/adr-index.yml` line
  44 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 617 (text)
  and `pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment).

### pwsh × powershell (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][71]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 5 (text).
- [pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][72]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 25 (text), line 31 (text), line 48 (text), line 54 (text), line 59 (text), line 65 (text), line 102 (text), line 106 (text), line 106
  (body comment), line 111 (text) and line 115 (text).
- [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][73]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 255 (text), line 290
  (text), line 296 (text), line 304 (text), line 312 (text), line 318 (text) and line 326 (text).
- [pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1][74]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 57 (text).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Azure.Templates/configs/glossary.yml][75]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 5 (text) and line 101
  (text).
- [pwsh/Catzc.Base.Docs/configs/adr-index.yml][76]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 44 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][77]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 260 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 255 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][78]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 617 (text).
- [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml][79]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21 (body comment) (a
  passing mention only).

## Keywords

- [world map][81]
- [track][82]
- [file language][83]
- [cell][84]
- [lit cell][85]
- [.claude][86]: a track
- [docs][86]: a track
- [pipelines][86]: a track
- [pwsh][86]: a track
- [markdown][87]: a file language
- [pipeline-yaml][87]: a file language
- [powershell][87]: a file language
- [yaml][87]: a file language

Terms the cited ADRs define:

- [environment class][88], defined by [ADR-AZ-DATAMOD#11][89]
- [slot][90], defined by [ADR-AZ-DATAMOD#2][91]

[1]: ../../../../adr/azure/azure-customer-model.md
[2]: ../../../../adr/azure/azure-data-model.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/plans/plan-promotion-ladder.md
[7]: ../../../../adr/azure/dora-explains.md
[8]: ../../../../adr/glossary.md
[9]: ../../../../adr/index.md
[10]: ../../../../how-to/pwsh/manual-test-plan/azure.md
[11]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[12]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[13]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[14]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[15]: ../../../../references/infrastructure/templates/discovery/options.yml.md
[16]: ../../../../references/infrastructure/templates/expedition/options.yml.md
[17]: ../../../../references/infrastructure/templates/foundation/options.yml.md
[18]: ../../../../references/pipelines/cd-shared.yaml.md
[19]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[20]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[21]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[24]: ../../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[25]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[26]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md
[27]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md
[28]: ../../../../references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
[30]: ../../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[31]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[32]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[33]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[34]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[35]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[36]: ../../../../references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[37]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[38]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
[39]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
[40]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[41]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md
[42]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[43]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
[44]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
[45]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[46]: ../../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[47]: ../../../../references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md
[48]: ../../../../references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md
[49]: ../../../../references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
[50]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
[51]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[52]: ../../../../references/pwsh/catzc-azure/azure-identity-resolves-from-config.drawio.md
[53]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[54]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[55]: ../../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[56]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[57]: ../../../../references/pwsh/catzc-azure/types/AzureCustomer.cs.md
[58]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[59]: ../../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[60]: ../../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[61]: ../../../../references/pwsh/catzc-azure/types/CustomerConfig.cs.md
[62]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[63]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[64]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md
[65]: ../../../../references/pwsh/catzc-base-qualitygates/configs/analyzer-adr-map.yml.md
[66]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[67]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[68]: ../../../../references/pwsh/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md
[69]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[70]: ../../../../../pipelines/ci-automation.yaml
[71]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[72]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[73]: ../../../../../pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[74]: ../../../../../pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1
[75]: ../../../../../pwsh/Catzc.Azure.Templates/configs/glossary.yml
[76]: ../../../../../pwsh/Catzc.Base.Docs/configs/adr-index.yml
[77]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[78]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[79]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml
[80]: ../../two-layers-join-through-one-resolver.md
[81]: ../../../../adr/glossary.md#world-map
[82]: ../../../../adr/glossary.md#track
[83]: ../../../../adr/glossary.md#file-language
[84]: ../../../../adr/glossary.md#cell
[85]: ../../../../adr/glossary.md#lit-cell
[86]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[87]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[88]: ../../../../adr/glossary.md#environment-class
[89]: ../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[90]: ../../../../adr/glossary.md#slot
[91]: ../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

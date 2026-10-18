---
catzc:
  immutable:
    with_body_sha: "71efe0bed4fa"
    repo_status: locked
    path: docs/explanation/azure/.assets/a-bad-coordinate-stops-discovery/grid.md
    source: docs/explanation/azure/.assets/a-bad-coordinate-stops-discovery/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A config file that resolves to no subscription, or to two, stops discovery with one line: the world-map minimap

```text
Where the files that cite ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD sit in the repository: tracks down, file languages across.
3 of 342 cells lit, holding 46 files.
```

![The world-map minimap of A config file that resolves to no subscription, or to two, stops discovery with one line](grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [A config file that resolves to no subscription, or to two, stops
discovery with one line][48], which explains [ADR-AZ-CUSTOMER][1] and [ADR-AZ-DATAMOD][2]. It lights every cell of the world map that holds
a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that
selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- docs × markdown: 44 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### docs × markdown (44 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/azure/azure-customer-model.md][1]: selected by [ADR-AZ-CUSTOMER][1]: the ADR's own file.
- [docs/adr/azure/azure-data-model.md][2]: selected by [ADR-AZ-DATAMOD][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][4]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 60 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 9 (text).
- [docs/adr/index.md][5]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 287 (text); selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 282 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][6]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 62 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][7]: selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 58 (text) and line 73 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][8]: selected by
  [ADR-AZ-CUSTOMER][1]: the file cites it at line 44 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 48 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][9]: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 72 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][10]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][11]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][12]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][13]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][14]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][15]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][16]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][17]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][18]: selected by [ADR-AZ-CUSTOMER][1]: the file cites
  it at line 101 (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][19]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 17 (text)
  and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][20]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][21]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at
  line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][22]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][23]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  128 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 20 (text), line 46 (text) and line 117 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][24]: selected by [ADR-AZ-DATAMOD][2]: the file cites it
  at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][25]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 24 (text) and line 108 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][26]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it
  at line 94 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 100 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][27]: selected by [ADR-AZ-DATAMOD][2]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md][28]: selected by [ADR-AZ-CUSTOMER][1]: the
  file cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][29]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md][30]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 27
  (text).
- [docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md][31]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md][32]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 19 (text)
  and line 46 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][33]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][34]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 66 (text);
  selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][35]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][36]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line
  26 (text); selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][37]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureCustomer.cs.md][38]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][39]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][40]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][41]: selected by [ADR-AZ-DATAMOD][2]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/CustomerConfig.cs.md][42]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][43]: selected by [ADR-AZ-DATAMOD][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][44]: selected by [ADR-AZ-DATAMOD][2]: the file cites
  it at line 53 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][45]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 51
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][46]: selected by [ADR-AZ-CUSTOMER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 260 (text); selected by [ADR-AZ-DATAMOD][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][47]: selected by [ADR-AZ-CUSTOMER][1]: the file cites it at line 260 (text); selected by
  [ADR-AZ-DATAMOD][2]: the file cites it at line 255 (text).

## Keywords

- [world map][49]
- [track][50]
- [file language][51]
- [cell][52]
- [lit cell][53]
- [docs][54]: a track
- [pipelines][54]: a track
- [pwsh][54]: a track
- [markdown][55]: a file language
- [pipeline-yaml][55]: a file language
- [yaml][55]: a file language

[1]: ../../../../adr/azure/azure-customer-model.md
[2]: ../../../../adr/azure/azure-data-model.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../adr/azure/dora-explains.md
[5]: ../../../../adr/index.md
[6]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[7]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[8]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[9]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[10]: ../../../../references/infrastructure/templates/discovery/options.yml.md
[11]: ../../../../references/infrastructure/templates/expedition/options.yml.md
[12]: ../../../../references/infrastructure/templates/foundation/options.yml.md
[13]: ../../../../references/pipelines/cd-shared.yaml.md
[14]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[15]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[16]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[17]: ../../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[18]: ../../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[19]: ../../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[24]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[25]: ../../../../references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[26]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[27]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[30]: ../../../../references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md
[31]: ../../../../references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md
[32]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
[33]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[34]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[35]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[36]: ../../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[37]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[38]: ../../../../references/pwsh/catzc-azure/types/AzureCustomer.cs.md
[39]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[40]: ../../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[41]: ../../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[42]: ../../../../references/pwsh/catzc-azure/types/CustomerConfig.cs.md
[43]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[44]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[45]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[46]: ../../../../../pipelines/ci-automation.yaml
[47]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[48]: ../../a-bad-coordinate-stops-discovery.md
[49]: ../../../../adr/glossary.md#world-map
[50]: ../../../../adr/glossary.md#track
[51]: ../../../../adr/glossary.md#file-language
[52]: ../../../../adr/glossary.md#cell
[53]: ../../../../adr/glossary.md#lit-cell
[54]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[55]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "3c9204c8c9e6"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-az-datamod--the-session-is-the-deploy-target--meta.grid.md
    source: docs/explanation/.assets/adr-az-datamod--the-session-is-the-deploy-target--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The az session is the deploy target, and the guard only checks it: the world-map minimap

```text
Where the files that cite ADR-AZ-DATAMOD sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 60 files.
```

![The world-map minimap of The az session is the deploy target, and the guard only checks it](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [The az session is the deploy target, and the guard only checks it][64],
which explains [ADR-AZ-DATAMOD][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the
decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 90 files
- automation × powershell: 4 lit of 1629 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 49 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][5]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 155 (text).
- [.claude/plans/plan-module-kinds-tracks.md][6]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 163 (text).

### automation × powershell (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][7]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 5 (text).
- [pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][8]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 25 (text), line 31 (text), line 48 (text), line 54 (text), line 59 (text), line 65 (text), line 102 (text), line 106 (text), line 106
  (body comment), line 111 (text) and line 115 (text).
- [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 225 (text), line 260
  (text), line 266 (text), line 274 (text), line 282 (text), line 288 (text) and line 296 (text).
- [pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 69 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Azure.Templates/configs/glossary.yml][11]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 5 (text) and line 101
  (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 255 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 613 (text).
- [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (body comment) (a
  passing mention only).

### docs × markdown (49 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 9 (text).
- [docs/adr/glossary.md][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 965 (text) and line 1013 (text).
- [docs/adr/index.md][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 280 (text) and line 404 (text).
- [docs/how-to/pwsh/manual-test-plan/azure.md][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15 (text) and line 58 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][19]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 61 (text) and line 61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][20]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 59 (text) and line 74 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][21]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 42 (text) and line 48 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][22]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 50 (text) and line 72 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][23]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][24]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][25]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][26]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 101 (text).
- [docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  94 (text).
- [docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md][28]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 129
  (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text)
  and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (text), line 46 (text) and line 117 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][34]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][35]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 24 (text), line 30 (text), line 101 (text) and line 108 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 32 (text), line 94 (text) and line 100 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md][37]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md][38]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][39]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][40]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md][41]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md][42]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][43]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][44]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md][45]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md][46]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][47]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-azure/azure-identity-resolves-from-config.drawio.md][48]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 102 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][49]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 56 (text) and line
  101 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][50]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][51]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11 (text), line
  26 (text), line 36 (text) and line 42 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][52]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][53]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][54]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][55]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][56]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 53 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][57]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][58]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][59]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][60]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 13 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][61]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][62]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][63]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Azure.Templates/configs/glossary.yml` line 5 (text), `pwsh/Catzc.Azure.Templates/configs/glossary.yml` line
  101 (text), `pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 5 (text),
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
  `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 225 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 260
  (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 266 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line
  274 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 282 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 288 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 296 (text), `pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1` line 69
  (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 613 (text)
  and `pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment).

## Keywords

- [world map][65]
- [track][66]
- [file language][67]
- [cell][68]
- [lit cell][69]
- [.claude][70]: a track
- [automation][70]: a track
- [docs][70]: a track
- [pipelines][70]: a track
- [markdown][71]: a file language
- [pipeline-yaml][71]: a file language
- [powershell][71]: a file language
- [yaml][71]: a file language

Terms the cited ADRs define:

- [environment class][72], defined by [ADR-AZ-DATAMOD#11][73]
- [slot][74], defined by [ADR-AZ-DATAMOD#2][75]

[1]: ../../../../adr/azure/azure-data-model.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[6]: ../../../../../.claude/plans/plan-module-kinds-tracks.md
[7]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[8]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[9]: ../../../../../pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[10]: ../../../../../pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1
[11]: ../../../../../pwsh/Catzc.Azure.Templates/configs/glossary.yml
[12]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[13]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[14]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml
[15]: ../../../../adr/azure/dora-explains.md
[16]: ../../../../adr/glossary.md
[17]: ../../../../adr/index.md
[18]: ../../../../how-to/pwsh/manual-test-plan/azure.md
[19]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[20]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[21]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[22]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[23]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[24]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[25]: ../../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[26]: ../../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[27]: ../../../../references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[30]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[31]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[32]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[33]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[34]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[35]: ../../../../references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[36]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[37]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
[38]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
[39]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[40]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[41]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
[42]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
[43]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[44]: ../../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[45]: ../../../../references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
[46]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
[47]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[48]: ../../../../references/pwsh/catzc-azure/azure-identity-resolves-from-config.drawio.md
[49]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[50]: ../../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[51]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[52]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[53]: ../../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[54]: ../../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[55]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[56]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[57]: ../../../../references/infrastructure/templates/discovery/options.yml.md
[58]: ../../../../references/infrastructure/templates/expedition/options.yml.md
[59]: ../../../../references/infrastructure/templates/foundation/options.yml.md
[60]: ../../../../references/pipelines/cd-shared.yaml.md
[61]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[62]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[63]: ../../../../../pipelines/ci-automation.yaml
[64]: ../../the-session-is-the-deploy-target.md
[65]: ../../../../adr/glossary.md#world-map
[66]: ../../../../adr/glossary.md#track
[67]: ../../../../adr/glossary.md#file-language
[68]: ../../../../adr/glossary.md#cell
[69]: ../../../../adr/glossary.md#lit-cell
[70]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[71]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[72]: ../../../../adr/glossary.md#environment-class
[73]: ../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[74]: ../../../../adr/glossary.md#slot
[75]: ../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

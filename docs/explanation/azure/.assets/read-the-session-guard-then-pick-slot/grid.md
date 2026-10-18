---
catzc:
  immutable:
    with_body_sha: "0e514932d75b"
    repo_status: locked
    path: docs/explanation/azure/.assets/read-the-session-guard-then-pick-slot/grid.md
    source: docs/explanation/azure/.assets/read-the-session-guard-then-pick-slot/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Get-BicepDeploymentContext reads the session, guards it, then picks the slot: the world-map minimap

```text
Where the files that cite ADR-AZ-DATAMOD sit in the repository: tracks down, file languages across.
3 of 342 cells lit, holding 36 files.
```

![The world-map minimap of Get-BicepDeploymentContext reads the session, guards it, then picks the slot](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Get-BicepDeploymentContext reads the session, guards it, then
picks the slot][38], which explains [ADR-AZ-DATAMOD][1]. It lights every cell of the world map that holds a file citing those codes, so it
shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- docs × markdown: 34 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### docs × markdown (34 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][3]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 9 (text).
- [docs/adr/index.md][4]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 282 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][5]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][6]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 58 (text) and line 73 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][7]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 48 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][8]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 72 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][11]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 13 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text)
  and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][20]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][21]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (text), line 46 (text) and line 117 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][22]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][23]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 24 (text) and line 108 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][24]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 100 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][25]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][26]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][28]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][34]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][35]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 53 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][36]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][37]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 255 (text).

## Keywords

- [world map][39]
- [track][40]
- [file language][41]
- [cell][42]
- [lit cell][43]
- [docs][44]: a track
- [pipelines][44]: a track
- [pwsh][44]: a track
- [markdown][45]: a file language
- [pipeline-yaml][45]: a file language
- [yaml][45]: a file language

[1]: ../../../../adr/azure/azure-data-model.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../adr/azure/dora-explains.md
[4]: ../../../../adr/index.md
[5]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[6]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[7]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[8]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[9]: ../../../../references/infrastructure/templates/discovery/options.yml.md
[10]: ../../../../references/infrastructure/templates/expedition/options.yml.md
[11]: ../../../../references/infrastructure/templates/foundation/options.yml.md
[12]: ../../../../references/pipelines/cd-shared.yaml.md
[13]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[14]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[16]: ../../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[17]: ../../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[18]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[19]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[24]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[25]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[26]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[27]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[28]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[29]: ../../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[30]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[31]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[32]: ../../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[33]: ../../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[34]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[35]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[36]: ../../../../../pipelines/ci-automation.yaml
[37]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[38]: ../../read-the-session-guard-then-pick-slot.md
[39]: ../../../../adr/glossary.md#world-map
[40]: ../../../../adr/glossary.md#track
[41]: ../../../../adr/glossary.md#file-language
[42]: ../../../../adr/glossary.md#cell
[43]: ../../../../adr/glossary.md#lit-cell
[44]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[45]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

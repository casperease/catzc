---
catzc:
  immutable:
    with_body_sha: ca21d6723e11
    repo_status: locked
    path: docs/explanation/azure/.assets/one-reverse-lookup-feeds-every-module/grid.md
    source: docs/explanation/azure/.assets/one-reverse-lookup-feeds-every-module/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One reverse lookup in Catzc.Azure.Cli hands the session to every module: the world-map minimap

```text
Where the files that cite ADR-AZ-DATAMOD and ADR-AZ-NAMING sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 44 files.
```

![The world-map minimap of One reverse lookup in Catzc.Azure.Cli hands the session to every module](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [One reverse lookup in Catzc.Azure.Cli hands the session to
every module][46], which explains [ADR-AZ-DATAMOD][1] and [ADR-AZ-NAMING][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 41 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/plan-explanation-drift-gaps.md][4]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 113 (text).

### docs × markdown (41 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/azure-naming-standard.md][2]: selected by [ADR-AZ-NAMING][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][5]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 9 (text); selected by [ADR-AZ-NAMING][2]:
  the file cites it at line 43 (text).
- [docs/adr/index.md][6]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 282 (text); selected by [ADR-AZ-NAMING][2]: the file
  cites it at line 284 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][7]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 67 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][8]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][9]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 58 (text) and line 73 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][10]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 48 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][11]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 72 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 13 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][20]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text)
  and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][21]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md][22]: selected by [ADR-AZ-NAMING][2]: the file cites it at line
  97 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md][23]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 29 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][24]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][25]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][26]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (text), line 46 (text) and line 117 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][28]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 24 (text) and line 108 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 100 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][30]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][31]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md][32]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 32
  (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][34]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 102 (text);
  selected by [ADR-AZ-NAMING][2]: the file cites it at line 32 (text), line 77 (text) and line 111 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][35]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][37]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][38]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][39]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][40]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][41]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][42]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 53 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][43]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 23
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][44]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text); selected by [ADR-AZ-NAMING][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 257 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][45]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 255 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 257 (text).

## Keywords

- [world map][47]
- [track][48]
- [file language][49]
- [cell][50]
- [lit cell][51]
- [.claude][52]: a track
- [docs][52]: a track
- [pipelines][52]: a track
- [pwsh][52]: a track
- [markdown][53]: a file language
- [pipeline-yaml][53]: a file language
- [yaml][53]: a file language

[1]: ../../../../adr/azure/azure-data-model.md
[2]: ../../../../adr/azure/azure-naming-standard.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[5]: ../../../../adr/azure/dora-explains.md
[6]: ../../../../adr/index.md
[7]: ../../../../how-to/getting-started/automation/add-a-doc-chapter.md
[8]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[9]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[10]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[11]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[12]: ../../../../references/infrastructure/templates/discovery/options.yml.md
[13]: ../../../../references/infrastructure/templates/expedition/options.yml.md
[14]: ../../../../references/infrastructure/templates/foundation/options.yml.md
[15]: ../../../../references/pipelines/cd-shared.yaml.md
[16]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[17]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[18]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[19]: ../../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[22]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
[24]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[25]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[26]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[27]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[29]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[30]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[31]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[32]: ../../../../references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
[33]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[34]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[35]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[36]: ../../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[37]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[38]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[39]: ../../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[40]: ../../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[41]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[42]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[43]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[44]: ../../../../../pipelines/ci-automation.yaml
[45]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[46]: ../../one-reverse-lookup-feeds-every-module.md
[47]: ../../../../adr/glossary.md#world-map
[48]: ../../../../adr/glossary.md#track
[49]: ../../../../adr/glossary.md#file-language
[50]: ../../../../adr/glossary.md#cell
[51]: ../../../../adr/glossary.md#lit-cell
[52]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[53]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

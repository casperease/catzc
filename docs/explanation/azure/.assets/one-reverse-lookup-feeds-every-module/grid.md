---
catzc:
  immutable:
    with_body_sha: "07008fb4c750"
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
5 of 342 cells lit, holding 71 files.
```

![The world-map minimap of One reverse lookup in Catzc.Azure.Cli hands the session to every module](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [One reverse lookup in Catzc.Azure.Cli hands the session to
every module][73], which explains [ADR-AZ-DATAMOD][1] and [ADR-AZ-NAMING][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 64 files
- docs × markdown: 61 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 4 lit of 1653 files
- pwsh × yaml: 4 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/plan-promotion-ladder.md][4]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 13 (text).

### docs × markdown (61 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/azure/.assets/azure-name-assembly/chain.md][5]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 18 (text), line 25
  (text), line 58 (text) and line 58 (text).
- [docs/adr/azure/.assets/azure-name-assembly/grid.md][6]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 18 (text), line 25
  (text), line 56 (text), line 58 (text), line 62 (text), line 66 (text), line 67 (text), line 68 (text), line 69 (text), line 70 (text),
  line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 91 (text), line 92 (text), line 94 (text), line 102 (text), line 111 (text), line 119 (text) and line 120
  (text).
- [docs/adr/azure/.assets/azure-name-assembly/tree.md][7]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 18 (text), line 25
  (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 55 (text), line 58 (text), line 59 (text), line 61 (text),
  line 64 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 82 (text), line 84
  (text), line 88 (text), line 92 (text), line 93 (text), line 99 (text), line 101 (text), line 108 (text), line 115 (text) and line 123
  (text).
- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/azure-naming-standard.md][2]: selected by [ADR-AZ-NAMING][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][8]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 9 (text); selected by [ADR-AZ-NAMING][2]:
  the file cites it at line 43 (text).
- [docs/adr/glossary.md][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 1006 (text) and line 1054 (text).
- [docs/adr/index.md][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 280 (text) and line 406 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 32 (text) and line 282 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][11]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 67 (text).
- [docs/how-to/pwsh/manual-test-plan/azure.md][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15 (text) and line 58 (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 13 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 101 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md][20]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 61 (text) and line 61 (text).
- [docs/references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.md][21]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 102 (text), line 102 (text), line 102 (text) and line 102 (text).
- [docs/references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.verify.md][22]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 50 (text), line 50 (text), line 50 (text), line 50 (text) and line 72 (text); selected by [ADR-AZ-NAMING][2]: the file
  cites it at line 54 (text).
- [docs/references/pwsh/.assets/bicep-deploy-one-immutable-context/diagram.drawio.md][23]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 24 (text), line 30 (text), line 101 (text), line 101 (text) and line 108 (text).
- [docs/references/pwsh/.assets/bicep-deploy-one-immutable-context/diagram.drawio.verify.md][24]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 58 (text) and line 73 (text).
- [docs/references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md][25]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 32 (text), line 94 (text) and line 100 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 28 (text), line 28 (text),
  line 94 (text) and line 94 (text).
- [docs/references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.verify.md][26]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 42 (text) and line 48 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 43 (text) and line 43 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][28]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][29]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  94 (text).
- [docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 129
  (text).
- [docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17 (text)
  and line 105 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][33]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md][34]: selected by [ADR-AZ-NAMING][2]: the file cites it at line
  97 (text), line 108 (text) and line 127 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md][35]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 29 (text) and line 32 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md][37]: selected by [ADR-AZ-NAMING][2]: the file cites it at line
  75 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][38]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][39]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20
  (text), line 46 (text) and line 117 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 142 (text).
- [docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][40]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md][41]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 22 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md][42]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][43]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][44]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md][45]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md][46]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][47]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][48]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][49]: selected by [ADR-AZ-NAMING][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md][50]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 12
  (text), line 32 (text) and line 64 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md][51]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md][52]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][53]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][54]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 56 (text), line 83
  (text) and line 102 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 32 (text), line 77 (text) and line 111 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][55]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][56]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 30
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][57]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11 (text), line
  26 (text), line 37 (text), line 39 (text) and line 45 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][58]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text) and line 20 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md][59]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md][60]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][61]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][62]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 53 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][63]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 23
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][64]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
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
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 106 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 111 (text),
  `pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 115 (text),
  `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 255 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 290
  (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 296 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line
  304 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 312 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 318 (text), `pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 326 (text), `pwsh/Catzc.Base.Docs/configs/adr-index.yml` line
  43 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 255 (text) and `pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body
  comment); selected by [ADR-AZ-NAMING][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 46 (text), `pwsh/Catzc.Base.Docs/configs/adr-index.yml` line 17
  (text) and `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 257 (text).

### pwsh × powershell (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][65]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 46
  (text).
- [pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][66]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 5 (text).
- [pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][67]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 25 (text), line 31 (text), line 48 (text), line 54 (text), line 59 (text), line 65 (text), line 102 (text), line 106 (text), line 106
  (text), line 111 (text) and line 115 (text).
- [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][68]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 255 (text), line 290
  (text), line 296 (text), line 304 (text), line 312 (text), line 318 (text) and line 326 (text).

### pwsh × yaml (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Azure.Templates/configs/glossary.yml][69]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 5 (text) and line 101
  (text).
- [pwsh/Catzc.Base.Docs/configs/adr-index.yml][70]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 43 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 17 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][71]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 255 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 257 (text).
- [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml][72]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (body comment) (a
  passing mention only).

## Keywords

- [world map][74]
- [track][75]
- [file language][76]
- [cell][77]
- [lit cell][78]
- [.claude][79]: a track
- [docs][79]: a track
- [pipelines][79]: a track
- [pwsh][79]: a track
- [markdown][80]: a file language
- [pipeline-yaml][80]: a file language
- [powershell][80]: a file language
- [yaml][80]: a file language

[1]: ../../../../adr/azure/azure-data-model.md
[2]: ../../../../adr/azure/azure-naming-standard.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/plan-promotion-ladder.md
[5]: ../../../../adr/azure/.assets/azure-name-assembly/chain.md
[6]: ../../../../adr/azure/.assets/azure-name-assembly/grid.md
[7]: ../../../../adr/azure/.assets/azure-name-assembly/tree.md
[8]: ../../../../adr/azure/dora-explains.md
[9]: ../../../../adr/glossary.md
[10]: ../../../../adr/index.md
[11]: ../../../../how-to/getting-started/automation/add-a-doc-chapter.md
[12]: ../../../../how-to/pwsh/manual-test-plan/azure.md
[13]: ../../../../references/infrastructure/templates/discovery/options.yml.md
[14]: ../../../../references/infrastructure/templates/expedition/options.yml.md
[15]: ../../../../references/infrastructure/templates/foundation/options.yml.md
[16]: ../../../../references/pipelines/cd-shared.yaml.md
[17]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[18]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[19]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md
[20]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md
[21]: ../../../../references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.md
[22]: ../../../../references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.verify.md
[23]: ../../../../references/pwsh/.assets/bicep-deploy-one-immutable-context/diagram.drawio.md
[24]: ../../../../references/pwsh/.assets/bicep-deploy-one-immutable-context/diagram.drawio.verify.md
[25]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md
[26]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.verify.md
[27]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[28]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[30]: ../../../../references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[31]: ../../../../references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
[32]: ../../../../references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
[33]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[34]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
[35]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
[36]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[37]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md
[38]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[39]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[40]: ../../../../references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[41]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
[42]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
[43]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[44]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[45]: ../../../../references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
[46]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
[47]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[48]: ../../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[49]: ../../../../references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[50]: ../../../../references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
[51]: ../../../../references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
[52]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
[53]: ../../../../references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[54]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[55]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[56]: ../../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[57]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[58]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[59]: ../../../../references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
[60]: ../../../../references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
[61]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[62]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[63]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[64]: ../../../../../pipelines/ci-automation.yaml
[65]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[66]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[67]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[68]: ../../../../../pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[69]: ../../../../../pwsh/Catzc.Azure.Templates/configs/glossary.yml
[70]: ../../../../../pwsh/Catzc.Base.Docs/configs/adr-index.yml
[71]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[72]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml
[73]: ../../one-reverse-lookup-feeds-every-module.md
[74]: ../../../../adr/glossary.md#world-map
[75]: ../../../../adr/glossary.md#track
[76]: ../../../../adr/glossary.md#file-language
[77]: ../../../../adr/glossary.md#cell
[78]: ../../../../adr/glossary.md#lit-cell
[79]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[80]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

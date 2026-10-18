---
catzc:
  immutable:
    with_body_sha: "43a111f93eba"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-az-datamod--four-gates-hold-the-session-rule--governance.grid.md
    source: docs/explanation/.assets/adr-az-datamod--four-gates-hold-the-session-rule--governance.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Four gates hold the session rule; the customer and the name hold by construction: the world-map minimap

```text
Where the files that cite ADR-AZ-DATAMOD and ADR-AZ-NAMING sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 70 files.
```

![The world-map minimap of Four gates hold the session rule; the customer and the name hold by construction](adr-az-datamod--four-gates-hold-the-session-rule--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Four gates hold the session rule; the customer and the name hold
by construction][74], which explains [ADR-AZ-DATAMOD][1] and [ADR-AZ-NAMING][2]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 90 files
- automation × powershell: 5 lit of 1629 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 58 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][6]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 155 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 163 (text).

### automation × powershell (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][8]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 46
  (text).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][9]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 5 (text).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][10]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 25 (text), line 31 (text), line 48 (text), line 54 (text), line 59 (text), line 65 (text), line 102 (text), line 106 (text), line
  106 (body comment), line 111 (text) and line 115 (text).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][11]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 225 (text),
  line 260 (text), line 266 (text), line 274 (text), line 282 (text), line 288 (text) and line 296 (text).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][12]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 69 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 39 (body comment) (a passing mention only).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/configs/glossary.yml][13]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 5 (text) and line
  101 (text).
- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 255 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 257 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][15]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 613 (text).
- [automation/Catzc.Base.RootConfig/assets/root/cspell.yml][16]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21 (body
  comment) (a passing mention only).

### docs × markdown (58 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/azure-data-model.md][1]: selected by [ADR-AZ-DATAMOD][1]: the ADR's own file.
- [docs/adr/azure/azure-naming-standard.md][2]: selected by [ADR-AZ-NAMING][2]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][17]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 9 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 43 (text).
- [docs/adr/glossary.md][18]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 965 (text) and line 1013 (text).
- [docs/adr/index.md][19]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 280 (text) and line 404 (text); selected by
  [ADR-AZ-NAMING][2]: the file cites it at line 31 (text) and line 282 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][20]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15 (text) and line 58
  (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][21]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 67 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][22]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 61 (text) and line 61 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md][23]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 59 (text) and line 74 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][24]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 42 (text) and line 48 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 43
  (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][25]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 50 (text) and line 72 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 54
  (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][26]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line
  21 (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md][27]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 17 (text).
- [docs/references/automation/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][28]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 21
  (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][29]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 101 (text).
- [docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md][30]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 94 (text).
- [docs/references/automation/catzc-azure-templates/Build-Bicep.ps1.md][31]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 129
  (text).
- [docs/references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md][32]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 17
  (text) and line 105 (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md][33]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 24 (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md][34]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 97 (text), line 108 (text) and line 127 (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md][35]: selected by [ADR-AZ-NAMING][2]: the file cites it
  at line 29 (text) and line 32 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md][36]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 36 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md][37]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 76 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md][38]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 18 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][39]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 20 (text), line 46 (text) and line 117 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 142 (text).
- [docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md][40]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 26 (text).
- [docs/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md][41]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 24 (text), line 30 (text), line 101 (text) and line 108 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][42]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 32 (text), line 94 (text) and line 100 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 28 (text) and
  line 94 (text).
- [docs/references/automation/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md][43]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 22 (text).
- [docs/references/automation/catzc-azure-templates/private/Get-BicepConfigName.ps1.md][44]: selected by [ADR-AZ-DATAMOD][1]: the file cites
  it at line 16 (text).
- [docs/references/automation/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md][45]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md][46]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 20 (text).
- [docs/references/automation/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md][47]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md][48]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 17 (text).
- [docs/references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][49]: selected by [ADR-AZ-DATAMOD][1]:
  the file cites it at line 16 (text).
- [docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][50]: selected by
  [ADR-AZ-DATAMOD][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][51]: selected by [ADR-AZ-NAMING][2]: the file
  cites it at line 14 (text).
- [docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md][52]: selected by [ADR-AZ-NAMING][2]: the file cites it at
  line 12 (text), line 32 (text) and line 64 (text).
- [docs/references/automation/catzc-azure/Get-AzureEnvironment.ps1.md][53]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18
  (text).
- [docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md][54]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 18
  (text).
- [docs/references/automation/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md][55]: selected by [ADR-AZ-DATAMOD][1]: the file cites it
  at line 14 (text).
- [docs/references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md][56]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 102 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][57]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 56 (text)
  and line 101 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 32 (text), line 77 (text) and line 110 (text).
- [docs/references/automation/catzc-azure/configs/customer.yml.md][58]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][59]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 30 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][60]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text), line 26 (text), line 36 (text) and line 42 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][61]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 11 (text); selected by [ADR-AZ-NAMING][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md][62]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at
  line 11 (text).
- [docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md][63]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 11
  (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md][64]: selected by [ADR-AZ-DATAMOD][1]: the
  file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md][65]: selected by [ADR-AZ-DATAMOD][1]: the file
  cites it at line 53 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][66]: selected by [ADR-AZ-NAMING][2]: the file cites it at line 23
  (text).
- [docs/references/infrastructure/templates/discovery/options.yml.md][67]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/infrastructure/templates/expedition/options.yml.md][68]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 15
  (text).
- [docs/references/infrastructure/templates/foundation/options.yml.md][69]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 14
  (text).
- [docs/references/pipelines/cd-shared.yaml.md][70]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 13 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][71]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 24 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][72]: selected by [ADR-AZ-DATAMOD][1]: the file cites it at line 20 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][73]: selected by [ADR-AZ-DATAMOD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Azure.Templates/configs/glossary.yml` line 5 (text),
  `automation/Catzc.Azure.Templates/configs/glossary.yml` line 101 (text),
  `automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 5 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 25 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 31 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 48 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 54 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 59 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 65 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 102 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 106 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 106 (body comment),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 111 (text),
  `automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1` line 115 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 225 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 260 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 266 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 274 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1`
  line 282 (text), `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 288 (text),
  `automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1` line 296 (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 69
  (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 255 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line
  613 (text) and `automation/Catzc.Base.RootConfig/assets/root/cspell.yml` line 21 (body comment); selected by [ADR-AZ-NAMING][2]: a
  pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 46 (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1`
  line 39 (body comment) and `automation/Catzc.Base.Docs/configs/adrs.yml` line 257 (text).

## Keywords

- [world map][75]
- [track][76]
- [file language][77]
- [cell][78]
- [lit cell][79]
- [.claude][80]: a track
- [automation][80]: a track
- [docs][80]: a track
- [pipelines][80]: a track
- [markdown][81]: a file language
- [pipeline-yaml][81]: a file language
- [powershell][81]: a file language
- [yaml][81]: a file language

Terms the cited ADRs define:

- [environment class][82], defined by [ADR-AZ-DATAMOD#11][83]
- [slot][84], defined by [ADR-AZ-DATAMOD#2][85]

[1]: ../../../adr/azure/azure-data-model.md
[2]: ../../../adr/azure/azure-naming-standard.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[9]: ../../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[10]: ../../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[11]: ../../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[12]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[13]: ../../../../automation/Catzc.Azure.Templates/configs/glossary.yml
[14]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[16]: ../../../../automation/Catzc.Base.RootConfig/assets/root/cspell.yml
[17]: ../../../adr/azure/dora-explains.md
[18]: ../../../adr/glossary.md
[19]: ../../../adr/index.md
[20]: ../../../how-to/automation/manual-test-plan/azure.md
[21]: ../../../how-to/getting-started/automation/add-a-doc-chapter.md
[22]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[23]: ../../../references/.assets/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
[24]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[25]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[26]: ../../../references/automation/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[27]: ../../../references/automation/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
[28]: ../../../references/automation/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[29]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[30]: ../../../references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
[31]: ../../../references/automation/catzc-azure-templates/Build-Bicep.ps1.md
[32]: ../../../references/automation/catzc-azure-templates/Deploy-Bicep.ps1.md
[33]: ../../../references/automation/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
[34]: ../../../references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
[35]: ../../../references/automation/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
[36]: ../../../references/automation/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
[37]: ../../../references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
[38]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
[39]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[40]: ../../../references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
[41]: ../../../references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
[42]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[43]: ../../../references/automation/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
[44]: ../../../references/automation/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
[45]: ../../../references/automation/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
[46]: ../../../references/automation/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
[47]: ../../../references/automation/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
[48]: ../../../references/automation/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
[49]: ../../../references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[50]: ../../../references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[51]: ../../../references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[52]: ../../../references/automation/catzc-azure-templates/types/BicepShortName.cs.md
[53]: ../../../references/automation/catzc-azure/Get-AzureEnvironment.ps1.md
[54]: ../../../references/automation/catzc-azure/Get-AzureSubscription.ps1.md
[55]: ../../../references/automation/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
[56]: ../../../references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md
[57]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[58]: ../../../references/automation/catzc-azure/configs/customer.yml.md
[59]: ../../../references/automation/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[60]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[61]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[62]: ../../../references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md
[63]: ../../../references/automation/catzc-azure/types/AzureTenantRecord.cs.md
[64]: ../../../references/automation/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
[65]: ../../../references/automation/catzc-base-qualitygates/private/Get-TerminologyCorpus.ps1.md
[66]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[67]: ../../../references/infrastructure/templates/discovery/options.yml.md
[68]: ../../../references/infrastructure/templates/expedition/options.yml.md
[69]: ../../../references/infrastructure/templates/foundation/options.yml.md
[70]: ../../../references/pipelines/cd-shared.yaml.md
[71]: ../../../references/pipelines/ci-infrastructure.yaml.md
[72]: ../../../references/pipelines/extends/cd-customer.yaml.md
[73]: ../../../../pipelines/ci-automation.yaml
[74]: ../../azure/four-gates-hold-the-session-rule.md
[75]: ../../../adr/glossary.md#world-map
[76]: ../../../adr/glossary.md#track
[77]: ../../../adr/glossary.md#file-language
[78]: ../../../adr/glossary.md#cell
[79]: ../../../adr/glossary.md#lit-cell
[80]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[81]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[82]: ../../../adr/glossary.md#environment-class
[83]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[84]: ../../../adr/glossary.md#slot
[85]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2

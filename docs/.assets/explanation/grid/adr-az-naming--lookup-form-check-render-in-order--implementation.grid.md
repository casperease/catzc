# docs/.assets/explanation/grid/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md

`Grid minimap: adr-az-naming--lookup-form-check-render-in-order--implementation`

![Grid minimap of adr-az-naming--lookup-form-check-render-in-order--implementation](adr-az-naming--lookup-form-check-render-in-order--implementation.grid.png)

The grid minimap of the slide `adr-az-naming--lookup-form-check-render-in-order--implementation` (implementation lens). The slide supports
[ADR-AZ-NAMING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .unordered × markdown: 1 lit of 20 files
- automation × csharp: 3 lit of 274 files
- automation × powershell: 7 lit of 1579 files
- automation × yaml: 1 lit of 109 files
- docs × markdown: 14 lit of 2165 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .unordered × markdown (1 lit file)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-caf-waf-automation.md][5]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 21 (text).

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][6]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 22 (text).
- [automation/Catzc.Azure/types/AzureConfig.cs][7]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 25 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][8]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 22 (text).

### automation × powershell (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][9]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][10]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 20
  (header), line 37 (header) and line 40 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][11]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][12]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 24 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][13]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 21
  (header) and line 70 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][14]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][15]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 25 (header) and line 104
  (body comment).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 271 (text).

### docs × markdown (14 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/azure/azure-naming-standard.md][1]: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][17]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 75 (text).
- [docs/adr/index.md][18]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 31 (text) and line 276 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][19]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 90 (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md][20]: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 17 (text), line 34 (text), line 45 (text) and line 64 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md][21]: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][22]: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 17 (text) and line 104 (text).
- [docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][23]: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md][24]: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 18 (text), line 32 (text), line 52 (text) and line 84 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][25]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 51 (text),
  line 96 (text) and line 129 (text).
- [docs/references/automation/catzc-azure/configs/customer.yml.md][26]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 35 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][27]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 21 (text)
  and line 51 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][28]: selected by [ADR-AZ-NAMING][1]: the file cites it at line
  31 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][29]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 42
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][30]: selected by [ADR-AZ-NAMING][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1` line 20 (header),
  `automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1` line 37 (header),
  `automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1` line 40 (header),
  `automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1` line 21 (header), `automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1`
  line 24 (header), `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 70 (text),
  `automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/types/BicepShortName.cs` line 22 (text), `automation/Catzc.Azure/types/AzureConfig.cs` line 25 (text),
  `automation/Catzc.Azure/types/AzureEnvironmentRecord.cs` line 22 (text), `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 25 (header),
  `automation/Catzc.Base.Docs/Build-AdrIndex.ps1` line 104 (body comment) and `automation/Catzc.Base.Docs/configs/adrs.yml` line 271 (text).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.unordered][36]: a track
- [automation][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [csharp][37]: a file language
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [powershell][37]: a file language
- [yaml][37]: a file language

[1]: ../../../adr/azure/azure-naming-standard.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[6]: ../../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[7]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[8]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[9]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[10]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[11]: ../../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[12]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[13]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[14]: ../../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[15]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[16]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../adr/azure/dora-explains.md
[18]: ../../../adr/index.md
[19]: ../../../how-to/getting-started/automation/add-a-doc-chapter.md
[20]: ../../../references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
[21]: ../../../references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
[22]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[23]: ../../../references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[24]: ../../../references/automation/catzc-azure-templates/types/BicepShortName.cs.md
[25]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[26]: ../../../references/automation/catzc-azure/configs/customer.yml.md
[27]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[28]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[29]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[30]: ../../../../pipelines/ci-automation.yaml
[31]: ../../../adr/glossary.md#world-map
[32]: ../../../adr/glossary.md#track
[33]: ../../../adr/glossary.md#file-language
[34]: ../../../adr/glossary.md#cell
[35]: ../../../adr/glossary.md#lit-cell
[36]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

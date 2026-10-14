# docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.grid.md

`Grid minimap: adr-az-naming--names-are-derived-never-typed--operations`

![Grid minimap of adr-az-naming--names-are-derived-never-typed--operations](adr-az-naming--names-are-derived-never-typed--operations.grid.png)

The grid minimap of the slide `adr-az-naming--names-are-derived-never-typed--operations` (operations lens). The slide supports
[ADR-AZ-NAMING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 3 lit of 229 files
- automation × powershell: 7 lit of 1443 files
- automation × yaml: 4 lit of 97 files
- docs × markdown: 27 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][5]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 2 (header), line
  25 (body comment) and line 95 (body comment).
- [automation/Catzc.Azure/types/AzureConfig.cs][6]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 18 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][7]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 2 (header).

### automation × powershell (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][8]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 87 (body
  comment), line 98 (body comment) and line 126 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][9]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 18 (header)
  and line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][10]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 77 (body
  comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][11]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 136 (body
  comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][12]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 68
  (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][13]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][14]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 60 (body comment) (a
  passing mention only).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure/configs/azure.yml][15]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 11 (header), line 38 (body
  comment) and line 85 (body comment).
- [automation/Catzc.Azure/configs/customer.yml][16]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][17]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 269 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][18]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 7 (header).

### docs × markdown (27 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/azure/az-session-verification.md][19]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/azure-customer-model.md][20]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/azure-data-model.md][21]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-naming-standard.md][1]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/azure-network-model.md][22]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/billing-and-tenant.md][23]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/design-principles.md][24]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/governance.md][25]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/identity-and-access.md][26]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/landing-zone-security.md][27]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain
  of that code.
- [docs/adr/azure/caf/management.md][28]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/naming-and-tagging.md][29]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/network-connectivity.md][30]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/network-private-access.md][31]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain
  of that code.
- [docs/adr/azure/caf/network-topology.md][32]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][33]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR
  domain of that code.
- [docs/adr/azure/caf/resource-organization.md][34]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain
  of that code.
- [docs/adr/azure/dora-explains.md][35]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][36]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][37]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][38]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/operational-excellence.md][39]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain
  of that code.
- [docs/adr/azure/waf/performance-efficiency.md][40]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain
  of that code.
- [docs/adr/azure/waf/reliability.md][41]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/waf/security.md][42]: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/index.md][43]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 15 (text) and line 251 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][44]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 69 (text).

## Keywords

- [world map][45]
- [track][46]
- [file language][47]
- [cell][48]
- [lit cell][49]
- [automation][18]: a track
- [docs][18]: a track
- [csharp][50]: a file language
- [markdown][50]: a file language
- [powershell][50]: a file language
- [yaml][50]: a file language

[1]: ../../adr/azure/azure-naming-standard.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[6]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[7]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[8]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[9]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[10]: ../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[11]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[12]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[13]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[14]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[15]: ../../../automation/Catzc.Azure/configs/azure.yml
[16]: ../../../automation/Catzc.Azure/configs/customer.yml
[17]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[19]: ../../adr/azure/az-session-verification.md
[20]: ../../adr/azure/azure-customer-model.md
[21]: ../../adr/azure/azure-data-model.md
[22]: ../../adr/azure/azure-network-model.md
[23]: ../../adr/azure/caf/billing-and-tenant.md
[24]: ../../adr/azure/caf/design-principles.md
[25]: ../../adr/azure/caf/governance.md
[26]: ../../adr/azure/caf/identity-and-access.md
[27]: ../../adr/azure/caf/landing-zone-security.md
[28]: ../../adr/azure/caf/management.md
[29]: ../../adr/azure/caf/naming-and-tagging.md
[30]: ../../adr/azure/caf/network-connectivity.md
[31]: ../../adr/azure/caf/network-private-access.md
[32]: ../../adr/azure/caf/network-topology.md
[33]: ../../adr/azure/caf/platform-automation-and-devops.md
[34]: ../../adr/azure/caf/resource-organization.md
[35]: ../../adr/azure/dora-explains.md
[36]: ../../adr/azure/landing-zones.md
[37]: ../../adr/azure/prefer-az-cli.md
[38]: ../../adr/azure/waf/cost-optimization.md
[39]: ../../adr/azure/waf/operational-excellence.md
[40]: ../../adr/azure/waf/performance-efficiency.md
[41]: ../../adr/azure/waf/reliability.md
[42]: ../../adr/azure/waf/security.md
[43]: ../../adr/index.md
[44]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[45]: ../../adr/glossary.md#world-map
[46]: ../../adr/glossary.md#track
[47]: ../../adr/glossary.md#file-language
[48]: ../../adr/glossary.md#cell
[49]: ../../adr/glossary.md#lit-cell
[50]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

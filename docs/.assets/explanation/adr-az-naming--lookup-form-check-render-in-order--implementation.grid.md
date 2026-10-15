# docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md

`Grid minimap: adr-az-naming--lookup-form-check-render-in-order--implementation`

![Grid minimap of adr-az-naming--lookup-form-check-render-in-order--implementation](adr-az-naming--lookup-form-check-render-in-order--implementation.grid.png)

The grid minimap of the slide `adr-az-naming--lookup-form-check-render-in-order--implementation` (implementation lens). The slide supports
[ADR-AZ-NAMING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 3 lit of 229 files
- automation × powershell: 7 lit of 1443 files
- automation × yaml: 4 lit of 97 files
- docs × markdown: 4 lit of 744 files

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

### docs × markdown (4 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/azure/azure-naming-standard.md][1]: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][19]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 45 (text).
- [docs/adr/index.md][20]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 15 (text) and line 251 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][21]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 69 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [automation][18]: a track
- [docs][18]: a track
- [csharp][27]: a file language
- [markdown][27]: a file language
- [powershell][27]: a file language
- [yaml][27]: a file language

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
[19]: ../../adr/azure/dora-explains.md
[20]: ../../adr/index.md
[21]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[22]: ../../adr/glossary.md#world-map
[23]: ../../adr/glossary.md#track
[24]: ../../adr/glossary.md#file-language
[25]: ../../adr/glossary.md#cell
[26]: ../../adr/glossary.md#lit-cell
[27]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

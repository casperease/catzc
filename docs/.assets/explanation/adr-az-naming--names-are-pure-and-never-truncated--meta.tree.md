# docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md

`Tree minimap: adr-az-naming--names-are-pure-and-never-truncated--meta`

![Tree minimap of adr-az-naming--names-are-pure-and-never-truncated--meta](adr-az-naming--names-are-pure-and-never-truncated--meta.tree.png)

The tree minimap of the slide `adr-az-naming--names-are-pure-and-never-truncated--meta` (meta lens). The slide supports [ADR-AZ-NAMING][1];
the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 18 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Az.Templates (automation/Catzc.Azure.Templates): 7 lit files
- Azure (automation/Catzc.Azure): 4 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- Variants (automation/Catzc.Base.Variants): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- docs (docs/ outside docs/adr/): 1 lit file

## Why each group is lit

### Az.Templates (automation/Catzc.Azure.Templates, 7 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][2], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 87 (body comment), line 98 (body comment) and line 126 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][3], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 18 (header) and line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][4], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 77 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][5], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 136 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][6], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 68 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][7], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][8], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 2 (header), line 25 (body comment) and line 95 (body comment).

### Azure (automation/Catzc.Azure, 4 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/configs/azure.yml][9], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at line 11
  (header), line 38 (body comment) and line 85 (body comment).
- [automation/Catzc.Azure/configs/customer.yml][10], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 9 (header).
- [automation/Catzc.Azure/types/AzureConfig.cs][11], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 18 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][12], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 2 (header).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][13], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/adrs.yml][14], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 269 (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-naming-standard.md][1], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 45 (text).

### Variants (automation/Catzc.Base.Variants, 1 lit file)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][16], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 7 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 15 (text) and line 251
  (text).

### docs (docs/ outside docs/adr/, 1 lit file)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][18], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 69 (text).

## Keywords

- [world map][19]
- [track][20]
- [file language][21]
- [cell][22]
- [lit cell][23]
- [automation][16]: a track
- [docs][16]: a track
- [csharp][24]: a file language
- [markdown][24]: a file language
- [powershell][24]: a file language
- [yaml][24]: a file language

[1]: ../../adr/azure/azure-naming-standard.md
[2]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[3]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[4]: ../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[5]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[6]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[7]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[8]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[9]: ../../../automation/Catzc.Azure/configs/azure.yml
[10]: ../../../automation/Catzc.Azure/configs/customer.yml
[11]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[12]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[13]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[14]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../adr/azure/dora-explains.md
[16]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[17]: ../../adr/index.md
[18]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[19]: ../../adr/glossary.md#world-map
[20]: ../../adr/glossary.md#track
[21]: ../../adr/glossary.md#file-language
[22]: ../../adr/glossary.md#cell
[23]: ../../adr/glossary.md#lit-cell
[24]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

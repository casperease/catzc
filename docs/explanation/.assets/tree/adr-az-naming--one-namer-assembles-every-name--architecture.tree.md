# docs/explanation/.assets/tree/adr-az-naming--one-namer-assembles-every-name--architecture.tree.md

`Tree minimap: adr-az-naming--one-namer-assembles-every-name--architecture`

![Tree minimap of adr-az-naming--one-namer-assembles-every-name--architecture](adr-az-naming--one-namer-assembles-every-name--architecture.tree.png)

The tree minimap of the slide `adr-az-naming--one-namer-assembles-every-name--architecture` (architecture lens). The slide supports
[ADR-AZ-NAMING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 27 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 11 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 7 lit files
- Azure (automation/Catzc.Azure): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- .unordered: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 11 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][2], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 90 (text).
- [docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 17 (text), line 34 (text), line 45 (text) and line 64 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 17 (text) and line 104 (text).
- [docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-azure-templates/types/BicepShortName.cs.md][7], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 18 (text), line 32 (text), line 52 (text) and line 84 (text).
- [docs/references/automation/catzc-azure/configs/azure.yml.md][8], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 51 (text), line 96 (text) and line 129 (text).
- [docs/references/automation/catzc-azure/configs/customer.yml.md][9], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 35 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][10], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 21 (text) and line 51 (text).
- [docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md][11], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][12], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 42 (text).

### Az.Templates (automation/Catzc.Azure.Templates, 7 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][13], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][14], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 20 (header), line 37 (header) and line 40 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][15], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][16], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 24 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][17], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 21 (header) and line 70 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][18], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][19], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 22 (text).

### Azure (automation/Catzc.Azure, 2 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][20], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 25 (text).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][21], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 22 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][22], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 25 (header) and line 104 (body comment).
- [automation/Catzc.Base.Docs/configs/adrs.yml][23], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 271 (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-naming-standard.md][1], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][24], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 75 (text).

### .unordered (1 lit file)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-caf-waf-automation.md][25], in the cell .unordered × markdown: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 21 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][26], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 31 (text) and line 276
  (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][27], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-NAMING][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1` line 21 (header),
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

- [world map][28]
- [track][29]
- [file language][30]
- [cell][31]
- [lit cell][32]
- [.unordered][33]: a track
- [automation][33]: a track
- [docs][33]: a track
- [pipelines][33]: a track
- [csharp][34]: a file language
- [markdown][34]: a file language
- [pipeline-yaml][34]: a file language
- [powershell][34]: a file language
- [yaml][34]: a file language

[1]: ../../../adr/azure/azure-naming-standard.md
[2]: ../../../how-to/getting-started/automation/add-a-doc-chapter.md
[3]: ../../../references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
[4]: ../../../references/automation/catzc-azure-templates/Get-BicepResourceName.ps1.md
[5]: ../../../references/automation/catzc-azure-templates/Get-BicepTemplates.ps1.md
[6]: ../../../references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[7]: ../../../references/automation/catzc-azure-templates/types/BicepShortName.cs.md
[8]: ../../../references/automation/catzc-azure/configs/azure.yml.md
[9]: ../../../references/automation/catzc-azure/configs/customer.yml.md
[10]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[11]: ../../../references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
[12]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[13]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[14]: ../../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[15]: ../../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[16]: ../../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[17]: ../../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[18]: ../../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[19]: ../../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[20]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[21]: ../../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[22]: ../../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[23]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../adr/azure/dora-explains.md
[25]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[26]: ../../../adr/index.md
[27]: ../../../../pipelines/ci-automation.yaml
[28]: ../../../adr/glossary.md#world-map
[29]: ../../../adr/glossary.md#track
[30]: ../../../adr/glossary.md#file-language
[31]: ../../../adr/glossary.md#cell
[32]: ../../../adr/glossary.md#lit-cell
[33]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[34]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

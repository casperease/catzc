# docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.tree.md

`Tree minimap: adr-az-naming--how-each-naming-rule-is-held--governance`

![Tree minimap of adr-az-naming--how-each-naming-rule-is-held--governance](adr-az-naming--how-each-naming-rule-is-held--governance.tree.png)

The tree minimap of the slide `adr-az-naming--how-each-naming-rule-is-held--governance` (governance lens). The slide supports
[ADR-AZ-NAMING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 45 files in 7 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- adr/azure (docs/adr/azure): 19 lit files
- docs (docs/ outside docs/adr/): 11 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 7 lit files
- Azure (automation/Catzc.Azure): 4 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Variants (automation/Catzc.Base.Variants): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/azure (19 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/az-session-verification.md][2], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/azure-customer-model.md][3], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-data-model.md][4], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][1], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-network-model.md][5], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/design-principles.md][6], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][7], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/management.md][8], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][9], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][10], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/security.md][11], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][12], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][13], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][14], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][15], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][16], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][17], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][18], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/security.md][19], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.

### docs (11 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.drawio.md][20], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 63 (text) and line 71 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.md][21], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.drawio.md][22], in the cell docs × markdown: selected
  by [ADR-AZ-NAMING][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.md][23], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md][24], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 69 (text).
- [docs/explanation/azure/how-each-naming-rule-is-held.md][25], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 15 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and
  line 59 (text).
- [docs/explanation/azure/lookup-form-check-render-in-order.md][26], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 19 (text), line 60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/azure/names-are-derived-never-typed.md][27], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 16 (text), line 49 (text), line 50 (text), line 51 (text), line 52 (text) and line 53 (text).
- [docs/explanation/azure/names-are-pure-and-never-truncated.md][28], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 16 (text), line 42 (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/azure/one-namer-assembles-every-name.md][29], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text) and line 59 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][30], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 69 (text).

### Az.Templates (7 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][31], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 87 (body comment), line 98 (body comment) and line 126 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][32], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 18 (header) and line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][33], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 77 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][34], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 136 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][35], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 68 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][37], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 2 (header), line 25 (body comment) and line 95 (body comment).

### Azure (4 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/configs/azure.yml][38], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at line
  11 (header), line 38 (body comment) and line 85 (body comment).
- [automation/Catzc.Azure/configs/customer.yml][39], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 9 (header).
- [automation/Catzc.Azure/types/AzureConfig.cs][40], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 18 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][41], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 2 (header).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][42], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/adrs.yml][43], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 267 (text).

### Variants (1 lit file)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][44], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 7 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][45], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 15 (text) and line 249
  (text).

## Keywords

- [world map][46]
- [track][47]
- [file language][48]
- [cell][49]
- [lit cell][50]
- [automation][44]: a track
- [docs][44]: a track
- [csharp][51]: a file language
- [markdown][51]: a file language
- [powershell][51]: a file language
- [yaml][51]: a file language

[1]: ../../adr/azure/azure-naming-standard.md
[2]: ../../adr/azure/az-session-verification.md
[3]: ../../adr/azure/azure-customer-model.md
[4]: ../../adr/azure/azure-data-model.md
[5]: ../../adr/azure/azure-network-model.md
[6]: ../../adr/azure/caf/design-principles.md
[7]: ../../adr/azure/caf/governance.md
[8]: ../../adr/azure/caf/management.md
[9]: ../../adr/azure/caf/naming-and-tagging.md
[10]: ../../adr/azure/caf/resource-organization.md
[11]: ../../adr/azure/caf/security.md
[12]: ../../adr/azure/dora-explains.md
[13]: ../../adr/azure/landing-zones.md
[14]: ../../adr/azure/prefer-az-cli.md
[15]: ../../adr/azure/waf/cost-optimization.md
[16]: ../../adr/azure/waf/operational-excellence.md
[17]: ../../adr/azure/waf/performance-efficiency.md
[18]: ../../adr/azure/waf/reliability.md
[19]: ../../adr/azure/waf/security.md
[20]: adr-az-naming--how-each-naming-rule-is-held--governance.drawio.md
[21]: adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.md
[22]: adr-az-naming--names-are-derived-never-typed--operations.drawio.md
[23]: adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.md
[24]: adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md
[25]: ../../explanation/azure/how-each-naming-rule-is-held.md
[26]: ../../explanation/azure/lookup-form-check-render-in-order.md
[27]: ../../explanation/azure/names-are-derived-never-typed.md
[28]: ../../explanation/azure/names-are-pure-and-never-truncated.md
[29]: ../../explanation/azure/one-namer-assembles-every-name.md
[30]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[31]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[32]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[33]: ../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[34]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[35]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[36]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[37]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[38]: ../../../automation/Catzc.Azure/configs/azure.yml
[39]: ../../../automation/Catzc.Azure/configs/customer.yml
[40]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[41]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[42]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[43]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[44]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[45]: ../../adr/index.md
[46]: ../../adr/glossary.md#world-map
[47]: ../../adr/glossary.md#track
[48]: ../../adr/glossary.md#file-language
[49]: ../../adr/glossary.md#cell
[50]: ../../adr/glossary.md#lit-cell
[51]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

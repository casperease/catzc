# docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.tree.md

`Tree minimap: adr-az-naming--names-are-derived-never-typed--operations`

![Tree minimap of adr-az-naming--names-are-derived-never-typed--operations](adr-az-naming--names-are-derived-never-typed--operations.tree.png)

The tree minimap of the slide `adr-az-naming--names-are-derived-never-typed--operations` (operations lens). The slide supports
[ADR-AZ-NAMING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 66 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 26 lit files
- adr/azure (docs/adr/azure): 25 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 7 lit files
- Azure (automation/Catzc.Azure): 4 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Variants (automation/Catzc.Base.Variants): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (26 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.chain.md][2], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 63 (text) and line 71 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.grid.md][4], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 57 (text), line 59 (text), line 60 (text), line 61
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99
  (text), line 100 (text), line 101 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 111
  (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text) and line 122 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.tree.md][5], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text),
  line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 73 (text), line 75 (text), line 77 (text),
  line 79 (text), line 81 (text), line 82 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 111 (text), line 112 (text), line 119 (text), line 121
  (text), line 123 (text), line 125 (text), line 132 (text), line 134 (text), line 141 (text) and line 148 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md][6], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md][8], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 57 (text), line 59 (text), line 60 (text),
  line 61 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text),
  line 99 (text), line 100 (text), line 101 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text),
  line 111 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text) and line 122 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.tree.md][9], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line
  37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 73 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 82 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 111 (text), line 112 (text), line 119 (text),
  line 121 (text), line 123 (text), line 125 (text), line 132 (text), line 134 (text), line 141 (text) and line 148 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.chain.md][10], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.drawio.md][11], in the cell docs × markdown: selected
  by [ADR-AZ-NAMING][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.grid.md][12], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 57 (text), line 59 (text), line 60 (text), line 61
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99
  (text), line 100 (text), line 101 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 111
  (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text) and line 122 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.tree.md][13], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text),
  line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 73 (text), line 75 (text), line 77 (text),
  line 79 (text), line 81 (text), line 82 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 111 (text), line 112 (text), line 119 (text), line 121
  (text), line 123 (text), line 125 (text), line 132 (text), line 134 (text), line 141 (text) and line 148 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md][14], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.md][15], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md][16], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 7 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 57 (text), line 59 (text), line 60 (text), line 61
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99
  (text), line 100 (text), line 101 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 111
  (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text) and line 122 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md][17], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text),
  line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 73 (text), line 75 (text), line 77 (text),
  line 79 (text), line 81 (text), line 82 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 111 (text), line 112 (text), line 119 (text), line 121
  (text), line 123 (text), line 125 (text), line 132 (text), line 134 (text), line 141 (text) and line 148 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md][18], in the cell docs × markdown: selected
  by [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md][20], in the cell docs × markdown: selected
  by [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 57 (text), line 59 (text), line 60 (text), line 61
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99
  (text), line 100 (text), line 101 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 111
  (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text) and line 122 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.tree.md][21], in the cell docs × markdown: selected
  by [ADR-AZ-NAMING][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text),
  line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 73 (text), line 75 (text), line 77 (text),
  line 79 (text), line 81 (text), line 82 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 111 (text), line 112 (text), line 119 (text), line 121
  (text), line 123 (text), line 125 (text), line 132 (text), line 134 (text), line 141 (text) and line 148 (text).
- [docs/explanation/azure/how-each-naming-rule-is-held.md][22], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 15 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and
  line 59 (text).
- [docs/explanation/azure/lookup-form-check-render-in-order.md][23], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 19 (text), line 60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/azure/names-are-derived-never-typed.md][24], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 16 (text), line 49 (text), line 50 (text), line 51 (text), line 52 (text) and line 53 (text).
- [docs/explanation/azure/names-are-pure-and-never-truncated.md][25], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 16 (text), line 42 (text), line 42 (text), line 44 (text) and line 45 (text).
- [docs/explanation/azure/one-namer-assembles-every-name.md][26], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text) and line 59 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][27], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 69 (text).

### adr/azure (25 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/az-session-verification.md][28], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/azure-customer-model.md][29], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-data-model.md][30], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][1], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-network-model.md][31], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/billing-and-tenant.md][32], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/design-principles.md][33], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][34], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][35], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/landing-zone-security.md][36], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/management.md][37], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][38], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-connectivity.md][39], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-private-access.md][40], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-topology.md][41], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][42], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of
  the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][43], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][44], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][45], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][46], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][47], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][48], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][49], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][50], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/security.md][51], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.

### Az.Templates (7 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1][52], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 87 (body comment), line 98 (body comment) and line 126 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1][53], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 18 (header) and line 21 (header).
- [automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1][54], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 77 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1][55], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 136 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][56], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 68 (text).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][57], in the cell automation × powershell: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][58], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 2 (header), line 25 (body comment) and line 95 (body comment).

### Azure (4 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/configs/azure.yml][59], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at line
  11 (header), line 38 (body comment) and line 85 (body comment).
- [automation/Catzc.Azure/configs/customer.yml][60], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 9 (header).
- [automation/Catzc.Azure/types/AzureConfig.cs][61], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 18 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][62], in the cell automation × csharp: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 2 (header).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][63], in the cell automation × powershell: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/adrs.yml][64], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 269 (text).

### Variants (1 lit file)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][65], in the cell automation × yaml: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 7 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][66], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 15 (text) and line 251
  (text).

## Keywords

- [world map][67]
- [track][68]
- [file language][69]
- [cell][70]
- [lit cell][71]
- [automation][65]: a track
- [docs][65]: a track
- [csharp][72]: a file language
- [markdown][72]: a file language
- [powershell][72]: a file language
- [yaml][72]: a file language

[1]: ../../adr/azure/azure-naming-standard.md
[2]: adr-az-naming--how-each-naming-rule-is-held--governance.chain.md
[3]: adr-az-naming--how-each-naming-rule-is-held--governance.drawio.md
[4]: adr-az-naming--how-each-naming-rule-is-held--governance.grid.md
[5]: adr-az-naming--how-each-naming-rule-is-held--governance.tree.md
[6]: adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md
[7]: adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.md
[8]: adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md
[9]: adr-az-naming--lookup-form-check-render-in-order--implementation.tree.md
[10]: adr-az-naming--names-are-derived-never-typed--operations.chain.md
[11]: adr-az-naming--names-are-derived-never-typed--operations.drawio.md
[12]: adr-az-naming--names-are-derived-never-typed--operations.grid.md
[13]: adr-az-naming--names-are-derived-never-typed--operations.tree.md
[14]: adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md
[15]: adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.md
[16]: adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md
[17]: adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md
[18]: adr-az-naming--one-namer-assembles-every-name--architecture.chain.md
[19]: adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md
[20]: adr-az-naming--one-namer-assembles-every-name--architecture.grid.md
[21]: adr-az-naming--one-namer-assembles-every-name--architecture.tree.md
[22]: ../../explanation/azure/how-each-naming-rule-is-held.md
[23]: ../../explanation/azure/lookup-form-check-render-in-order.md
[24]: ../../explanation/azure/names-are-derived-never-typed.md
[25]: ../../explanation/azure/names-are-pure-and-never-truncated.md
[26]: ../../explanation/azure/one-namer-assembles-every-name.md
[27]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[28]: ../../adr/azure/az-session-verification.md
[29]: ../../adr/azure/azure-customer-model.md
[30]: ../../adr/azure/azure-data-model.md
[31]: ../../adr/azure/azure-network-model.md
[32]: ../../adr/azure/caf/billing-and-tenant.md
[33]: ../../adr/azure/caf/design-principles.md
[34]: ../../adr/azure/caf/governance.md
[35]: ../../adr/azure/caf/identity-and-access.md
[36]: ../../adr/azure/caf/landing-zone-security.md
[37]: ../../adr/azure/caf/management.md
[38]: ../../adr/azure/caf/naming-and-tagging.md
[39]: ../../adr/azure/caf/network-connectivity.md
[40]: ../../adr/azure/caf/network-private-access.md
[41]: ../../adr/azure/caf/network-topology.md
[42]: ../../adr/azure/caf/platform-automation-and-devops.md
[43]: ../../adr/azure/caf/resource-organization.md
[44]: ../../adr/azure/dora-explains.md
[45]: ../../adr/azure/landing-zones.md
[46]: ../../adr/azure/prefer-az-cli.md
[47]: ../../adr/azure/waf/cost-optimization.md
[48]: ../../adr/azure/waf/operational-excellence.md
[49]: ../../adr/azure/waf/performance-efficiency.md
[50]: ../../adr/azure/waf/reliability.md
[51]: ../../adr/azure/waf/security.md
[52]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1
[53]: ../../../automation/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
[54]: ../../../automation/Catzc.Azure.Templates/Get-BicepResourceName.ps1
[55]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplates.ps1
[56]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[57]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[58]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[59]: ../../../automation/Catzc.Azure/configs/azure.yml
[60]: ../../../automation/Catzc.Azure/configs/customer.yml
[61]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[62]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[63]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[64]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[65]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[66]: ../../adr/index.md
[67]: ../../adr/glossary.md#world-map
[68]: ../../adr/glossary.md#track
[69]: ../../adr/glossary.md#file-language
[70]: ../../adr/glossary.md#cell
[71]: ../../adr/glossary.md#lit-cell
[72]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

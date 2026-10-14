# docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md

`Tree minimap: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture`

![Tree minimap of adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture` (architecture lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 46 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/azure (docs/adr/azure): 25 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/azure (25 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/az-session-verification.md][3], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-customer-model.md][4], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-data-model.md][5], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][6], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-network-model.md][7], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/billing-and-tenant.md][8], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/design-principles.md][9], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][10], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][11], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/landing-zone-security.md][12], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/management.md][13], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][14], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-connectivity.md][15], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-private-access.md][16], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-topology.md][17], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][18], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][19], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][20], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][21], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][22], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][23], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][24], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][25], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/security.md][26], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][27], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][28], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][29], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][30], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][31], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][32], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][33], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][34], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Az.Cli (8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][35], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][36], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][37], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][38], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][39], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][40], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][41], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][42], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 13 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][43], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][44], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 586 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 670 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][45], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  270 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 96 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][46], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 252 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 89 (text).

## Keywords

- [world map][47]
- [track][48]
- [file language][49]
- [cell][50]
- [lit cell][51]
- [automation][52]: a track
- [docs][52]: a track
- [markdown][53]: a file language
- [powershell][53]: a file language
- [yaml][53]: a file language

[1]: ../../adr/azure/prefer-az-cli.md
[2]: ../../adr/design/thin-platforms.md
[3]: ../../adr/azure/az-session-verification.md
[4]: ../../adr/azure/azure-customer-model.md
[5]: ../../adr/azure/azure-data-model.md
[6]: ../../adr/azure/azure-naming-standard.md
[7]: ../../adr/azure/azure-network-model.md
[8]: ../../adr/azure/caf/billing-and-tenant.md
[9]: ../../adr/azure/caf/design-principles.md
[10]: ../../adr/azure/caf/governance.md
[11]: ../../adr/azure/caf/identity-and-access.md
[12]: ../../adr/azure/caf/landing-zone-security.md
[13]: ../../adr/azure/caf/management.md
[14]: ../../adr/azure/caf/naming-and-tagging.md
[15]: ../../adr/azure/caf/network-connectivity.md
[16]: ../../adr/azure/caf/network-private-access.md
[17]: ../../adr/azure/caf/network-topology.md
[18]: ../../adr/azure/caf/platform-automation-and-devops.md
[19]: ../../adr/azure/caf/resource-organization.md
[20]: ../../adr/azure/dora-explains.md
[21]: ../../adr/azure/landing-zones.md
[22]: ../../adr/azure/waf/cost-optimization.md
[23]: ../../adr/azure/waf/operational-excellence.md
[24]: ../../adr/azure/waf/performance-efficiency.md
[25]: ../../adr/azure/waf/reliability.md
[26]: ../../adr/azure/waf/security.md
[27]: ../../adr/design/commit-lifecycle.md
[28]: ../../adr/design/dora-explains.md
[29]: ../../adr/design/module-aspects.md
[30]: ../../adr/design/run-modes.md
[31]: ../../adr/design/self-service.md
[32]: ../../adr/design/server-remote-integration.md
[33]: ../../adr/design/tracks.md
[34]: ../../adr/design/visual-design.md
[35]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[36]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[37]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[38]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[39]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[40]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[41]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[42]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[43]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[44]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[45]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[46]: ../../adr/index.md
[47]: ../../adr/glossary.md#world-map
[48]: ../../adr/glossary.md#track
[49]: ../../adr/glossary.md#file-language
[50]: ../../adr/glossary.md#cell
[51]: ../../adr/glossary.md#lit-cell
[52]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[53]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

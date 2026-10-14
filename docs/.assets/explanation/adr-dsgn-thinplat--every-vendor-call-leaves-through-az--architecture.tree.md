# docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md

`Tree minimap: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture`

![Tree minimap of adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture` (architecture lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 50 files in 7 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- adr/azure (docs/adr/azure): 19 lit files
- docs (docs/ outside docs/adr/): 10 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/azure (19 lit files)

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
- [docs/adr/azure/caf/design-principles.md][8], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][9], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/management.md][10], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][11], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][12], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/security.md][13], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/dora-explains.md][14], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][15], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][16], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][17], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][18], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][19], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/security.md][20], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][21], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][22], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][23], in the cell docs ×
  markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 68 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line
  68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][24], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][25], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 74 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 74 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][26], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the
  file cites it at line 13 (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][27], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 63 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 19 (text), line 58 (text), line 59 (text) and line 65
  (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][28], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 53 (text) and line 57 (text); selected by [ADR-DSGN-THINPLAT][2]: the
  file cites it at line 17 (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][29], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the
  file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][30], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 17 (text), line 34 (text), line 60 (text), line 60 (text), line 61 (text), line 65 (text), line 67 (text) and line 71 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][31], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][32], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][33], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][34], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][35], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][36], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][37], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][38], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Az.Cli (8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][39], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][40], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][41], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][42], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][43], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][44], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][45], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][46], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 13 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][47], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][48], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 578 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 628 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][49], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  268 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 96 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][50], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 250 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 89 (text).

## Keywords

- [world map][51]
- [track][52]
- [file language][53]
- [cell][54]
- [lit cell][55]
- [automation][56]: a track
- [docs][56]: a track
- [markdown][57]: a file language
- [powershell][57]: a file language
- [yaml][57]: a file language

[1]: ../../adr/azure/prefer-az-cli.md
[2]: ../../adr/design/thin-platforms.md
[3]: ../../adr/azure/az-session-verification.md
[4]: ../../adr/azure/azure-customer-model.md
[5]: ../../adr/azure/azure-data-model.md
[6]: ../../adr/azure/azure-naming-standard.md
[7]: ../../adr/azure/azure-network-model.md
[8]: ../../adr/azure/caf/design-principles.md
[9]: ../../adr/azure/caf/governance.md
[10]: ../../adr/azure/caf/management.md
[11]: ../../adr/azure/caf/naming-and-tagging.md
[12]: ../../adr/azure/caf/resource-organization.md
[13]: ../../adr/azure/caf/security.md
[14]: ../../adr/azure/dora-explains.md
[15]: ../../adr/azure/landing-zones.md
[16]: ../../adr/azure/waf/cost-optimization.md
[17]: ../../adr/azure/waf/operational-excellence.md
[18]: ../../adr/azure/waf/performance-efficiency.md
[19]: ../../adr/azure/waf/reliability.md
[20]: ../../adr/azure/waf/security.md
[21]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[22]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[23]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[24]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[25]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[26]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[27]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[28]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[29]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[30]: ../../explanation/design/what-keeps-the-platform-thin.md
[31]: ../../adr/design/commit-lifecycle.md
[32]: ../../adr/design/dora-explains.md
[33]: ../../adr/design/module-aspects.md
[34]: ../../adr/design/run-modes.md
[35]: ../../adr/design/self-service.md
[36]: ../../adr/design/server-remote-integration.md
[37]: ../../adr/design/tracks.md
[38]: ../../adr/design/visual-design.md
[39]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[40]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[41]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[42]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[43]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[44]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[45]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[46]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[47]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[48]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[49]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[50]: ../../adr/index.md
[51]: ../../adr/glossary.md#world-map
[52]: ../../adr/glossary.md#track
[53]: ../../adr/glossary.md#file-language
[54]: ../../adr/glossary.md#cell
[55]: ../../adr/glossary.md#lit-cell
[56]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[57]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

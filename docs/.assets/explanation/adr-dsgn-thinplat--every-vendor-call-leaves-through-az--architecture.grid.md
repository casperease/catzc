# docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md

`Grid minimap: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture`

![Grid minimap of adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture` (architecture lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 8 lit of 1443 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 35 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][6]: selected by [ADR-AZ-CLI][1]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][7]: selected by [ADR-AZ-CLI][1]: the file cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][8]: selected by [ADR-AZ-CLI][1]: the file cites it at line 14
  (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][9]: selected by [ADR-AZ-CLI][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][10]: selected by [ADR-AZ-CLI][1]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][11]: selected by [ADR-AZ-CLI][1]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][12]: selected by [ADR-AZ-CLI][1]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][13]: selected by [ADR-AZ-CLI][1]: the file cites it at line 13 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-AZ-CLI][1]: the file cites it at line 270 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][15]: selected by [ADR-AZ-CLI][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][16]: selected by [ADR-AZ-CLI][1]: the file cites it at line 586 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 670 (text).

### docs × markdown (35 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/az-session-verification.md][17]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/azure-customer-model.md][18]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-data-model.md][19]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][20]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-network-model.md][21]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/billing-and-tenant.md][22]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/design-principles.md][23]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/governance.md][24]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][25]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/landing-zone-security.md][26]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/management.md][27]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][28]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/network-connectivity.md][29]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/network-private-access.md][30]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/network-topology.md][31]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][32]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR
  domain of that code.
- [docs/adr/azure/caf/resource-organization.md][33]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/dora-explains.md][34]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][35]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][1]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][36]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/waf/operational-excellence.md][37]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/performance-efficiency.md][38]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/reliability.md][39]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/security.md][40]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/design/commit-lifecycle.md][41]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][42]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][43]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][44]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/self-service.md][45]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][46]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][2]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][47]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][48]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][49]: selected by [ADR-AZ-CLI][1]: the file cites it at line 252 (text); selected by [ADR-DSGN-THINPLAT][2]: the file
  cites it at line 89 (text).

## Keywords

- [world map][50]
- [track][51]
- [file language][52]
- [cell][53]
- [lit cell][54]
- [automation][55]: a track
- [docs][55]: a track
- [markdown][56]: a file language
- [powershell][56]: a file language
- [yaml][56]: a file language

[1]: ../../adr/azure/prefer-az-cli.md
[2]: ../../adr/design/thin-platforms.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[7]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[8]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[9]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[10]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[11]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[12]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[13]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[14]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[16]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[17]: ../../adr/azure/az-session-verification.md
[18]: ../../adr/azure/azure-customer-model.md
[19]: ../../adr/azure/azure-data-model.md
[20]: ../../adr/azure/azure-naming-standard.md
[21]: ../../adr/azure/azure-network-model.md
[22]: ../../adr/azure/caf/billing-and-tenant.md
[23]: ../../adr/azure/caf/design-principles.md
[24]: ../../adr/azure/caf/governance.md
[25]: ../../adr/azure/caf/identity-and-access.md
[26]: ../../adr/azure/caf/landing-zone-security.md
[27]: ../../adr/azure/caf/management.md
[28]: ../../adr/azure/caf/naming-and-tagging.md
[29]: ../../adr/azure/caf/network-connectivity.md
[30]: ../../adr/azure/caf/network-private-access.md
[31]: ../../adr/azure/caf/network-topology.md
[32]: ../../adr/azure/caf/platform-automation-and-devops.md
[33]: ../../adr/azure/caf/resource-organization.md
[34]: ../../adr/azure/dora-explains.md
[35]: ../../adr/azure/landing-zones.md
[36]: ../../adr/azure/waf/cost-optimization.md
[37]: ../../adr/azure/waf/operational-excellence.md
[38]: ../../adr/azure/waf/performance-efficiency.md
[39]: ../../adr/azure/waf/reliability.md
[40]: ../../adr/azure/waf/security.md
[41]: ../../adr/design/commit-lifecycle.md
[42]: ../../adr/design/dora-explains.md
[43]: ../../adr/design/module-aspects.md
[44]: ../../adr/design/run-modes.md
[45]: ../../adr/design/self-service.md
[46]: ../../adr/design/server-remote-integration.md
[47]: ../../adr/design/tracks.md
[48]: ../../adr/design/visual-design.md
[49]: ../../adr/index.md
[50]: ../../adr/glossary.md#world-map
[51]: ../../adr/glossary.md#track
[52]: ../../adr/glossary.md#file-language
[53]: ../../adr/glossary.md#cell
[54]: ../../adr/glossary.md#lit-cell
[55]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[56]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

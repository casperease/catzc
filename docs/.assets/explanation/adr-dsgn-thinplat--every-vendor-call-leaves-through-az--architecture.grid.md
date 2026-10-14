# docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md

`Grid minimap: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture`

![Grid minimap of adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture` (architecture lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 3 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- automation × powershell: 8 lit of 1398 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 39 lit of 469 files

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

- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-AZ-CLI][1]: the file cites it at line 268 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][15]: selected by [ADR-AZ-CLI][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][16]: selected by [ADR-AZ-CLI][1]: the file cites it at line 578 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 628 (text).

### docs × markdown (39 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][17]: selected by [ADR-DSGN-THINPLAT][2]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][18]: selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][19]: selected by
  [ADR-AZ-CLI][1]: the file cites it at line 68 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][20]: selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][21]: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 74 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 74 (text).
- [docs/adr/azure/az-session-verification.md][22]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/azure-customer-model.md][23]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-data-model.md][24]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][25]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-network-model.md][26]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/design-principles.md][27]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/governance.md][28]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/management.md][29]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][30]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/resource-organization.md][31]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/security.md][32]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][33]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][34]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][1]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][35]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/waf/operational-excellence.md][36]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/performance-efficiency.md][37]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/reliability.md][38]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/security.md][39]: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/design/commit-lifecycle.md][40]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][41]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][42]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][43]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/self-service.md][44]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][45]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][2]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][46]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][47]: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][48]: selected by [ADR-AZ-CLI][1]: the file cites it at line 250 (text); selected by [ADR-DSGN-THINPLAT][2]: the file
  cites it at line 89 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][49]: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 13
  (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][50]: selected by [ADR-AZ-CLI][1]: the file cites it at line 63 (text); selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 19 (text), line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][51]: selected by [ADR-AZ-CLI][1]: the file cites it at line 17 (text),
  line 52 (text), line 53 (text), line 53 (text) and line 57 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 17
  (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][52]: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 16 (text),
  line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][53]: selected by [ADR-AZ-CLI][1]: the file cites it at line 17 (text), line 34
  (text), line 60 (text), line 60 (text), line 61 (text), line 65 (text), line 67 (text) and line 71 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59
  (text).

## Keywords

- [world map][54]
- [track][55]
- [file language][56]
- [cell][57]
- [lit cell][58]
- [automation][59]: a track
- [docs][59]: a track
- [markdown][60]: a file language
- [powershell][60]: a file language
- [yaml][60]: a file language

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
[17]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[18]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[19]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[20]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[21]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[22]: ../../adr/azure/az-session-verification.md
[23]: ../../adr/azure/azure-customer-model.md
[24]: ../../adr/azure/azure-data-model.md
[25]: ../../adr/azure/azure-naming-standard.md
[26]: ../../adr/azure/azure-network-model.md
[27]: ../../adr/azure/caf/design-principles.md
[28]: ../../adr/azure/caf/governance.md
[29]: ../../adr/azure/caf/management.md
[30]: ../../adr/azure/caf/naming-and-tagging.md
[31]: ../../adr/azure/caf/resource-organization.md
[32]: ../../adr/azure/caf/security.md
[33]: ../../adr/azure/dora-explains.md
[34]: ../../adr/azure/landing-zones.md
[35]: ../../adr/azure/waf/cost-optimization.md
[36]: ../../adr/azure/waf/operational-excellence.md
[37]: ../../adr/azure/waf/performance-efficiency.md
[38]: ../../adr/azure/waf/reliability.md
[39]: ../../adr/azure/waf/security.md
[40]: ../../adr/design/commit-lifecycle.md
[41]: ../../adr/design/dora-explains.md
[42]: ../../adr/design/module-aspects.md
[43]: ../../adr/design/run-modes.md
[44]: ../../adr/design/self-service.md
[45]: ../../adr/design/server-remote-integration.md
[46]: ../../adr/design/tracks.md
[47]: ../../adr/design/visual-design.md
[48]: ../../adr/index.md
[49]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[50]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[51]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[52]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[53]: ../../explanation/design/what-keeps-the-platform-thin.md
[54]: ../../adr/glossary.md#world-map
[55]: ../../adr/glossary.md#track
[56]: ../../adr/glossary.md#file-language
[57]: ../../adr/glossary.md#cell
[58]: ../../adr/glossary.md#lit-cell
[59]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[60]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

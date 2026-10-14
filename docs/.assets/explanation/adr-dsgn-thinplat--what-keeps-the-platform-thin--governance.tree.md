# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md

`Tree minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Tree minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AUTO-PARITY][1], [ADR-AZ-CLI][2] and [ADR-DSGN-THINPLAT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 89 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 40 lit files
- adr/azure (docs/adr/azure): 25 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- Root files: 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Repository (automation/Catzc.Base.Repository): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (40 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][4], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][5], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][6], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][7], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/index.md][8], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][9], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][10], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/consumer-overlay.md][11], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][12], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][13], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][14], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][1], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][16], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][17], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][18], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][19], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][20], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][21], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][22], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][23], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][24], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][25], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][26], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][27], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][28], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][29], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][30], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][31], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][32], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][33], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][34], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][35], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][36], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][37], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][38], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][39], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][40], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][41], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][42], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### adr/azure (25 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/az-session-verification.md][43], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-customer-model.md][44], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-data-model.md][45], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][46], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-network-model.md][47], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/billing-and-tenant.md][48], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/design-principles.md][49], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][50], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][51], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/landing-zone-security.md][52], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/management.md][53], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][54], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-connectivity.md][55], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-private-access.md][56], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-topology.md][57], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][58], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][59], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][60], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][61], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][2], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][62], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][63], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][64], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][65], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/security.md][66], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][67], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][68], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][69], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][70], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][71], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][72], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][3], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][73], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][74], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Az.Cli (8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][75], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][76], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][77], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][78], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][79], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][80], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][81], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][82], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 13 (header).

### Root files (2 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][83], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).
- [.gitignore][84], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][85], in the cell automation × yaml: selected by [ADR-AZ-CLI][2]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][86], in the cell automation × yaml: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 586 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 670 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][87], in the cell automation × yaml: selected by [ADR-AUTO-PARITY][1]: the file cites it at
  line 137 (text); selected by [ADR-AZ-CLI][2]: the file cites it at line 270 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it
  at line 96 (text).

### Repository (1 lit file)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Get-RunEnvironment.ps1][88], in the cell automation × powershell: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 6 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][89], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 125 (text); selected by
  [ADR-AZ-CLI][2]: the file cites it at line 252 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 89 (text).

## Keywords

- [world map][90]
- [track][91]
- [file language][92]
- [cell][93]
- [lit cell][94]
- [root file][95]
- [unlisted file][96]
- [automation][97]: a track
- [docs][97]: a track
- [markdown][98]: a file language
- [powershell][98]: a file language
- [yaml][98]: a file language

[1]: ../../adr/automation/devbox-pipeline-parity.md
[2]: ../../adr/azure/prefer-az-cli.md
[3]: ../../adr/design/thin-platforms.md
[4]: ../../adr/automation/BCL/index.md
[5]: ../../adr/automation/BCL/native-csharp-types.md
[6]: ../../adr/automation/avoid-deep-nesting.md
[7]: ../../adr/automation/bash/bash-test-artifacts.md
[8]: ../../adr/automation/bash/index.md
[9]: ../../adr/automation/caching.md
[10]: ../../adr/automation/console-output-matters.md
[11]: ../../adr/automation/consumer-overlay.md
[12]: ../../adr/automation/controlling-module-dependencies.md
[13]: ../../adr/automation/controlling-systemwide-deps.md
[14]: ../../adr/automation/cross-platform.md
[15]: ../../adr/automation/dora-explains.md
[16]: ../../adr/automation/dry-run.md
[17]: ../../adr/automation/effective-in-enterprises.md
[18]: ../../adr/automation/environment-variables.md
[19]: ../../adr/automation/execution-engines.md
[20]: ../../adr/automation/fail-fast-with-asserts.md
[21]: ../../adr/automation/go/go-test-artifacts.md
[22]: ../../adr/automation/go/index.md
[23]: ../../adr/automation/idempotent-state-functions.md
[24]: ../../adr/automation/internal-asset-dependencies.md
[25]: ../../adr/automation/log-before-invoke.md
[26]: ../../adr/automation/managed-guids.md
[27]: ../../adr/automation/never-depend-on-pwd.md
[28]: ../../adr/automation/open-closed-architecture.md
[29]: ../../adr/automation/path-representation.md
[30]: ../../adr/automation/platform-bundle.md
[31]: ../../adr/automation/python/index.md
[32]: ../../adr/automation/python/python-test-artifacts.md
[33]: ../../adr/automation/retry-as-last-resort.md
[34]: ../../adr/automation/sensible-defaults.md
[35]: ../../adr/automation/single-responsibility-functions.md
[36]: ../../adr/automation/spell-out-names.md
[37]: ../../adr/automation/test-automation.md
[38]: ../../adr/automation/tool-removal-lifecycle.md
[39]: ../../adr/automation/tracked-files-from-the-index.md
[40]: ../../adr/automation/use-proper-package-managers.md
[41]: ../../adr/automation/uv-python-handler.md
[42]: ../../adr/automation/zero-ceremony-poka-yoke.md
[43]: ../../adr/azure/az-session-verification.md
[44]: ../../adr/azure/azure-customer-model.md
[45]: ../../adr/azure/azure-data-model.md
[46]: ../../adr/azure/azure-naming-standard.md
[47]: ../../adr/azure/azure-network-model.md
[48]: ../../adr/azure/caf/billing-and-tenant.md
[49]: ../../adr/azure/caf/design-principles.md
[50]: ../../adr/azure/caf/governance.md
[51]: ../../adr/azure/caf/identity-and-access.md
[52]: ../../adr/azure/caf/landing-zone-security.md
[53]: ../../adr/azure/caf/management.md
[54]: ../../adr/azure/caf/naming-and-tagging.md
[55]: ../../adr/azure/caf/network-connectivity.md
[56]: ../../adr/azure/caf/network-private-access.md
[57]: ../../adr/azure/caf/network-topology.md
[58]: ../../adr/azure/caf/platform-automation-and-devops.md
[59]: ../../adr/azure/caf/resource-organization.md
[60]: ../../adr/azure/dora-explains.md
[61]: ../../adr/azure/landing-zones.md
[62]: ../../adr/azure/waf/cost-optimization.md
[63]: ../../adr/azure/waf/operational-excellence.md
[64]: ../../adr/azure/waf/performance-efficiency.md
[65]: ../../adr/azure/waf/reliability.md
[66]: ../../adr/azure/waf/security.md
[67]: ../../adr/design/commit-lifecycle.md
[68]: ../../adr/design/dora-explains.md
[69]: ../../adr/design/module-aspects.md
[70]: ../../adr/design/run-modes.md
[71]: ../../adr/design/self-service.md
[72]: ../../adr/design/server-remote-integration.md
[73]: ../../adr/design/tracks.md
[74]: ../../adr/design/visual-design.md
[75]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[76]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[77]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[78]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[79]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[80]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[81]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[82]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[83]: ../../../.gitattributes
[84]: ../../../.gitignore
[85]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[86]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[87]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[88]: ../../../automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
[89]: ../../adr/index.md
[90]: ../../adr/glossary.md#world-map
[91]: ../../adr/glossary.md#track
[92]: ../../adr/glossary.md#file-language
[93]: ../../adr/glossary.md#cell
[94]: ../../adr/glossary.md#lit-cell
[95]: ../../adr/glossary.md#root-file
[96]: ../../adr/glossary.md#unlisted-file
[97]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[98]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

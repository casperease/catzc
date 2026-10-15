# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md

`Tree minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Tree minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AUTO-PARITY][1], [ADR-AZ-CLI][2] and [ADR-DSGN-THINPLAT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 21 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- Root files: 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Repository (automation/Catzc.Base.Repository): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Az.Cli (automation/Catzc.Azure.Cli, 8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][4], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites it
  at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][5], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][6], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][7], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][8], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][9], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][10], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][11], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 13 (header).

### Root files (2 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][12], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).
- [.gitignore][13], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][14], in the cell automation × yaml: selected by [ADR-AZ-CLI][2]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][15], in the cell automation × yaml: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 586 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 670 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/devbox-pipeline-parity.md][1], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 13
  (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: the file cites it at line 342 (text).
- [docs/adr/azure/prefer-az-cli.md][2], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: the ADR's own file.

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 29
  (text).
- [docs/adr/design/thin-platforms.md][3], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][19], in the cell automation × yaml: selected by [ADR-AUTO-PARITY][1]: the file cites it at
  line 137 (text); selected by [ADR-AZ-CLI][2]: the file cites it at line 270 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it
  at line 96 (text).

### Repository (automation/Catzc.Base.Repository, 1 lit file)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Get-RunEnvironment.ps1][20], in the cell automation × powershell: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 6 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][21], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 125 (text); selected by
  [ADR-AZ-CLI][2]: the file cites it at line 252 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 89 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [root file][27]
- [unlisted file][28]
- [automation][29]: a track
- [docs][29]: a track
- [markdown][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

[1]: ../../adr/automation/devbox-pipeline-parity.md
[2]: ../../adr/azure/prefer-az-cli.md
[3]: ../../adr/design/thin-platforms.md
[4]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[5]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[6]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[7]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[8]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[9]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[10]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[11]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[12]: ../../../.gitattributes
[13]: ../../../.gitignore
[14]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[15]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[16]: ../../adr/automation/dora-explains.md
[17]: ../../adr/azure/dora-explains.md
[18]: ../../adr/design/dora-explains.md
[19]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
[21]: ../../adr/index.md
[22]: ../../adr/glossary.md#world-map
[23]: ../../adr/glossary.md#track
[24]: ../../adr/glossary.md#file-language
[25]: ../../adr/glossary.md#cell
[26]: ../../adr/glossary.md#lit-cell
[27]: ../../adr/glossary.md#root-file
[28]: ../../adr/glossary.md#unlisted-file
[29]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

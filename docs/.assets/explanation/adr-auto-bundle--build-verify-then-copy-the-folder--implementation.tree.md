# docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md

`Tree minimap: adr-auto-bundle--build-verify-then-copy-the-folder--implementation`

![Tree minimap of adr-auto-bundle--build-verify-then-copy-the-folder--implementation](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.png)

The tree minimap of the slide `adr-auto-bundle--build-verify-then-copy-the-folder--implementation` (implementation lens). The slide supports
[ADR-AUTO-BUNDLE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 18 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Exporter (automation/Catzc.Base.Exporter): 10 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Root files: 1 lit file
- .github: 1 lit file
- .internal (automation/.internal): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Exporter (automation/Catzc.Base.Exporter, 10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][2], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][3], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][4], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][7], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][8], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][9], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][10], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][11], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 421
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][13], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][14], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### .internal (automation/.internal, 1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][15], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][16], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 149 (text).

## Keywords

- [world map][19]
- [track][20]
- [file language][21]
- [cell][22]
- [lit cell][23]
- [root file][24]
- [.github][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [csharp][26]: a file language
- [markdown][26]: a file language
- [powershell][26]: a file language
- [yaml][26]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[3]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[4]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[5]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[6]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[7]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[8]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[9]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[10]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[11]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[12]: ../../adr/automation/dora-explains.md
[13]: ../../../importer.ps1
[14]: ../../../.github/workflows/ci-automation.yml
[15]: ../../../automation/.internal/assets/Import-Catzc.ps1
[16]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[17]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../adr/index.md
[19]: ../../adr/glossary.md#world-map
[20]: ../../adr/glossary.md#track
[21]: ../../adr/glossary.md#file-language
[22]: ../../adr/glossary.md#cell
[23]: ../../adr/glossary.md#lit-cell
[24]: ../../adr/glossary.md#root-file
[25]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md

`Tree minimap: adr-auto-bundle--every-code-root-is-a-copy--architecture`

![Tree minimap of adr-auto-bundle--every-code-root-is-a-copy--architecture](adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.png)

The tree minimap of the slide `adr-auto-bundle--every-code-root-is-a-copy--architecture` (architecture lens). The slide supports
[ADR-AUTO-BUNDLE][1] and [ADR-DSGN-RUNMODE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 50 files in 17 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Exporter (automation/Catzc.Base.Exporter): 10 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- Root files: 3 lit files
- Repository (automation/Catzc.Base.Repository): 3 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Vendor (automation/Catzc.Base.Vendor): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- .github: 1 lit file
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Exporter (automation/Catzc.Base.Exporter, 10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][3], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][4], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][7], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][8], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][9], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][10], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][11], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][12], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][13], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][14], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][16], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][17], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][18], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][19], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][20], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 21 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][21], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][22], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][23], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 596 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 6 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][26], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][27], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][28], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][29], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][30], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 22 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][31], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][32], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [importer.ps1][33], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1
  (text).

### Repository (automation/Catzc.Base.Repository, 3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][34], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][35], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][36], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 6 (header).

### .internal (automation/.internal, 2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][37], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][38], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 1 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][39], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][40], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).

### Vendor (automation/Catzc.Base.Vendor, 2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][41], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][42], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 18 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][43], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 421
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][44], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 125
  (text).
- [docs/adr/design/run-modes.md][2], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the ADR's own file.

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][45], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### ConfigExtensions (automation/Catzc.Base.ConfigExtensions, 1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][46], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][47], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][48], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the file
  cites it at line 29 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][49], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 24 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][50], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 149 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 94 (text).

## Keywords

- [world map][51]
- [track][52]
- [file language][53]
- [cell][54]
- [lit cell][55]
- [root file][56]
- [unlisted file][57]
- [.github][58]: a track
- [automation][58]: a track
- [docs][58]: a track
- [csharp][59]: a file language
- [markdown][59]: a file language
- [powershell][59]: a file language
- [yaml][59]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/run-modes.md
[3]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[4]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[5]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[6]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[7]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[8]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[9]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[10]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[11]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[12]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[13]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[14]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[15]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[16]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[17]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[18]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[19]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[20]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[22]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[23]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[24]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[25]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[26]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[27]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[28]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[29]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[30]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[31]: ../../../.gitattributes
[32]: ../../../.gitignore
[33]: ../../../importer.ps1
[34]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[35]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[36]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[37]: ../../../automation/.internal/assets/Import-Catzc.ps1
[38]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[39]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[40]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[41]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[42]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[43]: ../../adr/automation/dora-explains.md
[44]: ../../adr/design/dora-explains.md
[45]: ../../../.github/workflows/ci-automation.yml
[46]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[47]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[48]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[49]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[50]: ../../adr/index.md
[51]: ../../adr/glossary.md#world-map
[52]: ../../adr/glossary.md#track
[53]: ../../adr/glossary.md#file-language
[54]: ../../adr/glossary.md#cell
[55]: ../../adr/glossary.md#lit-cell
[56]: ../../adr/glossary.md#root-file
[57]: ../../adr/glossary.md#unlisted-file
[58]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[59]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

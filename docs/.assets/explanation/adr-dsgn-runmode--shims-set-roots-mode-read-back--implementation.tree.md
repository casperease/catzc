# docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md

`Tree minimap: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation`

![Tree minimap of adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation](adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation` (implementation lens). The slide supports
[ADR-DSGN-RUNMODE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 36 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- ModuleSystem (automation/Catzc.Base.ModuleSystem): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- Root files: 3 lit files
- Repository (automation/Catzc.Base.Repository): 3 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Vendor (automation/Catzc.Base.Vendor): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][2], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][3], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][4], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][5], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][6], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][7], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][8], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][9], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 21 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][10], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][11], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][12], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 596 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][13], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][14], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (header) and line 6 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][16], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][17], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][18], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][19], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 22 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][20], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][21], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [importer.ps1][22], in the cell Root files × powershell: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Repository (automation/Catzc.Base.Repository, 3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][23], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][24], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][25], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 6 (header).

### .internal (automation/.internal, 2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][26], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][27], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 1 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][28], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 101 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][29], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 11 (header).

### Vendor (automation/Catzc.Base.Vendor, 2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][30], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][31], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 18 (header).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][32], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 125
  (text).
- [docs/adr/design/run-modes.md][1], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.

### ConfigExtensions (automation/Catzc.Base.ConfigExtensions, 1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][33], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 12 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][34], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 29 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][35], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 24 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][36], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 94 (text).

## Keywords

- [world map][37]
- [track][38]
- [file language][39]
- [cell][40]
- [lit cell][41]
- [root file][42]
- [unlisted file][43]
- [automation][44]: a track
- [docs][44]: a track
- [markdown][45]: a file language
- [powershell][45]: a file language
- [yaml][45]: a file language

[1]: ../../adr/design/run-modes.md
[2]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[3]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[4]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[5]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[6]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[7]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[8]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[9]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[10]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[11]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[12]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[13]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[14]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[15]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[16]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[17]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[18]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[19]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[20]: ../../../.gitattributes
[21]: ../../../.gitignore
[22]: ../../../importer.ps1
[23]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[24]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[25]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[26]: ../../../automation/.internal/assets/Import-Catzc.ps1
[27]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[28]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[30]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[31]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[32]: ../../adr/design/dora-explains.md
[33]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[34]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[35]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[36]: ../../adr/index.md
[37]: ../../adr/glossary.md#world-map
[38]: ../../adr/glossary.md#track
[39]: ../../adr/glossary.md#file-language
[40]: ../../adr/glossary.md#cell
[41]: ../../adr/glossary.md#lit-cell
[42]: ../../adr/glossary.md#root-file
[43]: ../../adr/glossary.md#unlisted-file
[44]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[45]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

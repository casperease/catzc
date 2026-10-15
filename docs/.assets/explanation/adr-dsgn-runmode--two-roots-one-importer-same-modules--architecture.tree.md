# docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md

`Tree minimap: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture`

![Tree minimap of adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture` (architecture lens). The slide supports
[ADR-DSGN-RUNMODE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 65 files in 14 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 24 lit files
- Root files: 8 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
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

### docs (docs/ outside docs/adr/, 24 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md][2], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 20 (text).
- [docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][4], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 34 (text).
- [docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 33 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 20 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-BaseModule.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 36 (text).
- [docs/references/automation/catzc-base-modulesystem/New-Importer.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 24 (text).
- [docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-repository/Assert-SourceTree.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 23 (text).
- [docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 38 (text).
- [docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (text).

### Root files (8 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][26], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 6 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][27], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 6 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.unordered/15-10-2026/plan-adr-consistency.md][28], in the cell Root files × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 195 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][29], in the cell Root files × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 12 (text), line 32 (text), line 261 (text) and line 272 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][30], in the cell Root files × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 93 (text).
- [.unordered/15-10-2026/plan-diagram-wave-9.md][31], in the cell Root files × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 121 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][32], in the cell Root files × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 71 (text) and line 96 (text).
- [importer.ps1][33], in the cell Root files × powershell: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][34], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][35], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][36], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][37], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][38], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][39], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][40], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][41], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][42], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][43], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][44], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 580 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][45], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][46], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (header) and line 6 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][47], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][48], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][49], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][50], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][51], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 7 (header).

### Repository (automation/Catzc.Base.Repository, 3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][52], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][53], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][54], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 6 (header).

### .internal (automation/.internal, 2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][55], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][56], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 1 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][57], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 84 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][58], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 7 (header).

### Vendor (automation/Catzc.Base.Vendor, 2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][59], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][60], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 6 (header).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][61], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 125
  (text).
- [docs/adr/design/run-modes.md][1], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.

### ConfigExtensions (automation/Catzc.Base.ConfigExtensions, 1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][62], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][63], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 14 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][64], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][65], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 96 (text).

## Keywords

- [world map][66]
- [track][67]
- [file language][68]
- [cell][69]
- [lit cell][70]
- [root file][71]
- [unlisted file][72]
- [automation][73]: a track
- [docs][73]: a track
- [markdown][74]: a file language
- [powershell][74]: a file language
- [yaml][74]: a file language

[1]: ../../adr/design/run-modes.md
[2]: ../../references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md
[3]: ../../references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
[4]: ../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[5]: ../../references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
[6]: ../../references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md
[7]: ../../references/automation/catzc-base-modulesystem/Get-BaseModule.ps1.md
[8]: ../../references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[9]: ../../references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
[10]: ../../references/automation/catzc-base-modulesystem/New-Importer.ps1.md
[11]: ../../references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[12]: ../../references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
[13]: ../../references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md
[14]: ../../references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
[15]: ../../references/automation/catzc-base-repository/Assert-SourceTree.ps1.md
[16]: ../../references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
[17]: ../../references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md
[18]: ../../references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
[19]: ../../references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[20]: ../../references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
[21]: ../../references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md
[22]: ../../references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
[23]: ../../references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
[24]: ../../references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
[25]: ../../references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md
[26]: ../../../.gitattributes
[27]: ../../../.gitignore
[28]: ../../../.unordered/15-10-2026/plan-adr-consistency.md
[29]: ../../../.unordered/15-10-2026/plan-built-bundle.md
[30]: ../../../.unordered/15-10-2026/plan-concern-axis.md
[31]: ../../../.unordered/15-10-2026/plan-diagram-wave-9.md
[32]: ../../../.unordered/15-10-2026/plan-explanation-drift.md
[33]: ../../../importer.ps1
[34]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[35]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[36]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[37]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[38]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[39]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[40]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[41]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[42]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[43]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[44]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[45]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[46]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[47]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[48]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[49]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[50]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[51]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[52]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[53]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[54]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[55]: ../../../automation/.internal/assets/Import-Catzc.ps1
[56]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[57]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[58]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[59]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[60]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[61]: ../../adr/design/dora-explains.md
[62]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[63]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[64]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[65]: ../../adr/index.md
[66]: ../../adr/glossary.md#world-map
[67]: ../../adr/glossary.md#track
[68]: ../../adr/glossary.md#file-language
[69]: ../../adr/glossary.md#cell
[70]: ../../adr/glossary.md#lit-cell
[71]: ../../adr/glossary.md#root-file
[72]: ../../adr/glossary.md#unlisted-file
[73]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[74]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

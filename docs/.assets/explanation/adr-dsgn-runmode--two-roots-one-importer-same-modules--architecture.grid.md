# docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md

`Grid minimap: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture`

![Grid minimap of adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture` (architecture lens). The slide supports
[ADR-DSGN-RUNMODE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (172 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 28 lit of 1456 files
- automation × yaml: 2 lit of 98 files
- docs × markdown: 27 lit of 1855 files
- Root files × markdown: 5 lit of 20 files
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 3 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### automation × powershell (28 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/.internal/assets/Import-Catzc.ps1][5]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][6]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][7]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][8]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][9]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 14 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][10]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][11]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][12]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][13]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][14]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][15]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][16]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][17]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][18]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][19]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][20]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][21]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][22]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][23]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][24]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][25]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][26]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][27]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][28]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][29]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][30]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][31]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][32]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][33]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 84 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][34]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 580 (text).

### docs × markdown (27 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][35]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 125 (text).
- [docs/adr/design/run-modes.md][1]: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.
- [docs/adr/index.md][36]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 96 (text).
- [docs/references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md][37]: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 20 (text).
- [docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md][38]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 19 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][39]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line
  34 (text).
- [docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md][40]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 33 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md][41]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 20 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-BaseModule.ps1.md][42]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 29 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][43]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 18 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md][44]: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 36 (text).
- [docs/references/automation/catzc-base-modulesystem/New-Importer.ps1.md][45]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line
  24 (text).
- [docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][46]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 25 (text).
- [docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md][47]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 29 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md][48]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md][49]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 15 (text).
- [docs/references/automation/catzc-base-repository/Assert-SourceTree.ps1.md][50]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 16 (text).
- [docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md][51]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 18 (text).
- [docs/references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md][52]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 14 (text).
- [docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md][53]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 31 (text).
- [docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][54]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 23 (text).
- [docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md][55]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 38 (text).
- [docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md][56]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 16 (text).
- [docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md][57]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 32 (text).
- [docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md][58]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md][59]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 19 (text).
- [docs/references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md][60]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 26 (text).

### Root files × markdown (5 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][61]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][62]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 195 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][63]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 12 (text), line 32 (text),
  line 261 (text) and line 272 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][64]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 93 (text).
- [.unordered/15-10-2026/plan-diagram-wave-9.md][65]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 121 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][66]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 71 (text) and line 96
  (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][61]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [importer.ps1][67]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][61]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][68]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.gitattributes][69]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 6 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][70]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 6 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1`
  line 7 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][71]
- [track][72]
- [file language][73]
- [cell][74]
- [lit cell][75]
- [root file][76]
- [unlisted file][77]
- [automation][78]: a track
- [docs][78]: a track
- [markdown][79]: a file language
- [powershell][79]: a file language
- [yaml][79]: a file language

[1]: ../../adr/design/run-modes.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/.internal/assets/Import-Catzc.ps1
[6]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[7]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[8]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[10]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[11]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[12]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[13]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[14]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[15]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[16]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[17]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[18]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[19]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[22]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[23]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[24]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[25]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[26]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[27]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[28]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[29]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[30]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[31]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[32]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[33]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[35]: ../../adr/design/dora-explains.md
[36]: ../../adr/index.md
[37]: ../../references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md
[38]: ../../references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
[39]: ../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[40]: ../../references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
[41]: ../../references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md
[42]: ../../references/automation/catzc-base-modulesystem/Get-BaseModule.ps1.md
[43]: ../../references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[44]: ../../references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
[45]: ../../references/automation/catzc-base-modulesystem/New-Importer.ps1.md
[46]: ../../references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[47]: ../../references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
[48]: ../../references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md
[49]: ../../references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
[50]: ../../references/automation/catzc-base-repository/Assert-SourceTree.ps1.md
[51]: ../../references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
[52]: ../../references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md
[53]: ../../references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
[54]: ../../references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[55]: ../../references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
[56]: ../../references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md
[57]: ../../references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
[58]: ../../references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
[59]: ../../references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
[60]: ../../references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md
[61]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[62]: ../../../.unordered/15-10-2026/plan-adr-consistency.md
[63]: ../../../.unordered/15-10-2026/plan-built-bundle.md
[64]: ../../../.unordered/15-10-2026/plan-concern-axis.md
[65]: ../../../.unordered/15-10-2026/plan-diagram-wave-9.md
[66]: ../../../.unordered/15-10-2026/plan-explanation-drift.md
[67]: ../../../importer.ps1
[68]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[69]: ../../../.gitattributes
[70]: ../../../.gitignore
[71]: ../../adr/glossary.md#world-map
[72]: ../../adr/glossary.md#track
[73]: ../../adr/glossary.md#file-language
[74]: ../../adr/glossary.md#cell
[75]: ../../adr/glossary.md#lit-cell
[76]: ../../adr/glossary.md#root-file
[77]: ../../adr/glossary.md#unlisted-file
[78]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[79]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md

`Grid minimap: adr-auto-bundle--one-commit-one-immutable-package--meta`

![Grid minimap of adr-auto-bundle--one-commit-one-immutable-package--meta](adr-auto-bundle--one-commit-one-immutable-package--meta.grid.png)

The grid minimap of the slide `adr-auto-bundle--one-commit-one-immutable-package--meta` (meta lens). The slide supports [ADR-AUTO-BUNDLE][1]
and [ADR-DSGN-RUNMODE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 2 lit of 229 files
- automation × powershell: 36 lit of 1443 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 5 lit of 744 files
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.github/workflows/ci-automation.yml][6]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48 (body comment) (a passing mention
  only).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][8]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 2 (header).

### automation × powershell (36 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/.internal/assets/Import-Catzc.ps1][9]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][10]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (text).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][11]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][13]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][14]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header) and line 54
  (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][16]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][17]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][18]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][19]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][20]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][21]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 29 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][22]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][23]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][24]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][25]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][26]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 28
  (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][27]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][28]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][29]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][30]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][31]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][32]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][33]: selected by [ADR-DSGN-RUNMODE][2]: the file cites
  it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][34]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][35]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][36]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][37]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][38]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][39]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 30
  (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][40]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][41]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][42]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][43]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][44]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 18 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][45]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 161 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][46]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][47]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 596 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][48]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 421 (text).
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][49]: selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 125 (text).
- [docs/adr/design/run-modes.md][2]: selected by [ADR-DSGN-RUNMODE][2]: the ADR's own file.
- [docs/adr/index.md][50]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 149 (text); selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 94 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][51]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [importer.ps1][52]: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by [ADR-DSGN-RUNMODE][2]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][51]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][53]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.gitattributes][54]: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][55]: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1`
  line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][56]
- [track][57]
- [file language][58]
- [cell][59]
- [lit cell][60]
- [root file][61]
- [unlisted file][62]
- [.github][63]: a track
- [automation][63]: a track
- [docs][63]: a track
- [csharp][64]: a file language
- [markdown][64]: a file language
- [powershell][64]: a file language
- [yaml][64]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/run-modes.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.github/workflows/ci-automation.yml
[7]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[8]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[9]: ../../../automation/.internal/assets/Import-Catzc.ps1
[10]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[11]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[12]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[13]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[14]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[15]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[16]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[17]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[18]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[19]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[20]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[21]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[22]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[23]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[24]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[25]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[26]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[27]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[28]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[29]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[30]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[31]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[32]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[33]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[34]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[35]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[36]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[37]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[38]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[39]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[40]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[41]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[42]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[43]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[44]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[45]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[46]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[47]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[48]: ../../adr/automation/dora-explains.md
[49]: ../../adr/design/dora-explains.md
[50]: ../../adr/index.md
[51]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[52]: ../../../importer.ps1
[53]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[54]: ../../../.gitattributes
[55]: ../../../.gitignore
[56]: ../../adr/glossary.md#world-map
[57]: ../../adr/glossary.md#track
[58]: ../../adr/glossary.md#file-language
[59]: ../../adr/glossary.md#cell
[60]: ../../adr/glossary.md#lit-cell
[61]: ../../adr/glossary.md#root-file
[62]: ../../adr/glossary.md#unlisted-file
[63]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[64]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

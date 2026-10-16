# docs/.assets/explanation/tree/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md

`Tree minimap: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture`

![Tree minimap of adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture` (architecture lens). The slide supports
[ADR-DSGN-RUNMODE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 49 files in 17 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- ModuleSystem (automation/Catzc.Base.ModuleSystem): 8 lit files
- .unordered: 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- Root files: 3 lit files
- Repository (automation/Catzc.Base.Repository): 3 lit files
- .claude: 2 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Vendor (automation/Catzc.Base.Vendor): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][2], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 23 (header) and line 50 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][3], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (header) and line 31 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][4], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 20 (header) and line 40 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][5], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 22 (header) and line 33 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][6], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 21 (header) and line 48 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][7], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 22 (header) and line 38 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][8], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 22 (header) and line 39 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][9], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 22 (header) and line 43 (header).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][10], in the cell .unordered × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 195 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][11], in the cell .unordered × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 12 (text), line 32 (text), line 261 (text) and line 272 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][12], in the cell .unordered × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 93 (text).
- [.unordered/15-10-2026/plan-diagram-wave-9.md][13], in the cell .unordered × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 124 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][14], in the cell .unordered × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 71 (text) and line 96 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 21 (header) and line 45 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][16], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][17], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 590 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][18], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][19], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (header) and line 23 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][20], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 22 (header) and line 36 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][21], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 21 (header) and line 50 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][22], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][23], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 20 (header) and line 44 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][24], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 21 (header) and line 43 (header).

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md][25], in the cell docs × markdown: selected
  by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text) and line 29 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md][26], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text), line 26 (text) and line 29 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][27], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 34 (text).
- [docs/references/automation/internal/Catzc.Internal.Importer.psm1.md][28], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 17 (text) and line 222 (text).
- [docs/references/automation/internal/Catzc.Internal.TestKit.psm1.md][29], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 16 (text) and line 76 (text).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][30], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 27 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line
  21 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 30 (header),
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 19 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line
  24 (header).
- [.gitignore][31], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 27 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line
  21 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 30 (header),
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 19 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line
  24 (header).
- [importer.ps1][32], in the cell Root files × powershell: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 18 (header),
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 17 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 21 (text).

### Repository (automation/Catzc.Base.Repository, 3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][33], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][34], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][35], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 19 (header) and line 24 (header).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][36], in the cell .claude × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 401 (text), line 458 (text) and line 796 (text).
- [.claude/plans/plan-lazy-types-load.md][37], in the cell .claude × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line
  139 (text).

### .internal (automation/.internal, 2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][38], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 18 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][39], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 17 (header) and line 21 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][40], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 97 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][41], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 21 (header) and line 32 (header).

### Vendor (automation/Catzc.Base.Vendor, 2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][42], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 20 (header) and line 31 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][43], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 19 (header) and line 36 (header).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][44], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 162
  (text).
- [docs/adr/design/run-modes.md][1], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.

### ConfigExtensions (automation/Catzc.Base.ConfigExtensions, 1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][45], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 21 (header) and line 32 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][46], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 24 (header) and line 53 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][47], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 22 (header) and line 47 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][48], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 109 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][49], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-RUNMODE][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 18 (header),
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 17 (header),
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 21 (text),
  `automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1` line 21 (header),
  `automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1` line 32 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 97
  (text), `automation/Catzc.Base.Docs/private/Get-CatsModules.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/private/Get-CatsModules.ps1` line 32 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 24
  (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 53 (header), `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1`
  line 23 (header), `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line 50 (header),
  `automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1` line 19 (header),
  `automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1` line 31 (header), `automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1`
  line 20 (header), `automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1` line 40 (header),
  `automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1` line 33 (header),
  `automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1` line 21 (header),
  `automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1` line 48 (header),
  `automation/Catzc.Base.ModuleSystem/New-Importer.ps1` line 22 (header), `automation/Catzc.Base.ModuleSystem/New-Importer.ps1` line 38
  (header), `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 39 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1` line 22 (header),
  `automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1` line 43 (header),
  `automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1` line 21 (header), `automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1`
  line 45 (header), `automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1` line 28 (header), `automation/Catzc.Base.QualityGates/configs/terminology.yml`
  line 590 (text), `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 20 (header), `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line
  27 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 21 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 30 (header), `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line
  19 (header), `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 24 (header),
  `automation/Catzc.Base.RootConfig/Build-RootConfig.ps1` line 22 (header), `automation/Catzc.Base.RootConfig/Build-RootConfig.ps1` line 47
  (header), `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 22 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 36 (header),
  `automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1` line 21 (header),
  `automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1` line 50 (header),
  `automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1` line 20 (header),
  `automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1` line 28 (header),
  `automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1` line 20 (header),
  `automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1` line 44 (header),
  `automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1` line 21 (header),
  `automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1` line 43 (header), `automation/Catzc.Base.Vendor/Install-VendorModule.ps1`
  line 20 (header), `automation/Catzc.Base.Vendor/Install-VendorModule.ps1` line 31 (header),
  `automation/Catzc.Base.Vendor/Remove-VendorModules.ps1` line 19 (header) and `automation/Catzc.Base.Vendor/Remove-VendorModules.ps1` line
  36 (header).

## Keywords

- [world map][50]
- [track][51]
- [file language][52]
- [cell][53]
- [lit cell][54]
- [root file][55]
- [unlisted file][56]
- [.claude][57]: a track
- [.unordered][57]: a track
- [automation][57]: a track
- [docs][57]: a track
- [pipelines][57]: a track
- [markdown][58]: a file language
- [pipeline-yaml][58]: a file language
- [powershell][58]: a file language
- [yaml][58]: a file language

[1]: ../../../adr/design/run-modes.md
[2]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[3]: ../../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[4]: ../../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[5]: ../../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[6]: ../../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[7]: ../../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[8]: ../../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[9]: ../../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[10]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[11]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[12]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[13]: ../../../../.unordered/15-10-2026/plan-diagram-wave-9.md
[14]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[15]: ../../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[16]: ../../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[17]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[18]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[19]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[20]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[21]: ../../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[22]: ../../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[23]: ../../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[24]: ../../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[25]: ../../../references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md
[26]: ../../../references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md
[27]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[28]: ../../../references/automation/internal/Catzc.Internal.Importer.psm1.md
[29]: ../../../references/automation/internal/Catzc.Internal.TestKit.psm1.md
[30]: ../../../../.gitattributes
[31]: ../../../../.gitignore
[32]: ../../../../importer.ps1
[33]: ../../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[34]: ../../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[35]: ../../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[36]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[37]: ../../../../.claude/plans/plan-lazy-types-load.md
[38]: ../../../../automation/.internal/assets/Import-Catzc.ps1
[39]: ../../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[40]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[41]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[42]: ../../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[43]: ../../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[44]: ../../../adr/design/dora-explains.md
[45]: ../../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[46]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[47]: ../../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[48]: ../../../adr/index.md
[49]: ../../../../pipelines/ci-automation.yaml
[50]: ../../../adr/glossary.md#world-map
[51]: ../../../adr/glossary.md#track
[52]: ../../../adr/glossary.md#file-language
[53]: ../../../adr/glossary.md#cell
[54]: ../../../adr/glossary.md#lit-cell
[55]: ../../../adr/glossary.md#root-file
[56]: ../../../adr/glossary.md#unlisted-file
[57]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

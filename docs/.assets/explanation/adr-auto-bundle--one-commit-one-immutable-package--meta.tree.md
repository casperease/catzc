# docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md

`Tree minimap: adr-auto-bundle--one-commit-one-immutable-package--meta`

![Tree minimap of adr-auto-bundle--one-commit-one-immutable-package--meta](adr-auto-bundle--one-commit-one-immutable-package--meta.tree.png)

The tree minimap of the slide `adr-auto-bundle--one-commit-one-immutable-package--meta` (meta lens). The slide supports [ADR-AUTO-BUNDLE][1]
and [ADR-DSGN-RUNMODE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 95 files in 17 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 40 lit files
- Exporter (automation/Catzc.Base.Exporter): 10 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- Root files: 3 lit files
- Repository (automation/Catzc.Base.Repository): 3 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Vendor (automation/Catzc.Base.Vendor): 2 lit files
- .github: 1 lit file
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (40 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][3], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][4], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][5], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][6], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/index.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][8], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][9], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/consumer-overlay.md][10], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][11], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][17], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][19], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][21], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][25], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][26], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][27], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][28], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][29], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][30], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][31], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][32], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][33], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][34], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][35], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][36], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][37], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][38], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][39], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][40], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][41], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### Exporter (10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][42], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][43], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][44], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][45], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][46], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][47], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][48], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][49], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][50], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][51], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][52], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][53], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][54], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][2], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][55], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][56], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][57], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][58], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][59], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### ModuleSystem (8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][60], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][61], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][62], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][63], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][64], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][65], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][66], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][67], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 21 (header).

### QualityGates (5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][68], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][69], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][70], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 596 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][71], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][72], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 6 (text).

### TypesSystem (5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][73], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][74], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][75], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][76], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][77], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 22 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][78], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][79], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [importer.ps1][80], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1
  (text).

### Repository (3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][81], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][82], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][83], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 6 (header).

### .internal (2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][84], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][85], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 1 (text).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][86], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][87], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).

### Vendor (2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][88], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][89], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 18 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][90], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### ConfigExtensions (1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][91], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).

### Contracts (1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][92], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).

### Globs (1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][93], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the file
  cites it at line 29 (header).

### RootConfig (1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][94], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 24 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][95], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 149 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 94 (text).

## Keywords

- [world map][96]
- [track][97]
- [file language][98]
- [cell][99]
- [lit cell][100]
- [root file][101]
- [unlisted file][102]
- [.github][103]: a track
- [automation][103]: a track
- [docs][103]: a track
- [csharp][104]: a file language
- [markdown][104]: a file language
- [powershell][104]: a file language
- [yaml][104]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/run-modes.md
[3]: ../../adr/automation/BCL/index.md
[4]: ../../adr/automation/BCL/native-csharp-types.md
[5]: ../../adr/automation/avoid-deep-nesting.md
[6]: ../../adr/automation/bash/bash-test-artifacts.md
[7]: ../../adr/automation/bash/index.md
[8]: ../../adr/automation/caching.md
[9]: ../../adr/automation/console-output-matters.md
[10]: ../../adr/automation/consumer-overlay.md
[11]: ../../adr/automation/controlling-module-dependencies.md
[12]: ../../adr/automation/controlling-systemwide-deps.md
[13]: ../../adr/automation/cross-platform.md
[14]: ../../adr/automation/devbox-pipeline-parity.md
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
[30]: ../../adr/automation/python/index.md
[31]: ../../adr/automation/python/python-test-artifacts.md
[32]: ../../adr/automation/retry-as-last-resort.md
[33]: ../../adr/automation/sensible-defaults.md
[34]: ../../adr/automation/single-responsibility-functions.md
[35]: ../../adr/automation/spell-out-names.md
[36]: ../../adr/automation/test-automation.md
[37]: ../../adr/automation/tool-removal-lifecycle.md
[38]: ../../adr/automation/tracked-files-from-the-index.md
[39]: ../../adr/automation/use-proper-package-managers.md
[40]: ../../adr/automation/uv-python-handler.md
[41]: ../../adr/automation/zero-ceremony-poka-yoke.md
[42]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[43]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[44]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[45]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[46]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[47]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[48]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[49]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[50]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[51]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[52]: ../../adr/design/commit-lifecycle.md
[53]: ../../adr/design/dora-explains.md
[54]: ../../adr/design/module-aspects.md
[55]: ../../adr/design/self-service.md
[56]: ../../adr/design/server-remote-integration.md
[57]: ../../adr/design/thin-platforms.md
[58]: ../../adr/design/tracks.md
[59]: ../../adr/design/visual-design.md
[60]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[61]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[62]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[63]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[64]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[65]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[66]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[67]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[68]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[69]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[70]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[71]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[72]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[73]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[74]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[75]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[76]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[77]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[78]: ../../../.gitattributes
[79]: ../../../.gitignore
[80]: ../../../importer.ps1
[81]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[82]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[83]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[84]: ../../../automation/.internal/assets/Import-Catzc.ps1
[85]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[86]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[87]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[88]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[89]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[90]: ../../../.github/workflows/ci-automation.yml
[91]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[92]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[93]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[94]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[95]: ../../adr/index.md
[96]: ../../adr/glossary.md#world-map
[97]: ../../adr/glossary.md#track
[98]: ../../adr/glossary.md#file-language
[99]: ../../adr/glossary.md#cell
[100]: ../../adr/glossary.md#lit-cell
[101]: ../../adr/glossary.md#root-file
[102]: ../../adr/glossary.md#unlisted-file
[103]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[104]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

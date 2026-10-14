# docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md

`Tree minimap: adr-auto-bundle--one-commit-one-immutable-package--meta`

![Tree minimap of adr-auto-bundle--one-commit-one-immutable-package--meta](adr-auto-bundle--one-commit-one-immutable-package--meta.tree.png)

The tree minimap of the slide `adr-auto-bundle--one-commit-one-immutable-package--meta` (meta lens). The slide supports [ADR-AUTO-BUNDLE][1]
and [ADR-DSGN-RUNMODE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 109 files in 18 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 39 lit files
- docs (docs/ outside docs/adr/): 15 lit files
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

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][3], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][4], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][5], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][6], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][8], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][9], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][10], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][11], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][17], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][19], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][21], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][25], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][26], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][27], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/repository/protected-globs.md][28], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][29], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][30], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][31], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][32], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][33], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][34], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][35], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][36], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][37], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][38], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][39], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][40], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### docs (15 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/automation/build-then-place-with-one-command.md][41], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][42], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][43], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][44], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][45], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 47
  (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][46], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][47], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it
  at line 15 (text), line 50 (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][48], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 41 (text), line 51 (text), line 66 (text), line 69 (text) and line 73 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][49], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][50], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 16 (text), line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text)
  and line 61 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 16 (text), line 42 (text), line 57 (text), line 63 (text)
  and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][51], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the file cites
  it at line 17 (text), line 60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][52], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][53], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 17 (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][54], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 14 (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][55], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line
  61 (text).

### Exporter (10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][56], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][57], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][58], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][59], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][60], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][61], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][62], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][63], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][64], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][65], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][66], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][67], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][68], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][2], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][69], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][70], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][71], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][72], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][73], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### ModuleSystem (8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][74], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][75], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][76], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][77], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][78], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][79], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][80], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][81], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 21 (header).

### QualityGates (5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][82], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][83], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][84], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 596 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][85], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 6 (text).

### TypesSystem (5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][87], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][88], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][89], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][90], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][91], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 22 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][92], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][93], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [importer.ps1][94], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1
  (text).

### Repository (3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][95], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][96], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][97], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 6 (header).

### .internal (2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][98], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][99], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 1 (text).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][100], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 162 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][101], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).

### Vendor (2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][102], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][103], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 18 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][104], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### ConfigExtensions (1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][105], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).

### Contracts (1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][106], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).

### Globs (1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][107], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the file
  cites it at line 29 (header).

### RootConfig (1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][108], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 24 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][109], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 94 (text).

## Keywords

- [world map][110]
- [track][111]
- [file language][112]
- [cell][113]
- [lit cell][114]
- [root file][115]
- [unlisted file][116]
- [.github][117]: a track
- [automation][117]: a track
- [docs][117]: a track
- [csharp][118]: a file language
- [markdown][118]: a file language
- [powershell][118]: a file language
- [yaml][118]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/run-modes.md
[3]: ../../adr/automation/BCL/index.md
[4]: ../../adr/automation/BCL/native-csharp-types.md
[5]: ../../adr/automation/avoid-deep-nesting.md
[6]: ../../adr/automation/bash/bash-test-artifacts.md
[7]: ../../adr/automation/caching.md
[8]: ../../adr/automation/console-output-matters.md
[9]: ../../adr/automation/controlling-module-dependencies.md
[10]: ../../adr/automation/controlling-systemwide-deps.md
[11]: ../../adr/automation/cross-platform.md
[12]: ../../adr/automation/devbox-pipeline-parity.md
[13]: ../../adr/automation/dora-explains.md
[14]: ../../adr/automation/dry-run.md
[15]: ../../adr/automation/effective-in-enterprises.md
[16]: ../../adr/automation/environment-variables.md
[17]: ../../adr/automation/execution-engines.md
[18]: ../../adr/automation/fail-fast-with-asserts.md
[19]: ../../adr/automation/go/index.md
[20]: ../../adr/automation/go/go-test-artifacts.md
[21]: ../../adr/automation/idempotent-state-functions.md
[22]: ../../adr/automation/internal-asset-dependencies.md
[23]: ../../adr/automation/log-before-invoke.md
[24]: ../../adr/automation/managed-guids.md
[25]: ../../adr/automation/never-depend-on-pwd.md
[26]: ../../adr/automation/open-closed-architecture.md
[27]: ../../adr/automation/path-representation.md
[28]: ../../adr/repository/protected-globs.md
[29]: ../../adr/automation/python/index.md
[30]: ../../adr/automation/python/python-test-artifacts.md
[31]: ../../adr/automation/retry-as-last-resort.md
[32]: ../../adr/automation/sensible-defaults.md
[33]: ../../adr/automation/single-responsibility-functions.md
[34]: ../../adr/automation/spell-out-names.md
[35]: ../../adr/automation/test-automation.md
[36]: ../../adr/automation/tool-removal-lifecycle.md
[37]: ../../adr/automation/tracked-files-from-the-index.md
[38]: ../../adr/automation/use-proper-package-managers.md
[39]: ../../adr/automation/uv-python-handler.md
[40]: ../../adr/automation/zero-ceremony-poka-yoke.md
[41]: ../../explanation/automation/build-then-place-with-one-command.md
[42]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[43]: ../../explanation/automation/dot-source-one-entry-script.md
[44]: ../../explanation/automation/every-code-root-is-a-copy.md
[45]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[46]: ../../explanation/automation/invoke-importer-in-code-order.md
[47]: ../../explanation/automation/one-commit-one-immutable-package.md
[48]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[49]: ../../explanation/automation/two-entries-feed-one-importer.md
[50]: ../../explanation/automation/what-gates-each-bundle-stage.md
[51]: ../../explanation/design/one-entry-script-per-mode.md
[52]: ../../explanation/design/shims-set-roots-mode-read-back.md
[53]: ../../explanation/design/two-roots-one-importer-same-modules.md
[54]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[55]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[56]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[57]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[58]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[59]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[60]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[61]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[62]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[63]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[64]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[65]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[66]: ../../adr/design/commit-lifecycle.md
[67]: ../../adr/design/dora-explains.md
[68]: ../../adr/design/module-aspects.md
[69]: ../../adr/design/self-service.md
[70]: ../../adr/design/server-remote-integration.md
[71]: ../../adr/design/thin-platforms.md
[72]: ../../adr/design/tracks.md
[73]: ../../adr/design/visual-design.md
[74]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[75]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[76]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[77]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[78]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[79]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[80]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[81]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[82]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[83]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[84]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[85]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[86]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[87]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[88]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[89]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[90]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[91]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[92]: ../../../.gitattributes
[93]: ../../../.gitignore
[94]: ../../../importer.ps1
[95]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[96]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[97]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[98]: ../../../automation/.internal/assets/Import-Catzc.ps1
[99]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[100]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[101]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[102]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[103]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[104]: ../../../.github/workflows/ci-automation.yml
[105]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[106]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[107]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[108]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[109]: ../../adr/index.md
[110]: ../../adr/glossary.md#world-map
[111]: ../../adr/glossary.md#track
[112]: ../../adr/glossary.md#file-language
[113]: ../../adr/glossary.md#cell
[114]: ../../adr/glossary.md#lit-cell
[115]: ../../adr/glossary.md#root-file
[116]: ../../adr/glossary.md#unlisted-file
[117]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[118]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

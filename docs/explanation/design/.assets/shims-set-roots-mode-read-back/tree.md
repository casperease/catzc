---
catzc:
  immutable:
    with_body_sha: "5590c5da532e"
    repo_status: locked
    path: docs/explanation/design/.assets/shims-set-roots-mode-read-back/tree.md
    source: docs/explanation/design/.assets/shims-set-roots-mode-read-back/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it: the tree minimap

```text
Which files cite ADR-DSGN-RUNMODE: every file of the world map is a tile, grouped by top-level folder.
44 files lit in 9 groups.
```

![The tree minimap of Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it](tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Each entry script sets the code root, and Get-CatzcRunMode reads
the mode back from it][45], which explains [ADR-DSGN-RUNMODE][1]. It lights every file that cites those codes, grouped by folder, so it
shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 44 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 30 lit files
- .claude: 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 2 lit files
- Root files: 1 lit file
- pipelines: 1 lit file
- .internal (pwsh/.internal): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 30 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][2], in the cell docs ×
  markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 53 (text).
- [docs/references/pwsh/catzc-base-configextensions/Test-ConfigValidators.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md][4], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][5], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 31 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][6], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 38 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 36 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-ModuleFunction.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-modulesystem/New-Importer.ps1.md][10], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 105 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-BuildArtifact.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-CatzcBuild.ps1.md][15], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md][18], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md][20], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Build-RootConfig.ps1.md][21], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 31 (text).
- [docs/references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md][26], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-vendor/Remove-VendorModules.ps1.md][27], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 25 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][28], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][29], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 193 (text).
- [docs/references/pwsh/internal/Catzc.Internal.TestKit.psm1.md][30], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 58 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][31], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 14 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][32], in the cell .claude × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 56 (text) and line 102 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][33], in the cell .claude × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 133 (text).
- [.claude/plans/task-layers-classification-flip.md][34], in the cell .claude × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 22 (text), line 31 (text), line 31 (text) and line 31 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][35], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 312 (text).
- [docs/adr/index.md][36], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 114 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][37], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 123
  (text).
- [docs/adr/design/run-modes.md][1], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][38], in the cell pwsh × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 80
  (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][39], in the cell pwsh × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 622
  (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][40], in the cell pwsh × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][41], in the cell pwsh × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][42], in the cell Root files × powershell: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `pwsh/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][43], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-RUNMODE][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 80 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 622 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` line 1 (text) and
  `pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1` line 1 (text).

### .internal (pwsh/.internal, 1 lit file)

The group holds the files of pwsh/.internal; each sits in its world-map cell and is lit by:

- [pwsh/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][44], in the cell pwsh × powershell: selected by [ADR-DSGN-RUNMODE][1]: the file
  cites it at line 1 (text).

## Keywords

- [world map][46]
- [track][47]
- [file language][48]
- [cell][49]
- [lit cell][50]
- [root file][51]
- [.claude][52]: a track
- [docs][52]: a track
- [pipelines][52]: a track
- [pwsh][52]: a track
- [markdown][53]: a file language
- [pipeline-yaml][53]: a file language
- [powershell][53]: a file language
- [yaml][53]: a file language

[1]: ../../../../adr/design/run-modes.md
[2]: ../../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[3]: ../../../../references/pwsh/catzc-base-configextensions/Test-ConfigValidators.ps1.md
[4]: ../../../../references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md
[5]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[6]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[7]: ../../../../references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[8]: ../../../../references/pwsh/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
[9]: ../../../../references/pwsh/catzc-base-modulesystem/Get-ModuleFunction.ps1.md
[10]: ../../../../references/pwsh/catzc-base-modulesystem/New-Importer.ps1.md
[11]: ../../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[12]: ../../../../references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
[13]: ../../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[14]: ../../../../references/pwsh/catzc-base-qualitygates/Test-BuildArtifact.ps1.md
[15]: ../../../../references/pwsh/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
[16]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md
[17]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md
[18]: ../../../../references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md
[19]: ../../../../references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
[20]: ../../../../references/pwsh/catzc-base-repository/Get-CatzcRunMode.ps1.md
[21]: ../../../../references/pwsh/catzc-base-rootconfig/Build-RootConfig.ps1.md
[22]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[23]: ../../../../references/pwsh/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
[24]: ../../../../references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
[25]: ../../../../references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
[26]: ../../../../references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md
[27]: ../../../../references/pwsh/catzc-base-vendor/Remove-VendorModules.ps1.md
[28]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[29]: ../../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[30]: ../../../../references/pwsh/internal/Catzc.Internal.TestKit.psm1.md
[31]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[32]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[33]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[34]: ../../../../../.claude/plans/task-layers-classification-flip.md
[35]: ../../../../adr/glossary.md
[36]: ../../../../adr/index.md
[37]: ../../../../adr/design/dora-explains.md
[38]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[39]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[40]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[41]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[42]: ../../../../../importer.ps1
[43]: ../../../../../pipelines/ci-automation.yaml
[44]: ../../../../../pwsh/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[45]: ../../shims-set-roots-mode-read-back.md
[46]: ../../../../adr/glossary.md#world-map
[47]: ../../../../adr/glossary.md#track
[48]: ../../../../adr/glossary.md#file-language
[49]: ../../../../adr/glossary.md#cell
[50]: ../../../../adr/glossary.md#lit-cell
[51]: ../../../../adr/glossary.md#root-file
[52]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[53]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

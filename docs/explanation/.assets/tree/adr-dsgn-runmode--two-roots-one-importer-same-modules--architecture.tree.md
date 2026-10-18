---
catzc:
  immutable:
    with_body_sha: af2623ad5cbe
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
    source: docs/explanation/.assets/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two code roots feed one importer, which loads the same modules: the tree minimap

```text
Which files cite ADR-DSGN-RUNMODE: every file of the world map is a tile, grouped by top-level folder.
43 files lit in 9 groups.
```

![The tree minimap of Two code roots feed one importer, which loads the same modules](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Two code roots feed one importer, which loads the same modules][44],
which explains [ADR-DSGN-RUNMODE][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the
decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 43 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 30 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Root files: 1 lit file
- .claude: 1 lit file
- .internal (automation/.internal): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 30 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][2], in the cell docs ×
  markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 53 (text).
- [docs/references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][5], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 38 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 36 (text).
- [docs/references/automation/catzc-base-modulesystem/New-Importer.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 23 (text).
- [docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][13], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 105 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md][16], in the cell docs × markdown: selected
  by [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text) and line 11 (text).
- [docs/references/automation/catzc-base-repository/Assert-SourceTree.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md][21], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 34 (text).
- [docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 27 (text).
- [docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 25 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][28], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 15 (text).
- [docs/references/automation/internal/Catzc.Internal.Importer.psm1.md][29], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 193 (text).
- [docs/references/automation/internal/Catzc.Internal.TestKit.psm1.md][30], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 58 (text).
- [docs/references/automation/internal/assets/Import-Catzc.ps1.md][31], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 14 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][32], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 575 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][33], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][35], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 80 (text).
- [automation/Catzc.Base.Docs/configs/glossary.yml][36], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][1]: the file cites it
  at line 611 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][37], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 312 (text).
- [docs/adr/index.md][38], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 114 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][39], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 123
  (text).
- [docs/adr/design/run-modes.md][1], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][40], in the cell Root files × powershell: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][41], in the cell .claude × markdown: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 135 (text), line 495 (text), line 557 (text) and line 916 (text).

### .internal (automation/.internal, 1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][42], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 1 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][43], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-RUNMODE][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1
  (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 80 (text), `automation/Catzc.Base.Docs/configs/glossary.yml` line 611 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 575 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` line 1 (text) and
  `automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1` line 1 (text).

## Keywords

- [world map][45]
- [track][46]
- [file language][47]
- [cell][48]
- [lit cell][49]
- [root file][50]
- [.claude][51]: a track
- [automation][51]: a track
- [docs][51]: a track
- [pipelines][51]: a track
- [markdown][52]: a file language
- [pipeline-yaml][52]: a file language
- [powershell][52]: a file language
- [yaml][52]: a file language

Terms the cited ADRs define:

- [run mode][53], defined by [ADR-DSGN-RUNMODE#1][54]

[1]: ../../../adr/design/run-modes.md
[2]: ../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[3]: ../../../references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md
[4]: ../../../references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
[5]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[6]: ../../../references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
[7]: ../../../references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md
[8]: ../../../references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[9]: ../../../references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
[10]: ../../../references/automation/catzc-base-modulesystem/New-Importer.ps1.md
[11]: ../../../references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[12]: ../../../references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
[13]: ../../../references/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[14]: ../../../references/automation/catzc-base-qualitygates/Test-BuildArtifact.ps1.md
[15]: ../../../references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
[16]: ../../../references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md
[17]: ../../../references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md
[18]: ../../../references/automation/catzc-base-repository/Assert-SourceTree.ps1.md
[19]: ../../../references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
[20]: ../../../references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md
[21]: ../../../references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
[22]: ../../../references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[23]: ../../../references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
[24]: ../../../references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
[25]: ../../../references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
[26]: ../../../references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
[27]: ../../../references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md
[28]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[29]: ../../../references/automation/internal/Catzc.Internal.Importer.psm1.md
[30]: ../../../references/automation/internal/Catzc.Internal.TestKit.psm1.md
[31]: ../../../references/automation/internal/assets/Import-Catzc.ps1.md
[32]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[33]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[34]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[35]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[36]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[37]: ../../../adr/glossary.md
[38]: ../../../adr/index.md
[39]: ../../../adr/design/dora-explains.md
[40]: ../../../../importer.ps1
[41]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[42]: ../../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[43]: ../../../../pipelines/ci-automation.yaml
[44]: ../../design/two-roots-one-importer-same-modules.md
[45]: ../../../adr/glossary.md#world-map
[46]: ../../../adr/glossary.md#track
[47]: ../../../adr/glossary.md#file-language
[48]: ../../../adr/glossary.md#cell
[49]: ../../../adr/glossary.md#lit-cell
[50]: ../../../adr/glossary.md#root-file
[51]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[52]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[53]: ../../../adr/glossary.md#run-mode
[54]: ../../../adr/design/run-modes.md#rule-adr-dsgn-runmode1

---
catzc:
  immutable:
    with_body_sha: "8f71ff34d3d8"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
    source: docs/explanation/.assets/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every stage of the bundle has a rule, and two gates check it: the tree minimap

```text
Which files cite ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST: every file of the world map is a tile, grouped by top-level folder.
31 files lit in 13 groups.
```

![The tree minimap of Every stage of the bundle has a rule, and two gates check it](adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check it][32],
which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 31 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Exporter (automation/Catzc.Base.Exporter): 9 lit files
- docs (docs/ outside docs/adr/): 4 lit files
- .claude: 3 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/pwsh (docs/adr/pwsh): 2 lit files
- Root files: 1 lit file
- .github: 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Overlay (automation/Catzc.Base.Overlay): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Exporter (automation/Catzc.Base.Exporter, 9 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][3], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 22 (header) and line 29 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][4], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 22 (header), line 27 (header) and line 73 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 21 (header) and line 29 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][7], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][8], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][9], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][10], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][11], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 21 (text).

### docs (docs/ outside docs/adr/, 4 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-exporter/configs/exporter.yml.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 33 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterBundle.cs.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md][14], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 31 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 34 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][16], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 24 (text), line 524 (text), line 586 (text) and line 947 (text).
- [.claude/plans/plan-module-kinds-tracks.md][17], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 355 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 37 (text), line 185 (text), line 294 (text), line 352
  (text), line 368 (text) and line 410 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][18], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 39 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 40 (text).

### .internal (automation/.internal, 2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][19], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 20 (header).
- [automation/.internal/assets/Import-ModuleFiles.ps1][20], in the cell automation × powershell: selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 19 (header).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][21], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 191 (text).
- [automation/Catzc.Base.Docs/configs/glossary.yml][22], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 520 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 595 (text).
- [docs/adr/index.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 201 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][25], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 507
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### adr/pwsh (docs/adr/pwsh, 2 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/dora-explains.md][26], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 115
  (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][27], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header); selected by
  [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/assets/Import-ModuleFiles.ps1` line 19 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][28], in the cell github-workflows × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 64 (body comment) (a passing mention only).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][29], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 21 (header) and line 36 (header).

### Overlay (automation/Catzc.Base.Overlay, 1 lit file)

The group holds the files of automation/Catzc.Base.Overlay; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][30], in the cell automation × powershell: selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 22 (header) and line 29 (header).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][31], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1` line 21 (header),
  `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1` line 36 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 161
  (text), `automation/Catzc.Base.Docs/configs/glossary.yml` line 520 (text), `automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1` line 22
  (header), `automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1` line 29 (header), `automation/Catzc.Base.Exporter/Build-Modules.ps1`
  line 22 (header), `automation/Catzc.Base.Exporter/Build-Modules.ps1` line 27 (header), `automation/Catzc.Base.Exporter/Build-Modules.ps1`
  line 73 (text), `automation/Catzc.Base.Exporter/Export-Catzc.ps1` line 20 (header), `automation/Catzc.Base.Exporter/Export-Catzc.ps1` line
  26 (header), `automation/Catzc.Base.Exporter/Install-Catzc.ps1` line 21 (header), `automation/Catzc.Base.Exporter/Install-Catzc.ps1` line
  29 (header), `automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1` line 20 (header),
  `automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1` line 28 (header),
  `automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1` line 22 (header),
  `automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1` line 28 (header),
  `automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1` line 21 (header),
  `automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1` line 26 (header),
  `automation/Catzc.Base.Exporter/types/ExporterBundle.cs` line 20 (text) and `automation/Catzc.Base.Exporter/types/ExporterConfig.cs` line
  21 (text); selected by [ADR-PWSH-MANIFEST][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/.internal/assets/Import-ModuleFiles.ps1` line 19 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 191 (text),
  `automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1` line 22 (header) and
  `automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1` line 29 (header).

## Keywords

- [world map][33]
- [track][34]
- [file language][35]
- [cell][36]
- [lit cell][37]
- [root file][38]
- [.claude][39]: a track
- [automation][39]: a track
- [docs][39]: a track
- [github-workflows][39]: a track
- [pipelines][39]: a track
- [csharp][40]: a file language
- [markdown][40]: a file language
- [pipeline-yaml][40]: a file language
- [powershell][40]: a file language
- [yaml][40]: a file language

Terms the cited ADRs define:

- [bundle][41], defined by [ADR-AUTO-BUNDLE#1][42]

[1]: ../../../adr/automation/platform-bundle.md
[2]: ../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[4]: ../../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[5]: ../../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[6]: ../../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[7]: ../../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[8]: ../../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[9]: ../../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[10]: ../../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[11]: ../../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[12]: ../../../references/automation/catzc-base-exporter/configs/exporter.yml.md
[13]: ../../../references/automation/catzc-base-exporter/types/ExporterBundle.cs.md
[14]: ../../../references/automation/catzc-base-exporter/types/ExporterConfig.cs.md
[15]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[16]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[17]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[18]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[19]: ../../../../automation/.internal/assets/Import-Catzc.ps1
[20]: ../../../../automation/.internal/assets/Import-ModuleFiles.ps1
[21]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[23]: ../../../adr/glossary.md
[24]: ../../../adr/index.md
[25]: ../../../adr/automation/dora-explains.md
[26]: ../../../adr/pwsh/dora-explains.md
[27]: ../../../../importer.ps1
[28]: ../../../../.github/workflows/ci-automation.yml
[29]: ../../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[30]: ../../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[31]: ../../../../pipelines/ci-automation.yaml
[32]: ../../automation/what-gates-each-bundle-stage.md
[33]: ../../../adr/glossary.md#world-map
[34]: ../../../adr/glossary.md#track
[35]: ../../../adr/glossary.md#file-language
[36]: ../../../adr/glossary.md#cell
[37]: ../../../adr/glossary.md#lit-cell
[38]: ../../../adr/glossary.md#root-file
[39]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[40]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[41]: ../../../adr/glossary.md#bundle
[42]: ../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

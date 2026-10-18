---
catzc:
  immutable:
    with_body_sha: "068661e5412f"
    repo_status: locked
    path: docs/explanation/automation/.assets/what-gates-each-bundle-stage/tree.md
    source: docs/explanation/automation/.assets/what-gates-each-bundle-stage/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every stage of the bundle has a rule, and two gates check it: the tree minimap

```text
Which files cite ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST: every file of the world map is a tile, grouped by top-level folder.
28 files lit in 10 groups.
```

![The tree minimap of Every stage of the bundle has a rule, and two gates check it](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check it][29],
which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 28 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 15 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/pwsh (docs/adr/pwsh): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- Root files: 1 lit file
- .claude: 1 lit file
- pipelines: 1 lit file
- .internal (pwsh/.internal): 1 lit file
- Exporter (pwsh/Catzc.Base.Exporter): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 15 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pipelines/github-workflows/ci-automation.yml.md][3], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 42 (text).
- [docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md][5], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md][6], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md][8], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md][10], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][17], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 15 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 611 (text).
- [docs/adr/index.md][19], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 201 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### adr/pwsh (docs/adr/pwsh, 2 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/dora-explains.md][21], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 61
  (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][22], in the cell pwsh × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 142
  (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 172 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][23], in the cell pwsh × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 506
  (text).

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][24], in the cell Root files × powershell: selected by [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/task-layers-classification-flip.md][25], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 32 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][26], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 142 (text),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 506 (text) and `pwsh/Catzc.Base.Exporter/Build-Modules.ps1` line 2 (text); selected by
  [ADR-PWSH-MANIFEST][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header) and `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 172 (text).

### .internal (pwsh/.internal, 1 lit file)

The group holds the files of pwsh/.internal; each sits in its world-map cell and is lit by:

- [pwsh/.internal/assets/Import-ModuleFiles.ps1][27], in the cell pwsh × powershell: selected by [ADR-PWSH-MANIFEST][2]: the file cites it
  at line 1 (header).

### Exporter (pwsh/Catzc.Base.Exporter, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Exporter/Build-Modules.ps1][28], in the cell pwsh × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 2 (text).

## Keywords

- [world map][30]
- [track][31]
- [file language][32]
- [cell][33]
- [lit cell][34]
- [root file][35]
- [.claude][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [pwsh][36]: a track
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [powershell][37]: a file language
- [yaml][37]: a file language

Terms the cited ADRs define:

- [bundle][38], defined by [ADR-AUTO-BUNDLE#1][39]

[1]: ../../../../adr/automation/platform-bundle.md
[2]: ../../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[4]: ../../../../references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md
[5]: ../../../../references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md
[6]: ../../../../references/pwsh/catzc-base-exporter/Build-Modules.ps1.md
[7]: ../../../../references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md
[8]: ../../../../references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md
[9]: ../../../../references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md
[10]: ../../../../references/pwsh/catzc-base-exporter/configs/exporter.yml.md
[11]: ../../../../references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[12]: ../../../../references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
[13]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
[14]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
[15]: ../../../../references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md
[16]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[17]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[18]: ../../../../adr/glossary.md
[19]: ../../../../adr/index.md
[20]: ../../../../adr/automation/dora-explains.md
[21]: ../../../../adr/pwsh/dora-explains.md
[22]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[23]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[24]: ../../../../../importer.ps1
[25]: ../../../../../.claude/plans/task-layers-classification-flip.md
[26]: ../../../../../pipelines/ci-automation.yaml
[27]: ../../../../../pwsh/.internal/assets/Import-ModuleFiles.ps1
[28]: ../../../../../pwsh/Catzc.Base.Exporter/Build-Modules.ps1
[29]: ../../what-gates-each-bundle-stage.md
[30]: ../../../../adr/glossary.md#world-map
[31]: ../../../../adr/glossary.md#track
[32]: ../../../../adr/glossary.md#file-language
[33]: ../../../../adr/glossary.md#cell
[34]: ../../../../adr/glossary.md#lit-cell
[35]: ../../../../adr/glossary.md#root-file
[36]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[38]: ../../../../adr/glossary.md#bundle
[39]: ../../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

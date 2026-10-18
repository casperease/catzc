---
catzc:
  immutable:
    with_body_sha: f82e0b83103b
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md
    source: docs/explanation/.assets/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two entry scripts feed one importer, and the importer leaves once the load is done: the tree minimap

```text
Which files cite ADR-AUTO-BUNDLE: every file of the world map is a tile, grouped by top-level folder.
27 files lit in 11 groups.
```

![The tree minimap of Two entry scripts feed one importer, and the importer leaves once the load is done](adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Two entry scripts feed one importer, and the importer leaves once
the load is done][28], which explains [ADR-AUTO-BUNDLE][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 27 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Exporter (automation/Catzc.Base.Exporter): 9 lit files
- docs (docs/ outside docs/adr/): 4 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Root files: 1 lit file
- .github: 1 lit file
- .internal (automation/.internal): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Exporter (automation/Catzc.Base.Exporter, 9 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][2], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 22 (header) and line 29 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][3], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 22 (header), line 27 (header) and line 73 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][4], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 21 (header) and line 29 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][7], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][8], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][9], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][10], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 21 (text).

### docs (docs/ outside docs/adr/, 4 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-exporter/configs/exporter.yml.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 33 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterBundle.cs.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 31 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 34 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][15], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 24 (text), line 524 (text), line 586 (text) and line 947 (text).
- [.claude/plans/plan-module-kinds-tracks.md][16], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 355 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][17], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 39 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][18], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text).
- [automation/Catzc.Base.Docs/configs/glossary.yml][19], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 520 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 595 (text).
- [docs/adr/index.md][21], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 507
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][23], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][24], in the cell github-workflows × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 64 (body comment) (a passing mention only).

### .internal (automation/.internal, 1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][25], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 20 (header).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][26], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 21 (header) and line 36 (header).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][27], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing
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
  21 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [root file][34]
- [.claude][35]: a track
- [automation][35]: a track
- [docs][35]: a track
- [github-workflows][35]: a track
- [pipelines][35]: a track
- [csharp][36]: a file language
- [markdown][36]: a file language
- [pipeline-yaml][36]: a file language
- [powershell][36]: a file language
- [yaml][36]: a file language

Terms the cited ADRs define:

- [bundle][37], defined by [ADR-AUTO-BUNDLE#1][38]

[1]: ../../../adr/automation/platform-bundle.md
[2]: ../../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[3]: ../../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[4]: ../../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[5]: ../../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[6]: ../../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[7]: ../../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[8]: ../../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[9]: ../../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[10]: ../../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[11]: ../../../references/automation/catzc-base-exporter/configs/exporter.yml.md
[12]: ../../../references/automation/catzc-base-exporter/types/ExporterBundle.cs.md
[13]: ../../../references/automation/catzc-base-exporter/types/ExporterConfig.cs.md
[14]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[15]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[16]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[17]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[18]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[19]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[20]: ../../../adr/glossary.md
[21]: ../../../adr/index.md
[22]: ../../../adr/automation/dora-explains.md
[23]: ../../../../importer.ps1
[24]: ../../../../.github/workflows/ci-automation.yml
[25]: ../../../../automation/.internal/assets/Import-Catzc.ps1
[26]: ../../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[27]: ../../../../pipelines/ci-automation.yaml
[28]: ../../automation/two-entries-feed-one-importer.md
[29]: ../../../adr/glossary.md#world-map
[30]: ../../../adr/glossary.md#track
[31]: ../../../adr/glossary.md#file-language
[32]: ../../../adr/glossary.md#cell
[33]: ../../../adr/glossary.md#lit-cell
[34]: ../../../adr/glossary.md#root-file
[35]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[36]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[37]: ../../../adr/glossary.md#bundle
[38]: ../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

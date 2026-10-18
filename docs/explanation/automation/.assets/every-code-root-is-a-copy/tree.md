---
catzc:
  immutable:
    with_body_sha: e76270bad066
    repo_status: locked
    path: docs/explanation/automation/.assets/every-code-root-is-a-copy/tree.md
    source: docs/explanation/automation/.assets/every-code-root-is-a-copy/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One engine builds the bundle, and every code root is a copy of its output: the tree minimap

```text
Which files cite ADR-AUTO-BUNDLE: every file of the world map is a tile, grouped by top-level folder.
20 files lit in 6 groups.
```

![The tree minimap of One engine builds the bundle, and every code root is a copy of its output](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [One engine builds the bundle, and every code root is a copy of its
output][21], which explains [ADR-AUTO-BUNDLE][1]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 20 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 14 lit files
- adr/auto (docs/adr/automation): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 14 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pipelines/github-workflows/ci-automation.yml.md][2], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 42 (text).
- [docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md][4], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md][5], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md][6], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md][9], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 15 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/task-layers-classification-flip.md][17], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 32 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 175 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][19], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 142 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][20], in the cell pwsh × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 142
  (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [.claude][27]: a track
- [docs][27]: a track
- [pipelines][27]: a track
- [pwsh][27]: a track
- [markdown][28]: a file language
- [pipeline-yaml][28]: a file language
- [yaml][28]: a file language

[1]: ../../../../adr/automation/platform-bundle.md
[2]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[3]: ../../../../references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md
[4]: ../../../../references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md
[5]: ../../../../references/pwsh/catzc-base-exporter/Build-Modules.ps1.md
[6]: ../../../../references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md
[7]: ../../../../references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md
[8]: ../../../../references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md
[9]: ../../../../references/pwsh/catzc-base-exporter/configs/exporter.yml.md
[10]: ../../../../references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[11]: ../../../../references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
[12]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
[13]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
[14]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[15]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[16]: ../../../../adr/automation/dora-explains.md
[17]: ../../../../../.claude/plans/task-layers-classification-flip.md
[18]: ../../../../adr/index.md
[19]: ../../../../../pipelines/ci-automation.yaml
[20]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../every-code-root-is-a-copy.md
[22]: ../../../../adr/glossary.md#world-map
[23]: ../../../../adr/glossary.md#track
[24]: ../../../../adr/glossary.md#file-language
[25]: ../../../../adr/glossary.md#cell
[26]: ../../../../adr/glossary.md#lit-cell
[27]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

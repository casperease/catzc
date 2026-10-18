---
catzc:
  immutable:
    with_body_sha: "85ed0bb78dc6"
    repo_status: locked
    path: docs/explanation/automation/.assets/every-code-root-is-a-copy/grid.md
    source: docs/explanation/automation/.assets/every-code-root-is-a-copy/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One engine builds the bundle, and every code root is a copy of its output: the world-map minimap

```text
Where the files that cite ADR-AUTO-BUNDLE sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 20 files.
```

![The world-map minimap of One engine builds the bundle, and every code root is a copy of its output](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [One engine builds the bundle, and every code root is a copy of
its output][24], which explains [ADR-AUTO-BUNDLE][1]. It lights every cell of the world map that holds a file citing those codes, so it
shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 17 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/task-layers-classification-flip.md][5]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 32 (text).

### docs × markdown (17 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/dora-explains.md][6]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437 (text).
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.
- [docs/adr/index.md][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 175 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][8]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 42
  (text).
- [docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md][9]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line
  20 (text).
- [docs/references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md][10]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md][11]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md][13]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md][14]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][16]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md][17]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md][18]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md][19]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][20]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][21]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][22]: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 142 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][23]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 142 (text).

## Keywords

- [world map][25]
- [track][26]
- [file language][27]
- [cell][28]
- [lit cell][29]
- [.claude][30]: a track
- [docs][30]: a track
- [pipelines][30]: a track
- [pwsh][30]: a track
- [markdown][31]: a file language
- [pipeline-yaml][31]: a file language
- [yaml][31]: a file language

[1]: ../../../../adr/automation/platform-bundle.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../.claude/plans/task-layers-classification-flip.md
[6]: ../../../../adr/automation/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[9]: ../../../../references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md
[10]: ../../../../references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md
[11]: ../../../../references/pwsh/catzc-base-exporter/Build-Modules.ps1.md
[12]: ../../../../references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md
[13]: ../../../../references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md
[14]: ../../../../references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md
[15]: ../../../../references/pwsh/catzc-base-exporter/configs/exporter.yml.md
[16]: ../../../../references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[17]: ../../../../references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
[18]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
[19]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
[20]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[21]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[22]: ../../../../../pipelines/ci-automation.yaml
[23]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../every-code-root-is-a-copy.md
[25]: ../../../../adr/glossary.md#world-map
[26]: ../../../../adr/glossary.md#track
[27]: ../../../../adr/glossary.md#file-language
[28]: ../../../../adr/glossary.md#cell
[29]: ../../../../adr/glossary.md#lit-cell
[30]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[31]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

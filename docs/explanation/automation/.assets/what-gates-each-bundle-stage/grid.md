---
catzc:
  immutable:
    with_body_sha: "8ad4fd25feed"
    repo_status: locked
    path: docs/explanation/automation/.assets/what-gates-each-bundle-stage/grid.md
    source: docs/explanation/automation/.assets/what-gates-each-bundle-stage/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every stage of the bundle has a rule, and two gates check it: the world-map minimap

```text
Where the files that cite ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 28 files.
```

![The world-map minimap of Every stage of the bundle has a rule, and two gates check it](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check
it][30], which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 21 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 2 lit of 1651 files
- pwsh × yaml: 2 lit of 115 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/task-layers-classification-flip.md][4]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 35 (text).

### docs × markdown (21 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][5]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437 (text).
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.
- [docs/adr/glossary.md][6]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 612 (text).
- [docs/adr/index.md][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text); selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 201 (text).
- [docs/adr/automation/pwsh/dora-explains.md][8]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 61 (text).
- [docs/adr/automation/pwsh/dynamic-module-manifests.md][2]: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][9]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 42
  (text).
- [docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md][10]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 20 (text).
- [docs/references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md][11]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md][13]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md][14]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md][16]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][17]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md][18]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md][19]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md][20]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md][21]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][22]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][23]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][24]: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 142 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 506
  (text) and `pwsh/Catzc.Base.Exporter/Build-Modules.ps1` line 2 (text); selected by [ADR-PWSH-MANIFEST][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header) and
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 172 (text).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/.internal/assets/Import-ModuleFiles.ps1][25]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 1 (header).
- [pwsh/Catzc.Base.Exporter/Build-Modules.ps1][26]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 2 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][27]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 142 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 172 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][28]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 506 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK-ROOTFILE][3]); the extension `.ps1` names the
file language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [importer.ps1][29]: selected by [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [root file][36]
- [.claude][37]: a track
- [docs][37]: a track
- [pipelines][37]: a track
- [pwsh][37]: a track
- [markdown][38]: a file language
- [pipeline-yaml][38]: a file language
- [powershell][38]: a file language
- [yaml][38]: a file language

[1]: ../../../../adr/automation/platform-bundle.md
[2]: ../../../../adr/automation/pwsh/dynamic-module-manifests.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/task-layers-classification-flip.md
[5]: ../../../../adr/automation/dora-explains.md
[6]: ../../../../adr/glossary.md
[7]: ../../../../adr/index.md
[8]: ../../../../adr/automation/pwsh/dora-explains.md
[9]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[10]: ../../../../references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md
[11]: ../../../../references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md
[12]: ../../../../references/pwsh/catzc-base-exporter/Build-Modules.ps1.md
[13]: ../../../../references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md
[14]: ../../../../references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md
[15]: ../../../../references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md
[16]: ../../../../references/pwsh/catzc-base-exporter/configs/exporter.yml.md
[17]: ../../../../references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[18]: ../../../../references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
[19]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
[20]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
[21]: ../../../../references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md
[22]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[23]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[24]: ../../../../../pipelines/ci-automation.yaml
[25]: ../../../../../pwsh/.internal/assets/Import-ModuleFiles.ps1
[26]: ../../../../../pwsh/Catzc.Base.Exporter/Build-Modules.ps1
[27]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[28]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[29]: ../../../../../importer.ps1
[30]: ../../what-gates-each-bundle-stage.md
[31]: ../../../../adr/glossary.md#world-map
[32]: ../../../../adr/glossary.md#track
[33]: ../../../../adr/glossary.md#file-language
[34]: ../../../../adr/glossary.md#cell
[35]: ../../../../adr/glossary.md#lit-cell
[36]: ../../../../adr/glossary.md#root-file
[37]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[38]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

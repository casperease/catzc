---
catzc:
  immutable:
    with_body_sha: fa48a5935d58
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
5 of 342 cells lit, holding 15 files.
```

![The world-map minimap of Every stage of the bundle has a rule, and two gates check it](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check
it][17], which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- docs × markdown: 11 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1651 files
- pwsh × yaml: 1 lit of 115 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### docs × markdown (11 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][4]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437 (text).
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.
- [docs/adr/index.md][5]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 175 (text); selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 203 (text).
- [docs/adr/pwsh/dora-explains.md][6]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 61 (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2]: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.
- [docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][8]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md][9]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md][10]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][11]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][13]: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 142 (text); selected by [ADR-PWSH-MANIFEST][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header) and
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 172 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/.internal/assets/Import-ModuleFiles.ps1][14]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 1 (header).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 142 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 172 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK-ROOTFILE][3]); the extension `.ps1` names the
file language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [importer.ps1][16]: selected by [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [root file][23]
- [docs][24]: a track
- [pipelines][24]: a track
- [pwsh][24]: a track
- [markdown][25]: a file language
- [pipeline-yaml][25]: a file language
- [powershell][25]: a file language
- [yaml][25]: a file language

[1]: ../../../../adr/automation/platform-bundle.md
[2]: ../../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../adr/automation/dora-explains.md
[5]: ../../../../adr/index.md
[6]: ../../../../adr/pwsh/dora-explains.md
[7]: ../../../../references/pwsh/catzc-base-exporter/configs/exporter.yml.md
[8]: ../../../../references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[9]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
[10]: ../../../../references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
[11]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[12]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[13]: ../../../../../pipelines/ci-automation.yaml
[14]: ../../../../../pwsh/.internal/assets/Import-ModuleFiles.ps1
[15]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[16]: ../../../../../importer.ps1
[17]: ../../what-gates-each-bundle-stage.md
[18]: ../../../../adr/glossary.md#world-map
[19]: ../../../../adr/glossary.md#track
[20]: ../../../../adr/glossary.md#file-language
[21]: ../../../../adr/glossary.md#cell
[22]: ../../../../adr/glossary.md#lit-cell
[23]: ../../../../adr/glossary.md#root-file
[24]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[25]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

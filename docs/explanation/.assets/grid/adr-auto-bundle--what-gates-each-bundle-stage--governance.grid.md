---
catzc:
  immutable:
    with_body_sha: "0a838c84fed7"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
    source: docs/explanation/.assets/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every stage of the bundle has a rule, and two gates check it: the world-map minimap

```text
Where the files that cite ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST sit in the repository: tracks down, file languages across.
7 of 342 cells lit, holding 30 files.
```

![The world-map minimap of Every stage of the bundle has a rule, and two gates check it](adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check
it][35], which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 90 files
- automation × powershell: 2 lit of 1629 files
- automation × yaml: 2 lit of 112 files
- docs × markdown: 20 lit of 2742 files
- github-workflows × yaml: 1 lit of 2 files, touched
- pipelines × pipeline-yaml: 1 lit of 9 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][6]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 495 (text),
  line 557 (text) and line 918 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 336 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 166 (text), line 275 (text), line 333 (text), line 349 (text) and line 391 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][8]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 19 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 20 (text).

### automation × powershell (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/.internal/assets/Import-ModuleFiles.ps1][9]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 1 (header).
- [pwsh/Catzc.Base.Exporter/Build-Modules.ps1][10]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 2 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][11]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 142 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 172 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 501 (text).

### docs × markdown (20 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][13]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437 (text).
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.
- [docs/adr/glossary.md][14]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 595 (text).
- [docs/adr/index.md][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text); selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 201 (text).
- [docs/adr/pwsh/dora-explains.md][16]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 61 (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2]: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.
- [docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md][17]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 20 (text).
- [docs/references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md][18]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md][19]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md][20]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md][21]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md][22]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/configs/exporter.yml.md][23]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][24]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md][25]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md][26]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md][27]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md][28]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][29]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][30]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.github/workflows/ci-automation.yml][31]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][32]: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 142 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 501
  (text) and `pwsh/Catzc.Base.Exporter/Build-Modules.ps1` line 2 (text); selected by [ADR-PWSH-MANIFEST][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header) and
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 172 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][33]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [importer.ps1][34]: selected by [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `pwsh/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

## Keywords

- [world map][36]
- [track][37]
- [file language][38]
- [cell][39]
- [lit cell][40]
- [root file][41]
- [.claude][42]: a track
- [automation][42]: a track
- [docs][42]: a track
- [github-workflows][42]: a track
- [pipelines][42]: a track
- [markdown][43]: a file language
- [pipeline-yaml][43]: a file language
- [powershell][43]: a file language
- [yaml][43]: a file language

Terms the cited ADRs define:

- [bundle][44], defined by [ADR-AUTO-BUNDLE#1][45]

[1]: ../../../adr/automation/platform-bundle.md
[2]: ../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[9]: ../../../../pwsh/.internal/assets/Import-ModuleFiles.ps1
[10]: ../../../../pwsh/Catzc.Base.Exporter/Build-Modules.ps1
[11]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[13]: ../../../adr/automation/dora-explains.md
[14]: ../../../adr/glossary.md
[15]: ../../../adr/index.md
[16]: ../../../adr/pwsh/dora-explains.md
[17]: ../../../references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md
[18]: ../../../references/pwsh/catzc-base-exporter/Assert-CatzcBundle.ps1.md
[19]: ../../../references/pwsh/catzc-base-exporter/Build-Modules.ps1.md
[20]: ../../../references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md
[21]: ../../../references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md
[22]: ../../../references/pwsh/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md
[23]: ../../../references/pwsh/catzc-base-exporter/configs/exporter.yml.md
[24]: ../../../references/pwsh/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[25]: ../../../references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
[26]: ../../../references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
[27]: ../../../references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
[28]: ../../../references/pwsh/catzc-base-overlay/Get-FunctionFileViolation.ps1.md
[29]: ../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[30]: ../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[31]: ../../../../.github/workflows/ci-automation.yml
[32]: ../../../../pipelines/ci-automation.yaml
[33]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[34]: ../../../../importer.ps1
[35]: ../../automation/what-gates-each-bundle-stage.md
[36]: ../../../adr/glossary.md#world-map
[37]: ../../../adr/glossary.md#track
[38]: ../../../adr/glossary.md#file-language
[39]: ../../../adr/glossary.md#cell
[40]: ../../../adr/glossary.md#lit-cell
[41]: ../../../adr/glossary.md#root-file
[42]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[43]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[44]: ../../../adr/glossary.md#bundle
[45]: ../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

# Every stage of the bundle has a rule, and two gates check it: the world-map minimap

```text
Where the files that cite ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST sit in the repository: tracks down, file languages across.
8 of 324 cells lit, holding 31 files.
```

![The world-map minimap of Every stage of the bundle has a rule, and two gates check it](adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check
it][36], which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every cell of the world map that holds a file citing
those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 91 files
- automation × csharp: 2 lit of 286 files
- automation × powershell: 11 lit of 1618 files
- automation × yaml: 2 lit of 112 files
- docs × markdown: 10 lit of 2220 files
- github-workflows × yaml: 1 lit of 2 files, touched
- pipelines × pipeline-yaml: 1 lit of 9 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][6]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 24 (text), line
  524 (text), line 586 (text) and line 947 (text).
- [.claude/plans/plan-module-kinds-tracks.md][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 355 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 37 (text), line 185 (text), line 294 (text), line 352 (text), line 368 (text) and line
  410 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][8]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 39 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 40 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][9]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][10]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 21 (text).

### automation × powershell (11 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/.internal/assets/Import-Catzc.ps1][11]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 20 (header).
- [automation/.internal/assets/Import-ModuleFiles.ps1][12]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][13]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 21 (header)
  and line 36 (header).
- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][14]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 22 (header) and
  line 29 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 22 (header), line 27
  (header) and line 73 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][16]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 20 (header) and line 26
  (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][17]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 21 (header) and line
  29 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][18]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 20
  (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][19]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 22
  (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][20]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 21
  (header) and line 26 (header).
- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][21]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 22
  (header) and line 29 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][22]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 161 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 191 (text).
- [automation/Catzc.Base.Docs/configs/glossary.yml][23]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 520 (text).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][24]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 507 (text).
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.
- [docs/adr/glossary.md][25]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 595 (text).
- [docs/adr/index.md][26]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text); selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 201 (text).
- [docs/adr/pwsh/dora-explains.md][27]: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 115 (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2]: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.
- [docs/references/automation/catzc-base-exporter/configs/exporter.yml.md][28]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line
  33 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterBundle.cs.md][29]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 32 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md][30]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 31 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][31]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 34
  (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.github/workflows/ci-automation.yml][32]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 64 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][33]: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header),
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

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][34]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [importer.ps1][35]: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header); selected by [ADR-PWSH-MANIFEST][2]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-ModuleFiles.ps1` line 19 (header).

## Keywords

- [world map][37]
- [track][38]
- [file language][39]
- [cell][40]
- [lit cell][41]
- [root file][42]
- [.claude][43]: a track
- [automation][43]: a track
- [docs][43]: a track
- [github-workflows][43]: a track
- [pipelines][43]: a track
- [csharp][44]: a file language
- [markdown][44]: a file language
- [pipeline-yaml][44]: a file language
- [powershell][44]: a file language
- [yaml][44]: a file language

Terms the cited ADRs define:

- [bundle][45], defined by [ADR-AUTO-BUNDLE#1][46]

[1]: ../../../adr/automation/platform-bundle.md
[2]: ../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[7]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[8]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[9]: ../../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[10]: ../../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[11]: ../../../../automation/.internal/assets/Import-Catzc.ps1
[12]: ../../../../automation/.internal/assets/Import-ModuleFiles.ps1
[13]: ../../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[14]: ../../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[15]: ../../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[16]: ../../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[17]: ../../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[18]: ../../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[19]: ../../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[20]: ../../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[21]: ../../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[22]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[23]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[24]: ../../../adr/automation/dora-explains.md
[25]: ../../../adr/glossary.md
[26]: ../../../adr/index.md
[27]: ../../../adr/pwsh/dora-explains.md
[28]: ../../../references/automation/catzc-base-exporter/configs/exporter.yml.md
[29]: ../../../references/automation/catzc-base-exporter/types/ExporterBundle.cs.md
[30]: ../../../references/automation/catzc-base-exporter/types/ExporterConfig.cs.md
[31]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[32]: ../../../../.github/workflows/ci-automation.yml
[33]: ../../../../pipelines/ci-automation.yaml
[34]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[35]: ../../../../importer.ps1
[36]: ../../automation/what-gates-each-bundle-stage.md
[37]: ../../../adr/glossary.md#world-map
[38]: ../../../adr/glossary.md#track
[39]: ../../../adr/glossary.md#file-language
[40]: ../../../adr/glossary.md#cell
[41]: ../../../adr/glossary.md#lit-cell
[42]: ../../../adr/glossary.md#root-file
[43]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[44]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[45]: ../../../adr/glossary.md#bundle
[46]: ../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

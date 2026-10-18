---
catzc:
  immutable:
    with_body_sha: "8b3225a066c1"
    repo_status: locked
    path: docs/explanation/design/.assets/where-code-loads-from-decides-the-mode/grid.md
    source: docs/explanation/design/.assets/where-code-loads-from-decides-the-mode/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Where the code loads from decides the run mode: the world-map minimap

```text
Where the files that cite ADR-DSGN-RUNMODE sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 27 files.
```

![The world-map minimap of Where the code loads from decides the run mode](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [Where the code loads from decides the run mode][29], which explains
[ADR-DSGN-RUNMODE][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the decision lives in
the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 24 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-explanation-drift-gaps.md][3]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 102 (text).

### docs × markdown (24 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/design/dora-explains.md][4]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 123 (text).
- [docs/adr/design/run-modes.md][1]: selected by [ADR-DSGN-RUNMODE][1]: the ADR's own file.
- [docs/adr/index.md][5]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 116 (text).
- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][6]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 53 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][7]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 31
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][8]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 38
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][9]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md][10]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 36 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-ModuleFunction.ps1.md][11]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line
  19 (text).
- [docs/references/pwsh/catzc-base-modulesystem/New-Importer.ps1.md][12]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 23
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][13]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line
  26 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md][14]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 26 (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][15]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 105 (text).
- [docs/references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md][16]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md][17]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Build-RootConfig.ps1.md][18]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 28
  (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][19]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md][20]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 34 (text).
- [docs/references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md][21]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 31 (text).
- [docs/references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md][22]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 27 (text).
- [docs/references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md][23]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 19
  (text).
- [docs/references/pwsh/catzc-base-vendor/Remove-VendorModules.ps1.md][24]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 25
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md][25]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/internal/assets/Import-Catzc.ps1.md][26]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 14 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][27]: selected by [ADR-DSGN-RUNMODE][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 80 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][28]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 80 (text).

## Keywords

- [world map][30]
- [track][31]
- [file language][32]
- [cell][33]
- [lit cell][34]
- [.claude][35]: a track
- [docs][35]: a track
- [pipelines][35]: a track
- [pwsh][35]: a track
- [markdown][36]: a file language
- [pipeline-yaml][36]: a file language
- [yaml][36]: a file language

[1]: ../../../../adr/design/run-modes.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[4]: ../../../../adr/design/dora-explains.md
[5]: ../../../../adr/index.md
[6]: ../../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[7]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[8]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[9]: ../../../../references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[10]: ../../../../references/pwsh/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
[11]: ../../../../references/pwsh/catzc-base-modulesystem/Get-ModuleFunction.ps1.md
[12]: ../../../../references/pwsh/catzc-base-modulesystem/New-Importer.ps1.md
[13]: ../../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[14]: ../../../../references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
[15]: ../../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[16]: ../../../../references/pwsh/catzc-base-repository/Assert-SourceTree.ps1.md
[17]: ../../../../references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md
[18]: ../../../../references/pwsh/catzc-base-rootconfig/Build-RootConfig.ps1.md
[19]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[20]: ../../../../references/pwsh/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
[21]: ../../../../references/pwsh/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
[22]: ../../../../references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
[23]: ../../../../references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md
[24]: ../../../../references/pwsh/catzc-base-vendor/Remove-VendorModules.ps1.md
[25]: ../../../../references/pwsh/internal/Catzc.Internal.Builder.psm1.md
[26]: ../../../../references/pwsh/internal/assets/Import-Catzc.ps1.md
[27]: ../../../../../pipelines/ci-automation.yaml
[28]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../where-code-loads-from-decides-the-mode.md
[30]: ../../../../adr/glossary.md#world-map
[31]: ../../../../adr/glossary.md#track
[32]: ../../../../adr/glossary.md#file-language
[33]: ../../../../adr/glossary.md#cell
[34]: ../../../../adr/glossary.md#lit-cell
[35]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[36]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

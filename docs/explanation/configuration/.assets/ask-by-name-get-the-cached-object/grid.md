---
catzc:
  immutable:
    with_body_sha: f8b30be63fd4
    repo_status: locked
    path: docs/explanation/configuration/.assets/ask-by-name-get-the-cached-object/grid.md
    source: docs/explanation/configuration/.assets/ask-by-name-get-the-cached-object/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Ask for a config by name and get the cached object back: the world-map minimap

```text
Where the files that cite ADR-CONF-ADDRESSING and ADR-CONF-LOADING sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 18 files.
```

![The world-map minimap of Ask for a config by name and get the cached object back](grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [Ask for a config by name and get the cached object back][20],
which explains [ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 15 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/decisions-2026-10-16.md][4]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 32 (text).

### docs × markdown (15 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/configuration/config-value-addressing.md][1]: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][5]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 28 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 11 (text).
- [docs/adr/configuration/module-config-loading.md][2]: selected by [ADR-CONF-LOADING][2]: the ADR's own file.
- [docs/adr/index.md][6]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 239 (text); selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 238 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][7]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][8]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md][9]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md][10]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][11]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][12]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 63
  (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][13]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line
  56 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][14]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  40 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][15]: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][16]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][17]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it
  at line 20 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][18]: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text); selected by [ADR-CONF-LOADING][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 208 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][19]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 209 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 208 (text).

## Keywords

- [world map][21]
- [track][22]
- [file language][23]
- [cell][24]
- [lit cell][25]
- [.claude][26]: a track
- [docs][26]: a track
- [pipelines][26]: a track
- [pwsh][26]: a track
- [markdown][27]: a file language
- [pipeline-yaml][27]: a file language
- [yaml][27]: a file language

[1]: ../../../../adr/configuration/config-value-addressing.md
[2]: ../../../../adr/configuration/module-config-loading.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/decisions-2026-10-16.md
[5]: ../../../../adr/configuration/dora-explains.md
[6]: ../../../../adr/index.md
[7]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[8]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[9]: ../../../../references/pwsh/catzc-base-docs/Build-Readme.ps1.md
[10]: ../../../../references/pwsh/catzc-base-docs/types/DocsConfig.cs.md
[11]: ../../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[12]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[13]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[14]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[15]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[16]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[17]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[18]: ../../../../../pipelines/ci-automation.yaml
[19]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../ask-by-name-get-the-cached-object.md
[21]: ../../../../adr/glossary.md#world-map
[22]: ../../../../adr/glossary.md#track
[23]: ../../../../adr/glossary.md#file-language
[24]: ../../../../adr/glossary.md#cell
[25]: ../../../../adr/glossary.md#lit-cell
[26]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[27]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

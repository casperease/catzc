---
catzc:
  immutable:
    with_body_sha: a108541e485e
    repo_status: locked
    path: docs/explanation/configuration/.assets/three-caches-back-one-reader/grid.md
    source: docs/explanation/configuration/.assets/three-caches-back-one-reader/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Three session caches back the one config reader: the world-map minimap

```text
Where the files that cite ADR-CONF-LOADING sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 32 files.
```

![The world-map minimap of Three session caches back the one config reader](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Three session caches back the one config reader][36], which
explains [ADR-CONF-LOADING][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the decision
lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 24 lit of 2756 files
- pipelines × pipeline-yaml: 1 lit of 9 files
- pwsh × csharp: 3 lit of 292 files, touched
- pwsh × powershell: 2 lit of 1648 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 32 (text).

### docs × markdown (24 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/configuration/dora-explains.md][6]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 11 (text).
- [docs/adr/configuration/module-config-loading.md][1]: selected by [ADR-CONF-LOADING][1]: the ADR's own file.
- [docs/adr/index.md][7]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 236 (text).
- [docs/how-to/getting-started/pwsh/add-a-module.md][8]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 72 (text).
- [docs/how-to/pwsh/manual-test-plan/configs.md][9]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 44 (text) and line 63
  (text).
- [docs/references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md][10]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 45 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][11]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16
  (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][12]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md][13]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md][14]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 21 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md][15]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][16]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][17]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md][18]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md][19]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-execution/Resolve-ToolExecutable.ps1.md][20]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md][21]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 19 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][22]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][23]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  40 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][24]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][25]: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/FileMetaConfig.cs.md][26]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][27]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md][28]: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 26 (text) and line 93 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][29]: selected by [ADR-CONF-LOADING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 208 (text), `pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1`
  line 38 (text), `pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs` line 7 (body comment), `pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs`
  line 8 (body comment), `pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs` line 10 (body comment) and
  `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 132 (text).

### pwsh × csharp (3 lit files, touched)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs][30]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 7 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs][31]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs][32]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 10 (body comment) (a
  passing mention only).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][33]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 38 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][34]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 132
  (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][35]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 208 (text).

## Keywords

- [world map][37]
- [track][38]
- [file language][39]
- [cell][40]
- [lit cell][41]
- [.claude][42]: a track
- [docs][42]: a track
- [pipelines][42]: a track
- [pwsh][42]: a track
- [csharp][43]: a file language
- [markdown][43]: a file language
- [pipeline-yaml][43]: a file language
- [powershell][43]: a file language
- [yaml][43]: a file language

[1]: ../../../../adr/configuration/module-config-loading.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../adr/configuration/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../how-to/getting-started/pwsh/add-a-module.md
[9]: ../../../../how-to/pwsh/manual-test-plan/configs.md
[10]: ../../../../references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md
[11]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[12]: ../../../../references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[13]: ../../../../references/pwsh/catzc-base-docs/Build-Readme.ps1.md
[14]: ../../../../references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
[15]: ../../../../references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md
[16]: ../../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[17]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[18]: ../../../../references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md
[19]: ../../../../references/pwsh/catzc-base-docs/types/DocsConfig.cs.md
[20]: ../../../../references/pwsh/catzc-base-execution/Resolve-ToolExecutable.ps1.md
[21]: ../../../../references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
[22]: ../../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[23]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[24]: ../../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[25]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[26]: ../../../../references/pwsh/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[27]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[28]: ../../../../references/pwsh/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
[29]: ../../../../../pipelines/ci-automation.yaml
[30]: ../../../../../pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[31]: ../../../../../pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs
[32]: ../../../../../pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs
[33]: ../../../../../pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[34]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[35]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[36]: ../../three-caches-back-one-reader.md
[37]: ../../../../adr/glossary.md#world-map
[38]: ../../../../adr/glossary.md#track
[39]: ../../../../adr/glossary.md#file-language
[40]: ../../../../adr/glossary.md#cell
[41]: ../../../../adr/glossary.md#lit-cell
[42]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[43]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

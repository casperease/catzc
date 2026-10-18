---
catzc:
  immutable:
    with_body_sha: "0861b93a916f"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
    source: docs/explanation/.assets/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Callers in any module read config through one module: the world-map minimap

```text
Where the files that cite ADR-CONF-LOADING sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 43 files.
```

![The world-map minimap of Callers in any module read config through one module](adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [Callers in any module read config through one module][47],
which explains [ADR-CONF-LOADING][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the
decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 4 lit of 91 files
- automation × csharp: 10 lit of 286 files
- automation × powershell: 12 lit of 1619 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 15 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (4 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 64 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][6]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 220 (text).
- [.claude/plans/plan-config-defaults.md][7]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 98 (text), line 175 (text) and
  line 264 (text).
- [.claude/plans/prompt-config-defaults-continue.md][8]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 35 (text) and line 56
  (text).

### automation × csharp (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][9]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 24 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][10]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 26 (text).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][11]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs][12]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/CapabilityEntry.cs][13]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][14]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][15]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][16]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs][17]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][18]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).

### automation × powershell (12 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][19]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22 (header), line 29
  (header) and line 35 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][20]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Docs/Build-Readme.ps1][21]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 23 (header) and line 45
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][22]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 23
  (header) and line 39 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][23]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (header)
  and line 30 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][24]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (header)
  and line 62 (text).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][25]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (header)
  and line 29 (header).
- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][26]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22
  (header) and line 34 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][27]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 23 (header) and
  line 54 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][28]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22 (header)
  and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][29]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  23 (header) and line 37 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][30]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 21 (header) and line 158 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][31]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 227 (text).

### docs × markdown (15 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/configuration/dora-explains.md][32]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 35 (text).
- [docs/adr/configuration/module-config-loading.md][1]: selected by [ADR-CONF-LOADING][1]: the ADR's own file.
- [docs/adr/index.md][33]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 236 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][34]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16 (text), line 69
  (text) and line 88 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][35]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15 (text) and
  line 97 (text).
- [docs/references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md][36]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 18 (text) and line 66 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][37]: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][38]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][39]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20
  (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][40]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 18
  (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][41]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 32
  (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][42]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][43]: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][44]: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 31 (text).
- [docs/references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md][45]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 17 (text), line 48 (text) and line 115 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][46]: selected by [ADR-CONF-LOADING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 22 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 29 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 35 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 22 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 23
  (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 45 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 227 (text),
  `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 23 (header),
  `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 39 (header),
  `automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1` line 30 (header), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1`
  line 21 (header), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 62 (text),
  `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line 24 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 26 (text),
  `automation/Catzc.Base.Docs/types/AgentsConfig.cs` line 23 (text), `automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs` line 21
  (text), `automation/Catzc.Base.Docs/types/CapabilityEntry.cs` line 20 (text), `automation/Catzc.Base.Docs/types/DocsConfig.cs` line 21
  (text), `automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1` line 20 (header),
  `automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1` line 29 (header),
  `automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1` line 22 (header),
  `automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1` line 34 (header), `automation/Catzc.Base.Git/types/GitIgnoreConfig.cs`
  line 21 (text), `automation/Catzc.Base.Globs/types/FileKindsConfig.cs` line 21 (text),
  `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line 23 (header), `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line
  54 (header), `automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1` line 37 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 158 (text),
  `automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs` line 21 (text) and
  `automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs` line 21 (text).

## Keywords

- [world map][48]
- [track][49]
- [file language][50]
- [cell][51]
- [lit cell][52]
- [.claude][53]: a track
- [automation][53]: a track
- [docs][53]: a track
- [pipelines][53]: a track
- [csharp][54]: a file language
- [markdown][54]: a file language
- [pipeline-yaml][54]: a file language
- [powershell][54]: a file language
- [yaml][54]: a file language

[1]: ../../../adr/configuration/module-config-loading.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[7]: ../../../../.claude/plans/plan-config-defaults.md
[8]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[9]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[10]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[11]: ../../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[12]: ../../../../automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[13]: ../../../../automation/Catzc.Base.Docs/types/CapabilityEntry.cs
[14]: ../../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[15]: ../../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[16]: ../../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[17]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
[18]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[19]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[20]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[21]: ../../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[22]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[23]: ../../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[24]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[25]: ../../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[26]: ../../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[27]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[28]: ../../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[29]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[30]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[31]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[32]: ../../../adr/configuration/dora-explains.md
[33]: ../../../adr/index.md
[34]: ../../../how-to/automation/manual-test-plan/configs.md
[35]: ../../../how-to/getting-started/automation/add-a-module.md
[36]: ../../../references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md
[37]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[38]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[39]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[40]: ../../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[41]: ../../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[42]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[43]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[44]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[45]: ../../../references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
[46]: ../../../../pipelines/ci-automation.yaml
[47]: ../../configuration/callers-depend-on-one-config-module.md
[48]: ../../../adr/glossary.md#world-map
[49]: ../../../adr/glossary.md#track
[50]: ../../../adr/glossary.md#file-language
[51]: ../../../adr/glossary.md#cell
[52]: ../../../adr/glossary.md#lit-cell
[53]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[54]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

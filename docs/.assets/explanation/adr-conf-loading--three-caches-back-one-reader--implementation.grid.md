# docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md

`Grid minimap: adr-conf-loading--three-caches-back-one-reader--implementation`

![Grid minimap of adr-conf-loading--three-caches-back-one-reader--implementation](adr-conf-loading--three-caches-back-one-reader--implementation.grid.png)

The grid minimap of the slide `adr-conf-loading--three-caches-back-one-reader--implementation` (implementation lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 4 lit of 51 files
- automation × csharp: 8 lit of 272 files
- automation × powershell: 12 lit of 1563 files
- automation × yaml: 1 lit of 107 files
- docs × markdown: 13 lit of 1985 files
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

- [.claude/plans/plan-bounded-folder-enumeration.md][5]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 148 (text).
- [.claude/plans/plan-config-defaults.md][6]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 62 (text), line 138 (text) and
  line 223 (text).
- [.claude/plans/plan-minimal-robots.md][7]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 51 (text).
- [.claude/plans/prompt-config-defaults-continue.md][8]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16 (text) and line 32
  (text).

### automation × csharp (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][9]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][10]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][11]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][12]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][13]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][14]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs][15]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][16]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).

### automation × powershell (12 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][17]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (header), line 28
  (header) and line 34 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][18]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.Docs/Build-Readme.ps1][19]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22 (header) and line 44
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][20]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22
  (header) and line 38 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][21]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (header)
  and line 29 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][22]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 20 (header)
  and line 61 (text).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][23]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 19 (header)
  and line 28 (header).
- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][24]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21
  (header) and line 33 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][25]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 22 (header) and
  line 52 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][26]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (header)
  and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][27]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  22 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][28]: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 20 (header) and line 157 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][29]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 220 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/configuration/dora-explains.md][30]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 35 (text).
- [docs/adr/configuration/module-config-loading.md][1]: selected by [ADR-CONF-LOADING][1]: the ADR's own file.
- [docs/adr/index.md][31]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 226 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][32]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15 (text), line 65
  (text) and line 84 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][33]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15 (text) and
  line 97 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][34]: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][35]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  19 (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][36]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 19
  (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][37]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 17
  (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][38]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 31
  (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][39]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  30 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][40]: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][41]: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 30 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][42]: selected by [ADR-CONF-LOADING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 21 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 28 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 34 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 21 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 22
  (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 44 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 220 (text),
  `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 22 (header),
  `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 38 (header),
  `automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1` line 29 (header), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1`
  line 20 (header), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 61 (text),
  `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line 23 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 23 (text),
  `automation/Catzc.Base.Docs/types/AgentsConfig.cs` line 21 (text), `automation/Catzc.Base.Docs/types/DocsConfig.cs` line 20 (text),
  `automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1` line 19 (header),
  `automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1` line 28 (header),
  `automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1` line 21 (header),
  `automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1` line 33 (header), `automation/Catzc.Base.Git/types/GitIgnoreConfig.cs`
  line 20 (text), `automation/Catzc.Base.Globs/types/FileKindsConfig.cs` line 20 (text),
  `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line 22 (header), `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line
  52 (header), `automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1` line 36 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 157 (text),
  `automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs` line 20 (text) and
  `automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs` line 20 (text).

## Keywords

- [world map][43]
- [track][44]
- [file language][45]
- [cell][46]
- [lit cell][47]
- [.claude][48]: a track
- [automation][48]: a track
- [docs][48]: a track
- [pipelines][48]: a track
- [csharp][49]: a file language
- [markdown][49]: a file language
- [pipeline-yaml][49]: a file language
- [powershell][49]: a file language
- [yaml][49]: a file language

[1]: ../../adr/configuration/module-config-loading.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/plans/plan-bounded-folder-enumeration.md
[6]: ../../../.claude/plans/plan-config-defaults.md
[7]: ../../../.claude/plans/plan-minimal-robots.md
[8]: ../../../.claude/plans/prompt-config-defaults-continue.md
[9]: ../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[10]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[11]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[12]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[13]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[14]: ../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[15]: ../../../automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
[16]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[17]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[18]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[19]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[20]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[21]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[22]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[23]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[24]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[25]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[26]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[27]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[28]: ../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[29]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[30]: ../../adr/configuration/dora-explains.md
[31]: ../../adr/index.md
[32]: ../../how-to/automation/manual-test-plan/configs.md
[33]: ../../how-to/getting-started/automation/add-a-module.md
[34]: ../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[35]: ../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[36]: ../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[37]: ../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[38]: ../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[39]: ../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[40]: ../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[41]: ../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[42]: ../../../pipelines/ci-automation.yaml
[43]: ../../adr/glossary.md#world-map
[44]: ../../adr/glossary.md#track
[45]: ../../adr/glossary.md#file-language
[46]: ../../adr/glossary.md#cell
[47]: ../../adr/glossary.md#lit-cell
[48]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[49]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

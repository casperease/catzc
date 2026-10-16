# docs/.assets/explanation/grid/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md

`Grid minimap: adr-conf-loading--ask-by-name-get-the-cached-object--operations`

![Grid minimap of adr-conf-loading--ask-by-name-get-the-cached-object--operations](adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.png)

The grid minimap of the slide `adr-conf-loading--ask-by-name-get-the-cached-object--operations` (operations lens). The slide supports
[ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the
code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 51 files
- .unordered × markdown: 1 lit of 20 files
- automation × csharp: 8 lit of 272 files
- automation × powershell: 17 lit of 1563 files
- automation × yaml: 1 lit of 107 files
- docs × markdown: 16 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-bounded-folder-enumeration.md][6]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 200 (text);
  selected by [ADR-CONF-LOADING][2]: the file cites it at line 148 (text).
- [.claude/plans/plan-config-defaults.md][7]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 62 (text), line 138 (text) and
  line 223 (text).
- [.claude/plans/plan-minimal-robots.md][8]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 51 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][9]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 17
  (text).
- [.claude/plans/prompt-config-defaults-continue.md][10]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 16 (text) and line 32
  (text).

### .unordered × markdown (1 lit file)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-diagram-wave-8.md][11]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 19 (text).

### automation × csharp (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][12]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][13]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][14]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][15]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][16]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][17]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs][18]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][19]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).

### automation × powershell (17 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][20]: selected by [ADR-CONF-ADDRESSING][1]: the file cites
  it at line 21 (header), line 29 (header) and line 34 (header).
- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][21]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 20 (header), line
  37 (header), line 40 (header) and line 43 (header); selected by [ADR-CONF-LOADING][2]: the file cites it at line 21 (header), line 28
  (header) and line 34 (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][22]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 19
  (header), line 29 (header), line 31 (header) and line 36 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][23]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 20
  (header), line 61 (text) and line 90 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/Build-Readme.ps1][24]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 22 (header) and line 44
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][25]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 22
  (header) and line 38 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][26]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (header)
  and line 29 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][27]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 20 (header)
  and line 61 (text).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][28]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 19 (header)
  and line 28 (header).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][29]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 20 (header) and line 77 (text).
- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][30]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 21
  (header) and line 33 (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][31]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][32]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][33]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 22 (header) and
  line 52 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][34]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 21 (header)
  and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][35]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  22 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][36]: selected by [ADR-CONF-LOADING][2]: the file cites it at
  line 20 (header) and line 157 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][37]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 221 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 220 (text).

### docs × markdown (16 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/configuration/config-value-addressing.md][1]: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][38]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 52 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 35 (text).
- [docs/adr/configuration/module-config-loading.md][2]: selected by [ADR-CONF-LOADING][2]: the ADR's own file.
- [docs/adr/index.md][39]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 227 (text); selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 226 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][40]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 15 (text), line 65
  (text) and line 84 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][41]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 15 (text) and
  line 97 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][42]: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][43]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  19 (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][44]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 19
  (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][45]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 17
  (text) and line 36 (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][46]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 31
  (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][47]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  30 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][48]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 27 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][49]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 27 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][50]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][51]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 30 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][52]: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 21 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 29 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 34 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 20 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 37 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 40 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 43 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 19 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 29 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 31 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 36 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 61 (text),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 90 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 221
  (text), `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Languages/New-GoWorkspace.ps1` line 21 (header) and `automation/Catzc.Base.Languages/New-PythonProject.ps1` line 22
  (header); selected by [ADR-CONF-LOADING][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 21 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 28 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 34 (header), `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line
  21 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 22 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 44
  (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 220 (text), `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1`
  line 22 (header), `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 38 (header),
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

- [world map][53]
- [track][54]
- [file language][55]
- [cell][56]
- [lit cell][57]
- [.claude][58]: a track
- [.unordered][58]: a track
- [automation][58]: a track
- [docs][58]: a track
- [pipelines][58]: a track
- [csharp][59]: a file language
- [markdown][59]: a file language
- [pipeline-yaml][59]: a file language
- [powershell][59]: a file language
- [yaml][59]: a file language

[1]: ../../../adr/configuration/config-value-addressing.md
[2]: ../../../adr/configuration/module-config-loading.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[7]: ../../../../.claude/plans/plan-config-defaults.md
[8]: ../../../../.claude/plans/plan-minimal-robots.md
[9]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[10]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[11]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[12]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[13]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[14]: ../../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[15]: ../../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[16]: ../../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[17]: ../../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[18]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
[19]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[20]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[21]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[22]: ../../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[23]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[24]: ../../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[25]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[26]: ../../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[27]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[28]: ../../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[29]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[30]: ../../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[31]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[32]: ../../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[33]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[34]: ../../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[35]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[36]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[37]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[38]: ../../../adr/configuration/dora-explains.md
[39]: ../../../adr/index.md
[40]: ../../../how-to/automation/manual-test-plan/configs.md
[41]: ../../../how-to/getting-started/automation/add-a-module.md
[42]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[43]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[44]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[45]: ../../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[46]: ../../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[47]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[48]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[49]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[50]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[51]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[52]: ../../../../pipelines/ci-automation.yaml
[53]: ../../../adr/glossary.md#world-map
[54]: ../../../adr/glossary.md#track
[55]: ../../../adr/glossary.md#file-language
[56]: ../../../adr/glossary.md#cell
[57]: ../../../adr/glossary.md#lit-cell
[58]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[59]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

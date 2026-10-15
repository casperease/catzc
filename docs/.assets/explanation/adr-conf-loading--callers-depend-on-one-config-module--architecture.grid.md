# docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md

`Grid minimap: adr-conf-loading--callers-depend-on-one-config-module--architecture`

![Grid minimap of adr-conf-loading--callers-depend-on-one-config-module--architecture](adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.png)

The grid minimap of the slide `adr-conf-loading--callers-depend-on-one-config-module--architecture` (architecture lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 6 lit of 229 files
- automation × powershell: 11 lit of 1443 files
- automation × yaml: 1 lit of 97 files
- docs × markdown: 5 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (6 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][5]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][6]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][7]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][8]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][9]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][10]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 5 (header).

### automation × powershell (11 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][11]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (header) and line
  14 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][12]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Build-Readme.ps1][13]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][14]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][15]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][16]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 43 (text).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][17]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][18]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][19]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][20]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][21]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  13 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][22]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 221 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/configuration/dora-explains.md][23]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 13 (text).
- [docs/adr/configuration/module-config-loading.md][1]: selected by [ADR-CONF-LOADING][1]: the ADR's own file.
- [docs/adr/index.md][24]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 206 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][25]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 37 (text) and line
  56 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][26]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 74 (text).

## Keywords

- [world map][27]
- [track][28]
- [file language][29]
- [cell][30]
- [lit cell][31]
- [automation][32]: a track
- [docs][32]: a track
- [csharp][33]: a file language
- [markdown][33]: a file language
- [powershell][33]: a file language
- [yaml][33]: a file language

[1]: ../../adr/configuration/module-config-loading.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[6]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[7]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[8]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[9]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[10]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[11]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[12]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[13]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[14]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[15]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[16]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[17]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[18]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[19]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[22]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[23]: ../../adr/configuration/dora-explains.md
[24]: ../../adr/index.md
[25]: ../../how-to/automation/manual-test-plan/configs.md
[26]: ../../how-to/getting-started/automation/add-a-module.md
[27]: ../../adr/glossary.md#world-map
[28]: ../../adr/glossary.md#track
[29]: ../../adr/glossary.md#file-language
[30]: ../../adr/glossary.md#cell
[31]: ../../adr/glossary.md#lit-cell
[32]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[33]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

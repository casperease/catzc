# docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md

`Grid minimap: adr-conf-loading--ask-by-name-get-the-cached-object--operations`

![Grid minimap of adr-conf-loading--ask-by-name-get-the-cached-object--operations](adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.png)

The grid minimap of the slide `adr-conf-loading--ask-by-name-get-the-cached-object--operations` (operations lens). The slide supports
[ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the
code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 6 lit of 229 files
- automation × powershell: 15 lit of 1445 files
- automation × yaml: 1 lit of 97 files
- docs × markdown: 6 lit of 745 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (6 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][6]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][7]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][8]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][9]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][10]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][11]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 5 (header).

### automation × powershell (15 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][12]: selected by [ADR-CONF-ADDRESSING][1]: the file cites
  it at line 9 (header) and line 14 (header).
- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][13]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 17 (header), line
  20 (header) and line 23 (header); selected by [ADR-CONF-LOADING][2]: the file cites it at line 8 (header) and line 14 (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][14]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 11
  (header), line 13 (header) and line 18 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][15]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 40
  (text) and line 69 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 16 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Build-Readme.ps1][16]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][17]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][18]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][19]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 43 (text).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][20]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][21]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][22]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 47 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][23]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 41 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][24]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][25]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][26]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  13 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][27]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 223 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 222 (text).

### docs × markdown (6 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/configuration/config-value-addressing.md][1]: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][28]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 30 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 13 (text).
- [docs/adr/configuration/module-config-loading.md][2]: selected by [ADR-CONF-LOADING][2]: the ADR's own file.
- [docs/adr/index.md][29]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 208 (text); selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 207 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][30]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 37 (text) and line
  56 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][31]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 74 (text).

## Keywords

- [world map][32]
- [track][33]
- [file language][34]
- [cell][35]
- [lit cell][36]
- [automation][37]: a track
- [docs][37]: a track
- [csharp][38]: a file language
- [markdown][38]: a file language
- [powershell][38]: a file language
- [yaml][38]: a file language

[1]: ../../adr/configuration/config-value-addressing.md
[2]: ../../adr/configuration/module-config-loading.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[7]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[8]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[9]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[10]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[11]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[12]: ../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[13]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[14]: ../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[15]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[16]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[17]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[18]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[19]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[20]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[21]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[22]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[23]: ../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[24]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[25]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[26]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[27]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[28]: ../../adr/configuration/dora-explains.md
[29]: ../../adr/index.md
[30]: ../../how-to/automation/manual-test-plan/configs.md
[31]: ../../how-to/getting-started/automation/add-a-module.md
[32]: ../../adr/glossary.md#world-map
[33]: ../../adr/glossary.md#track
[34]: ../../adr/glossary.md#file-language
[35]: ../../adr/glossary.md#cell
[36]: ../../adr/glossary.md#lit-cell
[37]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[38]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

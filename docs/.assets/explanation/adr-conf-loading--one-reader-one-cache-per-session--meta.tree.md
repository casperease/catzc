# docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md

`Tree minimap: adr-conf-loading--one-reader-one-cache-per-session--meta`

![Tree minimap of adr-conf-loading--one-reader-one-cache-per-session--meta](adr-conf-loading--one-reader-one-cache-per-session--meta.tree.png)

The tree minimap of the slide `adr-conf-loading--one-reader-one-cache-per-session--meta` (meta lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 28 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Docs (automation/Catzc.Base.Docs): 8 lit files
- docs (docs/ outside docs/adr/): 7 lit files
- adr/conf (docs/adr/configuration): 3 lit files
- Config (automation/Catzc.Base.Config): 2 lit files
- Git (automation/Catzc.Base.Git): 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Execution (automation/Catzc.Base.Execution): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Docs (8 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-Readme.ps1][2], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 21 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][3], in the cell automation × yaml: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 222 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][4], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 15 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][5], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][6], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 43 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][7], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][8], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][9], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 6 (header).

### docs (7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/configuration/ask-by-name-get-the-cached-object.md][10], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 17 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/configuration/callers-depend-on-one-config-module.md][11], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 16 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text) and line 51
  (text).
- [docs/explanation/configuration/one-gate-guards-the-read-path.md][12], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 17 (text), line 29 (text), line 56 (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text) and line
  60 (text).
- [docs/explanation/configuration/one-reader-one-cache-per-session.md][13], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 14 (text), line 40 (text) and line 41 (text).
- [docs/explanation/configuration/three-caches-back-one-reader.md][14], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 19 (text), line 53 (text), line 54 (text), line 55 (text) and line 56 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][15], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 37 (text) and line 56 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][16], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 74 (text).

### adr/conf (3 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][17], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: an ADR file of
  the `configuration` ADR domain, the ADR domain of that code.
- [docs/adr/configuration/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: an ADR file of the
  `configuration` ADR domain, the ADR domain of that code.
- [docs/adr/configuration/module-config-loading.md][1], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: an ADR file of the
  `configuration` ADR domain, the ADR domain of that code.

### Config (2 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][19], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 8 (header) and line 14 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][20], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 16 (body comment) (a passing mention only).

### Git (2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][21], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][22], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 5 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][23], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][24], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 13 (header).

### Execution (1 lit file)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][25], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 10 (header).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][26], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 28 (header).

### RootConfig (1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][27], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 5 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][28], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line 207 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [automation][34]: a track
- [docs][34]: a track
- [csharp][35]: a file language
- [markdown][35]: a file language
- [powershell][35]: a file language
- [yaml][35]: a file language

[1]: ../../adr/configuration/module-config-loading.md
[2]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[3]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[4]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[5]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[6]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[7]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[8]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[9]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[10]: ../../explanation/configuration/ask-by-name-get-the-cached-object.md
[11]: ../../explanation/configuration/callers-depend-on-one-config-module.md
[12]: ../../explanation/configuration/one-gate-guards-the-read-path.md
[13]: ../../explanation/configuration/one-reader-one-cache-per-session.md
[14]: ../../explanation/configuration/three-caches-back-one-reader.md
[15]: ../../how-to/automation/manual-test-plan/configs.md
[16]: ../../how-to/getting-started/automation/add-a-module.md
[17]: ../../adr/configuration/config-value-addressing.md
[18]: ../../adr/configuration/dora-explains.md
[19]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[20]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[21]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[22]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[23]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[24]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[25]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[26]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[27]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[28]: ../../adr/index.md
[29]: ../../adr/glossary.md#world-map
[30]: ../../adr/glossary.md#track
[31]: ../../adr/glossary.md#file-language
[32]: ../../adr/glossary.md#cell
[33]: ../../adr/glossary.md#lit-cell
[34]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[35]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

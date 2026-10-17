# docs/explanation/.assets/tree/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md

`Tree minimap: adr-conf-loading--one-reader-one-cache-per-session--meta`

![Tree minimap of adr-conf-loading--one-reader-one-cache-per-session--meta](adr-conf-loading--one-reader-one-cache-per-session--meta.tree.png)

The tree minimap of the slide `adr-conf-loading--one-reader-one-cache-per-session--meta` (meta lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 41 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Docs (automation/Catzc.Base.Docs): 11 lit files
- docs (docs/ outside docs/adr/): 10 lit files
- .claude: 4 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 4 lit files
- Config (automation/Catzc.Base.Config): 2 lit files
- Git (automation/Catzc.Base.Git): 2 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- Execution (automation/Catzc.Base.Execution): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Docs (automation/Catzc.Base.Docs, 11 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-Readme.ps1][2], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 23 (header) and line 45 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][3], in the cell automation × yaml: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 222 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][4], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 23 (header) and line 39 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][5], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][6], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 21 (header) and line 62 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][7], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 24 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][8], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 24 (text).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][9], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 22 (text).
- [automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs][10], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/CapabilityEntry.cs][11], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][12], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 21 (text).

### docs (docs/ outside docs/adr/, 10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/configs.md][13], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 16 (text), line 66 (text) and line 85 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][14], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 16 (text) and line 98 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][16], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][17], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 20 (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][18], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 18 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][19], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][20], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][21], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][22], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 31 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][23], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  64 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][24], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 219 (text).
- [.claude/plans/plan-config-defaults.md][25], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  99 (text), line 176 (text) and line 265 (text).
- [.claude/plans/prompt-config-defaults-continue.md][26], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 38 (text) and line 59 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 4 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][27], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][28], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 23 (header) and line 37 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][29], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 21 (header) and line 158 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs][30], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 21 (text).

### Config (automation/Catzc.Base.Config, 2 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][31], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 22 (header), line 29 (header) and line 35 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 22 (header).

### Git (automation/Catzc.Base.Git, 2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][33], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 22 (header) and line 34 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][34], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 21 (text).

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/dora-explains.md][35], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  36 (text).
- [docs/adr/configuration/module-config-loading.md][1], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the ADR's own file.

### Execution (automation/Catzc.Base.Execution, 1 lit file)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][36], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 20 (header) and line 29 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][37], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 21 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][38], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 23 (header) and line 54 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][39], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 21 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][40], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line 230 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][41], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-LOADING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 22 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 29 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 35 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 22 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 23
  (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 45 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 222 (text),
  `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 23 (header),
  `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 39 (header),
  `automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1` line 21 (header),
  `automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1` line 30 (header), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1`
  line 21 (header), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 62 (text),
  `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line 24 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 24 (text),
  `automation/Catzc.Base.Docs/types/AgentsConfig.cs` line 22 (text), `automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs` line 21
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

- [world map][42]
- [track][43]
- [file language][44]
- [cell][45]
- [lit cell][46]
- [.claude][47]: a track
- [automation][47]: a track
- [docs][47]: a track
- [pipelines][47]: a track
- [csharp][48]: a file language
- [markdown][48]: a file language
- [pipeline-yaml][48]: a file language
- [powershell][48]: a file language
- [yaml][48]: a file language

[1]: ../../../adr/configuration/module-config-loading.md
[2]: ../../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[3]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[4]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[5]: ../../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[6]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[7]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[8]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[9]: ../../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[10]: ../../../../automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[11]: ../../../../automation/Catzc.Base.Docs/types/CapabilityEntry.cs
[12]: ../../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[13]: ../../../how-to/automation/manual-test-plan/configs.md
[14]: ../../../how-to/getting-started/automation/add-a-module.md
[15]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[16]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[17]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[18]: ../../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[19]: ../../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[20]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[21]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[22]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[23]: ../../../../.claude/plans/decisions-2026-10-16.md
[24]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[25]: ../../../../.claude/plans/plan-config-defaults.md
[26]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[27]: ../../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[28]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[29]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[30]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
[31]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[32]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[33]: ../../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[34]: ../../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[35]: ../../../adr/configuration/dora-explains.md
[36]: ../../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[37]: ../../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[38]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[39]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[40]: ../../../adr/index.md
[41]: ../../../../pipelines/ci-automation.yaml
[42]: ../../../adr/glossary.md#world-map
[43]: ../../../adr/glossary.md#track
[44]: ../../../adr/glossary.md#file-language
[45]: ../../../adr/glossary.md#cell
[46]: ../../../adr/glossary.md#lit-cell
[47]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[48]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

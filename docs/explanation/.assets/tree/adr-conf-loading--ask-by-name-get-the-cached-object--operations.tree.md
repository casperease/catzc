# docs/explanation/.assets/tree/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md

`Tree minimap: adr-conf-loading--ask-by-name-get-the-cached-object--operations`

![Tree minimap of adr-conf-loading--ask-by-name-get-the-cached-object--operations](adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.png)

The tree minimap of the slide `adr-conf-loading--ask-by-name-get-the-cached-object--operations` (operations lens). The slide supports
[ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the
code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 51 files in 17 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 12 lit files
- Docs (automation/Catzc.Base.Docs): 11 lit files
- .claude: 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 4 lit files
- Config (automation/Catzc.Base.Config): 3 lit files
- adr/conf (docs/adr/configuration): 3 lit files
- Git (automation/Catzc.Base.Git): 2 lit files
- Languages (automation/Catzc.Base.Languages): 2 lit files
- .unordered: 1 lit file
- Az.Templates (automation/Catzc.Azure.Templates): 1 lit file
- Execution (automation/Catzc.Base.Execution): 1 lit file
- Folders (automation/Catzc.Base.Folders): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 12 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/configs.md][3], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 16 (text), line 66 (text) and line 85 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][4], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 16 (text) and line 98 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][6], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 20 (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][8], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 18 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][9], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][10], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][13], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][14], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 31 (text).

### Docs (automation/Catzc.Base.Docs, 11 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-Readme.ps1][15], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 23 (header) and line 45 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][16], in the cell automation × yaml: selected by [ADR-CONF-ADDRESSING][1]: the file cites it
  at line 223 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 222 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][17], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 23 (header) and line 39 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][18], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][19], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 21 (header) and line 62 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][20], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 24 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][21], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 24 (text).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][22], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 22 (text).
- [automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs][23], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/CapabilityEntry.cs][24], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][25], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 21 (text).

### .claude (5 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][26], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  64 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][27], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file
  cites it at line 29 (text) and line 304 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 219 (text).
- [.claude/plans/plan-config-defaults.md][28], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  99 (text), line 176 (text) and line 265 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][29], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 20 (text) and line 41 (text).
- [.claude/plans/prompt-config-defaults-continue.md][30], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 38 (text) and line 59 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 4 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][31], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][32], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 23 (header) and line 37 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][33], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 21 (header) and line 158 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs][34], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 21 (text).

### Config (automation/Catzc.Base.Config, 3 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][35], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 21 (header), line 38 (header), line 41 (header) and line 44 (header); selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 22 (header), line 29 (header) and line 35 (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][36], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 20 (header), line 30 (header), line 32 (header) and line 37 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][37], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 21 (header), line 62 (text) and line 91 (text); selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 22 (header).

### adr/conf (docs/adr/configuration, 3 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][1], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][38], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 53 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 36 (text).
- [docs/adr/configuration/module-config-loading.md][2], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the ADR's own file.

### Git (automation/Catzc.Base.Git, 2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][39], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 22 (header) and line 34 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][40], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 21 (text).

### Languages (automation/Catzc.Base.Languages, 2 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][41], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][42], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 23 (header).

### .unordered (1 lit file)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-diagram-wave-8.md][43], in the cell .unordered × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file
  cites it at line 19 (text).

### Az.Templates (automation/Catzc.Azure.Templates, 1 lit file)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][44], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 22 (header), line 30 (header) and line 35 (header).

### Execution (automation/Catzc.Base.Execution, 1 lit file)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][45], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 20 (header) and line 29 (header).

### Folders (automation/Catzc.Base.Folders, 1 lit file)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][46], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 21 (header) and line 78 (text).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][47], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 21 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][48], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 23 (header) and line 54 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][49], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 21 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][50], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 231 (text); selected
  by [ADR-CONF-LOADING][2]: the file cites it at line 230 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][51], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 22 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 30 (header),
  `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 35 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 21 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 38 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 41 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 44 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 20 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 30 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 32 (header),
  `automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1` line 37 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 62 (text),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 91 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 223
  (text), `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.Languages/New-GoWorkspace.ps1` line 22 (header) and `automation/Catzc.Base.Languages/New-PythonProject.ps1` line 23
  (header); selected by [ADR-CONF-LOADING][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 22 (header), `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 29 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 35 (header), `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line
  22 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 23 (header), `automation/Catzc.Base.Docs/Build-Readme.ps1` line 45
  (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 222 (text), `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1`
  line 23 (header), `automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1` line 39 (header),
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

- [world map][52]
- [track][53]
- [file language][54]
- [cell][55]
- [lit cell][56]
- [.claude][57]: a track
- [.unordered][57]: a track
- [automation][57]: a track
- [docs][57]: a track
- [pipelines][57]: a track
- [csharp][58]: a file language
- [markdown][58]: a file language
- [pipeline-yaml][58]: a file language
- [powershell][58]: a file language
- [yaml][58]: a file language

[1]: ../../../adr/configuration/config-value-addressing.md
[2]: ../../../adr/configuration/module-config-loading.md
[3]: ../../../how-to/automation/manual-test-plan/configs.md
[4]: ../../../how-to/getting-started/automation/add-a-module.md
[5]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[6]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[7]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[8]: ../../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[9]: ../../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[10]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[11]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[12]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[13]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[14]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[15]: ../../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[16]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[18]: ../../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[19]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[20]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[21]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[22]: ../../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[23]: ../../../../automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[24]: ../../../../automation/Catzc.Base.Docs/types/CapabilityEntry.cs
[25]: ../../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[26]: ../../../../.claude/plans/decisions-2026-10-16.md
[27]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[28]: ../../../../.claude/plans/plan-config-defaults.md
[29]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[30]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[31]: ../../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[32]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[33]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[34]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
[35]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[36]: ../../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[37]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[38]: ../../../adr/configuration/dora-explains.md
[39]: ../../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[40]: ../../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[41]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[42]: ../../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[43]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[44]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[45]: ../../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[46]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[47]: ../../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[48]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[49]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[50]: ../../../adr/index.md
[51]: ../../../../pipelines/ci-automation.yaml
[52]: ../../../adr/glossary.md#world-map
[53]: ../../../adr/glossary.md#track
[54]: ../../../adr/glossary.md#file-language
[55]: ../../../adr/glossary.md#cell
[56]: ../../../adr/glossary.md#lit-cell
[57]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

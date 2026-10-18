---
catzc:
  immutable:
    with_body_sha: "7d29e18beffc"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md
    source: docs/explanation/.assets/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Callers in any module read config through one module: the tree minimap

```text
Which files cite ADR-CONF-LOADING: every file of the world map is a tile, grouped by top-level folder.
43 files lit in 13 groups.
```

![The tree minimap of Callers in any module read config through one module](adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Callers in any module read config through one module][44], which
explains [ADR-CONF-LOADING][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the decision.
Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 43 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 12 lit files
- Docs (automation/Catzc.Base.Docs): 11 lit files
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

### docs (docs/ outside docs/adr/, 12 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/configs.md][2], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 16 (text), line 69 (text) and line 88 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][3], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 15 (text) and line 97 (text).
- [docs/references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md][4], in the cell docs ×
  markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line 18 (text) and line 66 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][6], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 20 (text) and line 38 (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][8], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 18 (text) and line 37 (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][9], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][10], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][11], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][12], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md][13], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 17 (text), line 48 (text) and line 115 (text).

### Docs (automation/Catzc.Base.Docs, 11 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-Readme.ps1][14], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 23 (header) and line 45 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][15], in the cell automation × yaml: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 227 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][16], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 23 (header) and line 39 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][17], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][18], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 21 (header) and line 62 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][19], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 24 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][20], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 26 (text).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][21], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 23 (text).
- [automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs][22], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/CapabilityEntry.cs][23], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][24], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 21 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][25], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  64 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][26], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 220 (text).
- [.claude/plans/plan-config-defaults.md][27], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  98 (text), line 175 (text) and line 264 (text).
- [.claude/plans/prompt-config-defaults-continue.md][28], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 35 (text) and line 56 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 4 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][29], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 22 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][30], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 23 (header) and line 37 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 21 (header) and line 158 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs][32], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 21 (text).

### Config (automation/Catzc.Base.Config, 2 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][33], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 22 (header), line 29 (header) and line 35 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 22 (header).

### Git (automation/Catzc.Base.Git, 2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][35], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 22 (header) and line 34 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][36], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 21 (text).

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/dora-explains.md][37], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  35 (text).
- [docs/adr/configuration/module-config-loading.md][1], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the ADR's own file.

### Execution (automation/Catzc.Base.Execution, 1 lit file)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][38], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 20 (header) and line 29 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][39], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 21 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][40], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 23 (header) and line 54 (header).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][41], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 21 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][42], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line 236 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][43], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-LOADING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 22 (header),
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

- [world map][45]
- [track][46]
- [file language][47]
- [cell][48]
- [lit cell][49]
- [.claude][50]: a track
- [automation][50]: a track
- [docs][50]: a track
- [pipelines][50]: a track
- [csharp][51]: a file language
- [markdown][51]: a file language
- [pipeline-yaml][51]: a file language
- [powershell][51]: a file language
- [yaml][51]: a file language

[1]: ../../../adr/configuration/module-config-loading.md
[2]: ../../../how-to/automation/manual-test-plan/configs.md
[3]: ../../../how-to/getting-started/automation/add-a-module.md
[4]: ../../../references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md
[5]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[6]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[7]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[8]: ../../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[9]: ../../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[10]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[11]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[12]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[13]: ../../../references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
[14]: ../../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[15]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[16]: ../../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[17]: ../../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[18]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[19]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[20]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[21]: ../../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[22]: ../../../../automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[23]: ../../../../automation/Catzc.Base.Docs/types/CapabilityEntry.cs
[24]: ../../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[25]: ../../../../.claude/plans/decisions-2026-10-16.md
[26]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[27]: ../../../../.claude/plans/plan-config-defaults.md
[28]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[29]: ../../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[30]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[31]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[32]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
[33]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[34]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[35]: ../../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[36]: ../../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[37]: ../../../adr/configuration/dora-explains.md
[38]: ../../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[39]: ../../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[40]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[41]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[42]: ../../../adr/index.md
[43]: ../../../../pipelines/ci-automation.yaml
[44]: ../../configuration/callers-depend-on-one-config-module.md
[45]: ../../../adr/glossary.md#world-map
[46]: ../../../adr/glossary.md#track
[47]: ../../../adr/glossary.md#file-language
[48]: ../../../adr/glossary.md#cell
[49]: ../../../adr/glossary.md#lit-cell
[50]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[51]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

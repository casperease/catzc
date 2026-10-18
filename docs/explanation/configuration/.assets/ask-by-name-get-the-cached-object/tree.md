---
catzc:
  immutable:
    with_body_sha: "658a1d093605"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md
    source: docs/explanation/.assets/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Ask for a config by name and get the cached object back: the tree minimap

```text
Which files cite ADR-CONF-ADDRESSING and ADR-CONF-LOADING: every file of the world map is a tile, grouped by top-level folder.
46 files lit in 10 groups.
```

![The tree minimap of Ask for a config by name and get the cached object back](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [Ask for a config by name and get the cached object back][47], which
explains [ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 46 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 28 lit files
- .claude: 5 lit files
- Docs (pwsh/Catzc.Base.Docs): 4 lit files
- adr/conf (docs/adr/configuration): 3 lit files
- Config (pwsh/Catzc.Base.Config): 1 lit file
- Folders (pwsh/Catzc.Base.Folders): 1 lit file
- Globs (pwsh/Catzc.Base.Globs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 28 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/pwsh/manual-test-plan/configs.md][3], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at
  line 44 (text) and line 63 (text).
- [docs/how-to/getting-started/pwsh/add-a-module.md][4], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 72 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][5], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 45 (text).
- [docs/references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md][6], in the cell docs ×
  markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at line 45 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][7], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 32 (text) and line 95 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 17 (text) and line 21 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][9], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 14 (text), line 23 (text), line 25 (text) and line 27 (text); selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 14 (text), line 20 (text), line 22 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md][12], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][15], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][16], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md][17], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md][18], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-execution/Resolve-ToolExecutable.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][21], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][22], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 63 (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 56 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-Automation.ps1.md][24], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 40 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][25], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][26], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/FileMetaConfig.cs.md][27], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][28], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md][29], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 26 (text) and line 93 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][30], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 20 (text).

### .claude (5 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][31], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  32 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][32], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file
  cites it at line 283 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 198 (text).
- [.claude/plans/plan-config-defaults.md][33], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  72 (text), line 169 (text) and line 258 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][34], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 18 (text).
- [.claude/plans/prompt-config-defaults-continue.md][35], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 15 (text) and line 36 (text).

### Docs (pwsh/Catzc.Base.Docs, 4 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][36], in the cell automation × yaml: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 209 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 208 (text).
- [pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][37], in the cell automation × powershell: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 38 (text).
- [pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs][38], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 7 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs][39], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 8 (body comment) (a passing mention only).

### adr/conf (docs/adr/configuration, 3 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][1], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][40], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 28 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 11 (text).
- [docs/adr/configuration/module-config-loading.md][2], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the ADR's own file.

### Config (pwsh/Catzc.Base.Config, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][41], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 37 (text) and line 66 (text).

### Folders (pwsh/Catzc.Base.Folders, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][42], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 54 (text).

### Globs (pwsh/Catzc.Base.Globs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs][43], in the cell automation × csharp: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 10 (body comment) (a passing mention only).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][44], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 132 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][45], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 237 (text); selected
  by [ADR-CONF-LOADING][2]: the file cites it at line 236 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][46], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37 (text),
  `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text) and
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text); selected by [ADR-CONF-LOADING][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 208 (text),
  `pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 38 (text), `pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs` line 7 (body
  comment), `pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs` line 8 (body comment), `pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs` line 10
  (body comment) and `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 132 (text).

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

[1]: ../../../../adr/configuration/config-value-addressing.md
[2]: ../../../../adr/configuration/module-config-loading.md
[3]: ../../../../how-to/pwsh/manual-test-plan/configs.md
[4]: ../../../../how-to/getting-started/pwsh/add-a-module.md
[5]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[6]: ../../../../references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md
[7]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[8]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[9]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[10]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[11]: ../../../../references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[12]: ../../../../references/pwsh/catzc-base-docs/Build-Readme.ps1.md
[13]: ../../../../references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
[14]: ../../../../references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md
[15]: ../../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[16]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[17]: ../../../../references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md
[18]: ../../../../references/pwsh/catzc-base-docs/types/DocsConfig.cs.md
[19]: ../../../../references/pwsh/catzc-base-execution/Resolve-ToolExecutable.ps1.md
[20]: ../../../../references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
[21]: ../../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[22]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[23]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[24]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-Automation.ps1.md
[25]: ../../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[26]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[27]: ../../../../references/pwsh/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[28]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[29]: ../../../../references/pwsh/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
[30]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[31]: ../../../../../.claude/plans/decisions-2026-10-16.md
[32]: ../../../../../.claude/plans/plan-bounded-folder-enumeration.md
[33]: ../../../../../.claude/plans/plan-config-defaults.md
[34]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[35]: ../../../../../.claude/plans/prompt-config-defaults-continue.md
[36]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[37]: ../../../../../pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[38]: ../../../../../pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[39]: ../../../../../pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs
[40]: ../../../../adr/configuration/dora-explains.md
[41]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[42]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[43]: ../../../../../pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs
[44]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[45]: ../../../../adr/index.md
[46]: ../../../../../pipelines/ci-automation.yaml
[47]: ../../ask-by-name-get-the-cached-object.md
[48]: ../../../../adr/glossary.md#world-map
[49]: ../../../../adr/glossary.md#track
[50]: ../../../../adr/glossary.md#file-language
[51]: ../../../../adr/glossary.md#cell
[52]: ../../../../adr/glossary.md#lit-cell
[53]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[54]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "89865ccc2e94"
    repo_status: locked
    path: docs/explanation/configuration/.assets/three-caches-back-one-reader/tree.md
    source: docs/explanation/configuration/.assets/three-caches-back-one-reader/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Three session caches back the one config reader: the tree minimap

```text
Which files cite ADR-CONF-LOADING: every file of the world map is a tile, grouped by top-level folder.
31 files lit in 7 groups.
```

![The tree minimap of Three session caches back the one config reader](tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Three session caches back the one config reader][32], which
explains [ADR-CONF-LOADING][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the decision.
Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 31 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 21 lit files
- Docs (pwsh/Catzc.Base.Docs): 4 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Globs (pwsh/Catzc.Base.Globs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 21 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/pwsh/add-a-module.md][2], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it
  at line 72 (text).
- [docs/how-to/pwsh/manual-test-plan/configs.md][3], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 44 (text) and line 63 (text).
- [docs/references/pwsh/.assets/invoke-tool-asserts-locked-version/diagram.drawio.md][4], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 26 (text) and line 93 (text).
- [docs/references/pwsh/.assets/invoke-tool-asserts-locked-version/diagram.drawio.verify.md][5], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 45 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][6], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md][8], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][11], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][12], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md][13], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md][14], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-execution/Resolve-ToolExecutable.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][17], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 40 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/FileMetaConfig.cs.md][21], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][22], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 15 (text).

### Docs (pwsh/Catzc.Base.Docs, 4 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][23], in the cell pwsh × yaml: selected by [ADR-CONF-LOADING][1]: the file cites it at line 208
  (text).
- [pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][24], in the cell pwsh × powershell: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 38 (text).
- [pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs][25], in the cell pwsh × csharp: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 7 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs][26], in the cell pwsh × csharp: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 8 (body comment) (a passing mention only).

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/dora-explains.md][27], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  11 (text).
- [docs/adr/configuration/module-config-loading.md][1], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][28], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line 236 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][29], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-LOADING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 208 (text),
  `pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 38 (text), `pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs` line 7 (body
  comment), `pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs` line 8 (body comment), `pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs` line 10
  (body comment) and `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 132 (text).

### Globs (pwsh/Catzc.Base.Globs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs][30], in the cell pwsh × csharp: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 10 (body comment) (a passing mention only).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][31], in the cell pwsh × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 132 (text).

## Keywords

- [world map][33]
- [track][34]
- [file language][35]
- [cell][36]
- [lit cell][37]
- [docs][38]: a track
- [pipelines][38]: a track
- [pwsh][38]: a track
- [csharp][39]: a file language
- [markdown][39]: a file language
- [pipeline-yaml][39]: a file language
- [powershell][39]: a file language
- [yaml][39]: a file language

[1]: ../../../../adr/configuration/module-config-loading.md
[2]: ../../../../how-to/getting-started/pwsh/add-a-module.md
[3]: ../../../../how-to/pwsh/manual-test-plan/configs.md
[4]: ../../../../references/pwsh/.assets/invoke-tool-asserts-locked-version/diagram.drawio.md
[5]: ../../../../references/pwsh/.assets/invoke-tool-asserts-locked-version/diagram.drawio.verify.md
[6]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[7]: ../../../../references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[8]: ../../../../references/pwsh/catzc-base-docs/Build-Readme.ps1.md
[9]: ../../../../references/pwsh/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
[10]: ../../../../references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md
[11]: ../../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[12]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[13]: ../../../../references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md
[14]: ../../../../references/pwsh/catzc-base-docs/types/DocsConfig.cs.md
[15]: ../../../../references/pwsh/catzc-base-execution/Resolve-ToolExecutable.ps1.md
[16]: ../../../../references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
[17]: ../../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[18]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[19]: ../../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[20]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[21]: ../../../../references/pwsh/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[22]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[23]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../../../pwsh/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[25]: ../../../../../pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[26]: ../../../../../pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs
[27]: ../../../../adr/configuration/dora-explains.md
[28]: ../../../../adr/index.md
[29]: ../../../../../pipelines/ci-automation.yaml
[30]: ../../../../../pwsh/Catzc.Base.Globs/types/FileKindsConfig.cs
[31]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[32]: ../../three-caches-back-one-reader.md
[33]: ../../../../adr/glossary.md#world-map
[34]: ../../../../adr/glossary.md#track
[35]: ../../../../adr/glossary.md#file-language
[36]: ../../../../adr/glossary.md#cell
[37]: ../../../../adr/glossary.md#lit-cell
[38]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

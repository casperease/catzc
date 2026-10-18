---
catzc:
  immutable:
    with_body_sha: "01f97d54e141"
    repo_status: locked
    path: docs/explanation/configuration/.assets/ask-by-name-get-the-cached-object/tree.md
    source: docs/explanation/configuration/.assets/ask-by-name-get-the-cached-object/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Ask for a config by name and get the cached object back: the tree minimap

```text
Which files cite ADR-CONF-ADDRESSING and ADR-CONF-LOADING: every file of the world map is a tile, grouped by top-level folder.
18 files lit in 6 groups.
```

![The tree minimap of Ask for a config by name and get the cached object back](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [Ask for a config by name and get the cached object back][19], which
explains [ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 18 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 11 lit files
- adr/conf (docs/adr/configuration): 3 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 11 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][3], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md][5], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md][6], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][8], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 63 (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 56 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 40 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][12], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 20 (text).

### adr/conf (docs/adr/configuration, 3 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][1], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][14], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 28 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 11 (text).
- [docs/adr/configuration/module-config-loading.md][2], in the cell docs × markdown: selected by [ADR-CONF-LOADING][2]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][15], in the cell .claude × markdown: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  32 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][16], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 239 (text); selected
  by [ADR-CONF-LOADING][2]: the file cites it at line 238 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][17], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text); selected by
  [ADR-CONF-LOADING][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 208 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][18], in the cell pwsh × yaml: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 209
  (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 208 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [pwsh][25]: a track
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [yaml][26]: a file language

[1]: ../../../../adr/configuration/config-value-addressing.md
[2]: ../../../../adr/configuration/module-config-loading.md
[3]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[4]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[5]: ../../../../references/pwsh/catzc-base-docs/Build-Readme.ps1.md
[6]: ../../../../references/pwsh/catzc-base-docs/types/DocsConfig.cs.md
[7]: ../../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[8]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[9]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[10]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[11]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[12]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[13]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[14]: ../../../../adr/configuration/dora-explains.md
[15]: ../../../../../.claude/plans/decisions-2026-10-16.md
[16]: ../../../../adr/index.md
[17]: ../../../../../pipelines/ci-automation.yaml
[18]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[19]: ../../ask-by-name-get-the-cached-object.md
[20]: ../../../../adr/glossary.md#world-map
[21]: ../../../../adr/glossary.md#track
[22]: ../../../../adr/glossary.md#file-language
[23]: ../../../../adr/glossary.md#cell
[24]: ../../../../adr/glossary.md#lit-cell
[25]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

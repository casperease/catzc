---
catzc:
  immutable:
    with_body_sha: "9ff3a6c54611"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.tree.md
    source: docs/explanation/.assets/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The optIn filter, then link, copy or render, through two write primitives: the tree minimap

```text
Which files cite ADR-REPO-ROOTCFG: every file of the world map is a tile, grouped by top-level folder.
40 files lit in 7 groups.
```

![The tree minimap of The optIn filter, then link, copy or render, through two write primitives](adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [The optIn filter, then link, copy or render, through two write
primitives][41], which explains [ADR-REPO-ROOTCFG][1]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 40 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 33 lit files
- adr/repo (docs/adr/repository): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file
- VSCode (pwsh/Catzc.Base.VSCode): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 33 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-files/Set-FileLink.ps1.md][2], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the file
  cites it at line 24 (text).
- [docs/references/pwsh/catzc-base-git/New-GitIgnore.ps1.md][3], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the file
  cites it at line 24 (text).
- [docs/references/pwsh/catzc-base-git/configs/gitignore.yml.md][4], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][5], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-languages.md][6], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 8 (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][7], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 32 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md][8], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md][9], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-rootconfig.md][11], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 41 (text) and line 50 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Build-RootConfig.ps1.md][12], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]:
  the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-rootconfig/New-GitAttributes.ps1.md][13], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]:
  the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Test-RootAnalyzerSettings.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Test-RootConfigFiles.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-rootconfig/configs/rootconfig.yml.md][16], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-rootconfig/private/Get-RootConfigRenderedFile.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-rootconfig/private/Get-RootConfigTargets.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][20], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-vscode/New-VSCodeExtensions.ps1.md][21], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]:
  the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-vscode/New-VSCodeLaunch.ps1.md][22], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-vscode/New-VSCodeSettings.ps1.md][24], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]:
  the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-vscode/New-VSCodeTasks.ps1.md][25], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-extensions.yml.md][26], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-launch.yml.md][27], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-pipeline-schema.yml.md][28], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md][29], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md][30], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-vscode/types/VscodeLaunchConfig.cs.md][31], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-vscode/types/VscodePipelineSchemaConfig.cs.md][32], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-vscode/types/VscodeSettingsConfig.cs.md][33], in the cell docs × markdown: selected by
  [ADR-REPO-ROOTCFG][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][34], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 398 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][35], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 131
  (text).
- [docs/adr/repository/generated-root-configs.md][1], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][36], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line
  301 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][37], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][1]: the file
  cites it at line 603 (text).

### VSCode (pwsh/Catzc.Base.VSCode, 1 lit file)

The group holds the files of pwsh/Catzc.Base.VSCode; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs][38], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][1]: the file
  cites it at line 8 (body comment) (a passing mention only).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][39], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 325 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][40], in the cell pipelines × pipeline-yaml: selected by [ADR-REPO-ROOTCFG][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 301 (text),
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 603 (text) and `pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs` line 8
  (body comment).

## Keywords

- [world map][42]
- [track][43]
- [file language][44]
- [cell][45]
- [lit cell][46]
- [automation][47]: a track
- [docs][47]: a track
- [pipelines][47]: a track
- [csharp][48]: a file language
- [markdown][48]: a file language
- [pipeline-yaml][48]: a file language
- [yaml][48]: a file language

[1]: ../../../adr/repository/generated-root-configs.md
[2]: ../../../references/pwsh/catzc-base-files/Set-FileLink.ps1.md
[3]: ../../../references/pwsh/catzc-base-git/New-GitIgnore.ps1.md
[4]: ../../../references/pwsh/catzc-base-git/configs/gitignore.yml.md
[5]: ../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[6]: ../../../references/pwsh/catzc-base-languages.md
[7]: ../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[8]: ../../../references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md
[9]: ../../../references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md
[10]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[11]: ../../../references/pwsh/catzc-base-rootconfig.md
[12]: ../../../references/pwsh/catzc-base-rootconfig/Build-RootConfig.ps1.md
[13]: ../../../references/pwsh/catzc-base-rootconfig/New-GitAttributes.ps1.md
[14]: ../../../references/pwsh/catzc-base-rootconfig/Test-RootAnalyzerSettings.ps1.md
[15]: ../../../references/pwsh/catzc-base-rootconfig/Test-RootConfigFiles.ps1.md
[16]: ../../../references/pwsh/catzc-base-rootconfig/configs/rootconfig.yml.md
[17]: ../../../references/pwsh/catzc-base-rootconfig/private/Get-RootConfigRenderedFile.ps1.md
[18]: ../../../references/pwsh/catzc-base-rootconfig/private/Get-RootConfigTargets.ps1.md
[19]: ../../../references/pwsh/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md
[20]: ../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[21]: ../../../references/pwsh/catzc-base-vscode/New-VSCodeExtensions.ps1.md
[22]: ../../../references/pwsh/catzc-base-vscode/New-VSCodeLaunch.ps1.md
[23]: ../../../references/pwsh/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md
[24]: ../../../references/pwsh/catzc-base-vscode/New-VSCodeSettings.ps1.md
[25]: ../../../references/pwsh/catzc-base-vscode/New-VSCodeTasks.ps1.md
[26]: ../../../references/pwsh/catzc-base-vscode/configs/vscode-extensions.yml.md
[27]: ../../../references/pwsh/catzc-base-vscode/configs/vscode-launch.yml.md
[28]: ../../../references/pwsh/catzc-base-vscode/configs/vscode-pipeline-schema.yml.md
[29]: ../../../references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md
[30]: ../../../references/pwsh/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md
[31]: ../../../references/pwsh/catzc-base-vscode/types/VscodeLaunchConfig.cs.md
[32]: ../../../references/pwsh/catzc-base-vscode/types/VscodePipelineSchemaConfig.cs.md
[33]: ../../../references/pwsh/catzc-base-vscode/types/VscodeSettingsConfig.cs.md
[34]: ../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[35]: ../../../adr/repository/dora-explains.md
[36]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[37]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[38]: ../../../../pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
[39]: ../../../adr/index.md
[40]: ../../../../pipelines/ci-automation.yaml
[41]: ../../repository/opted-in-then-link-copy-or-render.md
[42]: ../../../adr/glossary.md#world-map
[43]: ../../../adr/glossary.md#track
[44]: ../../../adr/glossary.md#file-language
[45]: ../../../adr/glossary.md#cell
[46]: ../../../adr/glossary.md#lit-cell
[47]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[48]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

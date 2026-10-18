# The import materialises every root file; two gates catch drift and name the fix: the world-map minimap

```text
Where the files that cite ADR-REPO-ROOTCFG sit in the repository: tracks down, file languages across.
5 of 324 cells lit, holding 49 files.
```

![The world-map minimap of The import materialises every root file; two gates catch drift and name the fix](adr-repo-rootcfg--import-materialises-two-gates-name-the-fix--operations.grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [The import materialises every root file; two gates catch drift
and name the fix][53], which explains [ADR-REPO-ROOTCFG][1]. It lights every cell of the world map that holds a file citing those codes, so
it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 9 lit of 286 files
- automation × powershell: 16 lit of 1619 files
- automation × yaml: 2 lit of 112 files
- docs × markdown: 21 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (9 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][5]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs][6]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs][7]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][8]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs][9]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs][10]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs][11]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 21
  (text).
- [automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs][12]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.VSCode/types/VscodeTasksConfig.cs][13]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 21 (text).

### automation × powershell (16 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Files/Set-FileLink.ps1][14]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 23 (header) and line 39
  (header).
- [automation/Catzc.Base.Git/New-GitIgnore.ps1][15]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (header) and line 39
  (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][16]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 23 (header) and
  line 48 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][17]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line
  23 (header) and line 36 (header).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][18]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 24 (header) and
  line 45 (header).
- [automation/Catzc.Base.RootConfig/New-GitAttributes.ps1][19]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 36 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][20]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22
  (header) and line 27 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][21]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (header)
  and line 29 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][22]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 21 (header) and line 36 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][23]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 21
  (header) and line 28 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][24]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 21 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][25]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (header) and
  line 36 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][26]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 21 (header) and line
  35 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][27]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 22 (header)
  and line 40 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][28]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 23 (header) and
  line 43 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeTasks.ps1][29]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 21 (header) and line
  34 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][30]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 320 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][31]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 622 (text).

### docs × markdown (21 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/index.md][32]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 325 (text).
- [docs/adr/repository/dora-explains.md][33]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 187 (text).
- [docs/adr/repository/generated-root-configs.md][1]: selected by [ADR-REPO-ROOTCFG][1]: the ADR's own file.
- [docs/references/automation/catzc-base-git/configs/gitignore.yml.md][34]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 29
  (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][35]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line
  32 (text).
- [docs/references/automation/catzc-base-languages.md][36]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 41 (text).
- [docs/references/automation/catzc-base-languages/types/GoWorkspaceFile.cs.md][37]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 33 (text).
- [docs/references/automation/catzc-base-languages/types/PythonWorkspaceFile.cs.md][38]: selected by [ADR-REPO-ROOTCFG][1]: the file cites
  it at line 33 (text).
- [docs/references/automation/catzc-base-rootconfig.md][39]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line 16 (text), line 68
  (text) and line 77 (text).
- [docs/references/automation/catzc-base-rootconfig/configs/rootconfig.yml.md][40]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 46 (text).
- [docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md][41]: selected by [ADR-REPO-ROOTCFG][1]: the
  file cites it at line 41 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][42]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it
  at line 32 (text).
- [docs/references/automation/catzc-base-vscode/configs/vscode-extensions.yml.md][43]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it
  at line 36 (text).
- [docs/references/automation/catzc-base-vscode/configs/vscode-launch.yml.md][44]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 29 (text).
- [docs/references/automation/catzc-base-vscode/configs/vscode-pipeline-schema.yml.md][45]: selected by [ADR-REPO-ROOTCFG][1]: the file
  cites it at line 31 (text).
- [docs/references/automation/catzc-base-vscode/configs/vscode-settings.yml.md][46]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 35 (text).
- [docs/references/automation/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md][47]: selected by [ADR-REPO-ROOTCFG][1]: the file cites
  it at line 32 (text).
- [docs/references/automation/catzc-base-vscode/types/VscodeLaunchConfig.cs.md][48]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at
  line 31 (text).
- [docs/references/automation/catzc-base-vscode/types/VscodePipelineSchemaConfig.cs.md][49]: selected by [ADR-REPO-ROOTCFG][1]: the file
  cites it at line 29 (text).
- [docs/references/automation/catzc-base-vscode/types/VscodeSettingsConfig.cs.md][50]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it
  at line 32 (text).
- [docs/references/automation/internal/Catzc.Internal.Importer.psm1.md][51]: selected by [ADR-REPO-ROOTCFG][1]: the file cites it at line
  419 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][52]: selected by [ADR-REPO-ROOTCFG][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 320 (text), `automation/Catzc.Base.Files/Set-FileLink.ps1`
  line 23 (header), `automation/Catzc.Base.Files/Set-FileLink.ps1` line 39 (header), `automation/Catzc.Base.Git/New-GitIgnore.ps1` line 22
  (header), `automation/Catzc.Base.Git/New-GitIgnore.ps1` line 39 (header), `automation/Catzc.Base.Git/types/GitIgnoreConfig.cs` line 22
  (text), `automation/Catzc.Base.Languages/New-GoWorkspace.ps1` line 23 (header), `automation/Catzc.Base.Languages/New-GoWorkspace.ps1` line
  48 (header), `automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs` line 22 (text),
  `automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 622 (text),
  `automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1` line 36 (header),
  `automation/Catzc.Base.RootConfig/Build-RootConfig.ps1` line 24 (header), `automation/Catzc.Base.RootConfig/Build-RootConfig.ps1` line 45
  (header), `automation/Catzc.Base.RootConfig/New-GitAttributes.ps1` line 36 (header),
  `automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1` line 22 (header),
  `automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1` line 27 (header),
  `automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1` line 22 (header), `automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1`
  line 29 (header), `automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1` line 21 (header),
  `automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1` line 36 (header),
  `automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1` line 21 (header),
  `automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1` line 28 (header),
  `automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs` line 22 (text), `automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1` line
  22 (header), `automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1` line 36 (header), `automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1`
  line 21 (header), `automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1` line 35 (header),
  `automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1` line 22 (header), `automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1`
  line 40 (header), `automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1` line 23 (header),
  `automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1` line 43 (header), `automation/Catzc.Base.VSCode/New-VSCodeTasks.ps1` line 21
  (header), `automation/Catzc.Base.VSCode/New-VSCodeTasks.ps1` line 34 (header),
  `automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs` line 22 (text), `automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs`
  line 22 (text), `automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs` line 21 (text),
  `automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs` line 22 (text) and `automation/Catzc.Base.VSCode/types/VscodeTasksConfig.cs`
  line 21 (text).

## Keywords

- [world map][54]
- [track][55]
- [file language][56]
- [cell][57]
- [lit cell][58]
- [automation][59]: a track
- [docs][59]: a track
- [pipelines][59]: a track
- [csharp][60]: a file language
- [markdown][60]: a file language
- [pipeline-yaml][60]: a file language
- [powershell][60]: a file language
- [yaml][60]: a file language

[1]: ../../../adr/repository/generated-root-configs.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[6]: ../../../../automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
[7]: ../../../../automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
[8]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[9]: ../../../../automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
[10]: ../../../../automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
[11]: ../../../../automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
[12]: ../../../../automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
[13]: ../../../../automation/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
[14]: ../../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[15]: ../../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[16]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[17]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[18]: ../../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[19]: ../../../../automation/Catzc.Base.RootConfig/New-GitAttributes.ps1
[20]: ../../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[21]: ../../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[22]: ../../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[23]: ../../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[24]: ../../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[25]: ../../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[26]: ../../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[27]: ../../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[28]: ../../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[29]: ../../../../automation/Catzc.Base.VSCode/New-VSCodeTasks.ps1
[30]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[31]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[32]: ../../../adr/index.md
[33]: ../../../adr/repository/dora-explains.md
[34]: ../../../references/automation/catzc-base-git/configs/gitignore.yml.md
[35]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[36]: ../../../references/automation/catzc-base-languages.md
[37]: ../../../references/automation/catzc-base-languages/types/GoWorkspaceFile.cs.md
[38]: ../../../references/automation/catzc-base-languages/types/PythonWorkspaceFile.cs.md
[39]: ../../../references/automation/catzc-base-rootconfig.md
[40]: ../../../references/automation/catzc-base-rootconfig/configs/rootconfig.yml.md
[41]: ../../../references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md
[42]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[43]: ../../../references/automation/catzc-base-vscode/configs/vscode-extensions.yml.md
[44]: ../../../references/automation/catzc-base-vscode/configs/vscode-launch.yml.md
[45]: ../../../references/automation/catzc-base-vscode/configs/vscode-pipeline-schema.yml.md
[46]: ../../../references/automation/catzc-base-vscode/configs/vscode-settings.yml.md
[47]: ../../../references/automation/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md
[48]: ../../../references/automation/catzc-base-vscode/types/VscodeLaunchConfig.cs.md
[49]: ../../../references/automation/catzc-base-vscode/types/VscodePipelineSchemaConfig.cs.md
[50]: ../../../references/automation/catzc-base-vscode/types/VscodeSettingsConfig.cs.md
[51]: ../../../references/automation/internal/Catzc.Internal.Importer.psm1.md
[52]: ../../../../pipelines/ci-automation.yaml
[53]: ../../repository/import-materialises-two-gates-name-the-fix.md
[54]: ../../../adr/glossary.md#world-map
[55]: ../../../adr/glossary.md#track
[56]: ../../../adr/glossary.md#file-language
[57]: ../../../adr/glossary.md#cell
[58]: ../../../adr/glossary.md#lit-cell
[59]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[60]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

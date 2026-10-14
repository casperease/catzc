# docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md

`Tree minimap: adr-conf-loading--one-reader-one-cache-per-session--meta`

![Tree minimap of adr-conf-loading--one-reader-one-cache-per-session--meta](adr-conf-loading--one-reader-one-cache-per-session--meta.tree.png)

The tree minimap of the slide `adr-conf-loading--one-reader-one-cache-per-session--meta` (meta lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 48 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 27 lit files
- Docs (automation/Catzc.Base.Docs): 8 lit files
- adr/conf (docs/adr/configuration): 3 lit files
- Config (automation/Catzc.Base.Config): 2 lit files
- Git (automation/Catzc.Base.Git): 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Execution (automation/Catzc.Base.Execution): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (27 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md][2], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md][3], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md][4], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text),
  line 31 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text),
  line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md][5], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63
  (text), line 65 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text),
  line 86 (text), line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line
  122 (text), line 129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md][6], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md][8], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text),
  line 31 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text),
  line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md][9], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63
  (text), line 65 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text),
  line 86 (text), line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line
  122 (text), line 129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][10], in the cell docs × markdown: selected
  by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 29 (text) and line 29 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md][11], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][12], in the cell docs × markdown: selected
  by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 43 (text), line 44 (text), line 45 (text), line 48 (text), line 56
  (text), line 157 (text), line 166 (text), line 186 (text), line 191 (text), line 195 (text), line 202 (text), line 249 (text), line 277
  (text), line 338 (text), line 403 (text), line 419 (text), line 701 (text), line 732 (text), line 734 (text), line 737 (text), line 738
  (text), line 741 (text), line 827 (text), line 830 (text), line 832 (text), line 838 (text), line 844 (text), line 846 (text), line 850
  (text), line 852 (text), line 854 (text), line 865 (text) and line 868 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md][13], in the cell docs × markdown: selected
  by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 101 (text), line 128 (text), line 328 (text), line 339 (text), line 344
  (text), line 347 (text), line 358 (text), line 407 (text), line 409 (text), line 411 (text), line 508 (text), line 511 (text), line 514
  (text), line 516 (text), line 518 (text), line 530 (text), line 533 (text), line 538 (text), line 540 (text), line 542 (text), line 556
  (text), line 560 (text), line 652 (text), line 790 (text), line 882 (text), line 929 (text), line 940 (text), line 1077 (text), line 1080
  (text), line 1083 (text), line 1091 (text), line 1092 (text) and line 1130 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md][14], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md][15], in the cell docs × markdown: selected
  by [ADR-CONF-LOADING][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md][16], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text), line 31 (text),
  line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49 (text), line 51
  (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 77 (text),
  line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md][17], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63 (text), line 65
  (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text), line 86 (text),
  line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line 122 (text), line
  129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.chain.md][18], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md][20], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text),
  line 31 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text),
  line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.tree.md][21], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63
  (text), line 65 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text),
  line 86 (text), line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line
  122 (text), line 129 (text), line 136 (text) and line 143 (text).
- [docs/explanation/configuration/ask-by-name-get-the-cached-object.md][22], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 17 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/configuration/callers-depend-on-one-config-module.md][23], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 16 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text) and line 51
  (text).
- [docs/explanation/configuration/one-gate-guards-the-read-path.md][24], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 17 (text), line 29 (text), line 56 (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text) and line
  60 (text).
- [docs/explanation/configuration/one-reader-one-cache-per-session.md][25], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 14 (text), line 40 (text) and line 41 (text).
- [docs/explanation/configuration/three-caches-back-one-reader.md][26], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 19 (text), line 53 (text), line 54 (text), line 55 (text) and line 56 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][27], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 37 (text) and line 56 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][28], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 74 (text).

### Docs (8 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-Readme.ps1][29], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 21 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][30], in the cell automation × yaml: selected by [ADR-CONF-LOADING][1]: the file cites it at
  line 221 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][31], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][32], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][33], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 43 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][34], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][35], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][36], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file cites
  it at line 6 (header).

### adr/conf (3 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][37], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: an ADR file of
  the `configuration` ADR domain, the ADR domain of that code.
- [docs/adr/configuration/dora-explains.md][38], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: an ADR file of the
  `configuration` ADR domain, the ADR domain of that code.
- [docs/adr/configuration/module-config-loading.md][1], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: an ADR file of the
  `configuration` ADR domain, the ADR domain of that code.

### Config (2 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][39], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 8 (header) and line 14 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][40], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 16 (body comment) (a passing mention only).

### Git (2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][41], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][42], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the file
  cites it at line 5 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][43], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][44], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 13 (header).

### Execution (1 lit file)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][45], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 10 (header).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][46], in the cell automation × powershell: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 28 (header).

### RootConfig (1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][47], in the cell automation × csharp: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 5 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][48], in the cell docs × markdown: selected by [ADR-CONF-LOADING][1]: the file cites it at line 206 (text).

## Keywords

- [world map][49]
- [track][50]
- [file language][51]
- [cell][52]
- [lit cell][53]
- [automation][54]: a track
- [docs][54]: a track
- [csharp][55]: a file language
- [markdown][55]: a file language
- [powershell][55]: a file language
- [yaml][55]: a file language

[1]: ../../adr/configuration/module-config-loading.md
[2]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
[3]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md
[4]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
[5]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md
[6]: adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
[7]: adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md
[8]: adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
[9]: adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md
[10]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[11]: adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md
[12]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[13]: adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md
[14]: adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
[15]: adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md
[16]: adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
[17]: adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md
[18]: adr-conf-loading--three-caches-back-one-reader--implementation.chain.md
[19]: adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md
[20]: adr-conf-loading--three-caches-back-one-reader--implementation.grid.md
[21]: adr-conf-loading--three-caches-back-one-reader--implementation.tree.md
[22]: ../../explanation/configuration/ask-by-name-get-the-cached-object.md
[23]: ../../explanation/configuration/callers-depend-on-one-config-module.md
[24]: ../../explanation/configuration/one-gate-guards-the-read-path.md
[25]: ../../explanation/configuration/one-reader-one-cache-per-session.md
[26]: ../../explanation/configuration/three-caches-back-one-reader.md
[27]: ../../how-to/automation/manual-test-plan/configs.md
[28]: ../../how-to/getting-started/automation/add-a-module.md
[29]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[30]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[31]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[32]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[33]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[34]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[35]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[36]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[37]: ../../adr/configuration/config-value-addressing.md
[38]: ../../adr/configuration/dora-explains.md
[39]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[40]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[41]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[42]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[43]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[44]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[45]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[46]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[47]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[48]: ../../adr/index.md
[49]: ../../adr/glossary.md#world-map
[50]: ../../adr/glossary.md#track
[51]: ../../adr/glossary.md#file-language
[52]: ../../adr/glossary.md#cell
[53]: ../../adr/glossary.md#lit-cell
[54]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[55]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

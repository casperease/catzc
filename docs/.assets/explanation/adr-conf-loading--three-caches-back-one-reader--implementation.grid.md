# docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md

`Grid minimap: adr-conf-loading--three-caches-back-one-reader--implementation`

![Grid minimap of adr-conf-loading--three-caches-back-one-reader--implementation](adr-conf-loading--three-caches-back-one-reader--implementation.grid.png)

The grid minimap of the slide `adr-conf-loading--three-caches-back-one-reader--implementation` (implementation lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 5 lit of 219 files
- automation × powershell: 11 lit of 1400 files
- automation × yaml: 1 lit of 95 files
- docs × markdown: 31 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][5]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][6]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][7]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][8]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][9]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 5 (header).

### automation × powershell (11 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][10]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 8 (header) and line
  14 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][11]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 16 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Build-Readme.ps1][12]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][13]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][14]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][15]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 43 (text).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][16]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][17]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][18]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][19]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][20]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  13 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 221 (text).

### docs × markdown (31 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md][22]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md][23]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md][24]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text), line 31 (text), line 38 (text), line
  40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49 (text), line 51 (text), line 52 (text),
  line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 77 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text) and
  line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md][25]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 42 (text), line
  45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63 (text), line 65 (text), line 68 (text),
  line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text), line 86 (text), line 88 (text), line 95
  (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line 122 (text), line 129 (text), line 136
  (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md][26]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md][27]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md][28]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text), line 31 (text),
  line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49 (text), line 51
  (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 77 (text),
  line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md][29]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63 (text), line 65
  (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text), line 86 (text),
  line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line 122 (text), line
  129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][30]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 8 (text), line 29 (text) and line 29 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md][31]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][32]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 8 (text), line 43 (text), line 44 (text), line 45 (text), line 48 (text), line 56 (text), line 157 (text), line 166
  (text), line 186 (text), line 191 (text), line 195 (text), line 202 (text), line 249 (text), line 277 (text), line 338 (text), line 403
  (text), line 419 (text), line 701 (text), line 732 (text), line 734 (text), line 737 (text), line 738 (text), line 741 (text), line 827
  (text), line 830 (text), line 832 (text), line 838 (text), line 844 (text), line 846 (text), line 850 (text), line 852 (text), line 854
  (text), line 865 (text) and line 868 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md][33]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 8 (text), line 101 (text), line 128 (text), line 328 (text), line 339 (text), line 344 (text), line 347 (text), line
  358 (text), line 407 (text), line 409 (text), line 411 (text), line 508 (text), line 511 (text), line 514 (text), line 516 (text), line
  518 (text), line 530 (text), line 533 (text), line 538 (text), line 540 (text), line 542 (text), line 556 (text), line 560 (text), line
  652 (text), line 790 (text), line 882 (text), line 929 (text), line 940 (text), line 1077 (text), line 1080 (text), line 1083 (text), line
  1091 (text), line 1092 (text) and line 1130 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md][34]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md][35]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md][36]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text), line 31 (text), line 38 (text), line 40
  (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49 (text), line 51 (text), line 52 (text),
  line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 77 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text) and
  line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md][37]: selected by [ADR-CONF-LOADING][1]: the
  file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 42 (text), line 45
  (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63 (text), line 65 (text), line 68 (text),
  line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text), line 86 (text), line 88 (text), line 95
  (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line 122 (text), line 129 (text), line 136
  (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.chain.md][38]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md][39]: selected by
  [ADR-CONF-LOADING][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md][40]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text), line 31 (text), line 38 (text), line
  40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49 (text), line 51 (text), line 52 (text),
  line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 77 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text) and
  line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.tree.md][41]: selected by [ADR-CONF-LOADING][1]:
  the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 42 (text), line
  45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63 (text), line 65 (text), line 68 (text),
  line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text), line 86 (text), line 88 (text), line 95
  (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line 122 (text), line 129 (text), line 136
  (text) and line 143 (text).
- [docs/adr/configuration/config-value-addressing.md][42]: selected by [ADR-CONF-LOADING][1]: an ADR file of the `configuration` ADR domain,
  the ADR domain of that code.
- [docs/adr/configuration/dora-explains.md][43]: selected by [ADR-CONF-LOADING][1]: an ADR file of the `configuration` ADR domain, the ADR
  domain of that code.
- [docs/adr/configuration/module-config-loading.md][1]: selected by [ADR-CONF-LOADING][1]: an ADR file of the `configuration` ADR domain,
  the ADR domain of that code.
- [docs/adr/index.md][44]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 206 (text).
- [docs/explanation/configuration/ask-by-name-get-the-cached-object.md][45]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 17
  (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/configuration/callers-depend-on-one-config-module.md][46]: selected by [ADR-CONF-LOADING][1]: the file cites it at line
  16 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/configuration/one-gate-guards-the-read-path.md][47]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 17
  (text), line 29 (text), line 56 (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text) and line 60 (text).
- [docs/explanation/configuration/one-reader-one-cache-per-session.md][48]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 14
  (text), line 40 (text) and line 41 (text).
- [docs/explanation/configuration/three-caches-back-one-reader.md][49]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 19
  (text), line 53 (text), line 54 (text), line 55 (text) and line 56 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][50]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 37 (text) and line
  56 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][51]: selected by [ADR-CONF-LOADING][1]: the file cites it at line 74 (text).

## Keywords

- [world map][52]
- [track][53]
- [file language][54]
- [cell][55]
- [lit cell][56]
- [automation][57]: a track
- [docs][57]: a track
- [csharp][58]: a file language
- [markdown][58]: a file language
- [powershell][58]: a file language
- [yaml][58]: a file language

[1]: ../../adr/configuration/module-config-loading.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[6]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[7]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[8]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[9]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[10]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[11]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[12]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[13]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[14]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[15]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[16]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[17]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[18]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[19]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[21]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[22]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
[23]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md
[24]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
[25]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md
[26]: adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
[27]: adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md
[28]: adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
[29]: adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md
[30]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[31]: adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md
[32]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[33]: adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md
[34]: adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
[35]: adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md
[36]: adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
[37]: adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md
[38]: adr-conf-loading--three-caches-back-one-reader--implementation.chain.md
[39]: adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md
[40]: adr-conf-loading--three-caches-back-one-reader--implementation.grid.md
[41]: adr-conf-loading--three-caches-back-one-reader--implementation.tree.md
[42]: ../../adr/configuration/config-value-addressing.md
[43]: ../../adr/configuration/dora-explains.md
[44]: ../../adr/index.md
[45]: ../../explanation/configuration/ask-by-name-get-the-cached-object.md
[46]: ../../explanation/configuration/callers-depend-on-one-config-module.md
[47]: ../../explanation/configuration/one-gate-guards-the-read-path.md
[48]: ../../explanation/configuration/one-reader-one-cache-per-session.md
[49]: ../../explanation/configuration/three-caches-back-one-reader.md
[50]: ../../how-to/automation/manual-test-plan/configs.md
[51]: ../../how-to/getting-started/automation/add-a-module.md
[52]: ../../adr/glossary.md#world-map
[53]: ../../adr/glossary.md#track
[54]: ../../adr/glossary.md#file-language
[55]: ../../adr/glossary.md#cell
[56]: ../../adr/glossary.md#lit-cell
[57]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# Ask for a config by name and get the cached object back: the world-map minimap

```text
Where the files that cite ADR-CONF-ADDRESSING and ADR-CONF-LOADING sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 46 files.
```

![The world-map minimap of Ask for a config by name and get the cached object back](adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [Ask for a config by name and get the cached object back][50],
which explains [ADR-CONF-ADDRESSING][1] and [ADR-CONF-LOADING][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 90 files
- automation × csharp: 3 lit of 289 files, touched
- automation × powershell: 4 lit of 1629 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 32 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/decisions-2026-10-16.md][6]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 32 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][7]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 283 (text);
  selected by [ADR-CONF-LOADING][2]: the file cites it at line 198 (text).
- [.claude/plans/plan-config-defaults.md][8]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 72 (text), line 169 (text) and
  line 258 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][9]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 18
  (text).
- [.claude/plans/prompt-config-defaults-continue.md][10]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 15 (text) and line 36
  (text).

### automation × csharp (3 lit files, touched)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs][11]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 7 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Docs/types/CapabilityEntry.cs][12]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 8 (body comment)
  (a passing mention only).
- [automation/Catzc.Base.Globs/types/FileKindsConfig.cs][13]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 10 (body comment)
  (a passing mention only).

### automation × powershell (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][14]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 37
  (text) and line 66 (text).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][15]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 38 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][16]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 54 (text).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][17]: selected by [ADR-CONF-LOADING][2]: the file cites it at
  line 132 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][18]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 209 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 208 (text).

### docs × markdown (32 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/configuration/config-value-addressing.md][1]: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][19]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 28 (text); selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 11 (text).
- [docs/adr/configuration/module-config-loading.md][2]: selected by [ADR-CONF-LOADING][2]: the ADR's own file.
- [docs/adr/index.md][20]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 237 (text); selected by [ADR-CONF-LOADING][2]:
  the file cites it at line 236 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][21]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 44 (text) and line
  63 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][22]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 72 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][23]: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 45 (text).
- [docs/references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md][24]: selected by
  [ADR-CONF-LOADING][2]: the file cites it at line 45 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][25]: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 32 (text) and line 95 (text).
- [docs/references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][26]: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 17 (text) and line 21 (text).
- [docs/references/automation/catzc-base-config/Get-ConfigValue.ps1.md][27]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line
  14 (text), line 23 (text), line 25 (text) and line 27 (text); selected by [ADR-CONF-LOADING][2]: the file cites it at line 16 (text) and
  line 20 (text).
- [docs/references/automation/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][28]: selected by [ADR-CONF-ADDRESSING][1]: the file
  cites it at line 14 (text), line 20 (text), line 22 (text) and line 26 (text).
- [docs/references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][29]: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 12 (text).
- [docs/references/automation/catzc-base-docs/Build-Readme.ps1.md][30]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 26
  (text).
- [docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md][31]: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 21 (text).
- [docs/references/automation/catzc-base-docs/private/Get-GlossarySources.ps1.md][32]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 18 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][33]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  16 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][34]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 15
  (text).
- [docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md][35]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 16
  (text).
- [docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md][36]: selected by [ADR-CONF-LOADING][2]: the file cites it at line 16
  (text).
- [docs/references/automation/catzc-base-execution/Resolve-ToolExecutable.ps1.md][37]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 18 (text).
- [docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md][38]: selected by [ADR-CONF-LOADING][2]: the file cites
  it at line 19 (text).
- [docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md][39]: selected by [ADR-CONF-LOADING][2]: the file cites it at line
  15 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][40]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 63 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][41]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 56 (text).
- [docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md][42]: selected by [ADR-CONF-LOADING][2]: the file cites it at
  line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][43]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][44]: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 20 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md][45]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 13 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md][46]: selected by [ADR-CONF-LOADING][2]: the file cites it
  at line 15 (text).
- [docs/references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md][47]: selected by [ADR-CONF-LOADING][2]: the
  file cites it at line 26 (text) and line 93 (text).
- [docs/references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][48]: selected by [ADR-CONF-ADDRESSING][1]: the file
  cites it at line 20 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][49]: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37 (text),
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 209
  (text) and `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text); selected by [ADR-CONF-LOADING][2]: a
  pipeline that cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line
  208 (text), `automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1` line 38 (text),
  `automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs` line 7 (body comment), `automation/Catzc.Base.Docs/types/CapabilityEntry.cs` line
  8 (body comment), `automation/Catzc.Base.Globs/types/FileKindsConfig.cs` line 10 (body comment) and
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 132 (text).

## Keywords

- [world map][51]
- [track][52]
- [file language][53]
- [cell][54]
- [lit cell][55]
- [.claude][56]: a track
- [automation][56]: a track
- [docs][56]: a track
- [pipelines][56]: a track
- [csharp][57]: a file language
- [markdown][57]: a file language
- [pipeline-yaml][57]: a file language
- [powershell][57]: a file language
- [yaml][57]: a file language

[1]: ../../../adr/configuration/config-value-addressing.md
[2]: ../../../adr/configuration/module-config-loading.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/decisions-2026-10-16.md
[7]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[8]: ../../../../.claude/plans/plan-config-defaults.md
[9]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[10]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[11]: ../../../../automation/Catzc.Base.Docs/types/CapabilitiesConfig.cs
[12]: ../../../../automation/Catzc.Base.Docs/types/CapabilityEntry.cs
[13]: ../../../../automation/Catzc.Base.Globs/types/FileKindsConfig.cs
[14]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[15]: ../../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[16]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[17]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[18]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[19]: ../../../adr/configuration/dora-explains.md
[20]: ../../../adr/index.md
[21]: ../../../how-to/automation/manual-test-plan/configs.md
[22]: ../../../how-to/getting-started/automation/add-a-module.md
[23]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[24]: ../../../references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.verify.md
[25]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[26]: ../../../references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[27]: ../../../references/automation/catzc-base-config/Get-ConfigValue.ps1.md
[28]: ../../../references/automation/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[29]: ../../../references/automation/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[30]: ../../../references/automation/catzc-base-docs/Build-Readme.ps1.md
[31]: ../../../references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
[32]: ../../../references/automation/catzc-base-docs/private/Get-GlossarySources.ps1.md
[33]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[34]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[35]: ../../../references/automation/catzc-base-docs/types/AgentsConfig.cs.md
[36]: ../../../references/automation/catzc-base-docs/types/DocsConfig.cs.md
[37]: ../../../references/automation/catzc-base-execution/Resolve-ToolExecutable.ps1.md
[38]: ../../../references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
[39]: ../../../references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
[40]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[41]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[42]: ../../../references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
[43]: ../../../references/automation/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[44]: ../../../references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[45]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
[46]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[47]: ../../../references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
[48]: ../../../references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[49]: ../../../../pipelines/ci-automation.yaml
[50]: ../../configuration/ask-by-name-get-the-cached-object.md
[51]: ../../../adr/glossary.md#world-map
[52]: ../../../adr/glossary.md#track
[53]: ../../../adr/glossary.md#file-language
[54]: ../../../adr/glossary.md#cell
[55]: ../../../adr/glossary.md#lit-cell
[56]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[57]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

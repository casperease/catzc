# docs/explanation/.assets/grid/adr-conf-addressing--type-an-address-get-the-value--operations.grid.md

`Grid minimap: adr-conf-addressing--type-an-address-get-the-value--operations`

![Grid minimap of adr-conf-addressing--type-an-address-get-the-value--operations](adr-conf-addressing--type-an-address-get-the-value--operations.grid.png)

The grid minimap of the slide `adr-conf-addressing--type-an-address-get-the-value--operations` (operations lens). The slide supports
[ADR-AUTO-ENVVAR][1] and [ADR-CONF-ADDRESSING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the
code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 71 files
- .unordered × markdown: 1 lit of 20 files
- automation × powershell: 10 lit of 1579 files
- automation × yaml: 2 lit of 109 files
- docs × markdown: 10 lit of 2165 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-bounded-folder-enumeration.md][6]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 29 (text) and line
  304 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][7]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 504 (text),
  line 526 (text) and line 734 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][8]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 20
  (text) and line 41 (text).

### .unordered × markdown (1 lit file)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-diagram-wave-8.md][9]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 19 (text).

### automation × powershell (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][10]: selected by [ADR-CONF-ADDRESSING][2]: the file cites
  it at line 22 (header), line 30 (header) and line 35 (header).
- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][11]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 20 (header) and line
  46 (header); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 21 (header), line 38 (header), line 41 (header) and line 44
  (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][12]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 20
  (header), line 30 (header), line 32 (header) and line 37 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][13]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 21
  (header), line 62 (text) and line 91 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][14]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 21 (header) and line 78 (text).
- [automation/Catzc.Base.Languages/Invoke-GoTest.ps1][15]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/Invoke-PythonTest.ps1][16]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][17]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][18]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 23 (header).
- [automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1][19]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 21
  (header) and line 52 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 155 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 223 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][21]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 605 (text).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][22]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 433 (text).
- [docs/adr/automation/environment-variables.md][1]: selected by [ADR-AUTO-ENVVAR][1]: the ADR's own file.
- [docs/adr/configuration/config-value-addressing.md][2]: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][23]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 53 (text).
- [docs/adr/index.md][24]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 166 (text); selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 231 (text).
- [docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md][25]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 17
  (text) and line 41 (text).
- [docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md][26]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at
  line 17 (text) and line 50 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][27]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 28 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][28]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 28 (text).
- [docs/references/automation/catzc-tooling-environment.md][29]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 16 (text), line
  28 (text), line 54 (text), line 55 (text) and line 55 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][30]: selected by [ADR-AUTO-ENVVAR][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 20 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 46 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 155 (text),
  `automation/Catzc.Base.Languages/Invoke-GoTest.ps1` line 22 (header), `automation/Catzc.Base.Languages/Invoke-PythonTest.ps1` line 22
  (header), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 605 (text),
  `automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1` line 21 (header) and
  `automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1` line 52 (header); selected by [ADR-CONF-ADDRESSING][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at
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
  (header).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.claude][36]: a track
- [.unordered][36]: a track
- [automation][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [powershell][37]: a file language
- [yaml][37]: a file language

[1]: ../../../adr/automation/environment-variables.md
[2]: ../../../adr/configuration/config-value-addressing.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[7]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[8]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[9]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[10]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[11]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[12]: ../../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[13]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[14]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[15]: ../../../../automation/Catzc.Base.Languages/Invoke-GoTest.ps1
[16]: ../../../../automation/Catzc.Base.Languages/Invoke-PythonTest.ps1
[17]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[18]: ../../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[19]: ../../../../automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1
[20]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[22]: ../../../adr/automation/dora-explains.md
[23]: ../../../adr/configuration/dora-explains.md
[24]: ../../../adr/index.md
[25]: ../../../references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
[26]: ../../../references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md
[27]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[28]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[29]: ../../../references/automation/catzc-tooling-environment.md
[30]: ../../../../pipelines/ci-automation.yaml
[31]: ../../../adr/glossary.md#world-map
[32]: ../../../adr/glossary.md#track
[33]: ../../../adr/glossary.md#file-language
[34]: ../../../adr/glossary.md#cell
[35]: ../../../adr/glossary.md#lit-cell
[36]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

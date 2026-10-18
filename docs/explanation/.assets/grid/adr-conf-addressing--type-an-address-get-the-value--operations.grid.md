# Type an address and get its value back; a wrong address throws its message at the call: the world-map minimap

```text
Where the files that cite ADR-AUTO-ENVVAR and ADR-CONF-ADDRESSING sit in the repository: tracks down, file languages across.
5 of 324 cells lit, holding 28 files.
```

![The world-map minimap of Type an address and get its value back; a wrong address throws its message at the call](adr-conf-addressing--type-an-address-get-the-value--operations.grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [Type an address and get its value back; a wrong address throws
its message at the call][32], which explains [ADR-AUTO-ENVVAR][1] and [ADR-CONF-ADDRESSING][2]. It lights every cell of the world map that
holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code
that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 91 files
- automation × powershell: 10 lit of 1618 files
- automation × yaml: 2 lit of 112 files
- docs × markdown: 12 lit of 2220 files
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

- [.claude/plans/plan-bounded-folder-enumeration.md][6]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 28 (text) and line
  305 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][7]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 564 (text),
  line 586 (text) and line 794 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][8]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 19
  (text) and line 40 (text).

### automation × powershell (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][9]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it
  at line 22 (header), line 30 (header) and line 35 (header).
- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][10]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 20 (header) and line
  46 (header); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 21 (header), line 38 (header), line 41 (header) and line 44
  (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][11]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 20
  (header), line 30 (header), line 32 (header) and line 37 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][12]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 21
  (header), line 62 (text) and line 91 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][13]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 21 (header) and line 78 (text).
- [automation/Catzc.Base.Languages/Invoke-GoTest.ps1][14]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/Invoke-PythonTest.ps1][15]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][16]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][17]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 23 (header).
- [automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1][18]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 21
  (header) and line 52 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][19]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 158 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 228 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][20]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 608 (text).

### docs × markdown (12 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][21]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 453 (text).
- [docs/adr/automation/environment-variables.md][1]: selected by [ADR-AUTO-ENVVAR][1]: the ADR's own file.
- [docs/adr/configuration/config-value-addressing.md][2]: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][22]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 52 (text).
- [docs/adr/index.md][23]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 170 (text); selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 237 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][24]: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 18 (text) and line 67 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][25]: selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 18 (text), line 56 (text) and line 119 (text).
- [docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md][26]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 17
  (text) and line 41 (text).
- [docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md][27]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at
  line 17 (text) and line 50 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][28]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 28 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][29]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 28 (text).
- [docs/references/automation/catzc-tooling-environment.md][30]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 15 (text), line
  27 (text), line 53 (text), line 54 (text) and line 54 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][31]: selected by [ADR-AUTO-ENVVAR][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 20 (header),
  `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 46 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 158 (text),
  `automation/Catzc.Base.Languages/Invoke-GoTest.ps1` line 22 (header), `automation/Catzc.Base.Languages/Invoke-PythonTest.ps1` line 22
  (header), `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 608 (text),
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
  `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 91 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 228
  (text), `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.Languages/New-GoWorkspace.ps1` line 22 (header) and `automation/Catzc.Base.Languages/New-PythonProject.ps1` line 23
  (header).

## Keywords

- [world map][33]
- [track][34]
- [file language][35]
- [cell][36]
- [lit cell][37]
- [.claude][38]: a track
- [automation][38]: a track
- [docs][38]: a track
- [pipelines][38]: a track
- [markdown][39]: a file language
- [pipeline-yaml][39]: a file language
- [powershell][39]: a file language
- [yaml][39]: a file language

[1]: ../../../adr/automation/environment-variables.md
[2]: ../../../adr/configuration/config-value-addressing.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[7]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[8]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[9]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[10]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[11]: ../../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[12]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[13]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[14]: ../../../../automation/Catzc.Base.Languages/Invoke-GoTest.ps1
[15]: ../../../../automation/Catzc.Base.Languages/Invoke-PythonTest.ps1
[16]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[17]: ../../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[18]: ../../../../automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1
[19]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[21]: ../../../adr/automation/dora-explains.md
[22]: ../../../adr/configuration/dora-explains.md
[23]: ../../../adr/index.md
[24]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[25]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[26]: ../../../references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
[27]: ../../../references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md
[28]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[29]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[30]: ../../../references/automation/catzc-tooling-environment.md
[31]: ../../../../pipelines/ci-automation.yaml
[32]: ../../configuration/type-an-address-get-the-value.md
[33]: ../../../adr/glossary.md#world-map
[34]: ../../../adr/glossary.md#track
[35]: ../../../adr/glossary.md#file-language
[36]: ../../../adr/glossary.md#cell
[37]: ../../../adr/glossary.md#lit-cell
[38]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

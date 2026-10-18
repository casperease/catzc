# Type an address and get its value back; a wrong address throws its message at the call: the tree minimap

```text
Which files cite ADR-AUTO-ENVVAR and ADR-CONF-ADDRESSING: every file of the world map is a tile, grouped by top-level folder.
28 files lit in 13 groups.
```

![The tree minimap of Type an address and get its value back; a wrong address throws its message at the call](adr-conf-addressing--type-an-address-get-the-value--operations.tree.png)

This is the tree minimap in the sidebar of the operations diagram of [Type an address and get its value back; a wrong address throws its
message at the call][29], which explains [ADR-AUTO-ENVVAR][1] and [ADR-CONF-ADDRESSING][2]. It lights every file that cites those codes,
grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 28 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 7 lit files
- Languages (automation/Catzc.Base.Languages): 4 lit files
- .claude: 3 lit files
- Config (automation/Catzc.Base.Config): 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Folders (automation/Catzc.Base.Folders): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- Tool.Environment (automation/Catzc.Tooling.Environment): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][3], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 18 (text) and line 67 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][4], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 18 (text), line 56 (text) and line 119 (text).
- [docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md][5], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]:
  the file cites it at line 17 (text) and line 41 (text).
- [docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-AUTO-ENVVAR][1]: the file cites it at line 17 (text) and line 50 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 28 (text).
- [docs/references/automation/catzc-tooling-environment.md][9], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file
  cites it at line 15 (text), line 27 (text), line 53 (text), line 54 (text) and line 54 (text).

### Languages (automation/Catzc.Base.Languages, 4 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Invoke-GoTest.ps1][10], in the cell automation × powershell: selected by [ADR-AUTO-ENVVAR][1]: the file
  cites it at line 22 (header).
- [automation/Catzc.Base.Languages/Invoke-PythonTest.ps1][11], in the cell automation × powershell: selected by [ADR-AUTO-ENVVAR][1]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][12], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][13], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][2]:
  the file cites it at line 23 (header).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-bounded-folder-enumeration.md][14], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][2]: the file
  cites it at line 28 (text) and line 305 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][15], in the cell .claude × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file
  cites it at line 564 (text), line 586 (text) and line 794 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][16], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][2]:
  the file cites it at line 19 (text) and line 40 (text).

### Config (automation/Catzc.Base.Config, 3 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][17], in the cell automation × powershell: selected by [ADR-AUTO-ENVVAR][1]: the file
  cites it at line 20 (header) and line 46 (header); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 21 (header), line 38
  (header), line 41 (header) and line 44 (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][18], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 20 (header), line 30 (header), line 32 (header) and line 37 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][19], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 21 (header), line 62 (text) and line 91 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][20], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 453
  (text).
- [docs/adr/automation/environment-variables.md][1], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the ADR's own file.

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][2], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][21], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 52 (text).

### Az.Templates (automation/Catzc.Azure.Templates, 1 lit file)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][22], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 22 (header), line 30 (header) and line 35 (header).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][23], in the cell automation × yaml: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at
  line 158 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 228 (text).

### Folders (automation/Catzc.Base.Folders, 1 lit file)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 21 (header) and line 78 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][25], in the cell automation × yaml: selected by [ADR-AUTO-ENVVAR][1]: the
  file cites it at line 608 (text).

### Tool.Environment (automation/Catzc.Tooling.Environment, 1 lit file)

The group holds the files of automation/Catzc.Tooling.Environment; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1][26], in the cell automation × powershell: selected by
  [ADR-AUTO-ENVVAR][1]: the file cites it at line 21 (header) and line 52 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][27], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 170 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 237 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][28], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-ENVVAR][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Config/Get-ConfigValue.ps1` line 20 (header),
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

- [world map][30]
- [track][31]
- [file language][32]
- [cell][33]
- [lit cell][34]
- [.claude][35]: a track
- [automation][35]: a track
- [docs][35]: a track
- [pipelines][35]: a track
- [markdown][36]: a file language
- [pipeline-yaml][36]: a file language
- [powershell][36]: a file language
- [yaml][36]: a file language

[1]: ../../../adr/automation/environment-variables.md
[2]: ../../../adr/configuration/config-value-addressing.md
[3]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[4]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[5]: ../../../references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
[6]: ../../../references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md
[7]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[8]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[9]: ../../../references/automation/catzc-tooling-environment.md
[10]: ../../../../automation/Catzc.Base.Languages/Invoke-GoTest.ps1
[11]: ../../../../automation/Catzc.Base.Languages/Invoke-PythonTest.ps1
[12]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[13]: ../../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[14]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[15]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[16]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[17]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[18]: ../../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[19]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[20]: ../../../adr/automation/dora-explains.md
[21]: ../../../adr/configuration/dora-explains.md
[22]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[23]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[25]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[26]: ../../../../automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1
[27]: ../../../adr/index.md
[28]: ../../../../pipelines/ci-automation.yaml
[29]: ../../configuration/type-an-address-get-the-value.md
[30]: ../../../adr/glossary.md#world-map
[31]: ../../../adr/glossary.md#track
[32]: ../../../adr/glossary.md#file-language
[33]: ../../../adr/glossary.md#cell
[34]: ../../../adr/glossary.md#lit-cell
[35]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[36]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "2b41314933b2"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-conf-addressing--type-an-address-get-the-value--operations.tree.md
    source: docs/explanation/.assets/adr-conf-addressing--type-an-address-get-the-value--operations.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Type an address and get its value back; a wrong address throws its message at the call: the tree minimap

```text
Which files cite ADR-AUTO-ENVVAR and ADR-CONF-ADDRESSING: every file of the world map is a tile, grouped by top-level folder.
24 files lit in 10 groups.
```

![The tree minimap of Type an address and get its value back; a wrong address throws its message at the call](adr-conf-addressing--type-an-address-get-the-value--operations.tree.png)

This is the tree minimap in the sidebar of the operations diagram of [Type an address and get its value back; a wrong address throws its
message at the call][25], which explains [ADR-AUTO-ENVVAR][1] and [ADR-CONF-ADDRESSING][2]. It lights every file that cites those codes,
grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 24 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 11 lit files
- .claude: 3 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- Config (automation/Catzc.Base.Config): 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Folders (automation/Catzc.Base.Folders): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 11 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][3], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 45 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][4], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 32 (text) and line 95 (text).
- [docs/references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][5], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 17 (text) and line 21 (text).
- [docs/references/automation/catzc-base-config/Get-ConfigValue.ps1.md][6], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]:
  the file cites it at line 29 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 14 (text), line 23 (text), line 25
  (text) and line 27 (text).
- [docs/references/automation/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 14 (text), line 20 (text), line 22 (text) and line 26 (text).
- [docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md][8], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]:
  the file cites it at line 97 (text).
- [docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-ENVVAR][1]: the file cites it at line 109 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 63 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 56 (text).
- [docs/references/automation/catzc-tooling-environment.md][12], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file
  cites it at line 4 (text), line 30 (text), line 31 (text) and line 31 (text).
- [docs/references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-ENVVAR][1]: the file cites it at line 43 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 20 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-bounded-folder-enumeration.md][14], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][2]: the file
  cites it at line 283 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][15], in the cell .claude × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file
  cites it at line 535 (text), line 557 (text) and line 765 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][16], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][2]:
  the file cites it at line 18 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 383
  (text).
- [docs/adr/automation/environment-variables.md][1], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the ADR's own file.

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][2], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 28 (text).

### Config (automation/Catzc.Base.Config, 1 lit file)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][19], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 37 (text) and line 66 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20], in the cell automation × yaml: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at
  line 139 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 209 (text).

### Folders (automation/Catzc.Base.Folders, 1 lit file)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][21], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 54 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][22], in the cell automation × yaml: selected by [ADR-AUTO-ENVVAR][1]: the
  file cites it at line 589 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][23], in the cell docs × markdown: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 170 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 237 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][24], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-ENVVAR][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 139 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 589 (text); selected by [ADR-CONF-ADDRESSING][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37
  (text), `automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line
  209 (text) and `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text).

## Keywords

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [.claude][31]: a track
- [automation][31]: a track
- [docs][31]: a track
- [pipelines][31]: a track
- [markdown][32]: a file language
- [pipeline-yaml][32]: a file language
- [powershell][32]: a file language
- [yaml][32]: a file language

[1]: ../../../adr/automation/environment-variables.md
[2]: ../../../adr/configuration/config-value-addressing.md
[3]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[4]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[5]: ../../../references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[6]: ../../../references/automation/catzc-base-config/Get-ConfigValue.ps1.md
[7]: ../../../references/automation/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[8]: ../../../references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
[9]: ../../../references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md
[10]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[11]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[12]: ../../../references/automation/catzc-tooling-environment.md
[13]: ../../../references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[14]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[15]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[16]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[17]: ../../../adr/automation/dora-explains.md
[18]: ../../../adr/configuration/dora-explains.md
[19]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[20]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[22]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[23]: ../../../adr/index.md
[24]: ../../../../pipelines/ci-automation.yaml
[25]: ../../configuration/type-an-address-get-the-value.md
[26]: ../../../adr/glossary.md#world-map
[27]: ../../../adr/glossary.md#track
[28]: ../../../adr/glossary.md#file-language
[29]: ../../../adr/glossary.md#cell
[30]: ../../../adr/glossary.md#lit-cell
[31]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[32]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

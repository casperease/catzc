# Strip, split, read once, walk one segment at a time; every wrong turn throws: the tree minimap

```text
Which files cite ADR-CONF-ADDRESSING: every file of the world map is a tile, grouped by top-level folder.
16 files lit in 8 groups.
```

![The tree minimap of Strip, split, read once, walk one segment at a time; every wrong turn throws](tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Strip, split, read once, walk one segment at a time; every wrong
turn throws][17], which explains [ADR-CONF-ADDRESSING][1]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 16 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 8 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Config (pwsh/Catzc.Base.Config): 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Folders (pwsh/Catzc.Base.Folders): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 8 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][2], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 45 (text) and line 45 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 32 (text), line 32 (text), line 95 (text) and line 95 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 17 (text) and line 21 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][5], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 14 (text), line 23 (text), line 25 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 14 (text), line 20 (text), line 22 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][7], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 63 (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 56 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 20 (text).

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][1], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][10], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 28 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][11], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 18 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][12], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 237 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][13], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37 (text),
  `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text) and
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text).

### Config (pwsh/Catzc.Base.Config, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][14], in the cell pwsh × powershell: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 37 (text) and line 66 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][15], in the cell pwsh × yaml: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 209
  (text).

### Folders (pwsh/Catzc.Base.Folders, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][16], in the cell pwsh × powershell: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 54 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [.claude][23]: a track
- [docs][23]: a track
- [pipelines][23]: a track
- [pwsh][23]: a track
- [markdown][24]: a file language
- [pipeline-yaml][24]: a file language
- [powershell][24]: a file language
- [yaml][24]: a file language

[1]: ../../../../adr/configuration/config-value-addressing.md
[2]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[3]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[4]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[5]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[6]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[7]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[8]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[9]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[10]: ../../../../adr/configuration/dora-explains.md
[11]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[12]: ../../../../adr/index.md
[13]: ../../../../../pipelines/ci-automation.yaml
[14]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[15]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[16]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[17]: ../../strip-split-walk-every-wrong-turn-throws.md
[18]: ../../../../adr/glossary.md#world-map
[19]: ../../../../adr/glossary.md#track
[20]: ../../../../adr/glossary.md#file-language
[21]: ../../../../adr/glossary.md#cell
[22]: ../../../../adr/glossary.md#lit-cell
[23]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "17eb261e7338"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.tree.md
    source: docs/explanation/.assets/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Callers in four modules dereference an address through Catzc.Base.Config; the walk stays private: the tree minimap

```text
Which files cite ADR-CONF-ADDRESSING: every file of the world map is a tile, grouped by top-level folder.
17 files lit in 8 groups.
```

![The tree minimap of Callers in four modules dereference an address through Catzc.Base.Config; the walk stays private](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Callers in four modules dereference an address through
Catzc.Base.Config; the walk stays private][18], which explains [ADR-CONF-ADDRESSING][1]. It lights every file that cites those codes,
grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 17 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 8 lit files
- .claude: 2 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- Config (pwsh/Catzc.Base.Config): 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Folders (pwsh/Catzc.Base.Folders): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 8 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][2], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 45 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 32 (text) and line 95 (text).
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

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-bounded-folder-enumeration.md][10], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file
  cites it at line 283 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][11], in the cell .claude × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 18 (text).

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][1], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][12], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 28 (text).

### Config (pwsh/Catzc.Base.Config, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][13], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 37 (text) and line 66 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][14], in the cell automation × yaml: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 209 (text).

### Folders (pwsh/Catzc.Base.Folders, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][15], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 54 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][16], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 237 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][17], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37 (text),
  `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text) and
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text).

## Keywords

- [world map][19]
- [track][20]
- [file language][21]
- [cell][22]
- [lit cell][23]
- [.claude][24]: a track
- [automation][24]: a track
- [docs][24]: a track
- [pipelines][24]: a track
- [markdown][25]: a file language
- [pipeline-yaml][25]: a file language
- [powershell][25]: a file language
- [yaml][25]: a file language

[1]: ../../../../adr/configuration/config-value-addressing.md
[2]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[3]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[4]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[5]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[6]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[7]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[8]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[9]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[10]: ../../../../../.claude/plans/plan-bounded-folder-enumeration.md
[11]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[12]: ../../../../adr/configuration/dora-explains.md
[13]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[14]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[16]: ../../../../adr/index.md
[17]: ../../../../../pipelines/ci-automation.yaml
[18]: ../../callers-in-four-modules-share-one-resolver.md
[19]: ../../../../adr/glossary.md#world-map
[20]: ../../../../adr/glossary.md#track
[21]: ../../../../adr/glossary.md#file-language
[22]: ../../../../adr/glossary.md#cell
[23]: ../../../../adr/glossary.md#lit-cell
[24]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[25]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

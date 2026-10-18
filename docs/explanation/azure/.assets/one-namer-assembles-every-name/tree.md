---
catzc:
  immutable:
    with_body_sha: bb0c28e22e03
    repo_status: locked
    path: docs/explanation/azure/.assets/one-namer-assembles-every-name/tree.md
    source: docs/explanation/azure/.assets/one-namer-assembles-every-name/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One resolver gathers the components and one namer assembles every Azure name: the tree minimap

```text
Which files cite ADR-AZ-NAMING: every file of the world map is a tile, grouped by top-level folder.
23 files lit in 7 groups.
```

![The tree minimap of One resolver gathers the components and one namer assembles every Azure name](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [One resolver gathers the components and one namer assembles every
Azure name][24], which explains [ADR-AZ-NAMING][1]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 23 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 15 lit files
- adr/azure (docs/adr/azure): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Az.Templates (pwsh/Catzc.Azure.Templates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 15 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][2], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 67 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][3], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 43 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][4], in the cell docs × markdown:
  selected by [ADR-AZ-NAMING][1]: the file cites it at line 54 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md][5], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 97 (text), line 108 (text) and line 127 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 29 (text) and line 32 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md][7], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 75 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][8], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 142 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][9], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 28 (text) and line 94 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-AZ-NAMING][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md][11], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 12 (text), line 32 (text) and line 64 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][12], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 32 (text), line 77 (text) and line 111 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][13], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][14], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][15], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][16], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 23 (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/azure-naming-standard.md][1], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 43 (text).

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adr-index.yml][18], in the cell pwsh × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at line 16
  (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][19], in the cell pwsh × yaml: selected by [ADR-AZ-NAMING][1]: the file cites it at line 257
  (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][20], in the cell .claude × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 54 (text) and line 113 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][21], in the cell docs × markdown: selected by [ADR-AZ-NAMING][1]: the file cites it at line 31 (text) and line 282
  (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][22], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-NAMING][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 46
  (text), `pwsh/Catzc.Base.Docs/configs/adr-index.yml` line 16 (body comment) and `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 257 (text).

### Az.Templates (pwsh/Catzc.Azure.Templates, 1 lit file)

The group holds the files of pwsh/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][23], in the cell pwsh × powershell: selected by [ADR-AZ-NAMING][1]: the
  file cites it at line 46 (text).

## Keywords

- [world map][25]
- [track][26]
- [file language][27]
- [cell][28]
- [lit cell][29]
- [.claude][30]: a track
- [docs][30]: a track
- [pipelines][30]: a track
- [pwsh][30]: a track
- [markdown][31]: a file language
- [pipeline-yaml][31]: a file language
- [powershell][31]: a file language
- [yaml][31]: a file language

[1]: ../../../../adr/azure/azure-naming-standard.md
[2]: ../../../../how-to/getting-started/automation/add-a-doc-chapter.md
[3]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[4]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[5]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
[6]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
[7]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md
[8]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[9]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[10]: ../../../../references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[11]: ../../../../references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
[12]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[13]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[14]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[15]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[16]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[17]: ../../../../adr/azure/dora-explains.md
[18]: ../../../../../pwsh/Catzc.Base.Docs/configs/adr-index.yml
[19]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[21]: ../../../../adr/index.md
[22]: ../../../../../pipelines/ci-automation.yaml
[23]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[24]: ../../one-namer-assembles-every-name.md
[25]: ../../../../adr/glossary.md#world-map
[26]: ../../../../adr/glossary.md#track
[27]: ../../../../adr/glossary.md#file-language
[28]: ../../../../adr/glossary.md#cell
[29]: ../../../../adr/glossary.md#lit-cell
[30]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[31]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "08b1cc17960e"
    repo_status: locked
    path: docs/explanation/azure/.assets/one-namer-assembles-every-name/grid.md
    source: docs/explanation/azure/.assets/one-namer-assembles-every-name/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One resolver gathers the components and one namer assembles every Azure name: the world-map minimap

```text
Where the files that cite ADR-AZ-NAMING sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 23 files.
```

![The world-map minimap of One resolver gathers the components and one namer assembles every Azure name](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [One resolver gathers the components and one namer assembles
every Azure name][25], which explains [ADR-AZ-NAMING][1]. It lights every cell of the world map that holds a file citing those codes, so it
shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 18 lit of 2766 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1651 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-explanation-drift-gaps.md][3]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 54 (text) and line 113
  (text).

### docs × markdown (18 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/azure/azure-naming-standard.md][1]: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][4]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 43 (text).
- [docs/adr/index.md][5]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 32 (text) and line 282 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][6]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 67 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][7]: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 43 (text) and line 43 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][8]: selected by [ADR-AZ-NAMING][1]:
  the file cites it at line 54 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md][9]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 97
  (text), line 108 (text) and line 127 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md][10]: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 29 (text) and line 32 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md][11]: selected by [ADR-AZ-NAMING][1]: the file cites it at line
  75 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][12]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 142
  (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][13]: selected by [ADR-AZ-NAMING][1]: the file cites it
  at line 28 (text), line 28 (text), line 94 (text) and line 94 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][14]: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md][15]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 12
  (text), line 32 (text) and line 64 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][16]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 32 (text), line 77
  (text) and line 111 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][17]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][18]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][19]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][20]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 23
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][21]: selected by [ADR-AZ-NAMING][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 46 (text),
  `pwsh/Catzc.Base.Docs/configs/adr-index.yml` line 17 (text) and `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 257 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][22]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 46
  (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adr-index.yml][23]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 17 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][24]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 257 (text).

## Keywords

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [.claude][31]: a track
- [docs][31]: a track
- [pipelines][31]: a track
- [pwsh][31]: a track
- [markdown][32]: a file language
- [pipeline-yaml][32]: a file language
- [powershell][32]: a file language
- [yaml][32]: a file language

[1]: ../../../../adr/azure/azure-naming-standard.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[4]: ../../../../adr/azure/dora-explains.md
[5]: ../../../../adr/index.md
[6]: ../../../../how-to/getting-started/automation/add-a-doc-chapter.md
[7]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[8]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[9]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
[10]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
[11]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md
[12]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[13]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md
[14]: ../../../../references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
[16]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[17]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[18]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[19]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[20]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[21]: ../../../../../pipelines/ci-automation.yaml
[22]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[23]: ../../../../../pwsh/Catzc.Base.Docs/configs/adr-index.yml
[24]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[25]: ../../one-namer-assembles-every-name.md
[26]: ../../../../adr/glossary.md#world-map
[27]: ../../../../adr/glossary.md#track
[28]: ../../../../adr/glossary.md#file-language
[29]: ../../../../adr/glossary.md#cell
[30]: ../../../../adr/glossary.md#lit-cell
[31]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[32]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

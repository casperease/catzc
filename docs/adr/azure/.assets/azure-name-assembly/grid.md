# ADR: Azure resource naming standard: the world-map minimap

```text
Where the files that cite ADR-AZ-NAMING sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 22 files.
```

![The world-map minimap of ADR: Azure resource naming standard](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [ADR: Azure resource naming standard][1], which explains
[ADR-AZ-NAMING][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the
repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- docs × markdown: 18 lit of 2772 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1653 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### docs × markdown (18 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/azure/azure-naming-standard.md][1]: selected by [ADR-AZ-NAMING][1]: the ADR's own file.
- [docs/adr/azure/dora-explains.md][3]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 43 (text).
- [docs/adr/index.md][4]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 32 (text) and line 282 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][5]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 67 (text).
- [docs/references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.verify.md][6]: selected by [ADR-AZ-NAMING][1]: the file
  cites it at line 54 (text).
- [docs/references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md][7]: selected by [ADR-AZ-NAMING][1]: the file cites it at line
  28 (text), line 28 (text), line 94 (text) and line 94 (text).
- [docs/references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.verify.md][8]: selected by [ADR-AZ-NAMING][1]: the file cites it
  at line 43 (text) and line 43 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md][9]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 97
  (text), line 108 (text) and line 127 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md][10]: selected by [ADR-AZ-NAMING][1]: the file cites it at
  line 29 (text) and line 32 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md][11]: selected by [ADR-AZ-NAMING][1]: the file cites it at line
  75 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md][12]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 142
  (text).
- [docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][13]: selected by [ADR-AZ-NAMING][1]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md][14]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 12
  (text), line 32 (text) and line 64 (text).
- [docs/references/pwsh/catzc-azure/configs/azure.yml.md][15]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 32 (text), line 77
  (text) and line 111 (text).
- [docs/references/pwsh/catzc-azure/configs/customer.yml.md][16]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][17]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md][18]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][19]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 23
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][20]: selected by [ADR-AZ-NAMING][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1` line 46 (text),
  `pwsh/Catzc.Base.Docs/configs/adr-index.yml` line 17 (text) and `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 257 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][21]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 46
  (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adr-index.yml][22]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 17 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][23]: selected by [ADR-AZ-NAMING][1]: the file cites it at line 257 (text).

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [docs][29]: a track
- [pipelines][29]: a track
- [pwsh][29]: a track
- [markdown][30]: a file language
- [pipeline-yaml][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

[1]: ../../azure-naming-standard.md
[2]: ../../../design/tracks.md
[3]: ../../dora-explains.md
[4]: ../../../index.md
[5]: ../../../../how-to/getting-started/automation/add-a-doc-chapter.md
[6]: ../../../../references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.verify.md
[7]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md
[8]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.verify.md
[9]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
[10]: ../../../../references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
[11]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md
[12]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
[13]: ../../../../references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[14]: ../../../../references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
[15]: ../../../../references/pwsh/catzc-azure/configs/azure.yml.md
[16]: ../../../../references/pwsh/catzc-azure/configs/customer.yml.md
[17]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[18]: ../../../../references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
[19]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[20]: ../../../../../pipelines/ci-automation.yaml
[21]: ../../../../../pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[22]: ../../../../../pwsh/Catzc.Base.Docs/configs/adr-index.yml
[23]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../glossary.md#world-map
[25]: ../../../glossary.md#track
[26]: ../../../glossary.md#file-language
[27]: ../../../glossary.md#cell
[28]: ../../../glossary.md#lit-cell
[29]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

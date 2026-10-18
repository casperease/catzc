---
catzc:
  immutable:
    with_body_sha: "6bef745558fa"
    repo_status: locked
    path: docs/explanation/configuration/.assets/two-test-files-check-the-address-rules/grid.md
    source: docs/explanation/configuration/.assets/two-test-files-check-the-address-rules/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two L0 test files check the address rules; read-only and committed-only rest on convention: the world-map minimap

```text
Where the files that cite ADR-AUTO-ENVVAR and ADR-CONF-ADDRESSING sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 21 files.
```

![The world-map minimap of Two L0 test files check the address rules; read-only and committed-only rest on convention](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Two L0 test files check the address rules; read-only and
committed-only rest on convention][23], which explains [ADR-AUTO-ENVVAR][1] and [ADR-CONF-ADDRESSING][2]. It lights every cell of the world
map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming
the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 49 files
- docs × markdown: 16 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 2 lit of 1657 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][4]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 86 (text).

### docs × markdown (16 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][5]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 383 (text).
- [docs/adr/automation/environment-variables.md][1]: selected by [ADR-AUTO-ENVVAR][1]: the ADR's own file.
- [docs/adr/configuration/config-value-addressing.md][2]: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][6]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 28 (text).
- [docs/adr/index.md][7]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 170 (text); selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 237 (text).
- [docs/references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md][8]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at
  line 33 (text), line 33 (text), line 96 (text) and line 97 (text).
- [docs/references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.verify.md][9]: selected by [ADR-CONF-ADDRESSING][2]: the file
  cites it at line 45 (text) and line 45 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][10]: selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 18 (text) and line 23 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][11]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 30
  (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 14 (text), line 24 (text), line 26 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][12]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it
  at line 14 (text), line 20 (text), line 22 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md][13]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 97
  (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md][14]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 109
  (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][15]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 63
  (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][16]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line
  56 (text).
- [docs/references/pwsh/catzc-tooling-environment.md][17]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 4 (text), line 31
  (text), line 32 (text) and line 32 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][18]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at
  line 43 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 20 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][19]: selected by [ADR-AUTO-ENVVAR][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 139 (text); selected by [ADR-CONF-ADDRESSING][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37
  (text), `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text)
  and `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][20]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 37 (text)
  and line 66 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][21]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 54
  (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][22]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 139 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 209 (text).

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [.claude][29]: a track
- [docs][29]: a track
- [pipelines][29]: a track
- [pwsh][29]: a track
- [markdown][30]: a file language
- [pipeline-yaml][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

[1]: ../../../../adr/automation/environment-variables.md
[2]: ../../../../adr/configuration/config-value-addressing.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[5]: ../../../../adr/automation/dora-explains.md
[6]: ../../../../adr/configuration/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.md
[9]: ../../../../references/pwsh/.assets/bicep-template-is-a-folder/diagram.drawio.verify.md
[10]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[11]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[12]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[13]: ../../../../references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md
[14]: ../../../../references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md
[15]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[16]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[17]: ../../../../references/pwsh/catzc-tooling-environment.md
[18]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[19]: ../../../../../pipelines/ci-automation.yaml
[20]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[21]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[22]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[23]: ../../two-test-files-check-the-address-rules.md
[24]: ../../../../adr/glossary.md#world-map
[25]: ../../../../adr/glossary.md#track
[26]: ../../../../adr/glossary.md#file-language
[27]: ../../../../adr/glossary.md#cell
[28]: ../../../../adr/glossary.md#lit-cell
[29]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "109448218ebd"
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
5 of 342 cells lit, holding 23 files.
```

![The world-map minimap of Two L0 test files check the address rules; read-only and committed-only rest on convention](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Two L0 test files check the address rules; read-only and
committed-only rest on convention][27], which explains [ADR-AUTO-ENVVAR][1] and [ADR-CONF-ADDRESSING][2]. It lights every cell of the world
map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming
the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 89 files
- docs × markdown: 16 lit of 2756 files
- pipelines × pipeline-yaml: 1 lit of 9 files
- pwsh × powershell: 2 lit of 1648 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][6]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 216 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][7]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 18
  (text).

### docs × markdown (16 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][8]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 383 (text).
- [docs/adr/automation/environment-variables.md][1]: selected by [ADR-AUTO-ENVVAR][1]: the ADR's own file.
- [docs/adr/configuration/config-value-addressing.md][2]: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][9]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 28 (text).
- [docs/adr/index.md][10]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 170 (text); selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 237 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][11]: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 45 (text).
- [docs/references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][12]: selected by [ADR-CONF-ADDRESSING][2]: the file
  cites it at line 32 (text) and line 95 (text).
- [docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md][13]: selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 17 (text) and line 21 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][14]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 29
  (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 14 (text), line 23 (text), line 25 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][15]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it
  at line 14 (text), line 20 (text), line 22 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md][16]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 97
  (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md][17]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 109
  (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][18]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 63
  (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][19]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line
  56 (text).
- [docs/references/pwsh/catzc-tooling-environment.md][20]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 4 (text), line 30
  (text), line 31 (text) and line 31 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][21]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at
  line 43 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 20 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][22]: selected by [ADR-AUTO-ENVVAR][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 139 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 591 (text); selected by [ADR-CONF-ADDRESSING][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 37 (text),
  `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` line 66 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text) and
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 54 (text).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][23]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 37 (text)
  and line 66 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][24]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 54
  (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][25]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 139 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 209 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][26]: selected by [ADR-AUTO-ENVVAR][1]: the file cites it at line 591 (text).

## Keywords

- [world map][28]
- [track][29]
- [file language][30]
- [cell][31]
- [lit cell][32]
- [.claude][33]: a track
- [docs][33]: a track
- [pipelines][33]: a track
- [pwsh][33]: a track
- [markdown][34]: a file language
- [pipeline-yaml][34]: a file language
- [powershell][34]: a file language
- [yaml][34]: a file language

[1]: ../../../../adr/automation/environment-variables.md
[2]: ../../../../adr/configuration/config-value-addressing.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[7]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[8]: ../../../../adr/automation/dora-explains.md
[9]: ../../../../adr/configuration/dora-explains.md
[10]: ../../../../adr/index.md
[11]: ../../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[12]: ../../../../references/pwsh/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[13]: ../../../../references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
[14]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[15]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[16]: ../../../../references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md
[17]: ../../../../references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md
[18]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[19]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[20]: ../../../../references/pwsh/catzc-tooling-environment.md
[21]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[22]: ../../../../../pipelines/ci-automation.yaml
[23]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[24]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[25]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[26]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[27]: ../../two-test-files-check-the-address-rules.md
[28]: ../../../../adr/glossary.md#world-map
[29]: ../../../../adr/glossary.md#track
[30]: ../../../../adr/glossary.md#file-language
[31]: ../../../../adr/glossary.md#cell
[32]: ../../../../adr/glossary.md#lit-cell
[33]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[34]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

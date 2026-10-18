---
catzc:
  immutable:
    with_body_sha: be6241f25317
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-conf-addressing--an-address-is-a-read-only-walk--meta.grid.md
    source: docs/explanation/.assets/adr-conf-addressing--an-address-is-a-read-only-walk--meta.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A config address is a read-only walk over the one cached config, never a second reader: the world-map minimap

```text
Where the files that cite ADR-CONF-ADDRESSING sit in the repository: tracks down, file languages across.
5 of 324 cells lit, holding 18 files.
```

![The world-map minimap of A config address is a read-only walk over the one cached config, never a second reader](adr-conf-addressing--an-address-is-a-read-only-walk--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A config address is a read-only walk over the one cached config, never
a second reader][22], which explains [ADR-CONF-ADDRESSING][1]. It lights every cell of the world map that holds a file citing those codes,
so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 91 files
- automation × powershell: 7 lit of 1619 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 7 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-bounded-folder-enumeration.md][5]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 28 (text) and line
  305 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][6]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 19
  (text) and line 40 (text).

### automation × powershell (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][7]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it
  at line 22 (header), line 30 (header) and line 35 (header).
- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][8]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 21 (header), line
  38 (header), line 41 (header) and line 44 (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][9]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 20
  (header), line 30 (header), line 32 (header) and line 37 (header).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][10]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 21
  (header), line 62 (text) and line 91 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][11]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 21 (header) and line 78 (text).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][12]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][13]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 23 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 228 (text).

### docs × markdown (7 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/configuration/config-value-addressing.md][1]: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][15]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 52 (text).
- [docs/adr/index.md][16]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 237 (text).
- [docs/references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md][17]: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 18 (text) and line 67 (text).
- [docs/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md][18]: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 18 (text), line 56 (text) and line 119 (text).
- [docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md][19]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 28 (text).
- [docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md][20]: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at
  line 28 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][21]: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1` line 22 (header),
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

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [.claude][28]: a track
- [automation][28]: a track
- [docs][28]: a track
- [pipelines][28]: a track
- [markdown][29]: a file language
- [pipeline-yaml][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

[1]: ../../../adr/configuration/config-value-addressing.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[6]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[7]: ../../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[8]: ../../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[9]: ../../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[10]: ../../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[11]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[12]: ../../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[13]: ../../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[14]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../adr/configuration/dora-explains.md
[16]: ../../../adr/index.md
[17]: ../../../references/.assets/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
[18]: ../../../references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
[19]: ../../../references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
[20]: ../../../references/automation/catzc-base-languages/New-PythonProject.ps1.md
[21]: ../../../../pipelines/ci-automation.yaml
[22]: ../../configuration/an-address-is-a-read-only-walk.md
[23]: ../../../adr/glossary.md#world-map
[24]: ../../../adr/glossary.md#track
[25]: ../../../adr/glossary.md#file-language
[26]: ../../../adr/glossary.md#cell
[27]: ../../../adr/glossary.md#lit-cell
[28]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

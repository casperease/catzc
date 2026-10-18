---
catzc:
  immutable:
    with_body_sha: "7d69f21a21ae"
    repo_status: locked
    path: docs/explanation/flow/.assets/globs-asks-loader-for-context-and-git-for-diff/grid.md
    source: docs/explanation/flow/.assets/globs-asks-loader-for-context-and-git-for-diff/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Catzc.Base.Globs owns the check, the loader names the context, and git names the change: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-DETECT and ADR-FLOW-CD-GLOBS sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 28 files.
```

![The world-map minimap of Catzc.Base.Globs owns the check, the loader names the context, and git names the change](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [Catzc.Base.Globs owns the check, the loader names the context,
and git names the change][30], which explains [ADR-FLOW-CD-DETECT][1] and [ADR-FLOW-CD-GLOBS][2]. It lights every cell of the world map that
holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code
that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 89 files
- docs × markdown: 24 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/plans/plan-explanation-drift-gaps.md][4]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 109 (text).

### docs × markdown (24 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/flow/dora-explains.md][5]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 49 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][1]: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.
- [docs/adr/index.md][6]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 133 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 135 (text).
- [docs/references/pipelines/cd-apex.yaml.md][7]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][8]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][9]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][10]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][11]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][12]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][13]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][14]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][15]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][16]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][17]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][18]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][19]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][20]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][21]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][22]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][23]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][25]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][26]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][27]: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][28]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 99 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][29]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1076 (text).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.claude][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [pwsh][36]: a track
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [yaml][37]: a file language

[1]: ../../../../adr/flow/pipeline-detection.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[5]: ../../../../adr/flow/dora-explains.md
[6]: ../../../../adr/index.md
[7]: ../../../../references/pipelines/cd-apex.yaml.md
[8]: ../../../../references/pipelines/cd-flux.yaml.md
[9]: ../../../../references/pipelines/cd-nova.yaml.md
[10]: ../../../../references/pipelines/cd-shared.yaml.md
[11]: ../../../../references/pipelines/ci-automation.yaml.md
[12]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[13]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[14]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[16]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[17]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[18]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[19]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[20]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[21]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[22]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[23]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[24]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[25]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[26]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[27]: ../../../../../pipelines/ci-automation.yaml
[28]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[30]: ../../globs-asks-loader-for-context-and-git-for-diff.md
[31]: ../../../../adr/glossary.md#world-map
[32]: ../../../../adr/glossary.md#track
[33]: ../../../../adr/glossary.md#file-language
[34]: ../../../../adr/glossary.md#cell
[35]: ../../../../adr/glossary.md#lit-cell
[36]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

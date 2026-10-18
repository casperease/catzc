---
catzc:
  immutable:
    with_body_sha: ba2da2d96b4a
    repo_status: locked
    path: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/grid.md
    source: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the world-map minimap

```text
Where the files that cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS sit in the repository: tracks down, file languages across.
4 of 342 cells lit, holding 43 files.
```

![The world-map minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to
one pipeline is held by review alone][44], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 8 lit of 89 files
- docs × markdown: 32 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (8 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [.claude/plans/decisions-2026-10-16.md][4]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45 (text), line 53 (text), line 116
  (text), line 117 (text), line 121 (text), line 121 (text) and line 131 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 22 (text), line 193 (text) and line 193 (text).
- [.claude/plans/decisions-2026-10-18.md][5]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text).
- [.claude/plans/plan-adr-code-language.md][6]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text) and line 36 (text).
- [.claude/plans/plan-diagram-folders.md][7]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 44 (text) and line 82 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 109 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 109 (text).
- [.claude/plans/prompt-diagram-folders-2-adrs.md][9]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 15 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 79 (text) and line 90 (text).
- [.claude/plans/task-diagram-folders.md][11]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 62 (text).

### docs × markdown (32 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [docs/adr/design/dora-explains.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][13]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/index.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 110 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 135 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 320 (text).
- [docs/adr/repository/conventional-folders.md][3]: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][15]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 11 (text).
- [docs/references/note-file-kind.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 37 (text).
- [docs/references/pipelines/cd-apex.yaml.md][17]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][18]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][19]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][20]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][21]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][22]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][23]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][25]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][26]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][27]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][28]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][29]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][30]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][31]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][32]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][33]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][34]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (text).
- [docs/references/pwsh/catzc-base-languages.md][35]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 45 (text) and line 75
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md][36]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 75
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pipelines/ci-automation.yaml][41]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text); selected by [ADR-REPO-FOLDERS][3]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 294 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 294 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][43]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1076 (text).

## Keywords

- [world map][45]
- [track][46]
- [file language][47]
- [cell][48]
- [lit cell][49]
- [.claude][50]: a track
- [docs][50]: a track
- [pipelines][50]: a track
- [pwsh][50]: a track
- [markdown][51]: a file language
- [pipeline-yaml][51]: a file language
- [yaml][51]: a file language

[1]: ../../../../adr/design/tracks.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../adr/repository/conventional-folders.md
[4]: ../../../../../.claude/plans/decisions-2026-10-16.md
[5]: ../../../../../.claude/plans/decisions-2026-10-18.md
[6]: ../../../../../.claude/plans/plan-adr-code-language.md
[7]: ../../../../../.claude/plans/plan-diagram-folders.md
[8]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[9]: ../../../../../.claude/plans/prompt-diagram-folders-2-adrs.md
[10]: ../../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[11]: ../../../../../.claude/plans/task-diagram-folders.md
[12]: ../../../../adr/design/dora-explains.md
[13]: ../../../../adr/flow/dora-explains.md
[14]: ../../../../adr/index.md
[15]: ../../../../adr/repository/dora-explains.md
[16]: ../../../../references/note-file-kind.md
[17]: ../../../../references/pipelines/cd-apex.yaml.md
[18]: ../../../../references/pipelines/cd-flux.yaml.md
[19]: ../../../../references/pipelines/cd-nova.yaml.md
[20]: ../../../../references/pipelines/cd-shared.yaml.md
[21]: ../../../../references/pipelines/ci-automation.yaml.md
[22]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[23]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[24]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[25]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[26]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[27]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[28]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[29]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[30]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[31]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[32]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[33]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[34]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[35]: ../../../../references/pwsh/catzc-base-languages.md
[36]: ../../../../references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[37]: ../../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[38]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[39]: ../../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[40]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[41]: ../../../../../pipelines/ci-automation.yaml
[42]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[43]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[44]: ../../unit-to-pipeline-rule-is-review-only.md
[45]: ../../../../adr/glossary.md#world-map
[46]: ../../../../adr/glossary.md#track
[47]: ../../../../adr/glossary.md#file-language
[48]: ../../../../adr/glossary.md#cell
[49]: ../../../../adr/glossary.md#lit-cell
[50]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[51]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

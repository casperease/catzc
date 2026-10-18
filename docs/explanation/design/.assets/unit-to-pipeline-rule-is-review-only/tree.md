---
catzc:
  immutable:
    with_body_sha: c8a678739b86
    repo_status: locked
    path: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/tree.md
    source: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the tree minimap

```text
Which files cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS: every file of the world map is a tile, grouped by top-level folder.
43 files lit in 9 groups.
```

![The tree minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to one
pipeline is held by review alone][44], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights every
file that cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the
code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 43 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 25 lit files
- .claude: 8 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 25 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/note-file-kind.md][4], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 37 (text).
- [docs/references/pipelines/cd-apex.yaml.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][14], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][15], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][16], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][19], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-languages.md][23], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 45 (text) and line 75 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][25], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][26], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 75 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][27], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][28], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 32 (text).

### .claude (8 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/decisions-2026-10-16.md][29], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 45
  (text), line 53 (text), line 116 (text), line 117 (text), line 121 (text), line 121 (text) and line 131 (text); selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text), line 193 (text) and line 193 (text).
- [.claude/plans/decisions-2026-10-18.md][30], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text).
- [.claude/plans/plan-adr-code-language.md][31], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  36 (text) and line 36 (text).
- [.claude/plans/plan-diagram-folders.md][32], in the cell .claude × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  44 (text) and line 82 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][33], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 109 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 109 (text).
- [.claude/plans/prompt-diagram-folders-2-adrs.md][34], in the cell .claude × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it
  at line 15 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][35], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 28 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 79 (text) and line 90 (text).
- [.claude/plans/task-diagram-folders.md][36], in the cell .claude × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  62 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][37], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92
  (text).
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/conventional-folders.md][3], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][39], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 11
  (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][40], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 110 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 135 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 320 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][41], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text);
  selected by [ADR-REPO-FOLDERS][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 294 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][42], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 294 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][43], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 1076 (text).

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
[4]: ../../../../references/note-file-kind.md
[5]: ../../../../references/pipelines/cd-apex.yaml.md
[6]: ../../../../references/pipelines/cd-flux.yaml.md
[7]: ../../../../references/pipelines/cd-nova.yaml.md
[8]: ../../../../references/pipelines/cd-shared.yaml.md
[9]: ../../../../references/pipelines/ci-automation.yaml.md
[10]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[11]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[12]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[13]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[14]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[16]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[17]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[18]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[19]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[20]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[21]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[22]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[23]: ../../../../references/pwsh/catzc-base-languages.md
[24]: ../../../../references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[25]: ../../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[26]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[27]: ../../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[28]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[29]: ../../../../../.claude/plans/decisions-2026-10-16.md
[30]: ../../../../../.claude/plans/decisions-2026-10-18.md
[31]: ../../../../../.claude/plans/plan-adr-code-language.md
[32]: ../../../../../.claude/plans/plan-diagram-folders.md
[33]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[34]: ../../../../../.claude/plans/prompt-diagram-folders-2-adrs.md
[35]: ../../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[36]: ../../../../../.claude/plans/task-diagram-folders.md
[37]: ../../../../adr/design/dora-explains.md
[38]: ../../../../adr/flow/dora-explains.md
[39]: ../../../../adr/repository/dora-explains.md
[40]: ../../../../adr/index.md
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

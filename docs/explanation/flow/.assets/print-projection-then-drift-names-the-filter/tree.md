---
catzc:
  immutable:
    with_body_sha: d3c68f324495
    repo_status: locked
    path: docs/explanation/flow/.assets/print-projection-then-drift-names-the-filter/tree.md
    source: docs/explanation/flow/.assets/print-projection-then-drift-names-the-filter/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Print the projection, and a drifted pipeline fails naming the filter that differs: the tree minimap

```text
Which files cite ADR-FLOW-CD-GLOBS: every file of the world map is a tile, grouped by top-level folder.
25 files lit in 7 groups.
```

![The tree minimap of Print the projection, and a drifted pipeline fails naming the filter that differs](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [Print the projection, and a drifted pipeline fails naming the filter
that differs][26], which explains [ADR-FLOW-CD-GLOBS][1]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 25 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 18 lit files
- adr/flow (docs/adr/flow): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 18 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pipelines/cd-apex.yaml.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][5], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][11], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][12], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][13], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][19], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 20 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 92
  (text).
- [docs/adr/flow/durable-sha-globs.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][21], in the cell .claude × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 109 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 135 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][23], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1076 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][24], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 101
  (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][25], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 1076 (text).

## Keywords

- [world map][27]
- [track][28]
- [file language][29]
- [cell][30]
- [lit cell][31]
- [.claude][32]: a track
- [docs][32]: a track
- [pipelines][32]: a track
- [pwsh][32]: a track
- [markdown][33]: a file language
- [pipeline-yaml][33]: a file language
- [yaml][33]: a file language

[1]: ../../../../adr/flow/durable-sha-globs.md
[2]: ../../../../references/pipelines/cd-apex.yaml.md
[3]: ../../../../references/pipelines/cd-flux.yaml.md
[4]: ../../../../references/pipelines/cd-nova.yaml.md
[5]: ../../../../references/pipelines/cd-shared.yaml.md
[6]: ../../../../references/pipelines/ci-automation.yaml.md
[7]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[8]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[9]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[10]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[11]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[12]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[13]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[14]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[15]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[16]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[17]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[18]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[19]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[20]: ../../../../adr/flow/dora-explains.md
[21]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[22]: ../../../../adr/index.md
[23]: ../../../../../pipelines/ci-automation.yaml
[24]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[25]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[26]: ../../print-projection-then-drift-names-the-filter.md
[27]: ../../../../adr/glossary.md#world-map
[28]: ../../../../adr/glossary.md#track
[29]: ../../../../adr/glossary.md#file-language
[30]: ../../../../adr/glossary.md#cell
[31]: ../../../../adr/glossary.md#lit-cell
[32]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[33]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

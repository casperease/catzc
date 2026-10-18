---
catzc:
  immutable:
    with_body_sha: "9e526572898e"
    repo_status: locked
    path: docs/explanation/flow/.assets/one-boolean-answer-from-one-function/tree.md
    source: docs/explanation/flow/.assets/one-boolean-answer-from-one-function/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One function answers "am I in a pipeline?", and every branch on context asks it: the tree minimap

```text
Which files cite ADR-FLOW-CD-DETECT: every file of the world map is a tile, grouped by top-level folder.
21 files lit in 8 groups.
```

![The tree minimap of One function answers "am I in a pipeline?", and every branch on context asks it](tree.png)

This is the tree minimap in the sidebar of the meta diagram of [One function answers "am I in a pipeline?", and every branch on context asks
it][22], which explains [ADR-FLOW-CD-DETECT][1]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 21 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 10 lit files
- .claude: 4 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file
  cites it at line 4 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 26 (text) and line 109 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md][4], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the
  file cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][9], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]:
  the file cites it at line 54 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][12], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][13], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it
  at line 18 (text).
- [.claude/plans/plan-promotion-ladder.md][14], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at
  line 11 (text) and line 38 (text).
- [.claude/plans/value-of-plan.md][15], in the cell .claude × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 33
  (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11
  (text) and line 49 (text).
- [docs/adr/flow/pipeline-detection.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 129 (text) and line
  131 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][18], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][19], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 97
  (text) and line 99 (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][20], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-DETECT][1]: the
  file cites it at line 70 (text) and line 71 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][21], in the cell pwsh × yaml: selected by [ADR-FLOW-CD-DETECT][1]: the file
  cites it at line 11 (text).

## Keywords

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [.claude][28]: a track
- [docs][28]: a track
- [pipelines][28]: a track
- [pwsh][28]: a track
- [markdown][29]: a file language
- [pipeline-yaml][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

[1]: ../../../../adr/flow/pipeline-detection.md
[2]: ../../../../how-to/automation/apply-environment-approvals.md
[3]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md
[4]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md
[5]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[6]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[7]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[8]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[9]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[10]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[11]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[12]: ../../../../../.claude/CLAUDE.md
[13]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[14]: ../../../../../.claude/plans/plan-promotion-ladder.md
[15]: ../../../../../.claude/plans/value-of-plan.md
[16]: ../../../../adr/flow/dora-explains.md
[17]: ../../../../adr/index.md
[18]: ../../../../../pipelines/ci-automation.yaml
[19]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[21]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[22]: ../../one-boolean-answer-from-one-function.md
[23]: ../../../../adr/glossary.md#world-map
[24]: ../../../../adr/glossary.md#track
[25]: ../../../../adr/glossary.md#file-language
[26]: ../../../../adr/glossary.md#cell
[27]: ../../../../adr/glossary.md#lit-cell
[28]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

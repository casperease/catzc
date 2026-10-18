---
catzc:
  immutable:
    with_body_sha: fe5392ae1dbe
    repo_status: locked
    path: docs/explanation/design/.assets/sync-point-rules-are-adr-only/tree.md
    source: docs/explanation/design/.assets/sync-point-rules-are-adr-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only BVT has a gate in code; the sync-point rules are ADR-only: the tree minimap

```text
Which files cite ADR-DSGN-LIFE and ADR-FLOW-CD: every file of the world map is a tile, grouped by top-level folder.
31 files lit in 10 groups.
```

![The tree minimap of Only BVT has a gate in code; the sync-point rules are ADR-only](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Only BVT has a gate in code; the sync-point rules are ADR-only][32],
which explains [ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 31 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 9 lit files
- .claude: 8 lit files
- pipelines: 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 2 lit files
- Maps (pwsh/Catzc.Base.Maps): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 9 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 4 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 40 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 28 (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][8], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 54 (text).

### .claude (8 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][12], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][13], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 126
  (text), line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][14], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 36 (text) and line 79 (text).
- [.claude/plans/plan-fast-push-followups.md][15], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line
  12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][16], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12
  (text), line 34 (text) and line 82 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 12 (text), line 34 (text) and line 82
  (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][17], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 20 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][18], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 55
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][19], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 36 (text)
  and line 43 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 36 (text).

### pipelines (3 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][20], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text);
  selected by [ADR-FLOW-CD][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18
  (text) and `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 58 (text).
- [pipelines/deploy-apex.yaml][21], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][2]: the file cites it at line 14 (body
  comment) (a passing mention only).
- [pipelines/deploy-shared.yaml][22], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD][2]: the file cites it at line 14
  (body comment) (a passing mention only).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line 345
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 505 (text) and line 518 (text).
- [docs/adr/index.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 129 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][25], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][26], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 11 (text).

### Docs (pwsh/Catzc.Base.Docs, 2 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][27], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 97 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][28], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484
  (text).

### Maps (pwsh/Catzc.Base.Maps, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][29], in the cell pwsh × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 70 (text) and line 71 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][30], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 49 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 18 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][31], in the cell pwsh × yaml: selected by [ADR-FLOW-CD][2]: the file cites it at line
  58 (text).

## Keywords

- [world map][33]
- [track][34]
- [file language][35]
- [cell][36]
- [lit cell][37]
- [.claude][38]: a track
- [docs][38]: a track
- [pipelines][38]: a track
- [pwsh][38]: a track
- [markdown][39]: a file language
- [pipeline-yaml][39]: a file language
- [powershell][39]: a file language
- [yaml][39]: a file language

Terms the cited ADRs define:

- [gate][40], defined by [ADR-FLOW-CD#13][41]
- [occupant][42], defined by [ADR-DSGN-LIFE#5][43]
- [release candidate][44], defined by [ADR-FLOW-CD#14][45]
- [staging slot][46], defined by [ADR-DSGN-LIFE#5][43]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../../../how-to/automation/apply-environment-approvals.md
[4]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[5]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[6]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[7]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[8]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[9]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[10]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[11]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[12]: ../../../../../.claude/CLAUDE.md
[13]: ../../../../../.claude/plans/plan-adr-code-language.md
[14]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[15]: ../../../../../.claude/plans/plan-fast-push-followups.md
[16]: ../../../../../.claude/plans/plan-promotion-ladder.md
[17]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[18]: ../../../../../.claude/plans/task-loose-ends.md
[19]: ../../../../../.claude/plans/value-of-plan.md
[20]: ../../../../../pipelines/ci-automation.yaml
[21]: ../../../../../pipelines/deploy-apex.yaml
[22]: ../../../../../pipelines/deploy-shared.yaml
[23]: ../../../../adr/glossary.md
[24]: ../../../../adr/index.md
[25]: ../../../../adr/design/dora-explains.md
[26]: ../../../../adr/flow/dora-explains.md
[27]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[28]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[29]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[30]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[31]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[32]: ../../sync-point-rules-are-adr-only.md
[33]: ../../../../adr/glossary.md#world-map
[34]: ../../../../adr/glossary.md#track
[35]: ../../../../adr/glossary.md#file-language
[36]: ../../../../adr/glossary.md#cell
[37]: ../../../../adr/glossary.md#lit-cell
[38]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[40]: ../../../../adr/glossary.md#gate
[41]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[42]: ../../../../adr/glossary.md#occupant
[43]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[44]: ../../../../adr/glossary.md#release-candidate
[45]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[46]: ../../../../adr/glossary.md#staging-slot

---
catzc:
  immutable:
    with_body_sha: "4c4ea3a17dd5"
    repo_status: locked
    path: docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself/grid.md
    source: docs/explanation/flow/.assets/cd-builds-once-then-deploys-prod-itself/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The customer CD pipeline builds once, then deploys the prod tier itself: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 26 files.
```

![The world-map minimap of The customer CD pipeline builds once, then deploys the prod tier itself](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [The customer CD pipeline builds once, then deploys the prod
tier itself][30], which explains [ADR-FLOW-CD][1]. It lights every cell of the world map that holds a file citing those codes, so it shows
where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 12 lit of 2761 files
- pipelines × pipeline-yaml: 3 lit of 13 files
- pwsh × powershell: 1 lit of 1649 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (7 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 126 (text), line 127 (text), line
  128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 36 (text) and line 79 (text).
- [.claude/plans/plan-promotion-ladder.md][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text), line 34 (text) and line 82
  (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 36 (text).

### docs × markdown (12 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 11 (text).
- [docs/adr/glossary.md][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 505 (text) and line 518 (text).
- [docs/adr/index.md][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text).
- [docs/how-to/automation/apply-environment-approvals.md][15]: selected by [ADR-FLOW-CD][1]: the file cites it at line 4 (text).
- [docs/references/pipelines/steps/download-artifact.yaml.md][16]: selected by [ADR-FLOW-CD][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 40 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text), line
  29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 37
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (3 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][23]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line
  70 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18 (text) and `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 58 (text).
- [pipelines/deploy-apex.yaml][24]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14 (body comment) (a passing mention only).
- [pipelines/deploy-shared.yaml][25]: selected by [ADR-FLOW-CD][1]: the file cites it at line 14 (body comment) (a passing mention only).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][26]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text) and
  line 71 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][27]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][28]: selected by [ADR-FLOW-CD][1]: the file cites it at line 18 (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][29]: selected by [ADR-FLOW-CD][1]: the file cites it at line 58 (text).

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
- [powershell][37]: a file language
- [yaml][37]: a file language

Terms the cited ADRs define:

- [gate][38], defined by [ADR-FLOW-CD#13][39]
- [release candidate][40], defined by [ADR-FLOW-CD#14][41]

[1]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../.claude/CLAUDE.md
[6]: ../../../../../.claude/plans/plan-adr-code-language.md
[7]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[8]: ../../../../../.claude/plans/plan-promotion-ladder.md
[9]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[10]: ../../../../../.claude/plans/task-loose-ends.md
[11]: ../../../../../.claude/plans/value-of-plan.md
[12]: ../../../../adr/flow/dora-explains.md
[13]: ../../../../adr/glossary.md
[14]: ../../../../adr/index.md
[15]: ../../../../how-to/automation/apply-environment-approvals.md
[16]: ../../../../references/pipelines/steps/download-artifact.yaml.md
[17]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[18]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[19]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[20]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[21]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[22]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[23]: ../../../../../pipelines/ci-automation.yaml
[24]: ../../../../../pipelines/deploy-apex.yaml
[25]: ../../../../../pipelines/deploy-shared.yaml
[26]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[27]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[28]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[29]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[30]: ../../cd-builds-once-then-deploys-prod-itself.md
[31]: ../../../../adr/glossary.md#world-map
[32]: ../../../../adr/glossary.md#track
[33]: ../../../../adr/glossary.md#file-language
[34]: ../../../../adr/glossary.md#cell
[35]: ../../../../adr/glossary.md#lit-cell
[36]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[38]: ../../../../adr/glossary.md#gate
[39]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[40]: ../../../../adr/glossary.md#release-candidate
[41]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

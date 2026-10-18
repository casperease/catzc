---
catzc:
  immutable:
    with_body_sha: "4d4d8913f185"
    repo_status: locked
    path: docs/explanation/design/.assets/sync-point-rules-are-adr-only/grid.md
    source: docs/explanation/design/.assets/sync-point-rules-are-adr-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only BVT has a gate in code; the sync-point rules are ADR-only: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE and ADR-FLOW-CD sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 20 files.
```

![The world-map minimap of Only BVT has a gate in code; the sync-point rules are ADR-only](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Only BVT has a gate in code; the sync-point rules are
ADR-only][22], which explains [ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 10 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1651 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (7 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][5]: selected by [ADR-FLOW-CD][2]: the file cites it at line 126 (text), line 127 (text), line
  128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][6]: selected by [ADR-FLOW-CD][2]: the file cites it at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text), line 34 (text) and line
  94 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 12 (text), line 35 (text) and line 94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 20 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 55 (text); selected by [ADR-FLOW-CD][2]:
  the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 35 (text); selected by [ADR-FLOW-CD][2]:
  the file cites it at line 35 (text).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][12]: selected by [ADR-FLOW-CD][2]: the file cites it at line 11 (text).
- [docs/adr/index.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 114 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 131 (text).
- [docs/how-to/automation/apply-environment-approvals.md][14]: selected by [ADR-FLOW-CD][2]: the file cites it at line 4 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][15]: selected by [ADR-FLOW-CD][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][16]: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text), line
  29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][17]: selected by [ADR-FLOW-CD][2]: the file cites it at line 37
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][18]: selected by [ADR-FLOW-CD][2]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][19]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text); selected by [ADR-FLOW-CD][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text) and
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][20]: selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and
  line 71 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 97 (text).

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

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/plan-adr-code-language.md
[6]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[7]: ../../../../../.claude/plans/plan-promotion-ladder.md
[8]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[9]: ../../../../../.claude/plans/task-loose-ends.md
[10]: ../../../../../.claude/plans/value-of-plan.md
[11]: ../../../../adr/design/dora-explains.md
[12]: ../../../../adr/flow/dora-explains.md
[13]: ../../../../adr/index.md
[14]: ../../../../how-to/automation/apply-environment-approvals.md
[15]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[16]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[17]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[18]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[19]: ../../../../../pipelines/ci-automation.yaml
[20]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[21]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../sync-point-rules-are-adr-only.md
[23]: ../../../../adr/glossary.md#world-map
[24]: ../../../../adr/glossary.md#track
[25]: ../../../../adr/glossary.md#file-language
[26]: ../../../../adr/glossary.md#cell
[27]: ../../../../adr/glossary.md#lit-cell
[28]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

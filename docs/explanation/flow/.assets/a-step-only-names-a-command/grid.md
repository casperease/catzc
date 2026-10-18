---
catzc:
  immutable:
    with_body_sha: "0f7dd22bfc5f"
    repo_status: locked
    path: docs/explanation/flow/.assets/a-step-only-names-a-command/grid.md
    source: docs/explanation/flow/.assets/a-step-only-names-a-command/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A pipeline step only names a command that a developer can run locally: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-RUNNER sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 19 files.
```

![The world-map minimap of A pipeline step only names a command that a developer can run locally](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A pipeline step only names a command that a developer can run
locally][21], which explains [ADR-FLOW-CD-RUNNER][1]. It lights every cell of the world map that holds a file citing those codes, so it
shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 9 lit of 2767 files
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

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/CLAUDE.md][3]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 55 (text) and line 56 (text).
- [.claude/plans/plan-adr-code-language.md][4]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 126 (text), line 126 (text),
  line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][5]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 12 (text), line 35 (text) and
  line 94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 20 (text).
- [.claude/plans/task-loose-ends.md][8]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 35 (text).

### docs × markdown (9 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/flow/dora-explains.md][10]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 11 (text) and line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][11]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 129 (text) and line 130 (text).
- [docs/how-to/automation/apply-environment-approvals.md][12]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 4 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][13]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][14]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][15]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28
  (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][16]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][17]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][18]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98
  (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text) and
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][19]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 70 (text)
  and line 71 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][20]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 97 (text) and line 98 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [.claude][27]: a track
- [docs][27]: a track
- [pipelines][27]: a track
- [pwsh][27]: a track
- [markdown][28]: a file language
- [pipeline-yaml][28]: a file language
- [powershell][28]: a file language
- [yaml][28]: a file language

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/CLAUDE.md
[4]: ../../../../../.claude/plans/plan-adr-code-language.md
[5]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[6]: ../../../../../.claude/plans/plan-promotion-ladder.md
[7]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[8]: ../../../../../.claude/plans/task-loose-ends.md
[9]: ../../../../../.claude/plans/value-of-plan.md
[10]: ../../../../adr/flow/dora-explains.md
[11]: ../../../../adr/index.md
[12]: ../../../../how-to/automation/apply-environment-approvals.md
[13]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[14]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[15]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[16]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[17]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[18]: ../../../../../pipelines/ci-automation.yaml
[19]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[20]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../a-step-only-names-a-command.md
[22]: ../../../../adr/glossary.md#world-map
[23]: ../../../../adr/glossary.md#track
[24]: ../../../../adr/glossary.md#file-language
[25]: ../../../../adr/glossary.md#cell
[26]: ../../../../adr/glossary.md#lit-cell
[27]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

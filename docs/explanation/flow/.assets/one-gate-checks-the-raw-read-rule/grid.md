---
catzc:
  immutable:
    with_body_sha: "8bb3fd1b0f22"
    repo_status: locked
    path: docs/explanation/flow/.assets/one-gate-checks-the-raw-read-rule/grid.md
    source: docs/explanation/flow/.assets/one-gate-checks-the-raw-read-rule/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The analyzer checks rule 1, a test checks rule 4, and rules 2, 3 and 5 have no gate: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-DETECT sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 24 files.
```

![The world-map minimap of The analyzer checks rule 1, a test checks rule 4, and rules 2, 3 and 5 have no gate](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [The analyzer checks rule 1, a test checks rule 4, and rules 2, 3
and 5 have no gate][26], which explains [ADR-FLOW-CD-DETECT][1]. It lights every cell of the world map that holds a file citing those codes,
so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 13 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1651 files
- pwsh × yaml: 2 lit of 115 files

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

- [.claude/CLAUDE.md][3]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-adr-code-language.md][4]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 126 (text), line 127 (text),
  line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][5]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][6]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 12 (text), line 35 (text) and
  line 87 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][7]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 21 (text).
- [.claude/plans/task-loose-ends.md][8]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 59 (text).
- [.claude/plans/value-of-plan.md][9]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 34 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/flow/dora-explains.md][10]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text) and line 49 (text).
- [docs/adr/flow/pipeline-detection.md][1]: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.
- [docs/adr/index.md][11]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 129 (text) and line 131 (text).
- [docs/how-to/automation/apply-environment-approvals.md][12]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 4 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][13]: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][14]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][15]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at
  line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][16]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 28
  (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][17]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][18]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 26 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][19]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][20]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][21]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][22]: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99
  (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][23]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 70 (text)
  and line 71 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][24]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 97 (text) and line 99 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][25]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text).

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
- [powershell][33]: a file language
- [yaml][33]: a file language

[1]: ../../../../adr/flow/pipeline-detection.md
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
[13]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[14]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[15]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[16]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[17]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[18]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md
[19]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[20]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[21]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[22]: ../../../../../pipelines/ci-automation.yaml
[23]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[24]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[25]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[26]: ../../one-gate-checks-the-raw-read-rule.md
[27]: ../../../../adr/glossary.md#world-map
[28]: ../../../../adr/glossary.md#track
[29]: ../../../../adr/glossary.md#file-language
[30]: ../../../../adr/glossary.md#cell
[31]: ../../../../adr/glossary.md#lit-cell
[32]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[33]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

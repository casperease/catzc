---
catzc:
  immutable:
    with_body_sha: ee94bef09196
    repo_status: locked
    path: docs/explanation/flow/.assets/the-analyzer-names-the-raw-read/grid.md
    source: docs/explanation/flow/.assets/the-analyzer-names-the-raw-read/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A raw read fails Test-ScriptAnalyzer with one Error line, and CI step 2e asserts the seam: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-DETECT sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 21 files.
```

![The world-map minimap of A raw read fails Test-ScriptAnalyzer with one Error line, and CI step 2e asserts the seam](grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [A raw read fails Test-ScriptAnalyzer with one Error line, and CI
step 2e asserts the seam][23], which explains [ADR-FLOW-CD-DETECT][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 4 lit of 64 files
- docs × markdown: 13 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1653 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (4 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/CLAUDE.md][3]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][4]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 17 (text).
- [.claude/plans/plan-promotion-ladder.md][5]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text) and line 38 (text).
- [.claude/plans/value-of-plan.md][6]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 33 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/flow/dora-explains.md][7]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text) and line 49 (text).
- [docs/adr/flow/pipeline-detection.md][1]: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.
- [docs/adr/index.md][8]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 129 (text) and line 131 (text).
- [docs/how-to/automation/apply-environment-approvals.md][9]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 4 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md][10]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it
  at line 26 (text) and line 109 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md][11]: selected by [ADR-FLOW-CD-DETECT][1]: the file
  cites it at line 55 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][12]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][13]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at
  line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][14]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 28
  (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][15]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][16]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][17]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][18]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][19]: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99
  (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][20]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 70 (text)
  and line 71 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 97 (text) and line 99 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][22]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text).

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [.claude][29]: a track
- [docs][29]: a track
- [pipelines][29]: a track
- [pwsh][29]: a track
- [markdown][30]: a file language
- [pipeline-yaml][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

[1]: ../../../../adr/flow/pipeline-detection.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/CLAUDE.md
[4]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[5]: ../../../../../.claude/plans/plan-promotion-ladder.md
[6]: ../../../../../.claude/plans/value-of-plan.md
[7]: ../../../../adr/flow/dora-explains.md
[8]: ../../../../adr/index.md
[9]: ../../../../how-to/automation/apply-environment-approvals.md
[10]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md
[11]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md
[12]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[13]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[14]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[15]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[16]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[17]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[18]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[19]: ../../../../../pipelines/ci-automation.yaml
[20]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[21]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[23]: ../../the-analyzer-names-the-raw-read.md
[24]: ../../../../adr/glossary.md#world-map
[25]: ../../../../adr/glossary.md#track
[26]: ../../../../adr/glossary.md#file-language
[27]: ../../../../adr/glossary.md#cell
[28]: ../../../../adr/glossary.md#lit-cell
[29]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

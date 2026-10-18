---
catzc:
  immutable:
    with_body_sha: "8a994d9a4772"
    repo_status: locked
    path: docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four/grid.md
    source: docs/explanation/flow/.assets/no-gate-checks-rules-one-and-four/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# No gate checks the runner rules 1 or 4, and the step template breaks rule 3: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 30 files.
```

![The world-map minimap of No gate checks the runner rules 1 or 4, and the step template breaks rule 3](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [No gate checks the runner rules 1 or 4, and the step template
breaks rule 3][32], which explains [ADR-FLOW-CD-RUNNER][1] and [ADR-PIPE-NAME][2]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 7 lit of 89 files
- docs × markdown: 16 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 3 lit of 1651 files
- pwsh × yaml: 3 lit of 115 files

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

- [.claude/CLAUDE.md][4]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 55 (text) and line 56 (text).
- [.claude/plans/plan-adr-code-language.md][5]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 126 (text), line 126 (text),
  line 127 (text), line 128 (text), line 181 (text) and line 184 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 36 (text).
- [.claude/plans/plan-promotion-ladder.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 12 (text), line 35 (text) and
  line 87 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][8]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 21 (text).
- [.claude/plans/task-loose-ends.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 59 (text).
- [.claude/plans/value-of-plan.md][10]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 34 (text).

### docs × markdown (16 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/flow/dora-explains.md][11]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 11 (text) and line 31 (text).
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: the ADR's own file.
- [docs/adr/index.md][12]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 129 (text) and line 130 (text); selected by
  [ADR-PIPE-NAME][2]: the file cites it at line 252 (text).
- [docs/adr/pipelines/dora-explains.md][13]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45 (text).
- [docs/adr/pipelines/pipeline-naming-and-placement.md][2]: selected by [ADR-PIPE-NAME][2]: the ADR's own file.
- [docs/how-to/automation/apply-environment-approvals.md][14]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][15]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 14 (text).
- [docs/references/pipelines/extends/cd-customer.yaml.md][16]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/steps/invoke-automation.yaml.md][17]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][18]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md][19]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 15 (text),
  line 22 (text), line 25 (text), line 29 (text), line 32 (text), line 34 (text), line 40 (text), line 76 (text), line 86 (text), line 96
  (text), line 105 (text), line 114 (text) and line 123 (text).
- [docs/references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md][20]: selected by [ADR-PIPE-NAME][2]: the file cites
  it at line 23 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][21]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 28
  (text), line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][22]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 45
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][23]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][24]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][25]: selected by [ADR-FLOW-CD-RUNNER][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 98
  (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text) and
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text); selected by [ADR-PIPE-NAME][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 51 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 56 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 63 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 68 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 71 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 75 (text), `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 78 (text),
  `pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1` line 85 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 48 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 57
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 60 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 64 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 72 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 74 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 77
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 79 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 82 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 84 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 87 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 89
  (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 92 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`
  line 94 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 102 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 105 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line
  116 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 121 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 225
  (text), `pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 9 (header) and
  `pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml` line 8 (header).

### pwsh × powershell (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1][26]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 51 (text), line 56 (text),
  line 63 (text), line 68 (text), line 71 (text), line 75 (text), line 78 (text) and line 85 (text).
- [pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][27]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 47 (text), line 48
  (text), line 57 (text), line 60 (text), line 64 (text), line 72 (text), line 74 (text), line 77 (text), line 79 (text), line 82 (text),
  line 84 (text), line 87 (text), line 89 (text), line 92 (text), line 94 (text), line 102 (text), line 105 (text), line 116 (text) and line
  121 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][28]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 70 (text)
  and line 71 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][29]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 97 (text) and line 98 (text);
  selected by [ADR-PIPE-NAME][2]: the file cites it at line 225 (text).
- [pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][30]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 9 (header).
- [pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml][31]: selected by [ADR-PIPE-NAME][2]: the file cites it at line 8 (header).

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

[1]: ../../../../adr/flow/pipeline-runner-pattern.md
[2]: ../../../../adr/pipelines/pipeline-naming-and-placement.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/plan-adr-code-language.md
[6]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[7]: ../../../../../.claude/plans/plan-promotion-ladder.md
[8]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[9]: ../../../../../.claude/plans/task-loose-ends.md
[10]: ../../../../../.claude/plans/value-of-plan.md
[11]: ../../../../adr/flow/dora-explains.md
[12]: ../../../../adr/index.md
[13]: ../../../../adr/pipelines/dora-explains.md
[14]: ../../../../how-to/automation/apply-environment-approvals.md
[15]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[16]: ../../../../references/pipelines/extends/cd-customer.yaml.md
[17]: ../../../../references/pipelines/steps/invoke-automation.yaml.md
[18]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[19]: ../../../../references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md
[21]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[22]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[23]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[24]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[25]: ../../../../../pipelines/ci-automation.yaml
[26]: ../../../../../pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1
[27]: ../../../../../pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[28]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[29]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[30]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[31]: ../../../../../pwsh/Catzc.Base.RootConfig/assets/root/.prettierrc.yml
[32]: ../../no-gate-checks-rules-one-and-four.md
[33]: ../../../../adr/glossary.md#world-map
[34]: ../../../../adr/glossary.md#track
[35]: ../../../../adr/glossary.md#file-language
[36]: ../../../../adr/glossary.md#cell
[37]: ../../../../adr/glossary.md#lit-cell
[38]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

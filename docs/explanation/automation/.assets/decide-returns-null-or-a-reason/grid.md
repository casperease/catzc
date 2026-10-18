---
catzc:
  immutable:
    with_body_sha: "5267688a9967"
    repo_status: locked
    path: docs/explanation/automation/.assets/decide-returns-null-or-a-reason/grid.md
    source: docs/explanation/automation/.assets/decide-returns-null-or-a-reason/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Main loads the limits and the run environment, then Decide returns null or a reason: the world-map minimap

```text
Where the files that cite ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 35 files.
```

![The world-map minimap of Main loads the limits and the run environment, then Decide returns null or a reason](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Main loads the limits and the run environment, then Decide
returns null or a reason][37], which explains [ADR-AUTO-FAILFAST][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 63 files
- docs × markdown: 23 lit of 2766 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 6 lit of 1653 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/CLAUDE.md][3]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][4]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text).

### docs × markdown (23 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/automation/dora-explains.md][5]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/index.md][6]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 102 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 63 (text).
- [docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.verify.md][10]: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][14]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][15]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][17]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][18]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][19]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][20]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md][21]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23
  (text), line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][22]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-typessystem.md][23]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][24]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][25]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][26]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 12
  (text) and line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][27]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 55
  (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text),
  `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47 (text), `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line
  64 (text), `pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1` line 30 (text),
  `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 152 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line
  160 (text), `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44 (text) and
  `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 133 (text).

### pwsh × powershell (6 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][28]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 47 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][29]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][30]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 30
  (text).
- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][31]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 152 (text) and
  line 160 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][32]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 44 (text).
- [pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][33]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 133
  (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][34]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 132 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][35]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 55 (text) and line 76 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][36]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 4 (text).

## Keywords

- [world map][38]
- [track][39]
- [file language][40]
- [cell][41]
- [lit cell][42]
- [.claude][43]: a track
- [docs][43]: a track
- [pipelines][43]: a track
- [pwsh][43]: a track
- [markdown][44]: a file language
- [pipeline-yaml][44]: a file language
- [powershell][44]: a file language
- [yaml][44]: a file language

[1]: ../../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/CLAUDE.md
[4]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[5]: ../../../../adr/automation/dora-explains.md
[6]: ../../../../adr/index.md
[7]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md
[8]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md
[9]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md
[10]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.verify.md
[11]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[12]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[13]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[14]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[15]: ../../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[16]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[17]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[18]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[19]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[20]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[21]: ../../../../references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
[22]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[23]: ../../../../references/pwsh/catzc-base-typessystem.md
[24]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[25]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[26]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[27]: ../../../../../pipelines/ci-automation.yaml
[28]: ../../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[29]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[30]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[31]: ../../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[32]: ../../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[33]: ../../../../../pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[34]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[35]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[36]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[37]: ../../decide-returns-null-or-a-reason.md
[38]: ../../../../adr/glossary.md#world-map
[39]: ../../../../adr/glossary.md#track
[40]: ../../../../adr/glossary.md#file-language
[41]: ../../../../adr/glossary.md#cell
[42]: ../../../../adr/glossary.md#lit-cell
[43]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[44]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: "5a95fba769ce"
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
5 of 342 cells lit, holding 40 files.
```

![The world-map minimap of Main loads the limits and the run environment, then Decide returns null or a reason](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Main loads the limits and the run environment, then Decide
returns null or a reason][42], which explains [ADR-AUTO-FAILFAST][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 9 lit of 89 files
- docs × markdown: 23 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 4 lit of 1651 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (9 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/CLAUDE.md][3]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text).
- [.claude/plans/decisions-2026-10-16.md][4]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 39 (text), line 39 (text), line
  161 (text) and line 168 (text).
- [.claude/plans/plan-adr-code-language.md][5]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 31 (text), line 32 (text),
  line 37 (text), line 39 (text), line 89 (text), line 89 (text), line 90 (text), line 90 (text), line 92 (text), line 92 (text), line 93
  (text), line 93 (text), line 105 (text), line 105 (text), line 106 (text), line 107 (text), line 108 (text) and line 108 (text).
- [.claude/plans/plan-assert-wait.md][6]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (text), line 33 (text), line 41
  (text), line 86 (text), line 88 (text), line 89 (text), line 89 (text), line 129 (text), line 131 (text), line 140 (text) and line 140
  (text).
- [.claude/plans/plan-explanation-drift-gaps.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 51 (text), line 65 (text)
  and line 106 (text).
- [.claude/plans/prompt-assert-wait-1-watch-blocking.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 18 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text).
- [.claude/plans/questionnaire-2026-10-16.md][10]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text).
- [.claude/plans/task-assert-wait.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 53 (text) and line 59 (text).

### docs × markdown (23 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/automation/dora-explains.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/index.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][14]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][15]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][17]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 102 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][18]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][19]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][20]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][21]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][22]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][23]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][24]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][25]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][26]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][27]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md][28]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23
  (text), line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][29]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-typessystem.md][30]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][31]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][32]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][33]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 12
  (text) and line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][34]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 55
  (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text),
  `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47 (text), `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line
  64 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 152 (text),
  `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 160 (text) and `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44
  (text).

### pwsh × powershell (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][35]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 47 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][36]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).
- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][37]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 152 (text) and
  line 160 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][38]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 44 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][39]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 132 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][40]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 55 (text) and line 76 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][41]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 4 (text).

## Keywords

- [world map][43]
- [track][44]
- [file language][45]
- [cell][46]
- [lit cell][47]
- [.claude][48]: a track
- [docs][48]: a track
- [pipelines][48]: a track
- [pwsh][48]: a track
- [markdown][49]: a file language
- [pipeline-yaml][49]: a file language
- [powershell][49]: a file language
- [yaml][49]: a file language

[1]: ../../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/CLAUDE.md
[4]: ../../../../../.claude/plans/decisions-2026-10-16.md
[5]: ../../../../../.claude/plans/plan-adr-code-language.md
[6]: ../../../../../.claude/plans/plan-assert-wait.md
[7]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[8]: ../../../../../.claude/plans/prompt-assert-wait-1-watch-blocking.md
[9]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[10]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[11]: ../../../../../.claude/plans/task-assert-wait.md
[12]: ../../../../adr/automation/dora-explains.md
[13]: ../../../../adr/index.md
[14]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[15]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[16]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[17]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md
[18]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[19]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[20]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[21]: ../../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[22]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md
[23]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[24]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[25]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[26]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[27]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[28]: ../../../../references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
[29]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[30]: ../../../../references/pwsh/catzc-base-typessystem.md
[31]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[32]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[33]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[34]: ../../../../../pipelines/ci-automation.yaml
[35]: ../../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[36]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[37]: ../../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[38]: ../../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[39]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[40]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[41]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[42]: ../../decide-returns-null-or-a-reason.md
[43]: ../../../../adr/glossary.md#world-map
[44]: ../../../../adr/glossary.md#track
[45]: ../../../../adr/glossary.md#file-language
[46]: ../../../../adr/glossary.md#cell
[47]: ../../../../adr/glossary.md#lit-cell
[48]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[49]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

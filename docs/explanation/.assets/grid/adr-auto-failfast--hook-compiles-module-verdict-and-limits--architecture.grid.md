# The hook compiles the module's own verdict and limit types, so the agent side and the pwsh side agree: the world-map minimap

```text
Where the files that cite ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 47 files.
```

![The world-map minimap of The hook compiles the module's own verdict and limit types, so the agent side and the pwsh side agree](adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [The hook compiles the module's own verdict and limit types, so
the agent side and the pwsh side agree][51], which explains [ADR-AUTO-FAILFAST][1]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 12 lit of 91 files
- automation × csharp: 2 lit of 286 files
- automation × powershell: 16 lit of 1618 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 12 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (12 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 115 (text).
- [.claude/plans/decisions-2026-10-16.md][6]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text), line 71 (text), line
  71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-assert-wait.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text), line 49 (text), line 63
  (text), line 71 (text), line 116 (text), line 118 (text), line 119 (text), line 158 (text) and line 165 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 26 (text), line 55
  (text), line 303 (text) and line 304 (text).
- [.claude/plans/plan-config-defaults.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 61 (text) and line 265 (text).
- [.claude/plans/plan-lazy-types-load.md][10]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 108 (text).
- [.claude/plans/plan-master.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 101 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 18 (text)
  and line 39 (text).
- [.claude/plans/questionnaire-2026-10-16.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 140 (text).
- [.claude/plans/task-assert-wait.md][14]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 70 (text).
- [.claude/plans/task-config-defaults-postures.md][15]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 43 (text).
- [.claude/plans/task-import-landing-zone.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text) and line 61
  (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][17]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][18]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (text).

### automation × powershell (16 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][19]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21
  (header) and line 36 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][20]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 41
  (header).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][21]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][22]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][23]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][24]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 87 (text).
- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][25]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23
  (header) and line 36 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][26]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and
  line 43 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][27]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][28]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 23 (header) and line 43 (header).
- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][29]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 19
  (header), line 168 (text) and line 176 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][30]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (header)
  and line 67 (text).
- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][31]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][32]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and
  line 26 (header).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][33]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][34]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22
  (header) and line 29 (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][35]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 151 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][36]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 74 (body comment) and
  line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][37]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][38]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 602
  (text).

### docs × markdown (12 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/dora-explains.md][39]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 330 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/index.md][40]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][41]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 82 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][42]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text), line 64 (text), line 77 (text), line 80 (text), line 81 (text) and line 81
  (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][43]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 123 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][44]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 32 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][45]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][46]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text), line 53 (text) and line 121 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][47]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-typessystem.md][48]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text) and
  line 88 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][49]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 31 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][50]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line
  21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 151
  (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 95
  (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 26 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 20 (header), `automation/Catzc.Base.Engines/types/ExecutionEngine.cs` line
  22 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 23 (header),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 36 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line
  21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 43 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 602 (text),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 43 (header),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 168 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 176 (text), `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 67 (text),
  `automation/Catzc.Base.Timeouts/Assert-Wait.ps1` line 22 (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 20
  (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 26 (header),
  `automation/Catzc.Base.Timeouts/types/BashSafeguard.cs` line 21 (text), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1`
  line 21 (header), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 27 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 22 (header) and
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 29 (header).

## Keywords

- [world map][52]
- [track][53]
- [file language][54]
- [cell][55]
- [lit cell][56]
- [.claude][57]: a track
- [automation][57]: a track
- [docs][57]: a track
- [pipelines][57]: a track
- [csharp][58]: a file language
- [markdown][58]: a file language
- [pipeline-yaml][58]: a file language
- [powershell][58]: a file language
- [yaml][58]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/CLAUDE.md
[6]: ../../../../.claude/plans/decisions-2026-10-16.md
[7]: ../../../../.claude/plans/plan-assert-wait.md
[8]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[9]: ../../../../.claude/plans/plan-config-defaults.md
[10]: ../../../../.claude/plans/plan-lazy-types-load.md
[11]: ../../../../.claude/plans/plan-master.md
[12]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[13]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[14]: ../../../../.claude/plans/task-assert-wait.md
[15]: ../../../../.claude/plans/task-config-defaults-postures.md
[16]: ../../../../.claude/plans/task-import-landing-zone.md
[17]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[18]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[19]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[20]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[21]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[22]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[23]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[24]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[25]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[26]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[27]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[28]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[29]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[30]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[31]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[32]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[33]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[34]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[35]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[36]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[37]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[38]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[39]: ../../../adr/automation/dora-explains.md
[40]: ../../../adr/index.md
[41]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[42]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[43]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[44]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[45]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[46]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[47]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[48]: ../../../references/automation/catzc-base-typessystem.md
[49]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[50]: ../../../../pipelines/ci-automation.yaml
[51]: ../../automation/hook-compiles-module-verdict-and-limits.md
[52]: ../../../adr/glossary.md#world-map
[53]: ../../../adr/glossary.md#track
[54]: ../../../adr/glossary.md#file-language
[55]: ../../../adr/glossary.md#cell
[56]: ../../../adr/glossary.md#lit-cell
[57]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

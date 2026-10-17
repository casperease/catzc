# docs/explanation/.assets/grid/adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.grid.md

`Grid minimap: adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture`

![Grid minimap of adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture](adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.grid.png)

The grid minimap of the slide `adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture` (architecture lens). The slide
supports [ADR-AUTO-FAILFAST][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 10 lit of 71 files
- .unordered × markdown: 5 lit of 20 files
- automation × csharp: 2 lit of 274 files
- automation × powershell: 13 lit of 1579 files
- automation × yaml: 4 lit of 109 files
- docs × markdown: 9 lit of 2165 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (10 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 113 (text).
- [.claude/plans/decisions-2026-10-16.md][6]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text), line 71 (text), line
  71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-assert-wait.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text), line 44 (text), line 57
  (text), line 65 (text) and line 115 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 27 (text), line 56
  (text), line 302 (text) and line 303 (text).
- [.claude/plans/plan-config-defaults.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 62 (text) and line 266 (text).
- [.claude/plans/plan-lazy-types-load.md][10]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 204 (text).
- [.claude/plans/plan-minimal-robots-agents.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text) and line 91
  (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text) and line
  131 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (text)
  and line 40 (text).
- [.claude/plans/questionnaire-2026-10-16.md][14]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 141 (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-built-bundle.md][15]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 13 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 14 (text) and line 16
  (text).
- [.unordered/15-10-2026/plan-duration-categories.md][17]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][18]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 129 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][19]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 70 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][20]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][21]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (text).

### automation × powershell (13 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][22]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21
  (header) and line 36 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][23]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 41
  (header).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][24]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][25]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][26]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][27]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 87 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][28]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and
  line 43 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][29]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][30]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 23 (header) and line 43 (header).
- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][31]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][32]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and
  line 26 (header).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][33]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][34]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22
  (header) and line 29 (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][35]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 148 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][36]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 74 (body comment) and
  line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][37]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][38]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 599
  (text).

### docs × markdown (9 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/dora-explains.md][39]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 310 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/index.md][40]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 159 (text).
- [docs/adr/repository/ai-agent-contract.md][41]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 18 (text) and line 55
  (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][42]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 32 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][43]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][44]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-typessystem.md][45]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text) and
  line 89 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][46]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 31 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][47]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line
  21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 148
  (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 95
  (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 26 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 20 (header), `automation/Catzc.Base.Engines/types/ExecutionEngine.cs` line
  22 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 87 (text), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 43 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 599 (text),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 43 (header),
  `automation/Catzc.Base.Timeouts/Assert-Wait.ps1` line 20 (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 20
  (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 26 (header),
  `automation/Catzc.Base.Timeouts/types/BashSafeguard.cs` line 21 (text), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1`
  line 21 (header), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 27 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 22 (header) and
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 29 (header).

## Keywords

- [world map][48]
- [track][49]
- [file language][50]
- [cell][51]
- [lit cell][52]
- [.claude][53]: a track
- [.unordered][53]: a track
- [automation][53]: a track
- [docs][53]: a track
- [pipelines][53]: a track
- [csharp][54]: a file language
- [markdown][54]: a file language
- [pipeline-yaml][54]: a file language
- [powershell][54]: a file language
- [yaml][54]: a file language

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
[11]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[12]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[13]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[14]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[15]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[16]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[17]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[18]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[19]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[20]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[21]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[22]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[23]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[24]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[25]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[26]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[27]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[28]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[29]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[30]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
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
[41]: ../../../adr/repository/ai-agent-contract.md
[42]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[43]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[44]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[45]: ../../../references/automation/catzc-base-typessystem.md
[46]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[47]: ../../../../pipelines/ci-automation.yaml
[48]: ../../../adr/glossary.md#world-map
[49]: ../../../adr/glossary.md#track
[50]: ../../../adr/glossary.md#file-language
[51]: ../../../adr/glossary.md#cell
[52]: ../../../adr/glossary.md#lit-cell
[53]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[54]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

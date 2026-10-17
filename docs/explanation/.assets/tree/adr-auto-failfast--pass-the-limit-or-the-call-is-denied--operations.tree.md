# docs/explanation/.assets/tree/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.tree.md

`Tree minimap: adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations`

![Tree minimap of adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations](adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.tree.png)

The tree minimap of the slide `adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations` (operations lens). The slide supports
[ADR-AUTO-FAILFAST][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 44 files in 15 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 10 lit files
- Docs (automation/Catzc.Base.Docs): 6 lit files
- .unordered: 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 3 lit files
- Folders (automation/Catzc.Base.Folders): 2 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- adr/repo (docs/adr/repository): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (10 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][2], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 113 (text).
- [.claude/plans/decisions-2026-10-16.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  25 (text), line 71 (text), line 71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-assert-wait.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32
  (text), line 44 (text), line 57 (text), line 65 (text) and line 115 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][5], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 27 (text), line 56 (text), line 302 (text) and line 303 (text).
- [.claude/plans/plan-config-defaults.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  62 (text) and line 266 (text).
- [.claude/plans/plan-lazy-types-load.md][7], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  204 (text).
- [.claude/plans/plan-minimal-robots-agents.md][8], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 25 (text) and line 91 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][9], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 25 (text) and line 131 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][10], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 19 (text) and line 40 (text).
- [.claude/plans/questionnaire-2026-10-16.md][11], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 141 (text).

### Docs (automation/Catzc.Base.Docs, 6 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-Glossary.ps1][12], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][13], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 148 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][14], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 74 (body comment) and line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][15], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 23 (text).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][16], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][17], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 20 (header).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-built-bundle.md][18], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 13 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][19], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 14 (text) and line 16 (text).
- [.unordered/15-10-2026/plan-duration-categories.md][20], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][21], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 129 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][22], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 70 (text).

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][24], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][25], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-typessystem.md][26], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 16 (text) and line 89 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][27], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 31 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][28], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 599 (text).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][29], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][30], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (header) and line 43 (header).

### Timeouts (automation/Catzc.Base.Timeouts, 3 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][31], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][32], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][33], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 21 (text).

### Folders (automation/Catzc.Base.Folders, 2 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][35], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 87 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][36], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][37], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (header) and line 29 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][38], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 310
  (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### Az.Cli (automation/Catzc.Azure.Cli, 1 lit file)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][39], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 36 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][40], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 22 (text).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][41], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 21 (header) and line 43 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][42], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 159 (text).

### adr/repo (docs/adr/repository, 1 lit file)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/ai-agent-contract.md][43], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  18 (text) and line 55 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][44], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line
  21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 148 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 95 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
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

- [world map][45]
- [track][46]
- [file language][47]
- [cell][48]
- [lit cell][49]
- [.claude][50]: a track
- [.unordered][50]: a track
- [automation][50]: a track
- [docs][50]: a track
- [pipelines][50]: a track
- [csharp][51]: a file language
- [markdown][51]: a file language
- [pipeline-yaml][51]: a file language
- [powershell][51]: a file language
- [yaml][51]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../.claude/CLAUDE.md
[3]: ../../../../.claude/plans/decisions-2026-10-16.md
[4]: ../../../../.claude/plans/plan-assert-wait.md
[5]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[6]: ../../../../.claude/plans/plan-config-defaults.md
[7]: ../../../../.claude/plans/plan-lazy-types-load.md
[8]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[9]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[10]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[11]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[12]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[13]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[15]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[16]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[17]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[18]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[19]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[20]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[21]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[22]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[23]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[24]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[25]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[26]: ../../../references/automation/catzc-base-typessystem.md
[27]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[28]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[29]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[30]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[31]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[32]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[33]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[34]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[35]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[36]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[37]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[38]: ../../../adr/automation/dora-explains.md
[39]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[40]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[41]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[42]: ../../../adr/index.md
[43]: ../../../adr/repository/ai-agent-contract.md
[44]: ../../../../pipelines/ci-automation.yaml
[45]: ../../../adr/glossary.md#world-map
[46]: ../../../adr/glossary.md#track
[47]: ../../../adr/glossary.md#file-language
[48]: ../../../adr/glossary.md#cell
[49]: ../../../adr/glossary.md#lit-cell
[50]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[51]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

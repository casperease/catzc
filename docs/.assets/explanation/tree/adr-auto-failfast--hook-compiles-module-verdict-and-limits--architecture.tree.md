# docs/.assets/explanation/tree/adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.tree.md

`Tree minimap: adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture`

![Tree minimap of adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture](adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.tree.png)

The tree minimap of the slide `adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture` (architecture lens). The slide
supports [ADR-AUTO-FAILFAST][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 42 files in 14 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 11 lit files
- .unordered: 5 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- Folders (automation/Catzc.Base.Folders): 2 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 2 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (11 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][2], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 105 (text).
- [.claude/agents/session-cost-audit.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  29 (text) and line 41 (text).
- [.claude/agents/test-optimization.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 29
  (text) and line 59 (text).
- [.claude/plans/decisions-2026-10-16.md][5], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  37 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 33 (text), line 198 (text) and line 199 (text).
- [.claude/plans/plan-config-defaults.md][7], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  27 (text) and line 224 (text).
- [.claude/plans/plan-lazy-types-load.md][8], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  163 (text).
- [.claude/plans/plan-minimal-robots-agents.md][9], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 61 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][10], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 101 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][11], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 16 (text).
- [.claude/plans/questionnaire-2026-10-16.md][12], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 121 (text).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-built-bundle.md][13], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 13 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][14], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 14 (text) and line 16 (text).
- [.unordered/15-10-2026/plan-duration-categories.md][15], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][16], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 129 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][17], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 70 (text).

### Docs (automation/Catzc.Base.Docs, 5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-Glossary.ps1][18], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 20 (header) and line 40 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][19], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 147 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][20], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 64 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][21], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (header) and line 25 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][22], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 19 (header).

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][24], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text) and line 56 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][25], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-typessystem.md][26], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 15 (text) and line 99 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][27], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text) and line 30 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][28], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 598 (text).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][29], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][30], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (header) and line 42 (header).

### Folders (automation/Catzc.Base.Folders, 2 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (header) and line 70 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (header) and line 86 (text).

### Timeouts (automation/Catzc.Base.Timeouts, 2 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][33], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 19 (header) and line 25 (header).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][34], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 20 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][35], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][36], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 28 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][37], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 308
  (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### Az.Cli (automation/Catzc.Azure.Cli, 1 lit file)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][38], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 35 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][39], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 21 (text).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][40], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 20 (header) and line 42 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][41], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 156 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][42], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line
  20 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 35 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 20 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 40 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 147 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 64 (body comment),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 19 (header),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 25 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 19 (header), `automation/Catzc.Base.Engines/types/ExecutionEngine.cs` line
  21 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 70 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 86 (text), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 20 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 42 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 598 (text),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 42 (header),
  `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 19 (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 25
  (header), `automation/Catzc.Base.Timeouts/types/BashSafeguard.cs` line 20 (text),
  `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 20 (header),
  `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 26 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 21 (header) and
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 28 (header).

## Keywords

- [world map][43]
- [track][44]
- [file language][45]
- [cell][46]
- [lit cell][47]
- [.claude][48]: a track
- [.unordered][48]: a track
- [automation][48]: a track
- [docs][48]: a track
- [pipelines][48]: a track
- [csharp][49]: a file language
- [markdown][49]: a file language
- [pipeline-yaml][49]: a file language
- [powershell][49]: a file language
- [yaml][49]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../.claude/CLAUDE.md
[3]: ../../../../.claude/agents/session-cost-audit.md
[4]: ../../../../.claude/agents/test-optimization.md
[5]: ../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[7]: ../../../../.claude/plans/plan-config-defaults.md
[8]: ../../../../.claude/plans/plan-lazy-types-load.md
[9]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[10]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[11]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[12]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[13]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[14]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[15]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[16]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[17]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[18]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[19]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[21]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[22]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[23]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[24]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[25]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[26]: ../../../references/automation/catzc-base-typessystem.md
[27]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[28]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[29]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[30]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[31]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[32]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[33]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[34]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[35]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[36]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[37]: ../../../adr/automation/dora-explains.md
[38]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[39]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[40]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[41]: ../../../adr/index.md
[42]: ../../../../pipelines/ci-automation.yaml
[43]: ../../../adr/glossary.md#world-map
[44]: ../../../adr/glossary.md#track
[45]: ../../../adr/glossary.md#file-language
[46]: ../../../adr/glossary.md#cell
[47]: ../../../adr/glossary.md#lit-cell
[48]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[49]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

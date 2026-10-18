# Main loads the limits and the run environment, then Decide returns null or a reason: the tree minimap

```text
Which files cite ADR-AUTO-FAILFAST: every file of the world map is a tile, grouped by top-level folder.
47 files lit in 15 groups.
```

![The tree minimap of Main loads the limits and the run environment, then Decide returns null or a reason](adr-auto-failfast--decide-returns-null-or-a-reason--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Main loads the limits and the run environment, then Decide returns
null or a reason][48], which explains [ADR-AUTO-FAILFAST][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 47 files in 15 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 12 lit files
- docs (docs/ outside docs/adr/): 9 lit files
- Docs (automation/Catzc.Base.Docs): 6 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 3 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 3 lit files
- Folders (automation/Catzc.Base.Folders): 2 lit files
- Slides (automation/Catzc.Base.Slides): 2 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Git (automation/Catzc.Base.Git): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .claude (12 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][2], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 115 (text).
- [.claude/plans/decisions-2026-10-16.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  25 (text), line 71 (text), line 71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-assert-wait.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32
  (text), line 49 (text), line 63 (text), line 71 (text), line 116 (text), line 118 (text), line 119 (text), line 158 (text) and line 165
  (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][5], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 26 (text), line 55 (text), line 303 (text) and line 304 (text).
- [.claude/plans/plan-config-defaults.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  61 (text) and line 265 (text).
- [.claude/plans/plan-lazy-types-load.md][7], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  108 (text).
- [.claude/plans/plan-master.md][8], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 101
  (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][9], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 18 (text) and line 39 (text).
- [.claude/plans/questionnaire-2026-10-16.md][10], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 140 (text).
- [.claude/plans/task-assert-wait.md][11], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 70
  (text).
- [.claude/plans/task-config-defaults-postures.md][12], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 43 (text).
- [.claude/plans/task-import-landing-zone.md][13], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 32 (text) and line 61 (text).

### docs (docs/ outside docs/adr/, 9 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][14], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 82 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][15], in the cell docs ×
  markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text), line 64 (text), line 77 (text), line 80 (text), line 81
  (text) and line 81 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][16], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 123 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][17], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text), line 53 (text) and line 121 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][20], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-typessystem.md][21], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 15 (text) and line 88 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][22], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 17 (text) and line 31 (text).

### Docs (automation/Catzc.Base.Docs, 6 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-Glossary.ps1][23], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][24], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 151 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][25], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 74 (body comment) and line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][26], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 23 (text).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][27], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][28], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 20 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 3 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][29], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 602 (text).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][30], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][31], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (header) and line 43 (header).

### Timeouts (automation/Catzc.Base.Timeouts, 3 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][32], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 22 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][33], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][34], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 21 (text).

### Folders (automation/Catzc.Base.Folders, 2 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][35], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and line 87 (text).

### Slides (automation/Catzc.Base.Slides, 2 lit files)

The group holds the files of automation/Catzc.Base.Slides; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][37], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (header), line 168 (text) and line 176 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][38], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 19 (header) and line 67 (text).

### TypesSystem (automation/Catzc.Base.TypesSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][39], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][40], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (header) and line 29 (header).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][41], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 330
  (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### Az.Cli (automation/Catzc.Azure.Cli, 1 lit file)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][42], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 36 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][43], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 22 (text).

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][44], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 23 (header) and line 36 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][45], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 21 (header) and line 43 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][46], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][47], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line
  21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 151 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 95 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
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

- [world map][49]
- [track][50]
- [file language][51]
- [cell][52]
- [lit cell][53]
- [.claude][54]: a track
- [automation][54]: a track
- [docs][54]: a track
- [pipelines][54]: a track
- [csharp][55]: a file language
- [markdown][55]: a file language
- [pipeline-yaml][55]: a file language
- [powershell][55]: a file language
- [yaml][55]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../../.claude/CLAUDE.md
[3]: ../../../../.claude/plans/decisions-2026-10-16.md
[4]: ../../../../.claude/plans/plan-assert-wait.md
[5]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[6]: ../../../../.claude/plans/plan-config-defaults.md
[7]: ../../../../.claude/plans/plan-lazy-types-load.md
[8]: ../../../../.claude/plans/plan-master.md
[9]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[10]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[11]: ../../../../.claude/plans/task-assert-wait.md
[12]: ../../../../.claude/plans/task-config-defaults-postures.md
[13]: ../../../../.claude/plans/task-import-landing-zone.md
[14]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[15]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[16]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[17]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[18]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[19]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[20]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[21]: ../../../references/automation/catzc-base-typessystem.md
[22]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[23]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[24]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[25]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[26]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[27]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[28]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[29]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[30]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[31]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[32]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[33]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[34]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[35]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[36]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[37]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[38]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[39]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[40]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[41]: ../../../adr/automation/dora-explains.md
[42]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[43]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[44]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[45]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[46]: ../../../adr/index.md
[47]: ../../../../pipelines/ci-automation.yaml
[48]: ../../automation/decide-returns-null-or-a-reason.md
[49]: ../../../adr/glossary.md#world-map
[50]: ../../../adr/glossary.md#track
[51]: ../../../adr/glossary.md#file-language
[52]: ../../../adr/glossary.md#cell
[53]: ../../../adr/glossary.md#lit-cell
[54]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[55]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

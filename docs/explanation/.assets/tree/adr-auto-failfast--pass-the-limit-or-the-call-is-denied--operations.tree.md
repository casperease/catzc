# A call inside the limit runs; outside it, the hook denies it and says how to re-issue it: the tree minimap

```text
Which files cite ADR-AUTO-FAILFAST: every file of the world map is a tile, grouped by top-level folder.
44 files lit in 9 groups.
```

![The tree minimap of A call inside the limit runs; outside it, the hook denies it and says how to re-issue it](adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.tree.png)

This is the tree minimap in the sidebar of the operations diagram of [A call inside the limit runs; outside it, the hook denies it and says
how to re-issue it][45], which explains [ADR-AUTO-FAILFAST][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 44 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 20 lit files
- .claude: 12 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Folders (automation/Catzc.Base.Folders): 2 lit files
- Slides (automation/Catzc.Base.Slides): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 20 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][2], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][3], in the cell docs ×
  markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line
  62 (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][5], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 102 (text).
- [docs/references/automation/catzc-base-docs/Test-Glossary.ps1.md][6], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 27 (text).
- [docs/references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 37 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][10], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text) and line 100 (text).
- [docs/references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][14], in the cell docs × markdown: selected
  by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-timeouts/Assert-Wait.ps1.md][15], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 23 (text) and line 24 (text).
- [docs/references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][17], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-typessystem.md][18], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 64 (text).
- [docs/references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 15 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][21], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 12 (text).

### .claude (12 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][22], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 118 (text).
- [.claude/plans/decisions-2026-10-16.md][23], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  39 (text), line 39 (text), line 161 (text) and line 168 (text).
- [.claude/plans/plan-assert-wait.md][24], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 24
  (text), line 38 (text), line 46 (text), line 91 (text), line 93 (text), line 94 (text), line 133 (text) and line 140 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][25], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 33 (text), line 281 (text) and line 282 (text).
- [.claude/plans/plan-config-defaults.md][26], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  35 (text) and line 259 (text).
- [.claude/plans/plan-lazy-types-load.md][27], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  90 (text).
- [.claude/plans/plan-master.md][28], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 84
  (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][29], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 17 (text).
- [.claude/plans/questionnaire-2026-10-16.md][30], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 121 (text).
- [.claude/plans/task-assert-wait.md][31], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 53
  (text).
- [.claude/plans/task-config-defaults-postures.md][32], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 24 (text).
- [.claude/plans/task-import-landing-zone.md][33], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 42 (text).

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][34], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 132 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][35], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 55 (body comment) and line 76 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][36], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 4 (text).

### Folders (automation/Catzc.Base.Folders, 2 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][37], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 47 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][38], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).

### Slides (automation/Catzc.Base.Slides, 2 lit files)

The group holds the files of automation/Catzc.Base.Slides; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][39], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 145 (text) and line 153 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][40], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 44 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][41], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 260
  (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][42], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 583 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][43], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][44], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 132 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 55 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47
  (text), `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 583 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 145 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 153 (text) and
  `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44 (text).

## Keywords

- [world map][46]
- [track][47]
- [file language][48]
- [cell][49]
- [lit cell][50]
- [.claude][51]: a track
- [automation][51]: a track
- [docs][51]: a track
- [pipelines][51]: a track
- [markdown][52]: a file language
- [pipeline-yaml][52]: a file language
- [powershell][52]: a file language
- [yaml][52]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[3]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[4]: ../../../references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[5]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[6]: ../../../references/automation/catzc-base-docs/Test-Glossary.ps1.md
[7]: ../../../references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[8]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[9]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[10]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[11]: ../../../references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[12]: ../../../references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md
[13]: ../../../references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[14]: ../../../references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[15]: ../../../references/automation/catzc-base-timeouts/Assert-Wait.ps1.md
[16]: ../../../references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[17]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[18]: ../../../references/automation/catzc-base-typessystem.md
[19]: ../../../references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[20]: ../../../references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[21]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[22]: ../../../../.claude/CLAUDE.md
[23]: ../../../../.claude/plans/decisions-2026-10-16.md
[24]: ../../../../.claude/plans/plan-assert-wait.md
[25]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[26]: ../../../../.claude/plans/plan-config-defaults.md
[27]: ../../../../.claude/plans/plan-lazy-types-load.md
[28]: ../../../../.claude/plans/plan-master.md
[29]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[30]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[31]: ../../../../.claude/plans/task-assert-wait.md
[32]: ../../../../.claude/plans/task-config-defaults-postures.md
[33]: ../../../../.claude/plans/task-import-landing-zone.md
[34]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[35]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[36]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[37]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[38]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[39]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[40]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[41]: ../../../adr/automation/dora-explains.md
[42]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[43]: ../../../adr/index.md
[44]: ../../../../pipelines/ci-automation.yaml
[45]: ../../automation/pass-the-limit-or-the-call-is-denied.md
[46]: ../../../adr/glossary.md#world-map
[47]: ../../../adr/glossary.md#track
[48]: ../../../adr/glossary.md#file-language
[49]: ../../../adr/glossary.md#cell
[50]: ../../../adr/glossary.md#lit-cell
[51]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[52]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

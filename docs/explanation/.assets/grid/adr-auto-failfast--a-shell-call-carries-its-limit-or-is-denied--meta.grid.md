---
catzc:
  immutable:
    with_body_sha: aa61f98d56b7
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.grid.md
    source: docs/explanation/.assets/adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A shell call carries its limit, or the hook denies it with a reason; it is never rewritten: the world-map minimap

```text
Where the files that cite ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 44 files.
```

![The world-map minimap of A shell call carries its limit, or the hook denies it with a reason; it is never rewritten](adr-auto-failfast--a-shell-call-carries-its-limit-or-is-denied--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A shell call carries its limit, or the hook denies it with a reason; it
is never rewritten][48], which explains [ADR-AUTO-FAILFAST][1]. It lights every cell of the world map that holds a file citing those codes,
so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 12 lit of 90 files
- automation × powershell: 4 lit of 1629 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 23 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (12 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 118 (text).
- [.claude/plans/decisions-2026-10-16.md][6]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 39 (text), line 39 (text), line
  161 (text) and line 168 (text).
- [.claude/plans/plan-assert-wait.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 24 (text), line 38 (text), line 46
  (text), line 91 (text), line 93 (text), line 94 (text), line 133 (text) and line 140 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 33 (text), line 281
  (text) and line 282 (text).
- [.claude/plans/plan-config-defaults.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 35 (text) and line 259 (text).
- [.claude/plans/plan-lazy-types-load.md][10]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 90 (text).
- [.claude/plans/plan-master.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 84 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 17
  (text).
- [.claude/plans/questionnaire-2026-10-16.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 121 (text).
- [.claude/plans/task-assert-wait.md][14]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 53 (text).
- [.claude/plans/task-config-defaults-postures.md][15]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 24 (text).
- [.claude/plans/task-import-landing-zone.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 42 (text).

### automation × powershell (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][17]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 47
  (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][18]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64
  (text).
- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][19]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 145
  (text) and line 153 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][20]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 44 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 132 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][22]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 55 (body comment) and
  line 76 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][23]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 4 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][24]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 583
  (text).

### docs × markdown (23 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/dora-explains.md][25]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/index.md][26]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 163 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][27]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][28]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][29]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 22 (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][30]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 102 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][31]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 27
  (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][32]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][33]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][34]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 37 (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][35]: selected by
  [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][36]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 22 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][37]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 25 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][38]: selected by [ADR-AUTO-FAILFAST][1]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][39]: selected by [ADR-AUTO-FAILFAST][1]:
  the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/Assert-Wait.ps1.md][40]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23
  (text) and line 24 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][41]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][42]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-typessystem.md][43]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][44]: selected by [ADR-AUTO-FAILFAST][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][45]: selected by [ADR-AUTO-FAILFAST][1]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][46]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 12 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][47]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml`
  line 55 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47
  (text), `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text),
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 583 (text),
  `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 145 (text),
  `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 153 (text) and
  `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44 (text).

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
- [markdown][55]: a file language
- [pipeline-yaml][55]: a file language
- [powershell][55]: a file language
- [yaml][55]: a file language

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
[17]: ../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[18]: ../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[19]: ../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[20]: ../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[21]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[23]: ../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[24]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[25]: ../../../adr/automation/dora-explains.md
[26]: ../../../adr/index.md
[27]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[28]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[29]: ../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[30]: ../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[31]: ../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[32]: ../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[33]: ../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[34]: ../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[35]: ../../../references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[36]: ../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[37]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[38]: ../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[39]: ../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[40]: ../../../references/pwsh/catzc-base-timeouts/Assert-Wait.ps1.md
[41]: ../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[42]: ../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[43]: ../../../references/pwsh/catzc-base-typessystem.md
[44]: ../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[45]: ../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[46]: ../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[47]: ../../../../pipelines/ci-automation.yaml
[48]: ../../automation/a-shell-call-carries-its-limit-or-is-denied.md
[49]: ../../../adr/glossary.md#world-map
[50]: ../../../adr/glossary.md#track
[51]: ../../../adr/glossary.md#file-language
[52]: ../../../adr/glossary.md#cell
[53]: ../../../adr/glossary.md#lit-cell
[54]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[55]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

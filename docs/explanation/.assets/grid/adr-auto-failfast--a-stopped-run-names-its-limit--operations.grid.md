---
catzc:
  immutable:
    with_body_sha: e1f9af6e27eb
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-auto-failfast--a-stopped-run-names-its-limit--operations.grid.md
    source: docs/explanation/.assets/adr-auto-failfast--a-stopped-run-names-its-limit--operations.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A run past its limit stops with a message that names the limit and where to change it: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 170 files.
```

![The world-map minimap of A run past its limit stops with a message that names the limit and where to change it](adr-auto-failfast--a-stopped-run-names-its-limit--operations.grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [A run past its limit stops with a message that names the limit
and where to change it][174], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights every cell of the world map that
holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code
that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 27 lit of 91 files
- automation × csharp: 33 lit of 286 files
- automation × powershell: 40 lit of 1619 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 65 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (27 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 48 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 115 (text).
- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 23 (text), line 51 (text), line
  62 (text), line 63 (text) and line 156 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 25 (text), line 71 (text),
  line 71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/decisions-2026-10-18.md][8]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 22 (text) and line 40 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][9]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text), line
  184 (text) and line 473 (text).
- [.claude/plans/plan-assert-wait.md][10]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31 (text), line 94 (text) and line
  95 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text), line 49 (text), line 63 (text), line 71 (text), line
  116 (text), line 118 (text), line 119 (text), line 158 (text) and line 165 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][11]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25 (text), line 150
  (text), line 165 (text), line 183 (text), line 191 (text), line 211 (text), line 223 (text), line 327 (text) and line 345 (text); selected
  by [ADR-AUTO-FAILFAST][2]: the file cites it at line 26 (text), line 55 (text), line 303 (text) and line 304 (text).
- [.claude/plans/plan-config-defaults.md][12]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31 (text), line 51 (text), line
  97 (text), line 141 (text), line 197 (text) and line 263 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 61 (text)
  and line 265 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][13]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31 (text),
  line 249 (text) and line 363 (text).
- [.claude/plans/plan-file-meta-head-policy.md][14]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 30 (text), line 61 (text)
  and line 166 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][15]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text),
  line 523 (text), line 560 (text), line 562 (text), line 702 (text) and line 794 (text).
- [.claude/plans/plan-lazy-types-load.md][16]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 30 (text) and line 85 (text);
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 108 (text).
- [.claude/plans/plan-master.md][17]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 101 (text).
- [.claude/plans/plan-materialization-of-knowledge.md][18]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text) and line
  43 (text).
- [.claude/plans/plan-module-kinds-tracks.md][19]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31 (text), line 269 (text),
  line 333 (text) and line 376 (text).
- [.claude/plans/plan-out-artifacts.md][20]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 28 (text) and line 150 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][21]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 23 (text) and line
  224 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][22]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 18 (text)
  and line 39 (text).
- [.claude/plans/prompt-config-defaults-continue.md][23]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 34 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][24]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 40 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][25]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18 (text), line 41
  (text) and line 56 (text).
- [.claude/plans/questionnaire-2026-10-16.md][26]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 140 (text).
- [.claude/plans/task-assert-wait.md][27]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 70 (text).
- [.claude/plans/task-config-defaults-postures.md][28]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 33 (text) and line 56
  (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 43 (text).
- [.claude/plans/task-config-defaults-variants.md][29]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text) and line 31
  (text).
- [.claude/plans/task-import-landing-zone.md][30]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31 (text), line 40 (text)
  and line 61 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text) and line 61 (text).
- [.claude/plans/task-lazy-types-load.md][31]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31 (text) and line 41 (text).
- [.claude/skills/catzc-module/SKILL.md][32]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text) and line 39 (text).

### automation × csharp (33 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure/types/AzureConfig.cs][33]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Contracts/types/ContractCommand.cs][34]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Contracts/types/ContractParameter.cs][35]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][36]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][37]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][38]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Docs/types/CheckMode.cs][39]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][40]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][41]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Languages/types/FileCarrier.cs][42]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/FileCarriersConfig.cs][43]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][44]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][45]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/LayoutRow.cs][46]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][47]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][48]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][49]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][50]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][51]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/CommentsConfig.cs][52]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs][53]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaKind.cs][54]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs][55]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][56]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][57]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  21 (text).
- [automation/Catzc.Base.QualityGates/types/PlansConfig.cs][58]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text) and
  line 25 (body comment).
- [automation/Catzc.Base.QualityGates/types/SourceCheck.cs][59]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][60]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21
  (text).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][61]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21
  (text).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][62]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][63]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21
  (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][64]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][65]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21
  (text).

### automation × powershell (40 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][66]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21
  (header) and line 36 (header).
- [automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][67]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (header), line 119 (text), line 287 (text) and line 303 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1][68]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header) and line 51 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][69]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  20 (header), line 26 (text) and line 50 (text).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][70]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 41
  (header).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][71]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20
  (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][72]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][73]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (header) and line 28 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][74]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (header) and line 27 (text).
- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][75]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header), line 87 (text) and line 93 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][76]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  20 (header), line 26 (text), line 33 (text) and line 74 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][77]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header) and line 46 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header) and line 87 (text).
- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][78]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (header)
  and line 33 (header); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (header) and line 36 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][79]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and
  line 43 (header).
- [automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][80]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header) and line 55 (text).
- [automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][81]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  20 (header) and line 155 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1][82]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][83]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][84]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 23 (header) and line 43 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][85]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header) and line 209 (text).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][86]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 20 (header), line 28 (text), line 124 (text) and line 128 (text).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][87]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 20 (header) and line 32 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1][88]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header) and line 25 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][89]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 20 (header), line 40 (text) and line 90 (text).
- [automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][90]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  20 (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1][91]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header) and line 24 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][92]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  20 (header) and line 26 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][93]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (header), line 27 (text) and line 51 (text).
- [automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][94]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header), line 66 (text) and line 88 (text).
- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][95]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19
  (header), line 168 (text) and line 176 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][96]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (header)
  and line 67 (text).
- [automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][97]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header), line 26 (text) and line 56 (text).
- [automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1][98]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header) and line 42 (text).
- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][99]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][100]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header)
  and line 26 (header).
- [automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][101]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header) and line 176 (text).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][102]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][103]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 22
  (header) and line 29 (header).
- [automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1][104]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header)
  and line 26 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][105]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 20 (header).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][106]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 150 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 151 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][107]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 74 (body comment) and
  line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][108]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 33 (body comment)
  (a passing mention only); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][109]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 602
  (text).

### docs × markdown (65 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][110]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 313 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 330 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2]: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1]: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.
- [docs/adr/index.md][111]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 162 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 163 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][112]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text) and line 56 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][113]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 82 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][114]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text) and line 77 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][115]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 16 (text), line 64 (text), line 77 (text), line 80 (text), line 81 (text) and line 81
  (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][116]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 123 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][117]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 47 (text).
- [docs/references/automation/catzc-base-contracts/configs/contracts.yml.md][118]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][119]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-contracts/types/ContractsConfig.cs.md][120]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md][121]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][122]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][123]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][124]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 60 (text).
- [docs/references/automation/catzc-base-docs/types/CheckMode.cs.md][125]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 40 (text).
- [docs/references/automation/catzc-base-docs/types/CheckModes.cs.md][126]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 35 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][127]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][128]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 16 (text), line 53 (text) and line 121 (text).
- [docs/references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][129]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages.md][130]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 82 (text).
- [docs/references/automation/catzc-base-languages/configs/file-carriers.yml.md][131]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/configs/go.yml.md][132]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][133]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 64 (text).
- [docs/references/automation/catzc-base-languages/configs/python.yml.md][134]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md][135]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md][136]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][137]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][138]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 49 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][139]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 36 (text).
- [docs/references/automation/catzc-base-maps/types/MapsConfig.cs.md][140]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 40 (text).
- [docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md][141]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][142]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 46 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md][143]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/MapsPalette.cs.md][144]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md][145]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md][146]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/links.yml.md][147]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md][148]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md][149]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md][150]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][151]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][152]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][153]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][154]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][155]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md][156]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md][157]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md][158]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md][159]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md][160]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][161]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md][162]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][163]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][164]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][165]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][166]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md][167]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-typessystem.md][168]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 15 (text) and
  line 88 (text).
- [docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md][169]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][170]: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md][171]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][172]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 17 (text) and line 31 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][173]: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure/types/AzureConfig.cs` line 21 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 119 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 287 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 303 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.Contracts/types/ContractCommand.cs` line 21 (text), `automation/Catzc.Base.Contracts/types/ContractParameter.cs`
  line 20 (text), `automation/Catzc.Base.Contracts/types/ContractsConfig.cs` line 21 (text), `automation/Catzc.Base.Docs/configs/adrs.yml`
  line 150 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 33 (body comment),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 27 (text), `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line
  21 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 22 (text), `automation/Catzc.Base.Docs/types/CheckMode.cs` line 20
  (text), `automation/Catzc.Base.Docs/types/CheckModes.cs` line 21 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 33 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 74 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 46 (text),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 21 (header),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 33 (header),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 55 (text),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 155 (text),
  `automation/Catzc.Base.Languages/types/FileCarrier.cs` line 20 (text), `automation/Catzc.Base.Languages/types/FileCarriersConfig.cs` line
  21 (text), `automation/Catzc.Base.Languages/types/GoConfig.cs` line 21 (text), `automation/Catzc.Base.Languages/types/LanguagesConfig.cs`
  line 21 (text), `automation/Catzc.Base.Languages/types/LayoutRow.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsConfig.cs` line
  21 (text), `automation/Catzc.Base.Maps/types/MapsHighlight.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsLabels.cs` line 20
  (text), `automation/Catzc.Base.Maps/types/MapsLimits.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsPalette.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 209 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 124 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 128 (text),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 32 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 40 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 90 (text),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.QualityGates/types/CommentsConfig.cs` line 21 (text), `automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/FileMetaKind.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs` line 20 (text), `automation/Catzc.Base.QualityGates/types/LinksConfig.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/PlansConfig.cs` line 20 (text), `automation/Catzc.Base.QualityGates/types/PlansConfig.cs` line
  25 (body comment), `automation/Catzc.Base.QualityGates/types/SourceCheck.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs` line 21 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 88 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 176 (text),
  `automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs` line 21 (text), `automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs`
  line 21 (text), `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 26 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1` line 20 (header) and
  `automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs` line 21 (text); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1`
  line 21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header),
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

- [world map][175]
- [track][176]
- [file language][177]
- [cell][178]
- [lit cell][179]
- [.claude][180]: a track
- [automation][180]: a track
- [docs][180]: a track
- [pipelines][180]: a track
- [csharp][181]: a file language
- [markdown][181]: a file language
- [pipeline-yaml][181]: a file language
- [powershell][181]: a file language
- [yaml][181]: a file language

[1]: ../../../adr/automation/sensible-defaults.md
[2]: ../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/decisions-2026-10-16.md
[8]: ../../../../.claude/plans/decisions-2026-10-18.md
[9]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[10]: ../../../../.claude/plans/plan-assert-wait.md
[11]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[12]: ../../../../.claude/plans/plan-config-defaults.md
[13]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[14]: ../../../../.claude/plans/plan-file-meta-head-policy.md
[15]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[16]: ../../../../.claude/plans/plan-lazy-types-load.md
[17]: ../../../../.claude/plans/plan-master.md
[18]: ../../../../.claude/plans/plan-materialization-of-knowledge.md
[19]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[20]: ../../../../.claude/plans/plan-out-artifacts.md
[21]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[22]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[23]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[24]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[25]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[26]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[27]: ../../../../.claude/plans/task-assert-wait.md
[28]: ../../../../.claude/plans/task-config-defaults-postures.md
[29]: ../../../../.claude/plans/task-config-defaults-variants.md
[30]: ../../../../.claude/plans/task-import-landing-zone.md
[31]: ../../../../.claude/plans/task-lazy-types-load.md
[32]: ../../../../.claude/skills/catzc-module/SKILL.md
[33]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[34]: ../../../../automation/Catzc.Base.Contracts/types/ContractCommand.cs
[35]: ../../../../automation/Catzc.Base.Contracts/types/ContractParameter.cs
[36]: ../../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[37]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[38]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[39]: ../../../../automation/Catzc.Base.Docs/types/CheckMode.cs
[40]: ../../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[41]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[42]: ../../../../automation/Catzc.Base.Languages/types/FileCarrier.cs
[43]: ../../../../automation/Catzc.Base.Languages/types/FileCarriersConfig.cs
[44]: ../../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[45]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[46]: ../../../../automation/Catzc.Base.Languages/types/LayoutRow.cs
[47]: ../../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[48]: ../../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[49]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[50]: ../../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[51]: ../../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[52]: ../../../../automation/Catzc.Base.QualityGates/types/CommentsConfig.cs
[53]: ../../../../automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
[54]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaKind.cs
[55]: ../../../../automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs
[56]: ../../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[57]: ../../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[58]: ../../../../automation/Catzc.Base.QualityGates/types/PlansConfig.cs
[59]: ../../../../automation/Catzc.Base.QualityGates/types/SourceCheck.cs
[60]: ../../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[61]: ../../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[62]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[63]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[64]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[65]: ../../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[66]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[67]: ../../../../automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[68]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
[69]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[70]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[71]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[72]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[73]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[74]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[75]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[76]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[77]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[78]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[79]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[80]: ../../../../automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[81]: ../../../../automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[82]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
[83]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[84]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[85]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[86]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[87]: ../../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[88]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
[89]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[90]: ../../../../automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[91]: ../../../../automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
[92]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[93]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[94]: ../../../../automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[95]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[96]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[97]: ../../../../automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[98]: ../../../../automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
[99]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[100]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[101]: ../../../../automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[102]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[103]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[104]: ../../../../automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1
[105]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[106]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[107]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[108]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[109]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[110]: ../../../adr/automation/dora-explains.md
[111]: ../../../adr/index.md
[112]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[113]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[114]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[115]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[116]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[117]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[118]: ../../../references/automation/catzc-base-contracts/configs/contracts.yml.md
[119]: ../../../references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[120]: ../../../references/automation/catzc-base-contracts/types/ContractsConfig.cs.md
[121]: ../../../references/automation/catzc-base-docs/configs/adr-checks.yml.md
[122]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[123]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[124]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[125]: ../../../references/automation/catzc-base-docs/types/CheckMode.cs.md
[126]: ../../../references/automation/catzc-base-docs/types/CheckModes.cs.md
[127]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[128]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[129]: ../../../references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[130]: ../../../references/automation/catzc-base-languages.md
[131]: ../../../references/automation/catzc-base-languages/configs/file-carriers.yml.md
[132]: ../../../references/automation/catzc-base-languages/configs/go.yml.md
[133]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[134]: ../../../references/automation/catzc-base-languages/configs/python.yml.md
[135]: ../../../references/automation/catzc-base-languages/types/FileCarrier.cs.md
[136]: ../../../references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md
[137]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[138]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[139]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[140]: ../../../references/automation/catzc-base-maps/types/MapsConfig.cs.md
[141]: ../../../references/automation/catzc-base-maps/types/MapsHighlight.cs.md
[142]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[143]: ../../../references/automation/catzc-base-maps/types/MapsLimits.cs.md
[144]: ../../../references/automation/catzc-base-maps/types/MapsPalette.cs.md
[145]: ../../../references/automation/catzc-base-qualitygates/configs/comments.yml.md
[146]: ../../../references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
[147]: ../../../references/automation/catzc-base-qualitygates/configs/links.yml.md
[148]: ../../../references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[149]: ../../../references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
[150]: ../../../references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
[151]: ../../../references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[152]: ../../../references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[153]: ../../../references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[154]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[155]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[156]: ../../../references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md
[157]: ../../../references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[158]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
[159]: ../../../references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[160]: ../../../references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md
[161]: ../../../references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[162]: ../../../references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md
[163]: ../../../references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[164]: ../../../references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[165]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[166]: ../../../references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[167]: ../../../references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[168]: ../../../references/automation/catzc-base-typessystem.md
[169]: ../../../references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
[170]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[171]: ../../../references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[172]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[173]: ../../../../pipelines/ci-automation.yaml
[174]: ../../automation/a-stopped-run-names-its-limit.md
[175]: ../../../adr/glossary.md#world-map
[176]: ../../../adr/glossary.md#track
[177]: ../../../adr/glossary.md#file-language
[178]: ../../../adr/glossary.md#cell
[179]: ../../../adr/glossary.md#lit-cell
[180]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[181]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

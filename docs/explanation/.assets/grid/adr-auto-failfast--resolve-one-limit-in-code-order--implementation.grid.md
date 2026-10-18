# Get-TimeoutSeconds resolves the environment, the config entry, then the exemption ceiling, in that order: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 144 files.
```

![The world-map minimap of Get-TimeoutSeconds resolves the environment, the config entry, then the exemption ceiling, in that order](adr-auto-failfast--resolve-one-limit-in-code-order--implementation.grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Get-TimeoutSeconds resolves the environment, the config
entry, then the exemption ceiling, in that order][148], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights every
cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its
reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 26 lit of 90 files
- automation × csharp: 6 lit of 289 files
- automation × powershell: 28 lit of 1629 files
- automation × yaml: 4 lit of 112 files
- docs × markdown: 79 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (26 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 51 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 118 (text).
- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text), line 30 (text), line
  31 (text) and line 124 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 39 (text), line 39 (text), line 161 (text)
  and line 168 (text).
- [.claude/plans/decisions-2026-10-18.md][8]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][9]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 157 (text) and
  line 446 (text).
- [.claude/plans/plan-assert-wait.md][10]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 69 (text) and line 70 (text);
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 24 (text), line 38 (text), line 46 (text), line 91 (text), line 93 (text),
  line 94 (text), line 133 (text) and line 140 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][11]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 128 (text), line 143
  (text), line 161 (text), line 169 (text), line 189 (text), line 201 (text), line 305 (text) and line 323 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 33 (text), line 281 (text) and line 282 (text).
- [.claude/plans/plan-config-defaults.md][12]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25 (text), line 71 (text), line
  135 (text), line 191 (text) and line 257 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 35 (text) and line 259
  (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][13]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 226 (text) and
  line 340 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][14]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 494 (text),
  line 531 (text), line 533 (text), line 673 (text) and line 765 (text).
- [.claude/plans/plan-lazy-types-load.md][15]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 67 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 90 (text).
- [.claude/plans/plan-master.md][16]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 84 (text).
- [.claude/plans/plan-materialization-of-knowledge.md][17]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text).
- [.claude/plans/plan-module-kinds-tracks.md][18]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 250 (text), line 314 (text)
  and line 357 (text).
- [.claude/plans/plan-out-artifacts.md][19]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 132 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][20]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 221 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][21]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 17
  (text).
- [.claude/plans/prompt-config-defaults-continue.md][22]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][23]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][24]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text) and line 36
  (text).
- [.claude/plans/questionnaire-2026-10-16.md][25]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 121 (text).
- [.claude/plans/task-assert-wait.md][26]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 53 (text).
- [.claude/plans/task-config-defaults-postures.md][27]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 37 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 24 (text).
- [.claude/plans/task-config-defaults-variants.md][28]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14 (text).
- [.claude/plans/task-import-landing-zone.md][29]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text) and line 42
  (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 42 (text).
- [.claude/plans/task-lazy-types-load.md][30]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 22 (text).
- [.claude/skills/catzc-module/SKILL.md][31]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text) and line 39 (text).

### automation × csharp (6 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Contracts/types/ContractCommand.cs][32]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Contracts/types/ContractParameter.cs][33]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/types/LayoutRow.cs][34]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.QualityGates/types/PlansConfig.cs][35]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (header).
- [automation/Catzc.Base.VSCode/types/VscodeOwnExtension.cs][36]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][37]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (body
  comment) (a passing mention only).

### automation × powershell (28 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1][38]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 174 (text).
- [automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][39]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 93
  (text), line 261 (text) and line 277 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1][40]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  28 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][41]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  2 (text) and line 26 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][42]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][43]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][44]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 63 (text)
  and line 69 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 47 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][45]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 9 (text) and line 50 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][46]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 23
  (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][47]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 31 (text).
- [automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][48]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  155 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][49]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 171 (text).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][50]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 2 (text), line 98 (text) and line 102 (text).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][51]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1][52]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 2 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][53]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 66 (text).
- [automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][54]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1][55]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][56]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][57]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 3 (text) and line 27 (text).
- [automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][58]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 43 (text) and line 65 (text).
- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][59]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 145
  (text) and line 153 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][60]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 44 (text).
- [automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][61]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text) and line 32 (text).
- [automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1][62]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (text).
- [automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][63]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  153 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][64]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 65 (text).
- [automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1][65]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text), line 41 (text) and line 50 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][66]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 131 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 132 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][67]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 55 (body comment) and
  line 76 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][68]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14 (body comment)
  (a passing mention only); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 4 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][69]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 583
  (text).

### docs × markdown (79 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][70]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 243 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2]: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1]: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.
- [docs/adr/index.md][71]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 162 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 163 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][72]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 34
  (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][73]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][74]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 54 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][75]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][76]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 22 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][77]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 102 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][78]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24
  (text).
- [docs/references/automation/catzc-base-contracts/configs/contracts.yml.md][79]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][80]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 12 (text).
- [docs/references/automation/catzc-base-contracts/types/ContractsConfig.cs.md][81]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/automation/catzc-base-docs/Test-Glossary.ps1.md][82]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 27
  (text).
- [docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md][83]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][84]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 15 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][85]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 13 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][86]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  12 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][87]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 37
  (text).
- [docs/references/automation/catzc-base-docs/types/CheckMode.cs.md][88]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (text).
- [docs/references/automation/catzc-base-docs/types/CheckModes.cs.md][89]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][90]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 37 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][91]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text) and line 100 (text).
- [docs/references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][92]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md][93]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 19 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md][94]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 25 (text).
- [docs/references/automation/catzc-base-languages.md][95]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 49 (text).
- [docs/references/automation/catzc-base-languages/configs/file-carriers.yml.md][96]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 14 (text).
- [docs/references/automation/catzc-base-languages/configs/go.yml.md][97]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][98]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 41 (text).
- [docs/references/automation/catzc-base-languages/configs/python.yml.md][99]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  18 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md][100]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md][101]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 14 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][102]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][103]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 26 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][104]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/automation/catzc-base-maps/types/MapsConfig.cs.md][105]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (text).
- [docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md][106]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][107]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25
  (text).
- [docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md][108]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/automation/catzc-base-maps/types/MapsPalette.cs.md][109]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md][110]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 17 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md][111]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 13 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/links.yml.md][112]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md][113]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md][114]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 17 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md][115]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md][116]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 16 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][117]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 16 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][118]: selected by [ADR-AUTO-FAILFAST][2]:
  the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][119]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 12 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][120]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 12 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][121]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 12 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][122]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 12 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][123]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md][124]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 13 (text).
- [docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md][125]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 22 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md][126]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 13 (text).
- [docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md][127]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 11 (text).
- [docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md][128]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][129]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 13 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md][130]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][131]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 13 (text).
- [docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][132]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 13 (text).
- [docs/references/automation/catzc-base-timeouts/Assert-Wait.ps1.md][133]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23
  (text) and line 24 (text).
- [docs/references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][134]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 16 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][135]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 12 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][136]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 19 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md][137]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 22 (text).
- [docs/references/automation/catzc-base-typessystem.md][138]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [docs/references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][139]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 15 (text).
- [docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][140]: selected by [ADR-AUTO-FAILFAST][2]: the file cites
  it at line 15 (text).
- [docs/references/automation/catzc-base-variants/private/Get-Variant.ps1.md][141]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 18 (text).
- [docs/references/automation/catzc-tooling-inspiration/Get-Inspiration.ps1.md][142]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 15 (text).
- [docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md][143]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 15 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][144]: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 13 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md][145]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 18 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][146]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 12 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][147]: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1` line 174 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 261 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 277 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Contracts/types/ContractCommand.cs` line 8 (body comment),
  `automation/Catzc.Base.Contracts/types/ContractParameter.cs` line 9 (body comment), `automation/Catzc.Base.Docs/configs/adrs.yml` line 131
  (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 14 (body comment),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 2 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 63 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 69 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 9 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 31 (text),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 155 (text),
  `automation/Catzc.Base.Languages/types/LayoutRow.cs` line 6 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 171 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 98 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 102 (text),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 6 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 16 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1` line 1 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 3 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/types/PlansConfig.cs` line 1 (header),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 43 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 65 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 32 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line 19 (text),
  `automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 153 (text),
  `automation/Catzc.Base.VSCode/types/VscodeOwnExtension.cs` line 9 (body comment),
  `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 65 (text),
  `automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 31 (text),
  `automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 41 (text),
  `automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 50 (text) and
  `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line 20 (body comment); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 132 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 55 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47
  (text), `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 583 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 145 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 153 (text) and
  `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44 (text).

## Keywords

- [world map][149]
- [track][150]
- [file language][151]
- [cell][152]
- [lit cell][153]
- [.claude][154]: a track
- [automation][154]: a track
- [docs][154]: a track
- [pipelines][154]: a track
- [csharp][155]: a file language
- [markdown][155]: a file language
- [pipeline-yaml][155]: a file language
- [powershell][155]: a file language
- [yaml][155]: a file language

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
[14]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[15]: ../../../../.claude/plans/plan-lazy-types-load.md
[16]: ../../../../.claude/plans/plan-master.md
[17]: ../../../../.claude/plans/plan-materialization-of-knowledge.md
[18]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[19]: ../../../../.claude/plans/plan-out-artifacts.md
[20]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[21]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[22]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[23]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[24]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[25]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[26]: ../../../../.claude/plans/task-assert-wait.md
[27]: ../../../../.claude/plans/task-config-defaults-postures.md
[28]: ../../../../.claude/plans/task-config-defaults-variants.md
[29]: ../../../../.claude/plans/task-import-landing-zone.md
[30]: ../../../../.claude/plans/task-lazy-types-load.md
[31]: ../../../../.claude/skills/catzc-module/SKILL.md
[32]: ../../../../automation/Catzc.Base.Contracts/types/ContractCommand.cs
[33]: ../../../../automation/Catzc.Base.Contracts/types/ContractParameter.cs
[34]: ../../../../automation/Catzc.Base.Languages/types/LayoutRow.cs
[35]: ../../../../automation/Catzc.Base.QualityGates/types/PlansConfig.cs
[36]: ../../../../automation/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
[37]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[38]: ../../../../automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[39]: ../../../../automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[40]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
[41]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[42]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[43]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[44]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[45]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[46]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[47]: ../../../../automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[48]: ../../../../automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[49]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[50]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[51]: ../../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[52]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
[53]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[54]: ../../../../automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[55]: ../../../../automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
[56]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[57]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[58]: ../../../../automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[59]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[60]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[61]: ../../../../automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[62]: ../../../../automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
[63]: ../../../../automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[64]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[65]: ../../../../automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
[66]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[67]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[68]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[69]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[70]: ../../../adr/automation/dora-explains.md
[71]: ../../../adr/index.md
[72]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[73]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[74]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[75]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[76]: ../../../references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[77]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[78]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[79]: ../../../references/automation/catzc-base-contracts/configs/contracts.yml.md
[80]: ../../../references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[81]: ../../../references/automation/catzc-base-contracts/types/ContractsConfig.cs.md
[82]: ../../../references/automation/catzc-base-docs/Test-Glossary.ps1.md
[83]: ../../../references/automation/catzc-base-docs/configs/adr-checks.yml.md
[84]: ../../../references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[85]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[86]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[87]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[88]: ../../../references/automation/catzc-base-docs/types/CheckMode.cs.md
[89]: ../../../references/automation/catzc-base-docs/types/CheckModes.cs.md
[90]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[91]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[92]: ../../../references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[93]: ../../../references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[94]: ../../../references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md
[95]: ../../../references/automation/catzc-base-languages.md
[96]: ../../../references/automation/catzc-base-languages/configs/file-carriers.yml.md
[97]: ../../../references/automation/catzc-base-languages/configs/go.yml.md
[98]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[99]: ../../../references/automation/catzc-base-languages/configs/python.yml.md
[100]: ../../../references/automation/catzc-base-languages/types/FileCarrier.cs.md
[101]: ../../../references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md
[102]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[103]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[104]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[105]: ../../../references/automation/catzc-base-maps/types/MapsConfig.cs.md
[106]: ../../../references/automation/catzc-base-maps/types/MapsHighlight.cs.md
[107]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[108]: ../../../references/automation/catzc-base-maps/types/MapsLimits.cs.md
[109]: ../../../references/automation/catzc-base-maps/types/MapsPalette.cs.md
[110]: ../../../references/automation/catzc-base-qualitygates/configs/comments.yml.md
[111]: ../../../references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
[112]: ../../../references/automation/catzc-base-qualitygates/configs/links.yml.md
[113]: ../../../references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[114]: ../../../references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
[115]: ../../../references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
[116]: ../../../references/automation/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md
[117]: ../../../references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[118]: ../../../references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[119]: ../../../references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[120]: ../../../references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[121]: ../../../references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[122]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[123]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[124]: ../../../references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md
[125]: ../../../references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[126]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
[127]: ../../../references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[128]: ../../../references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md
[129]: ../../../references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[130]: ../../../references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md
[131]: ../../../references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[132]: ../../../references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[133]: ../../../references/automation/catzc-base-timeouts/Assert-Wait.ps1.md
[134]: ../../../references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[135]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[136]: ../../../references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[137]: ../../../references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[138]: ../../../references/automation/catzc-base-typessystem.md
[139]: ../../../references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[140]: ../../../references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[141]: ../../../references/automation/catzc-base-variants/private/Get-Variant.ps1.md
[142]: ../../../references/automation/catzc-tooling-inspiration/Get-Inspiration.ps1.md
[143]: ../../../references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
[144]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[145]: ../../../references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[146]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[147]: ../../../../pipelines/ci-automation.yaml
[148]: ../../automation/resolve-one-limit-in-code-order.md
[149]: ../../../adr/glossary.md#world-map
[150]: ../../../adr/glossary.md#track
[151]: ../../../adr/glossary.md#file-language
[152]: ../../../adr/glossary.md#cell
[153]: ../../../adr/glossary.md#lit-cell
[154]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[155]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/grid/adr-auto-failfast--resolve-one-limit-in-code-order--implementation.grid.md

`Grid minimap: adr-auto-failfast--resolve-one-limit-in-code-order--implementation`

![Grid minimap of adr-auto-failfast--resolve-one-limit-in-code-order--implementation](adr-auto-failfast--resolve-one-limit-in-code-order--implementation.grid.png)

The grid minimap of the slide `adr-auto-failfast--resolve-one-limit-in-code-order--implementation` (implementation lens). The slide supports
[ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 22 lit of 51 files
- .unordered × markdown: 10 lit of 20 files
- automation × csharp: 29 lit of 272 files
- automation × powershell: 30 lit of 1563 files
- automation × yaml: 3 lit of 107 files
- docs × markdown: 59 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (22 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 46 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 105 (text).
- [.claude/agents/build-inspiration-module.md][7]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text) and line 47
  (text).
- [.claude/agents/session-cost-audit.md][8]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 29 (text) and line 41 (text).
- [.claude/agents/test-optimization.md][9]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 29 (text) and line 59 (text).
- [.claude/plans/decisions-2026-10-16.md][10]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 37 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][11]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 136 (text) and
  line 424 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][12]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 104 (text), line 112
  (text), line 122 (text), line 124 (text), line 143 (text), line 149 (text), line 221 (text) and line 239 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 33 (text), line 198 (text) and line 199 (text).
- [.claude/plans/plan-config-defaults.md][13]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text), line 61 (text), line
  104 (text), line 160 (text) and line 222 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 27 (text) and line 224
  (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][14]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 191 (text) and
  line 305 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][15]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 400 (text),
  line 433 (text), line 435 (text), line 568 (text) and line 659 (text).
- [.claude/plans/plan-lazy-types-load.md][16]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 127 (text), line 181 (text) and
  line 235 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 163 (text).
- [.claude/plans/plan-materialization-of-knowledge.md][17]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25 (text) and line
  91 (text).
- [.claude/plans/plan-minimal-robots-agents.md][18]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 61 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][19]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 101 (text).
- [.claude/plans/plan-module-kinds-tracks.md][20]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 156 (text), line 219 (text)
  and line 258 (text).
- [.claude/plans/plan-out-artifacts.md][21]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 118 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][22]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 140 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][23]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 16
  (text).
- [.claude/plans/prompt-config-defaults-continue.md][24]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][25]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][26]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text) and line 28
  (text).
- [.claude/plans/questionnaire-2026-10-16.md][27]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 121 (text).

### .unordered × markdown (10 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][28]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 107 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][29]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 12 (text), line 29 (text),
  line 110 (text), line 214 (text) and line 273 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 13 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][30]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 44 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][31]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 30 (text).
- [.unordered/15-10-2026/plan-contracts.md][32]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 220 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][33]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 14 (text) and line 16
  (text).
- [.unordered/15-10-2026/plan-duration-categories.md][34]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 12 (text); selected
  by [ADR-AUTO-FAILFAST][2]: the file cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][35]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 129 (text).
- [.unordered/15-10-2026/plan-strip-comments.md][36]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 77 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][37]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 70 (text).

### automation × csharp (29 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure/types/AzureConfig.cs][38]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][39]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][40]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][41]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Docs/types/CheckMode.cs][42]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][43]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][44]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/FileCarrier.cs][45]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Languages/types/FileCarriersConfig.cs][46]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][47]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][48]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][49]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][50]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][51]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][52]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][53]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/types/CommentsConfig.cs][54]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs][55]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaKind.cs][56]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs][57]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][58]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][59]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  20 (text).
- [automation/Catzc.Base.QualityGates/types/SourceCheck.cs][60]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][61]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (text).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][62]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (text).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][63]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][64]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][65]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][66]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 20
  (text).

### automation × powershell (30 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][67]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20
  (header) and line 35 (header).
- [automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][68]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header), line 117 (text), line 285 (text) and line 301 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][69]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header), line 25 (text) and line 49 (text).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][70]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header) and line 40
  (header).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][71]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19
  (header) and line 25 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][72]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][73]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header) and line 27 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][74]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header) and line 26 (text).
- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][75]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (header), line 86 (text) and line 92 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (header) and line 70 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][76]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header), line 25 (text), line 32 (text) and line 73 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][77]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (header) and line 45 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (header) and line 86 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][78]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header) and
  line 42 (header).
- [automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][79]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 18 (header) and line 54 (text).
- [automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][80]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header) and line 153 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1][81]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19
  (header) and line 26 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][82]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  20 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][83]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 22 (header) and line 42 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][84]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 18 (header) and line 203 (text).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][85]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header), line 27 (text), line 123 (text) and line 127 (text).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][86]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header) and line 31 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][87]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (header), line 39 (text) and line 89 (text).
- [automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][88]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header) and line 26 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][89]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  19 (header) and line 25 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][90]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 19 (header), line 26 (text) and line 50 (text).
- [automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][91]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 18 (header), line 65 (text) and line 87 (text).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][92]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (header) and
  line 25 (header).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][93]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 20
  (header) and line 26 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][94]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 21
  (header) and line 28 (header).
- [automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1][95]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header)
  and line 25 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][96]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 19 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][97]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 146 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 147 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][98]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][99]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 598
  (text).

### docs × markdown (59 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][100]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 291 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 308 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2]: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1]: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.
- [docs/adr/index.md][101]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 155 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 156 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][102]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 46 (text).
- [docs/references/automation/catzc-base-contracts/configs/contracts.yml.md][103]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 35 (text).
- [docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][104]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-contracts/types/ContractsConfig.cs.md][105]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md][106]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][107]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 31 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][108]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][109]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 58 (text).
- [docs/references/automation/catzc-base-docs/types/CheckMode.cs.md][110]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 39 (text).
- [docs/references/automation/catzc-base-docs/types/CheckModes.cs.md][111]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 34 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][112]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 16 (text) and line 56 (text).
- [docs/references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][113]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-languages.md][114]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 82 (text).
- [docs/references/automation/catzc-base-languages/configs/file-carriers.yml.md][115]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/configs/go.yml.md][116]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][117]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 63 (text).
- [docs/references/automation/catzc-base-languages/configs/python.yml.md][118]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  16 (text) and line 36 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md][119]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md][120]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][121]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  16 (text) and line 33 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][122]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 48 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][123]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/MapsConfig.cs.md][124]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 39 (text).
- [docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md][125]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  16 (text) and line 36 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][126]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 45 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md][127]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 34 (text).
- [docs/references/automation/catzc-base-maps/types/MapsPalette.cs.md][128]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md][129]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 39 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md][130]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/links.yml.md][131]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md][132]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md][133]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 16 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md][134]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][135]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][136]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][137]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][138]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][139]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md][140]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md][141]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 42 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md][142]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md][143]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 16 (text) and line 29 (text).
- [docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md][144]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][145]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 16 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md][146]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][147]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][148]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 16 (text) and line 33 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][149]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 16 (text) and line 30 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][150]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 16 (text) and line 39 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md][151]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 16 (text) and line 42 (text).
- [docs/references/automation/catzc-base-typessystem.md][152]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 15 (text) and
  line 99 (text).
- [docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md][153]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 16 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][154]: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 16 (text) and line 33 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md][155]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 16 (text) and line 37 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][156]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 16 (text) and line 30 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][157]: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure/types/AzureConfig.cs` line 20 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 117 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 285 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 301 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 49 (text),
  `automation/Catzc.Base.Contracts/types/ContractsConfig.cs` line 20 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 146 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 26 (text), `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line
  20 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 20 (text), `automation/Catzc.Base.Docs/types/CheckMode.cs` line 19
  (text), `automation/Catzc.Base.Docs/types/CheckModes.cs` line 20 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 18 (header), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 86 (text),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 92 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 32 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 73 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 45 (text),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 54 (text),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 153 (text),
  `automation/Catzc.Base.Languages/types/FileCarrier.cs` line 19 (text), `automation/Catzc.Base.Languages/types/FileCarriersConfig.cs` line
  20 (text), `automation/Catzc.Base.Languages/types/GoConfig.cs` line 20 (text), `automation/Catzc.Base.Languages/types/LanguagesConfig.cs`
  line 20 (text), `automation/Catzc.Base.Maps/types/MapsConfig.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsHighlight.cs` line
  19 (text), `automation/Catzc.Base.Maps/types/MapsLabels.cs` line 19 (text), `automation/Catzc.Base.Maps/types/MapsLimits.cs` line 19
  (text), `automation/Catzc.Base.Maps/types/MapsPalette.cs` line 19 (text),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 26 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 203 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 123 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 127 (text),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 31 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 39 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 89 (text),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.QualityGates/types/CommentsConfig.cs` line 20 (text), `automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs`
  line 20 (text), `automation/Catzc.Base.QualityGates/types/FileMetaKind.cs` line 19 (text),
  `automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs` line 19 (text), `automation/Catzc.Base.QualityGates/types/LinksConfig.cs`
  line 20 (text), `automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/SourceCheck.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs` line 20 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 18 (header),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 65 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs` line 20 (text), `automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs`
  line 20 (text), `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 19 (header),
  `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 25 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1` line 19 (header) and
  `automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs` line 20 (text); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1`
  line 20 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 35 (header),
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

- [world map][158]
- [track][159]
- [file language][160]
- [cell][161]
- [lit cell][162]
- [.claude][163]: a track
- [.unordered][163]: a track
- [automation][163]: a track
- [docs][163]: a track
- [pipelines][163]: a track
- [csharp][164]: a file language
- [markdown][164]: a file language
- [pipeline-yaml][164]: a file language
- [powershell][164]: a file language
- [yaml][164]: a file language

[1]: ../../../adr/automation/sensible-defaults.md
[2]: ../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/agents/build-inspiration-module.md
[8]: ../../../../.claude/agents/session-cost-audit.md
[9]: ../../../../.claude/agents/test-optimization.md
[10]: ../../../../.claude/plans/decisions-2026-10-16.md
[11]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[12]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[13]: ../../../../.claude/plans/plan-config-defaults.md
[14]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[15]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[16]: ../../../../.claude/plans/plan-lazy-types-load.md
[17]: ../../../../.claude/plans/plan-materialization-of-knowledge.md
[18]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[19]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[20]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[21]: ../../../../.claude/plans/plan-out-artifacts.md
[22]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[23]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[24]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[25]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[26]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[27]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[28]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[29]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[30]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[31]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[32]: ../../../../.unordered/15-10-2026/plan-contracts.md
[33]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[34]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[35]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[36]: ../../../../.unordered/15-10-2026/plan-strip-comments.md
[37]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[38]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[39]: ../../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[40]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[41]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[42]: ../../../../automation/Catzc.Base.Docs/types/CheckMode.cs
[43]: ../../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[44]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[45]: ../../../../automation/Catzc.Base.Languages/types/FileCarrier.cs
[46]: ../../../../automation/Catzc.Base.Languages/types/FileCarriersConfig.cs
[47]: ../../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[48]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[49]: ../../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[50]: ../../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[51]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[52]: ../../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[53]: ../../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[54]: ../../../../automation/Catzc.Base.QualityGates/types/CommentsConfig.cs
[55]: ../../../../automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
[56]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaKind.cs
[57]: ../../../../automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs
[58]: ../../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[59]: ../../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[60]: ../../../../automation/Catzc.Base.QualityGates/types/SourceCheck.cs
[61]: ../../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[62]: ../../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[63]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[64]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[65]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[66]: ../../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[67]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[68]: ../../../../automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[69]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[70]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[71]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[72]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[73]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[74]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[75]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[76]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[77]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[78]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[79]: ../../../../automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[80]: ../../../../automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[81]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
[82]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[83]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[84]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[85]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[86]: ../../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[87]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[88]: ../../../../automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[89]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[90]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[91]: ../../../../automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[92]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[93]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[94]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[95]: ../../../../automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1
[96]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[97]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[98]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[99]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[100]: ../../../adr/automation/dora-explains.md
[101]: ../../../adr/index.md
[102]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[103]: ../../../references/automation/catzc-base-contracts/configs/contracts.yml.md
[104]: ../../../references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[105]: ../../../references/automation/catzc-base-contracts/types/ContractsConfig.cs.md
[106]: ../../../references/automation/catzc-base-docs/configs/adr-checks.yml.md
[107]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[108]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[109]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[110]: ../../../references/automation/catzc-base-docs/types/CheckMode.cs.md
[111]: ../../../references/automation/catzc-base-docs/types/CheckModes.cs.md
[112]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[113]: ../../../references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[114]: ../../../references/automation/catzc-base-languages.md
[115]: ../../../references/automation/catzc-base-languages/configs/file-carriers.yml.md
[116]: ../../../references/automation/catzc-base-languages/configs/go.yml.md
[117]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[118]: ../../../references/automation/catzc-base-languages/configs/python.yml.md
[119]: ../../../references/automation/catzc-base-languages/types/FileCarrier.cs.md
[120]: ../../../references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md
[121]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[122]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[123]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[124]: ../../../references/automation/catzc-base-maps/types/MapsConfig.cs.md
[125]: ../../../references/automation/catzc-base-maps/types/MapsHighlight.cs.md
[126]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[127]: ../../../references/automation/catzc-base-maps/types/MapsLimits.cs.md
[128]: ../../../references/automation/catzc-base-maps/types/MapsPalette.cs.md
[129]: ../../../references/automation/catzc-base-qualitygates/configs/comments.yml.md
[130]: ../../../references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
[131]: ../../../references/automation/catzc-base-qualitygates/configs/links.yml.md
[132]: ../../../references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[133]: ../../../references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
[134]: ../../../references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
[135]: ../../../references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[136]: ../../../references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[137]: ../../../references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[138]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[139]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[140]: ../../../references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md
[141]: ../../../references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[142]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
[143]: ../../../references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[144]: ../../../references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md
[145]: ../../../references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[146]: ../../../references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md
[147]: ../../../references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[148]: ../../../references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[149]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[150]: ../../../references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[151]: ../../../references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[152]: ../../../references/automation/catzc-base-typessystem.md
[153]: ../../../references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
[154]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[155]: ../../../references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[156]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[157]: ../../../../pipelines/ci-automation.yaml
[158]: ../../../adr/glossary.md#world-map
[159]: ../../../adr/glossary.md#track
[160]: ../../../adr/glossary.md#file-language
[161]: ../../../adr/glossary.md#cell
[162]: ../../../adr/glossary.md#lit-cell
[163]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[164]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

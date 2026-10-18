---
catzc:
  immutable:
    with_body_sha: "3b8893e8234b"
    repo_status: locked
    path: docs/explanation/automation/.assets/a-stopped-run-names-its-limit/grid.md
    source: docs/explanation/automation/.assets/a-stopped-run-names-its-limit/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A run past its limit stops with a message that names the limit and where to change it: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 142 files.
```

![The world-map minimap of A run past its limit stops with a message that names the limit and where to change it](grid.png)

This is the world-map minimap in the sidebar of the operations diagram of [A run past its limit stops with a message that names the limit
and where to change it][146], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights every cell of the world map that
holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code
that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 15 lit of 89 files
- docs × markdown: 82 lit of 2757 files
- pipelines × pipeline-yaml: 1 lit of 9 files
- pwsh × csharp: 7 lit of 293 files
- pwsh × powershell: 31 lit of 1649 files
- pwsh × yaml: 6 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (15 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 51 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 121 (text).
- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text), line 30 (text), line
  31 (text) and line 124 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 39 (text), line 39 (text), line 161 (text)
  and line 168 (text).
- [.claude/plans/decisions-2026-10-18.md][8]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18 (text) and line 35 (text).
- [.claude/plans/plan-adr-code-language.md][9]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 31 (text), line 37 (text),
  line 39 (text), line 89 (text), line 89 (text), line 90 (text), line 92 (text), line 93 (text), line 105 (text) and line 108 (text).
- [.claude/plans/plan-assert-wait.md][10]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 64 (text) and line 65 (text);
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (text), line 33 (text), line 41 (text), line 86 (text), line 88 (text),
  line 89 (text), line 129 (text) and line 137 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][11]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 51 (text), line 65
  (text) and line 106 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][12]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 212 (text)
  and line 214 (text).
- [.claude/plans/prompt-assert-wait-1-watch-blocking.md][13]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 18 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][14]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 17
  (text).
- [.claude/plans/prompt-loose-ends-1-flag-and-comments.md][15]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][16]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [.claude/plans/questionnaire-2026-10-16.md][17]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 121 (text).
- [.claude/plans/task-assert-wait.md][18]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 54 (text).
- [.claude/plans/value-of-plan.md][19]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 68 (text).
- [.claude/skills/catzc-module/SKILL.md][20]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text) and line 39 (text).

### docs × markdown (82 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][21]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 243 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2]: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1]: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.
- [docs/adr/glossary.md][22]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 773 (text).
- [docs/adr/index.md][23]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 162 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 163 (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][24]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 34 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][25]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][26]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 54 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][27]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][28]: selected by [ADR-AUTO-FAILFAST][2]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][29]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][30]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-base-contracts/configs/contracts.yml.md][31]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][32]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md][33]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][34]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adr-checks.yml.md][35]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][36]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][37]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][38]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][39]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckMode.cs.md][40]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckModes.cs.md][41]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][42]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][43]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][44]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][45]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][46]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-languages.md][47]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 49 (text).
- [docs/references/pwsh/catzc-base-languages/configs/file-carriers.yml.md][48]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-languages/configs/go.yml.md][49]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][50]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 41
  (text).
- [docs/references/pwsh/catzc-base-languages/configs/python.yml.md][51]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileCarrier.cs.md][52]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md][53]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md][54]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][55]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  26 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][56]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsConfig.cs.md][57]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md][58]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][59]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLimits.cs.md][60]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsPalette.cs.md][61]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][62]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 49 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/comments.yml.md][63]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md][64]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/links.yml.md][65]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/parameter-consistency.yml.md][66]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md][67]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md][68]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md][69]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][70]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][71]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][72]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][73]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][74]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][75]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][76]: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md][77]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/EngineSetCheck.cs.md][78]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/FileMetaKind.cs.md][79]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/GeneratedWriter.cs.md][80]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md][81]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][82]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceCheck.cs.md][83]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][84]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][85]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-timeouts/Assert-Wait.ps1.md][86]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (text)
  and line 24 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][87]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][88]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][89]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 19 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md][90]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 22
  (text).
- [docs/references/pwsh/catzc-base-typessystem.md][91]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][92]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][93]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md][94]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][95]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 57
  (text).
- [docs/references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md][96]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md][97]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][98]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md][99]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][100]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  12 (text) and line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][101]: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Config/configs/glossary.yml` line 5 (text), `pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1` line 174 (text),
  `pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1` line 248 (text), `pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1` line 262 (text),
  `pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs` line 10 (body comment), `pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1`
  line 93 (text), `pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 261 (text),
  `pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 277 (text),
  `pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 92 (text),
  `pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 26 (text), `pwsh/Catzc.Base.Contracts/types/ContractCommand.cs`
  line 8 (body comment), `pwsh/Catzc.Base.Contracts/types/ContractParameter.cs` line 9 (body comment),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 131 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 14 (body comment),
  `pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 2 (text), `pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 2
  (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 63 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 69 (text), `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 9 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 50 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 167 (text), `pwsh/Catzc.Base.Languages/types/LayoutRow.cs` line 6
  (body comment), `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 27 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 171 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1` line 57 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 98 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 102 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 6 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 16 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 66 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 3 (text),
  `pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 27 (text),
  `pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs` line 1 (header), `pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1`
  line 43 (text), `pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 65 (text),
  `pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1` line 14 (text), `pwsh/Catzc.Base.Reports/types/QualityGateResult.cs`
  line 8 (body comment), `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 7 (text), `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1`
  line 46 (text), `pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line 19 (text),
  `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 153 (text), `pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs` line
  9 (body comment), `pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 65 (text),
  `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 41 (text) and
  `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 50 (text); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 55 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line
  585 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 145 (text),
  `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 153 (text) and `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44
  (text).

### pwsh × csharp (7 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs][102]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 10 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.Contracts/types/ContractCommand.cs][103]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Contracts/types/ContractParameter.cs][104]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Languages/types/LayoutRow.cs][105]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs][106]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (header).
- [pwsh/Catzc.Base.Reports/types/QualityGateResult.cs][107]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs][108]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body comment)
  (a passing mention only).

### pwsh × powershell (31 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1][109]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1][110]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 174 (text), line
  248 (text) and line 262 (text).
- [pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][111]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 93 (text),
  line 261 (text) and line 277 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1][112]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 28
  (text) and line 92 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][113]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text) and line 26 (text).
- [pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][114]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][115]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][116]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 63 (text) and
  line 69 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 47 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][117]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 9 (text) and line 50 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][118]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 23 (text);
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][119]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text).
- [pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][120]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 167
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][121]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  171 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][122]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 57
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][123]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 98 (text) and line 102 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][124]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1][125]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][126]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 66 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][127]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1][128]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][129]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][130]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 3 (text) and line 27 (text).
- [pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][131]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 43
  (text) and line 65 (text).
- [pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1][132]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14
  (text).
- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][133]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 145 (text)
  and line 153 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][134]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 44 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][135]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text),
  line 7 (text) and line 46 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1][136]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][137]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 153
  (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][138]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 65 (text).
- [pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1][139]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text), line 41 (text) and line 50 (text).

### pwsh × yaml (6 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Config/configs/glossary.yml][140]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 5 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][141]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 131 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 132 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][142]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 55 (body comment) and line
  76 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][143]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14 (body comment) (a
  passing mention only); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 4 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][144]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 27 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][145]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 585 (text).

## Keywords

- [world map][147]
- [track][148]
- [file language][149]
- [cell][150]
- [lit cell][151]
- [.claude][152]: a track
- [docs][152]: a track
- [pipelines][152]: a track
- [pwsh][152]: a track
- [csharp][153]: a file language
- [markdown][153]: a file language
- [pipeline-yaml][153]: a file language
- [powershell][153]: a file language
- [yaml][153]: a file language

Terms the cited ADRs define:

- [posture][154], defined by [ADR-AUTO-DEFAULT#6][155]

[1]: ../../../../adr/automation/sensible-defaults.md
[2]: ../../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/CLAUDE.md
[7]: ../../../../../.claude/plans/decisions-2026-10-16.md
[8]: ../../../../../.claude/plans/decisions-2026-10-18.md
[9]: ../../../../../.claude/plans/plan-adr-code-language.md
[10]: ../../../../../.claude/plans/plan-assert-wait.md
[11]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[12]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[13]: ../../../../../.claude/plans/prompt-assert-wait-1-watch-blocking.md
[14]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[15]: ../../../../../.claude/plans/prompt-loose-ends-1-flag-and-comments.md
[16]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[17]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[18]: ../../../../../.claude/plans/task-assert-wait.md
[19]: ../../../../../.claude/plans/value-of-plan.md
[20]: ../../../../../.claude/skills/catzc-module/SKILL.md
[21]: ../../../../adr/automation/dora-explains.md
[22]: ../../../../adr/glossary.md
[23]: ../../../../adr/index.md
[24]: ../../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[25]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[26]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[27]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[28]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[29]: ../../../../references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[30]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[31]: ../../../../references/pwsh/catzc-base-contracts/configs/contracts.yml.md
[32]: ../../../../references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[33]: ../../../../references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md
[34]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[35]: ../../../../references/pwsh/catzc-base-docs/configs/adr-checks.yml.md
[36]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[37]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[38]: ../../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[39]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[40]: ../../../../references/pwsh/catzc-base-docs/types/CheckMode.cs.md
[41]: ../../../../references/pwsh/catzc-base-docs/types/CheckModes.cs.md
[42]: ../../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[43]: ../../../../references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[44]: ../../../../references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[45]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[46]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[47]: ../../../../references/pwsh/catzc-base-languages.md
[48]: ../../../../references/pwsh/catzc-base-languages/configs/file-carriers.yml.md
[49]: ../../../../references/pwsh/catzc-base-languages/configs/go.yml.md
[50]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[51]: ../../../../references/pwsh/catzc-base-languages/configs/python.yml.md
[52]: ../../../../references/pwsh/catzc-base-languages/types/FileCarrier.cs.md
[53]: ../../../../references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md
[54]: ../../../../references/pwsh/catzc-base-languages/types/GoConfig.cs.md
[55]: ../../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[56]: ../../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[57]: ../../../../references/pwsh/catzc-base-maps/types/MapsConfig.cs.md
[58]: ../../../../references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md
[59]: ../../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[60]: ../../../../references/pwsh/catzc-base-maps/types/MapsLimits.cs.md
[61]: ../../../../references/pwsh/catzc-base-maps/types/MapsPalette.cs.md
[62]: ../../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[63]: ../../../../references/pwsh/catzc-base-qualitygates/configs/comments.yml.md
[64]: ../../../../references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md
[65]: ../../../../references/pwsh/catzc-base-qualitygates/configs/links.yml.md
[66]: ../../../../references/pwsh/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[67]: ../../../../references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md
[68]: ../../../../references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md
[69]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md
[70]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[71]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[72]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[73]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[74]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[75]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[76]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[77]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md
[78]: ../../../../references/pwsh/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[79]: ../../../../references/pwsh/catzc-base-qualitygates/types/FileMetaKind.cs.md
[80]: ../../../../references/pwsh/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[81]: ../../../../references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md
[82]: ../../../../references/pwsh/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[83]: ../../../../references/pwsh/catzc-base-qualitygates/types/SourceCheck.cs.md
[84]: ../../../../references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[85]: ../../../../references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[86]: ../../../../references/pwsh/catzc-base-timeouts/Assert-Wait.ps1.md
[87]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[88]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[89]: ../../../../references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[90]: ../../../../references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[91]: ../../../../references/pwsh/catzc-base-typessystem.md
[92]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[93]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[94]: ../../../../references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md
[95]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[96]: ../../../../references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md
[97]: ../../../../references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md
[98]: ../../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[99]: ../../../../references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[100]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[101]: ../../../../../pipelines/ci-automation.yaml
[102]: ../../../../../pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs
[103]: ../../../../../pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
[104]: ../../../../../pwsh/Catzc.Base.Contracts/types/ContractParameter.cs
[105]: ../../../../../pwsh/Catzc.Base.Languages/types/LayoutRow.cs
[106]: ../../../../../pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs
[107]: ../../../../../pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
[108]: ../../../../../pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
[109]: ../../../../../pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1
[110]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[111]: ../../../../../pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[112]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
[113]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[114]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[115]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[116]: ../../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[117]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[118]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[119]: ../../../../../pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[120]: ../../../../../pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[121]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[122]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[123]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[124]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[125]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
[126]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[127]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[128]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
[129]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[130]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[131]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[132]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
[133]: ../../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[134]: ../../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[135]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[136]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
[137]: ../../../../../pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[138]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[139]: ../../../../../pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
[140]: ../../../../../pwsh/Catzc.Base.Config/configs/glossary.yml
[141]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[142]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[143]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[144]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[145]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[146]: ../../a-stopped-run-names-its-limit.md
[147]: ../../../../adr/glossary.md#world-map
[148]: ../../../../adr/glossary.md#track
[149]: ../../../../adr/glossary.md#file-language
[150]: ../../../../adr/glossary.md#cell
[151]: ../../../../adr/glossary.md#lit-cell
[152]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[153]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[154]: ../../../../adr/glossary.md#posture
[155]: ../../../../adr/automation/sensible-defaults.md#rule-adr-auto-default6

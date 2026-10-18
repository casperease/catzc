---
catzc:
  immutable:
    with_body_sha: cc50daab2f1d
    repo_status: locked
    path: docs/explanation/automation/.assets/one-rule-per-stage-and-two-gaps/grid.md
    source: docs/explanation/automation/.assets/one-rule-per-stage-and-two-gaps/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two rules govern every stage, tests and the hook check them, and two gaps remain: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 135 files.
```

![The world-map minimap of Two rules govern every stage, tests and the hook check them, and two gaps remain](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Two rules govern every stage, tests and the hook check them, and
two gaps remain][137], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights every cell of the world map that holds a
file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that
selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 4 lit of 49 files
- docs × markdown: 82 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × csharp: 9 lit of 295 files
- pwsh × powershell: 34 lit of 1657 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (4 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 51 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 121 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][5]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 82 (text) and
  line 84 (text).
- [.claude/plans/plan-test-run-budget.md][6]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 84 (text).
- [.claude/skills/catzc-module/SKILL.md][7]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text) and line 41 (text).

### docs × markdown (82 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][8]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 243 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2]: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1]: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.
- [docs/adr/glossary.md][9]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 783 (text).
- [docs/adr/index.md][10]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 162 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 163 (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][11]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 34 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md][12]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 102 (text).
- [docs/references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md][13]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 63 (text).
- [docs/references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.verify.md][14]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 54 (text).
- [docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md][15]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.verify.md][16]: selected by [ADR-AUTO-FAILFAST][2]:
  the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][17]: selected by [ADR-AUTO-FAILFAST][2]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][18]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-base-contracts/configs/contracts.yml.md][19]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][20]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md][21]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][22]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adr-checks.yml.md][23]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][24]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][25]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][26]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][27]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckMode.cs.md][28]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckModes.cs.md][29]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][30]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][31]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][32]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 20 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][33]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 26
  (text).
- [docs/references/pwsh/catzc-base-languages.md][34]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 49 (text).
- [docs/references/pwsh/catzc-base-languages/configs/file-carriers.yml.md][35]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-languages/configs/go.yml.md][36]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][37]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 41
  (text).
- [docs/references/pwsh/catzc-base-languages/configs/python.yml.md][38]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileCarrier.cs.md][39]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md][40]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md][41]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][42]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  26 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][43]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsConfig.cs.md][44]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md][45]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][46]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLimits.cs.md][47]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsPalette.cs.md][48]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][49]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 49 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/comments.yml.md][50]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md][51]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/links.yml.md][52]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/parameter-consistency.yml.md][53]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md][54]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md][55]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md][56]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][57]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][58]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][59]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][60]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][61]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][62]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][63]: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md][64]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/EngineSetCheck.cs.md][65]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/FileMetaKind.cs.md][66]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/GeneratedWriter.cs.md][67]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md][68]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][69]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceCheck.cs.md][70]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][71]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][72]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][73]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md][74]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 24
  (text), line 25 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][75]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][76]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 19 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md][77]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 22
  (text).
- [docs/references/pwsh/catzc-base-typessystem.md][78]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][79]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][80]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md][81]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][82]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 57
  (text).
- [docs/references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md][83]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md][84]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][85]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md][86]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][87]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 12
  (text) and line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][88]: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites nothing itself carries its globset's
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
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 131 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 17 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 2 (text), `pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 2
  (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 63 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 69 (text), `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 9 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 50 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 169 (text), `pwsh/Catzc.Base.Languages/types/LayoutRow.cs` line 6
  (body comment), `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 33 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 159 (text),
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
  `pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs` line 1 (header), `pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1`
  line 16 (text), `pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 43 (text),
  `pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 65 (text),
  `pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1` line 14 (text),
  `pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1` line 21 (text), `pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs` line 6
  (body comment), `pwsh/Catzc.Base.Reports/types/QualityGateResult.cs` line 8 (body comment),
  `pwsh/Catzc.Base.Reports/types/TestRunResult.cs` line 6 (body comment), `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 2
  (text), `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 7 (text),
  `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 46 (text), `pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line
  19 (text), `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 163 (text),
  `pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs` line 9 (body comment), `pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 65
  (text), `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 41 (text) and
  `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` line 50 (text); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 132 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 55 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1` line 30 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1`
  line 152 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 160 (text),
  `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 46 (text) and `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1`
  line 133 (text).

### pwsh × csharp (9 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs][89]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 10 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.Contracts/types/ContractCommand.cs][90]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Contracts/types/ContractParameter.cs][91]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Languages/types/LayoutRow.cs][92]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs][93]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (header).
- [pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs][94]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Reports/types/QualityGateResult.cs][95]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Reports/types/TestRunResult.cs][96]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs][97]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body comment) (a
  passing mention only).

### pwsh × powershell (34 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1][98]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1][99]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 174 (text), line 248
  (text) and line 262 (text).
- [pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][100]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 93 (text),
  line 261 (text) and line 277 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1][101]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 28
  (text) and line 92 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][102]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text) and line 26 (text).
- [pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][103]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][104]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][105]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 63 (text) and
  line 69 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 47 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][106]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 9 (text) and line 50 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][107]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 23 (text);
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][108]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 30
  (text).
- [pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][109]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text).
- [pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][110]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 169
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][111]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  159 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][112]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 57
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][113]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 98 (text) and line 102 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][114]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1][115]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][116]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 66 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][117]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1][118]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][119]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][120]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 3 (text) and line 27 (text).
- [pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1][121]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text).
- [pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][122]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 43
  (text) and line 65 (text).
- [pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1][123]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14
  (text).
- [pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1][124]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 21
  (text).
- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][125]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 152 (text)
  and line 160 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][126]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 46 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][127]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text),
  line 7 (text) and line 46 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1][128]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][129]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 163
  (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 133 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][130]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 65 (text).
- [pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1][131]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text), line 41 (text) and line 50 (text).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Config/configs/glossary.yml][132]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 5 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][133]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 131 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 132 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][134]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 55 (text) and line 76
  (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][135]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 4 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][136]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 33 (text).

## Keywords

- [world map][138]
- [track][139]
- [file language][140]
- [cell][141]
- [lit cell][142]
- [.claude][143]: a track
- [docs][143]: a track
- [pipelines][143]: a track
- [pwsh][143]: a track
- [csharp][144]: a file language
- [markdown][144]: a file language
- [pipeline-yaml][144]: a file language
- [powershell][144]: a file language
- [yaml][144]: a file language

[1]: ../../../../adr/automation/sensible-defaults.md
[2]: ../../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[6]: ../../../../../.claude/plans/plan-test-run-budget.md
[7]: ../../../../../.claude/skills/catzc-module/SKILL.md
[8]: ../../../../adr/automation/dora-explains.md
[9]: ../../../../adr/glossary.md
[10]: ../../../../adr/index.md
[11]: ../../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[12]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md
[13]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.verify.md
[14]: ../../../../references/pwsh/.assets/azure-identity-resolves-from-config/diagram.drawio.verify.md
[15]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md
[16]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.verify.md
[17]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[18]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[19]: ../../../../references/pwsh/catzc-base-contracts/configs/contracts.yml.md
[20]: ../../../../references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[21]: ../../../../references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md
[22]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[23]: ../../../../references/pwsh/catzc-base-docs/configs/adr-checks.yml.md
[24]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[25]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[26]: ../../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[27]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[28]: ../../../../references/pwsh/catzc-base-docs/types/CheckMode.cs.md
[29]: ../../../../references/pwsh/catzc-base-docs/types/CheckModes.cs.md
[30]: ../../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[31]: ../../../../references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[32]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[33]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[34]: ../../../../references/pwsh/catzc-base-languages.md
[35]: ../../../../references/pwsh/catzc-base-languages/configs/file-carriers.yml.md
[36]: ../../../../references/pwsh/catzc-base-languages/configs/go.yml.md
[37]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[38]: ../../../../references/pwsh/catzc-base-languages/configs/python.yml.md
[39]: ../../../../references/pwsh/catzc-base-languages/types/FileCarrier.cs.md
[40]: ../../../../references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md
[41]: ../../../../references/pwsh/catzc-base-languages/types/GoConfig.cs.md
[42]: ../../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[43]: ../../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[44]: ../../../../references/pwsh/catzc-base-maps/types/MapsConfig.cs.md
[45]: ../../../../references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md
[46]: ../../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[47]: ../../../../references/pwsh/catzc-base-maps/types/MapsLimits.cs.md
[48]: ../../../../references/pwsh/catzc-base-maps/types/MapsPalette.cs.md
[49]: ../../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[50]: ../../../../references/pwsh/catzc-base-qualitygates/configs/comments.yml.md
[51]: ../../../../references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md
[52]: ../../../../references/pwsh/catzc-base-qualitygates/configs/links.yml.md
[53]: ../../../../references/pwsh/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[54]: ../../../../references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md
[55]: ../../../../references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md
[56]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md
[57]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[58]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[59]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[60]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[61]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[62]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[63]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[64]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md
[65]: ../../../../references/pwsh/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[66]: ../../../../references/pwsh/catzc-base-qualitygates/types/FileMetaKind.cs.md
[67]: ../../../../references/pwsh/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[68]: ../../../../references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md
[69]: ../../../../references/pwsh/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[70]: ../../../../references/pwsh/catzc-base-qualitygates/types/SourceCheck.cs.md
[71]: ../../../../references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[72]: ../../../../references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[73]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[74]: ../../../../references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
[75]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[76]: ../../../../references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[77]: ../../../../references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[78]: ../../../../references/pwsh/catzc-base-typessystem.md
[79]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[80]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[81]: ../../../../references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md
[82]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[83]: ../../../../references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md
[84]: ../../../../references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md
[85]: ../../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[86]: ../../../../references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[87]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[88]: ../../../../../pipelines/ci-automation.yaml
[89]: ../../../../../pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs
[90]: ../../../../../pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
[91]: ../../../../../pwsh/Catzc.Base.Contracts/types/ContractParameter.cs
[92]: ../../../../../pwsh/Catzc.Base.Languages/types/LayoutRow.cs
[93]: ../../../../../pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs
[94]: ../../../../../pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs
[95]: ../../../../../pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
[96]: ../../../../../pwsh/Catzc.Base.Reports/types/TestRunResult.cs
[97]: ../../../../../pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
[98]: ../../../../../pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1
[99]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[100]: ../../../../../pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[101]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
[102]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[103]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[104]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[105]: ../../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[106]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[107]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[108]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[109]: ../../../../../pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[110]: ../../../../../pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[111]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[112]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[113]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[114]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[115]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
[116]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[117]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[118]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
[119]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[120]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[121]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1
[122]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[123]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
[124]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1
[125]: ../../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[126]: ../../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[127]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[128]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
[129]: ../../../../../pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[130]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[131]: ../../../../../pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
[132]: ../../../../../pwsh/Catzc.Base.Config/configs/glossary.yml
[133]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[134]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[135]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[136]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[137]: ../../one-rule-per-stage-and-two-gaps.md
[138]: ../../../../adr/glossary.md#world-map
[139]: ../../../../adr/glossary.md#track
[140]: ../../../../adr/glossary.md#file-language
[141]: ../../../../adr/glossary.md#cell
[142]: ../../../../adr/glossary.md#lit-cell
[143]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[144]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

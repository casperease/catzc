---
catzc:
  immutable:
    with_body_sha: "44b63fd5df15"
    repo_status: locked
    path: docs/explanation/automation/.assets/three-tests-prove-the-hook/grid.md
    source: docs/explanation/automation/.assets/three-tests-prove-the-hook/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One rule bounds every call, three tests prove the hook, and the exemption route is ADR-only: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 141 files.
```

![The world-map minimap of One rule bounds every call, three tests prove the hook, and the exemption route is ADR-only](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [One rule bounds every call, three tests prove the hook, and the
exemption route is ADR-only][143], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights every cell of the world map
that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the
code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 15 lit of 89 files
- docs × markdown: 82 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × csharp: 7 lit of 293 files
- pwsh × powershell: 31 lit of 1651 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (15 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 51 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 121 (text).
- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text), line 30 (text), line
  31 (text) and line 124 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 39 (text), line 39 (text), line 161 (text)
  and line 168 (text).
- [.claude/plans/decisions-2026-10-18.md][6]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18 (text) and line 35 (text).
- [.claude/plans/plan-adr-code-language.md][7]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 31 (text), line 32 (text),
  line 37 (text), line 39 (text), line 89 (text), line 89 (text), line 90 (text), line 90 (text), line 92 (text), line 92 (text), line 93
  (text), line 93 (text), line 105 (text), line 105 (text), line 106 (text), line 107 (text), line 108 (text) and line 108 (text).
- [.claude/plans/plan-assert-wait.md][8]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 18 (text), line 32 (text), line 40
  (text), line 66 (text), line 107 (text), line 118 (text) and line 118 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][9]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 51 (text), line 67 (text)
  and line 109 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][10]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 216 (text)
  and line 218 (text).
- [.claude/plans/prompt-assert-wait-1-watch-blocking.md][11]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 18 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][12]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 17
  (text).
- [.claude/plans/prompt-loose-ends-1-flag-and-comments.md][13]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][14]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [.claude/plans/questionnaire-2026-10-16.md][15]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 121 (text).
- [.claude/plans/task-assert-wait.md][16]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 53 (text) and line 60 (text).
- [.claude/plans/value-of-plan.md][17]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 65 (text).
- [.claude/skills/catzc-module/SKILL.md][18]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 26 (text) and line 40 (text).

### docs × markdown (82 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][19]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 243 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 260 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2]: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1]: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.
- [docs/adr/glossary.md][20]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 782 (text).
- [docs/adr/index.md][21]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 162 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 163 (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][22]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 34 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][23]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 63 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][24]: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 54 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][25]: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 45 (text), line 58 (text), line 61 (text), line 62 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][26]: selected by [ADR-AUTO-FAILFAST][2]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][27]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 102 (text).
- [docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md][28]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-base-contracts/configs/contracts.yml.md][29]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][30]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md][31]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][32]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adr-checks.yml.md][33]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md][34]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][35]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][36]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][37]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckMode.cs.md][38]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckModes.cs.md][39]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md][40]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line
  37 (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][41]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 32 (text) and line 100 (text).
- [docs/references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][42]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][43]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 19 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][44]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-languages.md][45]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 49 (text).
- [docs/references/pwsh/catzc-base-languages/configs/file-carriers.yml.md][46]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-languages/configs/go.yml.md][47]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][48]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 41
  (text).
- [docs/references/pwsh/catzc-base-languages/configs/python.yml.md][49]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileCarrier.cs.md][50]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md][51]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md][52]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][53]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  26 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][54]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsConfig.cs.md][55]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md][56]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][57]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLimits.cs.md][58]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsPalette.cs.md][59]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][60]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 49 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/comments.yml.md][61]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md][62]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/links.yml.md][63]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/parameter-consistency.yml.md][64]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md][65]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md][66]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md][67]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][68]: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md][69]: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][70]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][71]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][72]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][73]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][74]: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md][75]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/EngineSetCheck.cs.md][76]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/FileMetaKind.cs.md][77]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/GeneratedWriter.cs.md][78]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md][79]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][80]: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceCheck.cs.md][81]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][82]: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][83]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md][84]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md][85]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23
  (text), line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md][86]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][87]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 19 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md][88]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 22
  (text).
- [docs/references/pwsh/catzc-base-typessystem.md][89]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [docs/references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md][90]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md][91]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md][92]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][93]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 57
  (text).
- [docs/references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md][94]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md][95]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][96]: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md][97]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 18 (text).
- [docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md][98]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 12
  (text) and line 39 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][99]: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites nothing itself carries its globset's
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
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 131 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 14 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 2 (text), `pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 2
  (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 63 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 69 (text), `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 9 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 50 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 169 (text), `pwsh/Catzc.Base.Languages/types/LayoutRow.cs` line 6
  (body comment), `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 27 (text),
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
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 55 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 4 (text), `pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 47 (text),
  `pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 64 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line
  152 (text), `pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 160 (text) and
  `pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 44 (text).

### pwsh × csharp (7 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs][100]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 10 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.Contracts/types/ContractCommand.cs][101]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Contracts/types/ContractParameter.cs][102]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Languages/types/LayoutRow.cs][103]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs][104]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (header).
- [pwsh/Catzc.Base.Reports/types/QualityGateResult.cs][105]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 8 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs][106]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 9 (body comment)
  (a passing mention only).

### pwsh × powershell (31 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1][107]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1][108]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 174 (text), line
  248 (text) and line 262 (text).
- [pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][109]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 93 (text),
  line 261 (text) and line 277 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1][110]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 28
  (text) and line 92 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][111]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text) and line 26 (text).
- [pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][112]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][113]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text).
- [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][114]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 63 (text) and
  line 69 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 47 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][115]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 9 (text) and line 50 (text).
- [pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][116]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 23 (text);
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 64 (text).
- [pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][117]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text).
- [pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][118]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 169
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][119]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  159 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][120]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 57
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][121]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text), line 98 (text) and line 102 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][122]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 6
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1][123]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][124]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 16
  (text) and line 66 (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][125]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1][126]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][127]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][128]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 3 (text) and line 27 (text).
- [pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][129]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 43
  (text) and line 65 (text).
- [pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1][130]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14
  (text).
- [pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][131]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 152 (text)
  and line 160 (text).
- [pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][132]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 44 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][133]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 2 (text),
  line 7 (text) and line 46 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1][134]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (text).
- [pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][135]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 153
  (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][136]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 65 (text).
- [pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1][137]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text), line 41 (text) and line 50 (text).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Config/configs/glossary.yml][138]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 5 (text).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][139]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 131 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 132 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][140]: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 55 (text) and line 76
  (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][141]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 14 (text); selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 4 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][142]: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 27 (text).

## Keywords

- [world map][144]
- [track][145]
- [file language][146]
- [cell][147]
- [lit cell][148]
- [.claude][149]: a track
- [docs][149]: a track
- [pipelines][149]: a track
- [pwsh][149]: a track
- [csharp][150]: a file language
- [markdown][150]: a file language
- [pipeline-yaml][150]: a file language
- [powershell][150]: a file language
- [yaml][150]: a file language

[1]: ../../../../adr/automation/sensible-defaults.md
[2]: ../../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../../.claude/plans/decisions-2026-10-18.md
[7]: ../../../../../.claude/plans/plan-adr-code-language.md
[8]: ../../../../../.claude/plans/plan-assert-wait.md
[9]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[10]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[11]: ../../../../../.claude/plans/prompt-assert-wait-1-watch-blocking.md
[12]: ../../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[13]: ../../../../../.claude/plans/prompt-loose-ends-1-flag-and-comments.md
[14]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[15]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[16]: ../../../../../.claude/plans/task-assert-wait.md
[17]: ../../../../../.claude/plans/value-of-plan.md
[18]: ../../../../../.claude/skills/catzc-module/SKILL.md
[19]: ../../../../adr/automation/dora-explains.md
[20]: ../../../../adr/glossary.md
[21]: ../../../../adr/index.md
[22]: ../../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[23]: ../../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[24]: ../../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[25]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[26]: ../../../../references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[27]: ../../../../references/pwsh/.assets/az-cli-test-assert-share-one-state/diagram.drawio.md
[28]: ../../../../references/pwsh/catzc-azure/types/AzureConfig.cs.md
[29]: ../../../../references/pwsh/catzc-base-contracts/configs/contracts.yml.md
[30]: ../../../../references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[31]: ../../../../references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md
[32]: ../../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[33]: ../../../../references/pwsh/catzc-base-docs/configs/adr-checks.yml.md
[34]: ../../../../references/pwsh/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
[35]: ../../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[36]: ../../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[37]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[38]: ../../../../references/pwsh/catzc-base-docs/types/CheckMode.cs.md
[39]: ../../../../references/pwsh/catzc-base-docs/types/CheckModes.cs.md
[40]: ../../../../references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
[41]: ../../../../references/pwsh/.assets/invoke-executable-two-paths-one-bounded/diagram.drawio.md
[42]: ../../../../references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[43]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[44]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[45]: ../../../../references/pwsh/catzc-base-languages.md
[46]: ../../../../references/pwsh/catzc-base-languages/configs/file-carriers.yml.md
[47]: ../../../../references/pwsh/catzc-base-languages/configs/go.yml.md
[48]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[49]: ../../../../references/pwsh/catzc-base-languages/configs/python.yml.md
[50]: ../../../../references/pwsh/catzc-base-languages/types/FileCarrier.cs.md
[51]: ../../../../references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md
[52]: ../../../../references/pwsh/catzc-base-languages/types/GoConfig.cs.md
[53]: ../../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[54]: ../../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[55]: ../../../../references/pwsh/catzc-base-maps/types/MapsConfig.cs.md
[56]: ../../../../references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md
[57]: ../../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[58]: ../../../../references/pwsh/catzc-base-maps/types/MapsLimits.cs.md
[59]: ../../../../references/pwsh/catzc-base-maps/types/MapsPalette.cs.md
[60]: ../../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[61]: ../../../../references/pwsh/catzc-base-qualitygates/configs/comments.yml.md
[62]: ../../../../references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md
[63]: ../../../../references/pwsh/catzc-base-qualitygates/configs/links.yml.md
[64]: ../../../../references/pwsh/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[65]: ../../../../references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md
[66]: ../../../../references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md
[67]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md
[68]: ../../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[69]: ../../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
[70]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[71]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[72]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[73]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[74]: ../../../../references/pwsh/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[75]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md
[76]: ../../../../references/pwsh/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[77]: ../../../../references/pwsh/catzc-base-qualitygates/types/FileMetaKind.cs.md
[78]: ../../../../references/pwsh/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[79]: ../../../../references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md
[80]: ../../../../references/pwsh/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[81]: ../../../../references/pwsh/catzc-base-qualitygates/types/SourceCheck.cs.md
[82]: ../../../../references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[83]: ../../../../references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[84]: ../../../../references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
[85]: ../../../../references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
[86]: ../../../../references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
[87]: ../../../../references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[88]: ../../../../references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[89]: ../../../../references/pwsh/catzc-base-typessystem.md
[90]: ../../../../references/pwsh/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
[91]: ../../../../references/pwsh/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
[92]: ../../../../references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md
[93]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[94]: ../../../../references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md
[95]: ../../../../references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md
[96]: ../../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[97]: ../../../../references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[98]: ../../../../references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
[99]: ../../../../../pipelines/ci-automation.yaml
[100]: ../../../../../pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs
[101]: ../../../../../pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
[102]: ../../../../../pwsh/Catzc.Base.Contracts/types/ContractParameter.cs
[103]: ../../../../../pwsh/Catzc.Base.Languages/types/LayoutRow.cs
[104]: ../../../../../pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs
[105]: ../../../../../pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
[106]: ../../../../../pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
[107]: ../../../../../pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1
[108]: ../../../../../pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[109]: ../../../../../pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[110]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
[111]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[112]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[113]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[114]: ../../../../../pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[115]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[116]: ../../../../../pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[117]: ../../../../../pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[118]: ../../../../../pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[119]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[120]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[121]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[122]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[123]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
[124]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[125]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[126]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
[127]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[128]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[129]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[130]: ../../../../../pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
[131]: ../../../../../pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[132]: ../../../../../pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[133]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[134]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
[135]: ../../../../../pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[136]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[137]: ../../../../../pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
[138]: ../../../../../pwsh/Catzc.Base.Config/configs/glossary.yml
[139]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[140]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[141]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[142]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[143]: ../../three-tests-prove-the-hook.md
[144]: ../../../../adr/glossary.md#world-map
[145]: ../../../../adr/glossary.md#track
[146]: ../../../../adr/glossary.md#file-language
[147]: ../../../../adr/glossary.md#cell
[148]: ../../../../adr/glossary.md#lit-cell
[149]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[150]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

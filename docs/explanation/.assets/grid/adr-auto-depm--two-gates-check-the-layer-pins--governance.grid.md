---
catzc:
  immutable:
    with_body_sha: "4c4acd17029f"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
    source: docs/explanation/.assets/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two gates check the layer pins, and one rule is left to review: the world-map minimap

```text
Where the files that cite ADR-AUTO-DEPM and ADR-AUTO-TEST sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 459 files.
```

![The world-map minimap of Two gates check the layer pins, and one rule is left to review](adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Two gates check the layer pins, and one rule is left to
review][464], which explains [ADR-AUTO-DEPM][1] and [ADR-AUTO-TEST][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 14 lit of 90 files
- automation × powershell: 61 lit of 1629 files
- automation × yaml: 10 lit of 112 files
- docs × markdown: 372 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (14 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 54 (text).
- [.claude/agents/test-optimization.md][7]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 5 (text).
- [.claude/plans/decisions-2026-10-16.md][8]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 80 (text) and line 83 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][9]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 157 (text); selected
  by [ADR-AUTO-TEST][2]: the file cites it at line 156 (text).
- [.claude/plans/plan-assert-wait.md][10]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 62 (text); selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 53 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][11]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 143 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][12]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 506 (text).
- [.claude/plans/plan-module-kinds-tracks.md][13]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 207 (text), line 290 (text),
  line 294 (text), line 357 (text), line 363 (text), line 367 (text), line 386 (text), line 542 (text) and line 579 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][14]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 17 (text); selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][15]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 18 (text).
- [.claude/plans/prompt-module-model-2-implement.md][16]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 15 (text).
- [.claude/plans/task-import-landing-zone.md][17]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 61 (text).
- [.claude/skills/catzc-module/SKILL.md][18]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 28 (text) and line 41 (text).
- [.claude/skills/test-speed/SKILL.md][19]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 4 (text), line 26 (text), line 38
  (text), line 39 (text), line 40 (text), line 42 (text) and line 45 (text).

### automation × powershell (61 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1][20]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1 (text) and line
  77 (text).
- [pwsh/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1][21]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 147
  (text).
- [pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][22]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 42 (text)
  and line 51 (text).
- [pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][23]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 5 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1][24]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 26 (text),
  line 46 (body comment), line 70 (text) and line 197 (body comment).
- [pwsh/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1][25]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1][26]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1][27]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (text) and line 124 (text).
- [pwsh/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1][28]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1 (text) and
  line 134 (text).
- [pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1][29]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 53
  (text), line 181 (text) and line 190 (text).
- [pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][30]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 43 (body
  comment) and line 85 (text).
- [pwsh/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1][31]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (header).
- [pwsh/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1][32]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 1 (text).
- [pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1][33]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 79
  (text) and line 79 (body comment).
- [pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1][34]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  15 (text), line 26 (text) and line 38 (text).
- [pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1][35]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text), line 21 (text) and line 32 (text).
- [pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][36]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 24
  (text), line 32 (text) and line 45 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][37]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 41 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][38]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 37 (text),
  line 66 (text), line 72 (text) and line 80 (body comment).
- [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][39]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 45 (text), line
  96 (text), line 103 (text) and line 111 (body comment).
- [pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1][40]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 27 (text), line 33 (text) and line 43 (text).
- [pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1][41]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  16 (text) and line 28 (text).
- [pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1][42]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1 (header).
- [pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][43]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 11
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1][44]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1][45]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 4
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1][46]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 95
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1][47]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  51 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1][48]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1][49]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  13 (text), line 25 (text), line 37 (text), line 49 (text), line 62 (text), line 72 (text) and line 85 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1][50]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 21
  (body comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1][51]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 19
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1][52]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][53]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1][54]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  2 (text), line 2 (body comment) and line 100 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1][55]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1][56]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 156
  (text), line 181 (text), line 254 (text), line 269 (text), line 269 (body comment) and line 309 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1][57]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 2
  (text) and line 13 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1][58]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1][59]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 16 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1][60]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 13
  (body comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1][61]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 52
  (text), line 61 (text) and line 76 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1][62]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1][63]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 48 (text), line 52 (text) and line 70 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1][64]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 25
  (text) and line 32 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1][65]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 20
  (text), line 26 (text), line 40 (text), line 64 (text) and line 77 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1][66]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 19 (body
  comment), line 24 (body comment) and line 37 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1][67]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  36 (text), line 40 (text) and line 45 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1][68]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 19
  (text), line 29 (text) and line 39 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1][69]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1][70]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 26
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1][71]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 32
  (text), line 41 (text) and line 53 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1][72]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  88 (body comment) and line 99 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1][73]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 20
  (text), line 29 (text), line 43 (text) and line 53 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1][74]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1][75]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 1 (text).
- [pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1][76]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 10
  (text), line 20 (text), line 28 (text) and line 38 (text).
- [pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1][77]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 2
  (text), line 10 (text) and line 17 (text).
- [pwsh/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1][78]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1][79]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 74
  (body comment) (a passing mention only).
- [pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1][80]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 1 (text).

### automation × yaml (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml][81]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 7 (header).
- [pwsh/Catzc.Base.Docs/configs/adrs.yml][82]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 138 (text); selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 125 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][83]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 76 (body comment), line 97
  (text), line 97 (body comment) and line 97 (body comment).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][84]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 9 (text), line 14
  (body comment), line 19 (text), line 19 (body comment), line 19 (body comment) and line 24 (body comment).
- [pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml][85]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (header) and line 6 (text).
- [pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml][86]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 1
  (header), line 8 (text) and line 16 (text).
- [pwsh/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml][87]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  5 (header).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][88]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 15
  (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][89]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 5 (text), line 21
  (text), line 30 (text), line 40 (text), line 67 (text), line 82 (text), line 105 (text), line 117 (text), line 127 (text), line 137
  (text), line 152 (text) and line 166 (text).
- [pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][90]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 120 (body
  comment) (a passing mention only).

### docs × markdown (372 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/controlling-module-dependencies.md][1]: selected by [ADR-AUTO-DEPM][1]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][91]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 365 (text); selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 140 (text).
- [docs/adr/automation/test-automation.md][2]: selected by [ADR-AUTO-TEST][2]: the ADR's own file.
- [docs/adr/glossary.md][92]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 534 (text), line 584 (text), line 606 (text), line
  729 (text), line 785 (text), line 803 (text), line 815 (text), line 829 (text), line 851 (text), line 865 (text), line 876 (text) and line
  896 (text).
- [docs/adr/index.md][93]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 169 (text); selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 156 (text).
- [docs/how-to/pwsh/manual-test-plan.md][94]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 54 (text) and line 60 (text).
- [docs/how-to/pwsh/manual-test-plan/azure.md][95]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 15 (text) and line 67
  (text).
- [docs/how-to/pwsh/manual-test-plan/test-harness.md][96]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 15 (text).
- [docs/how-to/getting-started/pwsh/run-tests-and-checks.md][97]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 31 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][98]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 44 (text).
- [docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md][99]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 47 (text), line 54 (text), line 54 (text), line 71 (text) and line 73 (text); selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 53 (text).
- [docs/references/.assets/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.verify.md][100]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 18 (text), line 20 (text), line 49 (text) and line 62 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md][101]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 24 (text).
- [docs/references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md][102]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-azure-devops/configs/identity-tokens.yml.md][103]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-azure-devops/tests/Get-AdoYamlFiles.Tests.ps1.md][104]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 24 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md][105]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 18 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md][106]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 26 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md][107]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 18 (text), line 20 (text) and line 23 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md][108]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 28 (text) and line 36 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleCustomer.Tests.ps1.md][109]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text), line 15 (text), line 27 (text) and line 39 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleIndexed.Tests.ps1.md][110]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text), line 15 (text) and line 35 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleSubscription.Tests.ps1.md][111]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text), line 13 (text), line 25 (text) and line 37 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleWithModule.Tests.ps1.md][112]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 15 (text), line 15 (text), line 27 (text) and line 39 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md][113]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 21 (text) and line 30 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.Tests.ps1.md][114]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 15 (text), line 15 (text), line 25 (text) and line 35 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md][115]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 22 (text), line 40 (text) and line 49 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Deploy-Bicep.Tests.ps1.md][116]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 57 (text), line 57 (text) and line 67 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepDeploymentContext.Tests.ps1.md][117]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text), line 15 (text), line 26 (text) and line 56 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md][118]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (text), line 22 (text), line 25 (text), line 30 (text) and line 39 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Tests.ps1.md][119]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterViolations.Tests.ps1.md][120]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md][121]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepResourceName.Tests.ps1.md][122]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 17 (text) and line 17 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md][123]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateConfiguration.Tests.ps1.md][124]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 15 (text) and line 15 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateCustomers.Tests.ps1.md][125]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text), line 13 (text), line 23 (text) and line 23 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateNames.Tests.ps1.md][126]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md][127]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text), line 13 (text), line 32 (text) and line 32 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplates.Tests.ps1.md][128]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 17 (text) and line 17 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTrackTagNameSet.Tests.ps1.md][129]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md][130]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/Set-BicepTemplateConfiguration.Tests.ps1.md][131]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 57 (text).
- [docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md][132]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure/Test-AzureNetworkPlan.ps1.md][133]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-azure/configs/identity-tokens.yml.md][134]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 13
  (text).
- [docs/references/pwsh/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md][135]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md][136]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md][137]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure/tests/Get-AzureEnvironment.Tests.ps1.md][138]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md][139]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1.md][140]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text) and line 13 (text).
- [docs/references/pwsh/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md][141]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md][142]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md][143]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-config/tests/Config-Conventions.Tests.ps1.md][144]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-base-config/tests/Get-Config.Tests.ps1.md][145]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 12 (text), line 23 (text), line 26 (text) and line 44 (text).
- [docs/references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md][146]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 22 (text).
- [docs/references/pwsh/catzc-base-configextensions/Test-ConfigValidators.ps1.md][147]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md][148]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-configextensions/tests/Test-ConfigValidators.Tests.ps1.md][149]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-contracts/Test-Contracts.ps1.md][150]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md][151]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md][152]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-contracts/tests/Get-ContractAssetNote.Tests.ps1.md][153]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-contracts/tests/Get-ContractFreezeFindings.Tests.ps1.md][154]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md][155]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md][156]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-docs.md][157]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 32 (text).
- [docs/references/pwsh/catzc-base-docs/Test-AdrEngineNeutrality.ps1.md][158]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-docs/Test-AdrRegistry.ps1.md][159]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-docs/Test-AgentDefinitions.ps1.md][160]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-docs/Test-GeneratedReadmes.ps1.md][161]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md][162]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-docs/configs/adr-checks.yml.md][163]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md][164]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 29 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md][165]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1.md][166]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md][167]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrCitationMap.Tests.ps1.md][168]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md][169]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md][170]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrFileIndex.Tests.ps1.md][171]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md][172]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text) and line 22 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AdrRuleSummaryLines.Tests.ps1.md][173]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md][174]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md][175]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md][176]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md][177]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryAnchorViolations.Tests.ps1.md][178]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md][179]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1.md][180]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryFormViolations.Tests.ps1.md][181]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md][182]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md][183]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md][184]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md][185]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Resolve-AdrLinkTarget.Tests.ps1.md][186]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md][187]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 8 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-AdrRegistry.Tests.ps1.md][188]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 8 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md][189]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-GeneratedReadmes.Tests.ps1.md][190]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][191]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 25 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-docs/tests/Update-AdrCitation.Tests.ps1.md][192]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/AdrChecksConfig.Tests.ps1.md][193]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md][194]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md][195]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md][196]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md][197]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md][198]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md][199]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md][200]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  23 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckMode.cs.md][201]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][202]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  33 (text).
- [docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md][203]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  136 (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][204]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 95 (text).
- [docs/references/pwsh/catzc-base-execution/tests/Find-Executable.Tests.ps1.md][205]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md][206]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md][207]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md][208]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md][209]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md][210]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md][211]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md][212]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text), line 21 (text) and line 23 (text).
- [docs/references/pwsh/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md][213]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md][214]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md][215]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-files/tests/Get-GitChangedPath.Tests.ps1.md][216]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs.md][217]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 42 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][218]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 21 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][219]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 21 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][220]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 23 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][221]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][222]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md][223]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md][224]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 23 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][225]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1.md][226]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1.md][227]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md][228]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 22 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][229]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md][230]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][231]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 35 (text).
- [docs/references/pwsh/catzc-base-languages.md][232]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md][233]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md][234]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md][235]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md][236]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Invoke-GoTest.Tests.ps1.md][237]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 11 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md][238]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md][239]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md][240]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-languages/types/BashTestResult.cs.md][241]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoTestResult.cs.md][242]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  18 (text).
- [docs/references/pwsh/catzc-base-languages/types/PythonTestResult.cs.md][243]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 19 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][244]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 43 (text).
- [docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md][245]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md][246]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][247]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][248]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][249]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][250]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][251]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][252]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-modulesystem.md][253]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md][254]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 58 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-CheckedInBinaries.ps1.md][255]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md][256]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md][257]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 21 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-InternalAssetDependency.ps1.md][258]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-ModuleCycles.ps1.md][259]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-ModuleDependency.ps1.md][260]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 16 (text).
- [docs/references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md][261]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md][262]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 110 (text) and line 114 (text); selected by [ADR-AUTO-TEST][2]: the file cites it at line 39 (text), line 41 (text)
  and line 104 (text).
- [docs/references/pwsh/catzc-base-modulesystem/private/Get-UncoveredInternalAssetDependency.ps1.md][263]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md][264]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Tests.ps1.md][265]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md][266]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Test-CheckedInBinaries.Tests.ps1.md][267]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text) and line 22 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md][268]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md][269]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Test-InternalAssetDependency.Tests.ps1.md][270]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Test-ModuleCycles.Tests.ps1.md][271]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-modulesystem/tests/Test-ModuleDependency.Tests.ps1.md][272]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/ArtifactsConfig.cs.md][273]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md][274]: selected by [ADR-AUTO-DEPM][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md][275]: selected by [ADR-AUTO-DEPM][1]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md][276]: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md][277]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md][278]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-overlay/tests/Overlay.Fixture.ps1.md][279]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Get-TestTargetSkipReason.ps1.md][280]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 15 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Invoke-TestFile.ps1.md][281]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 21 (text), line 30 (text), line 34 (text), line 39 (text) and line 40 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md][282]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][283]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 20 (text), line 32 (text), line 33 (text), line 96 (text), line 110 (text), line 214 (text) and line 224 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-BuildArtifact.ps1.md][284]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-CatzcBuild.ps1.md][285]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text), line 22 (text) and line 47 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Change.ps1.md][286]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md][287]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ConfigIdentityHygiene.ps1.md][288]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-FileMeta.ps1.md][289]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-FileMetaProcessors.ps1.md][290]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Formatting.ps1.md][291]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-GeneratedFiles.ps1.md][292]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Links.ps1.md][293]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 24
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md][294]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 21 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ManagedGuids.ps1.md][295]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ManualTestPlan.ps1.md][296]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-MarkdownTitle.ps1.md][297]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Markdownlint.ps1.md][298]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ParameterConsistency.ps1.md][299]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md][300]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 30
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md][301]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 24 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md][302]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-SourceConventions.ps1.md][303]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Spelling.ps1.md][304]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Terminology.ps1.md][305]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 27 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-TestTitles.ps1.md][306]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/generated-files.yml.md][307]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md][308]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 42 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md][309]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 42 (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md][310]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Assert-TestTagGate.ps1.md][311]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Enter-SystemTestLock.ps1.md][312]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md][313]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GeneratedFileGenerator.ps1.md][314]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestOutcomes.ps1.md][315]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][316]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LogicTestIdentityFinding.ps1.md][317]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-NeutralCodeFinding.ps1.md][318]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md][319]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunLocationEntry.ps1.md][320]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-BuildArtifactProbe.ps1.md][321]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md][322]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md][323]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 14 (text), line 23 (text), line 222 (text) and line 302 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md][324]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md][325]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 18 (text), line 62 (text) and line 121 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestRunMaxLevel.ps1.md][326]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text) and line 24 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][327]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Select-TestRunFiles.ps1.md][328]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Split-TestAutomationFiles.ps1.md][329]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 26 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md][330]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationHeader.ps1.md][331]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md][332]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 52 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Write-TestOptOutExclusion.ps1.md][333]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md][334]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (text), line 25 (text), line 28 (text), line 96 (text) and line 101 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Build-EnglishDictionary.Tests.ps1.md][335]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md][336]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Enter-SystemTestLock.Tests.ps1.md][337]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 8 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Format-Code.Tests.ps1.md][338]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 11 (text), line 13 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Format-Links.Tests.ps1.md][339]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Format-Types.Tests.ps1.md][340]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md][341]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-BashTestCases.Tests.ps1.md][342]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md][343]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-ChangeTestFile.Tests.ps1.md][344]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-EngineSetFinding.Tests.ps1.md][345]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md][346]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-FormatEngineStamp.Tests.ps1.md][347]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-FormatScope.Tests.ps1.md][348]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-GoTestCases.Tests.ps1.md][349]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestExecutable.Tests.ps1.md][350]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md][351]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md][352]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-LiveIdentityTokens.Tests.ps1.md][353]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-NeutralCodeFinding.Tests.ps1.md][354]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-ParameterTypeConflict.Tests.ps1.md][355]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md][356]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-PythonTestCases.Tests.ps1.md][357]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-RepositoryGuids.Tests.ps1.md][358]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md][359]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestFileModule.Tests.ps1.md][360]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestRunContext.Tests.ps1.md][361]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestRunFile.Tests.ps1.md][362]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md][363]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-BicepFormat.Tests.ps1.md][364]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-DotnetFormat.Tests.ps1.md][365]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-Gofmt.Tests.ps1.md][366]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-ImprintStep.Tests.ps1.md][367]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-Prettier.Tests.ps1.md][368]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-PythonWorkspaceTool.Tests.ps1.md][369]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-RuffFormat.Tests.ps1.md][370]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Invoke-TestFile.Tests.ps1.md][371]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 21 (text), line 27 (text), line 36 (text) and line 41 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Language.Bridge.ps1.md][372]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 18 (text), line 23 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md][373]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Measure-QualityGates.Tests.ps1.md][374]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/New-TestAutomationShardScript.Tests.ps1.md][375]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/New-TestRunFinalManifest.Tests.ps1.md][376]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Save-TestDurationHistory.Tests.ps1.md][377]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Select-TestShardAssignment.Tests.ps1.md][378]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Split-CachedFile.Tests.ps1.md][379]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-AnalyzerAdrMap.Tests.ps1.md][380]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Automation.Tests.ps1.md][381]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-BuildArtifact.Tests.ps1.md][382]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Change.Tests.ps1.md][383]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-ConfigIdentityHygiene.Tests.ps1.md][384]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md][385]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Formatting.Tests.ps1.md][386]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text), line 13 (text) and line 24 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md][387]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Links.Tests.ps1.md][388]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Links.Untracked.Tests.ps1.md][389]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-LogicTestIdentity.Tests.ps1.md][390]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text), line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-ManagedGuids.Tests.ps1.md][391]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md][392]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Markdownlint.Tests.ps1.md][393]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-ParameterConsistency.Tests.ps1.md][394]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 11 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-PythonLint.Tests.ps1.md][395]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text), line 13 (text) and line 23 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md][396]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 11 (text), line 14 (text) and line 23 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-ShippedConfigs.Tests.ps1.md][397]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-SourceConventions.Tests.ps1.md][398]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Spelling.Tests.ps1.md][399]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 24 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-TestTitles.Tests.ps1.md][400]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md][401]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Write-TestRunFailures.Tests.ps1.md][402]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/EngineSetCheck.Tests.ps1.md][403]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/types/SpellingOracle.Tests.ps1.md][404]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/IdentityTokenRule.cs.md][405]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][406]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][407]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-reports/Write-QualityGateReport.ps1.md][408]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-reports/configs/reports.yml.md][409]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md][410]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-reports/types/ReportsConfig.cs.md][411]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md][412]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md][413]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-repository/tests/types/ParsedScripts.Tests.ps1.md][414]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md][415]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-rootconfig.md][416]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 48 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Test-RootAnalyzerSettings.ps1.md][417]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-rootconfig/Test-RootConfigFiles.ps1.md][418]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-rootconfig/tests/Build-RootConfig.Tests.ps1.md][419]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 45 (text) and line 56 (text).
- [docs/references/pwsh/catzc-base-rootconfig/tests/Get-RootConfigRenderedFile.Tests.ps1.md][420]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-rootconfig/tests/Test-RootAnalyzerSettings.Tests.ps1.md][421]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-rootconfig/tests/Test-RootConfigFiles.Tests.ps1.md][422]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md][423]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-timeouts/types/TestTiers.cs.md][424]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-typessystem/Test-ShippedTypes.ps1.md][425]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md][426]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md][427]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md][428]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-typessystem/tests/Test-ShippedTypes.Tests.ps1.md][429]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-core/Remove-SystemInstallation.ps1.md][430]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 19 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md][431]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Assert-ToolVersion.Tests.ps1.md][432]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Get-ToolConfig.Tests.ps1.md][433]: selected by [ADR-AUTO-TEST][2]: the file cites it
  at line 21 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Get-ToolInstallOrder.Tests.ps1.md][434]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 15 (text) and line 26 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Remove-LinuxToolInstall.Tests.ps1.md][435]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md][436]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md][437]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 8 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md][438]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 11 (text) and line 20 (text).
- [docs/references/pwsh/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md][439]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md][440]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md][441]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][442]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md][443]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md][444]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-tooling-keyhandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1.md][445]: selected by
  [ADR-AUTO-TEST][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-tooling-keyhandler/tests/Select-SupportedKeyHandler.Tests.ps1.md][446]: selected by [ADR-AUTO-TEST][2]:
  the file cites it at line 8 (text) and line 13 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md][447]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 38 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md][448]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md][449]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md][450]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md][451]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md][452]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md][453]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-tooling-python/tests/Install-PipTool.Tests.ps1.md][454]: selected by [ADR-AUTO-TEST][2]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-tooling-toolchain/tests/Install-BicepStandalone.Tests.ps1.md][455]: selected by [ADR-AUTO-TEST][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md][456]: selected by [ADR-AUTO-TEST][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/internal/tests/Import-AllModules.Tests.ps1.md][457]: selected by [ADR-AUTO-TEST][2]: the file cites it at line
  82 (text).
- [docs/references/pwsh/internal/tests/New-BuiltCatzcRoot.Tests.ps1.md][458]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 8 (text).
- [docs/references/pwsh/internal/tests/Test-FolderConventions.Tests.ps1.md][459]: selected by [ADR-AUTO-TEST][2]: the file cites it at
  line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][460]: selected by [ADR-AUTO-TEST][2]: the file cites it at line 22 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][461]: selected by [ADR-AUTO-DEPM][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 138 (text); selected by [ADR-AUTO-TEST][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 1 (text),
  `pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 77 (text), `pwsh/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1`
  line 147 (text), `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 42 (text),
  `pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1` line 51 (text),
  `pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1` line 5 (body comment),
  `pwsh/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml` line 7 (header),
  `pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 26 (text),
  `pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 46 (body comment),
  `pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1` line 197 (body comment), `pwsh/Catzc.Base.Docs/configs/adrs.yml`
  line 125 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 76 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml`
  line 97 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 97 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml`
  line 97 (body comment), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 9 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 14 (body comment), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line
  19 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 19 (body comment),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 19 (body comment), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line
  24 (body comment), `pwsh/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1` line 124 (text),
  `pwsh/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1`
  line 134 (text), `pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 181 (text),
  `pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` line 190 (text),
  `pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 43 (body comment),
  `pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 85 (text),
  `pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml` line 1 (header),
  `pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml` line 6 (text),
  `pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml` line 1 (header),
  `pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml` line 8 (text),
  `pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml` line 16 (text),
  `pwsh/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1` line 1 (header),
  `pwsh/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml` line 5 (header),
  `pwsh/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1` line 79 (text),
  `pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1` line 79 (body comment),
  `pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 15 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 26 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1` line 38 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 14 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 21 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1` line 32 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 24 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 32 (text),
  `pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 41 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 37 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 66 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 72 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 45 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  96 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 103 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 27 (text),
  `pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 33 (text),
  `pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` line 43 (text),
  `pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1` line 16 (text),
  `pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1` line 1 (header),
  `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 15 (text),
  `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 5 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 21
  (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 30 (text),
  `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 40 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line
  67 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 82 (text),
  `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 105 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line
  117 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 127 (text),
  `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 137 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line
  152 (text), `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 166 (text),
  `pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 11 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1` line 4 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1` line 95 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1` line 51 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 13 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 25 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 37 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 49 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 62 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 72 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1` line 85 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1` line 21 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1` line 19 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 2 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1` line 100 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 156 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 181 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 254 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 269 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 269 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1` line 309 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1` line 13 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1` line 16 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` line 13 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 52 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 61 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1` line 76 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 48 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 52 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` line 25 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` line 32 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 20 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 26 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 40 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 64 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` line 77 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 19 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 24 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1` line 37 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 36 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 40 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 19 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 29 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` line 39 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1` line 26 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 32 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 41 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1` line 88 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1` line 99 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 20 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 29 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 43 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 10 (text),
  `pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 20 (text),
  `pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1` line 38 (text),
  `pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 10 (text),
  `pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml` line 120 (body comment),
  `pwsh/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1` line 74 (body comment) and
  `pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1` line 1 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][462]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [importer.ps1][463]: selected by [ADR-AUTO-TEST][2]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 1 (text) and
  `pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 77 (text).

## Keywords

- [world map][465]
- [track][466]
- [file language][467]
- [cell][468]
- [lit cell][469]
- [root file][470]
- [.claude][471]: a track
- [automation][471]: a track
- [docs][471]: a track
- [pipelines][471]: a track
- [markdown][472]: a file language
- [pipeline-yaml][472]: a file language
- [powershell][472]: a file language
- [yaml][472]: a file language

Terms the cited ADRs define:

- [all tests][473], defined by [ADR-AUTO-TEST#36][474]
- [build verification test][475], defined by [ADR-AUTO-TEST#24][476]
- [category][477], defined by [ADR-AUTO-TEST#1][478]
- [phase][479], defined by [ADR-AUTO-TEST#26][480]
- [quality gate][481], defined by [ADR-AUTO-TEST#35][482]
- [test][483], defined by [ADR-AUTO-TEST#42][484]
- [test file][485], defined by [ADR-AUTO-TEST#43][486]
- [test run][487], defined by [ADR-AUTO-TEST#34][488]
- [test suite][489], defined by [ADR-AUTO-TEST#37][490]
- [testing in production][491], defined by [ADR-AUTO-TEST#41][492]
- [tier][493], defined by [ADR-AUTO-TEST#13][494]
- [vertical test][495], defined by [ADR-AUTO-TEST#38][496]

[1]: ../../../adr/automation/controlling-module-dependencies.md
[2]: ../../../adr/automation/test-automation.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/agents/test-optimization.md
[8]: ../../../../.claude/plans/decisions-2026-10-16.md
[9]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[10]: ../../../../.claude/plans/plan-assert-wait.md
[11]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[12]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[13]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[14]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[15]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[16]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[17]: ../../../../.claude/plans/task-import-landing-zone.md
[18]: ../../../../.claude/skills/catzc-module/SKILL.md
[19]: ../../../../.claude/skills/test-speed/SKILL.md
[20]: ../../../../pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
[21]: ../../../../pwsh/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1
[22]: ../../../../pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[23]: ../../../../pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[24]: ../../../../pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
[25]: ../../../../pwsh/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1
[26]: ../../../../pwsh/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1
[27]: ../../../../pwsh/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1
[28]: ../../../../pwsh/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
[29]: ../../../../pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
[30]: ../../../../pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[31]: ../../../../pwsh/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1
[32]: ../../../../pwsh/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
[33]: ../../../../pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
[34]: ../../../../pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
[35]: ../../../../pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
[36]: ../../../../pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[37]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[38]: ../../../../pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[39]: ../../../../pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[40]: ../../../../pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
[41]: ../../../../pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
[42]: ../../../../pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1
[43]: ../../../../pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[44]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
[45]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
[46]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1
[47]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
[48]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
[49]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1
[50]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
[51]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
[52]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
[53]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[54]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
[55]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
[56]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
[57]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
[58]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
[59]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
[60]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
[61]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
[62]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
[63]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
[64]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
[65]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
[66]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
[67]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
[68]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
[69]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
[70]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
[71]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
[72]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
[73]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
[74]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
[75]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
[76]: ../../../../pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
[77]: ../../../../pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
[78]: ../../../../pwsh/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
[79]: ../../../../pwsh/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
[80]: ../../../../pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
[81]: ../../../../pwsh/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
[82]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[83]: ../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[84]: ../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[85]: ../../../../pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
[86]: ../../../../pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
[87]: ../../../../pwsh/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml
[88]: ../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[89]: ../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[90]: ../../../../pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[91]: ../../../adr/automation/dora-explains.md
[92]: ../../../adr/glossary.md
[93]: ../../../adr/index.md
[94]: ../../../how-to/pwsh/manual-test-plan.md
[95]: ../../../how-to/pwsh/manual-test-plan/azure.md
[96]: ../../../how-to/pwsh/manual-test-plan/test-harness.md
[97]: ../../../how-to/getting-started/pwsh/run-tests-and-checks.md
[98]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[99]: ../../../references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
[100]: ../../../references/.assets/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.verify.md
[101]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/tests/types/BuildValidationConfig.Tests.ps1.md
[102]: ../../../references/pwsh/catzc-azure-devops/Test-Pipelines.ps1.md
[103]: ../../../references/pwsh/catzc-azure-devops/configs/identity-tokens.yml.md
[104]: ../../../references/pwsh/catzc-azure-devops/tests/Get-AdoYamlFiles.Tests.ps1.md
[105]: ../../../references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md
[106]: ../../../references/pwsh/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md
[107]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md
[108]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md
[109]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleCustomer.Tests.ps1.md
[110]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleIndexed.Tests.ps1.md
[111]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleSubscription.Tests.ps1.md
[112]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleWithModule.Tests.ps1.md
[113]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md
[114]: ../../../references/pwsh/catzc-azure-templates/tests/Build-Bicep.Tests.ps1.md
[115]: ../../../references/pwsh/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md
[116]: ../../../references/pwsh/catzc-azure-templates/tests/Deploy-Bicep.Tests.ps1.md
[117]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepDeploymentContext.Tests.ps1.md
[118]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
[119]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Tests.ps1.md
[120]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepParameterViolations.Tests.ps1.md
[121]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md
[122]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepResourceName.Tests.ps1.md
[123]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md
[124]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateConfiguration.Tests.ps1.md
[125]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateCustomers.Tests.ps1.md
[126]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateNames.Tests.ps1.md
[127]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md
[128]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTemplates.Tests.ps1.md
[129]: ../../../references/pwsh/catzc-azure-templates/tests/Get-BicepTrackTagNameSet.Tests.ps1.md
[130]: ../../../references/pwsh/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md
[131]: ../../../references/pwsh/catzc-azure-templates/tests/Set-BicepTemplateConfiguration.Tests.ps1.md
[132]: ../../../references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
[133]: ../../../references/pwsh/catzc-azure/Test-AzureNetworkPlan.ps1.md
[134]: ../../../references/pwsh/catzc-azure/configs/identity-tokens.yml.md
[135]: ../../../references/pwsh/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md
[136]: ../../../references/pwsh/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md
[137]: ../../../references/pwsh/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md
[138]: ../../../references/pwsh/catzc-azure/tests/Get-AzureEnvironment.Tests.ps1.md
[139]: ../../../references/pwsh/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md
[140]: ../../../references/pwsh/catzc-azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1.md
[141]: ../../../references/pwsh/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md
[142]: ../../../references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
[143]: ../../../references/pwsh/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md
[144]: ../../../references/pwsh/catzc-base-config/tests/Config-Conventions.Tests.ps1.md
[145]: ../../../references/pwsh/catzc-base-config/tests/Get-Config.Tests.ps1.md
[146]: ../../../references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
[147]: ../../../references/pwsh/catzc-base-configextensions/Test-ConfigValidators.ps1.md
[148]: ../../../references/pwsh/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md
[149]: ../../../references/pwsh/catzc-base-configextensions/tests/Test-ConfigValidators.Tests.ps1.md
[150]: ../../../references/pwsh/catzc-base-contracts/Test-Contracts.ps1.md
[151]: ../../../references/pwsh/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md
[152]: ../../../references/pwsh/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md
[153]: ../../../references/pwsh/catzc-base-contracts/tests/Get-ContractAssetNote.Tests.ps1.md
[154]: ../../../references/pwsh/catzc-base-contracts/tests/Get-ContractFreezeFindings.Tests.ps1.md
[155]: ../../../references/pwsh/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md
[156]: ../../../references/pwsh/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md
[157]: ../../../references/pwsh/catzc-base-docs.md
[158]: ../../../references/pwsh/catzc-base-docs/Test-AdrEngineNeutrality.ps1.md
[159]: ../../../references/pwsh/catzc-base-docs/Test-AdrRegistry.ps1.md
[160]: ../../../references/pwsh/catzc-base-docs/Test-AgentDefinitions.ps1.md
[161]: ../../../references/pwsh/catzc-base-docs/Test-GeneratedReadmes.ps1.md
[162]: ../../../references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
[163]: ../../../references/pwsh/catzc-base-docs/configs/adr-checks.yml.md
[164]: ../../../references/pwsh/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md
[165]: ../../../references/pwsh/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md
[166]: ../../../references/pwsh/catzc-base-docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1.md
[167]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md
[168]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrCitationMap.Tests.ps1.md
[169]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md
[170]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md
[171]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrFileIndex.Tests.ps1.md
[172]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md
[173]: ../../../references/pwsh/catzc-base-docs/tests/Get-AdrRuleSummaryLines.Tests.ps1.md
[174]: ../../../references/pwsh/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md
[175]: ../../../references/pwsh/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md
[176]: ../../../references/pwsh/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md
[177]: ../../../references/pwsh/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md
[178]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossaryAnchorViolations.Tests.ps1.md
[179]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md
[180]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1.md
[181]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossaryFormViolations.Tests.ps1.md
[182]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md
[183]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md
[184]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md
[185]: ../../../references/pwsh/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md
[186]: ../../../references/pwsh/catzc-base-docs/tests/Resolve-AdrLinkTarget.Tests.ps1.md
[187]: ../../../references/pwsh/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md
[188]: ../../../references/pwsh/catzc-base-docs/tests/Test-AdrRegistry.Tests.ps1.md
[189]: ../../../references/pwsh/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md
[190]: ../../../references/pwsh/catzc-base-docs/tests/Test-GeneratedReadmes.Tests.ps1.md
[191]: ../../../references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[192]: ../../../references/pwsh/catzc-base-docs/tests/Update-AdrCitation.Tests.ps1.md
[193]: ../../../references/pwsh/catzc-base-docs/tests/types/AdrChecksConfig.Tests.ps1.md
[194]: ../../../references/pwsh/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md
[195]: ../../../references/pwsh/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md
[196]: ../../../references/pwsh/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md
[197]: ../../../references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
[198]: ../../../references/pwsh/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md
[199]: ../../../references/pwsh/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md
[200]: ../../../references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md
[201]: ../../../references/pwsh/catzc-base-docs/types/CheckMode.cs.md
[202]: ../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[203]: ../../../references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md
[204]: ../../../references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[205]: ../../../references/pwsh/catzc-base-execution/tests/Find-Executable.Tests.ps1.md
[206]: ../../../references/pwsh/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md
[207]: ../../../references/pwsh/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md
[208]: ../../../references/pwsh/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md
[209]: ../../../references/pwsh/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md
[210]: ../../../references/pwsh/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md
[211]: ../../../references/pwsh/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md
[212]: ../../../references/pwsh/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md
[213]: ../../../references/pwsh/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md
[214]: ../../../references/pwsh/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md
[215]: ../../../references/pwsh/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md
[216]: ../../../references/pwsh/catzc-base-files/tests/Get-GitChangedPath.Tests.ps1.md
[217]: ../../../references/pwsh/catzc-base-globs.md
[218]: ../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[219]: ../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[220]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[221]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[222]: ../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[223]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md
[224]: ../../../references/pwsh/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md
[225]: ../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[226]: ../../../references/pwsh/catzc-base-globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1.md
[227]: ../../../references/pwsh/catzc-base-globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1.md
[228]: ../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md
[229]: ../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[230]: ../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md
[231]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[232]: ../../../references/pwsh/catzc-base-languages.md
[233]: ../../../references/pwsh/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md
[234]: ../../../references/pwsh/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md
[235]: ../../../references/pwsh/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md
[236]: ../../../references/pwsh/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md
[237]: ../../../references/pwsh/catzc-base-languages/tests/Invoke-GoTest.Tests.ps1.md
[238]: ../../../references/pwsh/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md
[239]: ../../../references/pwsh/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md
[240]: ../../../references/pwsh/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md
[241]: ../../../references/pwsh/catzc-base-languages/types/BashTestResult.cs.md
[242]: ../../../references/pwsh/catzc-base-languages/types/GoTestResult.cs.md
[243]: ../../../references/pwsh/catzc-base-languages/types/PythonTestResult.cs.md
[244]: ../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[245]: ../../../references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
[246]: ../../../references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
[247]: ../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[248]: ../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[249]: ../../../references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[250]: ../../../references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[251]: ../../../references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[252]: ../../../references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[253]: ../../../references/pwsh/catzc-base-modulesystem.md
[254]: ../../../references/pwsh/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
[255]: ../../../references/pwsh/catzc-base-modulesystem/Test-CheckedInBinaries.ps1.md
[256]: ../../../references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[257]: ../../../references/pwsh/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
[258]: ../../../references/pwsh/catzc-base-modulesystem/Test-InternalAssetDependency.ps1.md
[259]: ../../../references/pwsh/catzc-base-modulesystem/Test-ModuleCycles.ps1.md
[260]: ../../../references/pwsh/catzc-base-modulesystem/Test-ModuleDependency.ps1.md
[261]: ../../../references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md
[262]: ../../../references/pwsh/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
[263]: ../../../references/pwsh/catzc-base-modulesystem/private/Get-UncoveredInternalAssetDependency.ps1.md
[264]: ../../../references/pwsh/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md
[265]: ../../../references/pwsh/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Tests.ps1.md
[266]: ../../../references/pwsh/catzc-base-modulesystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md
[267]: ../../../references/pwsh/catzc-base-modulesystem/tests/Test-CheckedInBinaries.Tests.ps1.md
[268]: ../../../references/pwsh/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md
[269]: ../../../references/pwsh/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md
[270]: ../../../references/pwsh/catzc-base-modulesystem/tests/Test-InternalAssetDependency.Tests.ps1.md
[271]: ../../../references/pwsh/catzc-base-modulesystem/tests/Test-ModuleCycles.Tests.ps1.md
[272]: ../../../references/pwsh/catzc-base-modulesystem/tests/Test-ModuleDependency.Tests.ps1.md
[273]: ../../../references/pwsh/catzc-base-modulesystem/types/ArtifactsConfig.cs.md
[274]: ../../../references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md
[275]: ../../../references/pwsh/catzc-base-modulesystem/types/DependencyGraph.cs.md
[276]: ../../../references/pwsh/catzc-base-modulesystem/types/ModuleGroup.cs.md
[277]: ../../../references/pwsh/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
[278]: ../../../references/pwsh/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md
[279]: ../../../references/pwsh/catzc-base-overlay/tests/Overlay.Fixture.ps1.md
[280]: ../../../references/pwsh/catzc-base-qualitygates/Get-TestTargetSkipReason.ps1.md
[281]: ../../../references/pwsh/catzc-base-qualitygates/Invoke-TestFile.ps1.md
[282]: ../../../references/pwsh/catzc-base-qualitygates/Test-AnalyzerAdrMap.ps1.md
[283]: ../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[284]: ../../../references/pwsh/catzc-base-qualitygates/Test-BuildArtifact.ps1.md
[285]: ../../../references/pwsh/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
[286]: ../../../references/pwsh/catzc-base-qualitygates/Test-Change.ps1.md
[287]: ../../../references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md
[288]: ../../../references/pwsh/catzc-base-qualitygates/Test-ConfigIdentityHygiene.ps1.md
[289]: ../../../references/pwsh/catzc-base-qualitygates/Test-FileMeta.ps1.md
[290]: ../../../references/pwsh/catzc-base-qualitygates/Test-FileMetaProcessors.ps1.md
[291]: ../../../references/pwsh/catzc-base-qualitygates/Test-Formatting.ps1.md
[292]: ../../../references/pwsh/catzc-base-qualitygates/Test-GeneratedFiles.ps1.md
[293]: ../../../references/pwsh/catzc-base-qualitygates/Test-Links.ps1.md
[294]: ../../../references/pwsh/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md
[295]: ../../../references/pwsh/catzc-base-qualitygates/Test-ManagedGuids.ps1.md
[296]: ../../../references/pwsh/catzc-base-qualitygates/Test-ManualTestPlan.ps1.md
[297]: ../../../references/pwsh/catzc-base-qualitygates/Test-MarkdownTitle.ps1.md
[298]: ../../../references/pwsh/catzc-base-qualitygates/Test-Markdownlint.ps1.md
[299]: ../../../references/pwsh/catzc-base-qualitygates/Test-ParameterConsistency.ps1.md
[300]: ../../../references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md
[301]: ../../../references/pwsh/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md
[302]: ../../../references/pwsh/catzc-base-qualitygates/Test-ShippedConfigs.ps1.md
[303]: ../../../references/pwsh/catzc-base-qualitygates/Test-SourceConventions.ps1.md
[304]: ../../../references/pwsh/catzc-base-qualitygates/Test-Spelling.ps1.md
[305]: ../../../references/pwsh/catzc-base-qualitygates/Test-Terminology.ps1.md
[306]: ../../../references/pwsh/catzc-base-qualitygates/Test-TestTitles.ps1.md
[307]: ../../../references/pwsh/catzc-base-qualitygates/configs/generated-files.yml.md
[308]: ../../../references/pwsh/catzc-base-qualitygates/configs/source-conventions.yml.md
[309]: ../../../references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md
[310]: ../../../references/pwsh/catzc-base-qualitygates/configs/test-policy.yml.md
[311]: ../../../references/pwsh/catzc-base-qualitygates/private/Assert-TestTagGate.ps1.md
[312]: ../../../references/pwsh/catzc-base-qualitygates/private/Enter-SystemTestLock.ps1.md
[313]: ../../../references/pwsh/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md
[314]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-GeneratedFileGenerator.ps1.md
[315]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestOutcomes.ps1.md
[316]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[317]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-LogicTestIdentityFinding.ps1.md
[318]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-NeutralCodeFinding.ps1.md
[319]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md
[320]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-TestRunLocationEntry.ps1.md
[321]: ../../../references/pwsh/catzc-base-qualitygates/private/Invoke-BuildArtifactProbe.ps1.md
[322]: ../../../references/pwsh/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md
[323]: ../../../references/pwsh/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md
[324]: ../../../references/pwsh/catzc-base-qualitygates/private/New-PesterRunConfiguration.ps1.md
[325]: ../../../references/pwsh/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md
[326]: ../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestRunMaxLevel.ps1.md
[327]: ../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[328]: ../../../references/pwsh/catzc-base-qualitygates/private/Select-TestRunFiles.ps1.md
[329]: ../../../references/pwsh/catzc-base-qualitygates/private/Split-TestAutomationFiles.ps1.md
[330]: ../../../references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
[331]: ../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationHeader.ps1.md
[332]: ../../../references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md
[333]: ../../../references/pwsh/catzc-base-qualitygates/private/Write-TestOptOutExclusion.ps1.md
[334]: ../../../references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md
[335]: ../../../references/pwsh/catzc-base-qualitygates/tests/Build-EnglishDictionary.Tests.ps1.md
[336]: ../../../references/pwsh/catzc-base-qualitygates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md
[337]: ../../../references/pwsh/catzc-base-qualitygates/tests/Enter-SystemTestLock.Tests.ps1.md
[338]: ../../../references/pwsh/catzc-base-qualitygates/tests/Format-Code.Tests.ps1.md
[339]: ../../../references/pwsh/catzc-base-qualitygates/tests/Format-Links.Tests.ps1.md
[340]: ../../../references/pwsh/catzc-base-qualitygates/tests/Format-Types.Tests.ps1.md
[341]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md
[342]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-BashTestCases.Tests.ps1.md
[343]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md
[344]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-ChangeTestFile.Tests.ps1.md
[345]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-EngineSetFinding.Tests.ps1.md
[346]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md
[347]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-FormatEngineStamp.Tests.ps1.md
[348]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-FormatScope.Tests.ps1.md
[349]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-GoTestCases.Tests.ps1.md
[350]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestExecutable.Tests.ps1.md
[351]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestFolders.Tests.ps1.md
[352]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md
[353]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-LiveIdentityTokens.Tests.ps1.md
[354]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-NeutralCodeFinding.Tests.ps1.md
[355]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-ParameterTypeConflict.Tests.ps1.md
[356]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md
[357]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-PythonTestCases.Tests.ps1.md
[358]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-RepositoryGuids.Tests.ps1.md
[359]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md
[360]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestFileModule.Tests.ps1.md
[361]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestRunContext.Tests.ps1.md
[362]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestRunFile.Tests.ps1.md
[363]: ../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md
[364]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-BicepFormat.Tests.ps1.md
[365]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-DotnetFormat.Tests.ps1.md
[366]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-Gofmt.Tests.ps1.md
[367]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-ImprintStep.Tests.ps1.md
[368]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-Prettier.Tests.ps1.md
[369]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-PythonWorkspaceTool.Tests.ps1.md
[370]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-RuffFormat.Tests.ps1.md
[371]: ../../../references/pwsh/catzc-base-qualitygates/tests/Invoke-TestFile.Tests.ps1.md
[372]: ../../../references/pwsh/catzc-base-qualitygates/tests/Language.Bridge.ps1.md
[373]: ../../../references/pwsh/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md
[374]: ../../../references/pwsh/catzc-base-qualitygates/tests/Measure-QualityGates.Tests.ps1.md
[375]: ../../../references/pwsh/catzc-base-qualitygates/tests/New-TestAutomationShardScript.Tests.ps1.md
[376]: ../../../references/pwsh/catzc-base-qualitygates/tests/New-TestRunFinalManifest.Tests.ps1.md
[377]: ../../../references/pwsh/catzc-base-qualitygates/tests/Save-TestDurationHistory.Tests.ps1.md
[378]: ../../../references/pwsh/catzc-base-qualitygates/tests/Select-TestShardAssignment.Tests.ps1.md
[379]: ../../../references/pwsh/catzc-base-qualitygates/tests/Split-CachedFile.Tests.ps1.md
[380]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-AnalyzerAdrMap.Tests.ps1.md
[381]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Automation.Tests.ps1.md
[382]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-BuildArtifact.Tests.ps1.md
[383]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Change.Tests.ps1.md
[384]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-ConfigIdentityHygiene.Tests.ps1.md
[385]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md
[386]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Formatting.Tests.ps1.md
[387]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md
[388]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Links.Tests.ps1.md
[389]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Links.Untracked.Tests.ps1.md
[390]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-LogicTestIdentity.Tests.ps1.md
[391]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-ManagedGuids.Tests.ps1.md
[392]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md
[393]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Markdownlint.Tests.ps1.md
[394]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-ParameterConsistency.Tests.ps1.md
[395]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-PythonLint.Tests.ps1.md
[396]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md
[397]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-ShippedConfigs.Tests.ps1.md
[398]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-SourceConventions.Tests.ps1.md
[399]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-Spelling.Tests.ps1.md
[400]: ../../../references/pwsh/catzc-base-qualitygates/tests/Test-TestTitles.Tests.ps1.md
[401]: ../../../references/pwsh/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md
[402]: ../../../references/pwsh/catzc-base-qualitygates/tests/Write-TestRunFailures.Tests.ps1.md
[403]: ../../../references/pwsh/catzc-base-qualitygates/tests/types/EngineSetCheck.Tests.ps1.md
[404]: ../../../references/pwsh/catzc-base-qualitygates/tests/types/SpellingOracle.Tests.ps1.md
[405]: ../../../references/pwsh/catzc-base-qualitygates/types/IdentityTokenRule.cs.md
[406]: ../../../references/pwsh/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[407]: ../../../references/pwsh/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[408]: ../../../references/pwsh/catzc-base-reports/Write-QualityGateReport.ps1.md
[409]: ../../../references/pwsh/catzc-base-reports/configs/reports.yml.md
[410]: ../../../references/pwsh/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md
[411]: ../../../references/pwsh/catzc-base-reports/types/ReportsConfig.cs.md
[412]: ../../../references/pwsh/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md
[413]: ../../../references/pwsh/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md
[414]: ../../../references/pwsh/catzc-base-repository/tests/types/ParsedScripts.Tests.ps1.md
[415]: ../../../references/pwsh/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md
[416]: ../../../references/pwsh/catzc-base-rootconfig.md
[417]: ../../../references/pwsh/catzc-base-rootconfig/Test-RootAnalyzerSettings.ps1.md
[418]: ../../../references/pwsh/catzc-base-rootconfig/Test-RootConfigFiles.ps1.md
[419]: ../../../references/pwsh/catzc-base-rootconfig/tests/Build-RootConfig.Tests.ps1.md
[420]: ../../../references/pwsh/catzc-base-rootconfig/tests/Get-RootConfigRenderedFile.Tests.ps1.md
[421]: ../../../references/pwsh/catzc-base-rootconfig/tests/Test-RootAnalyzerSettings.Tests.ps1.md
[422]: ../../../references/pwsh/catzc-base-rootconfig/tests/Test-RootConfigFiles.Tests.ps1.md
[423]: ../../../references/pwsh/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md
[424]: ../../../references/pwsh/catzc-base-timeouts/types/TestTiers.cs.md
[425]: ../../../references/pwsh/catzc-base-typessystem/Test-ShippedTypes.ps1.md
[426]: ../../../references/pwsh/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md
[427]: ../../../references/pwsh/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md
[428]: ../../../references/pwsh/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md
[429]: ../../../references/pwsh/catzc-base-typessystem/tests/Test-ShippedTypes.Tests.ps1.md
[430]: ../../../references/pwsh/catzc-tooling-core/Remove-SystemInstallation.ps1.md
[431]: ../../../references/pwsh/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md
[432]: ../../../references/pwsh/catzc-tooling-core/tests/Assert-ToolVersion.Tests.ps1.md
[433]: ../../../references/pwsh/catzc-tooling-core/tests/Get-ToolConfig.Tests.ps1.md
[434]: ../../../references/pwsh/catzc-tooling-core/tests/Get-ToolInstallOrder.Tests.ps1.md
[435]: ../../../references/pwsh/catzc-tooling-core/tests/Remove-LinuxToolInstall.Tests.ps1.md
[436]: ../../../references/pwsh/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md
[437]: ../../../references/pwsh/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md
[438]: ../../../references/pwsh/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md
[439]: ../../../references/pwsh/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md
[440]: ../../../references/pwsh/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md
[441]: ../../../references/pwsh/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md
[442]: ../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[443]: ../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md
[444]: ../../../references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md
[445]: ../../../references/pwsh/catzc-tooling-keyhandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1.md
[446]: ../../../references/pwsh/catzc-tooling-keyhandler/tests/Select-SupportedKeyHandler.Tests.ps1.md
[447]: ../../../references/pwsh/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md
[448]: ../../../references/pwsh/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md
[449]: ../../../references/pwsh/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md
[450]: ../../../references/pwsh/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md
[451]: ../../../references/pwsh/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md
[452]: ../../../references/pwsh/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md
[453]: ../../../references/pwsh/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md
[454]: ../../../references/pwsh/catzc-tooling-python/tests/Install-PipTool.Tests.ps1.md
[455]: ../../../references/pwsh/catzc-tooling-toolchain/tests/Install-BicepStandalone.Tests.ps1.md
[456]: ../../../references/pwsh/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md
[457]: ../../../references/pwsh/internal/tests/Import-AllModules.Tests.ps1.md
[458]: ../../../references/pwsh/internal/tests/New-BuiltCatzcRoot.Tests.ps1.md
[459]: ../../../references/pwsh/internal/tests/Test-FolderConventions.Tests.ps1.md
[460]: ../../../references/pipelines/ci-infrastructure.yaml.md
[461]: ../../../../pipelines/ci-automation.yaml
[462]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[463]: ../../../../importer.ps1
[464]: ../../automation/two-gates-check-the-layer-pins.md
[465]: ../../../adr/glossary.md#world-map
[466]: ../../../adr/glossary.md#track
[467]: ../../../adr/glossary.md#file-language
[468]: ../../../adr/glossary.md#cell
[469]: ../../../adr/glossary.md#lit-cell
[470]: ../../../adr/glossary.md#root-file
[471]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[472]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[473]: ../../../adr/glossary.md#all-tests
[474]: ../../../adr/automation/test-automation.md#rule-adr-auto-test36
[475]: ../../../adr/glossary.md#build-verification-test
[476]: ../../../adr/automation/test-automation.md#rule-adr-auto-test24
[477]: ../../../adr/glossary.md#category
[478]: ../../../adr/automation/test-automation.md#rule-adr-auto-test1
[479]: ../../../adr/glossary.md#phase
[480]: ../../../adr/automation/test-automation.md#rule-adr-auto-test26
[481]: ../../../adr/glossary.md#quality-gate
[482]: ../../../adr/automation/test-automation.md#rule-adr-auto-test35
[483]: ../../../adr/glossary.md#test
[484]: ../../../adr/automation/test-automation.md#rule-adr-auto-test42
[485]: ../../../adr/glossary.md#test-file
[486]: ../../../adr/automation/test-automation.md#rule-adr-auto-test43
[487]: ../../../adr/glossary.md#test-run
[488]: ../../../adr/automation/test-automation.md#rule-adr-auto-test34
[489]: ../../../adr/glossary.md#test-suite
[490]: ../../../adr/automation/test-automation.md#rule-adr-auto-test37
[491]: ../../../adr/glossary.md#testing-in-production
[492]: ../../../adr/automation/test-automation.md#rule-adr-auto-test41
[493]: ../../../adr/glossary.md#tier
[494]: ../../../adr/automation/test-automation.md#rule-adr-auto-test13
[495]: ../../../adr/glossary.md#vertical-test
[496]: ../../../adr/automation/test-automation.md#rule-adr-auto-test38

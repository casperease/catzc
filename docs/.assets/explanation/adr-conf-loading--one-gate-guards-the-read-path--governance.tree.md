# docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md

`Tree minimap: adr-conf-loading--one-gate-guards-the-read-path--governance`

![Tree minimap of adr-conf-loading--one-gate-guards-the-read-path--governance](adr-conf-loading--one-gate-guards-the-read-path--governance.tree.png)

The tree minimap of the slide `adr-conf-loading--one-gate-guards-the-read-path--governance` (governance lens). The slide supports
[ADR-AUTO-TEST][1], [ADR-CONF-ADDRESSING][2] and [ADR-CONF-LOADING][3]; the highlight of those ADR codes selects what is lit, and each
reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 475 files in 40 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- QualityGates (automation/Catzc.Base.QualityGates): 126 lit files
- docs (docs/ outside docs/adr/): 62 lit files
- Docs (automation/Catzc.Base.Docs): 43 lit files
- adr/auto (docs/adr/automation): 39 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 30 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 20 lit files
- Globs (automation/Catzc.Base.Globs): 14 lit files
- Languages (automation/Catzc.Base.Languages): 13 lit files
- Azure (automation/Catzc.Azure): 11 lit files
- Execution (automation/Catzc.Base.Execution): 11 lit files
- Tool.Core (automation/Catzc.Tooling.Core): 11 lit files
- Maps (automation/Catzc.Base.Maps): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 9 lit files
- Contracts (automation/Catzc.Base.Contracts): 7 lit files
- Tool.Provisioning (automation/Catzc.Tooling.Provisioning): 7 lit files
- Config (automation/Catzc.Base.Config): 5 lit files
- Reports (automation/Catzc.Base.Reports): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- .internal (automation/.internal): 4 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 4 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 4 lit files
- Root files: 3 lit files
- .claude: 3 lit files
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 3 lit files
- Exporter (automation/Catzc.Base.Exporter): 3 lit files
- Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler): 3 lit files
- adr/conf (docs/adr/configuration): 3 lit files
- Git (automation/Catzc.Base.Git): 2 lit files
- Objects (automation/Catzc.Base.Objects): 2 lit files
- Repository (automation/Catzc.Base.Repository): 2 lit files
- Tool.Toolchain (automation/Catzc.Tooling.Toolchain): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .scriptanalyzer (automation/.scriptanalyzer): 1 lit file
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Environment (automation/Catzc.Base.Environment): 1 lit file
- Files (automation/Catzc.Base.Files): 1 lit file
- Timeouts (automation/Catzc.Base.Timeouts): 1 lit file
- Tool.Python (automation/Catzc.Tooling.Python): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### QualityGates (126 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1][4], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 6 (header) and line 8 (header).
- [automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 13 (header), line 24 (header), line 28 (header), line 34 (header) and line 35 (header).
- [automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][7], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 13 (header), line 19 (header), line 21 (header), line 71 (header), line 87 (header), line 172 (body comment) and line 184
  (body comment).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][8], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][9], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 6 (header), line 16 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/Test-Change.ps1][10], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1][11], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/Test-Formatting.ps1][12], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1][13], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/Test-Links.ps1][14], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 13 (header).
- [automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1][15], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 6 (header) and line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1][16], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1][17], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header) and line 10 (header).
- [automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1][18], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1][19], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1][20], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1][21], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][22], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header); selected by [ADR-CONF-LOADING][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1][23], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-Spelling.ps1][24], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/Test-Terminology.ps1][25], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 23 (header).
- [automation/Catzc.Base.QualityGates/Test-TestTitles.ps1][26], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header) and line 10 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][27], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 27 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][28], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 9 (text), line 25 (text), line 34 (text), line 44 (text), line 71 (text), line 86 (text), line 109 (text), line 121
  (text), line 131 (text), line 141 (text), line 156 (text) and line 170 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][29], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 26 (header).
- [automation/Catzc.Base.QualityGates/configs/test-policy.yml][30], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 1 (header).
- [automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1][31], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1][32], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header) and line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1][33], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][34], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][35], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 24 (header); selected by [ADR-CONF-LOADING][3]: the file cites it at line 13 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1][36], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1][37], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1][38], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1][39], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1][40], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1][41], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header), line 16 (header) and line 185 (body comment).
- [automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1][42], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1][43], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 11 (header), line 39 (header) and line 137 (body comment).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1][44], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header) and line 20 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][45], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1][46], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 15 (header).
- [automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1][47], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 20 (header) and line 24 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1][48], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1][49], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1][50], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1][51], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 14 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1][52], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1][53], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1][54], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 1 (header), line 3 (header) and line 231 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1][55], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1][56], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1][57], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1][58], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text) and line 23 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1][59], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1][60], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1][61], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1][62], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1][63], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1][64], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1][65], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1][66], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1][67], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1][68], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 10 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1][69], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1][70], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1][71], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1][72], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 62 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1][73], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1][74], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 23 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1][75], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1][76], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1][77], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][78], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1][79], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1][80], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1][81], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (text), line 2 (body comment), line 100 (text) and line 104 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1][82], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1][83], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1][85], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1][87], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1][88], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1][89], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 77 (body comment), line 83 (body comment), line 127 (body comment) and line 132 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1][90], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 85 (text), line 110 (text), line 183 (text), line 198 (text), line 198 (body comment) and
  line 238 (text).
- [automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1][91], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 8 (header), line 13 (header) and line 15 (header).
- [automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1][92], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1][93], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1][94], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 44 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1][95], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1][96], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (text) and line 13 (text).
- [automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1][97], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1][98], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1][99], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1][100], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1][101], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 16 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1][102], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1][103], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 18 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1][104], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header), line 57 (text), line 66 (text) and line 81 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1][105], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1][106], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1][107], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header), line 4 (header), line 52 (text), line 56 (text) and line 74 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1][108], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header), line 3 (header), line 29 (body comment), line 37 (text) and line 79 (body
  comment).
- [automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1][109], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header), line 23 (text), line 29 (text) and line 43 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1][110], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header), line 5 (header), line 24 (body comment), line 29 (body comment) and line 42 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1][111], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1][112], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header), line 6 (header), line 7 (header), line 43 (text), line 47 (text) and line 52
  (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1][113], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1][114], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1][115], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 19 (text), line 29 (text), line 39 (text), line 103 (body comment) and line 105 (body
  comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1][116], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1][117], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header), line 3 (header), line 29 (text) and line 60 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1][118], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 37 (text), line 46 (text) and line 58 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1][119], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header), line 4 (header) and line 162 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][120], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1][121], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1][122], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 20 (text), line 29 (text), line 43 (text), line 115 (body comment) and line 117 (body
  comment).
- [automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1][123], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1][124], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 6 (header).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1][125], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1][126], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1][127], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 35 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs][128], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][129], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 2 (header).

### docs (62 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][130], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 65 (text), line 65 (text), line 87 (text), line 88 (text), line 89 (text),
  line 90 (text), line 91 (text), line 92 (text), line 93 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text) and line 98
  (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][131], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][132], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 33 (text), line 34 (text), line 35 (text), line 52 (text), line 56 (text),
  line 57 (text), line 58 (text), line 59 (text), line 60 (text), line 61 (text), line 62 (text), line 63 (text), line 73 (text), line 75
  (text), line 78 (text), line 79 (text), line 80 (text), line 84 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line
  109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line
  125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line
  141 (text), line 143 (text), line 145 (text), line 147 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line
  156 (text), line 158 (text), line 160 (text), line 161 (text), line 163 (text), line 167 (text), line 169 (text), line 173 (text), line
  175 (text), line 177 (text), line 179 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line
  192 (text), line 194 (text), line 196 (text), line 197 (text), line 198 (text), line 199 (text), line 201 (text), line 205 (text), line
  206 (text), line 208 (text), line 209 (text), line 210 (text), line 212 (text), line 216 (text), line 218 (text), line 220 (text), line
  222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line
  238 (text), line 239 (text), line 241 (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 250 (text), line
  252 (text), line 254 (text), line 256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line
  268 (text), line 270 (text), line 272 (text), line 274 (text), line 276 (text), line 287 (text), line 289 (text), line 291 (text), line
  293 (text), line 296 (text), line 297 (text), line 299 (text), line 300 (text), line 301 (text), line 303 (text), line 305 (text), line
  307 (text), line 309 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text), line
  323 (text), line 325 (text), line 327 (text), line 329 (text), line 331 (text), line 333 (text), line 335 (text), line 337 (text), line
  338 (text), line 339 (text), line 340 (text), line 342 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line
  355 (text), line 362 (text), line 364 (text), line 366 (text), line 369 (text), line 370 (text), line 371 (text), line 373 (text), line
  376 (text), line 379 (text), line 381 (text), line 383 (text), line 385 (text), line 387 (text), line 390 (text), line 391 (text), line
  393 (text), line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 403 (text), line 404 (text), line 406 (text), line
  408 (text), line 410 (text), line 411 (text), line 413 (text), line 414 (text), line 415 (text), line 416 (text), line 418 (text), line
  419 (text), line 421 (text), line 422 (text), line 423 (text), line 426 (text), line 427 (text), line 428 (text), line 430 (text), line
  431 (text), line 432 (text), line 434 (text), line 436 (text), line 438 (text), line 440 (text), line 442 (text), line 444 (text), line
  448 (text), line 450 (text), line 454 (text), line 458 (text), line 460 (text), line 462 (text), line 465 (text), line 466 (text), line
  468 (text), line 470 (text), line 472 (text), line 474 (text), line 476 (text), line 478 (text), line 480 (text), line 482 (text), line
  484 (text), line 487 (text), line 489 (text), line 491 (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text), line
  501 (text), line 503 (text), line 505 (text), line 507 (text), line 509 (text), line 511 (text), line 513 (text), line 515 (text), line
  517 (text), line 519 (text), line 521 (text), line 523 (text), line 527 (text), line 529 (text), line 531 (text), line 533 (text), line
  535 (text), line 537 (text), line 539 (text), line 541 (text), line 543 (text), line 545 (text), line 547 (text), line 549 (text), line
  551 (text), line 553 (text), line 555 (text), line 557 (text), line 559 (text), line 561 (text), line 563 (text), line 565 (text), line
  567 (text), line 570 (text), line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line
  584 (text), line 586 (text), line 589 (text), line 590 (text), line 596 (text), line 598 (text), line 600 (text), line 602 (text), line
  604 (text), line 608 (text), line 610 (text), line 612 (text), line 614 (text), line 616 (text), line 618 (text), line 620 (text), line
  622 (text), line 625 (text), line 627 (text), line 629 (text), line 631 (text), line 633 (text), line 635 (text), line 637 (text), line
  639 (text), line 641 (text), line 643 (text), line 645 (text), line 646 (text), line 648 (text), line 654 (text), line 656 (text), line
  659 (text), line 661 (text), line 662 (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 682 (text), line
  683 (text), line 685 (text), line 687 (text), line 689 (text), line 693 (text), line 694 (text), line 696 (text), line 698 (text), line
  700 (text), line 702 (text), line 704 (text), line 706 (text), line 708 (text), line 710 (text), line 712 (text), line 714 (text), line
  716 (text), line 718 (text), line 720 (text), line 722 (text), line 724 (text), line 726 (text), line 728 (text), line 730 (text), line
  732 (text), line 734 (text), line 736 (text), line 738 (text), line 740 (text), line 742 (text), line 746 (text), line 750 (text), line
  758 (text), line 759 (text), line 761 (text), line 763 (text), line 765 (text), line 767 (text), line 769 (text), line 771 (text), line
  774 (text), line 776 (text), line 777 (text), line 781 (text), line 783 (text), line 784 (text), line 785 (text), line 813 (text), line
  815 (text), line 817 (text), line 819 (text), line 831 (text), line 834 (text), line 837 (text), line 840 (text), line 843 (text), line
  846 (text), line 849 (text), line 852 (text), line 855 (text), line 858 (text), line 861 (text), line 864 (text), line 867 (text), line
  870 (text), line 873 (text), line 876 (text), line 879 (text), line 882 (text), line 885 (text), line 888 (text), line 891 (text), line
  894 (text), line 897 (text), line 900 (text), line 903 (text), line 906 (text), line 909 (text), line 912 (text), line 915 (text), line
  918 (text), line 921 (text), line 924 (text), line 927 (text), line 930 (text), line 933 (text), line 936 (text), line 939 (text), line
  942 (text), line 945 (text), line 948 (text), line 951 (text), line 968 (text), line 972 (text), line 996 (text), line 1000 (text), line
  1003 (text), line 1007 (text), line 1017 (text), line 1018 (text), line 1020 (text), line 1022 (text), line 1023 (text), line 1028 (text),
  line 1029 (text), line 1031 (text), line 1032 (text), line 1033 (text), line 1034 (text), line 1035 (text), line 1042 (text), line 1051
  (text), line 1066 (text), line 1074 (text), line 1103 (text), line 1104 (text), line 1105 (text), line 1106 (text), line 1107 (text), line
  1108 (text), line 1109 (text), line 1110 (text), line 1111 (text), line 1112 (text), line 1113 (text) and line 1114 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md][133], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 73 (text),
  line 75 (text), line 78 (text), line 81 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 96 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 114 (text), line 115 (text), line 119 (text), line 121 (text), line 124 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 138 (text), line 140 (text), line 144 (text), line 148 (text), line 149
  (text), line 152 (text), line 154 (text), line 157 (text), line 159 (text), line 161 (text), line 163 (text), line 165 (text), line 167
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 180 (text), line 182 (text), line 184
  (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200
  (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 218
  (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234
  (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250
  (text), line 253 (text), line 255 (text), line 258 (text), line 260 (text), line 262 (text), line 265 (text), line 267 (text), line 269
  (text), line 271 (text), line 273 (text), line 275 (text), line 277 (text), line 279 (text), line 281 (text), line 284 (text), line 290
  (text), line 292 (text), line 294 (text), line 296 (text), line 299 (text), line 302 (text), line 305 (text), line 307 (text), line 310
  (text), line 312 (text), line 314 (text), line 317 (text), line 319 (text), line 321 (text), line 324 (text), line 326 (text), line 328
  (text), line 330 (text), line 333 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 342 (text), line 344
  (text), line 371 (text), line 374 (text), line 376 (text), line 378 (text), line 390 (text), line 392 (text), line 416 (text), line 420
  (text), line 423 (text), line 427 (text), line 438 (text), line 440 (text), line 442 (text), line 444 (text), line 446 (text), line 452
  (text), line 454 (text), line 456 (text), line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 471 (text), line 473
  (text), line 475 (text), line 477 (text), line 480 (text), line 482 (text), line 487 (text), line 490 (text), line 493 (text), line 494
  (text), line 496 (text), line 498 (text), line 501 (text), line 505 (text), line 507 (text), line 508 (text), line 511 (text), line 513
  (text), line 515 (text), line 517 (text), line 519 (text), line 521 (text), line 523 (text), line 525 (text), line 526 (text), line 529
  (text), line 531 (text), line 532 (text), line 534 (text), line 537 (text), line 539 (text), line 541 (text), line 542 (text), line 544
  (text), line 547 (text), line 549 (text), line 550 (text), line 559 (text), line 562 (text), line 565 (text), line 568 (text), line 571
  (text), line 574 (text), line 577 (text), line 581 (text), line 584 (text), line 587 (text), line 590 (text), line 593 (text), line 596
  (text), line 599 (text), line 602 (text), line 605 (text), line 608 (text), line 611 (text), line 614 (text), line 617 (text), line 620
  (text), line 623 (text), line 626 (text), line 629 (text), line 632 (text), line 635 (text), line 638 (text), line 641 (text), line 644
  (text), line 647 (text), line 650 (text), line 653 (text), line 657 (text), line 660 (text), line 663 (text), line 666 (text), line 669
  (text), line 672 (text), line 675 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 690 (text), line 693
  (text), line 695 (text), line 698 (text), line 701 (text), line 702 (text), line 706 (text), line 708 (text), line 711 (text), line 714
  (text), line 716 (text), line 718 (text), line 720 (text), line 722 (text), line 724 (text), line 726 (text), line 728 (text), line 731
  (text), line 733 (text), line 736 (text), line 738 (text), line 740 (text), line 742 (text), line 744 (text), line 746 (text), line 758
  (text), line 768 (text), line 770 (text), line 773 (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 785
  (text), line 788 (text), line 790 (text), line 794 (text), line 796 (text), line 798 (text), line 800 (text), line 802 (text), line 804
  (text), line 806 (text), line 807 (text), line 816 (text), line 819 (text), line 820 (text), line 822 (text), line 825 (text), line 826
  (text), line 828 (text), line 831 (text), line 833 (text), line 835 (text), line 837 (text), line 839 (text), line 841 (text), line 842
  (text), line 864 (text), line 865 (text), line 868 (text), line 878 (text), line 880 (text), line 883 (text), line 884 (text), line 886
  (text), line 888 (text), line 890 (text), line 893 (text), line 894 (text), line 896 (text), line 898 (text), line 906 (text), line 908
  (text), line 910 (text), line 912 (text), line 913 (text), line 916 (text), line 918 (text), line 920 (text), line 921 (text), line 923
  (text), line 925 (text), line 932 (text), line 934 (text), line 937 (text), line 938 (text), line 941 (text), line 943 (text), line 945
  (text), line 947 (text), line 949 (text), line 951 (text), line 953 (text), line 959 (text), line 962 (text), line 964 (text), line 966
  (text), line 968 (text), line 970 (text), line 972 (text), line 974 (text), line 976 (text), line 978 (text), line 995 (text), line 998
  (text), line 1000 (text), line 1002 (text), line 1004 (text), line 1010 (text), line 1012 (text), line 1014 (text), line 1017 (text), line
  1018 (text), line 1020 (text), line 1022 (text), line 1025 (text), line 1027 (text), line 1036 (text), line 1037 (text), line 1039 (text),
  line 1042 (text), line 1044 (text), line 1046 (text), line 1048 (text), line 1050 (text), line 1081 (text), line 1084 (text), line 1086
  (text), line 1088 (text), line 1090 (text), line 1092 (text), line 1094 (text), line 1102 (text), line 1104 (text), line 1106 (text), line
  1108 (text), line 1110 (text), line 1112 (text), line 1114 (text), line 1122 (text), line 1124 (text), line 1128 (text), line 1130 (text),
  line 1140 (text), line 1141 (text), line 1146 (text), line 1153 (text), line 1155 (text), line 1158 (text), line 1161 (text), line 1162
  (text), line 1176 (text), line 1178 (text), line 1184 (text), line 1186 (text), line 1189 (text), line 1190 (text), line 1198 (text), line
  1200 (text), line 1202 (text), line 1204 (text), line 1213 (text), line 1217 (text), line 1225 (text), line 1233 (text), line 1241 (text),
  line 1253 (text), line 1254 (text), line 1256 (text), line 1265 (text), line 1267 (text), line 1269 (text), line 1276 (text), line 1278
  (text), line 1280 (text), line 1287 (text), line 1296 (text), line 1298 (text), line 1313 (text), line 1317 (text), line 1332 (text), line
  1339 (text), line 1346 (text), line 1353 (text), line 1359 (text), line 1367 (text), line 1373 (text), line 1398 (text), line 1399 (text),
  line 1400 (text), line 1401 (text), line 1402 (text), line 1403 (text), line 1404 (text), line 1405 (text), line 1406 (text), line 1407
  (text), line 1408 (text) and line 1409 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md][134], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 34 (text), line 34 (text), line 48 (text), line 49 (text), line 50 (text),
  line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59
  (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md][135], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md][136], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 32 (text), line 33 (text), line 34 (text), line 44 (text), line 46 (text),
  line 47 (text), line 48 (text), line 49 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 65 (text), line 67
  (text), line 69 (text), line 70 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text),
  line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98
  (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114
  (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130
  (text), line 132 (text), line 134 (text), line 136 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145
  (text), line 147 (text), line 149 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160
  (text), line 162 (text), line 164 (text), line 166 (text), line 167 (text), line 169 (text), line 171 (text), line 173 (text), line 175
  (text), line 177 (text), line 179 (text), line 180 (text), line 181 (text), line 182 (text), line 183 (text), line 185 (text), line 186
  (text), line 188 (text), line 189 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200
  (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216
  (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 228 (text), line 230
  (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 246
  (text), line 248 (text), line 250 (text), line 252 (text), line 254 (text), line 256 (text), line 258 (text), line 260 (text), line 262
  (text), line 264 (text), line 265 (text), line 267 (text), line 268 (text), line 269 (text), line 271 (text), line 273 (text), line 275
  (text), line 277 (text), line 279 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 291
  (text), line 293 (text), line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line 305 (text), line 306
  (text), line 307 (text), line 308 (text), line 310 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319
  (text), line 321 (text), line 323 (text), line 325 (text), line 327 (text), line 329 (text), line 330 (text), line 331 (text), line 333
  (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349
  (text), line 351 (text), line 353 (text), line 355 (text), line 357 (text), line 359 (text), line 360 (text), line 362 (text), line 364
  (text), line 366 (text), line 367 (text), line 369 (text), line 370 (text), line 371 (text), line 372 (text), line 374 (text), line 375
  (text), line 377 (text), line 378 (text), line 379 (text), line 381 (text), line 382 (text), line 383 (text), line 385 (text), line 386
  (text), line 387 (text), line 389 (text), line 391 (text), line 393 (text), line 395 (text), line 397 (text), line 399 (text), line 401
  (text), line 403 (text), line 405 (text), line 407 (text), line 409 (text), line 411 (text), line 413 (text), line 415 (text), line 417
  (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line 433
  (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445 (text), line 447 (text), line 449
  (text), line 451 (text), line 453 (text), line 455 (text), line 457 (text), line 459 (text), line 461 (text), line 463 (text), line 465
  (text), line 467 (text), line 469 (text), line 471 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481
  (text), line 483 (text), line 485 (text), line 487 (text), line 489 (text), line 491 (text), line 493 (text), line 495 (text), line 497
  (text), line 499 (text), line 501 (text), line 503 (text), line 505 (text), line 507 (text), line 509 (text), line 511 (text), line 513
  (text), line 515 (text), line 517 (text), line 519 (text), line 521 (text), line 523 (text), line 525 (text), line 527 (text), line 529
  (text), line 531 (text), line 533 (text), line 535 (text), line 537 (text), line 539 (text), line 541 (text), line 543 (text), line 545
  (text), line 547 (text), line 549 (text), line 551 (text), line 553 (text), line 555 (text), line 557 (text), line 559 (text), line 561
  (text), line 563 (text), line 565 (text), line 567 (text), line 569 (text), line 571 (text), line 573 (text), line 575 (text), line 577
  (text), line 579 (text), line 581 (text), line 583 (text), line 584 (text), line 586 (text), line 588 (text), line 590 (text), line 592
  (text), line 594 (text), line 595 (text), line 597 (text), line 599 (text), line 601 (text), line 603 (text), line 605 (text), line 606
  (text), line 608 (text), line 610 (text), line 612 (text), line 614 (text), line 615 (text), line 617 (text), line 619 (text), line 621
  (text), line 623 (text), line 625 (text), line 627 (text), line 629 (text), line 631 (text), line 633 (text), line 635 (text), line 637
  (text), line 639 (text), line 641 (text), line 643 (text), line 645 (text), line 647 (text), line 649 (text), line 651 (text), line 653
  (text), line 655 (text), line 657 (text), line 659 (text), line 661 (text), line 663 (text), line 665 (text), line 667 (text), line 675
  (text), line 676 (text), line 678 (text), line 680 (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 689
  (text), line 690 (text), line 692 (text), line 695 (text), line 696 (text), line 697 (text), line 698 (text), line 706 (text), line 713
  (text), line 718 (text), line 720 (text), line 722 (text), line 725 (text), line 727 (text), line 729 (text), line 731 (text), line 733
  (text), line 735 (text), line 737 (text), line 739 (text), line 741 (text), line 743 (text), line 745 (text), line 747 (text), line 749
  (text), line 751 (text), line 753 (text), line 755 (text), line 757 (text), line 759 (text), line 761 (text), line 763 (text), line 765
  (text), line 767 (text), line 769 (text), line 771 (text), line 773 (text), line 775 (text), line 777 (text), line 779 (text), line 781
  (text), line 783 (text), line 785 (text), line 787 (text), line 789 (text), line 791 (text), line 793 (text), line 795 (text), line 797
  (text), line 799 (text), line 801 (text), line 803 (text), line 804 (text), line 807 (text), line 814 (text), line 820 (text), line 822
  (text), line 824 (text), line 825 (text), line 826 (text), line 828 (text), line 830 (text), line 831 (text), line 833 (text), line 834
  (text), line 836 (text), line 837 (text), line 838 (text), line 839 (text), line 840 (text), line 847 (text), line 855 (text), line 866
  (text), line 869 (text), line 894 (text), line 895 (text), line 896 (text), line 897 (text), line 898 (text), line 899 (text), line 900
  (text), line 901 (text), line 902 (text), line 903 (text), line 904 (text) and line 905 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md][137], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 70 (text),
  line 72 (text), line 74 (text), line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 95 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 113 (text), line 115 (text), line 118 (text), line 120 (text), line 122 (text),
  line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 137 (text),
  line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text),
  line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 170 (text),
  line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text),
  line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text),
  line 204 (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text),
  line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text),
  line 237 (text), line 239 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text),
  line 254 (text), line 256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text),
  line 270 (text), line 272 (text), line 274 (text), line 277 (text), line 278 (text), line 281 (text), line 283 (text), line 286 (text),
  line 288 (text), line 290 (text), line 293 (text), line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text),
  line 305 (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 317 (text), line 319 (text),
  line 327 (text), line 330 (text), line 333 (text), line 336 (text), line 339 (text), line 342 (text), line 345 (text), line 348 (text),
  line 351 (text), line 354 (text), line 357 (text), line 360 (text), line 363 (text), line 366 (text), line 369 (text), line 372 (text),
  line 375 (text), line 378 (text), line 381 (text), line 384 (text), line 387 (text), line 390 (text), line 393 (text), line 396 (text),
  line 399 (text), line 402 (text), line 405 (text), line 408 (text), line 411 (text), line 414 (text), line 417 (text), line 420 (text),
  line 423 (text), line 426 (text), line 429 (text), line 432 (text), line 435 (text), line 438 (text), line 441 (text), line 448 (text),
  line 450 (text), line 452 (text), line 454 (text), line 457 (text), line 458 (text), line 461 (text), line 462 (text), line 465 (text),
  line 466 (text), line 468 (text), line 470 (text), line 473 (text), line 475 (text), line 477 (text), line 478 (text), line 481 (text),
  line 483 (text), line 485 (text), line 487 (text), line 489 (text), line 491 (text), line 493 (text), line 495 (text), line 496 (text),
  line 499 (text), line 501 (text), line 502 (text), line 504 (text), line 507 (text), line 509 (text), line 511 (text), line 512 (text),
  line 514 (text), line 517 (text), line 519 (text), line 520 (text), line 528 (text), line 534 (text), line 540 (text), line 542 (text),
  line 544 (text), line 546 (text), line 553 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text),
  line 568 (text), line 570 (text), line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text),
  line 584 (text), line 586 (text), line 594 (text), line 596 (text), line 598 (text), line 600 (text), line 602 (text), line 605 (text),
  line 607 (text), line 610 (text), line 613 (text), line 614 (text), line 618 (text), line 620 (text), line 623 (text), line 626 (text),
  line 628 (text), line 630 (text), line 632 (text), line 634 (text), line 636 (text), line 638 (text), line 640 (text), line 643 (text),
  line 645 (text), line 648 (text), line 650 (text), line 652 (text), line 654 (text), line 656 (text), line 658 (text), line 664 (text),
  line 666 (text), line 668 (text), line 671 (text), line 673 (text), line 674 (text), line 676 (text), line 678 (text), line 681 (text),
  line 683 (text), line 685 (text), line 687 (text), line 689 (text), line 691 (text), line 693 (text), line 695 (text), line 697 (text),
  line 699 (text), line 700 (text), line 713 (text), line 716 (text), line 717 (text), line 719 (text), line 722 (text), line 723 (text),
  line 725 (text), line 728 (text), line 730 (text), line 732 (text), line 734 (text), line 736 (text), line 738 (text), line 739 (text),
  line 746 (text), line 748 (text), line 751 (text), line 752 (text), line 754 (text), line 756 (text), line 758 (text), line 761 (text),
  line 762 (text), line 764 (text), line 766 (text), line 774 (text), line 776 (text), line 778 (text), line 780 (text), line 781 (text),
  line 784 (text), line 786 (text), line 788 (text), line 789 (text), line 791 (text), line 793 (text), line 800 (text), line 802 (text),
  line 805 (text), line 806 (text), line 809 (text), line 811 (text), line 813 (text), line 815 (text), line 817 (text), line 819 (text),
  line 821 (text), line 827 (text), line 830 (text), line 832 (text), line 834 (text), line 836 (text), line 838 (text), line 840 (text),
  line 842 (text), line 844 (text), line 846 (text), line 853 (text), line 855 (text), line 857 (text), line 860 (text), line 861 (text),
  line 863 (text), line 865 (text), line 868 (text), line 870 (text), line 877 (text), line 878 (text), line 880 (text), line 883 (text),
  line 885 (text), line 887 (text), line 889 (text), line 891 (text), line 897 (text), line 900 (text), line 902 (text), line 904 (text),
  line 906 (text), line 908 (text), line 910 (text), line 918 (text), line 920 (text), line 922 (text), line 924 (text), line 926 (text),
  line 928 (text), line 930 (text), line 936 (text), line 938 (text), line 941 (text), line 944 (text), line 945 (text), line 952 (text),
  line 955 (text), line 957 (text), line 959 (text), line 961 (text), line 967 (text), line 968 (text), line 970 (text), line 979 (text),
  line 981 (text), line 983 (text), line 985 (text), line 992 (text), line 994 (text), line 997 (text), line 998 (text), line 1006 (text),
  line 1008 (text), line 1010 (text), line 1012 (text), line 1018 (text), line 1021 (text), line 1024 (text), line 1035 (text), line 1036
  (text), line 1039 (text), line 1047 (text), line 1049 (text), line 1051 (text), line 1058 (text), line 1059 (text), line 1062 (text), line
  1069 (text), line 1071 (text), line 1073 (text), line 1080 (text), line 1082 (text), line 1089 (text), line 1091 (text), line 1098 (text),
  line 1100 (text), line 1106 (text), line 1110 (text), line 1117 (text), line 1124 (text), line 1131 (text), line 1138 (text), line 1145
  (text), line 1151 (text), line 1159 (text), line 1165 (text), line 1189 (text), line 1190 (text), line 1191 (text), line 1192 (text), line
  1193 (text), line 1194 (text), line 1195 (text), line 1196 (text), line 1197 (text), line 1198 (text), line 1199 (text) and line 1200
  (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md][138], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md][139], in the cell docs × markdown:
  selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 70 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 70
  (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md][140], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text),
  line 31 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text),
  line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md][141], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63
  (text), line 65 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text),
  line 86 (text), line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line
  122 (text), line 129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md][142], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md][143], in the cell docs ×
  markdown: selected by [ADR-CONF-LOADING][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md][144], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text),
  line 31 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text),
  line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md][145], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63
  (text), line 65 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text),
  line 86 (text), line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line
  122 (text), line 129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][146], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 37 (text), line 37 (text), line 51 (text), line 52 (text), line
  53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text), line 61 (text)
  and line 62 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 8 (text), line 26 (text) and line 26 (text); selected
  by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 29 (text) and line 29 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md][147], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 72 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 72
  (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][148], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 32 (text), line 33 (text), line 34 (text), line 46 (text), line 49 (text),
  line 50 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text), line 65 (text), line 67
  (text), line 69 (text), line 70 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116
  (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132
  (text), line 134 (text), line 136 (text), line 138 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147
  (text), line 149 (text), line 151 (text), line 152 (text), line 154 (text), line 160 (text), line 162 (text), line 164 (text), line 167
  (text), line 169 (text), line 171 (text), line 173 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182
  (text), line 184 (text), line 187 (text), line 188 (text), line 189 (text), line 190 (text), line 193 (text), line 196 (text), line 197
  (text), line 199 (text), line 200 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211
  (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line 225 (text), line 227
  (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241
  (text), line 243 (text), line 245 (text), line 247 (text), line 251 (text), line 253 (text), line 255 (text), line 257 (text), line 259
  (text), line 261 (text), line 263 (text), line 265 (text), line 267 (text), line 269 (text), line 271 (text), line 273 (text), line 275
  (text), line 279 (text), line 280 (text), line 282 (text), line 283 (text), line 284 (text), line 286 (text), line 288 (text), line 290
  (text), line 292 (text), line 294 (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 308 (text), line 310
  (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 325
  (text), line 326 (text), line 327 (text), line 329 (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 339
  (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 350 (text), line 351 (text), line 353
  (text), line 355 (text), line 357 (text), line 359 (text), line 361 (text), line 363 (text), line 365 (text), line 367 (text), line 369
  (text), line 371 (text), line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 380 (text), line 382 (text), line 384
  (text), line 386 (text), line 387 (text), line 389 (text), line 390 (text), line 391 (text), line 392 (text), line 394 (text), line 395
  (text), line 397 (text), line 398 (text), line 399 (text), line 401 (text), line 402 (text), line 404 (text), line 406 (text), line 407
  (text), line 408 (text), line 410 (text), line 412 (text), line 414 (text), line 416 (text), line 418 (text), line 420 (text), line 422
  (text), line 424 (text), line 426 (text), line 428 (text), line 430 (text), line 432 (text), line 434 (text), line 436 (text), line 438
  (text), line 440 (text), line 442 (text), line 444 (text), line 446 (text), line 448 (text), line 450 (text), line 452 (text), line 454
  (text), line 456 (text), line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 470
  (text), line 472 (text), line 474 (text), line 476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 486
  (text), line 488 (text), line 490 (text), line 492 (text), line 494 (text), line 496 (text), line 498 (text), line 500 (text), line 502
  (text), line 504 (text), line 506 (text), line 508 (text), line 510 (text), line 512 (text), line 514 (text), line 516 (text), line 518
  (text), line 520 (text), line 522 (text), line 524 (text), line 526 (text), line 528 (text), line 530 (text), line 532 (text), line 534
  (text), line 536 (text), line 538 (text), line 540 (text), line 542 (text), line 544 (text), line 546 (text), line 548 (text), line 550
  (text), line 552 (text), line 554 (text), line 556 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line 566
  (text), line 568 (text), line 570 (text), line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582
  (text), line 584 (text), line 586 (text), line 588 (text), line 590 (text), line 592 (text), line 594 (text), line 596 (text), line 598
  (text), line 600 (text), line 602 (text), line 604 (text), line 605 (text), line 607 (text), line 609 (text), line 611 (text), line 613
  (text), line 615 (text), line 616 (text), line 618 (text), line 620 (text), line 622 (text), line 624 (text), line 626 (text), line 627
  (text), line 629 (text), line 631 (text), line 633 (text), line 635 (text), line 636 (text), line 638 (text), line 640 (text), line 642
  (text), line 644 (text), line 646 (text), line 648 (text), line 650 (text), line 652 (text), line 654 (text), line 656 (text), line 658
  (text), line 660 (text), line 662 (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 674
  (text), line 676 (text), line 678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 696
  (text), line 697 (text), line 699 (text), line 700 (text), line 702 (text), line 704 (text), line 706 (text), line 708 (text), line 710
  (text), line 711 (text), line 713 (text), line 716 (text), line 717 (text), line 718 (text), line 719 (text), line 727 (text), line 729
  (text), line 735 (text), line 742 (text), line 744 (text), line 747 (text), line 748 (text), line 750 (text), line 752 (text), line 754
  (text), line 756 (text), line 758 (text), line 760 (text), line 762 (text), line 764 (text), line 766 (text), line 768 (text), line 770
  (text), line 772 (text), line 774 (text), line 776 (text), line 778 (text), line 780 (text), line 782 (text), line 784 (text), line 786
  (text), line 788 (text), line 790 (text), line 792 (text), line 794 (text), line 796 (text), line 798 (text), line 800 (text), line 802
  (text), line 804 (text), line 806 (text), line 808 (text), line 810 (text), line 812 (text), line 814 (text), line 816 (text), line 818
  (text), line 820 (text), line 822 (text), line 824 (text), line 834 (text), line 837 (text), line 839 (text), line 841 (text), line 848
  (text), line 856 (text), line 857 (text), line 858 (text), line 860 (text), line 862 (text), line 863 (text), line 867 (text), line 869
  (text), line 871 (text), line 872 (text), line 873 (text), line 874 (text), line 875 (text), line 882 (text), line 890 (text), line 901
  (text), line 904 (text), line 929 (text), line 930 (text), line 931 (text), line 932 (text), line 933 (text), line 934 (text), line 935
  (text), line 936 (text), line 937 (text), line 938 (text), line 939 (text) and line 940 (text); selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 8 (text), line 82 (text), line 156 (text), line 158 (text), line 165 (text), line 304 (text), line 306 (text), line
  701 (text), line 732 (text), line 736 (text), line 826 (text), line 829 (text), line 831 (text), line 837 (text), line 843 (text) and line
  849 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 43 (text), line 44 (text), line 45 (text), line 48
  (text), line 56 (text), line 157 (text), line 166 (text), line 186 (text), line 191 (text), line 195 (text), line 202 (text), line 249
  (text), line 277 (text), line 338 (text), line 403 (text), line 419 (text), line 701 (text), line 732 (text), line 734 (text), line 737
  (text), line 738 (text), line 741 (text), line 827 (text), line 830 (text), line 832 (text), line 838 (text), line 844 (text), line 846
  (text), line 850 (text), line 852 (text), line 854 (text), line 865 (text) and line 868 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md][149], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 115 (text), line 117 (text), line 120 (text), line 122 (text), line 124
  (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 139
  (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156
  (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 165 (text), line 168 (text), line 170 (text), line 172
  (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188
  (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204
  (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220
  (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236
  (text), line 239 (text), line 241 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line 254
  (text), line 256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270
  (text), line 272 (text), line 274 (text), line 276 (text), line 279 (text), line 280 (text), line 283 (text), line 285 (text), line 288
  (text), line 290 (text), line 292 (text), line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line 305
  (text), line 307 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text), line 319 (text), line 321
  (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 338 (text), line 341 (text), line 346 (text), line 349
  (text), line 352 (text), line 353 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 364 (text), line 365
  (text), line 368 (text), line 370 (text), line 372 (text), line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382
  (text), line 383 (text), line 386 (text), line 388 (text), line 389 (text), line 391 (text), line 394 (text), line 396 (text), line 398
  (text), line 399 (text), line 401 (text), line 404 (text), line 406 (text), line 413 (text), line 420 (text), line 422 (text), line 424
  (text), line 426 (text), line 428 (text), line 430 (text), line 432 (text), line 434 (text), line 436 (text), line 438 (text), line 440
  (text), line 442 (text), line 444 (text), line 446 (text), line 448 (text), line 450 (text), line 452 (text), line 454 (text), line 456
  (text), line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 470 (text), line 472
  (text), line 474 (text), line 476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 486 (text), line 488
  (text), line 490 (text), line 492 (text), line 494 (text), line 496 (text), line 504 (text), line 506 (text), line 513 (text), line 520
  (text), line 522 (text), line 524 (text), line 525 (text), line 527 (text), line 535 (text), line 544 (text), line 546 (text), line 548
  (text), line 550 (text), line 552 (text), line 554 (text), line 558 (text), line 562 (text), line 564 (text), line 566 (text), line 568
  (text), line 570 (text), line 572 (text), line 580 (text), line 584 (text), line 586 (text), line 588 (text), line 590 (text), line 593
  (text), line 595 (text), line 598 (text), line 601 (text), line 602 (text), line 606 (text), line 608 (text), line 611 (text), line 614
  (text), line 616 (text), line 618 (text), line 620 (text), line 622 (text), line 624 (text), line 626 (text), line 628 (text), line 631
  (text), line 633 (text), line 636 (text), line 638 (text), line 640 (text), line 642 (text), line 644 (text), line 646 (text), line 654
  (text), line 656 (text), line 658 (text), line 661 (text), line 663 (text), line 664 (text), line 666 (text), line 668 (text), line 671
  (text), line 673 (text), line 675 (text), line 677 (text), line 679 (text), line 681 (text), line 683 (text), line 685 (text), line 687
  (text), line 689 (text), line 690 (text), line 697 (text), line 700 (text), line 701 (text), line 703 (text), line 706 (text), line 707
  (text), line 709 (text), line 712 (text), line 714 (text), line 716 (text), line 718 (text), line 720 (text), line 722 (text), line 723
  (text), line 735 (text), line 737 (text), line 739 (text), line 741 (text), line 742 (text), line 745 (text), line 747 (text), line 749
  (text), line 750 (text), line 752 (text), line 754 (text), line 761 (text), line 763 (text), line 766 (text), line 767 (text), line 769
  (text), line 771 (text), line 773 (text), line 776 (text), line 777 (text), line 779 (text), line 781 (text), line 788 (text), line 793
  (text), line 795 (text), line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 805 (text), line 807 (text), line 809
  (text), line 816 (text), line 818 (text), line 821 (text), line 822 (text), line 825 (text), line 827 (text), line 829 (text), line 831
  (text), line 833 (text), line 835 (text), line 837 (text), line 843 (text), line 845 (text), line 847 (text), line 850 (text), line 851
  (text), line 853 (text), line 855 (text), line 858 (text), line 860 (text), line 867 (text), line 868 (text), line 870 (text), line 873
  (text), line 875 (text), line 877 (text), line 879 (text), line 881 (text), line 889 (text), line 892 (text), line 894 (text), line 896
  (text), line 898 (text), line 900 (text), line 902 (text), line 910 (text), line 912 (text), line 914 (text), line 916 (text), line 918
  (text), line 920 (text), line 922 (text), line 934 (text), line 935 (text), line 938 (text), line 946 (text), line 948 (text), line 951
  (text), line 954 (text), line 955 (text), line 962 (text), line 965 (text), line 967 (text), line 969 (text), line 971 (text), line 977
  (text), line 979 (text), line 981 (text), line 983 (text), line 990 (text), line 992 (text), line 995 (text), line 996 (text), line 1004
  (text), line 1006 (text), line 1008 (text), line 1010 (text), line 1016 (text), line 1019 (text), line 1022 (text), line 1032 (text), line
  1033 (text), line 1035 (text), line 1044 (text), line 1046 (text), line 1048 (text), line 1055 (text), line 1056 (text), line 1059 (text),
  line 1066 (text), line 1068 (text), line 1070 (text), line 1100 (text), line 1102 (text), line 1109 (text), line 1111 (text), line 1118
  (text), line 1120 (text), line 1126 (text), line 1129 (text), line 1137 (text), line 1144 (text), line 1151 (text), line 1158 (text), line
  1165 (text), line 1171 (text), line 1179 (text), line 1185 (text), line 1209 (text), line 1210 (text), line 1211 (text), line 1212 (text),
  line 1213 (text), line 1214 (text), line 1215 (text), line 1216 (text), line 1217 (text), line 1218 (text), line 1219 (text) and line 1220
  (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 8 (text), line 339 (text), line 508 (text), line 513 (text), line
  530 (text), line 536 (text), line 582 (text), line 730 (text), line 732 (text), line 928 (text), line 932 (text), line 939 (text), line
  1076 (text), line 1079 (text), line 1082 (text) and line 1130 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 8
  (text), line 101 (text), line 128 (text), line 328 (text), line 339 (text), line 344 (text), line 347 (text), line 358 (text), line 407
  (text), line 409 (text), line 411 (text), line 508 (text), line 511 (text), line 514 (text), line 516 (text), line 518 (text), line 530
  (text), line 533 (text), line 538 (text), line 540 (text), line 542 (text), line 556 (text), line 560 (text), line 652 (text), line 790
  (text), line 882 (text), line 929 (text), line 940 (text), line 1077 (text), line 1080 (text), line 1083 (text), line 1091 (text), line
  1092 (text) and line 1130 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md][150], in the cell docs × markdown: selected
  by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md][151], in the cell docs × markdown: selected
  by [ADR-CONF-LOADING][3]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md][152], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text), line 31 (text),
  line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49 (text), line 51
  (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 77 (text),
  line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md][153], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63 (text), line 65
  (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text), line 86 (text),
  line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line 122 (text), line
  129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.chain.md][154], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md][155], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md][156], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 30 (text),
  line 31 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 45 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 61 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text),
  line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text) and line 97 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.tree.md][157], in the cell docs × markdown:
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 42 (text), line 45 (text), line 47 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 63
  (text), line 65 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 84 (text),
  line 86 (text), line 88 (text), line 95 (text), line 98 (text), line 105 (text), line 106 (text), line 113 (text), line 116 (text), line
  122 (text), line 129 (text), line 136 (text) and line 143 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][158], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 79 (text), line 79 (text), line 93 (text), line 94 (text), line 95 (text),
  line 98 (text), line 99 (text), line 101 (text), line 102 (text), line 103 (text), line 104 (text), line 105 (text), line 106 (text) and
  line 107 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][159], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][160], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 51 (text), line 53 (text),
  line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text), line 68 (text), line 70
  (text), line 72 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 79 (text), line 81 (text), line 83 (text),
  line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101
  (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117
  (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133
  (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148
  (text), line 150 (text), line 152 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 163
  (text), line 165 (text), line 167 (text), line 169 (text), line 170 (text), line 172 (text), line 174 (text), line 176 (text), line 178
  (text), line 180 (text), line 182 (text), line 183 (text), line 184 (text), line 185 (text), line 186 (text), line 188 (text), line 189
  (text), line 191 (text), line 192 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203
  (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219
  (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 231 (text), line 233
  (text), line 235 (text), line 237 (text), line 239 (text), line 241 (text), line 243 (text), line 245 (text), line 247 (text), line 249
  (text), line 251 (text), line 253 (text), line 255 (text), line 257 (text), line 259 (text), line 261 (text), line 263 (text), line 265
  (text), line 267 (text), line 268 (text), line 270 (text), line 271 (text), line 272 (text), line 274 (text), line 276 (text), line 278
  (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 290 (text), line 292 (text), line 294
  (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 306 (text), line 308 (text), line 311
  (text), line 312 (text), line 313 (text), line 315 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 326
  (text), line 328 (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 337 (text), line 338 (text), line 340
  (text), line 342 (text), line 344 (text), line 346 (text), line 348 (text), line 350 (text), line 352 (text), line 354 (text), line 356
  (text), line 358 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 367 (text), line 369 (text), line 371
  (text), line 373 (text), line 374 (text), line 376 (text), line 377 (text), line 378 (text), line 379 (text), line 381 (text), line 382
  (text), line 384 (text), line 385 (text), line 386 (text), line 388 (text), line 389 (text), line 390 (text), line 392 (text), line 393
  (text), line 394 (text), line 396 (text), line 398 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text), line 408
  (text), line 410 (text), line 412 (text), line 414 (text), line 416 (text), line 418 (text), line 420 (text), line 422 (text), line 424
  (text), line 426 (text), line 428 (text), line 430 (text), line 432 (text), line 434 (text), line 436 (text), line 438 (text), line 440
  (text), line 442 (text), line 444 (text), line 446 (text), line 448 (text), line 450 (text), line 452 (text), line 454 (text), line 456
  (text), line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 470 (text), line 472
  (text), line 474 (text), line 476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 486 (text), line 488
  (text), line 490 (text), line 492 (text), line 494 (text), line 496 (text), line 498 (text), line 500 (text), line 502 (text), line 504
  (text), line 506 (text), line 508 (text), line 510 (text), line 512 (text), line 514 (text), line 516 (text), line 518 (text), line 520
  (text), line 522 (text), line 524 (text), line 526 (text), line 528 (text), line 530 (text), line 532 (text), line 534 (text), line 536
  (text), line 538 (text), line 540 (text), line 542 (text), line 544 (text), line 546 (text), line 548 (text), line 550 (text), line 552
  (text), line 554 (text), line 556 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 568
  (text), line 570 (text), line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line 584
  (text), line 586 (text), line 588 (text), line 590 (text), line 591 (text), line 593 (text), line 595 (text), line 597 (text), line 599
  (text), line 601 (text), line 602 (text), line 604 (text), line 606 (text), line 608 (text), line 610 (text), line 612 (text), line 613
  (text), line 615 (text), line 617 (text), line 619 (text), line 621 (text), line 622 (text), line 624 (text), line 626 (text), line 628
  (text), line 630 (text), line 632 (text), line 634 (text), line 636 (text), line 638 (text), line 640 (text), line 642 (text), line 644
  (text), line 646 (text), line 648 (text), line 650 (text), line 652 (text), line 654 (text), line 656 (text), line 658 (text), line 660
  (text), line 662 (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 674 (text), line 682
  (text), line 683 (text), line 685 (text), line 686 (text), line 689 (text), line 692 (text), line 694 (text), line 696 (text), line 698
  (text), line 701 (text), line 703 (text), line 706 (text), line 707 (text), line 708 (text), line 709 (text), line 717 (text), line 719
  (text), line 721 (text), line 748 (text), line 766 (text), line 769 (text), line 771 (text), line 773 (text), line 775 (text), line 777
  (text), line 779 (text), line 781 (text), line 783 (text), line 785 (text), line 787 (text), line 789 (text), line 791 (text), line 793
  (text), line 795 (text), line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 805 (text), line 807 (text), line 809
  (text), line 811 (text), line 813 (text), line 815 (text), line 817 (text), line 819 (text), line 821 (text), line 823 (text), line 825
  (text), line 827 (text), line 829 (text), line 831 (text), line 833 (text), line 835 (text), line 837 (text), line 839 (text), line 841
  (text), line 843 (text), line 845 (text), line 847 (text), line 877 (text), line 881 (text), line 884 (text), line 886 (text), line 888
  (text), line 917 (text), line 927 (text), line 937 (text), line 941 (text), line 945 (text), line 946 (text), line 948 (text), line 949
  (text), line 951 (text), line 952 (text), line 953 (text), line 954 (text), line 955 (text), line 962 (text), line 970 (text), line 981
  (text), line 984 (text), line 1009 (text), line 1010 (text), line 1011 (text), line 1014 (text), line 1015 (text), line 1017 (text), line
  1018 (text), line 1019 (text), line 1020 (text), line 1021 (text), line 1022 (text) and line 1023 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][161], in the cell docs × markdown: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 116 (text), line 118 (text), line 121 (text), line 123 (text), line 125
  (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140
  (text), line 143 (text), line 145 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 157
  (text), line 159 (text), line 161 (text), line 163 (text), line 165 (text), line 166 (text), line 169 (text), line 171 (text), line 173
  (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189
  (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205
  (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221
  (text), line 223 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 237
  (text), line 240 (text), line 242 (text), line 245 (text), line 247 (text), line 249 (text), line 251 (text), line 253 (text), line 255
  (text), line 257 (text), line 259 (text), line 261 (text), line 263 (text), line 265 (text), line 267 (text), line 269 (text), line 271
  (text), line 273 (text), line 275 (text), line 277 (text), line 280 (text), line 281 (text), line 284 (text), line 286 (text), line 289
  (text), line 291 (text), line 293 (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 306
  (text), line 308 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 320 (text), line 322
  (text), line 330 (text), line 332 (text), line 334 (text), line 365 (text), line 383 (text), line 385 (text), line 388 (text), line 390
  (text), line 392 (text), line 421 (text), line 432 (text), line 444 (text), line 448 (text), line 452 (text), line 454 (text), line 456
  (text), line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 475 (text), line 477
  (text), line 479 (text), line 481 (text), line 483 (text), line 485 (text), line 487 (text), line 489 (text), line 491 (text), line 493
  (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 503 (text), line 505 (text), line 507 (text), line 509
  (text), line 511 (text), line 513 (text), line 515 (text), line 517 (text), line 519 (text), line 521 (text), line 523 (text), line 525
  (text), line 527 (text), line 529 (text), line 531 (text), line 533 (text), line 535 (text), line 537 (text), line 539 (text), line 541
  (text), line 543 (text), line 545 (text), line 547 (text), line 549 (text), line 551 (text), line 558 (text), line 560 (text), line 562
  (text), line 564 (text), line 566 (text), line 569 (text), line 573 (text), line 574 (text), line 577 (text), line 578 (text), line 580
  (text), line 582 (text), line 585 (text), line 587 (text), line 589 (text), line 590 (text), line 593 (text), line 595 (text), line 597
  (text), line 599 (text), line 601 (text), line 603 (text), line 605 (text), line 607 (text), line 608 (text), line 611 (text), line 613
  (text), line 614 (text), line 616 (text), line 619 (text), line 621 (text), line 623 (text), line 624 (text), line 626 (text), line 629
  (text), line 631 (text), line 634 (text), line 643 (text), line 645 (text), line 647 (text), line 649 (text), line 651 (text), line 654
  (text), line 656 (text), line 659 (text), line 662 (text), line 663 (text), line 667 (text), line 669 (text), line 672 (text), line 675
  (text), line 677 (text), line 679 (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 689 (text), line 692
  (text), line 694 (text), line 697 (text), line 699 (text), line 701 (text), line 703 (text), line 705 (text), line 707 (text), line 713
  (text), line 715 (text), line 717 (text), line 720 (text), line 722 (text), line 723 (text), line 725 (text), line 727 (text), line 732
  (text), line 734 (text), line 736 (text), line 738 (text), line 740 (text), line 742 (text), line 744 (text), line 746 (text), line 748
  (text), line 750 (text), line 751 (text), line 758 (text), line 761 (text), line 762 (text), line 764 (text), line 767 (text), line 768
  (text), line 770 (text), line 773 (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 783 (text), line 784
  (text), line 791 (text), line 793 (text), line 796 (text), line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 806
  (text), line 807 (text), line 809 (text), line 811 (text), line 819 (text), line 821 (text), line 823 (text), line 825 (text), line 826
  (text), line 829 (text), line 831 (text), line 833 (text), line 834 (text), line 836 (text), line 838 (text), line 845 (text), line 849
  (text), line 851 (text), line 854 (text), line 855 (text), line 859 (text), line 861 (text), line 864 (text), line 866 (text), line 872
  (text), line 874 (text), line 877 (text), line 878 (text), line 881 (text), line 883 (text), line 885 (text), line 887 (text), line 889
  (text), line 891 (text), line 893 (text), line 899 (text), line 902 (text), line 904 (text), line 906 (text), line 908 (text), line 910
  (text), line 912 (text), line 914 (text), line 916 (text), line 918 (text), line 956 (text), line 957 (text), line 959 (text), line 962
  (text), line 964 (text), line 966 (text), line 968 (text), line 970 (text), line 976 (text), line 979 (text), line 981 (text), line 983
  (text), line 985 (text), line 987 (text), line 989 (text), line 997 (text), line 999 (text), line 1001 (text), line 1003 (text), line 1005
  (text), line 1007 (text), line 1009 (text), line 1015 (text), line 1017 (text), line 1021 (text), line 1050 (text), line 1052 (text), line
  1055 (text), line 1058 (text), line 1059 (text), line 1066 (text), line 1069 (text), line 1071 (text), line 1073 (text), line 1075 (text),
  line 1081 (text), line 1083 (text), line 1085 (text), line 1087 (text), line 1094 (text), line 1096 (text), line 1099 (text), line 1100
  (text), line 1108 (text), line 1110 (text), line 1112 (text), line 1114 (text), line 1120 (text), line 1123 (text), line 1126 (text), line
  1137 (text), line 1138 (text), line 1141 (text), line 1149 (text), line 1151 (text), line 1153 (text), line 1160 (text), line 1161 (text),
  line 1164 (text), line 1171 (text), line 1173 (text), line 1175 (text), line 1182 (text), line 1184 (text), line 1191 (text), line 1193
  (text), line 1200 (text), line 1202 (text), line 1208 (text), line 1212 (text), line 1221 (text), line 1228 (text), line 1235 (text), line
  1242 (text), line 1249 (text), line 1255 (text), line 1263 (text), line 1269 (text), line 1293 (text), line 1294 (text), line 1295 (text),
  line 1298 (text), line 1299 (text), line 1301 (text), line 1302 (text), line 1303 (text), line 1304 (text), line 1305 (text), line 1306
  (text) and line 1307 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][162], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 43 (text), line 43 (text), line 57 (text), line 58 (text), line
  59 (text), line 60 (text), line 61 (text), line 62 (text), line 63 (text), line 64 (text), line 65 (text), line 66 (text), line 67 (text)
  and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][163], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][164], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 33 (text), line 34 (text), line 35 (text), line 52 (text), line
  66 (text), line 67 (text), line 68 (text), line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 81 (text),
  line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 97 (text), line 99 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 161 (text), line 163 (text), line 165 (text), line 167
  (text), line 169 (text), line 171 (text), line 173 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 191 (text), line 193 (text), line 195 (text), line 197
  (text), line 199 (text), line 201 (text), line 203 (text), line 204 (text), line 205 (text), line 206 (text), line 207 (text), line 209
  (text), line 210 (text), line 212 (text), line 213 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222
  (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238
  (text), line 240 (text), line 241 (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 251 (text), line 252
  (text), line 254 (text), line 256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268
  (text), line 270 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line 281 (text), line 283 (text), line 285
  (text), line 287 (text), line 308 (text), line 310 (text), line 314 (text), line 318 (text), line 329 (text), line 331 (text), line 341
  (text), line 349 (text), line 353 (text), line 355 (text), line 357 (text), line 359 (text), line 364 (text), line 370 (text), line 373
  (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line 383 (text), line 385 (text), line 387 (text), line 389
  (text), line 390 (text), line 391 (text), line 392 (text), line 394 (text), line 395 (text), line 397 (text), line 399 (text), line 401
  (text), line 403 (text), line 405 (text), line 407 (text), line 409 (text), line 411 (text), line 413 (text), line 414 (text), line 415
  (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431
  (text), line 433 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 444 (text), line 447
  (text), line 449 (text), line 451 (text), line 452 (text), line 454 (text), line 455 (text), line 456 (text), line 457 (text), line 459
  (text), line 461 (text), line 463 (text), line 464 (text), line 465 (text), line 467 (text), line 468 (text), line 469 (text), line 471
  (text), line 472 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 483 (text), line 485 (text), line 487
  (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 504 (text), line 506 (text), line 510
  (text), line 512 (text), line 516 (text), line 518 (text), line 520 (text), line 522 (text), line 524 (text), line 526 (text), line 528
  (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text), line 540 (text), line 542 (text), line 544
  (text), line 546 (text), line 548 (text), line 550 (text), line 552 (text), line 554 (text), line 556 (text), line 558 (text), line 560
  (text), line 564 (text), line 566 (text), line 568 (text), line 570 (text), line 573 (text), line 575 (text), line 577 (text), line 579
  (text), line 581 (text), line 583 (text), line 585 (text), line 587 (text), line 589 (text), line 591 (text), line 593 (text), line 595
  (text), line 597 (text), line 599 (text), line 601 (text), line 603 (text), line 605 (text), line 607 (text), line 609 (text), line 611
  (text), line 613 (text), line 615 (text), line 617 (text), line 619 (text), line 621 (text), line 623 (text), line 625 (text), line 627
  (text), line 629 (text), line 631 (text), line 633 (text), line 635 (text), line 637 (text), line 639 (text), line 641 (text), line 643
  (text), line 645 (text), line 647 (text), line 649 (text), line 651 (text), line 653 (text), line 655 (text), line 657 (text), line 660
  (text), line 662 (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 675 (text), line 677
  (text), line 679 (text), line 681 (text), line 683 (text), line 685 (text), line 686 (text), line 688 (text), line 690 (text), line 692
  (text), line 694 (text), line 696 (text), line 697 (text), line 699 (text), line 701 (text), line 703 (text), line 705 (text), line 707
  (text), line 708 (text), line 710 (text), line 712 (text), line 714 (text), line 716 (text), line 717 (text), line 719 (text), line 721
  (text), line 723 (text), line 725 (text), line 727 (text), line 729 (text), line 731 (text), line 733 (text), line 735 (text), line 737
  (text), line 739 (text), line 741 (text), line 743 (text), line 745 (text), line 747 (text), line 749 (text), line 751 (text), line 753
  (text), line 755 (text), line 757 (text), line 759 (text), line 761 (text), line 763 (text), line 765 (text), line 767 (text), line 769
  (text), line 779 (text), line 780 (text), line 782 (text), line 783 (text), line 785 (text), line 787 (text), line 789 (text), line 791
  (text), line 796 (text), line 797 (text), line 799 (text), line 802 (text), line 804 (text), line 805 (text), line 806 (text), line 814
  (text), line 816 (text), line 818 (text), line 822 (text), line 830 (text), line 840 (text), line 848 (text), line 850 (text), line 852
  (text), line 854 (text), line 856 (text), line 858 (text), line 860 (text), line 862 (text), line 864 (text), line 866 (text), line 868
  (text), line 870 (text), line 872 (text), line 874 (text), line 876 (text), line 878 (text), line 880 (text), line 882 (text), line 884
  (text), line 886 (text), line 888 (text), line 890 (text), line 892 (text), line 894 (text), line 896 (text), line 898 (text), line 900
  (text), line 902 (text), line 904 (text), line 906 (text), line 908 (text), line 910 (text), line 912 (text), line 914 (text), line 916
  (text), line 918 (text), line 920 (text), line 922 (text), line 924 (text), line 938 (text), line 941 (text), line 943 (text), line 945
  (text), line 947 (text), line 953 (text), line 958 (text), line 963 (text), line 974 (text), line 983 (text), line 984 (text), line 988
  (text), line 989 (text), line 991 (text), line 992 (text), line 994 (text), line 995 (text), line 996 (text), line 1008 (text), line 1016
  (text), line 1027 (text), line 1030 (text), line 1056 (text), line 1057 (text), line 1058 (text), line 1059 (text), line 1060 (text), line
  1061 (text), line 1062 (text), line 1063 (text), line 1064 (text), line 1065 (text), line 1066 (text) and line 1067 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][165], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line
  72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text),
  line 90 (text), line 92 (text), line 94 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line
  106 (text), line 108 (text), line 110 (text), line 112 (text), line 115 (text), line 117 (text), line 120 (text), line 122 (text), line
  124 (text), line 128 (text), line 130 (text), line 132 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line
  146 (text), line 150 (text), line 152 (text), line 156 (text), line 158 (text), line 163 (text), line 165 (text), line 167 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 178 (text), line 181 (text), line 183 (text), line
  185 (text), line 187 (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line
  220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line
  236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line
  252 (text), line 255 (text), line 257 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line
  270 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line 280 (text), line 282 (text), line 284 (text), line
  286 (text), line 288 (text), line 290 (text), line 292 (text), line 295 (text), line 296 (text), line 299 (text), line 301 (text), line
  304 (text), line 306 (text), line 308 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line
  321 (text), line 323 (text), line 326 (text), line 328 (text), line 330 (text), line 332 (text), line 334 (text), line 335 (text), line
  337 (text), line 368 (text), line 371 (text), line 374 (text), line 379 (text), line 395 (text), line 397 (text), line 407 (text), line
  417 (text), line 421 (text), line 423 (text), line 425 (text), line 428 (text), line 433 (text), line 438 (text), line 463 (text), line
  465 (text), line 467 (text), line 471 (text), line 479 (text), line 488 (text), line 496 (text), line 498 (text), line 500 (text), line
  506 (text), line 512 (text), line 519 (text), line 530 (text), line 539 (text), line 541 (text), line 545 (text), line 547 (text), line
  549 (text), line 551 (text), line 553 (text), line 555 (text), line 557 (text), line 564 (text), line 567 (text), line 570 (text), line
  573 (text), line 576 (text), line 579 (text), line 582 (text), line 585 (text), line 588 (text), line 591 (text), line 594 (text), line
  597 (text), line 600 (text), line 603 (text), line 606 (text), line 609 (text), line 612 (text), line 615 (text), line 618 (text), line
  621 (text), line 624 (text), line 627 (text), line 630 (text), line 633 (text), line 636 (text), line 639 (text), line 642 (text), line
  645 (text), line 648 (text), line 651 (text), line 654 (text), line 657 (text), line 660 (text), line 663 (text), line 666 (text), line
  669 (text), line 672 (text), line 675 (text), line 678 (text), line 686 (text), line 688 (text), line 690 (text), line 692 (text), line
  694 (text), line 697 (text), line 700 (text), line 701 (text), line 704 (text), line 705 (text), line 707 (text), line 709 (text), line
  712 (text), line 714 (text), line 716 (text), line 717 (text), line 720 (text), line 722 (text), line 724 (text), line 726 (text), line
  728 (text), line 730 (text), line 732 (text), line 734 (text), line 735 (text), line 738 (text), line 740 (text), line 741 (text), line
  743 (text), line 746 (text), line 748 (text), line 750 (text), line 751 (text), line 753 (text), line 756 (text), line 758 (text), line
  759 (text), line 767 (text), line 769 (text), line 771 (text), line 773 (text), line 775 (text), line 778 (text), line 780 (text), line
  783 (text), line 786 (text), line 787 (text), line 791 (text), line 793 (text), line 796 (text), line 799 (text), line 801 (text), line
  803 (text), line 805 (text), line 807 (text), line 809 (text), line 811 (text), line 813 (text), line 816 (text), line 818 (text), line
  821 (text), line 823 (text), line 825 (text), line 827 (text), line 829 (text), line 831 (text), line 837 (text), line 839 (text), line
  841 (text), line 844 (text), line 846 (text), line 847 (text), line 849 (text), line 851 (text), line 854 (text), line 856 (text), line
  858 (text), line 860 (text), line 862 (text), line 864 (text), line 866 (text), line 868 (text), line 870 (text), line 872 (text), line
  873 (text), line 880 (text), line 882 (text), line 885 (text), line 886 (text), line 888 (text), line 890 (text), line 892 (text), line
  895 (text), line 896 (text), line 898 (text), line 900 (text), line 908 (text), line 910 (text), line 912 (text), line 914 (text), line
  915 (text), line 918 (text), line 920 (text), line 922 (text), line 923 (text), line 925 (text), line 927 (text), line 934 (text), line
  936 (text), line 939 (text), line 940 (text), line 943 (text), line 945 (text), line 947 (text), line 949 (text), line 951 (text), line
  953 (text), line 955 (text), line 961 (text), line 964 (text), line 966 (text), line 968 (text), line 970 (text), line 972 (text), line
  974 (text), line 976 (text), line 978 (text), line 980 (text), line 987 (text), line 989 (text), line 991 (text), line 994 (text), line
  995 (text), line 997 (text), line 999 (text), line 1002 (text), line 1004 (text), line 1011 (text), line 1012 (text), line 1014 (text),
  line 1017 (text), line 1019 (text), line 1021 (text), line 1023 (text), line 1025 (text), line 1031 (text), line 1034 (text), line 1036
  (text), line 1038 (text), line 1040 (text), line 1042 (text), line 1044 (text), line 1052 (text), line 1054 (text), line 1056 (text), line
  1058 (text), line 1060 (text), line 1062 (text), line 1064 (text), line 1081 (text), line 1114 (text), line 1121 (text), line 1123 (text),
  line 1126 (text), line 1129 (text), line 1130 (text), line 1137 (text), line 1140 (text), line 1142 (text), line 1144 (text), line 1146
  (text), line 1152 (text), line 1154 (text), line 1156 (text), line 1158 (text), line 1165 (text), line 1167 (text), line 1170 (text), line
  1171 (text), line 1181 (text), line 1182 (text), line 1185 (text), line 1192 (text), line 1194 (text), line 1196 (text), line 1198 (text),
  line 1204 (text), line 1207 (text), line 1210 (text), line 1220 (text), line 1221 (text), line 1223 (text), line 1232 (text), line 1233
  (text), line 1236 (text), line 1244 (text), line 1246 (text), line 1248 (text), line 1255 (text), line 1257 (text), line 1259 (text), line
  1266 (text), line 1268 (text), line 1275 (text), line 1277 (text), line 1284 (text), line 1286 (text), line 1292 (text), line 1295 (text),
  line 1310 (text), line 1317 (text), line 1324 (text), line 1331 (text), line 1337 (text), line 1345 (text), line 1369 (text), line 1370
  (text), line 1371 (text), line 1372 (text), line 1373 (text), line 1374 (text), line 1375 (text), line 1376 (text), line 1377 (text), line
  1378 (text), line 1379 (text) and line 1380 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][166], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 52 (text), line 52 (text), line 66 (text), line 67 (text), line
  68 (text), line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 74 (text), line 75 (text), line 76 (text)
  and line 77 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][167], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][168], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 36 (text), line 53 (text), line
  67 (text), line 68 (text), line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 74 (text), line 82 (text),
  line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 98 (text), line 100 (text), line 101 (text), line 103 (text), line
  105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line
  121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line
  137 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147 (text), line 149 (text), line 151 (text), line
  153 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  183 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 192 (text), line 194 (text), line 196 (text), line
  198 (text), line 200 (text), line 202 (text), line 204 (text), line 205 (text), line 206 (text), line 207 (text), line 208 (text), line
  210 (text), line 211 (text), line 213 (text), line 214 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line
  223 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line
  239 (text), line 241 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line
  253 (text), line 255 (text), line 257 (text), line 259 (text), line 261 (text), line 263 (text), line 265 (text), line 267 (text), line
  269 (text), line 271 (text), line 273 (text), line 275 (text), line 277 (text), line 279 (text), line 282 (text), line 284 (text), line
  286 (text), line 289 (text), line 310 (text), line 312 (text), line 316 (text), line 320 (text), line 331 (text), line 333 (text), line
  343 (text), line 351 (text), line 355 (text), line 357 (text), line 359 (text), line 361 (text), line 366 (text), line 372 (text), line
  375 (text), line 377 (text), line 379 (text), line 381 (text), line 383 (text), line 385 (text), line 387 (text), line 389 (text), line
  391 (text), line 392 (text), line 393 (text), line 394 (text), line 396 (text), line 397 (text), line 399 (text), line 401 (text), line
  403 (text), line 405 (text), line 407 (text), line 409 (text), line 411 (text), line 413 (text), line 415 (text), line 416 (text), line
  417 (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line
  433 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445 (text), line 446 (text), line
  449 (text), line 451 (text), line 453 (text), line 454 (text), line 456 (text), line 457 (text), line 458 (text), line 459 (text), line
  461 (text), line 463 (text), line 465 (text), line 466 (text), line 467 (text), line 469 (text), line 470 (text), line 471 (text), line
  473 (text), line 474 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 485 (text), line 487 (text), line
  489 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 503 (text), line 506 (text), line 508 (text), line
  512 (text), line 514 (text), line 518 (text), line 520 (text), line 522 (text), line 524 (text), line 526 (text), line 528 (text), line
  530 (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text), line 540 (text), line 542 (text), line 544 (text), line
  546 (text), line 548 (text), line 550 (text), line 552 (text), line 554 (text), line 556 (text), line 558 (text), line 560 (text), line
  562 (text), line 566 (text), line 568 (text), line 570 (text), line 572 (text), line 575 (text), line 577 (text), line 579 (text), line
  581 (text), line 583 (text), line 585 (text), line 587 (text), line 589 (text), line 591 (text), line 593 (text), line 595 (text), line
  597 (text), line 599 (text), line 601 (text), line 603 (text), line 605 (text), line 607 (text), line 609 (text), line 611 (text), line
  613 (text), line 615 (text), line 617 (text), line 619 (text), line 621 (text), line 623 (text), line 625 (text), line 627 (text), line
  629 (text), line 631 (text), line 633 (text), line 635 (text), line 637 (text), line 639 (text), line 641 (text), line 643 (text), line
  645 (text), line 647 (text), line 649 (text), line 651 (text), line 653 (text), line 655 (text), line 657 (text), line 659 (text), line
  662 (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 674 (text), line 677 (text), line
  679 (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 688 (text), line 690 (text), line 692 (text), line
  694 (text), line 696 (text), line 698 (text), line 699 (text), line 701 (text), line 703 (text), line 705 (text), line 707 (text), line
  709 (text), line 710 (text), line 712 (text), line 714 (text), line 716 (text), line 718 (text), line 719 (text), line 721 (text), line
  723 (text), line 725 (text), line 727 (text), line 729 (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line
  739 (text), line 741 (text), line 743 (text), line 745 (text), line 747 (text), line 749 (text), line 751 (text), line 753 (text), line
  755 (text), line 757 (text), line 759 (text), line 761 (text), line 763 (text), line 765 (text), line 767 (text), line 769 (text), line
  771 (text), line 781 (text), line 782 (text), line 784 (text), line 785 (text), line 788 (text), line 790 (text), line 792 (text), line
  794 (text), line 799 (text), line 800 (text), line 802 (text), line 805 (text), line 808 (text), line 809 (text), line 810 (text), line
  820 (text), line 822 (text), line 824 (text), line 828 (text), line 836 (text), line 846 (text), line 855 (text), line 857 (text), line
  859 (text), line 861 (text), line 863 (text), line 865 (text), line 867 (text), line 869 (text), line 871 (text), line 873 (text), line
  875 (text), line 877 (text), line 879 (text), line 881 (text), line 883 (text), line 885 (text), line 887 (text), line 889 (text), line
  891 (text), line 893 (text), line 895 (text), line 897 (text), line 899 (text), line 901 (text), line 903 (text), line 905 (text), line
  907 (text), line 909 (text), line 911 (text), line 913 (text), line 915 (text), line 917 (text), line 919 (text), line 921 (text), line
  923 (text), line 925 (text), line 927 (text), line 929 (text), line 931 (text), line 945 (text), line 948 (text), line 967 (text), line
  969 (text), line 971 (text), line 977 (text), line 982 (text), line 987 (text), line 998 (text), line 1008 (text), line 1009 (text), line
  1013 (text), line 1014 (text), line 1016 (text), line 1017 (text), line 1019 (text), line 1020 (text), line 1021 (text), line 1033 (text),
  line 1041 (text), line 1052 (text), line 1055 (text), line 1081 (text), line 1082 (text), line 1083 (text), line 1084 (text), line 1085
  (text), line 1086 (text), line 1087 (text), line 1088 (text), line 1089 (text), line 1090 (text), line 1091 (text) and line 1092 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][169], in the cell docs × markdown:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line
  73 (text), line 75 (text), line 77 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 109 (text), line 111 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 124 (text), line
  126 (text), line 130 (text), line 132 (text), line 134 (text), line 141 (text), line 143 (text), line 145 (text), line 147 (text), line
  148 (text), line 152 (text), line 154 (text), line 158 (text), line 160 (text), line 165 (text), line 167 (text), line 169 (text), line
  171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 180 (text), line 183 (text), line 185 (text), line
  187 (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line
  203 (text), line 205 (text), line 207 (text), line 209 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line
  222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line
  238 (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line
  254 (text), line 257 (text), line 259 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line
  272 (text), line 274 (text), line 276 (text), line 278 (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line
  288 (text), line 290 (text), line 292 (text), line 294 (text), line 297 (text), line 298 (text), line 301 (text), line 303 (text), line
  306 (text), line 308 (text), line 310 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text), line
  323 (text), line 325 (text), line 328 (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 337 (text), line
  339 (text), line 370 (text), line 373 (text), line 376 (text), line 381 (text), line 397 (text), line 399 (text), line 409 (text), line
  419 (text), line 423 (text), line 425 (text), line 427 (text), line 430 (text), line 435 (text), line 440 (text), line 467 (text), line
  469 (text), line 471 (text), line 475 (text), line 483 (text), line 492 (text), line 503 (text), line 505 (text), line 507 (text), line
  513 (text), line 519 (text), line 526 (text), line 537 (text), line 547 (text), line 549 (text), line 553 (text), line 555 (text), line
  557 (text), line 559 (text), line 561 (text), line 563 (text), line 565 (text), line 572 (text), line 575 (text), line 578 (text), line
  581 (text), line 584 (text), line 587 (text), line 590 (text), line 593 (text), line 596 (text), line 599 (text), line 602 (text), line
  605 (text), line 608 (text), line 611 (text), line 614 (text), line 617 (text), line 620 (text), line 623 (text), line 626 (text), line
  629 (text), line 632 (text), line 635 (text), line 638 (text), line 641 (text), line 644 (text), line 647 (text), line 650 (text), line
  653 (text), line 656 (text), line 659 (text), line 662 (text), line 665 (text), line 668 (text), line 671 (text), line 674 (text), line
  677 (text), line 680 (text), line 683 (text), line 686 (text), line 694 (text), line 696 (text), line 698 (text), line 700 (text), line
  702 (text), line 705 (text), line 708 (text), line 709 (text), line 712 (text), line 713 (text), line 715 (text), line 717 (text), line
  720 (text), line 722 (text), line 724 (text), line 725 (text), line 728 (text), line 730 (text), line 732 (text), line 734 (text), line
  736 (text), line 738 (text), line 740 (text), line 742 (text), line 743 (text), line 746 (text), line 748 (text), line 749 (text), line
  751 (text), line 754 (text), line 756 (text), line 758 (text), line 759 (text), line 761 (text), line 764 (text), line 766 (text), line
  767 (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 783 (text), line 786 (text), line 788 (text), line
  791 (text), line 794 (text), line 795 (text), line 799 (text), line 801 (text), line 804 (text), line 807 (text), line 809 (text), line
  811 (text), line 813 (text), line 815 (text), line 817 (text), line 819 (text), line 821 (text), line 824 (text), line 826 (text), line
  829 (text), line 831 (text), line 833 (text), line 835 (text), line 837 (text), line 839 (text), line 845 (text), line 847 (text), line
  849 (text), line 852 (text), line 854 (text), line 855 (text), line 857 (text), line 859 (text), line 862 (text), line 864 (text), line
  866 (text), line 868 (text), line 870 (text), line 872 (text), line 874 (text), line 876 (text), line 878 (text), line 880 (text), line
  881 (text), line 888 (text), line 890 (text), line 893 (text), line 894 (text), line 896 (text), line 898 (text), line 900 (text), line
  903 (text), line 904 (text), line 906 (text), line 908 (text), line 916 (text), line 918 (text), line 920 (text), line 922 (text), line
  923 (text), line 926 (text), line 928 (text), line 930 (text), line 931 (text), line 933 (text), line 935 (text), line 942 (text), line
  944 (text), line 947 (text), line 948 (text), line 951 (text), line 953 (text), line 955 (text), line 957 (text), line 959 (text), line
  961 (text), line 963 (text), line 969 (text), line 972 (text), line 974 (text), line 976 (text), line 978 (text), line 980 (text), line
  982 (text), line 984 (text), line 986 (text), line 988 (text), line 995 (text), line 997 (text), line 999 (text), line 1002 (text), line
  1003 (text), line 1005 (text), line 1007 (text), line 1010 (text), line 1012 (text), line 1019 (text), line 1020 (text), line 1022 (text),
  line 1025 (text), line 1027 (text), line 1029 (text), line 1031 (text), line 1033 (text), line 1039 (text), line 1042 (text), line 1044
  (text), line 1046 (text), line 1048 (text), line 1050 (text), line 1052 (text), line 1060 (text), line 1062 (text), line 1064 (text), line
  1066 (text), line 1068 (text), line 1070 (text), line 1072 (text), line 1108 (text), line 1141 (text), line 1148 (text), line 1150 (text),
  line 1153 (text), line 1156 (text), line 1157 (text), line 1164 (text), line 1167 (text), line 1169 (text), line 1171 (text), line 1173
  (text), line 1179 (text), line 1181 (text), line 1183 (text), line 1185 (text), line 1192 (text), line 1194 (text), line 1197 (text), line
  1198 (text), line 1208 (text), line 1209 (text), line 1212 (text), line 1219 (text), line 1221 (text), line 1223 (text), line 1225 (text),
  line 1231 (text), line 1234 (text), line 1237 (text), line 1247 (text), line 1249 (text), line 1251 (text), line 1260 (text), line 1261
  (text), line 1264 (text), line 1272 (text), line 1274 (text), line 1276 (text), line 1283 (text), line 1285 (text), line 1287 (text), line
  1296 (text), line 1303 (text), line 1305 (text), line 1312 (text), line 1314 (text), line 1321 (text), line 1323 (text), line 1329 (text),
  line 1332 (text), line 1348 (text), line 1355 (text), line 1362 (text), line 1368 (text), line 1376 (text), line 1400 (text), line 1401
  (text), line 1402 (text), line 1403 (text), line 1404 (text), line 1405 (text), line 1406 (text), line 1407 (text), line 1408 (text), line
  1409 (text), line 1410 (text) and line 1411 (text).
- [docs/explanation/automation/two-gates-check-the-layer-pins.md][170], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 15 (text), line 53 (text) and line 67 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][171], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 16 (text), line 55 (text) and line 56 (text).
- [docs/explanation/configuration/ask-by-name-get-the-cached-object.md][172], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 17 (text) and line 55 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at
  line 17 (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/configuration/callers-depend-on-one-config-module.md][173], in the cell docs × markdown: selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 16 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text) and line 51
  (text).
- [docs/explanation/configuration/one-gate-guards-the-read-path.md][174], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 17 (text), line 29 (text) and line 64 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 17
  (text), line 29 (text), line 61 (text), line 62 (text), line 62 (text), line 63 (text) and line 63 (text); selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 17 (text), line 29 (text), line 56 (text), line 56 (text), line 57 (text), line 58
  (text), line 59 (text) and line 60 (text).
- [docs/explanation/configuration/one-reader-one-cache-per-session.md][175], in the cell docs × markdown: selected by [ADR-CONF-LOADING][3]:
  the file cites it at line 14 (text), line 40 (text) and line 41 (text).
- [docs/explanation/configuration/three-caches-back-one-reader.md][176], in the cell docs × markdown: selected by [ADR-CONF-LOADING][3]: the
  file cites it at line 19 (text), line 53 (text), line 54 (text), line 55 (text) and line 56 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][177], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 56 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][178], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 62 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][179], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 17 (text) and line 60 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][180], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 16 (text) and line 52 (text).
- [docs/how-to/automation/manual-test-plan.md][181], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  56 (text) and line 62 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][182], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 17 (text) and line 69 (text).
- [docs/how-to/automation/manual-test-plan/configs.md][183], in the cell docs × markdown: selected by [ADR-CONF-LOADING][3]: the file cites
  it at line 37 (text) and line 56 (text).
- [docs/how-to/automation/manual-test-plan/test-harness.md][184], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 17 (text).
- [docs/how-to/getting-started/automation/add-a-module.md][185], in the cell docs × markdown: selected by [ADR-CONF-LOADING][3]: the file
  cites it at line 74 (text).
- [docs/how-to/getting-started/automation/run-tests-and-checks.md][186], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 33 (text).
- [docs/references/automation/catzc-base-docs.md][187], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 34 (text).
- [docs/references/automation/catzc-base-globs.md][188], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 44 (text).
- [docs/references/automation/catzc-base-languages.md][189], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 39 (text).
- [docs/references/automation/catzc-base-modulesystem.md][190], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 36 (text).
- [docs/references/automation/catzc-base-rootconfig.md][191], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 50 (text).

### Docs (43 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-Readme.ps1][192], in the cell automation × powershell: selected by [ADR-CONF-LOADING][3]: the file cites
  it at line 21 (header).
- [automation/Catzc.Base.Docs/Test-AdrRegistry.ps1][193], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1][194], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1][195], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][196], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 17 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][197], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 145 (text); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 222 (text); selected by [ADR-CONF-LOADING][3]: the file
  cites it at line 221 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][198], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 57 (text), line 57 (body comment) and line 57 (body comment).
- [automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1][199], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1][200], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 18 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1][201], in the cell automation × powershell: selected by [ADR-CONF-LOADING][3]:
  the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1][202], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1][203], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1][204], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1][205], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][206], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 3 (header) and line 42 (body comment); selected by [ADR-CONF-LOADING][3]: the file cites it at line 43 (text).
- [automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1][207], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1][208], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1][209], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1][210], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (header), line 22 (text), line 23 (text) and line 27 (text).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1][211], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1][212], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1][213], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1][214], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1][215], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1][216], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1][217], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header) and line 17 (text).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1][218], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1][219], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1][220], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header), line 45 (text), line 104 (text) and line 115 (text).
- [automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1][221], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][222], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 47 (body comment), line 82 (body comment), line 83 (body comment) and line 96 (text).
- [automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1][223], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml][224], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml][225], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 1 (header), line 8 (text) and line 16 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][226], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1][227], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1][228], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1][229], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header) and line 16 (text).
- [automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1][230], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header) and line 11 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][231], in the cell automation × csharp: selected by [ADR-CONF-LOADING][3]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][232], in the cell automation × csharp: selected by [ADR-CONF-LOADING][3]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/DocsConfig.cs][233], in the cell automation × csharp: selected by [ADR-CONF-LOADING][3]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][234], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 40 (body comment) (a passing mention only).

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][235], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][236], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][237], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][238], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][239], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][240], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][241], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][242], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][243], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][244], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][245], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][246], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][247], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][248], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][249], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][250], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][251], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/go/test-artifacts.md][252], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][253], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][254], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][255], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][256], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][257], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][258], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][259], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][260], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/protected-globs.md][261], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][262], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][263], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][264], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][265], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][266], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][267], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][1], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][268], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][269], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][270], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][271], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][272], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### Az.Templates (30 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1][273], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1][274], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 9 (header) and line 14 (header).
- [automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1][275], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 23 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][276], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 8 (header), line 10 (header) and line 13 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1][277], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 18 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1][278], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1][279], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment), line 5 (body comment) and line 36 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1][280], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment), line 4 (body comment), line 10 (body comment) and line 39 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1][281], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1][282], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1][283], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (body comment), line 5 (body comment), line 9 (body comment) and line 39 (body comment) (a passing mention
  only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1][284], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 34 (body comment), line 124 (body comment) and line 176 (body comment) (a passing mention
  only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1][285], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 46 (body comment), line 46 (body comment) and line 98 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1][286], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (body comment), line 6 (body comment), line 11 (body comment) and line 51 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][287], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 9 (header), line 12 (header), line 15 (header), line 20 (header) and line 25 (body comment).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1][288], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1][289], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1][290], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1][291], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1][292], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1][293], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment) and line 5 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1][294], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment), line 4 (body comment), line 42 (body comment) and line 42 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1][295], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1][296], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment), line 4 (body comment), line 57 (body comment) and line 57 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1][297], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1][298], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][299], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1][300], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 43 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml][301], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][302], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (body comment) (a passing mention only).

### ModuleSystem (20 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][303], in the cell automation × powershell: selected by [ADR-CONF-LOADING][3]: the
  file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][304], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 34 (body comment) (a passing mention only).
- [automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1][305], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][306], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][307], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 15 (header).
- [automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1][308], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1][309], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1][310], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/configs/artifacts.yml][311], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1][312], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 13 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1][313], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1][314], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1][315], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1][316], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header) and line 92 (body comment).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1][317], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1][318], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header), line 31 (text), line 37 (text) and line 47 (text).
- [automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1][319], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1][320], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1][321], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header), line 19 (text) and line 31 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][322], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 3 (header).

### Globs (14 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][323], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 14 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][324], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][325], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 18 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][326], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][327], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1][328], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][329], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 16 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][330], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1][331], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header), line 19 (text), line 30 (text) and line 42 (text).
- [automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1][332], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header), line 4 (header), line 18 (text), line 25 (text) and line 36 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1][333], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][334], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header), line 5 (header), line 29 (text), line 37 (text) and line 50 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1][335], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][336], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 32 (body comment) and line 50 (body comment) (a passing mention only).

### Languages (13 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][337], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 47 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/New-PythonProject.ps1][338], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][2]:
  the file cites it at line 41 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1][339], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1][340], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][341], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1][342], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1][343], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1][344], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1][345], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 17 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1][346], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][347], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][348], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][349], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 9 (header).

### Azure (11 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/Test-AzureNetworkPlan.ps1][350], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 5 (header).
- [automation/Catzc.Azure/configs/identity-tokens.yml][351], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 3 (header).
- [automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1][352], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1][353], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1][354], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1][355], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1][356], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1][357], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1][358], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 4 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][359], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1][360], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 6 (body comment) and line 7 (body comment) (a passing mention only).

### Execution (11 lit files)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Invoke-Executable.ps1][361], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 107 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1][362], in the cell automation × powershell: selected by [ADR-CONF-LOADING][3]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1][363], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1][364], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1][365], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 81 (text) and line 81 (body comment).
- [automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1][366], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1][367], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1][368], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1][369], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1][370], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1][371], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment), line 13 (body comment) and line 15 (body comment) (a passing mention
  only).

### Tool.Core (11 lit files)

The group holds the files of automation/Catzc.Tooling.Core; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1][372], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 13 (header).
- [automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1][373], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1][374], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1][375], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 81 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1][376], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (body comment) and line 52 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1][377], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1][378], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1][379], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (text).
- [automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1][380], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 35 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1][381], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 82 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1][382], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment) (a passing mention only).

### Maps (9 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][383], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][384], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][385], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][386], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][387], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][388], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header), line 7 (header), line 45 (text), line 74 (text), line 80 (text) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][389], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header), line 7 (header), line 53 (text), line 104 (text), line 111 (text) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][390], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][391], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).

### RootConfig (9 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][392], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][393], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][394], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 120 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1][395], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 138 (body comment) and line 228 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1][396], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1][397], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1][398], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][399], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][400], in the cell automation × csharp: selected by [ADR-CONF-LOADING][3]: the
  file cites it at line 5 (header).

### Contracts (7 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Test-Contracts.ps1][401], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1][402], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1][403], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1][404], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1][405], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1][406], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1][407], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header), line 7 (header), line 35 (text), line 55 (body comment), line 79 (text) and line
  187 (body comment).

### Tool.Provisioning (7 lit files)

The group holds the files of automation/Catzc.Tooling.Provisioning; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1][408], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 45 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1][409], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1][410], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1][411], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1][412], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1][413], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1][414], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 3 (header).

### Config (5 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/Get-ConfigValue.ps1][415], in the cell automation × powershell: selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 17 (header), line 20 (header) and line 23 (header); selected by [ADR-CONF-LOADING][3]: the file cites it at line 8
  (header) and line 14 (header).
- [automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1][416], in the cell automation × powershell: selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 11 (header), line 13 (header) and line 18 (header).
- [automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1][417], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 8 (body comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1][418], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 4 (body comment), line 15 (body comment), line 18 (body comment) and line 133 (body comment) (a passing mention
  only).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][419], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 119 (body comment) (a passing mention only); selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 40
  (text) and line 69 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 16 (body comment) (a passing mention only).

### Reports (5 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/Write-QualityGateReport.ps1][420], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/configs/reports.yml][421], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 2 (header).
- [automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1][422], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header), line 4 (header), line 14 (text), line 24 (text), line 32 (text) and line 42
  (text).
- [automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1][423], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (text), line 10 (text) and line 17 (text).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][424], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 4 (header).

### TypesSystem (5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1][425], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][426], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1][427], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][428], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1][429], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).

### .internal (4 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/tests/Import-AllModules.Tests.ps1][430], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 200 (body comment) (a passing mention only).
- [automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1][431], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 1 (text) and line 80 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][432], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 5 (header).
- [automation/.internal/tests/Test-FolderConventions.Tests.ps1][433], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 2 (header).

### Az.DevOps (4 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][434], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 9 (header).
- [automation/Catzc.Azure.DevOps/configs/identity-tokens.yml][435], in the cell automation × yaml: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1][436], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 207 (body comment) (a passing mention only).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][437], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 44 (text) and line 53 (text).

### Tool.Inspiration (4 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1][438], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1][439], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][440], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1][441], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][442], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TEST][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 2 (header)
  and `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header).
- [.gitignore][443], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TEST][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 2 (header) and
  `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header).
- [importer.ps1][444], in the cell Root files × powershell: selected by [ADR-AUTO-TEST][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/tests/Import-AllModules.Tests.ps1` line 200 (body comment),
  `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 1 (text), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 80
  (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 5 (header) and
  `automation/.internal/tests/Test-FolderConventions.Tests.ps1` line 2 (header).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][445], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 50 (text).
- [.claude/agents/catzc-worker.md][446], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 48
  (text).
- [.claude/agents/test-optimization.md][447], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (text), line 21 (text), line 21 (text), line 21 (text), line 22 (text), line 23 (text), line 52 (text), line 57 (text), line 58 (text),
  line 62 (text), line 62 (text), line 67 (text) and line 75 (text).

### ConfigExtensions (3 lit files)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][448], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1][449], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1][450], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).

### Exporter (3 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1][451], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1][452], in the cell automation × powershell: selected by [ADR-AUTO-TEST][1]:
  the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1][453], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 6 (body comment) and line 8 (body comment) (a passing mention only).

### Tool.KeyHandler (3 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1][454], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1][455], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1][456], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header) and line 4 (text).

### adr/conf (3 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][2], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: an ADR file of
  the `configuration` ADR domain, the ADR domain of that code; selected by [ADR-CONF-LOADING][3]: an ADR file of the `configuration` ADR
  domain, the ADR domain of that code.
- [docs/adr/configuration/dora-explains.md][457], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: an ADR file of the
  `configuration` ADR domain, the ADR domain of that code; selected by [ADR-CONF-LOADING][3]: an ADR file of the `configuration` ADR domain,
  the ADR domain of that code.
- [docs/adr/configuration/module-config-loading.md][3], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][2]: an ADR file of
  the `configuration` ADR domain, the ADR domain of that code; selected by [ADR-CONF-LOADING][3]: an ADR file of the `configuration` ADR
  domain, the ADR domain of that code.

### Git (2 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1][458], in the cell automation × powershell: selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][459], in the cell automation × csharp: selected by [ADR-CONF-LOADING][3]: the file
  cites it at line 5 (header).

### Objects (2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][460], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][461], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).

### Repository (2 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1][462], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1][463], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).

### Tool.Toolchain (2 lit files)

The group holds the files of automation/Catzc.Tooling.Toolchain; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1][464], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1][465], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][466], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 329 (text), line 367
  (text), line 378 (text), line 411 (text), line 446 (text), line 464 (text), line 476 (text), line 490 (text), line 512 (text), line 526
  (text), line 537 (text) and line 557 (text).
- [docs/adr/index.md][467], in the cell docs × markdown: selected by [ADR-AUTO-TEST][1]: the file cites it at line 133 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 207 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 206 (text).

### .scriptanalyzer (1 lit file)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1][468], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 154 (text).

### Az.DevOps.BuildValidation (1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1][469], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][1]: the file cites it at line 13 (body comment) (a passing mention only).

### Engines (1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml][470], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).

### Environment (1 lit file)

The group holds the files of automation/Catzc.Base.Environment; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1][471], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][1]: the file cites it at line 6 (text).

### Files (1 lit file)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1][472], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment) (a passing mention only).

### Timeouts (1 lit file)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TestTiers.cs][473], in the cell automation × csharp: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 2 (header) and line 3 (header).

### Tool.Python (1 lit file)

The group holds the files of automation/Catzc.Tooling.Python; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1][474], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 3 (body comment) (a passing mention only).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-infrastructure.yaml][475], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  68 (body comment) (a passing mention only).

## Keywords

- [world map][476]
- [track][477]
- [file language][478]
- [cell][479]
- [lit cell][480]
- [root file][481]
- [unlisted file][482]
- [.claude][483]: a track
- [automation][483]: a track
- [docs][483]: a track
- [pipelines][483]: a track
- [csharp][484]: a file language
- [markdown][484]: a file language
- [pipeline-yaml][484]: a file language
- [powershell][484]: a file language
- [yaml][484]: a file language

Terms the cited ADRs define:

- [all tests][485], defined by [ADR-AUTO-TEST#36][486]
- [build verification test][487], defined by [ADR-AUTO-TEST#24][488]
- [category][489], defined by [ADR-AUTO-TEST#1][490]
- [phase][491], defined by [ADR-AUTO-TEST#26][492]
- [quality gate][493], defined by [ADR-AUTO-TEST#35][494]
- [test][495], defined by [ADR-AUTO-TEST#42][496]
- [test file][497], defined by [ADR-AUTO-TEST#43][498]
- [test run][499], defined by [ADR-AUTO-TEST#34][500]
- [test suite][501], defined by [ADR-AUTO-TEST#37][502]
- [testing in production][503], defined by [ADR-AUTO-TEST#41][504]
- [tier][505], defined by [ADR-AUTO-TEST#13][506]
- [vertical test][507], defined by [ADR-AUTO-TEST#38][508]

[1]: ../../adr/automation/test-automation.md
[2]: ../../adr/configuration/config-value-addressing.md
[3]: ../../adr/configuration/module-config-loading.md
[4]: ../../../automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
[5]: ../../../automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1
[6]: ../../../automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
[7]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[8]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[9]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[10]: ../../../automation/Catzc.Base.QualityGates/Test-Change.ps1
[11]: ../../../automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
[12]: ../../../automation/Catzc.Base.QualityGates/Test-Formatting.ps1
[13]: ../../../automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
[14]: ../../../automation/Catzc.Base.QualityGates/Test-Links.ps1
[15]: ../../../automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
[16]: ../../../automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
[17]: ../../../automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
[18]: ../../../automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
[19]: ../../../automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
[22]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[23]: ../../../automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1
[24]: ../../../automation/Catzc.Base.QualityGates/Test-Spelling.ps1
[25]: ../../../automation/Catzc.Base.QualityGates/Test-Terminology.ps1
[26]: ../../../automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
[27]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[28]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[29]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[30]: ../../../automation/Catzc.Base.QualityGates/configs/test-policy.yml
[31]: ../../../automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
[32]: ../../../automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
[33]: ../../../automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
[34]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[35]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[36]: ../../../automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
[37]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
[38]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
[39]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
[40]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
[41]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
[42]: ../../../automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
[43]: ../../../automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
[44]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
[45]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[46]: ../../../automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
[47]: ../../../automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
[48]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
[49]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
[50]: ../../../automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
[51]: ../../../automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
[52]: ../../../automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
[53]: ../../../automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
[54]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
[55]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
[56]: ../../../automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
[57]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
[58]: ../../../automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
[59]: ../../../automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
[60]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
[61]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
[62]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
[63]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
[64]: ../../../automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
[65]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
[66]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
[67]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
[68]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
[69]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
[70]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
[71]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
[72]: ../../../automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
[73]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
[74]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
[75]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
[76]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
[77]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
[78]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[79]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
[80]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
[81]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
[82]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
[83]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
[84]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
[85]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
[86]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
[87]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
[88]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
[89]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
[90]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
[91]: ../../../automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
[92]: ../../../automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
[93]: ../../../automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
[94]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
[95]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
[96]: ../../../automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
[97]: ../../../automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
[98]: ../../../automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
[99]: ../../../automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
[100]: ../../../automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
[101]: ../../../automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
[102]: ../../../automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
[103]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
[104]: ../../../automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
[105]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
[106]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
[107]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
[108]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
[109]: ../../../automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
[110]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
[111]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
[112]: ../../../automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
[113]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
[114]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
[115]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
[116]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
[117]: ../../../automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
[118]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
[119]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
[120]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[121]: ../../../automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
[122]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
[123]: ../../../automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
[124]: ../../../automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
[125]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
[126]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
[127]: ../../../automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
[128]: ../../../automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
[129]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[130]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[131]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[132]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[133]: adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
[134]: adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
[135]: adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md
[136]: adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
[137]: adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md
[138]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
[139]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.drawio.md
[140]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
[141]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.tree.md
[142]: adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
[143]: adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md
[144]: adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
[145]: adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md
[146]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[147]: adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md
[148]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[149]: adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md
[150]: adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
[151]: adr-conf-loading--one-reader-one-cache-per-session--meta.drawio.md
[152]: adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
[153]: adr-conf-loading--one-reader-one-cache-per-session--meta.tree.md
[154]: adr-conf-loading--three-caches-back-one-reader--implementation.chain.md
[155]: adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md
[156]: adr-conf-loading--three-caches-back-one-reader--implementation.grid.md
[157]: adr-conf-loading--three-caches-back-one-reader--implementation.tree.md
[158]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[159]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[160]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[161]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[162]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[163]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[164]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[165]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[166]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[167]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[168]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[169]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[170]: ../../explanation/automation/two-gates-check-the-layer-pins.md
[171]: ../../explanation/automation/what-gates-each-bundle-stage.md
[172]: ../../explanation/configuration/ask-by-name-get-the-cached-object.md
[173]: ../../explanation/configuration/callers-depend-on-one-config-module.md
[174]: ../../explanation/configuration/one-gate-guards-the-read-path.md
[175]: ../../explanation/configuration/one-reader-one-cache-per-session.md
[176]: ../../explanation/configuration/three-caches-back-one-reader.md
[177]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[178]: ../../explanation/design/which-rung-gates-exist-in-code.md
[179]: ../../explanation/flow/gates-check-source-and-trigger.md
[180]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[181]: ../../how-to/automation/manual-test-plan.md
[182]: ../../how-to/automation/manual-test-plan/azure.md
[183]: ../../how-to/automation/manual-test-plan/configs.md
[184]: ../../how-to/automation/manual-test-plan/test-harness.md
[185]: ../../how-to/getting-started/automation/add-a-module.md
[186]: ../../how-to/getting-started/automation/run-tests-and-checks.md
[187]: ../../references/automation/catzc-base-docs.md
[188]: ../../references/automation/catzc-base-globs.md
[189]: ../../references/automation/catzc-base-languages.md
[190]: ../../references/automation/catzc-base-modulesystem.md
[191]: ../../references/automation/catzc-base-rootconfig.md
[192]: ../../../automation/Catzc.Base.Docs/Build-Readme.ps1
[193]: ../../../automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
[194]: ../../../automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
[195]: ../../../automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
[196]: ../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[197]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[198]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[199]: ../../../automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1
[200]: ../../../automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
[201]: ../../../automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1
[202]: ../../../automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
[203]: ../../../automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
[204]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
[205]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
[206]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[207]: ../../../automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
[208]: ../../../automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
[209]: ../../../automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
[210]: ../../../automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
[211]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
[212]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
[213]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
[214]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
[215]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
[216]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
[217]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
[218]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
[219]: ../../../automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
[220]: ../../../automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
[221]: ../../../automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
[222]: ../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[223]: ../../../automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
[224]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
[225]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
[226]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[227]: ../../../automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
[228]: ../../../automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
[229]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
[230]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
[231]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[232]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[233]: ../../../automation/Catzc.Base.Docs/types/DocsConfig.cs
[234]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[235]: ../../adr/automation/BCL/index.md
[236]: ../../adr/automation/BCL/native-csharp-types.md
[237]: ../../adr/automation/avoid-deep-nesting.md
[238]: ../../adr/automation/bash/bash-test-artifacts.md
[239]: ../../adr/automation/caching.md
[240]: ../../adr/automation/console-output-matters.md
[241]: ../../adr/automation/controlling-module-dependencies.md
[242]: ../../adr/automation/controlling-systemwide-deps.md
[243]: ../../adr/automation/cross-platform.md
[244]: ../../adr/automation/devbox-pipeline-parity.md
[245]: ../../adr/automation/dora-explains.md
[246]: ../../adr/automation/dry-run.md
[247]: ../../adr/automation/effective-in-enterprises.md
[248]: ../../adr/automation/environment-variables.md
[249]: ../../adr/automation/execution-engines.md
[250]: ../../adr/automation/fail-fast-with-asserts.md
[251]: ../../adr/automation/go/index.md
[252]: ../../adr/automation/go/test-artifacts.md
[253]: ../../adr/automation/idempotent-state-functions.md
[254]: ../../adr/automation/internal-asset-dependencies.md
[255]: ../../adr/automation/log-before-invoke.md
[256]: ../../adr/automation/managed-guids.md
[257]: ../../adr/automation/never-depend-on-pwd.md
[258]: ../../adr/automation/open-closed-architecture.md
[259]: ../../adr/automation/path-representation.md
[260]: ../../adr/automation/platform-bundle.md
[261]: ../../adr/automation/protected-globs.md
[262]: ../../adr/automation/python/index.md
[263]: ../../adr/automation/python/python-test-artifacts.md
[264]: ../../adr/automation/retry-as-last-resort.md
[265]: ../../adr/automation/sensible-defaults.md
[266]: ../../adr/automation/single-responsibility-functions.md
[267]: ../../adr/automation/spell-out-names.md
[268]: ../../adr/automation/tool-removal-lifecycle.md
[269]: ../../adr/automation/tracked-files-from-the-index.md
[270]: ../../adr/automation/use-proper-package-managers.md
[271]: ../../adr/automation/uv-python-handler.md
[272]: ../../adr/automation/zero-ceremony-poka-yoke.md
[273]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
[274]: ../../../automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
[275]: ../../../automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
[276]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[277]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
[278]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
[279]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
[280]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
[281]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
[282]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
[283]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
[284]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
[285]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
[286]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
[287]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[288]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
[289]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
[290]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
[291]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
[292]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
[293]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
[294]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
[295]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
[296]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
[297]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
[298]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
[299]: ../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[300]: ../../../automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
[301]: ../../../automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
[302]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[303]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[304]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[305]: ../../../automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
[306]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[307]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[308]: ../../../automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
[309]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
[310]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
[311]: ../../../automation/Catzc.Base.ModuleSystem/configs/artifacts.yml
[312]: ../../../automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
[313]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
[314]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
[315]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
[316]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
[317]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
[318]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
[319]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
[320]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
[321]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
[322]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[323]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[324]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[325]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[326]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[327]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[328]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
[329]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[330]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[331]: ../../../automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
[332]: ../../../automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
[333]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
[334]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[335]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
[336]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[337]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[338]: ../../../automation/Catzc.Base.Languages/New-PythonProject.ps1
[339]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
[340]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
[341]: ../../../automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[342]: ../../../automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
[343]: ../../../automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
[344]: ../../../automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
[345]: ../../../automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
[346]: ../../../automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
[347]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[348]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[349]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[350]: ../../../automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
[351]: ../../../automation/Catzc.Azure/configs/identity-tokens.yml
[352]: ../../../automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
[353]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
[354]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
[355]: ../../../automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
[356]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
[357]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
[358]: ../../../automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
[359]: ../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[360]: ../../../automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
[361]: ../../../automation/Catzc.Base.Execution/Invoke-Executable.ps1
[362]: ../../../automation/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
[363]: ../../../automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
[364]: ../../../automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
[365]: ../../../automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
[366]: ../../../automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
[367]: ../../../automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
[368]: ../../../automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
[369]: ../../../automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
[370]: ../../../automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
[371]: ../../../automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
[372]: ../../../automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
[373]: ../../../automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
[374]: ../../../automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
[375]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
[376]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
[377]: ../../../automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
[378]: ../../../automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
[379]: ../../../automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
[380]: ../../../automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
[381]: ../../../automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
[382]: ../../../automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
[383]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[384]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[385]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[386]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[387]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[388]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[389]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[390]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[391]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[392]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[393]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[394]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[395]: ../../../automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
[396]: ../../../automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
[397]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
[398]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
[399]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[400]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[401]: ../../../automation/Catzc.Base.Contracts/Test-Contracts.ps1
[402]: ../../../automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
[403]: ../../../automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
[404]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
[405]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
[406]: ../../../automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
[407]: ../../../automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
[408]: ../../../automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
[409]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
[410]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
[411]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
[412]: ../../../automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
[413]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
[414]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
[415]: ../../../automation/Catzc.Base.Config/Get-ConfigValue.ps1
[416]: ../../../automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
[417]: ../../../automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
[418]: ../../../automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[419]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[420]: ../../../automation/Catzc.Base.Reports/Write-QualityGateReport.ps1
[421]: ../../../automation/Catzc.Base.Reports/configs/reports.yml
[422]: ../../../automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
[423]: ../../../automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
[424]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[425]: ../../../automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
[426]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[427]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
[428]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[429]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
[430]: ../../../automation/.internal/tests/Import-AllModules.Tests.ps1
[431]: ../../../automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
[432]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[433]: ../../../automation/.internal/tests/Test-FolderConventions.Tests.ps1
[434]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[435]: ../../../automation/Catzc.Azure.DevOps/configs/identity-tokens.yml
[436]: ../../../automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
[437]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[438]: ../../../automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
[439]: ../../../automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
[440]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[441]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
[442]: ../../../.gitattributes
[443]: ../../../.gitignore
[444]: ../../../importer.ps1
[445]: ../../../.claude/CLAUDE.md
[446]: ../../../.claude/agents/catzc-worker.md
[447]: ../../../.claude/agents/test-optimization.md
[448]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[449]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
[450]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
[451]: ../../../automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
[452]: ../../../automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
[453]: ../../../automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
[454]: ../../../automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
[455]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
[456]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
[457]: ../../adr/configuration/dora-explains.md
[458]: ../../../automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
[459]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[460]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[461]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[462]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
[463]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
[464]: ../../../automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
[465]: ../../../automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
[466]: ../../adr/glossary.md
[467]: ../../adr/index.md
[468]: ../../../automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1
[469]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
[470]: ../../../automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml
[471]: ../../../automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
[472]: ../../../automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
[473]: ../../../automation/Catzc.Base.Timeouts/types/TestTiers.cs
[474]: ../../../automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1
[475]: ../../../pipelines/ci-infrastructure.yaml
[476]: ../../adr/glossary.md#world-map
[477]: ../../adr/glossary.md#track
[478]: ../../adr/glossary.md#file-language
[479]: ../../adr/glossary.md#cell
[480]: ../../adr/glossary.md#lit-cell
[481]: ../../adr/glossary.md#root-file
[482]: ../../adr/glossary.md#unlisted-file
[483]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[484]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[485]: ../../adr/glossary.md#all-tests
[486]: ../../adr/automation/test-automation.md#rule-adr-auto-test36
[487]: ../../adr/glossary.md#build-verification-test
[488]: ../../adr/automation/test-automation.md#rule-adr-auto-test24
[489]: ../../adr/glossary.md#category
[490]: ../../adr/automation/test-automation.md#rule-adr-auto-test1
[491]: ../../adr/glossary.md#phase
[492]: ../../adr/automation/test-automation.md#rule-adr-auto-test26
[493]: ../../adr/glossary.md#quality-gate
[494]: ../../adr/automation/test-automation.md#rule-adr-auto-test35
[495]: ../../adr/glossary.md#test
[496]: ../../adr/automation/test-automation.md#rule-adr-auto-test42
[497]: ../../adr/glossary.md#test-file
[498]: ../../adr/automation/test-automation.md#rule-adr-auto-test43
[499]: ../../adr/glossary.md#test-run
[500]: ../../adr/automation/test-automation.md#rule-adr-auto-test34
[501]: ../../adr/glossary.md#test-suite
[502]: ../../adr/automation/test-automation.md#rule-adr-auto-test37
[503]: ../../adr/glossary.md#testing-in-production
[504]: ../../adr/automation/test-automation.md#rule-adr-auto-test41
[505]: ../../adr/glossary.md#tier
[506]: ../../adr/automation/test-automation.md#rule-adr-auto-test13
[507]: ../../adr/glossary.md#vertical-test
[508]: ../../adr/automation/test-automation.md#rule-adr-auto-test38

# docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md

`Tree minimap: adr-auto-bundle--what-gates-each-bundle-stage--governance`

![Tree minimap of adr-auto-bundle--what-gates-each-bundle-stage--governance](adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.png)

The tree minimap of the slide `adr-auto-bundle--what-gates-each-bundle-stage--governance` (governance lens). The slide supports
[ADR-AUTO-ASSETDEP][1], [ADR-AUTO-BUNDLE][2], [ADR-AUTO-TEST][3] and [ADR-DSGN-RUNMODE][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 483 files in 42 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- QualityGates (automation/Catzc.Base.QualityGates): 139 lit files
- Docs (automation/Catzc.Base.Docs): 52 lit files
- adr/auto (docs/adr/automation): 40 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 29 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 25 lit files
- Globs (automation/Catzc.Base.Globs): 15 lit files
- Exporter (automation/Catzc.Base.Exporter): 13 lit files
- Azure (automation/Catzc.Azure): 11 lit files
- Languages (automation/Catzc.Base.Languages): 11 lit files
- Tool.Core (automation/Catzc.Tooling.Core): 11 lit files
- docs (docs/ outside docs/adr/): 11 lit files
- Execution (automation/Catzc.Base.Execution): 10 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 10 lit files
- Maps (automation/Catzc.Base.Maps): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Contracts (automation/Catzc.Base.Contracts): 8 lit files
- Tool.Provisioning (automation/Catzc.Tooling.Provisioning): 7 lit files
- .internal (automation/.internal): 6 lit files
- Config (automation/Catzc.Base.Config): 5 lit files
- Reports (automation/Catzc.Base.Reports): 5 lit files
- Repository (automation/Catzc.Base.Repository): 5 lit files
- .claude: 4 lit files
- Az.DevOps (automation/Catzc.Azure.DevOps): 4 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 4 lit files
- Tool.Toolchain (automation/Catzc.Tooling.Toolchain): 4 lit files
- Root files: 3 lit files
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 3 lit files
- Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler): 3 lit files
- .scriptanalyzer (automation/.scriptanalyzer): 2 lit files
- Objects (automation/Catzc.Base.Objects): 2 lit files
- Overlay (automation/Catzc.Base.Overlay): 2 lit files
- Vendor (automation/Catzc.Base.Vendor): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .github: 1 lit file
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Environment (automation/Catzc.Base.Environment): 1 lit file
- Files (automation/Catzc.Base.Files): 1 lit file
- Timeouts (automation/Catzc.Base.Timeouts): 1 lit file
- Tool.Python (automation/Catzc.Tooling.Python): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### QualityGates (139 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 6 (header) and line 8 (header).
- [automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 13 (header), line 24 (header), line 28 (header), line 34 (header) and line 35 (header).
- [automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1][7], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][8], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 13 (header), line 19 (header), line 21 (header), line 71 (header), line 87 (header), line 172 (body comment) and line 184
  (body comment).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][9], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (header) and line 7 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][10], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (header), line 16 (header) and line 36 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/Test-Change.ps1][11], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1][12], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/Test-Formatting.ps1][13], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1][14], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/Test-Links.ps1][15], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 19 (header).
- [automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1][16], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 6 (header) and line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1][17], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1][18], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header) and line 10 (header).
- [automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1][19], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1][20], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1][21], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1][22], in the cell automation × powershell: selected by [ADR-AUTO-ASSETDEP][1]:
  the file cites it at line 57 (body comment) (a passing mention only); selected by [ADR-AUTO-TEST][3]: the file cites it at line 16
  (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][23], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1][24], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/Test-Spelling.ps1][25], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/Test-Terminology.ps1][26], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 23 (header).
- [automation/Catzc.Base.QualityGates/Test-TestTitles.ps1][27], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header) and line 10 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][28], in the cell automation × yaml: selected by [ADR-AUTO-ASSETDEP][1]:
  the file cites it at line 29 (body comment) (a passing mention only); selected by [ADR-AUTO-TEST][3]: the file cites it at line 27 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][29], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 9 (text), line 25 (text), line 34 (text), line 44 (text), line 71 (text), line 86 (text), line 109 (text), line 121
  (text), line 131 (text), line 141 (text), line 156 (text) and line 170 (text).
- [automation/Catzc.Base.QualityGates/configs/source-conventions.yml][30], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][31], in the cell automation × yaml: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 594 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 26 (header); selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 596 (text).
- [automation/Catzc.Base.QualityGates/configs/test-policy.yml][32], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 1 (header).
- [automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1][33], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1][34], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header) and line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1][35], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][36], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][37], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 24 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1][38], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1][39], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1][40], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 59 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1][41], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1][42], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1][43], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 10 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1][44], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1][45], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 16 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1][46], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1][47], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header), line 16 (header) and line 185 (body comment).
- [automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1][48], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1][49], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 15 (header); selected by [ADR-AUTO-TEST][3]: the file cites it at line 11 (header), line
  39 (header) and line 137 (body comment).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1][50], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header) and line 20 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][51], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1][52], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1][53], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 20 (header) and line 24 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1][54], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1][55], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1][56], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1][57], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 14 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1][58], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1][59], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1][60], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 203 (body comment) and line 207 (text); selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 1 (header), line 3 (header) and line 231 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1][61], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1][62], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 40 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1][63], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1][64], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text) and line 23 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1][65], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1][66], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1][67], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1][68], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1][69], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1][70], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1][71], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1][72], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1][73], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1][74], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1][75], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 10 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1][76], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 16 (text), line 28 (text), line 40 (text), line 52 (text), line 65 (text),
  line 75 (text) and line 88 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1][77], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1][78], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1][79], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1][80], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 62 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1][81], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 14 (body comment) and line 16 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1][82], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1][83], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 23 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1][85], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][87], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1][88], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1][89], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1][90], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (text), line 2 (body comment), line 100 (text) and line 104 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1][91], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1][92], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1][93], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1][94], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1][95], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1][96], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1][97], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1][98], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 77 (body comment), line 83 (body comment), line 127 (body comment) and line 132 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1][99], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 85 (text), line 110 (text), line 183 (text), line 198 (text), line 198 (body comment) and
  line 238 (text).
- [automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1][100], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 8 (header), line 13 (header) and line 15 (header).
- [automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1][101], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1][102], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1][103], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 152 (body comment) and line 155 (text); selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 44 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1][104], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1][105], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (text) and line 13 (text).
- [automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1][106], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1][107], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1][108], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1][109], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1][110], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 16 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1][111], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1][112], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 39 (body comment) and line 45 (text); selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 2 (header) and line 18 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1][113], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header), line 57 (text), line 66 (text) and line 81 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][114], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][115], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1][116], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1][117], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1][118], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 4 (header), line 52 (text), line 56 (text) and line 74 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1][119], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header), line 3 (header), line 29 (body comment), line 37 (text) and line 79 (body
  comment).
- [automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1][120], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header), line 23 (text), line 29 (text) and line 43 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1][121], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 63 (body comment) and line 69 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1][122], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header), line 5 (header), line 24 (body comment), line 29 (body comment) and line 42 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1][123], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1][124], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 6 (header), line 7 (header), line 43 (text), line 47 (text) and line 52
  (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1][125], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1][126], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1][127], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 19 (text), line 29 (text), line 39 (text), line 103 (body comment) and line 105 (body
  comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1][128], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1][129], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header), line 3 (header), line 29 (text) and line 60 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1][130], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 88 (body comment) and line 96 (text); selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 37 (text), line 46 (text) and line 58 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1][131], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header), line 4 (header) and line 162 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][132], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1][133], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 96 (body comment) and line 107 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1][134], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 20 (text), line 29 (text), line 43 (text), line 115 (body comment) and line 117 (body
  comment).
- [automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1][135], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1][136], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 6 (header).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1][137], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][3]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1][138], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][139], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1][140], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 35 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs][141], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][142], in the cell automation × csharp: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][143], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 2 (header).

### Docs (52 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1][144], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-AdrRegistry.ps1][145], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1][146], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1][147], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][148], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 17 (header).
- [automation/Catzc.Base.Docs/configs/adr-checks.yml][149], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][150], in the cell automation × yaml: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it
  at line 163 (text); selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 161 (text); selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 145 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][151], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 57 (text), line 57 (body comment) and line 57 (body comment).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][152], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1][153], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 18 (header).
- [automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1][154], in the cell automation × powershell: selected by [ADR-AUTO-ASSETDEP][1]:
  the file cites it at line 62 (body comment) and line 63 (text).
- [automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1][155], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1][156], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1][157], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header) and line 4 (text).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1][158], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1][159], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1][160], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header) and line 4 (text).
- [automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1][161], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][162], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 3 (header) and line 42 (body comment).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1][163], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1][164], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1][165], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 51 (body comment) and line 52 (text).
- [automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1][166], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1][167], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1][168], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1][169], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1][170], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1][171], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1][172], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1][173], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1][174], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1][175], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1][176], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1][177], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1][178], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 4 (text) and line 126 (text).
- [automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1][179], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header), line 4 (text) and line 136 (text).
- [automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1][180], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 45 (text), line 104 (text) and line 115 (text).
- [automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1][181], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][182], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 47 (body comment), line 82 (body comment), line 83 (body comment) and line 96 (text).
- [automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1][183], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml][184], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml][185], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 1 (header), line 8 (text) and line 16 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][186], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][187], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1][188], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1][189], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][190], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1][191], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1][192], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][193], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 13 (header).
- [automation/Catzc.Base.Docs/types/CheckMode.cs][194], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][195], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 40 (body comment) (a passing mention only).

### adr/auto (40 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][196], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][197], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][198], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][199], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/index.md][200], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][201], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][202], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/consumer-overlay.md][203], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][204], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR
  file of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/controlling-systemwide-deps.md][205], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][206], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][207], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][208], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][209], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][210], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][211], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][212], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][213], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][214], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][215], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][216], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][217], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][218], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][219], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][220], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][221], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][2], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][222], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][223], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][224], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][225], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][226], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR
  file of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/spell-out-names.md][227], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][3], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][228], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][229], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][230], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][231], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][232], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.

### Az.Templates (29 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1][233], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1][234], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 23 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][235], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 8 (header), line 10 (header) and line 13 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1][236], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 18 (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1][237], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1][238], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment), line 5 (body comment) and line 36 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1][239], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment), line 4 (body comment), line 10 (body comment) and line 39 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1][240], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1][241], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1][242], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (body comment), line 5 (body comment), line 9 (body comment) and line 39 (body comment) (a passing mention
  only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1][243], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 34 (body comment), line 124 (body comment) and line 176 (body comment) (a passing mention
  only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1][244], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 46 (body comment), line 46 (body comment) and line 98 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1][245], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (body comment), line 6 (body comment), line 11 (body comment) and line 51 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][246], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 9 (header), line 12 (header), line 15 (header), line 20 (header) and line 25 (body comment).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1][247], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1][248], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1][249], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1][250], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1][251], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1][252], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment) and line 5 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1][253], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment), line 4 (body comment), line 42 (body comment) and line 42 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1][254], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1][255], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment), line 4 (body comment), line 57 (body comment) and line 57 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1][256], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1][257], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][258], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1][259], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 43 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml][260], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][261], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (body comment) (a passing mention only).

### ModuleSystem (25 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][262], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][263], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][264], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][265], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 34 (body comment) (a passing mention only); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][266], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 5 (header), line 20 (header) and line 209 (text); selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][267], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][268], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]:
  the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1][269], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][270], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][271], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 15 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1][272], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 6 (header), line 10 (header) and line 13 (header); selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1][273], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1][274], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/configs/artifacts.yml][275], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1][276], in the cell automation × powershell: selected
  by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 4 (header), line 7 (header), line 14 (header) and line 42 (text); selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 13 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1][277], in the cell automation × powershell:
  selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 1 (header), line 5 (header), line 8 (text) and line 9 (text); selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1][278], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 2 (header) and line 89 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line
  5 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1][279], in the cell automation × powershell:
  selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 2 (header), line 5 (header) and line 12 (text); selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1][280], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header) and line 92 (body comment).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1][281], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1][282], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 31 (text), line 37 (text) and line 47 (text).
- [automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1][283], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1][284], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1][285], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 19 (text) and line 31 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][286], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 3 (header).

### Globs (15 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][287], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the file
  cites it at line 29 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][288], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 14 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][289], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][290], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 18 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][291], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][292], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1][293], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][294], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 16 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][295], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1][296], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header), line 19 (text), line 30 (text) and line 42 (text).
- [automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1][297], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header), line 4 (header), line 18 (text), line 25 (text) and line 36 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1][298], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][299], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header), line 5 (header), line 29 (text), line 37 (text) and line 50 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1][300], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][301], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 32 (body comment) and line 50 (body comment) (a passing mention only).

### Exporter (13 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][302], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][303], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][2]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][304], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][305], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][306], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][307], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][2]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][308], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][309], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1][310], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1][311], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1][312], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 6 (body comment) and line 8 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][313], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][314], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][2]: the file
  cites it at line 2 (header).

### Azure (11 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/Test-AzureNetworkPlan.ps1][315], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 5 (header).
- [automation/Catzc.Azure/configs/identity-tokens.yml][316], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 3 (header).
- [automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1][317], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1][318], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1][319], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1][320], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1][321], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1][322], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1][323], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 4 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][324], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1][325], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 6 (body comment) and line 7 (body comment) (a passing mention only).

### Languages (11 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1][326], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1][327], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][328], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1][329], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1][330], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1][331], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1][332], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 17 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1][333], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][334], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][335], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][336], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 9 (header).

### Tool.Core (11 lit files)

The group holds the files of automation/Catzc.Tooling.Core; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1][337], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 13 (header).
- [automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1][338], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1][339], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1][340], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 81 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1][341], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (body comment) and line 52 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1][342], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1][343], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1][344], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (text).
- [automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1][345], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 35 (body comment) and line 87 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1][346], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 82 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1][347], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment) (a passing mention only).

### docs (11 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan.md][348], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  56 (text) and line 62 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][349], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 17 (text) and line 69 (text).
- [docs/how-to/automation/manual-test-plan/docs-and-links.md][350], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 13 (text).
- [docs/how-to/automation/manual-test-plan/module-system.md][351], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: the file
  cites it at line 20 (text) and line 20 (text).
- [docs/how-to/automation/manual-test-plan/test-harness.md][352], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 17 (text).
- [docs/how-to/getting-started/automation/run-tests-and-checks.md][353], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 33 (text).
- [docs/references/automation/catzc-base-docs.md][354], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 34 (text).
- [docs/references/automation/catzc-base-globs.md][355], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 44 (text).
- [docs/references/automation/catzc-base-languages.md][356], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 39 (text).
- [docs/references/automation/catzc-base-modulesystem.md][357], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 36 (text).
- [docs/references/automation/catzc-base-rootconfig.md][358], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 50 (text).

### Execution (10 lit files)

The group holds the files of automation/Catzc.Base.Execution; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Execution/Invoke-Executable.ps1][359], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 107 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1][360], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1][361], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1][362], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 81 (text) and line 81 (body comment).
- [automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1][363], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1][364], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1][365], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1][366], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1][367], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1][368], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment), line 13 (body comment) and line 15 (body comment) (a passing mention
  only).

### TypesSystem (10 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][369], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][370], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][371], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][372], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][373], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1][374], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][375], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1][376], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][377], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1][378], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).

### Maps (9 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][379], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][380], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][381], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][382], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][383], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 3 (header).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][384], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header), line 7 (header), line 45 (text), line 74 (text), line 80 (text) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][385], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 5 (header), line 7 (header), line 53 (text), line 104 (text), line 111 (text) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][386], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][387], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).

### RootConfig (9 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][388], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 24 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][389], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][390], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][391], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 120 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1][392], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 138 (body comment) and line 228 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1][393], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1][394], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1][395], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][396], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][397], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][398], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][399], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][4], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][400], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][401], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][402], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][403], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][404], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Contracts (8 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][405], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 12 (header).
- [automation/Catzc.Base.Contracts/Test-Contracts.ps1][406], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1][407], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1][408], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1][409], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1][410], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1][411], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1][412], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header), line 7 (header), line 35 (text), line 55 (body comment), line 79 (text) and line
  208 (body comment).

### Tool.Provisioning (7 lit files)

The group holds the files of automation/Catzc.Tooling.Provisioning; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1][413], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 45 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1][414], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1][415], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1][416], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1][417], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1][418], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1][419], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 3 (header).

### .internal (6 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][420], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][2]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 5 (header).
- [automation/.internal/tests/Import-AllModules.Tests.ps1][421], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 206 (body comment) (a passing mention only).
- [automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1][422], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 1 (text) and line 80 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][423], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][424], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 5 (header).
- [automation/.internal/tests/Test-FolderConventions.Tests.ps1][425], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 2 (header).

### Config (5 lit files)

The group holds the files of automation/Catzc.Base.Config; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1][426], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1][427], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 8 (body comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1][428], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 4 (body comment), line 15 (body comment), line 18 (body comment) and line 188 (body comment) (a passing mention
  only).
- [automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1][429], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 42 (body comment) and line 43 (text).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][430], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 119 (body comment) (a passing mention only).

### Reports (5 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/Write-QualityGateReport.ps1][431], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/configs/reports.yml][432], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 2 (header).
- [automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1][433], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header), line 4 (header), line 14 (text), line 24 (text), line 32 (text) and line 42
  (text).
- [automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1][434], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (text), line 10 (text) and line 17 (text).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][435], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 4 (header).

### Repository (5 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][436], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][437], in the cell automation × powershell: selected by [ADR-AUTO-ASSETDEP][1]:
  the file cites it at line 7 (header) and line 17 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][438], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1][439], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1][440], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][441], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at line 50 (text).
- [.claude/agents/build-inspiration-module.md][442], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 45 (text).
- [.claude/agents/catzc-worker.md][443], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at line 47
  (text).
- [.claude/agents/test-optimization.md][444], in the cell .claude × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (text), line 21 (text), line 21 (text), line 21 (text), line 22 (text), line 23 (text), line 52 (text), line 57 (text), line 58 (text),
  line 62 (text), line 62 (text), line 67 (text) and line 75 (text).

### Az.DevOps (4 lit files)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][445], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 9 (header).
- [automation/Catzc.Azure.DevOps/configs/identity-tokens.yml][446], in the cell automation × yaml: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 2 (header).
- [automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1][447], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 207 (body comment) (a passing mention only).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][448], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 44 (text) and line 53 (text).

### Tool.Inspiration (4 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1][449], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1][450], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][451], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1][452], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).

### Tool.Toolchain (4 lit files)

The group holds the files of automation/Catzc.Tooling.Toolchain; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1][453], in the cell automation × powershell: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 96 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1][454], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1][455], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 3 (header) and line 6 (text).
- [automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1][456], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][457], in the cell Root files × Unlisted files: selected by [ADR-AUTO-ASSETDEP][1]: a root file carries the citations of
  its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 17 (header); selected by [ADR-AUTO-TEST][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1`
  line 2 (header) and `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header); selected by
  [ADR-DSGN-RUNMODE][4]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line
  10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][458], in the cell Root files × Unlisted files: selected by [ADR-AUTO-ASSETDEP][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 17 (header); selected by [ADR-AUTO-TEST][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1`
  line 2 (header) and `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header); selected by
  [ADR-DSGN-RUNMODE][4]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line
  10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [importer.ps1][459], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][2]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-AUTO-TEST][3]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/tests/Import-AllModules.Tests.ps1` line 206 (body comment),
  `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 1 (text), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 80
  (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 5 (header) and
  `automation/.internal/tests/Test-FolderConventions.Tests.ps1` line 2 (header); selected by [ADR-DSGN-RUNMODE][4]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### ConfigExtensions (3 lit files)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][460], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1][461], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1][462], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).

### Tool.KeyHandler (3 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1][463], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1][464], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1][465], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (header) and line 4 (text).

### .scriptanalyzer (2 lit files)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1][466], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 154 (text).
- [automation/.scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1][467], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 54 (text).

### Objects (2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][468], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][469], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).

### Overlay (2 lit files)

The group holds the files of automation/Catzc.Base.Overlay; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][470], in the cell automation × powershell: selected by
  [ADR-AUTO-ASSETDEP][1]: the file cites it at line 14 (header) and line 73 (text).
- [automation/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1][471], in the cell automation × powershell: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 3 (header).

### Vendor (2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][472], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][473], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 18 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][474], in the cell docs × markdown: selected by [ADR-AUTO-TEST][3]: the file cites it at line 329 (text), line 367
  (text), line 378 (text), line 413 (text), line 459 (text), line 477 (text), line 489 (text), line 503 (text), line 525 (text), line 539
  (text), line 550 (text) and line 570 (text).
- [docs/adr/index.md][475], in the cell docs × markdown: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 151 (text); selected
  by [ADR-AUTO-BUNDLE][2]: the file cites it at line 149 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 133 (text);
  selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 94 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][476], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 48
  (body comment) (a passing mention only).

### Az.DevOps.BuildValidation (1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1][477], in the cell automation × powershell:
  selected by [ADR-AUTO-TEST][3]: the file cites it at line 13 (body comment) (a passing mention only).

### Engines (1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml][478], in the cell automation × yaml: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).

### Environment (1 lit file)

The group holds the files of automation/Catzc.Base.Environment; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1][479], in the cell automation × powershell: selected
  by [ADR-AUTO-TEST][3]: the file cites it at line 6 (text).

### Files (1 lit file)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1][480], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment) (a passing mention only).

### Timeouts (1 lit file)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TestTiers.cs][481], in the cell automation × csharp: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 2 (header) and line 3 (header).

### Tool.Python (1 lit file)

The group holds the files of automation/Catzc.Tooling.Python; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1][482], in the cell automation × powershell: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 3 (body comment) (a passing mention only).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-infrastructure.yaml][483], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  68 (body comment) (a passing mention only).

## Keywords

- [world map][484]
- [track][485]
- [file language][486]
- [cell][487]
- [lit cell][488]
- [root file][489]
- [unlisted file][490]
- [.claude][491]: a track
- [.github][491]: a track
- [automation][491]: a track
- [docs][491]: a track
- [pipelines][491]: a track
- [csharp][492]: a file language
- [markdown][492]: a file language
- [pipeline-yaml][492]: a file language
- [powershell][492]: a file language
- [yaml][492]: a file language

Terms the cited ADRs define:

- [all tests][493], defined by [ADR-AUTO-TEST#36][494]
- [build verification test][495], defined by [ADR-AUTO-TEST#24][496]
- [category][497], defined by [ADR-AUTO-TEST#1][498]
- [phase][499], defined by [ADR-AUTO-TEST#26][500]
- [quality gate][501], defined by [ADR-AUTO-TEST#35][502]
- [test][503], defined by [ADR-AUTO-TEST#42][504]
- [test file][505], defined by [ADR-AUTO-TEST#43][506]
- [test run][507], defined by [ADR-AUTO-TEST#34][508]
- [test suite][509], defined by [ADR-AUTO-TEST#37][510]
- [testing in production][511], defined by [ADR-AUTO-TEST#41][512]
- [tier][513], defined by [ADR-AUTO-TEST#13][514]
- [vertical test][515], defined by [ADR-AUTO-TEST#38][516]

[1]: ../../adr/automation/internal-asset-dependencies.md
[2]: ../../adr/automation/platform-bundle.md
[3]: ../../adr/automation/test-automation.md
[4]: ../../adr/design/run-modes.md
[5]: ../../../automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
[6]: ../../../automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1
[7]: ../../../automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
[8]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[9]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[10]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[11]: ../../../automation/Catzc.Base.QualityGates/Test-Change.ps1
[12]: ../../../automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
[13]: ../../../automation/Catzc.Base.QualityGates/Test-Formatting.ps1
[14]: ../../../automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
[15]: ../../../automation/Catzc.Base.QualityGates/Test-Links.ps1
[16]: ../../../automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
[17]: ../../../automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
[18]: ../../../automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
[19]: ../../../automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
[22]: ../../../automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
[23]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[24]: ../../../automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1
[25]: ../../../automation/Catzc.Base.QualityGates/Test-Spelling.ps1
[26]: ../../../automation/Catzc.Base.QualityGates/Test-Terminology.ps1
[27]: ../../../automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
[28]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[29]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[30]: ../../../automation/Catzc.Base.QualityGates/configs/source-conventions.yml
[31]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[32]: ../../../automation/Catzc.Base.QualityGates/configs/test-policy.yml
[33]: ../../../automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
[34]: ../../../automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
[35]: ../../../automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
[36]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[37]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[38]: ../../../automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
[39]: ../../../automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1
[40]: ../../../automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1
[41]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
[42]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
[43]: ../../../automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1
[44]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
[45]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1
[46]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
[47]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
[48]: ../../../automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
[49]: ../../../automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
[50]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
[51]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[52]: ../../../automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
[53]: ../../../automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
[54]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
[55]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
[56]: ../../../automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
[57]: ../../../automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
[58]: ../../../automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
[59]: ../../../automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
[60]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
[61]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
[62]: ../../../automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
[63]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
[64]: ../../../automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
[65]: ../../../automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
[66]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
[67]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
[68]: ../../../automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1
[69]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
[70]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
[71]: ../../../automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
[72]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
[73]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
[74]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
[75]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
[76]: ../../../automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1
[77]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
[78]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
[79]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
[80]: ../../../automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
[81]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1
[82]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
[83]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
[84]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
[85]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
[86]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
[87]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[88]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
[89]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
[90]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
[91]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
[92]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
[93]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
[94]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
[95]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
[96]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
[97]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
[98]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
[99]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
[100]: ../../../automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
[101]: ../../../automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
[102]: ../../../automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
[103]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
[104]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
[105]: ../../../automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
[106]: ../../../automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
[107]: ../../../automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
[108]: ../../../automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
[109]: ../../../automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
[110]: ../../../automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
[111]: ../../../automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
[112]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
[113]: ../../../automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
[114]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[115]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[116]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
[117]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
[118]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
[119]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
[120]: ../../../automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
[121]: ../../../automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1
[122]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
[123]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
[124]: ../../../automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
[125]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
[126]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
[127]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
[128]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
[129]: ../../../automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
[130]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
[131]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
[132]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[133]: ../../../automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
[134]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
[135]: ../../../automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
[136]: ../../../automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
[137]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
[138]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
[139]: ../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[140]: ../../../automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
[141]: ../../../automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
[142]: ../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[143]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[144]: ../../../automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1
[145]: ../../../automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
[146]: ../../../automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
[147]: ../../../automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
[148]: ../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[149]: ../../../automation/Catzc.Base.Docs/configs/adr-checks.yml
[150]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[151]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[152]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[153]: ../../../automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
[154]: ../../../automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1
[155]: ../../../automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
[156]: ../../../automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
[157]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1
[158]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
[159]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
[160]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1
[161]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1
[162]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[163]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1
[164]: ../../../automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
[165]: ../../../automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1
[166]: ../../../automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
[167]: ../../../automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
[168]: ../../../automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
[169]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
[170]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
[171]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
[172]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
[173]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
[174]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
[175]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
[176]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
[177]: ../../../automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1
[178]: ../../../automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1
[179]: ../../../automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
[180]: ../../../automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
[181]: ../../../automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
[182]: ../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[183]: ../../../automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
[184]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
[185]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
[186]: ../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[187]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[188]: ../../../automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
[189]: ../../../automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
[190]: ../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[191]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
[192]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
[193]: ../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[194]: ../../../automation/Catzc.Base.Docs/types/CheckMode.cs
[195]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[196]: ../../adr/automation/BCL/index.md
[197]: ../../adr/automation/BCL/native-csharp-types.md
[198]: ../../adr/automation/avoid-deep-nesting.md
[199]: ../../adr/automation/bash/bash-test-artifacts.md
[200]: ../../adr/automation/bash/index.md
[201]: ../../adr/automation/caching.md
[202]: ../../adr/automation/console-output-matters.md
[203]: ../../adr/automation/consumer-overlay.md
[204]: ../../adr/automation/controlling-module-dependencies.md
[205]: ../../adr/automation/controlling-systemwide-deps.md
[206]: ../../adr/automation/cross-platform.md
[207]: ../../adr/automation/devbox-pipeline-parity.md
[208]: ../../adr/automation/dora-explains.md
[209]: ../../adr/automation/dry-run.md
[210]: ../../adr/automation/effective-in-enterprises.md
[211]: ../../adr/automation/environment-variables.md
[212]: ../../adr/automation/execution-engines.md
[213]: ../../adr/automation/fail-fast-with-asserts.md
[214]: ../../adr/automation/go/go-test-artifacts.md
[215]: ../../adr/automation/go/index.md
[216]: ../../adr/automation/idempotent-state-functions.md
[217]: ../../adr/automation/log-before-invoke.md
[218]: ../../adr/automation/managed-guids.md
[219]: ../../adr/automation/never-depend-on-pwd.md
[220]: ../../adr/automation/open-closed-architecture.md
[221]: ../../adr/automation/path-representation.md
[222]: ../../adr/automation/python/index.md
[223]: ../../adr/automation/python/python-test-artifacts.md
[224]: ../../adr/automation/retry-as-last-resort.md
[225]: ../../adr/automation/sensible-defaults.md
[226]: ../../adr/automation/single-responsibility-functions.md
[227]: ../../adr/automation/spell-out-names.md
[228]: ../../adr/automation/tool-removal-lifecycle.md
[229]: ../../adr/automation/tracked-files-from-the-index.md
[230]: ../../adr/automation/use-proper-package-managers.md
[231]: ../../adr/automation/uv-python-handler.md
[232]: ../../adr/automation/zero-ceremony-poka-yoke.md
[233]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
[234]: ../../../automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
[235]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[236]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
[237]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
[238]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
[239]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
[240]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
[241]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
[242]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
[243]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
[244]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
[245]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
[246]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[247]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
[248]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
[249]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
[250]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
[251]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
[252]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
[253]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
[254]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
[255]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
[256]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
[257]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
[258]: ../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[259]: ../../../automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
[260]: ../../../automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
[261]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[262]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[263]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[264]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[265]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[266]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[267]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[268]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[269]: ../../../automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
[270]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[271]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[272]: ../../../automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
[273]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
[274]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
[275]: ../../../automation/Catzc.Base.ModuleSystem/configs/artifacts.yml
[276]: ../../../automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
[277]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
[278]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
[279]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
[280]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
[281]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
[282]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
[283]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
[284]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
[285]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
[286]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[287]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[288]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[289]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[290]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[291]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[292]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[293]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
[294]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[295]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[296]: ../../../automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
[297]: ../../../automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
[298]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
[299]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[300]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
[301]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[302]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[303]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[304]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[305]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[306]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[307]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[308]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[309]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[310]: ../../../automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
[311]: ../../../automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
[312]: ../../../automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
[313]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[314]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[315]: ../../../automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
[316]: ../../../automation/Catzc.Azure/configs/identity-tokens.yml
[317]: ../../../automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
[318]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
[319]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
[320]: ../../../automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
[321]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
[322]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
[323]: ../../../automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
[324]: ../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[325]: ../../../automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
[326]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
[327]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
[328]: ../../../automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[329]: ../../../automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
[330]: ../../../automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
[331]: ../../../automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
[332]: ../../../automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
[333]: ../../../automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
[334]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[335]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[336]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[337]: ../../../automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
[338]: ../../../automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
[339]: ../../../automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
[340]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
[341]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
[342]: ../../../automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
[343]: ../../../automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
[344]: ../../../automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
[345]: ../../../automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
[346]: ../../../automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
[347]: ../../../automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
[348]: ../../how-to/automation/manual-test-plan.md
[349]: ../../how-to/automation/manual-test-plan/azure.md
[350]: ../../how-to/automation/manual-test-plan/docs-and-links.md
[351]: ../../how-to/automation/manual-test-plan/module-system.md
[352]: ../../how-to/automation/manual-test-plan/test-harness.md
[353]: ../../how-to/getting-started/automation/run-tests-and-checks.md
[354]: ../../references/automation/catzc-base-docs.md
[355]: ../../references/automation/catzc-base-globs.md
[356]: ../../references/automation/catzc-base-languages.md
[357]: ../../references/automation/catzc-base-modulesystem.md
[358]: ../../references/automation/catzc-base-rootconfig.md
[359]: ../../../automation/Catzc.Base.Execution/Invoke-Executable.ps1
[360]: ../../../automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
[361]: ../../../automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
[362]: ../../../automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
[363]: ../../../automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
[364]: ../../../automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
[365]: ../../../automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
[366]: ../../../automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
[367]: ../../../automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
[368]: ../../../automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
[369]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[370]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[371]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[372]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[373]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[374]: ../../../automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
[375]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[376]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
[377]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[378]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
[379]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[380]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[381]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[382]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[383]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[384]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[385]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[386]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[387]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[388]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[389]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[390]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[391]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[392]: ../../../automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
[393]: ../../../automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
[394]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
[395]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
[396]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[397]: ../../adr/design/commit-lifecycle.md
[398]: ../../adr/design/dora-explains.md
[399]: ../../adr/design/module-aspects.md
[400]: ../../adr/design/self-service.md
[401]: ../../adr/design/server-remote-integration.md
[402]: ../../adr/design/thin-platforms.md
[403]: ../../adr/design/tracks.md
[404]: ../../adr/design/visual-design.md
[405]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[406]: ../../../automation/Catzc.Base.Contracts/Test-Contracts.ps1
[407]: ../../../automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
[408]: ../../../automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
[409]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
[410]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
[411]: ../../../automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
[412]: ../../../automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
[413]: ../../../automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
[414]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
[415]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
[416]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
[417]: ../../../automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
[418]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
[419]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
[420]: ../../../automation/.internal/assets/Import-Catzc.ps1
[421]: ../../../automation/.internal/tests/Import-AllModules.Tests.ps1
[422]: ../../../automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
[423]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[424]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[425]: ../../../automation/.internal/tests/Test-FolderConventions.Tests.ps1
[426]: ../../../automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1
[427]: ../../../automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
[428]: ../../../automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[429]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1
[430]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[431]: ../../../automation/Catzc.Base.Reports/Write-QualityGateReport.ps1
[432]: ../../../automation/Catzc.Base.Reports/configs/reports.yml
[433]: ../../../automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
[434]: ../../../automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
[435]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[436]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[437]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[438]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[439]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
[440]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
[441]: ../../../.claude/CLAUDE.md
[442]: ../../../.claude/agents/build-inspiration-module.md
[443]: ../../../.claude/agents/catzc-worker.md
[444]: ../../../.claude/agents/test-optimization.md
[445]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[446]: ../../../automation/Catzc.Azure.DevOps/configs/identity-tokens.yml
[447]: ../../../automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
[448]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[449]: ../../../automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
[450]: ../../../automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
[451]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[452]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
[453]: ../../../automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1
[454]: ../../../automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
[455]: ../../../automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1
[456]: ../../../automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
[457]: ../../../.gitattributes
[458]: ../../../.gitignore
[459]: ../../../importer.ps1
[460]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[461]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
[462]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
[463]: ../../../automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
[464]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
[465]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
[466]: ../../../automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1
[467]: ../../../automation/.scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1
[468]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[469]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[470]: ../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[471]: ../../../automation/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1
[472]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[473]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[474]: ../../adr/glossary.md
[475]: ../../adr/index.md
[476]: ../../../.github/workflows/ci-automation.yml
[477]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
[478]: ../../../automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml
[479]: ../../../automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
[480]: ../../../automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
[481]: ../../../automation/Catzc.Base.Timeouts/types/TestTiers.cs
[482]: ../../../automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1
[483]: ../../../pipelines/ci-infrastructure.yaml
[484]: ../../adr/glossary.md#world-map
[485]: ../../adr/glossary.md#track
[486]: ../../adr/glossary.md#file-language
[487]: ../../adr/glossary.md#cell
[488]: ../../adr/glossary.md#lit-cell
[489]: ../../adr/glossary.md#root-file
[490]: ../../adr/glossary.md#unlisted-file
[491]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[492]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[493]: ../../adr/glossary.md#all-tests
[494]: ../../adr/automation/test-automation.md#rule-adr-auto-test36
[495]: ../../adr/glossary.md#build-verification-test
[496]: ../../adr/automation/test-automation.md#rule-adr-auto-test24
[497]: ../../adr/glossary.md#category
[498]: ../../adr/automation/test-automation.md#rule-adr-auto-test1
[499]: ../../adr/glossary.md#phase
[500]: ../../adr/automation/test-automation.md#rule-adr-auto-test26
[501]: ../../adr/glossary.md#quality-gate
[502]: ../../adr/automation/test-automation.md#rule-adr-auto-test35
[503]: ../../adr/glossary.md#test
[504]: ../../adr/automation/test-automation.md#rule-adr-auto-test42
[505]: ../../adr/glossary.md#test-file
[506]: ../../adr/automation/test-automation.md#rule-adr-auto-test43
[507]: ../../adr/glossary.md#test-run
[508]: ../../adr/automation/test-automation.md#rule-adr-auto-test34
[509]: ../../adr/glossary.md#test-suite
[510]: ../../adr/automation/test-automation.md#rule-adr-auto-test37
[511]: ../../adr/glossary.md#testing-in-production
[512]: ../../adr/automation/test-automation.md#rule-adr-auto-test41
[513]: ../../adr/glossary.md#tier
[514]: ../../adr/automation/test-automation.md#rule-adr-auto-test13
[515]: ../../adr/glossary.md#vertical-test
[516]: ../../adr/automation/test-automation.md#rule-adr-auto-test38

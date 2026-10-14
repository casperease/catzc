# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md

`Grid minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Grid minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.png)

The grid minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5] and [ADR-REPO-ROOTCFG][6]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 8 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- .claude × markdown: 2 lit of 9 files
- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 99 lit of 219 files
- automation × powershell: 75 lit of 1398 files
- automation × yaml: 10 lit of 95 files
- docs × markdown: 136 lit of 469 files
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 4 files

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][7]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [.claude/CLAUDE.md][10]: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 57 (text) and line 121 (text); selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 30 (text).
- [.claude/agents/build-inspiration-module.md][11]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 25 (text).

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][7]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [.github/workflows/ci-automation.yml][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48 (body comment) (a passing
  mention only).

### automation × csharp (99 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][7]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][13]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][14]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 3 (header).
- [automation/Catzc.Azure.DevOps/types/AdoConfig.cs][15]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.Templates/types/BicepParameter.cs][16]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header) and
  line 8 (header).
- [automation/Catzc.Azure.Templates/types/BicepParameterModel.cs][17]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6
  (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][18]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 11 (header).
- [automation/Catzc.Azure/types/AzureConfig.cs][19]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure/types/AzureCustomer.cs][20]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][21]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][22]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][23]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Azure/types/CustomerConfig.cs][24]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure/types/NetworkConfig.cs][25]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure/types/NetworkEnvironment.cs][26]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Azure/types/NetworkSubscription.cs][27]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Contracts/types/ContractAsset.cs][28]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractCheckResult.cs][29]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractManifest.cs][30]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][31]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChange.cs][32]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs][33]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationMap.cs][34]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 60 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs][35]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][36]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/types/AdrDomainEdge.cs][37]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][38]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header) and line 7
  (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][39]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Docs/types/AgentEntry.cs][40]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][41]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryAvoid.cs][42]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][43]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Docs/types/GlossaryEntry.cs][44]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/types/GlossaryOptions.cs][45]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryRealization.cs][46]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][47]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][48]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 3 (header);
  selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][49]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 2 (header);
  selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterPackage.cs][50]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][51]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][52]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][53]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][54]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FormatterEngine.cs][55]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][56]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][57]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs][58]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 2 (header);
  selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][59]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][60]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][61]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs][62]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header);
  selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/CitationSite.cs][63]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/HighlightReason.cs][64]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/HighlightedCell.cs][65]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][66]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Maps/types/MapPlacement.cs][67]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][68]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][69]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][70]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][71]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][72]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPin.cs][73]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/TreemapRect.cs][74]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][75]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][76]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][77]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 25 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][78]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][79]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs][80]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/types/BaseModule.cs][81]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][82]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs][83]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs][84]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs][85]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs][86]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7
  (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81 (text).
- [automation/Catzc.Base.QualityGates/types/GuidsConfig.cs][87]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][88]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs][89]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 11
  (header).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][90]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/types/SpellingOracle.cs][91]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][92]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Reports/types/OutputFormat.cs][93]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs][94]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/types/OutputPattern.cs][95]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 67 (body comment)
  (a passing mention only).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][96]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][97]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][98]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][99]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs][100]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7
  (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs][101]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header);
  selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 2 (header).
- [automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs][102]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs][103]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header);
  selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][104]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][105]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][106]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Vendor/types/VendorConfig.cs][107]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][108]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs][109]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4
  (header).
- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs][110]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs][111]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line
  6 (header).

### automation × powershell (75 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][7]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [automation/.internal/assets/Import-Catzc.ps1][112]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header); selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 5 (header).
- [automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1][113]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header) and
  line 9 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][114]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][115]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 2
  (header), line 17 (text), line 38 (text) and line 75 (text).
- [automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1][116]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 3 (text).
- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][117]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 103 (body comment) (a
  passing mention only).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][118]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 133 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][119]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][120]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1][121]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 3 (header) and line 23 (text).
- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][122]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 60 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1][123]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1][124]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 3 (header) and line
  24 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][125]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][126]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 3
  (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][127]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 1 (text).
- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][128]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][129]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header) and line
  52 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][130]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][131]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][132]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7
  (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][133]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Files/Set-FileLink.ps1][134]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 17 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][135]: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Git/New-GitIgnore.ps1][136]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 17 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][137]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 29 (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][138]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 25 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][139]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 29 (header);
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][140]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][141]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header);
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][142]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][143]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 28
  (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][144]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][145]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 23 (header)
  and line 109 (body comment); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][146]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1][147]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line
  35 (text) and line 113 (text).
- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][148]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5
  (text).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][149]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6
  (text).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][150]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 65 (header),
  line 117 (header) and line 117 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][151]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 25
  (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][152]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][153]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line
  12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1][154]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 7
  (header) and line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1][155]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81
  (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][156]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 37
  (text) and line 37 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][157]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][158]: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1][159]: selected by [ADR-PWSH-ERROR][5]: the file cites it
  at line 29 (text) and line 80 (text).
- [automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1][160]: selected by [ADR-PWSH-ERROR][5]: the file cites it
  at line 35 (text) and line 36 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][161]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][162]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][163]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-SessionActor.ps1][164]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1][165]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][166]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 24 (header);
  selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 21 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][167]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][168]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 7 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][169]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at
  line 16 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][170]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][171]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at
  line 12 (header).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][172]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][173]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][174]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 12
  (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][175]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][176]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][177]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 19
  (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1][178]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][179]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 4 (text).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][180]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (text).
- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][181]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][182]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][183]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 18
  (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][184]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][185]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][186]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 18 (header).

### automation × yaml (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][7]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][187]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 162 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 167 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 101 (text);
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 192
  (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 292 (text).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][188]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Git/configs/gitignore.yml][189]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][190]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 18
  (text), line 18 (body comment) and line 35 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][191]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 588
  (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 568 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at
  line 608 (text).
- [automation/Catzc.Base.RootConfig/configs/rootconfig.yml][192]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 20 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-extensions.yml][193]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.VSCode/configs/vscode-launch.yml][194]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml][195]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.VSCode/configs/vscode-settings.yml][196]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).

### docs × markdown (136 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][7]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md][197]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md][198]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md][199]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][200]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 70 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md][201]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md][202]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 61 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][203]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 69 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][204]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 56 (text) and line 63 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 56 (text) and line 63
  (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 56 (text) and line 64 (text); selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 56 (text) and line 64 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 56 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 56 (text) and line 64 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md][205]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][206]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 67 (text) and line 74 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 67 (text) and line 74
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][207]: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][208]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][209]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][210]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][211]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][212]: selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 68 (text).
- [docs/adr/automation/BCL/index.md][213]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][2]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][214]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][215]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][216]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][217]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][218]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/controlling-systemwide-deps.md][219]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][220]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][221]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][222]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][223]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][224]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][225]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][226]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][227]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][228]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/test-artifacts.md][229]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][230]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][231]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][232]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][233]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][234]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][235]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][236]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/protected-globs.md][237]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][238]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][239]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][240]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][241]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][242]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/spell-out-names.md][243]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][244]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][245]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][246]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][247]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][248]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][249]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/design/commit-lifecycle.md][250]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][251]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][252]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][3]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][253]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][254]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][255]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/tracks.md][256]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][257]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][258]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text); selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 155 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 94 (text); selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 53 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 15 (text) and line
  178 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 273 (text).
- [docs/adr/principles/configure-not-program.md][259]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the
  ADR domain of that code.
- [docs/adr/principles/dora-explains.md][260]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR domain
  of that code.
- [docs/adr/principles/everything-as-code.md][261]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR
  domain of that code.
- [docs/adr/principles/one-living-version.md][4]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR
  domain of that code.
- [docs/adr/principles/poka-yoke.md][262]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR domain of
  that code.
- [docs/adr/principles/reduce-variability.md][263]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR
  domain of that code.
- [docs/adr/principles/reduce-waste.md][264]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/announce-state-changes.md][265]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/assert-idioms.md][266]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][267]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][268]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/cross-platform-powershell.md][269]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/dora-explains.md][270]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][271]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/environment-variable-mechanics.md][272]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/error-handling.md][5]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][273]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/identifier-names.md][274]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/index.md][275]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][276]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/one-function-per-file.md][277]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/parameter-design.md][278]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/pester-testing.md][279]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/powershell-formatting.md][280]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][281]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][282]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][283]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/pwsh-engine.md][284]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][285]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/script-scope-caching.md][286]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][287]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][288]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/working-directory-mechanics.md][289]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/agent-definitions.md][290]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/api-contracts.md][291]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/controlled-vocabulary.md][292]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][293]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][294]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][295]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][296]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][297]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/generated-readmes.md][298]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/generated-root-configs.md][6]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/inspiration.md][299]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/markdown-links.md][300]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/output-formats.md][301]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/repo-variants.md][302]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/uniform-formatting.md][303]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/explanation/automation/build-then-place-with-one-command.md][304]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][305]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][306]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][307]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][308]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 47 (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][309]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 18
  (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][310]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15
  (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 15 (text), line 50
  (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][311]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 45 (text) and line 68 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 41 (text), line 51
  (text), line 66 (text), line 69 (text) and line 73 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 33 (text) and line
  61 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 35 (text) and line 62 (text); selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 33 (text), line 44 (text), line 60 (text) and line 67 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][312]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 18
  (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][313]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 16 (text),
  line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text);
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 16 (text), line 42 (text), line 57 (text), line 63 (text) and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][314]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (text), line
  60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][315]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][316]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][317]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 14
  (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][318]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (text), line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][319]: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 32
  (text).
- [docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md][320]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 30
  (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][321]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 72 (text).
- [docs/how-to/getting-started/automation/powershell/add-a-function.md][322]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 111
  (text), line 114 (text), line 120 (text) and line 121 (text).
- [docs/references/automation/catzc-base-languages.md][323]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 10 (text).
- [docs/references/automation/catzc-base-rootconfig.md][324]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 43 (text) and
  line 52 (text).
- [docs/references/automation/catzc-base-typessystem.md][325]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 37 (text).
- [docs/references/automation/internal/catzc-internal-importer.md][326]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 36
  (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][327]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [importer.ps1][328]: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by [ADR-AUTO-TYPES][2]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1` line 4
  (header), `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1` line 9 (text),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 2 (header),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 17 (text),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 38 (text) and
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 75 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][327]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][329]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [.gitattributes][330]: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][331]: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][332]
- [track][333]
- [file language][334]
- [cell][335]
- [lit cell][336]
- [root file][337]
- [unlisted file][338]
- [.claude][339]: a track
- [.github][339]: a track
- [automation][339]: a track
- [docs][339]: a track
- [csharp][340]: a file language
- [markdown][340]: a file language
- [powershell][340]: a file language
- [yaml][340]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/native-csharp-types.md
[3]: ../../adr/design/run-modes.md
[4]: ../../adr/principles/one-living-version.md
[5]: ../../adr/pwsh/error-handling.md
[6]: ../../adr/repository/generated-root-configs.md
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[8]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[9]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[10]: ../../../.claude/CLAUDE.md
[11]: ../../../.claude/agents/build-inspiration-module.md
[12]: ../../../.github/workflows/ci-automation.yml
[13]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[14]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[15]: ../../../automation/Catzc.Azure.DevOps/types/AdoConfig.cs
[16]: ../../../automation/Catzc.Azure.Templates/types/BicepParameter.cs
[17]: ../../../automation/Catzc.Azure.Templates/types/BicepParameterModel.cs
[18]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[19]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[20]: ../../../automation/Catzc.Azure/types/AzureCustomer.cs
[21]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[22]: ../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[23]: ../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[24]: ../../../automation/Catzc.Azure/types/CustomerConfig.cs
[25]: ../../../automation/Catzc.Azure/types/NetworkConfig.cs
[26]: ../../../automation/Catzc.Azure/types/NetworkEnvironment.cs
[27]: ../../../automation/Catzc.Azure/types/NetworkSubscription.cs
[28]: ../../../automation/Catzc.Base.Contracts/types/ContractAsset.cs
[29]: ../../../automation/Catzc.Base.Contracts/types/ContractCheckResult.cs
[30]: ../../../automation/Catzc.Base.Contracts/types/ContractManifest.cs
[31]: ../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[32]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChange.cs
[33]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
[34]: ../../../automation/Catzc.Base.Docs/types/AdrCitationMap.cs
[35]: ../../../automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
[36]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[37]: ../../../automation/Catzc.Base.Docs/types/AdrDomainEdge.cs
[38]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[39]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[40]: ../../../automation/Catzc.Base.Docs/types/AgentEntry.cs
[41]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[42]: ../../../automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
[43]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[44]: ../../../automation/Catzc.Base.Docs/types/GlossaryEntry.cs
[45]: ../../../automation/Catzc.Base.Docs/types/GlossaryOptions.cs
[46]: ../../../automation/Catzc.Base.Docs/types/GlossaryRealization.cs
[47]: ../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[48]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[49]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[50]: ../../../automation/Catzc.Base.Exporter/types/ExporterPackage.cs
[51]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[52]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[53]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[54]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[55]: ../../../automation/Catzc.Base.Languages/types/FormatterEngine.cs
[56]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[57]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[58]: ../../../automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
[59]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[60]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[61]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[62]: ../../../automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
[63]: ../../../automation/Catzc.Base.Maps/types/CitationSite.cs
[64]: ../../../automation/Catzc.Base.Maps/types/HighlightReason.cs
[65]: ../../../automation/Catzc.Base.Maps/types/HighlightedCell.cs
[66]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[67]: ../../../automation/Catzc.Base.Maps/types/MapPlacement.cs
[68]: ../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[69]: ../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[70]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[71]: ../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[72]: ../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[73]: ../../../automation/Catzc.Base.Maps/types/MapsPin.cs
[74]: ../../../automation/Catzc.Base.Maps/types/TreemapRect.cs
[75]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[76]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[77]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[78]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[79]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[80]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
[81]: ../../../automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
[82]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[83]: ../../../automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs
[84]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
[85]: ../../../automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
[86]: ../../../automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
[87]: ../../../automation/Catzc.Base.QualityGates/types/GuidsConfig.cs
[88]: ../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[89]: ../../../automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
[90]: ../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[91]: ../../../automation/Catzc.Base.QualityGates/types/SpellingOracle.cs
[92]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[93]: ../../../automation/Catzc.Base.Reports/types/OutputFormat.cs
[94]: ../../../automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs
[95]: ../../../automation/Catzc.Base.Reports/types/OutputPattern.cs
[96]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[97]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[98]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[99]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[100]: ../../../automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
[101]: ../../../automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
[102]: ../../../automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
[103]: ../../../automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
[104]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[105]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[106]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[107]: ../../../automation/Catzc.Base.Vendor/types/VendorConfig.cs
[108]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[109]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
[110]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
[111]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
[112]: ../../../automation/.internal/assets/Import-Catzc.ps1
[113]: ../../../automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
[114]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[115]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[116]: ../../../automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1
[117]: ../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[118]: ../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[119]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[120]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[121]: ../../../automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
[122]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[123]: ../../../automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1
[124]: ../../../automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
[125]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[126]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[127]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[128]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[129]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[130]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[131]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[132]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[133]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[134]: ../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[135]: ../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[136]: ../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[137]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[138]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[139]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[140]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[141]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[142]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[143]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[144]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[145]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[146]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[147]: ../../../automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
[148]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[149]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[150]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[151]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[152]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[153]: ../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[154]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
[155]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
[156]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[157]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[158]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[159]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1
[160]: ../../../automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1
[161]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[162]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[163]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[164]: ../../../automation/Catzc.Base.Repository/Get-SessionActor.ps1
[165]: ../../../automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
[166]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[167]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[168]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[169]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[170]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[171]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[172]: ../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[173]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[174]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[175]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[176]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[177]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[178]: ../../../automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
[179]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[180]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[181]: ../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[182]: ../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[183]: ../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[184]: ../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[185]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[186]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[187]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[188]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[189]: ../../../automation/Catzc.Base.Git/configs/gitignore.yml
[190]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[191]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[192]: ../../../automation/Catzc.Base.RootConfig/configs/rootconfig.yml
[193]: ../../../automation/Catzc.Base.VSCode/configs/vscode-extensions.yml
[194]: ../../../automation/Catzc.Base.VSCode/configs/vscode-launch.yml
[195]: ../../../automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
[196]: ../../../automation/Catzc.Base.VSCode/configs/vscode-settings.yml
[197]: adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
[198]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
[199]: adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
[200]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[201]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
[202]: adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
[203]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[204]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[205]: adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
[206]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[207]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[208]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[209]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[210]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[211]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[212]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[213]: ../../adr/automation/BCL/index.md
[214]: ../../adr/automation/avoid-deep-nesting.md
[215]: ../../adr/automation/bash/bash-test-artifacts.md
[216]: ../../adr/automation/caching.md
[217]: ../../adr/automation/console-output-matters.md
[218]: ../../adr/automation/controlling-module-dependencies.md
[219]: ../../adr/automation/controlling-systemwide-deps.md
[220]: ../../adr/automation/cross-platform.md
[221]: ../../adr/automation/devbox-pipeline-parity.md
[222]: ../../adr/automation/dora-explains.md
[223]: ../../adr/automation/dry-run.md
[224]: ../../adr/automation/effective-in-enterprises.md
[225]: ../../adr/automation/environment-variables.md
[226]: ../../adr/automation/execution-engines.md
[227]: ../../adr/automation/fail-fast-with-asserts.md
[228]: ../../adr/automation/go/index.md
[229]: ../../adr/automation/go/test-artifacts.md
[230]: ../../adr/automation/idempotent-state-functions.md
[231]: ../../adr/automation/internal-asset-dependencies.md
[232]: ../../adr/automation/log-before-invoke.md
[233]: ../../adr/automation/managed-guids.md
[234]: ../../adr/automation/never-depend-on-pwd.md
[235]: ../../adr/automation/open-closed-architecture.md
[236]: ../../adr/automation/path-representation.md
[237]: ../../adr/automation/protected-globs.md
[238]: ../../adr/automation/python/index.md
[239]: ../../adr/automation/python/python-test-artifacts.md
[240]: ../../adr/automation/retry-as-last-resort.md
[241]: ../../adr/automation/sensible-defaults.md
[242]: ../../adr/automation/single-responsibility-functions.md
[243]: ../../adr/automation/spell-out-names.md
[244]: ../../adr/automation/test-automation.md
[245]: ../../adr/automation/tool-removal-lifecycle.md
[246]: ../../adr/automation/tracked-files-from-the-index.md
[247]: ../../adr/automation/use-proper-package-managers.md
[248]: ../../adr/automation/uv-python-handler.md
[249]: ../../adr/automation/zero-ceremony-poka-yoke.md
[250]: ../../adr/design/commit-lifecycle.md
[251]: ../../adr/design/dora-explains.md
[252]: ../../adr/design/module-aspects.md
[253]: ../../adr/design/self-service.md
[254]: ../../adr/design/server-remote-integration.md
[255]: ../../adr/design/thin-platforms.md
[256]: ../../adr/design/tracks.md
[257]: ../../adr/design/visual-design.md
[258]: ../../adr/index.md
[259]: ../../adr/principles/configure-not-program.md
[260]: ../../adr/principles/dora-explains.md
[261]: ../../adr/principles/everything-as-code.md
[262]: ../../adr/principles/poka-yoke.md
[263]: ../../adr/principles/reduce-variability.md
[264]: ../../adr/principles/reduce-waste.md
[265]: ../../adr/pwsh/announce-state-changes.md
[266]: ../../adr/pwsh/assert-idioms.md
[267]: ../../adr/pwsh/automatic-variable-pitfalls.md
[268]: ../../adr/pwsh/avoid-using-semicolons.md
[269]: ../../adr/pwsh/cross-platform-powershell.md
[270]: ../../adr/pwsh/dora-explains.md
[271]: ../../adr/pwsh/dynamic-module-manifests.md
[272]: ../../adr/pwsh/environment-variable-mechanics.md
[273]: ../../adr/pwsh/hosting-csharp-types.md
[274]: ../../adr/pwsh/identifier-names.md
[275]: ../../adr/pwsh/index.md
[276]: ../../adr/pwsh/module-path-hygiene.md
[277]: ../../adr/pwsh/one-function-per-file.md
[278]: ../../adr/pwsh/parameter-design.md
[279]: ../../adr/pwsh/pester-testing.md
[280]: ../../adr/pwsh/powershell-formatting.md
[281]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[282]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[283]: ../../adr/pwsh/prepost-extension-modules.md
[284]: ../../adr/pwsh/pwsh-engine.md
[285]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[286]: ../../adr/pwsh/script-scope-caching.md
[287]: ../../adr/pwsh/use-ps1-not-psm1.md
[288]: ../../adr/pwsh/vendor-toolset-dependencies.md
[289]: ../../adr/pwsh/working-directory-mechanics.md
[290]: ../../adr/repository/agent-definitions.md
[291]: ../../adr/repository/api-contracts.md
[292]: ../../adr/repository/controlled-vocabulary.md
[293]: ../../adr/repository/conventional-folders.md
[294]: ../../adr/repository/dedicated-output-directory.md
[295]: ../../adr/repository/documentation-examples.md
[296]: ../../adr/repository/domain-language-separation.md
[297]: ../../adr/repository/dora-explains.md
[298]: ../../adr/repository/generated-readmes.md
[299]: ../../adr/repository/inspiration.md
[300]: ../../adr/repository/markdown-links.md
[301]: ../../adr/repository/output-formats.md
[302]: ../../adr/repository/repo-variants.md
[303]: ../../adr/repository/uniform-formatting.md
[304]: ../../explanation/automation/build-then-place-with-one-command.md
[305]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[306]: ../../explanation/automation/dot-source-one-entry-script.md
[307]: ../../explanation/automation/every-code-root-is-a-copy.md
[308]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[309]: ../../explanation/automation/invoke-importer-in-code-order.md
[310]: ../../explanation/automation/one-commit-one-immutable-package.md
[311]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[312]: ../../explanation/automation/two-entries-feed-one-importer.md
[313]: ../../explanation/automation/what-gates-each-bundle-stage.md
[314]: ../../explanation/design/one-entry-script-per-mode.md
[315]: ../../explanation/design/shims-set-roots-mode-read-back.md
[316]: ../../explanation/design/two-roots-one-importer-same-modules.md
[317]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[318]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[319]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[320]: ../../how-to/getting-started/automation/BCL/add-a-dotnet-type.md
[321]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[322]: ../../how-to/getting-started/automation/powershell/add-a-function.md
[323]: ../../references/automation/catzc-base-languages.md
[324]: ../../references/automation/catzc-base-rootconfig.md
[325]: ../../references/automation/catzc-base-typessystem.md
[326]: ../../references/automation/internal/catzc-internal-importer.md
[327]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[328]: ../../../importer.ps1
[329]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[330]: ../../../.gitattributes
[331]: ../../../.gitignore
[332]: ../../adr/glossary.md#world-map
[333]: ../../adr/glossary.md#track
[334]: ../../adr/glossary.md#file-language
[335]: ../../adr/glossary.md#cell
[336]: ../../adr/glossary.md#lit-cell
[337]: ../../adr/glossary.md#root-file
[338]: ../../adr/glossary.md#unlisted-file
[339]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[340]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

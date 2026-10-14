# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md

`Grid minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Grid minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.png)

The grid minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5] and [ADR-REPO-ROOTCFG][6]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 9 files
- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 99 lit of 219 files
- automation × powershell: 76 lit of 1400 files
- automation × yaml: 10 lit of 95 files
- docs × markdown: 184 lit of 741 files
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

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

### automation × powershell (76 lit files)

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
  54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][130]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][131]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][132]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7
  (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][133]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][134]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Files/Set-FileLink.ps1][135]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 17 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][136]: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Git/New-GitIgnore.ps1][137]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 17 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][138]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 29 (header).
- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][139]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 25 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][140]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 29 (header);
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][141]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][142]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 4 (header);
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][143]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][144]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 28
  (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][145]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][146]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 23 (header)
  and line 109 (body comment); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][147]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1][148]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line
  35 (text) and line 113 (text).
- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][149]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5
  (text).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][150]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6
  (text).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][151]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 65 (header),
  line 117 (header) and line 117 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][152]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 25
  (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][153]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][154]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line
  12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1][155]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 7
  (header) and line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1][156]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81
  (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][157]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 37
  (text) and line 37 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][158]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][159]: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1][160]: selected by [ADR-PWSH-ERROR][5]: the file cites it
  at line 29 (text) and line 80 (text).
- [automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1][161]: selected by [ADR-PWSH-ERROR][5]: the file cites it
  at line 35 (text) and line 36 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][162]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][163]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][164]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-SessionActor.ps1][165]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1][166]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][167]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 24 (header);
  selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 21 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][168]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][169]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 7 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][170]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at
  line 16 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][171]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][172]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at
  line 12 (header).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][173]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][174]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][175]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 12
  (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][176]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][177]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][178]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 19
  (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1][179]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][180]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 4 (text).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][181]: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (text).
- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][182]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][183]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][184]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 18
  (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][185]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][186]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][187]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 18 (header).

### automation × yaml (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][7]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][188]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 162 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 167 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 101 (text);
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 192
  (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 313 (text).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][189]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Git/configs/gitignore.yml][190]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][191]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 18
  (text), line 18 (body comment) and line 35 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][192]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 590
  (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 570 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at
  line 610 (text).
- [automation/Catzc.Base.RootConfig/configs/rootconfig.yml][193]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 20 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-extensions.yml][194]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.VSCode/configs/vscode-launch.yml][195]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml][196]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.VSCode/configs/vscode-settings.yml][197]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).

### docs × markdown (184 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][7]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][198]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md][199]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][200]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text), line 47 (text), line
  48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70 (text), line 73 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154
  (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 169
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185
  (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md][201]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line
  43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 115 (text), line
  117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line
  133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line
  148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line
  170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197 (text), line 204 (text), line
  211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][202]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md][203]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][204]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text),
  line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70
  (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183
  (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md][205]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text),
  line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197
  (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][206]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md][207]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][208]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text), line 47 (text), line 48
  (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70 (text), line 73 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154
  (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 169
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185
  (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.tree.md][209]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43
  (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 115 (text), line
  117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line
  133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line
  148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line
  170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197 (text), line 204 (text), line
  211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][210]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][211]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 70 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][212]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 31 (text), line 39 (text), line 40 (text), line 47 (text), line 52 (text), line 55 (text), line 56
  (text), line 58 (text), line 59 (text), line 60 (text), line 62 (text), line 105 (text), line 107 (text), line 115 (text), line 118
  (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 132 (text), line 134
  (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 161
  (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177
  (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 193
  (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209
  (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line 241
  (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 252 (text), line 254 (text), line 256 (text), line 259
  (text), line 262 (text), line 264 (text) and line 283 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line
  48 (text), line 49 (text), line 50 (text), line 54 (text), line 64 (text), line 65 (text), line 66 (text), line 68 (text), line 69 (text),
  line 71 (text), line 73 (text), line 74 (text), line 75 (text), line 77 (text), line 78 (text), line 79 (text), line 81 (text), line 83
  (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text),
  line 97 (text), line 98 (text), line 106 (text), line 108 (text), line 122 (text), line 128 (text), line 130 (text), line 135 (text), line
  137 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 225 (text), line 227 (text), line 229 (text), line
  231 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241 (text), line 250 (text), line
  253 (text), line 257 (text), line 260 (text), line 266 (text), line 267 (text), line 269 (text), line 271 (text), line 273 (text), line
  275 (text), line 284 (text), line 293 (text) and line 297 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md][213]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text),
  line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87
  (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text),
  line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 142 (text),
  line 144 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 165 (text), line 168 (text), line 170 (text),
  line 173 (text), line 176 (text), line 178 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text),
  line 208 (text), line 211 (text), line 212 (text), line 214 (text), line 303 (text), line 324 (text), line 333 (text), line 351 (text),
  line 365 (text) and line 386 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 131 (text), line 137
  (text), line 139 (text), line 144 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 164
  (text), line 166 (text), line 171 (text), line 175 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188
  (text), line 190 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233
  (text), line 235 (text), line 237 (text), line 244 (text), line 247 (text), line 248 (text), line 251 (text), line 253 (text), line 254
  (text), line 256 (text), line 259 (text), line 265 (text), line 267 (text), line 269 (text), line 272 (text), line 274 (text), line 281
  (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 295 (text), line 299 (text), line 305 (text), line 313
  (text), line 315 (text), line 317 (text), line 325 (text), line 327 (text), line 334 (text), line 335 (text), line 342 (text), line 344
  (text), line 359 (text), line 372 (text), line 379 (text) and line 387 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][214]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md][215]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][216]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text), line 47 (text), line 48
  (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70 (text), line 73 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154
  (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 169
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185
  (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md][217]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43
  (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 115 (text), line
  117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line
  133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line
  148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line
  170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197 (text), line 204 (text), line
  211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][218]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md][219]: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 61 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][220]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text), line 47 (text), line
  48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70 (text), line 73 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154
  (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 169
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185
  (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md][221]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line
  43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 115 (text), line
  117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line
  133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line
  148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line
  170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197 (text), line 204 (text), line
  211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][222]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][223]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 69 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][224]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 7 (text), line 30 (text), line 38 (text), line 39 (text), line 46 (text), line 51 (text), line 54 (text), line 55
  (text), line 57 (text), line 58 (text), line 59 (text), line 61 (text), line 104 (text), line 106 (text), line 114 (text), line 117
  (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 131 (text), line 133
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160
  (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 176
  (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192
  (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208
  (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 240
  (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 251 (text), line 253 (text), line 255 (text), line 258
  (text), line 261 (text), line 263 (text) and line 282 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line
  47 (text), line 48 (text), line 49 (text), line 53 (text), line 63 (text), line 64 (text), line 65 (text), line 67 (text), line 68 (text),
  line 70 (text), line 72 (text), line 73 (text), line 74 (text), line 76 (text), line 77 (text), line 78 (text), line 80 (text), line 82
  (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text),
  line 96 (text), line 97 (text), line 105 (text), line 107 (text), line 121 (text), line 127 (text), line 129 (text), line 134 (text), line
  136 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 224 (text), line 226 (text), line 228 (text), line
  230 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 238 (text), line 240 (text), line 249 (text), line
  252 (text), line 256 (text), line 259 (text), line 265 (text), line 266 (text), line 268 (text), line 270 (text), line 272 (text), line
  274 (text), line 283 (text), line 292 (text) and line 296 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md][225]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 7 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52
  (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 124 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 141 (text),
  line 143 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 164 (text), line 167 (text), line 169 (text),
  line 172 (text), line 175 (text), line 177 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 210 (text), line 211 (text), line 213 (text), line 302 (text), line 323 (text), line 332 (text), line 350 (text),
  line 364 (text) and line 385 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 130 (text), line 136
  (text), line 138 (text), line 143 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 163
  (text), line 165 (text), line 170 (text), line 174 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232
  (text), line 234 (text), line 236 (text), line 243 (text), line 246 (text), line 247 (text), line 250 (text), line 252 (text), line 253
  (text), line 255 (text), line 258 (text), line 264 (text), line 266 (text), line 268 (text), line 271 (text), line 273 (text), line 280
  (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 294 (text), line 298 (text), line 304 (text), line 312
  (text), line 314 (text), line 316 (text), line 324 (text), line 326 (text), line 333 (text), line 334 (text), line 341 (text), line 343
  (text), line 358 (text), line 371 (text), line 378 (text) and line 386 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][226]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 68 (text), line 68 (text), line 79 (text) and line 79 (text); selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (text), line 54 (text), line 54 (text), line 71 (text) and line 71 (text); selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 38 (text), line 38 (text), line 46 (text) and line 46 (text); selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 8 (text), line 30 (text) and line 30 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 8 (text),
  line 57 (text) and line 57 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (text), line 60 (text) and line 60
  (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][227]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 56 (text) and line 63 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 56 (text) and line 63
  (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 56 (text) and line 64 (text); selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 56 (text) and line 64 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 56 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 56 (text) and line 64 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][228]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 41 (text), line 90 (text), line 92 (text), line 178 (text), line 192 (text), line 205 (text), line
  206 (text), line 208 (text), line 209 (text), line 210 (text), line 212 (text), line 309 (text), line 313 (text), line 334 (text), line
  336 (text), line 337 (text), line 339 (text), line 341 (text), line 344 (text), line 345 (text), line 347 (text), line 352 (text), line
  354 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line
  384 (text), line 386 (text), line 388 (text), line 390 (text), line 392 (text), line 394 (text), line 396 (text), line 398 (text), line
  400 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 410 (text), line 412 (text), line 414 (text), line
  416 (text), line 418 (text), line 420 (text), line 422 (text), line 424 (text), line 426 (text), line 428 (text), line 430 (text), line
  432 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445 (text), line 447 (text), line
  465 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 569 (text), line 571 (text), line 573 (text), line
  576 (text), line 582 (text), line 584 (text) and line 616 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (text),
  line 34 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 59 (text), line 60
  (text), line 61 (text), line 62 (text), line 63 (text), line 64 (text), line 65 (text), line 66 (text), line 67 (text), line 68 (text),
  line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 76 (text), line 77 (text), line 78 (text), line 79
  (text), line 81 (text), line 82 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 88 (text),
  line 89 (text), line 91 (text), line 93 (text), line 94 (text), line 96 (text), line 97 (text), line 98 (text), line 99 (text), line 100
  (text), line 101 (text), line 102 (text), line 104 (text), line 105 (text), line 106 (text), line 107 (text), line 109 (text), line 110
  (text), line 111 (text), line 112 (text), line 113 (text), line 114 (text), line 115 (text), line 116 (text), line 117 (text), line 118
  (text), line 119 (text), line 120 (text), line 121 (text), line 122 (text), line 123 (text), line 124 (text), line 125 (text), line 126
  (text), line 127 (text), line 128 (text), line 130 (text), line 131 (text), line 132 (text), line 133 (text), line 135 (text), line 136
  (text), line 137 (text), line 139 (text), line 141 (text), line 142 (text), line 143 (text), line 144 (text), line 145 (text), line 147
  (text), line 149 (text), line 151 (text), line 152 (text), line 154 (text), line 158 (text), line 160 (text), line 161 (text), line 162
  (text), line 163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 180 (text), line 183 (text), line 194
  (text), line 202 (text), line 204 (text), line 219 (text), line 223 (text), line 230 (text), line 234 (text), line 236 (text), line 238
  (text), line 264 (text), line 265 (text), line 278 (text), line 282 (text), line 288 (text), line 290 (text), line 292 (text), line 294
  (text), line 310 (text), line 348 (text), line 370 (text), line 372 (text), line 374 (text), line 376 (text), line 378 (text), line 380
  (text), line 382 (text), line 385 (text), line 387 (text), line 389 (text), line 391 (text), line 393 (text), line 395 (text), line 397
  (text), line 399 (text), line 401 (text), line 403 (text), line 405 (text), line 407 (text), line 409 (text), line 411 (text), line 413
  (text), line 415 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429
  (text), line 431 (text), line 433 (text), line 436 (text), line 438 (text), line 440 (text), line 442 (text), line 444 (text), line 446
  (text), line 448 (text), line 465 (text), line 577 (text), line 599 (text), line 607 (text), line 608 (text), line 617 (text), line 632
  (text) and line 638 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 179 (text), line 182 (text), line
  190 (text), line 201 (text), line 217 (text), line 220 (text), line 221 (text), line 224 (text), line 225 (text), line 227 (text), line
  229 (text), line 231 (text), line 232 (text), line 242 (text), line 244 (text), line 253 (text), line 255 (text), line 261 (text), line
  262 (text), line 263 (text), line 267 (text), line 280 (text), line 283 (text), line 284 (text), line 286 (text), line 289 (text), line
  301 (text), line 302 (text), line 310 (text), line 317 (text), line 340 (text), line 346 (text), line 349 (text), line 355 (text), line
  357 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 449 (text), line 451 (text), line 453 (text), line
  455 (text), line 456 (text), line 458 (text), line 460 (text), line 462 (text), line 463 (text), line 466 (text), line 567 (text), line
  570 (text), line 574 (text), line 578 (text), line 586 (text), line 587 (text), line 589 (text), line 591 (text), line 593 (text), line
  595 (text), line 623 (text), line 634 (text) and line 640 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text),
  line 32 (text), line 215 (text), line 311 (text), line 318 (text), line 349 (text), line 368 (text), line 467 (text), line 469 (text),
  line 471 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 579 (text) and line 597 (text);
  selected by [ADR-PWSH-ERROR][5]: the file cites it at line 8 (text), line 33 (text), line 74 (text), line 134 (text), line 185 (text),
  line 186 (text), line 188 (text), line 196 (text), line 198 (text), line 199 (text), line 211 (text), line 240 (text), line 247 (text),
  line 249 (text), line 251 (text), line 257 (text), line 259 (text), line 311 (text), line 315 (text), line 350 (text), line 467 (text),
  line 483 (text), line 485 (text), line 486 (text), line 488 (text), line 490 (text), line 492 (text), line 493 (text), line 495 (text),
  line 497 (text), line 498 (text), line 500 (text), line 502 (text), line 503 (text), line 505 (text), line 507 (text), line 509 (text),
  line 511 (text), line 513 (text), line 515 (text), line 517 (text), line 519 (text), line 520 (text), line 522 (text), line 524 (text),
  line 526 (text), line 528 (text), line 580 (text), line 601 (text) and line 602 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 8 (text), line 95 (text), line 103 (text), line 108 (text), line 148 (text), line 153 (text), line 155 (text), line 156 (text),
  line 159 (text), line 214 (text), line 216 (text), line 218 (text), line 245 (text), line 268 (text), line 269 (text), line 271 (text),
  line 272 (text), line 274 (text), line 276 (text), line 296 (text), line 297 (text), line 298 (text), line 300 (text), line 312 (text),
  line 314 (text), line 318 (text), line 320 (text), line 321 (text), line 323 (text), line 324 (text), line 326 (text), line 351 (text),
  line 468 (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text), line 540 (text), line 542 (text),
  line 544 (text), line 546 (text), line 548 (text), line 550 (text), line 552 (text), line 554 (text), line 556 (text), line 558 (text),
  line 580 (text), line 604 (text) and line 605 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md][229]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 62 (text), line 65 (text), line 68 (text), line 71 (text), line 74 (text), line 77 (text), line 80
  (text), line 83 (text), line 86 (text), line 89 (text), line 92 (text), line 95 (text), line 98 (text), line 101 (text), line 104 (text),
  line 107 (text), line 110 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text),
  line 131 (text), line 134 (text), line 137 (text), line 140 (text), line 143 (text), line 146 (text), line 149 (text), line 152 (text),
  line 155 (text), line 158 (text), line 161 (text), line 164 (text), line 167 (text), line 170 (text), line 173 (text), line 176 (text),
  line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text),
  line 204 (text), line 206 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 229 (text), line 232 (text),
  line 234 (text), line 237 (text), line 243 (text), line 245 (text), line 344 (text), line 603 (text), line 605 (text), line 607 (text),
  line 609 (text), line 612 (text), line 613 (text), line 616 (text), line 617 (text), line 619 (text), line 737 (text), line 784 (text),
  line 822 (text), line 933 (text) and line 975 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (text), line 63 (text),
  line 66 (text), line 69 (text), line 72 (text), line 75 (text), line 78 (text), line 81 (text), line 84 (text), line 87 (text), line 90
  (text), line 93 (text), line 96 (text), line 99 (text), line 102 (text), line 105 (text), line 108 (text), line 111 (text), line 114
  (text), line 117 (text), line 120 (text), line 123 (text), line 126 (text), line 129 (text), line 132 (text), line 135 (text), line 138
  (text), line 141 (text), line 144 (text), line 147 (text), line 150 (text), line 153 (text), line 156 (text), line 159 (text), line 162
  (text), line 165 (text), line 168 (text), line 171 (text), line 174 (text), line 177 (text), line 199 (text), line 239 (text), line 262
  (text), line 272 (text), line 274 (text), line 345 (text), line 351 (text), line 352 (text), line 354 (text), line 356 (text), line 360
  (text), line 362 (text), line 364 (text), line 366 (text), line 368 (text), line 370 (text), line 372 (text), line 374 (text), line 376
  (text), line 378 (text), line 380 (text), line 382 (text), line 416 (text), line 418 (text), line 420 (text), line 422 (text), line 425
  (text), line 426 (text), line 428 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445
  (text), line 447 (text), line 449 (text), line 451 (text), line 453 (text), line 455 (text), line 457 (text), line 459 (text), line 461
  (text), line 463 (text), line 465 (text), line 472 (text), line 476 (text), line 484 (text), line 490 (text), line 491 (text), line 493
  (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 503 (text), line 547 (text), line 549 (text), line 551
  (text), line 553 (text), line 555 (text), line 557 (text), line 559 (text), line 561 (text), line 563 (text), line 565 (text), line 567
  (text), line 590 (text), line 592 (text), line 596 (text), line 618 (text), line 620 (text), line 621 (text), line 628 (text), line 630
  (text), line 632 (text), line 634 (text), line 636 (text), line 638 (text), line 640 (text), line 642 (text), line 644 (text), line 652
  (text), line 655 (text), line 661 (text), line 664 (text), line 666 (text), line 668 (text), line 740 (text), line 741 (text), line 743
  (text), line 745 (text), line 747 (text), line 758 (text), line 760 (text), line 762 (text), line 775 (text), line 778 (text), line 786
  (text), line 790 (text), line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 810 (text), line 816 (text), line 824
  (text), line 848 (text), line 850 (text), line 852 (text), line 863 (text), line 872 (text), line 880 (text), line 882 (text), line 898
  (text), line 900 (text), line 906 (text), line 908 (text), line 915 (text), line 917 (text), line 924 (text), line 927 (text), line 947
  (text), line 961 (text) and line 976 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 191 (text), line
  197 (text), line 200 (text), line 206 (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line
  228 (text), line 230 (text), line 235 (text), line 239 (text), line 247 (text), line 249 (text), line 251 (text), line 253 (text), line
  255 (text), line 257 (text), line 345 (text), line 348 (text), line 391 (text), line 393 (text), line 397 (text), line 409 (text), line
  411 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 482 (text), line 485 (text), line
  488 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text), line 662 (text), line 674 (text), line 676 (text), line
  678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 690 (text), line 697 (text), line
  769 (text), line 771 (text), line 773 (text), line 785 (text), line 789 (text), line 812 (text), line 818 (text), line 829 (text), line
  859 (text), line 861 (text), line 955 (text), line 968 (text) and line 976 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at
  line 8 (text), line 201 (text), line 219 (text), line 240 (text), line 260 (text), line 346 (text), line 398 (text), line 718 (text), line
  720 (text), line 722 (text), line 724 (text), line 726 (text), line 728 (text), line 730 (text), line 870 (text), line 890 (text) and line
  977 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 8 (text), line 201 (text), line 241 (text), line 264 (text), line
  266 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 291 (text), line 293 (text), line
  295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line 305 (text), line 307 (text), line 309 (text), line
  311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text), line 323 (text), line 325 (text), line
  327 (text), line 329 (text), line 331 (text), line 338 (text), line 340 (text), line 342 (text), line 346 (text), line 358 (text), line
  389 (text), line 395 (text), line 403 (text), line 405 (text), line 407 (text), line 413 (text), line 415 (text), line 417 (text), line
  612 (text), line 754 (text), line 756 (text), line 871 (text), line 941 (text) and line 977 (text); selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 8 (text), line 202 (text), line 242 (text), line 268 (text), line 270 (text), line 347 (text), line 399 (text), line
  401 (text), line 510 (text), line 512 (text), line 514 (text), line 516 (text), line 518 (text), line 520 (text), line 522 (text), line
  524 (text), line 526 (text), line 528 (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text), line
  545 (text), line 560 (text), line 568 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line
  584 (text), line 586 (text), line 588 (text), line 591 (text), line 593 (text), line 595 (text), line 597 (text), line 698 (text), line
  700 (text), line 701 (text), line 703 (text), line 706 (text), line 708 (text), line 710 (text), line 711 (text), line 837 (text), line
  839 (text), line 841 (text), line 888 (text) and line 978 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][230]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md][231]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][232]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text), line 47 (text), line
  48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70 (text), line 73 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154
  (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 169
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185
  (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md][233]: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line
  43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 115 (text), line
  117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line
  133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line
  148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line
  170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197 (text), line 204 (text), line
  211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][234]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 57 (text), line 57 (text), line 73 (text) and line 73 (text); selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 30 (text), line 30 (text), line 38 (text) and line 38 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][235]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 67 (text) and line 74 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 67 (text) and line 74
  (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][236]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 71 (text), line 181 (text), line 278 (text), line 279
  (text), line 281 (text), line 282 (text), line 283 (text), line 285 (text), line 763 (text), line 773 (text), line 794 (text), line 796
  (text), line 797 (text), line 799 (text), line 801 (text), line 804 (text), line 805 (text), line 807 (text), line 810 (text), line 812
  (text), line 836 (text), line 839 (text), line 842 (text), line 845 (text), line 848 (text), line 851 (text), line 854 (text), line 857
  (text), line 860 (text), line 863 (text), line 866 (text), line 869 (text), line 872 (text), line 875 (text), line 878 (text), line 881
  (text), line 884 (text), line 887 (text), line 890 (text), line 893 (text), line 896 (text), line 899 (text), line 902 (text), line 905
  (text), line 908 (text), line 911 (text), line 914 (text), line 917 (text), line 920 (text), line 923 (text), line 926 (text), line 929
  (text), line 932 (text), line 935 (text), line 938 (text), line 941 (text), line 944 (text), line 947 (text), line 950 (text), line 971
  (text), line 974 (text), line 977 (text), line 979 (text), line 981 (text), line 984 (text), line 986 (text), line 988 (text), line 991
  (text), line 994 (text), line 999 (text) and line 1050 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line
  72 (text), line 77 (text), line 176 (text), line 200 (text), line 295 (text), line 351 (text), line 352 (text), line 354 (text), line 356
  (text), line 358 (text), line 359 (text), line 360 (text), line 367 (text), line 407 (text), line 409 (text), line 592 (text), line 594
  (text), line 650 (text), line 652 (text), line 653 (text), line 658 (text), line 672 (text), line 674 (text), line 676 (text), line 678
  (text), line 680 (text), line 691 (text), line 692 (text), line 764 (text), line 781 (text), line 800 (text), line 806 (text), line 808
  (text), line 814 (text), line 821 (text), line 824 (text), line 826 (text), line 828 (text), line 830 (text), line 952 (text), line 954
  (text), line 956 (text), line 958 (text), line 959 (text), line 961 (text), line 963 (text), line 965 (text), line 966 (text), line 972
  (text), line 982 (text), line 985 (text), line 989 (text), line 992 (text), line 1001 (text), line 1005 (text), line 1008 (text), line
  1010 (text), line 1012 (text), line 1015 (text), line 1055 (text), line 1069 (text) and line 1077 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md][237]: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 8 (text), line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 362 (text), line
  364 (text), line 366 (text), line 369 (text), line 371 (text), line 393 (text), line 396 (text), line 398 (text), line 400 (text), line
  403 (text), line 406 (text), line 408 (text), line 411 (text), line 414 (text), line 419 (text), line 480 (text), line 558 (text), line
  561 (text), line 564 (text), line 567 (text), line 570 (text), line 573 (text), line 576 (text), line 580 (text), line 583 (text), line
  586 (text), line 589 (text), line 592 (text), line 595 (text), line 598 (text), line 601 (text), line 604 (text), line 607 (text), line
  610 (text), line 613 (text), line 616 (text), line 619 (text), line 622 (text), line 625 (text), line 628 (text), line 631 (text), line
  634 (text), line 637 (text), line 640 (text), line 643 (text), line 646 (text), line 649 (text), line 652 (text), line 656 (text), line
  659 (text), line 662 (text), line 665 (text), line 668 (text), line 671 (text), line 674 (text), line 849 (text), line 851 (text), line
  853 (text), line 855 (text), line 858 (text), line 859 (text), line 862 (text), line 869 (text), line 871 (text), line 1079 (text), line
  1120 (text), line 1239 (text), line 1317 (text) and line 1324 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8
  (text), line 74 (text), line 76 (text), line 120 (text), line 286 (text), line 288 (text), line 358 (text), line 364 (text), line 366
  (text), line 372 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text), line 388 (text), line 402 (text), line 404
  (text), line 409 (text), line 413 (text), line 421 (text), line 425 (text), line 429 (text), line 431 (text), line 433 (text), line 436
  (text), line 481 (text), line 484 (text), line 752 (text), line 755 (text), line 756 (text), line 759 (text), line 762 (text), line 764
  (text), line 766 (text), line 773 (text), line 814 (text), line 986 (text), line 988 (text), line 990 (text), line 992 (text), line 994
  (text), line 1033 (text), line 1056 (text), line 1058 (text), line 1060 (text), line 1062 (text), line 1064 (text), line 1066 (text), line
  1068 (text), line 1070 (text), line 1072 (text), line 1121 (text), line 1127 (text), line 1169 (text), line 1172 (text), line 1173 (text),
  line 1228 (text), line 1236 (text), line 1245 (text), line 1265 (text), line 1304 (text), line 1306 (text) and line 1318 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][238]: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][239]: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][240]: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line 35
  (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md][241]: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49
  (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][242]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][243]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][244]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md][245]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][246]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][247]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][248]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md][249]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][250]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][251]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][252]: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line
  35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md][253]: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line
  49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][254]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][255]: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][256]: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line
  35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md][257]: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line
  49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][258]: selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 28 (text) and line 28 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][259]: selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][260]: selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 33 (text), line 288 (text), line 786 (text), line 806 (text), line 818
  (text), line 847 (text), line 949 (text), line 951 (text), line 953 (text), line 955 (text), line 957 (text), line 959 (text), line 961
  (text), line 963 (text), line 965 (text) and line 1000 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][261]: selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 117 (text), line 465 (text), line 493 (text), line 501 (text), line 539
  (text), line 703 (text), line 1078 (text), line 1080 (text), line 1082 (text), line 1084 (text), line 1086 (text), line 1088 (text), line
  1090 (text), line 1248 (text), line 1293 (text) and line 1333 (text).
- [docs/adr/automation/BCL/index.md][262]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][2]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][263]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][264]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][265]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][266]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][267]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/controlling-systemwide-deps.md][268]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][269]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][270]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][271]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][272]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][273]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][274]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][275]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][276]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][277]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/test-artifacts.md][278]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][279]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][280]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][281]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][282]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][283]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][284]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][285]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/protected-globs.md][286]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][287]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][288]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][289]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][290]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][291]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/spell-out-names.md][292]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][293]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][294]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][295]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][296]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][297]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][298]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/design/commit-lifecycle.md][299]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][300]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][301]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][3]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][302]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][303]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][304]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/tracks.md][305]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][306]: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][307]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text); selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 155 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 94 (text); selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 53 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 15 (text) and line
  178 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 292 (text).
- [docs/adr/principles/configure-not-program.md][308]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the
  ADR domain of that code.
- [docs/adr/principles/dora-explains.md][309]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR domain
  of that code.
- [docs/adr/principles/everything-as-code.md][310]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR
  domain of that code.
- [docs/adr/principles/one-living-version.md][4]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR
  domain of that code.
- [docs/adr/principles/poka-yoke.md][311]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR domain of
  that code.
- [docs/adr/principles/reduce-variability.md][312]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR
  domain of that code.
- [docs/adr/principles/reduce-waste.md][313]: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/announce-state-changes.md][314]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/assert-idioms.md][315]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][316]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][317]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/cross-platform-powershell.md][318]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/dora-explains.md][319]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][320]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/environment-variable-mechanics.md][321]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/error-handling.md][5]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][322]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/identifier-names.md][323]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/index.md][324]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][325]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/one-function-per-file.md][326]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/parameter-design.md][327]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/pester-testing.md][328]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/powershell-formatting.md][329]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][330]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][331]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][332]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/pwsh-engine.md][333]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][334]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/script-scope-caching.md][335]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][336]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][337]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/pwsh/working-directory-mechanics.md][338]: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/agent-definitions.md][339]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/api-contracts.md][340]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/controlled-vocabulary.md][341]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][342]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][343]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][344]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][345]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][346]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/generated-readmes.md][347]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/generated-root-configs.md][6]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/inspiration.md][348]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/markdown-links.md][349]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/output-formats.md][350]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/repo-variants.md][351]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/uniform-formatting.md][352]: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/explanation/automation/build-then-place-with-one-command.md][353]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][354]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][355]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][356]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][357]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 47 (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][358]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 18
  (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][359]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15
  (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 15 (text), line 50
  (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][360]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 45 (text) and line 68 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 41 (text), line 51
  (text), line 66 (text), line 69 (text) and line 73 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 33 (text) and line
  61 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 35 (text) and line 62 (text); selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 33 (text), line 44 (text), line 60 (text) and line 67 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][361]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 18
  (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][362]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 16 (text),
  line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text);
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 16 (text), line 42 (text), line 57 (text), line 63 (text) and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][363]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (text), line
  60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][364]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][365]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][366]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 14
  (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][367]: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (text), line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][368]: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 32
  (text).
- [docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md][369]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 30
  (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][370]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 72 (text).
- [docs/how-to/getting-started/automation/powershell/add-a-function.md][371]: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 111
  (text), line 114 (text), line 120 (text) and line 121 (text).
- [docs/references/automation/catzc-base-languages.md][372]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 10 (text).
- [docs/references/automation/catzc-base-rootconfig.md][373]: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 43 (text) and
  line 52 (text).
- [docs/references/automation/catzc-base-typessystem.md][374]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 37 (text).
- [docs/references/automation/internal/catzc-internal-importer.md][375]: selected by [ADR-AUTO-TYPES][2]: the file cites it at line 36
  (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][376]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][8]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [importer.ps1][377]: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner module's files (files.yml), which
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

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][376]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][378]). Lit ([ADR-DSGN-TRACK#12][9]) by:

- [.gitattributes][379]: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][380]: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][381]
- [track][382]
- [file language][383]
- [cell][384]
- [lit cell][385]
- [root file][386]
- [unlisted file][387]
- [.claude][388]: a track
- [.github][388]: a track
- [automation][388]: a track
- [docs][388]: a track
- [csharp][389]: a file language
- [markdown][389]: a file language
- [powershell][389]: a file language
- [yaml][389]: a file language

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
[133]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[134]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[135]: ../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[136]: ../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[137]: ../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[138]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[139]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[140]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[141]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[142]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[143]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[144]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[145]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[146]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[147]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[148]: ../../../automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
[149]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[150]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[151]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[152]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[153]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[154]: ../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[155]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
[156]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
[157]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[158]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[159]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[160]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1
[161]: ../../../automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1
[162]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[163]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[164]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[165]: ../../../automation/Catzc.Base.Repository/Get-SessionActor.ps1
[166]: ../../../automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
[167]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[168]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[169]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[170]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[171]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[172]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[173]: ../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[174]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[175]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[176]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[177]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[178]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[179]: ../../../automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
[180]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[181]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[182]: ../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[183]: ../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[184]: ../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[185]: ../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[186]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[187]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[188]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[189]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[190]: ../../../automation/Catzc.Base.Git/configs/gitignore.yml
[191]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[192]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[193]: ../../../automation/Catzc.Base.RootConfig/configs/rootconfig.yml
[194]: ../../../automation/Catzc.Base.VSCode/configs/vscode-extensions.yml
[195]: ../../../automation/Catzc.Base.VSCode/configs/vscode-launch.yml
[196]: ../../../automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
[197]: ../../../automation/Catzc.Base.VSCode/configs/vscode-settings.yml
[198]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[199]: adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
[200]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[201]: adr-auto-bundle--build-then-place-with-one-command--operations.tree.md
[202]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[203]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
[204]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[205]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md
[206]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[207]: adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
[208]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[209]: adr-auto-bundle--dot-source-one-entry-script--operations.tree.md
[210]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[211]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[212]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[213]: adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
[214]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[215]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
[216]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[217]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md
[218]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[219]: adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
[220]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[221]: adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md
[222]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[223]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[224]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[225]: adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md
[226]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[227]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[228]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[229]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md
[230]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[231]: adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
[232]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[233]: adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md
[234]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[235]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[236]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[237]: adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
[238]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[239]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[240]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[241]: adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md
[242]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[243]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[244]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[245]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md
[246]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[247]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[248]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[249]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
[250]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[251]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[252]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[253]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
[254]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[255]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[256]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[257]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md
[258]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[259]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[260]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[261]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[262]: ../../adr/automation/BCL/index.md
[263]: ../../adr/automation/avoid-deep-nesting.md
[264]: ../../adr/automation/bash/bash-test-artifacts.md
[265]: ../../adr/automation/caching.md
[266]: ../../adr/automation/console-output-matters.md
[267]: ../../adr/automation/controlling-module-dependencies.md
[268]: ../../adr/automation/controlling-systemwide-deps.md
[269]: ../../adr/automation/cross-platform.md
[270]: ../../adr/automation/devbox-pipeline-parity.md
[271]: ../../adr/automation/dora-explains.md
[272]: ../../adr/automation/dry-run.md
[273]: ../../adr/automation/effective-in-enterprises.md
[274]: ../../adr/automation/environment-variables.md
[275]: ../../adr/automation/execution-engines.md
[276]: ../../adr/automation/fail-fast-with-asserts.md
[277]: ../../adr/automation/go/index.md
[278]: ../../adr/automation/go/test-artifacts.md
[279]: ../../adr/automation/idempotent-state-functions.md
[280]: ../../adr/automation/internal-asset-dependencies.md
[281]: ../../adr/automation/log-before-invoke.md
[282]: ../../adr/automation/managed-guids.md
[283]: ../../adr/automation/never-depend-on-pwd.md
[284]: ../../adr/automation/open-closed-architecture.md
[285]: ../../adr/automation/path-representation.md
[286]: ../../adr/automation/protected-globs.md
[287]: ../../adr/automation/python/index.md
[288]: ../../adr/automation/python/python-test-artifacts.md
[289]: ../../adr/automation/retry-as-last-resort.md
[290]: ../../adr/automation/sensible-defaults.md
[291]: ../../adr/automation/single-responsibility-functions.md
[292]: ../../adr/automation/spell-out-names.md
[293]: ../../adr/automation/test-automation.md
[294]: ../../adr/automation/tool-removal-lifecycle.md
[295]: ../../adr/automation/tracked-files-from-the-index.md
[296]: ../../adr/automation/use-proper-package-managers.md
[297]: ../../adr/automation/uv-python-handler.md
[298]: ../../adr/automation/zero-ceremony-poka-yoke.md
[299]: ../../adr/design/commit-lifecycle.md
[300]: ../../adr/design/dora-explains.md
[301]: ../../adr/design/module-aspects.md
[302]: ../../adr/design/self-service.md
[303]: ../../adr/design/server-remote-integration.md
[304]: ../../adr/design/thin-platforms.md
[305]: ../../adr/design/tracks.md
[306]: ../../adr/design/visual-design.md
[307]: ../../adr/index.md
[308]: ../../adr/principles/configure-not-program.md
[309]: ../../adr/principles/dora-explains.md
[310]: ../../adr/principles/everything-as-code.md
[311]: ../../adr/principles/poka-yoke.md
[312]: ../../adr/principles/reduce-variability.md
[313]: ../../adr/principles/reduce-waste.md
[314]: ../../adr/pwsh/announce-state-changes.md
[315]: ../../adr/pwsh/assert-idioms.md
[316]: ../../adr/pwsh/automatic-variable-pitfalls.md
[317]: ../../adr/pwsh/avoid-using-semicolons.md
[318]: ../../adr/pwsh/cross-platform-powershell.md
[319]: ../../adr/pwsh/dora-explains.md
[320]: ../../adr/pwsh/dynamic-module-manifests.md
[321]: ../../adr/pwsh/environment-variable-mechanics.md
[322]: ../../adr/pwsh/hosting-csharp-types.md
[323]: ../../adr/pwsh/identifier-names.md
[324]: ../../adr/pwsh/index.md
[325]: ../../adr/pwsh/module-path-hygiene.md
[326]: ../../adr/pwsh/one-function-per-file.md
[327]: ../../adr/pwsh/parameter-design.md
[328]: ../../adr/pwsh/pester-testing.md
[329]: ../../adr/pwsh/powershell-formatting.md
[330]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[331]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[332]: ../../adr/pwsh/prepost-extension-modules.md
[333]: ../../adr/pwsh/pwsh-engine.md
[334]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[335]: ../../adr/pwsh/script-scope-caching.md
[336]: ../../adr/pwsh/use-ps1-not-psm1.md
[337]: ../../adr/pwsh/vendor-toolset-dependencies.md
[338]: ../../adr/pwsh/working-directory-mechanics.md
[339]: ../../adr/repository/agent-definitions.md
[340]: ../../adr/repository/api-contracts.md
[341]: ../../adr/repository/controlled-vocabulary.md
[342]: ../../adr/repository/conventional-folders.md
[343]: ../../adr/repository/dedicated-output-directory.md
[344]: ../../adr/repository/documentation-examples.md
[345]: ../../adr/repository/domain-language-separation.md
[346]: ../../adr/repository/dora-explains.md
[347]: ../../adr/repository/generated-readmes.md
[348]: ../../adr/repository/inspiration.md
[349]: ../../adr/repository/markdown-links.md
[350]: ../../adr/repository/output-formats.md
[351]: ../../adr/repository/repo-variants.md
[352]: ../../adr/repository/uniform-formatting.md
[353]: ../../explanation/automation/build-then-place-with-one-command.md
[354]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[355]: ../../explanation/automation/dot-source-one-entry-script.md
[356]: ../../explanation/automation/every-code-root-is-a-copy.md
[357]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[358]: ../../explanation/automation/invoke-importer-in-code-order.md
[359]: ../../explanation/automation/one-commit-one-immutable-package.md
[360]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[361]: ../../explanation/automation/two-entries-feed-one-importer.md
[362]: ../../explanation/automation/what-gates-each-bundle-stage.md
[363]: ../../explanation/design/one-entry-script-per-mode.md
[364]: ../../explanation/design/shims-set-roots-mode-read-back.md
[365]: ../../explanation/design/two-roots-one-importer-same-modules.md
[366]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[367]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[368]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[369]: ../../how-to/getting-started/automation/BCL/add-a-dotnet-type.md
[370]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[371]: ../../how-to/getting-started/automation/powershell/add-a-function.md
[372]: ../../references/automation/catzc-base-languages.md
[373]: ../../references/automation/catzc-base-rootconfig.md
[374]: ../../references/automation/catzc-base-typessystem.md
[375]: ../../references/automation/internal/catzc-internal-importer.md
[376]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[377]: ../../../importer.ps1
[378]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[379]: ../../../.gitattributes
[380]: ../../../.gitignore
[381]: ../../adr/glossary.md#world-map
[382]: ../../adr/glossary.md#track
[383]: ../../adr/glossary.md#file-language
[384]: ../../adr/glossary.md#cell
[385]: ../../adr/glossary.md#lit-cell
[386]: ../../adr/glossary.md#root-file
[387]: ../../adr/glossary.md#unlisted-file
[388]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[389]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

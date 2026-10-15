# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md

`Tree minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Tree minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.png)

The tree minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5] and [ADR-REPO-ROOTCFG][6]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 218 files in 39 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Docs (automation/Catzc.Base.Docs): 30 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 20 lit files
- Maps (automation/Catzc.Base.Maps): 16 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 16 lit files
- Languages (automation/Catzc.Base.Languages): 12 lit files
- VSCode (automation/Catzc.Base.VSCode): 12 lit files
- Exporter (automation/Catzc.Base.Exporter): 11 lit files
- Azure (automation/Catzc.Azure): 9 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 8 lit files
- docs (docs/ outside docs/adr/): 7 lit files
- Contracts (automation/Catzc.Base.Contracts): 6 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 5 lit files
- Repository (automation/Catzc.Base.Repository): 5 lit files
- .internal (automation/.internal): 4 lit files
- Reports (automation/Catzc.Base.Reports): 4 lit files
- Root files: 3 lit files
- Git (automation/Catzc.Base.Git): 3 lit files
- Variants (automation/Catzc.Base.Variants): 3 lit files
- Vendor (automation/Catzc.Base.Vendor): 3 lit files
- adr/auto (docs/adr/automation): 3 lit files
- .claude: 2 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 2 lit files
- Files (automation/Catzc.Base.Files): 2 lit files
- Objects (automation/Catzc.Base.Objects): 2 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 2 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 2 lit files
- Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/prin (docs/adr/principles): 2 lit files
- adr/pwsh (docs/adr/pwsh): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- .github: 1 lit file
- .scriptanalyzer (automation/.scriptanalyzer): 1 lit file
- Az.DevOps (automation/Catzc.Azure.DevOps): 1 lit file
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Docs (automation/Catzc.Base.Docs, 30 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][7], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1][8], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 21 (header).
- [automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1][9], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 3 (header) and line 24 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][10], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 161 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 167 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 101 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text); selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 192 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 314 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][11], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][12], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][13], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][14], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 1 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][15], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][4]:
  the file cites it at line 4 (text).
- [automation/Catzc.Base.Docs/types/AdrCheck.cs][16], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][17], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChange.cs][18], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs][19], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationMap.cs][20], in the cell automation × csharp: selected by [ADR-PWSH-ERROR][5]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs][21], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][22], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/types/AdrDomainEdge.cs][23], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrDoraCheck.cs][24], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrNeutralityCheck.cs][25], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrNeutralityToken.cs][26], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][27], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][28], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Docs/types/AgentEntry.cs][29], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][30], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 8 (header).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][31], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][4]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryAvoid.cs][32], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][33], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.Docs/types/GlossaryEntry.cs][34], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Docs/types/GlossaryOptions.cs][35], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryRealization.cs][36], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).

### QualityGates (automation/Catzc.Base.QualityGates, 20 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][37], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the
  file cites it at line 65 (header), line 117 (header) and line 117 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][38], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][39], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][40], in the cell automation × yaml: selected by [ADR-PWSH-ERROR][5]: the
  file cites it at line 18 (text), line 18 (body comment) and line 35 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][41], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 596 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 576 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 616 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][42], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1][43], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 7 (header) and line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1][44], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 81 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][45], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][46], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs][47], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81 (text).
- [automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs][48], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 14 (header).
- [automation/Catzc.Base.QualityGates/types/GuidsConfig.cs][49], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][50], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 16 (header).
- [automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs][51], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][52], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/types/SourceCheck.cs][53], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 13 (header).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][54], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.QualityGates/types/SpellingOracle.cs][55], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][56], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).

### Maps (automation/Catzc.Base.Maps, 16 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/types/CitationSite.cs][57], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/HighlightReason.cs][58], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/HighlightedCell.cs][59], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][60], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.Maps/types/MapPlacement.cs][61], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][62], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][63], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 9 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][64], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][65], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][66], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPin.cs][67], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Maps/types/TreemapRect.cs][68], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][69], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][70], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][71], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 28 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][72], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 10 (header).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 16 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][73], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 29 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][74], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][75], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][76], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][77], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][78], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][79], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 23 (header) and line 109 (body comment); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][80], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1][81], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 35 (text) and line 113 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][82], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs][83], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/types/BaseModule.cs][84], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][85], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs][86], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs][87], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs][88], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header).

### Languages (automation/Catzc.Base.Languages, 12 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][89], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 25 (header).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][90], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][91], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][92], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FormatterEngine.cs][93], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][94], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][95], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs][96], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 2 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][97], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][98], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][99], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs][100], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).

### VSCode (automation/Catzc.Base.VSCode, 12 lit files)

The group holds the files of automation/Catzc.Base.VSCode; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][101], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][102], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][103], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 18 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][104], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-extensions.yml][105], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-launch.yml][106], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml][107], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-settings.yml][108], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs][109], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs][110], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 2 (header).
- [automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs][111], in the cell automation × csharp: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs][112], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 9 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).

### Exporter (automation/Catzc.Base.Exporter, 11 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][113], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][114], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][115], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][116], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][117], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][118], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][119], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][120], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][121], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][122], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterPackage.cs][123], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Azure (automation/Catzc.Azure, 9 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][124], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Azure/types/AzureCustomer.cs][125], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][126], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][127], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][128], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Azure/types/CustomerConfig.cs][129], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/NetworkConfig.cs][130], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Azure/types/NetworkEnvironment.cs][131], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/NetworkSubscription.cs][132], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).

### TypesSystem (automation/Catzc.Base.TypesSystem, 9 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][133], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][134], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][135], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 12 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][136], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][137], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][138], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 19 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1][139], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][140], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 4 (text).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][141], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 8 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][142], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 24 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 21 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][143], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][144], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.RootConfig/configs/rootconfig.yml][145], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][146], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 16 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][147], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][148], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][149], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 6 (header).

### docs (docs/ outside docs/adr/, 7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md][150], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 30 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][151], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 72 (text).
- [docs/how-to/getting-started/automation/powershell/add-a-function.md][152], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 111 (text), line 114 (text), line 120 (text) and line 121 (text).
- [docs/references/automation/catzc-base-languages.md][153], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 10 (text).
- [docs/references/automation/catzc-base-rootconfig.md][154], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 43 (text) and line 52 (text).
- [docs/references/automation/catzc-base-typessystem.md][155], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 37 (text).
- [docs/references/automation/internal/catzc-internal-importer.md][156], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 36 (text).

### Contracts (automation/Catzc.Base.Contracts, 6 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][157], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).
- [automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1][158], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header) and line 23 (text).
- [automation/Catzc.Base.Contracts/types/ContractAsset.cs][159], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractCheckResult.cs][160], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractManifest.cs][161], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][162], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 20 (header).

### Az.Templates (automation/Catzc.Azure.Templates, 5 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][163], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 103 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][164], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 133 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepParameter.cs][165], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header) and line 8 (header).
- [automation/Catzc.Azure.Templates/types/BicepParameterModel.cs][166], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][167], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).

### Repository (automation/Catzc.Base.Repository, 5 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][168], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][169], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][170], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-SessionActor.ps1][171], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1][172], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 1 (text).

### .internal (automation/.internal, 4 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][173], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 5 (header).
- [automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1][174], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header) and line 9 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][175], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][176], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 2 (header), line 17 (text), line 38 (text) and line 75 (text).

### Reports (automation/Catzc.Base.Reports, 4 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/types/OutputFormat.cs][177], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs][178], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/types/OutputPattern.cs][179], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 67 (body comment) (a passing mention only).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][180], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][181], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][182], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [importer.ps1][183], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1` line 4 (header), `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1`
  line 9 (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 2 (header),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 17 (text),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 38 (text) and
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 75 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Git (automation/Catzc.Base.Git, 3 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/New-GitIgnore.ps1][184], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 17 (header).
- [automation/Catzc.Base.Git/configs/gitignore.yml][185], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][186], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 6 (header).

### Variants (automation/Catzc.Base.Variants, 3 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/types/VariantAspect.cs][187], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][188], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][189], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Vendor (automation/Catzc.Base.Vendor, 3 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][190], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][191], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 18 (header).
- [automation/Catzc.Base.Vendor/types/VendorConfig.cs][192], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).

### adr/auto (docs/adr/automation, 3 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/native-csharp-types.md][2], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][193], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 421
  (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 529 (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][194], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 57 (text) and line
  122 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 30 (text).
- [.claude/agents/build-inspiration-module.md][195], in the cell .claude × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 25 (text).

### Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation, 2 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][196], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][197], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).

### Files (automation/Catzc.Base.Files, 2 lit files)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/Set-FileLink.ps1][198], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 17 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][199], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 20 (header).

### Objects (automation/Catzc.Base.Objects, 2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][200], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][201], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (text).

### Timeouts (automation/Catzc.Base.Timeouts, 2 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][202], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][203], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Tool.Inspiration (automation/Catzc.Tooling.Inspiration, 2 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][204], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs][205], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 4 (header).

### Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler, 2 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs][206], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs][207], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][208], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 125
  (text).
- [docs/adr/design/run-modes.md][3], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the ADR's own file.

### adr/prin (docs/adr/principles, 2 lit files)

The group holds the files of docs/adr/principles; each sits in its world-map cell and is lit by:

- [docs/adr/principles/dora-explains.md][209], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 86
  (text).
- [docs/adr/principles/one-living-version.md][4], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: the ADR's own file.

### adr/pwsh (docs/adr/pwsh, 2 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/dora-explains.md][210], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: the file cites it at line 128 (text).
- [docs/adr/pwsh/error-handling.md][5], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: the ADR's own file.

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][211], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 115
  (text).
- [docs/adr/repository/generated-root-configs.md][6], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the ADR's own file.

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][212], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### .scriptanalyzer (automation/.scriptanalyzer, 1 lit file)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1][213], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 3 (text).

### Az.DevOps (automation/Catzc.Azure.DevOps, 1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/types/AdoConfig.cs][214], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).

### ConfigExtensions (automation/Catzc.Base.ConfigExtensions, 1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][215], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][216], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][217], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 29 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][218], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 149 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 155 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 94 (text);
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 53 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 15
  (text) and line 178 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 292 (text).

## Keywords

- [world map][219]
- [track][220]
- [file language][221]
- [cell][222]
- [lit cell][223]
- [root file][224]
- [unlisted file][225]
- [.claude][226]: a track
- [.github][226]: a track
- [automation][226]: a track
- [docs][226]: a track
- [csharp][227]: a file language
- [markdown][227]: a file language
- [powershell][227]: a file language
- [yaml][227]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/native-csharp-types.md
[3]: ../../adr/design/run-modes.md
[4]: ../../adr/principles/one-living-version.md
[5]: ../../adr/pwsh/error-handling.md
[6]: ../../adr/repository/generated-root-configs.md
[7]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[8]: ../../../automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1
[9]: ../../../automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
[10]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[12]: ../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[13]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[14]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[15]: ../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[16]: ../../../automation/Catzc.Base.Docs/types/AdrCheck.cs
[17]: ../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[18]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChange.cs
[19]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
[20]: ../../../automation/Catzc.Base.Docs/types/AdrCitationMap.cs
[21]: ../../../automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
[22]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[23]: ../../../automation/Catzc.Base.Docs/types/AdrDomainEdge.cs
[24]: ../../../automation/Catzc.Base.Docs/types/AdrDoraCheck.cs
[25]: ../../../automation/Catzc.Base.Docs/types/AdrNeutralityCheck.cs
[26]: ../../../automation/Catzc.Base.Docs/types/AdrNeutralityToken.cs
[27]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[28]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[29]: ../../../automation/Catzc.Base.Docs/types/AgentEntry.cs
[30]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[31]: ../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[32]: ../../../automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
[33]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[34]: ../../../automation/Catzc.Base.Docs/types/GlossaryEntry.cs
[35]: ../../../automation/Catzc.Base.Docs/types/GlossaryOptions.cs
[36]: ../../../automation/Catzc.Base.Docs/types/GlossaryRealization.cs
[37]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[38]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[39]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[40]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[41]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[42]: ../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[43]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
[44]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
[45]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[46]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[47]: ../../../automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
[48]: ../../../automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
[49]: ../../../automation/Catzc.Base.QualityGates/types/GuidsConfig.cs
[50]: ../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[51]: ../../../automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
[52]: ../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[53]: ../../../automation/Catzc.Base.QualityGates/types/SourceCheck.cs
[54]: ../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[55]: ../../../automation/Catzc.Base.QualityGates/types/SpellingOracle.cs
[56]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[57]: ../../../automation/Catzc.Base.Maps/types/CitationSite.cs
[58]: ../../../automation/Catzc.Base.Maps/types/HighlightReason.cs
[59]: ../../../automation/Catzc.Base.Maps/types/HighlightedCell.cs
[60]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[61]: ../../../automation/Catzc.Base.Maps/types/MapPlacement.cs
[62]: ../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[63]: ../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[64]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[65]: ../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[66]: ../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[67]: ../../../automation/Catzc.Base.Maps/types/MapsPin.cs
[68]: ../../../automation/Catzc.Base.Maps/types/TreemapRect.cs
[69]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[70]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[71]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[72]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[73]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[74]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[75]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[76]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[77]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[78]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[79]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[80]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[81]: ../../../automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
[82]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[83]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
[84]: ../../../automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
[85]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[86]: ../../../automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs
[87]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
[88]: ../../../automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
[89]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[90]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[91]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[92]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[93]: ../../../automation/Catzc.Base.Languages/types/FormatterEngine.cs
[94]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[95]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[96]: ../../../automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
[97]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[98]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[99]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[100]: ../../../automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
[101]: ../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[102]: ../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[103]: ../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[104]: ../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[105]: ../../../automation/Catzc.Base.VSCode/configs/vscode-extensions.yml
[106]: ../../../automation/Catzc.Base.VSCode/configs/vscode-launch.yml
[107]: ../../../automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
[108]: ../../../automation/Catzc.Base.VSCode/configs/vscode-settings.yml
[109]: ../../../automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
[110]: ../../../automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
[111]: ../../../automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
[112]: ../../../automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
[113]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[114]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[115]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[116]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[117]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[118]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[119]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[120]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[121]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[122]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[123]: ../../../automation/Catzc.Base.Exporter/types/ExporterPackage.cs
[124]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[125]: ../../../automation/Catzc.Azure/types/AzureCustomer.cs
[126]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[127]: ../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[128]: ../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[129]: ../../../automation/Catzc.Azure/types/CustomerConfig.cs
[130]: ../../../automation/Catzc.Azure/types/NetworkConfig.cs
[131]: ../../../automation/Catzc.Azure/types/NetworkEnvironment.cs
[132]: ../../../automation/Catzc.Azure/types/NetworkSubscription.cs
[133]: ../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[134]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[135]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[136]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[137]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[138]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[139]: ../../../automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
[140]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[141]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[142]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[143]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[144]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[145]: ../../../automation/Catzc.Base.RootConfig/configs/rootconfig.yml
[146]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[147]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[148]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[149]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[150]: ../../how-to/getting-started/automation/BCL/add-a-dotnet-type.md
[151]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[152]: ../../how-to/getting-started/automation/powershell/add-a-function.md
[153]: ../../references/automation/catzc-base-languages.md
[154]: ../../references/automation/catzc-base-rootconfig.md
[155]: ../../references/automation/catzc-base-typessystem.md
[156]: ../../references/automation/internal/catzc-internal-importer.md
[157]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[158]: ../../../automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
[159]: ../../../automation/Catzc.Base.Contracts/types/ContractAsset.cs
[160]: ../../../automation/Catzc.Base.Contracts/types/ContractCheckResult.cs
[161]: ../../../automation/Catzc.Base.Contracts/types/ContractManifest.cs
[162]: ../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[163]: ../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[164]: ../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[165]: ../../../automation/Catzc.Azure.Templates/types/BicepParameter.cs
[166]: ../../../automation/Catzc.Azure.Templates/types/BicepParameterModel.cs
[167]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[168]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[169]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[170]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[171]: ../../../automation/Catzc.Base.Repository/Get-SessionActor.ps1
[172]: ../../../automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
[173]: ../../../automation/.internal/assets/Import-Catzc.ps1
[174]: ../../../automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
[175]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[176]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[177]: ../../../automation/Catzc.Base.Reports/types/OutputFormat.cs
[178]: ../../../automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs
[179]: ../../../automation/Catzc.Base.Reports/types/OutputPattern.cs
[180]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[181]: ../../../.gitattributes
[182]: ../../../.gitignore
[183]: ../../../importer.ps1
[184]: ../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[185]: ../../../automation/Catzc.Base.Git/configs/gitignore.yml
[186]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[187]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[188]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[189]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[190]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[191]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[192]: ../../../automation/Catzc.Base.Vendor/types/VendorConfig.cs
[193]: ../../adr/automation/dora-explains.md
[194]: ../../../.claude/CLAUDE.md
[195]: ../../../.claude/agents/build-inspiration-module.md
[196]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[197]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[198]: ../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[199]: ../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[200]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[201]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[202]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[203]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[204]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[205]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
[206]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
[207]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
[208]: ../../adr/design/dora-explains.md
[209]: ../../adr/principles/dora-explains.md
[210]: ../../adr/pwsh/dora-explains.md
[211]: ../../adr/repository/dora-explains.md
[212]: ../../../.github/workflows/ci-automation.yml
[213]: ../../../automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1
[214]: ../../../automation/Catzc.Azure.DevOps/types/AdoConfig.cs
[215]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[216]: ../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[217]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[218]: ../../adr/index.md
[219]: ../../adr/glossary.md#world-map
[220]: ../../adr/glossary.md#track
[221]: ../../adr/glossary.md#file-language
[222]: ../../adr/glossary.md#cell
[223]: ../../adr/glossary.md#lit-cell
[224]: ../../adr/glossary.md#root-file
[225]: ../../adr/glossary.md#unlisted-file
[226]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[227]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

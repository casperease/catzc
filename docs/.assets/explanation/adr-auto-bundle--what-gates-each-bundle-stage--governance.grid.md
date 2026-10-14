# docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md

`Grid minimap: adr-auto-bundle--what-gates-each-bundle-stage--governance`

![Grid minimap of adr-auto-bundle--what-gates-each-bundle-stage--governance](adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.png)

The grid minimap of the slide `adr-auto-bundle--what-gates-each-bundle-stage--governance` (governance lens). The slide supports
[ADR-AUTO-ASSETDEP][1], [ADR-AUTO-BUNDLE][2], [ADR-AUTO-TEST][3] and [ADR-DSGN-RUNMODE][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 9 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 9 files
- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 11 lit of 219 files
- automation × powershell: 365 lit of 1400 files
- automation × yaml: 16 lit of 95 files
- docs × markdown: 162 lit of 741 files
- pipelines × pipeline-yaml: 1 lit of 9 files, touched
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.claude/CLAUDE.md][8]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 50 (text).
- [.claude/agents/catzc-worker.md][9]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 48 (text).
- [.claude/agents/test-optimization.md][10]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (text), line 21 (text), line 21
  (text), line 21 (text), line 22 (text), line 23 (text), line 52 (text), line 57 (text), line 58 (text), line 62 (text), line 62 (text),
  line 67 (text) and line 75 (text).

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.github/workflows/ci-automation.yml][11]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 48 (body comment) (a passing
  mention only).

### automation × csharp (11 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][12]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 40 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][13]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][14]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][15]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][16]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][17]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][18]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs][19]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][20]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][21]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Timeouts/types/TestTiers.cs][22]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 3
  (header).

### automation × powershell (365 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/.internal/assets/Import-Catzc.ps1][23]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 6 (header); selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 5 (header).
- [automation/.internal/tests/Import-AllModules.Tests.ps1][24]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 200 (body comment)
  (a passing mention only).
- [automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1][25]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1 (text) and line
  80 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][26]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][27]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/.internal/tests/Test-FolderConventions.Tests.ps1][28]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1][29]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 154
  (text).
- [automation/.scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1][30]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 54
  (text).
- [automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1][31]: selected by [ADR-AUTO-TEST][3]: the file
  cites it at line 13 (body comment) (a passing mention only).
- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][32]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 9 (header).
- [automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1][33]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 207 (body
  comment) (a passing mention only).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][34]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 44 (text)
  and line 53 (text).
- [automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1][35]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 10
  (header).
- [automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1][36]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 23
  (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][37]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8
  (header), line 10 (header) and line 13 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1][38]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 18
  (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1][39]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1][40]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 5 (body comment), line 5 (body comment) and line 36 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1][41]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 4 (body comment), line 4 (body comment), line 10 (body comment) and line 39 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1][42]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1][43]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1][44]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (body
  comment), line 5 (body comment), line 9 (body comment) and line 39 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1][45]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 34 (body comment), line 124 (body comment) and line 176 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1][46]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 46 (body
  comment), line 46 (body comment) and line 98 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1][47]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 6 (body comment), line 6 (body comment), line 11 (body comment) and line 51 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][48]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 9 (header), line 12 (header), line 15 (header), line 20 (header) and line 25 (body comment).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1][49]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1][50]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1][51]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1][52]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1][53]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1][54]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 5 (body comment) and line 5 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1][55]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 4 (body comment), line 4 (body comment), line 42 (body comment) and line 42 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1][56]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1][57]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment), line 4 (body comment), line 57 (body comment) and line 57 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1][58]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1][59]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][60]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1][61]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 43 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][62]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (body comment) (a passing mention only).
- [automation/Catzc.Azure/Test-AzureNetworkPlan.ps1][63]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1][64]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1][65]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1][66]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1][67]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1][68]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1][69]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1][70]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][71]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (body comment)
  and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1][72]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (body
  comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1][73]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1][74]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1][75]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body comment),
  line 15 (body comment), line 18 (body comment) and line 133 (body comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1][76]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 42
  (body comment) and line 43 (text).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][77]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 119 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][78]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1][79]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1][80]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][81]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Contracts/Test-Contracts.ps1][82]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1][83]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1][84]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1][85]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1][86]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1][87]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1][88]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header), line 7 (header), line 35 (text), line 55 (body comment), line 79 (text) and line 187 (body comment).
- [automation/Catzc.Base.Docs/Test-AdrRegistry.ps1][89]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1][90]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1][91]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][92]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 17 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][93]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1][94]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 18
  (header).
- [automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1][95]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 62 (body
  comment) and line 63 (text).
- [automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1][96]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1][97]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1][98]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1][99]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][100]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header) and
  line 42 (body comment).
- [automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1][101]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1][102]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 51 (body
  comment) and line 52 (text).
- [automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1][103]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1][104]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1][105]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header), line
  22 (text), line 23 (text) and line 27 (text).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1][106]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1][107]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1][108]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1][109]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1][110]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1][111]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1][112]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  5 (header) and line 17 (text).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1][113]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1][114]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1][115]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header), line 45 (text), line 104 (text) and line 115 (text).
- [automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1][116]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][117]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 47 (body
  comment), line 82 (body comment), line 83 (body comment) and line 96 (text).
- [automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1][118]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][119]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1][120]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1][121]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1][122]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header) and line 16 (text).
- [automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1][123]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header) and line 11 (text).
- [automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1][124]: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 6 (text).
- [automation/Catzc.Base.Execution/Invoke-Executable.ps1][125]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 107 (body comment)
  (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1][126]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1][127]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1][128]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 81
  (text) and line 81 (body comment).
- [automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1][129]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1][130]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1][131]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1][132]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1][133]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1][134]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (body comment), line 13 (body comment) and line 15 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][135]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][136]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 5 (header) and line
  54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][137]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][138]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][139]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][140]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][141]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1][142]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1][143]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1][144]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (body comment) and line 8 (body comment) (a passing mention only).
- [automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1][145]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][146]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 29 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][147]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][148]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 14
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][149]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 18 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][150]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][151]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1][152]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (body comment)
  (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][153]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 16 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][154]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1][155]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  2 (header), line 19 (text), line 30 (text) and line 42 (text).
- [automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1][156]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header), line 4 (header), line 18 (text), line 25 (text) and line 36 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1][157]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][158]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header), line 5 (header), line 29 (text), line 37 (text) and line 50 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1][159]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  2 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][160]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 32 (body
  comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1][161]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1][162]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  2 (header).
- [automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][163]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1][164]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1][165]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1][166]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1][167]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 17 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1][168]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][169]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][170]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][171]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][172]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][173]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][174]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header), line 7 (header), line 45 (text), line 74 (text), line 80 (text) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][175]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header),
  line 7 (header), line 53 (text), line 104 (text), line 111 (text) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][176]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][177]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][178]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][179]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][180]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][181]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 34 (body
  comment) (a passing mention only); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][182]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 5
  (header), line 20 (header) and line 209 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][183]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][184]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 17
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1][185]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][186]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][187]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 15
  (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1][188]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line
  6 (header), line 10 (header) and line 13 (header); selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1][189]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1][190]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1][191]: selected by [ADR-AUTO-ASSETDEP][1]: the file
  cites it at line 4 (header), line 7 (header), line 14 (header) and line 42 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 13 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1][192]: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 1 (header), line 5 (header), line 8 (text) and line 9 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1][193]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites
  it at line 2 (header) and line 89 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1][194]: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 2 (header), line 5 (header) and line 12 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1][195]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header) and line 92 (body comment).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1][196]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1][197]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header), line 31 (text), line 37 (text) and line 47 (text).
- [automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1][198]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites
  it at line 22 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1][199]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1][200]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header), line 19 (text) and line 31 (text).
- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][201]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][202]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1][203]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (header) and line 8 (header).
- [automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1][204]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 13 (header), line
  24 (header), line 28 (header), line 34 (header) and line 35 (header).
- [automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1][205]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][206]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 13 (header), line
  19 (header), line 21 (header), line 71 (header), line 87 (header), line 172 (body comment) and line 184 (body comment).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][207]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header) and
  line 7 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][208]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header), line
  16 (header) and line 36 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-Change.ps1][209]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1][210]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.QualityGates/Test-Formatting.ps1][211]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1][212]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/Test-Links.ps1][213]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 13 (header).
- [automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1][214]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header)
  and line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1][215]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1][216]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header)
  and line 10 (header).
- [automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1][217]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1][218]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1][219]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1][220]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 57 (body
  comment) (a passing mention only); selected by [ADR-AUTO-TEST][3]: the file cites it at line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][221]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1][222]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.QualityGates/Test-Spelling.ps1][223]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/Test-Terminology.ps1][224]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 23 (header).
- [automation/Catzc.Base.QualityGates/Test-TestTitles.ps1][225]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header) and
  line 10 (header).
- [automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1][226]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1][227]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (header) and line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1][228]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][229]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][230]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1][231]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1][232]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it
  at line 59 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1][233]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1][234]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  5 (header).
- [automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1][235]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line
  10 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1][236]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  6 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1][237]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it
  at line 16 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1][238]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1][239]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header), line 16 (header) and line 185 (body comment).
- [automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1][240]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 12 (header).
- [automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1][241]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it
  at line 15 (header); selected by [ADR-AUTO-TEST][3]: the file cites it at line 11 (header), line 39 (header) and line 137 (body comment).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1][242]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (header) and line 20 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][243]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1][244]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1][245]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  20 (header) and line 24 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1][246]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1][247]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  4 (header).
- [automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1][248]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1][249]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 14 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1][250]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1][251]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  6 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1][252]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 203
  (body comment) and line 207 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 1 (header), line 3 (header) and line 231
  (body comment).
- [automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1][253]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1][254]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  40 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1][255]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1][256]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 1 (text) and line 23 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1][257]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1][258]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1][259]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1][260]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1][261]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1][262]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1][263]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1][264]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1][265]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1][266]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 10 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1][267]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1][268]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1][269]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1][270]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  62 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1][271]: selected by [ADR-AUTO-ASSETDEP][1]: the file
  cites it at line 14 (body comment) and line 16 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1][272]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1][273]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 23
  (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1][274]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 21
  (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1][275]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1][276]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][277]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1][278]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1][279]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1][280]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  2 (text), line 2 (body comment), line 100 (text) and line 104 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1][281]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1][282]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1][283]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1][284]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1][285]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1][286]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1][287]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1][288]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 77
  (body comment), line 83 (body comment), line 127 (body comment) and line 132 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1][289]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 85
  (text), line 110 (text), line 183 (text), line 198 (text), line 198 (body comment) and line 238 (text).
- [automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1][290]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (header),
  line 13 (header) and line 15 (header).
- [automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1][291]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1][292]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1][293]: selected by [ADR-AUTO-ASSETDEP][1]: the file
  cites it at line 152 (body comment) and line 155 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 44 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1][294]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1][295]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (text) and line 13 (text).
- [automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1][296]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1][297]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1][298]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1][299]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1][300]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 16 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1][301]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1][302]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line
  39 (body comment) and line 45 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 2 (header) and line 18 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1][303]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header), line 57 (text), line 66 (text) and line 81 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][304]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][305]: selected by [ADR-DSGN-RUNMODE][4]: the file
  cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1][306]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1][307]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1][308]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header), line 4 (header), line 52 (text), line 56 (text) and line 74 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1][309]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header), line 3 (header), line 29 (body comment), line 37 (text) and line 79 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1][310]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header), line 23 (text), line 29 (text) and line 43 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1][311]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line
  63 (body comment) and line 69 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1][312]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header), line 5 (header), line 24 (body comment), line 29 (body comment) and line 42 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1][313]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1][314]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header), line 6 (header), line 7 (header), line 43 (text), line 47 (text) and line 52 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1][315]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1][316]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1][317]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 19
  (text), line 29 (text), line 39 (text), line 103 (body comment) and line 105 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1][318]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 1 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1][319]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header), line 3 (header), line 29 (text) and line 60 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1][320]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at
  line 88 (body comment) and line 96 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 37 (text), line 46 (text) and line 58
  (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1][321]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header), line 4 (header) and line 162 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][322]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1][323]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1][324]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 20
  (text), line 29 (text), line 43 (text), line 115 (body comment) and line 117 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1][325]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1][326]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header) and line 6 (header).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1][327]: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1][328]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1][329]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  35 (body comment) (a passing mention only).
- [automation/Catzc.Base.Reports/Write-QualityGateReport.ps1][330]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1][331]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header), line 4 (header), line 14 (text), line 24 (text), line 32 (text) and line 42 (text).
- [automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1][332]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (text), line 10 (text) and line 17 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][333]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][334]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 7 (header)
  and line 17 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][335]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1][336]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1][337]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][338]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 24 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][339]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][340]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1][341]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 138
  (body comment) and line 228 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1][342]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1][343]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1][344]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][345]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][346]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][347]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 30
  (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][348]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][349]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][350]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1][351]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][352]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header) and line 3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1][353]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][354]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header) and line 4 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1][355]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][356]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][357]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 18 (header).
- [automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1][358]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 13 (header).
- [automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1][359]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1][360]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1][361]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 81 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1][362]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 7
  (body comment) and line 52 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1][363]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1][364]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1][365]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  4 (text).
- [automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1][366]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 35 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1][367]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  82 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1][368]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1][369]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header).
- [automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1][370]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][371]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1][372]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1][373]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 7 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1][374]: selected by [ADR-AUTO-TEST][3]: the file cites
  it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1][375]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 3 (header) and line 4 (text).
- [automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1][376]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 45 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1][377]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1][378]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 5
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1][379]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header) and line 3 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1][380]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header) and line 4 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1][381]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1][382]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1][383]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1][384]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 96 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1][385]: selected by [ADR-AUTO-TEST][3]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1][386]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 3
  (header) and line 6 (text).
- [automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1][387]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3
  (header).

### automation × yaml (16 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Azure.DevOps/configs/identity-tokens.yml][388]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml][389]: selected by [ADR-AUTO-TEST][3]: the file cites it
  at line 7 (header).
- [automation/Catzc.Azure/configs/identity-tokens.yml][390]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][391]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 163 (text); selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 162 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 145 (text); selected
  by [ADR-DSGN-RUNMODE][4]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][392]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 57 (text), line 57 (body
  comment) and line 57 (body comment).
- [automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml][393]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header) and line 6 (text).
- [automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml][394]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1
  (header), line 8 (text) and line 16 (text).
- [automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml][395]: selected by [ADR-AUTO-TEST][3]: the file cites it at line
  5 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][396]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/configs/artifacts.yml][397]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][398]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 29
  (body comment) (a passing mention only); selected by [ADR-AUTO-TEST][3]: the file cites it at line 27 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][399]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 9 (text), line
  25 (text), line 34 (text), line 44 (text), line 71 (text), line 86 (text), line 109 (text), line 121 (text), line 131 (text), line 141
  (text), line 156 (text) and line 170 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][400]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 588
  (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 26 (header); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at
  line 590 (text).
- [automation/Catzc.Base.QualityGates/configs/test-policy.yml][401]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Reports/configs/reports.yml][402]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][403]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 120 (body
  comment) (a passing mention only).

### docs × markdown (162 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][404]: selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md][405]: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][406]: selected by [ADR-AUTO-BUNDLE][2]:
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
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md][407]: selected by [ADR-AUTO-BUNDLE][2]:
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
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][408]: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md][409]: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][410]: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text),
  line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70
  (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183
  (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md][411]: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text),
  line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197
  (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][412]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md][413]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][414]: selected by [ADR-AUTO-BUNDLE][2]: the
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
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.tree.md][415]: selected by [ADR-AUTO-BUNDLE][2]: the
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
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][416]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][417]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 70 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][418]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 31 (text), line 39 (text), line 40 (text), line 47 (text), line 52 (text), line 55 (text), line 56
  (text), line 58 (text), line 59 (text), line 60 (text), line 62 (text), line 105 (text), line 107 (text), line 115 (text), line 118
  (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 132 (text), line 134
  (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 161
  (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177
  (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 193
  (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209
  (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line 241
  (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 252 (text), line 254 (text), line 256 (text), line 259
  (text), line 262 (text), line 264 (text) and line 283 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line
  48 (text), line 49 (text), line 50 (text), line 54 (text), line 64 (text), line 65 (text), line 66 (text), line 68 (text), line 69 (text),
  line 71 (text), line 73 (text), line 74 (text), line 75 (text), line 77 (text), line 78 (text), line 79 (text), line 81 (text), line 83
  (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text),
  line 97 (text), line 98 (text), line 106 (text), line 108 (text), line 122 (text), line 128 (text), line 130 (text), line 135 (text), line
  137 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 225 (text), line 227 (text), line 229 (text), line
  231 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241 (text), line 250 (text), line
  253 (text), line 257 (text), line 260 (text), line 266 (text), line 267 (text), line 269 (text), line 271 (text), line 273 (text), line
  275 (text), line 284 (text), line 293 (text) and line 297 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md][419]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text),
  line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87
  (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text),
  line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 142 (text),
  line 144 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 165 (text), line 168 (text), line 170 (text),
  line 173 (text), line 176 (text), line 178 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text),
  line 208 (text), line 211 (text), line 212 (text), line 214 (text), line 303 (text), line 324 (text), line 333 (text), line 351 (text),
  line 365 (text) and line 386 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 131 (text), line 137
  (text), line 139 (text), line 144 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 164
  (text), line 166 (text), line 171 (text), line 175 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188
  (text), line 190 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233
  (text), line 235 (text), line 237 (text), line 244 (text), line 247 (text), line 248 (text), line 251 (text), line 253 (text), line 254
  (text), line 256 (text), line 259 (text), line 265 (text), line 267 (text), line 269 (text), line 272 (text), line 274 (text), line 281
  (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 295 (text), line 299 (text), line 305 (text), line 313
  (text), line 315 (text), line 317 (text), line 325 (text), line 327 (text), line 334 (text), line 335 (text), line 342 (text), line 344
  (text), line 359 (text), line 372 (text), line 379 (text) and line 387 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][420]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md][421]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][422]: selected by [ADR-AUTO-BUNDLE][2]: the
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
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md][423]: selected by [ADR-AUTO-BUNDLE][2]: the
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
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][424]: selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md][425]: selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 61 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][426]: selected by [ADR-AUTO-BUNDLE][2]:
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
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md][427]: selected by [ADR-AUTO-BUNDLE][2]:
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
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][428]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][429]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 69 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][430]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 7 (text), line 30 (text), line 38 (text), line 39 (text), line 46 (text), line 51 (text), line 54 (text), line 55
  (text), line 57 (text), line 58 (text), line 59 (text), line 61 (text), line 104 (text), line 106 (text), line 114 (text), line 117
  (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 131 (text), line 133
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160
  (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 176
  (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192
  (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208
  (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 240
  (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 251 (text), line 253 (text), line 255 (text), line 258
  (text), line 261 (text), line 263 (text) and line 282 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line
  47 (text), line 48 (text), line 49 (text), line 53 (text), line 63 (text), line 64 (text), line 65 (text), line 67 (text), line 68 (text),
  line 70 (text), line 72 (text), line 73 (text), line 74 (text), line 76 (text), line 77 (text), line 78 (text), line 80 (text), line 82
  (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text),
  line 96 (text), line 97 (text), line 105 (text), line 107 (text), line 121 (text), line 127 (text), line 129 (text), line 134 (text), line
  136 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 224 (text), line 226 (text), line 228 (text), line
  230 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 238 (text), line 240 (text), line 249 (text), line
  252 (text), line 256 (text), line 259 (text), line 265 (text), line 266 (text), line 268 (text), line 270 (text), line 272 (text), line
  274 (text), line 283 (text), line 292 (text) and line 296 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md][431]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 7 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52
  (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 124 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 141 (text),
  line 143 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 164 (text), line 167 (text), line 169 (text),
  line 172 (text), line 175 (text), line 177 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 210 (text), line 211 (text), line 213 (text), line 302 (text), line 323 (text), line 332 (text), line 350 (text),
  line 364 (text) and line 385 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 130 (text), line 136
  (text), line 138 (text), line 143 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 163
  (text), line 165 (text), line 170 (text), line 174 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232
  (text), line 234 (text), line 236 (text), line 243 (text), line 246 (text), line 247 (text), line 250 (text), line 252 (text), line 253
  (text), line 255 (text), line 258 (text), line 264 (text), line 266 (text), line 268 (text), line 271 (text), line 273 (text), line 280
  (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 294 (text), line 298 (text), line 304 (text), line 312
  (text), line 314 (text), line 316 (text), line 324 (text), line 326 (text), line 333 (text), line 334 (text), line 341 (text), line 343
  (text), line 358 (text), line 371 (text), line 378 (text) and line 386 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][432]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 68 (text), line 68 (text), line 79 (text) and line 79 (text); selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (text), line 38 (text), line 38 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][433]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 56 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 56 (text) and line 64
  (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][434]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 41 (text), line 90 (text), line 92 (text), line 178 (text), line 192 (text), line 205 (text), line
  206 (text), line 208 (text), line 209 (text), line 210 (text), line 212 (text), line 309 (text), line 313 (text), line 334 (text), line
  336 (text), line 337 (text), line 339 (text), line 341 (text), line 344 (text), line 345 (text), line 347 (text), line 352 (text), line
  354 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line
  384 (text), line 386 (text), line 388 (text), line 390 (text), line 392 (text), line 394 (text), line 396 (text), line 398 (text), line
  400 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 410 (text), line 412 (text), line 414 (text), line
  416 (text), line 418 (text), line 420 (text), line 422 (text), line 424 (text), line 426 (text), line 428 (text), line 430 (text), line
  432 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445 (text), line 447 (text), line
  465 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 569 (text), line 571 (text), line 573 (text), line
  576 (text), line 582 (text), line 584 (text) and line 616 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text),
  line 179 (text), line 182 (text), line 190 (text), line 201 (text), line 217 (text), line 220 (text), line 221 (text), line 224 (text),
  line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 242 (text), line 244 (text), line 253 (text),
  line 255 (text), line 261 (text), line 262 (text), line 263 (text), line 267 (text), line 280 (text), line 283 (text), line 284 (text),
  line 286 (text), line 289 (text), line 301 (text), line 302 (text), line 310 (text), line 317 (text), line 340 (text), line 346 (text),
  line 349 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 449 (text),
  line 451 (text), line 453 (text), line 455 (text), line 456 (text), line 458 (text), line 460 (text), line 462 (text), line 463 (text),
  line 466 (text), line 567 (text), line 570 (text), line 574 (text), line 578 (text), line 586 (text), line 587 (text), line 589 (text),
  line 591 (text), line 593 (text), line 595 (text), line 623 (text), line 634 (text) and line 640 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md][435]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 8 (text), line 62 (text), line 65 (text), line 68 (text), line 71 (text), line 74 (text), line 77 (text), line 80
  (text), line 83 (text), line 86 (text), line 89 (text), line 92 (text), line 95 (text), line 98 (text), line 101 (text), line 104 (text),
  line 107 (text), line 110 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text),
  line 131 (text), line 134 (text), line 137 (text), line 140 (text), line 143 (text), line 146 (text), line 149 (text), line 152 (text),
  line 155 (text), line 158 (text), line 161 (text), line 164 (text), line 167 (text), line 170 (text), line 173 (text), line 176 (text),
  line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text),
  line 204 (text), line 206 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 229 (text), line 232 (text),
  line 234 (text), line 237 (text), line 243 (text), line 245 (text), line 344 (text), line 603 (text), line 605 (text), line 607 (text),
  line 609 (text), line 612 (text), line 613 (text), line 616 (text), line 617 (text), line 619 (text), line 737 (text), line 784 (text),
  line 822 (text), line 933 (text) and line 975 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 191
  (text), line 197 (text), line 200 (text), line 206 (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217
  (text), line 228 (text), line 230 (text), line 235 (text), line 239 (text), line 247 (text), line 249 (text), line 251 (text), line 253
  (text), line 255 (text), line 257 (text), line 345 (text), line 348 (text), line 391 (text), line 393 (text), line 397 (text), line 409
  (text), line 411 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 482 (text), line 485
  (text), line 488 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text), line 662 (text), line 674 (text), line 676
  (text), line 678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 690 (text), line 697
  (text), line 769 (text), line 771 (text), line 773 (text), line 785 (text), line 789 (text), line 812 (text), line 818 (text), line 829
  (text), line 859 (text), line 861 (text), line 955 (text), line 968 (text) and line 976 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][436]: selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md][437]: selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][438]: selected by [ADR-AUTO-BUNDLE][2]:
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
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md][439]: selected by [ADR-AUTO-BUNDLE][2]:
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
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][440]: selected by [ADR-AUTO-ASSETDEP][1]:
  the file cites it at line 8 (text), line 46 (text), line 46 (text), line 54 (text) and line 54 (text); selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 8 (text), line 57 (text), line 57 (text), line 73 (text) and line 73 (text); selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 65 (text), line 65 (text), line 87 (text), line 88 (text), line 89 (text), line 90 (text), line 91
  (text), line 92 (text), line 93 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text) and line 98 (text); selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 30 (text), line 30 (text), line 38 (text) and line 38 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][441]: selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 67 (text) and line 74 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 67 (text) and line 74
  (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][442]: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 8 (text), line 82 (text), line 165 (text), line 171 (text), line 203 (text), line 214 (text), line 357 (text), line
  368 (text), line 372 (text), line 375 (text), line 378 (text), line 380 (text), line 389 (text), line 425 (text), line 446 (text), line
  452 (text), line 456 (text), line 464 (text), line 486 (text), line 525 (text), line 569 (text), line 588 (text), line 606 (text), line
  624 (text), line 651 (text), line 744 (text), line 748 (text), line 762 (text), line 775 (text), line 780 (text), line 835 (text), line
  838 (text), line 841 (text), line 844 (text), line 847 (text), line 850 (text), line 853 (text), line 856 (text), line 859 (text), line
  862 (text), line 865 (text), line 868 (text), line 871 (text), line 874 (text), line 877 (text), line 880 (text), line 883 (text), line
  886 (text), line 889 (text), line 892 (text), line 895 (text), line 898 (text), line 901 (text), line 904 (text), line 907 (text), line
  910 (text), line 913 (text), line 916 (text), line 919 (text), line 922 (text), line 925 (text), line 928 (text), line 931 (text), line
  934 (text), line 937 (text), line 940 (text), line 943 (text), line 946 (text), line 949 (text), line 971 (text), line 976 (text), line
  998 (text), line 1014 (text), line 1025 (text), line 1026 (text), line 1064 (text) and line 1072 (text); selected by [ADR-AUTO-BUNDLE][2]:
  the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 71 (text), line 181 (text), line 278 (text), line
  279 (text), line 281 (text), line 282 (text), line 283 (text), line 285 (text), line 763 (text), line 773 (text), line 794 (text), line
  796 (text), line 797 (text), line 799 (text), line 801 (text), line 804 (text), line 805 (text), line 807 (text), line 810 (text), line
  812 (text), line 836 (text), line 839 (text), line 842 (text), line 845 (text), line 848 (text), line 851 (text), line 854 (text), line
  857 (text), line 860 (text), line 863 (text), line 866 (text), line 869 (text), line 872 (text), line 875 (text), line 878 (text), line
  881 (text), line 884 (text), line 887 (text), line 890 (text), line 893 (text), line 896 (text), line 899 (text), line 902 (text), line
  905 (text), line 908 (text), line 911 (text), line 914 (text), line 917 (text), line 920 (text), line 923 (text), line 926 (text), line
  929 (text), line 932 (text), line 935 (text), line 938 (text), line 941 (text), line 944 (text), line 947 (text), line 950 (text), line
  971 (text), line 974 (text), line 977 (text), line 979 (text), line 981 (text), line 984 (text), line 986 (text), line 988 (text), line
  991 (text), line 994 (text), line 999 (text) and line 1050 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 8 (text),
  line 33 (text), line 34 (text), line 35 (text), line 52 (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text), line 60
  (text), line 61 (text), line 62 (text), line 63 (text), line 73 (text), line 75 (text), line 78 (text), line 79 (text), line 80 (text),
  line 84 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99
  (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147
  (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 161
  (text), line 163 (text), line 167 (text), line 169 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 183
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 197
  (text), line 198 (text), line 199 (text), line 201 (text), line 205 (text), line 206 (text), line 208 (text), line 209 (text), line 210
  (text), line 212 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228
  (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241 (text), line 243
  (text), line 245 (text), line 247 (text), line 249 (text), line 250 (text), line 252 (text), line 254 (text), line 256 (text), line 258
  (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line 272 (text), line 274
  (text), line 276 (text), line 287 (text), line 289 (text), line 291 (text), line 293 (text), line 296 (text), line 297 (text), line 299
  (text), line 300 (text), line 301 (text), line 303 (text), line 305 (text), line 307 (text), line 309 (text), line 311 (text), line 313
  (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text), line 323 (text), line 325 (text), line 327 (text), line 329
  (text), line 331 (text), line 333 (text), line 335 (text), line 337 (text), line 338 (text), line 339 (text), line 340 (text), line 342
  (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 355 (text), line 362 (text), line 364 (text), line 366
  (text), line 369 (text), line 370 (text), line 371 (text), line 373 (text), line 376 (text), line 379 (text), line 381 (text), line 383
  (text), line 385 (text), line 387 (text), line 390 (text), line 391 (text), line 393 (text), line 395 (text), line 397 (text), line 399
  (text), line 401 (text), line 403 (text), line 404 (text), line 406 (text), line 408 (text), line 410 (text), line 411 (text), line 413
  (text), line 414 (text), line 415 (text), line 416 (text), line 418 (text), line 419 (text), line 421 (text), line 422 (text), line 423
  (text), line 426 (text), line 427 (text), line 428 (text), line 430 (text), line 431 (text), line 432 (text), line 434 (text), line 436
  (text), line 438 (text), line 440 (text), line 442 (text), line 444 (text), line 448 (text), line 450 (text), line 454 (text), line 458
  (text), line 460 (text), line 462 (text), line 465 (text), line 466 (text), line 468 (text), line 470 (text), line 472 (text), line 474
  (text), line 476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 487 (text), line 489 (text), line 491
  (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 503 (text), line 505 (text), line 507
  (text), line 509 (text), line 511 (text), line 513 (text), line 515 (text), line 517 (text), line 519 (text), line 521 (text), line 523
  (text), line 527 (text), line 529 (text), line 531 (text), line 533 (text), line 535 (text), line 537 (text), line 539 (text), line 541
  (text), line 543 (text), line 545 (text), line 547 (text), line 549 (text), line 551 (text), line 553 (text), line 555 (text), line 557
  (text), line 559 (text), line 561 (text), line 563 (text), line 565 (text), line 567 (text), line 570 (text), line 572 (text), line 574
  (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line 584 (text), line 586 (text), line 589 (text), line 590
  (text), line 596 (text), line 598 (text), line 600 (text), line 602 (text), line 604 (text), line 608 (text), line 610 (text), line 612
  (text), line 614 (text), line 616 (text), line 618 (text), line 620 (text), line 622 (text), line 625 (text), line 627 (text), line 629
  (text), line 631 (text), line 633 (text), line 635 (text), line 637 (text), line 639 (text), line 641 (text), line 643 (text), line 645
  (text), line 646 (text), line 648 (text), line 654 (text), line 656 (text), line 659 (text), line 661 (text), line 662 (text), line 664
  (text), line 666 (text), line 668 (text), line 670 (text), line 682 (text), line 683 (text), line 685 (text), line 687 (text), line 689
  (text), line 693 (text), line 694 (text), line 696 (text), line 698 (text), line 700 (text), line 702 (text), line 704 (text), line 706
  (text), line 708 (text), line 710 (text), line 712 (text), line 714 (text), line 716 (text), line 718 (text), line 720 (text), line 722
  (text), line 724 (text), line 726 (text), line 728 (text), line 730 (text), line 732 (text), line 734 (text), line 736 (text), line 738
  (text), line 740 (text), line 742 (text), line 746 (text), line 750 (text), line 758 (text), line 759 (text), line 761 (text), line 763
  (text), line 765 (text), line 767 (text), line 769 (text), line 771 (text), line 774 (text), line 776 (text), line 777 (text), line 781
  (text), line 783 (text), line 784 (text), line 785 (text), line 813 (text), line 815 (text), line 817 (text), line 819 (text), line 831
  (text), line 834 (text), line 837 (text), line 840 (text), line 843 (text), line 846 (text), line 849 (text), line 852 (text), line 855
  (text), line 858 (text), line 861 (text), line 864 (text), line 867 (text), line 870 (text), line 873 (text), line 876 (text), line 879
  (text), line 882 (text), line 885 (text), line 888 (text), line 891 (text), line 894 (text), line 897 (text), line 900 (text), line 903
  (text), line 906 (text), line 909 (text), line 912 (text), line 915 (text), line 918 (text), line 921 (text), line 924 (text), line 927
  (text), line 930 (text), line 933 (text), line 936 (text), line 939 (text), line 942 (text), line 945 (text), line 948 (text), line 951
  (text), line 968 (text), line 972 (text), line 996 (text), line 1000 (text), line 1003 (text), line 1007 (text), line 1017 (text), line
  1018 (text), line 1020 (text), line 1022 (text), line 1023 (text), line 1028 (text), line 1029 (text), line 1031 (text), line 1032 (text),
  line 1033 (text), line 1034 (text), line 1035 (text), line 1042 (text), line 1051 (text), line 1066 (text), line 1074 (text), line 1103
  (text), line 1104 (text), line 1105 (text), line 1106 (text), line 1107 (text), line 1108 (text), line 1109 (text), line 1110 (text), line
  1111 (text), line 1112 (text), line 1113 (text) and line 1114 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8
  (text), line 72 (text), line 77 (text), line 176 (text), line 200 (text), line 295 (text), line 351 (text), line 352 (text), line 354
  (text), line 356 (text), line 358 (text), line 359 (text), line 360 (text), line 367 (text), line 407 (text), line 409 (text), line 592
  (text), line 594 (text), line 650 (text), line 652 (text), line 653 (text), line 658 (text), line 672 (text), line 674 (text), line 676
  (text), line 678 (text), line 680 (text), line 691 (text), line 692 (text), line 764 (text), line 781 (text), line 800 (text), line 806
  (text), line 808 (text), line 814 (text), line 821 (text), line 824 (text), line 826 (text), line 828 (text), line 830 (text), line 952
  (text), line 954 (text), line 956 (text), line 958 (text), line 959 (text), line 961 (text), line 963 (text), line 965 (text), line 966
  (text), line 972 (text), line 982 (text), line 985 (text), line 989 (text), line 992 (text), line 1001 (text), line 1005 (text), line 1008
  (text), line 1010 (text), line 1012 (text), line 1015 (text), line 1055 (text), line 1069 (text) and line 1077 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md][443]: selected by [ADR-AUTO-ASSETDEP][1]: the
  file cites it at line 8 (text), line 100 (text), line 113 (text), line 118 (text), line 136 (text), line 142 (text), line 146 (text), line
  154 (text), line 177 (text), line 216 (text), line 262 (text), line 281 (text), line 301 (text), line 321 (text), line 395 (text), line
  418 (text), line 435 (text), line 448 (text), line 450 (text), line 479 (text), line 488 (text), line 503 (text), line 557 (text), line
  560 (text), line 563 (text), line 566 (text), line 569 (text), line 572 (text), line 575 (text), line 579 (text), line 582 (text), line
  585 (text), line 588 (text), line 591 (text), line 594 (text), line 597 (text), line 600 (text), line 603 (text), line 606 (text), line
  609 (text), line 612 (text), line 615 (text), line 618 (text), line 621 (text), line 624 (text), line 627 (text), line 630 (text), line
  633 (text), line 636 (text), line 639 (text), line 642 (text), line 645 (text), line 648 (text), line 651 (text), line 655 (text), line
  658 (text), line 661 (text), line 664 (text), line 667 (text), line 670 (text), line 673 (text), line 762 (text), line 775 (text), line
  784 (text), line 787 (text), line 790 (text), line 793 (text), line 802 (text), line 1138 (text), line 1145 (text), line 1171 (text), line
  1210 (text), line 1215 (text), line 1223 (text), line 1231 (text), line 1289 (text) and line 1316 (text); selected by
  [ADR-AUTO-BUNDLE][2]: the file cites it at line 8 (text), line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360
  (text), line 362 (text), line 364 (text), line 366 (text), line 369 (text), line 371 (text), line 393 (text), line 396 (text), line 398
  (text), line 400 (text), line 403 (text), line 406 (text), line 408 (text), line 411 (text), line 414 (text), line 419 (text), line 480
  (text), line 558 (text), line 561 (text), line 564 (text), line 567 (text), line 570 (text), line 573 (text), line 576 (text), line 580
  (text), line 583 (text), line 586 (text), line 589 (text), line 592 (text), line 595 (text), line 598 (text), line 601 (text), line 604
  (text), line 607 (text), line 610 (text), line 613 (text), line 616 (text), line 619 (text), line 622 (text), line 625 (text), line 628
  (text), line 631 (text), line 634 (text), line 637 (text), line 640 (text), line 643 (text), line 646 (text), line 649 (text), line 652
  (text), line 656 (text), line 659 (text), line 662 (text), line 665 (text), line 668 (text), line 671 (text), line 674 (text), line 849
  (text), line 851 (text), line 853 (text), line 855 (text), line 858 (text), line 859 (text), line 862 (text), line 869 (text), line 871
  (text), line 1079 (text), line 1120 (text), line 1239 (text), line 1317 (text) and line 1324 (text); selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 73 (text), line 75 (text), line 78
  (text), line 81 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text),
  line 96 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line
  114 (text), line 115 (text), line 119 (text), line 121 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line
  132 (text), line 134 (text), line 138 (text), line 140 (text), line 144 (text), line 148 (text), line 149 (text), line 152 (text), line
  154 (text), line 157 (text), line 159 (text), line 161 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line
  171 (text), line 173 (text), line 175 (text), line 177 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line
  188 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line
  204 (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 218 (text), line 220 (text), line
  222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line
  238 (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 253 (text), line
  255 (text), line 258 (text), line 260 (text), line 262 (text), line 265 (text), line 267 (text), line 269 (text), line 271 (text), line
  273 (text), line 275 (text), line 277 (text), line 279 (text), line 281 (text), line 284 (text), line 290 (text), line 292 (text), line
  294 (text), line 296 (text), line 299 (text), line 302 (text), line 305 (text), line 307 (text), line 310 (text), line 312 (text), line
  314 (text), line 317 (text), line 319 (text), line 321 (text), line 324 (text), line 326 (text), line 328 (text), line 330 (text), line
  333 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 342 (text), line 344 (text), line 371 (text), line
  374 (text), line 376 (text), line 378 (text), line 390 (text), line 392 (text), line 416 (text), line 420 (text), line 423 (text), line
  427 (text), line 438 (text), line 440 (text), line 442 (text), line 444 (text), line 446 (text), line 452 (text), line 454 (text), line
  456 (text), line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 471 (text), line 473 (text), line 475 (text), line
  477 (text), line 480 (text), line 482 (text), line 487 (text), line 490 (text), line 493 (text), line 494 (text), line 496 (text), line
  498 (text), line 501 (text), line 505 (text), line 507 (text), line 508 (text), line 511 (text), line 513 (text), line 515 (text), line
  517 (text), line 519 (text), line 521 (text), line 523 (text), line 525 (text), line 526 (text), line 529 (text), line 531 (text), line
  532 (text), line 534 (text), line 537 (text), line 539 (text), line 541 (text), line 542 (text), line 544 (text), line 547 (text), line
  549 (text), line 550 (text), line 559 (text), line 562 (text), line 565 (text), line 568 (text), line 571 (text), line 574 (text), line
  577 (text), line 581 (text), line 584 (text), line 587 (text), line 590 (text), line 593 (text), line 596 (text), line 599 (text), line
  602 (text), line 605 (text), line 608 (text), line 611 (text), line 614 (text), line 617 (text), line 620 (text), line 623 (text), line
  626 (text), line 629 (text), line 632 (text), line 635 (text), line 638 (text), line 641 (text), line 644 (text), line 647 (text), line
  650 (text), line 653 (text), line 657 (text), line 660 (text), line 663 (text), line 666 (text), line 669 (text), line 672 (text), line
  675 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 690 (text), line 693 (text), line 695 (text), line
  698 (text), line 701 (text), line 702 (text), line 706 (text), line 708 (text), line 711 (text), line 714 (text), line 716 (text), line
  718 (text), line 720 (text), line 722 (text), line 724 (text), line 726 (text), line 728 (text), line 731 (text), line 733 (text), line
  736 (text), line 738 (text), line 740 (text), line 742 (text), line 744 (text), line 746 (text), line 758 (text), line 768 (text), line
  770 (text), line 773 (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 785 (text), line 788 (text), line
  790 (text), line 794 (text), line 796 (text), line 798 (text), line 800 (text), line 802 (text), line 804 (text), line 806 (text), line
  807 (text), line 816 (text), line 819 (text), line 820 (text), line 822 (text), line 825 (text), line 826 (text), line 828 (text), line
  831 (text), line 833 (text), line 835 (text), line 837 (text), line 839 (text), line 841 (text), line 842 (text), line 864 (text), line
  865 (text), line 868 (text), line 878 (text), line 880 (text), line 883 (text), line 884 (text), line 886 (text), line 888 (text), line
  890 (text), line 893 (text), line 894 (text), line 896 (text), line 898 (text), line 906 (text), line 908 (text), line 910 (text), line
  912 (text), line 913 (text), line 916 (text), line 918 (text), line 920 (text), line 921 (text), line 923 (text), line 925 (text), line
  932 (text), line 934 (text), line 937 (text), line 938 (text), line 941 (text), line 943 (text), line 945 (text), line 947 (text), line
  949 (text), line 951 (text), line 953 (text), line 959 (text), line 962 (text), line 964 (text), line 966 (text), line 968 (text), line
  970 (text), line 972 (text), line 974 (text), line 976 (text), line 978 (text), line 995 (text), line 998 (text), line 1000 (text), line
  1002 (text), line 1004 (text), line 1010 (text), line 1012 (text), line 1014 (text), line 1017 (text), line 1018 (text), line 1020 (text),
  line 1022 (text), line 1025 (text), line 1027 (text), line 1036 (text), line 1037 (text), line 1039 (text), line 1042 (text), line 1044
  (text), line 1046 (text), line 1048 (text), line 1050 (text), line 1081 (text), line 1084 (text), line 1086 (text), line 1088 (text), line
  1090 (text), line 1092 (text), line 1094 (text), line 1102 (text), line 1104 (text), line 1106 (text), line 1108 (text), line 1110 (text),
  line 1112 (text), line 1114 (text), line 1122 (text), line 1124 (text), line 1128 (text), line 1130 (text), line 1140 (text), line 1141
  (text), line 1146 (text), line 1153 (text), line 1155 (text), line 1158 (text), line 1161 (text), line 1162 (text), line 1176 (text), line
  1178 (text), line 1184 (text), line 1186 (text), line 1189 (text), line 1190 (text), line 1198 (text), line 1200 (text), line 1202 (text),
  line 1204 (text), line 1213 (text), line 1217 (text), line 1225 (text), line 1233 (text), line 1241 (text), line 1253 (text), line 1254
  (text), line 1256 (text), line 1265 (text), line 1267 (text), line 1269 (text), line 1276 (text), line 1278 (text), line 1280 (text), line
  1287 (text), line 1296 (text), line 1298 (text), line 1313 (text), line 1317 (text), line 1332 (text), line 1339 (text), line 1346 (text),
  line 1353 (text), line 1359 (text), line 1367 (text), line 1373 (text), line 1398 (text), line 1399 (text), line 1400 (text), line 1401
  (text), line 1402 (text), line 1403 (text), line 1404 (text), line 1405 (text), line 1406 (text), line 1407 (text), line 1408 (text) and
  line 1409 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 74 (text), line 76 (text), line 120 (text),
  line 286 (text), line 288 (text), line 358 (text), line 364 (text), line 366 (text), line 372 (text), line 380 (text), line 382 (text),
  line 384 (text), line 386 (text), line 388 (text), line 402 (text), line 404 (text), line 409 (text), line 413 (text), line 421 (text),
  line 425 (text), line 429 (text), line 431 (text), line 433 (text), line 436 (text), line 481 (text), line 484 (text), line 752 (text),
  line 755 (text), line 756 (text), line 759 (text), line 762 (text), line 764 (text), line 766 (text), line 773 (text), line 814 (text),
  line 986 (text), line 988 (text), line 990 (text), line 992 (text), line 994 (text), line 1033 (text), line 1056 (text), line 1058 (text),
  line 1060 (text), line 1062 (text), line 1064 (text), line 1066 (text), line 1068 (text), line 1070 (text), line 1072 (text), line 1121
  (text), line 1127 (text), line 1169 (text), line 1172 (text), line 1173 (text), line 1228 (text), line 1236 (text), line 1245 (text), line
  1265 (text), line 1304 (text), line 1306 (text) and line 1318 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md][444]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 34 (text), line 34 (text), line 48 (text), line 49 (text), line 50 (text), line 51 (text), line 52
  (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md][445]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md][446]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 32 (text), line 33 (text), line 34 (text), line 44 (text), line 46 (text), line 47 (text), line 48
  (text), line 49 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 65 (text), line 67 (text), line 69 (text),
  line 70 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text),
  line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text),
  line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text),
  line 134 (text), line 136 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147 (text),
  line 149 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text),
  line 164 (text), line 166 (text), line 167 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text),
  line 179 (text), line 180 (text), line 181 (text), line 182 (text), line 183 (text), line 185 (text), line 186 (text), line 188 (text),
  line 189 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text),
  line 204 (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 217 (text),
  line 219 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 228 (text), line 230 (text), line 232 (text),
  line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text),
  line 250 (text), line 252 (text), line 254 (text), line 256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text),
  line 265 (text), line 267 (text), line 268 (text), line 269 (text), line 271 (text), line 273 (text), line 275 (text), line 277 (text),
  line 279 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 291 (text), line 293 (text),
  line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line 305 (text), line 306 (text), line 307 (text),
  line 308 (text), line 310 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text),
  line 323 (text), line 325 (text), line 327 (text), line 329 (text), line 330 (text), line 331 (text), line 333 (text), line 335 (text),
  line 337 (text), line 339 (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 351 (text),
  line 353 (text), line 355 (text), line 357 (text), line 359 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text),
  line 367 (text), line 369 (text), line 370 (text), line 371 (text), line 372 (text), line 374 (text), line 375 (text), line 377 (text),
  line 378 (text), line 379 (text), line 381 (text), line 382 (text), line 383 (text), line 385 (text), line 386 (text), line 387 (text),
  line 389 (text), line 391 (text), line 393 (text), line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 403 (text),
  line 405 (text), line 407 (text), line 409 (text), line 411 (text), line 413 (text), line 415 (text), line 417 (text), line 419 (text),
  line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line 433 (text), line 435 (text),
  line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445 (text), line 447 (text), line 449 (text), line 451 (text),
  line 453 (text), line 455 (text), line 457 (text), line 459 (text), line 461 (text), line 463 (text), line 465 (text), line 467 (text),
  line 469 (text), line 471 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 483 (text),
  line 485 (text), line 487 (text), line 489 (text), line 491 (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text),
  line 501 (text), line 503 (text), line 505 (text), line 507 (text), line 509 (text), line 511 (text), line 513 (text), line 515 (text),
  line 517 (text), line 519 (text), line 521 (text), line 523 (text), line 525 (text), line 527 (text), line 529 (text), line 531 (text),
  line 533 (text), line 535 (text), line 537 (text), line 539 (text), line 541 (text), line 543 (text), line 545 (text), line 547 (text),
  line 549 (text), line 551 (text), line 553 (text), line 555 (text), line 557 (text), line 559 (text), line 561 (text), line 563 (text),
  line 565 (text), line 567 (text), line 569 (text), line 571 (text), line 573 (text), line 575 (text), line 577 (text), line 579 (text),
  line 581 (text), line 583 (text), line 584 (text), line 586 (text), line 588 (text), line 590 (text), line 592 (text), line 594 (text),
  line 595 (text), line 597 (text), line 599 (text), line 601 (text), line 603 (text), line 605 (text), line 606 (text), line 608 (text),
  line 610 (text), line 612 (text), line 614 (text), line 615 (text), line 617 (text), line 619 (text), line 621 (text), line 623 (text),
  line 625 (text), line 627 (text), line 629 (text), line 631 (text), line 633 (text), line 635 (text), line 637 (text), line 639 (text),
  line 641 (text), line 643 (text), line 645 (text), line 647 (text), line 649 (text), line 651 (text), line 653 (text), line 655 (text),
  line 657 (text), line 659 (text), line 661 (text), line 663 (text), line 665 (text), line 667 (text), line 675 (text), line 676 (text),
  line 678 (text), line 680 (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 689 (text), line 690 (text),
  line 692 (text), line 695 (text), line 696 (text), line 697 (text), line 698 (text), line 706 (text), line 713 (text), line 718 (text),
  line 720 (text), line 722 (text), line 725 (text), line 727 (text), line 729 (text), line 731 (text), line 733 (text), line 735 (text),
  line 737 (text), line 739 (text), line 741 (text), line 743 (text), line 745 (text), line 747 (text), line 749 (text), line 751 (text),
  line 753 (text), line 755 (text), line 757 (text), line 759 (text), line 761 (text), line 763 (text), line 765 (text), line 767 (text),
  line 769 (text), line 771 (text), line 773 (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 783 (text),
  line 785 (text), line 787 (text), line 789 (text), line 791 (text), line 793 (text), line 795 (text), line 797 (text), line 799 (text),
  line 801 (text), line 803 (text), line 804 (text), line 807 (text), line 814 (text), line 820 (text), line 822 (text), line 824 (text),
  line 825 (text), line 826 (text), line 828 (text), line 830 (text), line 831 (text), line 833 (text), line 834 (text), line 836 (text),
  line 837 (text), line 838 (text), line 839 (text), line 840 (text), line 847 (text), line 855 (text), line 866 (text), line 869 (text),
  line 894 (text), line 895 (text), line 896 (text), line 897 (text), line 898 (text), line 899 (text), line 900 (text), line 901 (text),
  line 902 (text), line 903 (text), line 904 (text) and line 905 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md][447]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 70 (text), line 72 (text), line 74
  (text), line 77 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 95 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line
  108 (text), line 110 (text), line 113 (text), line 115 (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line
  126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 137 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line
  158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line
  174 (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line
  190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line
  206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line
  222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 237 (text), line
  239 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line 254 (text), line
  256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line
  272 (text), line 274 (text), line 277 (text), line 278 (text), line 281 (text), line 283 (text), line 286 (text), line 288 (text), line
  290 (text), line 293 (text), line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line 305 (text), line
  308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 317 (text), line 319 (text), line 327 (text), line
  330 (text), line 333 (text), line 336 (text), line 339 (text), line 342 (text), line 345 (text), line 348 (text), line 351 (text), line
  354 (text), line 357 (text), line 360 (text), line 363 (text), line 366 (text), line 369 (text), line 372 (text), line 375 (text), line
  378 (text), line 381 (text), line 384 (text), line 387 (text), line 390 (text), line 393 (text), line 396 (text), line 399 (text), line
  402 (text), line 405 (text), line 408 (text), line 411 (text), line 414 (text), line 417 (text), line 420 (text), line 423 (text), line
  426 (text), line 429 (text), line 432 (text), line 435 (text), line 438 (text), line 441 (text), line 448 (text), line 450 (text), line
  452 (text), line 454 (text), line 457 (text), line 458 (text), line 461 (text), line 462 (text), line 465 (text), line 466 (text), line
  468 (text), line 470 (text), line 473 (text), line 475 (text), line 477 (text), line 478 (text), line 481 (text), line 483 (text), line
  485 (text), line 487 (text), line 489 (text), line 491 (text), line 493 (text), line 495 (text), line 496 (text), line 499 (text), line
  501 (text), line 502 (text), line 504 (text), line 507 (text), line 509 (text), line 511 (text), line 512 (text), line 514 (text), line
  517 (text), line 519 (text), line 520 (text), line 528 (text), line 534 (text), line 540 (text), line 542 (text), line 544 (text), line
  546 (text), line 553 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 568 (text), line
  570 (text), line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line 584 (text), line
  586 (text), line 594 (text), line 596 (text), line 598 (text), line 600 (text), line 602 (text), line 605 (text), line 607 (text), line
  610 (text), line 613 (text), line 614 (text), line 618 (text), line 620 (text), line 623 (text), line 626 (text), line 628 (text), line
  630 (text), line 632 (text), line 634 (text), line 636 (text), line 638 (text), line 640 (text), line 643 (text), line 645 (text), line
  648 (text), line 650 (text), line 652 (text), line 654 (text), line 656 (text), line 658 (text), line 664 (text), line 666 (text), line
  668 (text), line 671 (text), line 673 (text), line 674 (text), line 676 (text), line 678 (text), line 681 (text), line 683 (text), line
  685 (text), line 687 (text), line 689 (text), line 691 (text), line 693 (text), line 695 (text), line 697 (text), line 699 (text), line
  700 (text), line 713 (text), line 716 (text), line 717 (text), line 719 (text), line 722 (text), line 723 (text), line 725 (text), line
  728 (text), line 730 (text), line 732 (text), line 734 (text), line 736 (text), line 738 (text), line 739 (text), line 746 (text), line
  748 (text), line 751 (text), line 752 (text), line 754 (text), line 756 (text), line 758 (text), line 761 (text), line 762 (text), line
  764 (text), line 766 (text), line 774 (text), line 776 (text), line 778 (text), line 780 (text), line 781 (text), line 784 (text), line
  786 (text), line 788 (text), line 789 (text), line 791 (text), line 793 (text), line 800 (text), line 802 (text), line 805 (text), line
  806 (text), line 809 (text), line 811 (text), line 813 (text), line 815 (text), line 817 (text), line 819 (text), line 821 (text), line
  827 (text), line 830 (text), line 832 (text), line 834 (text), line 836 (text), line 838 (text), line 840 (text), line 842 (text), line
  844 (text), line 846 (text), line 853 (text), line 855 (text), line 857 (text), line 860 (text), line 861 (text), line 863 (text), line
  865 (text), line 868 (text), line 870 (text), line 877 (text), line 878 (text), line 880 (text), line 883 (text), line 885 (text), line
  887 (text), line 889 (text), line 891 (text), line 897 (text), line 900 (text), line 902 (text), line 904 (text), line 906 (text), line
  908 (text), line 910 (text), line 918 (text), line 920 (text), line 922 (text), line 924 (text), line 926 (text), line 928 (text), line
  930 (text), line 936 (text), line 938 (text), line 941 (text), line 944 (text), line 945 (text), line 952 (text), line 955 (text), line
  957 (text), line 959 (text), line 961 (text), line 967 (text), line 968 (text), line 970 (text), line 979 (text), line 981 (text), line
  983 (text), line 985 (text), line 992 (text), line 994 (text), line 997 (text), line 998 (text), line 1006 (text), line 1008 (text), line
  1010 (text), line 1012 (text), line 1018 (text), line 1021 (text), line 1024 (text), line 1035 (text), line 1036 (text), line 1039 (text),
  line 1047 (text), line 1049 (text), line 1051 (text), line 1058 (text), line 1059 (text), line 1062 (text), line 1069 (text), line 1071
  (text), line 1073 (text), line 1080 (text), line 1082 (text), line 1089 (text), line 1091 (text), line 1098 (text), line 1100 (text), line
  1106 (text), line 1110 (text), line 1117 (text), line 1124 (text), line 1131 (text), line 1138 (text), line 1145 (text), line 1151 (text),
  line 1159 (text), line 1165 (text), line 1189 (text), line 1190 (text), line 1191 (text), line 1192 (text), line 1193 (text), line 1194
  (text), line 1195 (text), line 1196 (text), line 1197 (text), line 1198 (text), line 1199 (text) and line 1200 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][448]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 37 (text), line 37 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55
  (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text), line 61 (text) and line 62 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md][449]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 72 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][450]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 32 (text), line 33 (text), line 34 (text), line 46 (text), line 49 (text), line 50 (text), line 51
  (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text), line 65 (text), line 67 (text), line 69 (text),
  line 70 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147 (text), line 149 (text),
  line 151 (text), line 152 (text), line 154 (text), line 160 (text), line 162 (text), line 164 (text), line 167 (text), line 169 (text),
  line 171 (text), line 173 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text),
  line 187 (text), line 188 (text), line 189 (text), line 190 (text), line 193 (text), line 196 (text), line 197 (text), line 199 (text),
  line 200 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text),
  line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 228 (text),
  line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241 (text), line 243 (text),
  line 245 (text), line 247 (text), line 251 (text), line 253 (text), line 255 (text), line 257 (text), line 259 (text), line 261 (text),
  line 263 (text), line 265 (text), line 267 (text), line 269 (text), line 271 (text), line 273 (text), line 275 (text), line 279 (text),
  line 280 (text), line 282 (text), line 283 (text), line 284 (text), line 286 (text), line 288 (text), line 290 (text), line 292 (text),
  line 294 (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 308 (text), line 310 (text), line 312 (text),
  line 314 (text), line 316 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 325 (text), line 326 (text),
  line 327 (text), line 329 (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 339 (text), line 341 (text),
  line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 350 (text), line 351 (text), line 353 (text), line 355 (text),
  line 357 (text), line 359 (text), line 361 (text), line 363 (text), line 365 (text), line 367 (text), line 369 (text), line 371 (text),
  line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text),
  line 387 (text), line 389 (text), line 390 (text), line 391 (text), line 392 (text), line 394 (text), line 395 (text), line 397 (text),
  line 398 (text), line 399 (text), line 401 (text), line 402 (text), line 404 (text), line 406 (text), line 407 (text), line 408 (text),
  line 410 (text), line 412 (text), line 414 (text), line 416 (text), line 418 (text), line 420 (text), line 422 (text), line 424 (text),
  line 426 (text), line 428 (text), line 430 (text), line 432 (text), line 434 (text), line 436 (text), line 438 (text), line 440 (text),
  line 442 (text), line 444 (text), line 446 (text), line 448 (text), line 450 (text), line 452 (text), line 454 (text), line 456 (text),
  line 458 (text), line 460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 470 (text), line 472 (text),
  line 474 (text), line 476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 486 (text), line 488 (text),
  line 490 (text), line 492 (text), line 494 (text), line 496 (text), line 498 (text), line 500 (text), line 502 (text), line 504 (text),
  line 506 (text), line 508 (text), line 510 (text), line 512 (text), line 514 (text), line 516 (text), line 518 (text), line 520 (text),
  line 522 (text), line 524 (text), line 526 (text), line 528 (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text),
  line 538 (text), line 540 (text), line 542 (text), line 544 (text), line 546 (text), line 548 (text), line 550 (text), line 552 (text),
  line 554 (text), line 556 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 568 (text),
  line 570 (text), line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line 584 (text),
  line 586 (text), line 588 (text), line 590 (text), line 592 (text), line 594 (text), line 596 (text), line 598 (text), line 600 (text),
  line 602 (text), line 604 (text), line 605 (text), line 607 (text), line 609 (text), line 611 (text), line 613 (text), line 615 (text),
  line 616 (text), line 618 (text), line 620 (text), line 622 (text), line 624 (text), line 626 (text), line 627 (text), line 629 (text),
  line 631 (text), line 633 (text), line 635 (text), line 636 (text), line 638 (text), line 640 (text), line 642 (text), line 644 (text),
  line 646 (text), line 648 (text), line 650 (text), line 652 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text),
  line 662 (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 674 (text), line 676 (text),
  line 678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 696 (text), line 697 (text),
  line 699 (text), line 700 (text), line 702 (text), line 704 (text), line 706 (text), line 708 (text), line 710 (text), line 711 (text),
  line 713 (text), line 716 (text), line 717 (text), line 718 (text), line 719 (text), line 727 (text), line 729 (text), line 735 (text),
  line 742 (text), line 744 (text), line 747 (text), line 748 (text), line 750 (text), line 752 (text), line 754 (text), line 756 (text),
  line 758 (text), line 760 (text), line 762 (text), line 764 (text), line 766 (text), line 768 (text), line 770 (text), line 772 (text),
  line 774 (text), line 776 (text), line 778 (text), line 780 (text), line 782 (text), line 784 (text), line 786 (text), line 788 (text),
  line 790 (text), line 792 (text), line 794 (text), line 796 (text), line 798 (text), line 800 (text), line 802 (text), line 804 (text),
  line 806 (text), line 808 (text), line 810 (text), line 812 (text), line 814 (text), line 816 (text), line 818 (text), line 820 (text),
  line 822 (text), line 824 (text), line 834 (text), line 837 (text), line 839 (text), line 841 (text), line 848 (text), line 856 (text),
  line 857 (text), line 858 (text), line 860 (text), line 862 (text), line 863 (text), line 867 (text), line 869 (text), line 871 (text),
  line 872 (text), line 873 (text), line 874 (text), line 875 (text), line 882 (text), line 890 (text), line 901 (text), line 904 (text),
  line 929 (text), line 930 (text), line 931 (text), line 932 (text), line 933 (text), line 934 (text), line 935 (text), line 936 (text),
  line 937 (text), line 938 (text), line 939 (text) and line 940 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md][451]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 74 (text), line 76
  (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line
  110 (text), line 112 (text), line 115 (text), line 117 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line
  128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 139 (text), line 142 (text), line
  144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 165 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line
  176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line
  192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line
  208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line
  224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 239 (text), line
  241 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line 254 (text), line 256 (text), line
  258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line 272 (text), line
  274 (text), line 276 (text), line 279 (text), line 280 (text), line 283 (text), line 285 (text), line 288 (text), line 290 (text), line
  292 (text), line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line 305 (text), line 307 (text), line
  310 (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text), line 319 (text), line 321 (text), line 330 (text), line
  332 (text), line 334 (text), line 336 (text), line 338 (text), line 341 (text), line 346 (text), line 349 (text), line 352 (text), line
  353 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 364 (text), line 365 (text), line 368 (text), line
  370 (text), line 372 (text), line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 383 (text), line
  386 (text), line 388 (text), line 389 (text), line 391 (text), line 394 (text), line 396 (text), line 398 (text), line 399 (text), line
  401 (text), line 404 (text), line 406 (text), line 413 (text), line 420 (text), line 422 (text), line 424 (text), line 426 (text), line
  428 (text), line 430 (text), line 432 (text), line 434 (text), line 436 (text), line 438 (text), line 440 (text), line 442 (text), line
  444 (text), line 446 (text), line 448 (text), line 450 (text), line 452 (text), line 454 (text), line 456 (text), line 458 (text), line
  460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 470 (text), line 472 (text), line 474 (text), line
  476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 486 (text), line 488 (text), line 490 (text), line
  492 (text), line 494 (text), line 496 (text), line 504 (text), line 506 (text), line 513 (text), line 520 (text), line 522 (text), line
  524 (text), line 525 (text), line 527 (text), line 535 (text), line 544 (text), line 546 (text), line 548 (text), line 550 (text), line
  552 (text), line 554 (text), line 558 (text), line 562 (text), line 564 (text), line 566 (text), line 568 (text), line 570 (text), line
  572 (text), line 580 (text), line 584 (text), line 586 (text), line 588 (text), line 590 (text), line 593 (text), line 595 (text), line
  598 (text), line 601 (text), line 602 (text), line 606 (text), line 608 (text), line 611 (text), line 614 (text), line 616 (text), line
  618 (text), line 620 (text), line 622 (text), line 624 (text), line 626 (text), line 628 (text), line 631 (text), line 633 (text), line
  636 (text), line 638 (text), line 640 (text), line 642 (text), line 644 (text), line 646 (text), line 654 (text), line 656 (text), line
  658 (text), line 661 (text), line 663 (text), line 664 (text), line 666 (text), line 668 (text), line 671 (text), line 673 (text), line
  675 (text), line 677 (text), line 679 (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 689 (text), line
  690 (text), line 697 (text), line 700 (text), line 701 (text), line 703 (text), line 706 (text), line 707 (text), line 709 (text), line
  712 (text), line 714 (text), line 716 (text), line 718 (text), line 720 (text), line 722 (text), line 723 (text), line 735 (text), line
  737 (text), line 739 (text), line 741 (text), line 742 (text), line 745 (text), line 747 (text), line 749 (text), line 750 (text), line
  752 (text), line 754 (text), line 761 (text), line 763 (text), line 766 (text), line 767 (text), line 769 (text), line 771 (text), line
  773 (text), line 776 (text), line 777 (text), line 779 (text), line 781 (text), line 788 (text), line 793 (text), line 795 (text), line
  797 (text), line 799 (text), line 801 (text), line 803 (text), line 805 (text), line 807 (text), line 809 (text), line 816 (text), line
  818 (text), line 821 (text), line 822 (text), line 825 (text), line 827 (text), line 829 (text), line 831 (text), line 833 (text), line
  835 (text), line 837 (text), line 843 (text), line 845 (text), line 847 (text), line 850 (text), line 851 (text), line 853 (text), line
  855 (text), line 858 (text), line 860 (text), line 867 (text), line 868 (text), line 870 (text), line 873 (text), line 875 (text), line
  877 (text), line 879 (text), line 881 (text), line 889 (text), line 892 (text), line 894 (text), line 896 (text), line 898 (text), line
  900 (text), line 902 (text), line 910 (text), line 912 (text), line 914 (text), line 916 (text), line 918 (text), line 920 (text), line
  922 (text), line 934 (text), line 935 (text), line 938 (text), line 946 (text), line 948 (text), line 951 (text), line 954 (text), line
  955 (text), line 962 (text), line 965 (text), line 967 (text), line 969 (text), line 971 (text), line 977 (text), line 979 (text), line
  981 (text), line 983 (text), line 990 (text), line 992 (text), line 995 (text), line 996 (text), line 1004 (text), line 1006 (text), line
  1008 (text), line 1010 (text), line 1016 (text), line 1019 (text), line 1022 (text), line 1032 (text), line 1033 (text), line 1035 (text),
  line 1044 (text), line 1046 (text), line 1048 (text), line 1055 (text), line 1056 (text), line 1059 (text), line 1066 (text), line 1068
  (text), line 1070 (text), line 1100 (text), line 1102 (text), line 1109 (text), line 1111 (text), line 1118 (text), line 1120 (text), line
  1126 (text), line 1129 (text), line 1137 (text), line 1144 (text), line 1151 (text), line 1158 (text), line 1165 (text), line 1171 (text),
  line 1179 (text), line 1185 (text), line 1209 (text), line 1210 (text), line 1211 (text), line 1212 (text), line 1213 (text), line 1214
  (text), line 1215 (text), line 1216 (text), line 1217 (text), line 1218 (text), line 1219 (text) and line 1220 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][452]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 79 (text), line 79 (text), line 93 (text), line 94 (text), line 95 (text), line 98 (text), line 99
  (text), line 101 (text), line 102 (text), line 103 (text), line 104 (text), line 105 (text), line 106 (text) and line 107 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][453]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][454]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 51 (text), line 53 (text), line 54 (text), line 55
  (text), line 56 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87
  (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text),
  line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text),
  line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text),
  line 137 (text), line 139 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text),
  line 152 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 163 (text), line 165 (text),
  line 167 (text), line 169 (text), line 170 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text),
  line 182 (text), line 183 (text), line 184 (text), line 185 (text), line 186 (text), line 188 (text), line 189 (text), line 191 (text),
  line 192 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 220 (text),
  line 222 (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 231 (text), line 233 (text), line 235 (text),
  line 237 (text), line 239 (text), line 241 (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 251 (text),
  line 253 (text), line 255 (text), line 257 (text), line 259 (text), line 261 (text), line 263 (text), line 265 (text), line 267 (text),
  line 268 (text), line 270 (text), line 271 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line 280 (text),
  line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 290 (text), line 292 (text), line 294 (text), line 296 (text),
  line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 306 (text), line 308 (text), line 311 (text), line 312 (text),
  line 313 (text), line 315 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 326 (text), line 328 (text),
  line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 337 (text), line 338 (text), line 340 (text), line 342 (text),
  line 344 (text), line 346 (text), line 348 (text), line 350 (text), line 352 (text), line 354 (text), line 356 (text), line 358 (text),
  line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 367 (text), line 369 (text), line 371 (text), line 373 (text),
  line 374 (text), line 376 (text), line 377 (text), line 378 (text), line 379 (text), line 381 (text), line 382 (text), line 384 (text),
  line 385 (text), line 386 (text), line 388 (text), line 389 (text), line 390 (text), line 392 (text), line 393 (text), line 394 (text),
  line 396 (text), line 398 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 410 (text),
  line 412 (text), line 414 (text), line 416 (text), line 418 (text), line 420 (text), line 422 (text), line 424 (text), line 426 (text),
  line 428 (text), line 430 (text), line 432 (text), line 434 (text), line 436 (text), line 438 (text), line 440 (text), line 442 (text),
  line 444 (text), line 446 (text), line 448 (text), line 450 (text), line 452 (text), line 454 (text), line 456 (text), line 458 (text),
  line 460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 470 (text), line 472 (text), line 474 (text),
  line 476 (text), line 478 (text), line 480 (text), line 482 (text), line 484 (text), line 486 (text), line 488 (text), line 490 (text),
  line 492 (text), line 494 (text), line 496 (text), line 498 (text), line 500 (text), line 502 (text), line 504 (text), line 506 (text),
  line 508 (text), line 510 (text), line 512 (text), line 514 (text), line 516 (text), line 518 (text), line 520 (text), line 522 (text),
  line 524 (text), line 526 (text), line 528 (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text),
  line 540 (text), line 542 (text), line 544 (text), line 546 (text), line 548 (text), line 550 (text), line 552 (text), line 554 (text),
  line 556 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 568 (text), line 570 (text),
  line 572 (text), line 574 (text), line 576 (text), line 578 (text), line 580 (text), line 582 (text), line 584 (text), line 586 (text),
  line 588 (text), line 590 (text), line 591 (text), line 593 (text), line 595 (text), line 597 (text), line 599 (text), line 601 (text),
  line 602 (text), line 604 (text), line 606 (text), line 608 (text), line 610 (text), line 612 (text), line 613 (text), line 615 (text),
  line 617 (text), line 619 (text), line 621 (text), line 622 (text), line 624 (text), line 626 (text), line 628 (text), line 630 (text),
  line 632 (text), line 634 (text), line 636 (text), line 638 (text), line 640 (text), line 642 (text), line 644 (text), line 646 (text),
  line 648 (text), line 650 (text), line 652 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text), line 662 (text),
  line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 674 (text), line 682 (text), line 683 (text),
  line 685 (text), line 686 (text), line 689 (text), line 692 (text), line 694 (text), line 696 (text), line 698 (text), line 701 (text),
  line 703 (text), line 706 (text), line 707 (text), line 708 (text), line 709 (text), line 717 (text), line 719 (text), line 721 (text),
  line 748 (text), line 766 (text), line 769 (text), line 771 (text), line 773 (text), line 775 (text), line 777 (text), line 779 (text),
  line 781 (text), line 783 (text), line 785 (text), line 787 (text), line 789 (text), line 791 (text), line 793 (text), line 795 (text),
  line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 805 (text), line 807 (text), line 809 (text), line 811 (text),
  line 813 (text), line 815 (text), line 817 (text), line 819 (text), line 821 (text), line 823 (text), line 825 (text), line 827 (text),
  line 829 (text), line 831 (text), line 833 (text), line 835 (text), line 837 (text), line 839 (text), line 841 (text), line 843 (text),
  line 845 (text), line 847 (text), line 877 (text), line 881 (text), line 884 (text), line 886 (text), line 888 (text), line 917 (text),
  line 927 (text), line 937 (text), line 941 (text), line 945 (text), line 946 (text), line 948 (text), line 949 (text), line 951 (text),
  line 952 (text), line 953 (text), line 954 (text), line 955 (text), line 962 (text), line 970 (text), line 981 (text), line 984 (text),
  line 1009 (text), line 1010 (text), line 1011 (text), line 1014 (text), line 1015 (text), line 1017 (text), line 1018 (text), line 1019
  (text), line 1020 (text), line 1021 (text), line 1022 (text) and line 1023 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][455]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 74 (text), line 76
  (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line
  110 (text), line 112 (text), line 116 (text), line 118 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 143 (text), line
  145 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line
  161 (text), line 163 (text), line 165 (text), line 166 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line
  177 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line
  193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line
  209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line
  225 (text), line 227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 240 (text), line
  242 (text), line 245 (text), line 247 (text), line 249 (text), line 251 (text), line 253 (text), line 255 (text), line 257 (text), line
  259 (text), line 261 (text), line 263 (text), line 265 (text), line 267 (text), line 269 (text), line 271 (text), line 273 (text), line
  275 (text), line 277 (text), line 280 (text), line 281 (text), line 284 (text), line 286 (text), line 289 (text), line 291 (text), line
  293 (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 306 (text), line 308 (text), line
  311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 320 (text), line 322 (text), line 330 (text), line
  332 (text), line 334 (text), line 365 (text), line 383 (text), line 385 (text), line 388 (text), line 390 (text), line 392 (text), line
  421 (text), line 432 (text), line 444 (text), line 448 (text), line 452 (text), line 454 (text), line 456 (text), line 458 (text), line
  460 (text), line 462 (text), line 464 (text), line 466 (text), line 468 (text), line 475 (text), line 477 (text), line 479 (text), line
  481 (text), line 483 (text), line 485 (text), line 487 (text), line 489 (text), line 491 (text), line 493 (text), line 495 (text), line
  497 (text), line 499 (text), line 501 (text), line 503 (text), line 505 (text), line 507 (text), line 509 (text), line 511 (text), line
  513 (text), line 515 (text), line 517 (text), line 519 (text), line 521 (text), line 523 (text), line 525 (text), line 527 (text), line
  529 (text), line 531 (text), line 533 (text), line 535 (text), line 537 (text), line 539 (text), line 541 (text), line 543 (text), line
  545 (text), line 547 (text), line 549 (text), line 551 (text), line 558 (text), line 560 (text), line 562 (text), line 564 (text), line
  566 (text), line 569 (text), line 573 (text), line 574 (text), line 577 (text), line 578 (text), line 580 (text), line 582 (text), line
  585 (text), line 587 (text), line 589 (text), line 590 (text), line 593 (text), line 595 (text), line 597 (text), line 599 (text), line
  601 (text), line 603 (text), line 605 (text), line 607 (text), line 608 (text), line 611 (text), line 613 (text), line 614 (text), line
  616 (text), line 619 (text), line 621 (text), line 623 (text), line 624 (text), line 626 (text), line 629 (text), line 631 (text), line
  634 (text), line 643 (text), line 645 (text), line 647 (text), line 649 (text), line 651 (text), line 654 (text), line 656 (text), line
  659 (text), line 662 (text), line 663 (text), line 667 (text), line 669 (text), line 672 (text), line 675 (text), line 677 (text), line
  679 (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 689 (text), line 692 (text), line 694 (text), line
  697 (text), line 699 (text), line 701 (text), line 703 (text), line 705 (text), line 707 (text), line 713 (text), line 715 (text), line
  717 (text), line 720 (text), line 722 (text), line 723 (text), line 725 (text), line 727 (text), line 732 (text), line 734 (text), line
  736 (text), line 738 (text), line 740 (text), line 742 (text), line 744 (text), line 746 (text), line 748 (text), line 750 (text), line
  751 (text), line 758 (text), line 761 (text), line 762 (text), line 764 (text), line 767 (text), line 768 (text), line 770 (text), line
  773 (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 783 (text), line 784 (text), line 791 (text), line
  793 (text), line 796 (text), line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 806 (text), line 807 (text), line
  809 (text), line 811 (text), line 819 (text), line 821 (text), line 823 (text), line 825 (text), line 826 (text), line 829 (text), line
  831 (text), line 833 (text), line 834 (text), line 836 (text), line 838 (text), line 845 (text), line 849 (text), line 851 (text), line
  854 (text), line 855 (text), line 859 (text), line 861 (text), line 864 (text), line 866 (text), line 872 (text), line 874 (text), line
  877 (text), line 878 (text), line 881 (text), line 883 (text), line 885 (text), line 887 (text), line 889 (text), line 891 (text), line
  893 (text), line 899 (text), line 902 (text), line 904 (text), line 906 (text), line 908 (text), line 910 (text), line 912 (text), line
  914 (text), line 916 (text), line 918 (text), line 956 (text), line 957 (text), line 959 (text), line 962 (text), line 964 (text), line
  966 (text), line 968 (text), line 970 (text), line 976 (text), line 979 (text), line 981 (text), line 983 (text), line 985 (text), line
  987 (text), line 989 (text), line 997 (text), line 999 (text), line 1001 (text), line 1003 (text), line 1005 (text), line 1007 (text),
  line 1009 (text), line 1015 (text), line 1017 (text), line 1021 (text), line 1050 (text), line 1052 (text), line 1055 (text), line 1058
  (text), line 1059 (text), line 1066 (text), line 1069 (text), line 1071 (text), line 1073 (text), line 1075 (text), line 1081 (text), line
  1083 (text), line 1085 (text), line 1087 (text), line 1094 (text), line 1096 (text), line 1099 (text), line 1100 (text), line 1108 (text),
  line 1110 (text), line 1112 (text), line 1114 (text), line 1120 (text), line 1123 (text), line 1126 (text), line 1137 (text), line 1138
  (text), line 1141 (text), line 1149 (text), line 1151 (text), line 1153 (text), line 1160 (text), line 1161 (text), line 1164 (text), line
  1171 (text), line 1173 (text), line 1175 (text), line 1182 (text), line 1184 (text), line 1191 (text), line 1193 (text), line 1200 (text),
  line 1202 (text), line 1208 (text), line 1212 (text), line 1221 (text), line 1228 (text), line 1235 (text), line 1242 (text), line 1249
  (text), line 1255 (text), line 1263 (text), line 1269 (text), line 1293 (text), line 1294 (text), line 1295 (text), line 1298 (text), line
  1299 (text), line 1301 (text), line 1302 (text), line 1303 (text), line 1304 (text), line 1305 (text), line 1306 (text) and line 1307
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][456]: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][457]: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][458]: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line 35
  (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md][459]: selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49
  (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][460]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][461]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][462]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md][463]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][464]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][465]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][466]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md][467]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][468]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][469]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][470]: selected by [ADR-DSGN-RUNMODE][4]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line
  35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md][471]: selected by [ADR-DSGN-RUNMODE][4]:
  the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line
  49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][472]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][473]: selected by
  [ADR-DSGN-RUNMODE][4]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][474]: selected by [ADR-DSGN-RUNMODE][4]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line
  35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md][475]: selected by [ADR-DSGN-RUNMODE][4]:
  the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line
  49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][476]: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 8 (text), line 43 (text), line 43 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text), line
  61 (text), line 62 (text), line 63 (text), line 64 (text), line 65 (text), line 66 (text), line 67 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][477]: selected by [ADR-AUTO-TEST][3]:
  the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][478]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 33 (text), line 34 (text), line 35 (text), line 52 (text), line 66 (text), line 67 (text), line 68
  (text), line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 81 (text), line 83 (text), line 85 (text),
  line 86 (text), line 87 (text), line 97 (text), line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line
  108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line
  124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line
  140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line
  156 (text), line 158 (text), line 160 (text), line 161 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line
  171 (text), line 173 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line
  186 (text), line 188 (text), line 190 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 204 (text), line 205 (text), line 206 (text), line 207 (text), line 209 (text), line 210 (text), line
  212 (text), line 213 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line
  226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line
  241 (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 251 (text), line 252 (text), line 254 (text), line
  256 (text), line 258 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line
  272 (text), line 274 (text), line 276 (text), line 278 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line
  308 (text), line 310 (text), line 314 (text), line 318 (text), line 329 (text), line 331 (text), line 341 (text), line 349 (text), line
  353 (text), line 355 (text), line 357 (text), line 359 (text), line 364 (text), line 370 (text), line 373 (text), line 375 (text), line
  377 (text), line 379 (text), line 381 (text), line 383 (text), line 385 (text), line 387 (text), line 389 (text), line 390 (text), line
  391 (text), line 392 (text), line 394 (text), line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 403 (text), line
  405 (text), line 407 (text), line 409 (text), line 411 (text), line 413 (text), line 414 (text), line 415 (text), line 417 (text), line
  419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line 433 (text), line
  435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 444 (text), line 447 (text), line 449 (text), line
  451 (text), line 452 (text), line 454 (text), line 455 (text), line 456 (text), line 457 (text), line 459 (text), line 461 (text), line
  463 (text), line 464 (text), line 465 (text), line 467 (text), line 468 (text), line 469 (text), line 471 (text), line 472 (text), line
  473 (text), line 475 (text), line 477 (text), line 479 (text), line 483 (text), line 485 (text), line 487 (text), line 493 (text), line
  495 (text), line 497 (text), line 499 (text), line 501 (text), line 504 (text), line 506 (text), line 510 (text), line 512 (text), line
  516 (text), line 518 (text), line 520 (text), line 522 (text), line 524 (text), line 526 (text), line 528 (text), line 530 (text), line
  532 (text), line 534 (text), line 536 (text), line 538 (text), line 540 (text), line 542 (text), line 544 (text), line 546 (text), line
  548 (text), line 550 (text), line 552 (text), line 554 (text), line 556 (text), line 558 (text), line 560 (text), line 564 (text), line
  566 (text), line 568 (text), line 570 (text), line 573 (text), line 575 (text), line 577 (text), line 579 (text), line 581 (text), line
  583 (text), line 585 (text), line 587 (text), line 589 (text), line 591 (text), line 593 (text), line 595 (text), line 597 (text), line
  599 (text), line 601 (text), line 603 (text), line 605 (text), line 607 (text), line 609 (text), line 611 (text), line 613 (text), line
  615 (text), line 617 (text), line 619 (text), line 621 (text), line 623 (text), line 625 (text), line 627 (text), line 629 (text), line
  631 (text), line 633 (text), line 635 (text), line 637 (text), line 639 (text), line 641 (text), line 643 (text), line 645 (text), line
  647 (text), line 649 (text), line 651 (text), line 653 (text), line 655 (text), line 657 (text), line 660 (text), line 662 (text), line
  664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 675 (text), line 677 (text), line 679 (text), line
  681 (text), line 683 (text), line 685 (text), line 686 (text), line 688 (text), line 690 (text), line 692 (text), line 694 (text), line
  696 (text), line 697 (text), line 699 (text), line 701 (text), line 703 (text), line 705 (text), line 707 (text), line 708 (text), line
  710 (text), line 712 (text), line 714 (text), line 716 (text), line 717 (text), line 719 (text), line 721 (text), line 723 (text), line
  725 (text), line 727 (text), line 729 (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line 739 (text), line
  741 (text), line 743 (text), line 745 (text), line 747 (text), line 749 (text), line 751 (text), line 753 (text), line 755 (text), line
  757 (text), line 759 (text), line 761 (text), line 763 (text), line 765 (text), line 767 (text), line 769 (text), line 779 (text), line
  780 (text), line 782 (text), line 783 (text), line 785 (text), line 787 (text), line 789 (text), line 791 (text), line 796 (text), line
  797 (text), line 799 (text), line 802 (text), line 804 (text), line 805 (text), line 806 (text), line 814 (text), line 816 (text), line
  818 (text), line 822 (text), line 830 (text), line 840 (text), line 848 (text), line 850 (text), line 852 (text), line 854 (text), line
  856 (text), line 858 (text), line 860 (text), line 862 (text), line 864 (text), line 866 (text), line 868 (text), line 870 (text), line
  872 (text), line 874 (text), line 876 (text), line 878 (text), line 880 (text), line 882 (text), line 884 (text), line 886 (text), line
  888 (text), line 890 (text), line 892 (text), line 894 (text), line 896 (text), line 898 (text), line 900 (text), line 902 (text), line
  904 (text), line 906 (text), line 908 (text), line 910 (text), line 912 (text), line 914 (text), line 916 (text), line 918 (text), line
  920 (text), line 922 (text), line 924 (text), line 938 (text), line 941 (text), line 943 (text), line 945 (text), line 947 (text), line
  953 (text), line 958 (text), line 963 (text), line 974 (text), line 983 (text), line 984 (text), line 988 (text), line 989 (text), line
  991 (text), line 992 (text), line 994 (text), line 995 (text), line 996 (text), line 1008 (text), line 1016 (text), line 1027 (text), line
  1030 (text), line 1056 (text), line 1057 (text), line 1058 (text), line 1059 (text), line 1060 (text), line 1061 (text), line 1062 (text),
  line 1063 (text), line 1064 (text), line 1065 (text), line 1066 (text) and line 1067 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][479]: selected by [ADR-AUTO-TEST][3]: the
  file cites it at line 8 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 74 (text), line 76
  (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line
  110 (text), line 112 (text), line 115 (text), line 117 (text), line 120 (text), line 122 (text), line 124 (text), line 128 (text), line
  130 (text), line 132 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 146 (text), line 150 (text), line
  152 (text), line 156 (text), line 158 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 171 (text), line
  173 (text), line 175 (text), line 177 (text), line 178 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line
  205 (text), line 207 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 220 (text), line 222 (text), line
  224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line
  240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line 255 (text), line
  257 (text), line 260 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line 272 (text), line
  274 (text), line 276 (text), line 278 (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line
  290 (text), line 292 (text), line 295 (text), line 296 (text), line 299 (text), line 301 (text), line 304 (text), line 306 (text), line
  308 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text), line 323 (text), line
  326 (text), line 328 (text), line 330 (text), line 332 (text), line 334 (text), line 335 (text), line 337 (text), line 368 (text), line
  371 (text), line 374 (text), line 379 (text), line 395 (text), line 397 (text), line 407 (text), line 417 (text), line 421 (text), line
  423 (text), line 425 (text), line 428 (text), line 433 (text), line 438 (text), line 463 (text), line 465 (text), line 467 (text), line
  471 (text), line 479 (text), line 488 (text), line 496 (text), line 498 (text), line 500 (text), line 506 (text), line 512 (text), line
  519 (text), line 530 (text), line 539 (text), line 541 (text), line 545 (text), line 547 (text), line 549 (text), line 551 (text), line
  553 (text), line 555 (text), line 557 (text), line 564 (text), line 567 (text), line 570 (text), line 573 (text), line 576 (text), line
  579 (text), line 582 (text), line 585 (text), line 588 (text), line 591 (text), line 594 (text), line 597 (text), line 600 (text), line
  603 (text), line 606 (text), line 609 (text), line 612 (text), line 615 (text), line 618 (text), line 621 (text), line 624 (text), line
  627 (text), line 630 (text), line 633 (text), line 636 (text), line 639 (text), line 642 (text), line 645 (text), line 648 (text), line
  651 (text), line 654 (text), line 657 (text), line 660 (text), line 663 (text), line 666 (text), line 669 (text), line 672 (text), line
  675 (text), line 678 (text), line 686 (text), line 688 (text), line 690 (text), line 692 (text), line 694 (text), line 697 (text), line
  700 (text), line 701 (text), line 704 (text), line 705 (text), line 707 (text), line 709 (text), line 712 (text), line 714 (text), line
  716 (text), line 717 (text), line 720 (text), line 722 (text), line 724 (text), line 726 (text), line 728 (text), line 730 (text), line
  732 (text), line 734 (text), line 735 (text), line 738 (text), line 740 (text), line 741 (text), line 743 (text), line 746 (text), line
  748 (text), line 750 (text), line 751 (text), line 753 (text), line 756 (text), line 758 (text), line 759 (text), line 767 (text), line
  769 (text), line 771 (text), line 773 (text), line 775 (text), line 778 (text), line 780 (text), line 783 (text), line 786 (text), line
  787 (text), line 791 (text), line 793 (text), line 796 (text), line 799 (text), line 801 (text), line 803 (text), line 805 (text), line
  807 (text), line 809 (text), line 811 (text), line 813 (text), line 816 (text), line 818 (text), line 821 (text), line 823 (text), line
  825 (text), line 827 (text), line 829 (text), line 831 (text), line 837 (text), line 839 (text), line 841 (text), line 844 (text), line
  846 (text), line 847 (text), line 849 (text), line 851 (text), line 854 (text), line 856 (text), line 858 (text), line 860 (text), line
  862 (text), line 864 (text), line 866 (text), line 868 (text), line 870 (text), line 872 (text), line 873 (text), line 880 (text), line
  882 (text), line 885 (text), line 886 (text), line 888 (text), line 890 (text), line 892 (text), line 895 (text), line 896 (text), line
  898 (text), line 900 (text), line 908 (text), line 910 (text), line 912 (text), line 914 (text), line 915 (text), line 918 (text), line
  920 (text), line 922 (text), line 923 (text), line 925 (text), line 927 (text), line 934 (text), line 936 (text), line 939 (text), line
  940 (text), line 943 (text), line 945 (text), line 947 (text), line 949 (text), line 951 (text), line 953 (text), line 955 (text), line
  961 (text), line 964 (text), line 966 (text), line 968 (text), line 970 (text), line 972 (text), line 974 (text), line 976 (text), line
  978 (text), line 980 (text), line 987 (text), line 989 (text), line 991 (text), line 994 (text), line 995 (text), line 997 (text), line
  999 (text), line 1002 (text), line 1004 (text), line 1011 (text), line 1012 (text), line 1014 (text), line 1017 (text), line 1019 (text),
  line 1021 (text), line 1023 (text), line 1025 (text), line 1031 (text), line 1034 (text), line 1036 (text), line 1038 (text), line 1040
  (text), line 1042 (text), line 1044 (text), line 1052 (text), line 1054 (text), line 1056 (text), line 1058 (text), line 1060 (text), line
  1062 (text), line 1064 (text), line 1081 (text), line 1114 (text), line 1121 (text), line 1123 (text), line 1126 (text), line 1129 (text),
  line 1130 (text), line 1137 (text), line 1140 (text), line 1142 (text), line 1144 (text), line 1146 (text), line 1152 (text), line 1154
  (text), line 1156 (text), line 1158 (text), line 1165 (text), line 1167 (text), line 1170 (text), line 1171 (text), line 1181 (text), line
  1182 (text), line 1185 (text), line 1192 (text), line 1194 (text), line 1196 (text), line 1198 (text), line 1204 (text), line 1207 (text),
  line 1210 (text), line 1220 (text), line 1221 (text), line 1223 (text), line 1232 (text), line 1233 (text), line 1236 (text), line 1244
  (text), line 1246 (text), line 1248 (text), line 1255 (text), line 1257 (text), line 1259 (text), line 1266 (text), line 1268 (text), line
  1275 (text), line 1277 (text), line 1284 (text), line 1286 (text), line 1292 (text), line 1295 (text), line 1310 (text), line 1317 (text),
  line 1324 (text), line 1331 (text), line 1337 (text), line 1345 (text), line 1369 (text), line 1370 (text), line 1371 (text), line 1372
  (text), line 1373 (text), line 1374 (text), line 1375 (text), line 1376 (text), line 1377 (text), line 1378 (text), line 1379 (text) and
  line 1380 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][480]: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 8 (text), line 52 (text), line 52 (text), line 66 (text), line 67 (text), line 68 (text),
  line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 74 (text), line 75 (text), line 76 (text) and line 77
  (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][481]: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][482]: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 36 (text), line 53 (text), line 67 (text),
  line 68 (text), line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 74 (text), line 82 (text), line 84
  (text), line 86 (text), line 87 (text), line 88 (text), line 98 (text), line 100 (text), line 101 (text), line 103 (text), line 105
  (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137
  (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 147 (text), line 149 (text), line 151 (text), line 153
  (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 162 (text), line 164 (text), line 166 (text), line 168
  (text), line 170 (text), line 172 (text), line 174 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183
  (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 192 (text), line 194 (text), line 196 (text), line 198
  (text), line 200 (text), line 202 (text), line 204 (text), line 205 (text), line 206 (text), line 207 (text), line 208 (text), line 210
  (text), line 211 (text), line 213 (text), line 214 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223
  (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 239
  (text), line 241 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line 253
  (text), line 255 (text), line 257 (text), line 259 (text), line 261 (text), line 263 (text), line 265 (text), line 267 (text), line 269
  (text), line 271 (text), line 273 (text), line 275 (text), line 277 (text), line 279 (text), line 282 (text), line 284 (text), line 286
  (text), line 289 (text), line 310 (text), line 312 (text), line 316 (text), line 320 (text), line 331 (text), line 333 (text), line 343
  (text), line 351 (text), line 355 (text), line 357 (text), line 359 (text), line 361 (text), line 366 (text), line 372 (text), line 375
  (text), line 377 (text), line 379 (text), line 381 (text), line 383 (text), line 385 (text), line 387 (text), line 389 (text), line 391
  (text), line 392 (text), line 393 (text), line 394 (text), line 396 (text), line 397 (text), line 399 (text), line 401 (text), line 403
  (text), line 405 (text), line 407 (text), line 409 (text), line 411 (text), line 413 (text), line 415 (text), line 416 (text), line 417
  (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line 433
  (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445 (text), line 446 (text), line 449
  (text), line 451 (text), line 453 (text), line 454 (text), line 456 (text), line 457 (text), line 458 (text), line 459 (text), line 461
  (text), line 463 (text), line 465 (text), line 466 (text), line 467 (text), line 469 (text), line 470 (text), line 471 (text), line 473
  (text), line 474 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 485 (text), line 487 (text), line 489
  (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 503 (text), line 506 (text), line 508 (text), line 512
  (text), line 514 (text), line 518 (text), line 520 (text), line 522 (text), line 524 (text), line 526 (text), line 528 (text), line 530
  (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text), line 540 (text), line 542 (text), line 544 (text), line 546
  (text), line 548 (text), line 550 (text), line 552 (text), line 554 (text), line 556 (text), line 558 (text), line 560 (text), line 562
  (text), line 566 (text), line 568 (text), line 570 (text), line 572 (text), line 575 (text), line 577 (text), line 579 (text), line 581
  (text), line 583 (text), line 585 (text), line 587 (text), line 589 (text), line 591 (text), line 593 (text), line 595 (text), line 597
  (text), line 599 (text), line 601 (text), line 603 (text), line 605 (text), line 607 (text), line 609 (text), line 611 (text), line 613
  (text), line 615 (text), line 617 (text), line 619 (text), line 621 (text), line 623 (text), line 625 (text), line 627 (text), line 629
  (text), line 631 (text), line 633 (text), line 635 (text), line 637 (text), line 639 (text), line 641 (text), line 643 (text), line 645
  (text), line 647 (text), line 649 (text), line 651 (text), line 653 (text), line 655 (text), line 657 (text), line 659 (text), line 662
  (text), line 664 (text), line 666 (text), line 668 (text), line 670 (text), line 672 (text), line 674 (text), line 677 (text), line 679
  (text), line 681 (text), line 683 (text), line 685 (text), line 687 (text), line 688 (text), line 690 (text), line 692 (text), line 694
  (text), line 696 (text), line 698 (text), line 699 (text), line 701 (text), line 703 (text), line 705 (text), line 707 (text), line 709
  (text), line 710 (text), line 712 (text), line 714 (text), line 716 (text), line 718 (text), line 719 (text), line 721 (text), line 723
  (text), line 725 (text), line 727 (text), line 729 (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line 739
  (text), line 741 (text), line 743 (text), line 745 (text), line 747 (text), line 749 (text), line 751 (text), line 753 (text), line 755
  (text), line 757 (text), line 759 (text), line 761 (text), line 763 (text), line 765 (text), line 767 (text), line 769 (text), line 771
  (text), line 781 (text), line 782 (text), line 784 (text), line 785 (text), line 788 (text), line 790 (text), line 792 (text), line 794
  (text), line 799 (text), line 800 (text), line 802 (text), line 805 (text), line 808 (text), line 809 (text), line 810 (text), line 820
  (text), line 822 (text), line 824 (text), line 828 (text), line 836 (text), line 846 (text), line 855 (text), line 857 (text), line 859
  (text), line 861 (text), line 863 (text), line 865 (text), line 867 (text), line 869 (text), line 871 (text), line 873 (text), line 875
  (text), line 877 (text), line 879 (text), line 881 (text), line 883 (text), line 885 (text), line 887 (text), line 889 (text), line 891
  (text), line 893 (text), line 895 (text), line 897 (text), line 899 (text), line 901 (text), line 903 (text), line 905 (text), line 907
  (text), line 909 (text), line 911 (text), line 913 (text), line 915 (text), line 917 (text), line 919 (text), line 921 (text), line 923
  (text), line 925 (text), line 927 (text), line 929 (text), line 931 (text), line 945 (text), line 948 (text), line 967 (text), line 969
  (text), line 971 (text), line 977 (text), line 982 (text), line 987 (text), line 998 (text), line 1008 (text), line 1009 (text), line 1013
  (text), line 1014 (text), line 1016 (text), line 1017 (text), line 1019 (text), line 1020 (text), line 1021 (text), line 1033 (text), line
  1041 (text), line 1052 (text), line 1055 (text), line 1081 (text), line 1082 (text), line 1083 (text), line 1084 (text), line 1085 (text),
  line 1086 (text), line 1087 (text), line 1088 (text), line 1089 (text), line 1090 (text), line 1091 (text) and line 1092 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][483]: selected by
  [ADR-AUTO-TEST][3]: the file cites it at line 8 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 73 (text),
  line 75 (text), line 77 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 109 (text), line 111 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 124 (text), line 126
  (text), line 130 (text), line 132 (text), line 134 (text), line 141 (text), line 143 (text), line 145 (text), line 147 (text), line 148
  (text), line 152 (text), line 154 (text), line 158 (text), line 160 (text), line 165 (text), line 167 (text), line 169 (text), line 171
  (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 180 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203
  (text), line 205 (text), line 207 (text), line 209 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 222
  (text), line 224 (text), line 226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 238
  (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 250 (text), line 252 (text), line 254
  (text), line 257 (text), line 259 (text), line 262 (text), line 264 (text), line 266 (text), line 268 (text), line 270 (text), line 272
  (text), line 274 (text), line 276 (text), line 278 (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line 288
  (text), line 290 (text), line 292 (text), line 294 (text), line 297 (text), line 298 (text), line 301 (text), line 303 (text), line 306
  (text), line 308 (text), line 310 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line 321 (text), line 323
  (text), line 325 (text), line 328 (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 337 (text), line 339
  (text), line 370 (text), line 373 (text), line 376 (text), line 381 (text), line 397 (text), line 399 (text), line 409 (text), line 419
  (text), line 423 (text), line 425 (text), line 427 (text), line 430 (text), line 435 (text), line 440 (text), line 467 (text), line 469
  (text), line 471 (text), line 475 (text), line 483 (text), line 492 (text), line 503 (text), line 505 (text), line 507 (text), line 513
  (text), line 519 (text), line 526 (text), line 537 (text), line 547 (text), line 549 (text), line 553 (text), line 555 (text), line 557
  (text), line 559 (text), line 561 (text), line 563 (text), line 565 (text), line 572 (text), line 575 (text), line 578 (text), line 581
  (text), line 584 (text), line 587 (text), line 590 (text), line 593 (text), line 596 (text), line 599 (text), line 602 (text), line 605
  (text), line 608 (text), line 611 (text), line 614 (text), line 617 (text), line 620 (text), line 623 (text), line 626 (text), line 629
  (text), line 632 (text), line 635 (text), line 638 (text), line 641 (text), line 644 (text), line 647 (text), line 650 (text), line 653
  (text), line 656 (text), line 659 (text), line 662 (text), line 665 (text), line 668 (text), line 671 (text), line 674 (text), line 677
  (text), line 680 (text), line 683 (text), line 686 (text), line 694 (text), line 696 (text), line 698 (text), line 700 (text), line 702
  (text), line 705 (text), line 708 (text), line 709 (text), line 712 (text), line 713 (text), line 715 (text), line 717 (text), line 720
  (text), line 722 (text), line 724 (text), line 725 (text), line 728 (text), line 730 (text), line 732 (text), line 734 (text), line 736
  (text), line 738 (text), line 740 (text), line 742 (text), line 743 (text), line 746 (text), line 748 (text), line 749 (text), line 751
  (text), line 754 (text), line 756 (text), line 758 (text), line 759 (text), line 761 (text), line 764 (text), line 766 (text), line 767
  (text), line 775 (text), line 777 (text), line 779 (text), line 781 (text), line 783 (text), line 786 (text), line 788 (text), line 791
  (text), line 794 (text), line 795 (text), line 799 (text), line 801 (text), line 804 (text), line 807 (text), line 809 (text), line 811
  (text), line 813 (text), line 815 (text), line 817 (text), line 819 (text), line 821 (text), line 824 (text), line 826 (text), line 829
  (text), line 831 (text), line 833 (text), line 835 (text), line 837 (text), line 839 (text), line 845 (text), line 847 (text), line 849
  (text), line 852 (text), line 854 (text), line 855 (text), line 857 (text), line 859 (text), line 862 (text), line 864 (text), line 866
  (text), line 868 (text), line 870 (text), line 872 (text), line 874 (text), line 876 (text), line 878 (text), line 880 (text), line 881
  (text), line 888 (text), line 890 (text), line 893 (text), line 894 (text), line 896 (text), line 898 (text), line 900 (text), line 903
  (text), line 904 (text), line 906 (text), line 908 (text), line 916 (text), line 918 (text), line 920 (text), line 922 (text), line 923
  (text), line 926 (text), line 928 (text), line 930 (text), line 931 (text), line 933 (text), line 935 (text), line 942 (text), line 944
  (text), line 947 (text), line 948 (text), line 951 (text), line 953 (text), line 955 (text), line 957 (text), line 959 (text), line 961
  (text), line 963 (text), line 969 (text), line 972 (text), line 974 (text), line 976 (text), line 978 (text), line 980 (text), line 982
  (text), line 984 (text), line 986 (text), line 988 (text), line 995 (text), line 997 (text), line 999 (text), line 1002 (text), line 1003
  (text), line 1005 (text), line 1007 (text), line 1010 (text), line 1012 (text), line 1019 (text), line 1020 (text), line 1022 (text), line
  1025 (text), line 1027 (text), line 1029 (text), line 1031 (text), line 1033 (text), line 1039 (text), line 1042 (text), line 1044 (text),
  line 1046 (text), line 1048 (text), line 1050 (text), line 1052 (text), line 1060 (text), line 1062 (text), line 1064 (text), line 1066
  (text), line 1068 (text), line 1070 (text), line 1072 (text), line 1108 (text), line 1141 (text), line 1148 (text), line 1150 (text), line
  1153 (text), line 1156 (text), line 1157 (text), line 1164 (text), line 1167 (text), line 1169 (text), line 1171 (text), line 1173 (text),
  line 1179 (text), line 1181 (text), line 1183 (text), line 1185 (text), line 1192 (text), line 1194 (text), line 1197 (text), line 1198
  (text), line 1208 (text), line 1209 (text), line 1212 (text), line 1219 (text), line 1221 (text), line 1223 (text), line 1225 (text), line
  1231 (text), line 1234 (text), line 1237 (text), line 1247 (text), line 1249 (text), line 1251 (text), line 1260 (text), line 1261 (text),
  line 1264 (text), line 1272 (text), line 1274 (text), line 1276 (text), line 1283 (text), line 1285 (text), line 1287 (text), line 1296
  (text), line 1303 (text), line 1305 (text), line 1312 (text), line 1314 (text), line 1321 (text), line 1323 (text), line 1329 (text), line
  1332 (text), line 1348 (text), line 1355 (text), line 1362 (text), line 1368 (text), line 1376 (text), line 1400 (text), line 1401 (text),
  line 1402 (text), line 1403 (text), line 1404 (text), line 1405 (text), line 1406 (text), line 1407 (text), line 1408 (text), line 1409
  (text), line 1410 (text) and line 1411 (text).
- [docs/adr/automation/BCL/index.md][484]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected by
  [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][485]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][486]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][487]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][488]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected by
  [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][489]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][490]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][491]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][492]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][493]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][494]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][495]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected by
  [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][496]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][497]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][498]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][499]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][500]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected by
  [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/test-artifacts.md][501]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][502]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][1]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][503]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][504]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][505]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][506]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][507]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][2]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/protected-globs.md][508]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][509]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected by
  [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][510]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][511]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][512]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][513]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][514]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][3]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][515]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][516]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code; selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][517]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][518]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code; selected
  by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][519]: selected by [ADR-AUTO-ASSETDEP][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code; selected by [ADR-AUTO-BUNDLE][2]: an ADR file of the `automation` ADR domain, the ADR domain of that code;
  selected by [ADR-AUTO-TEST][3]: an ADR file of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/design/commit-lifecycle.md][520]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][521]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][522]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][4]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][523]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][524]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][525]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/tracks.md][526]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][527]: selected by [ADR-DSGN-RUNMODE][4]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][528]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 329 (text), line 367 (text), line 378 (text), line
  411 (text), line 446 (text), line 464 (text), line 476 (text), line 490 (text), line 512 (text), line 526 (text), line 537 (text) and line
  557 (text).
- [docs/adr/index.md][529]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 151 (text); selected by [ADR-AUTO-BUNDLE][2]: the
  file cites it at line 150 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 133 (text); selected by [ADR-DSGN-RUNMODE][4]:
  the file cites it at line 94 (text).
- [docs/explanation/automation/build-then-place-with-one-command.md][530]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 17
  (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][531]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 68
  (text); selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 17 (text), line 58 (text), line 60 (text), line 61 (text), line 63
  (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][532]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 17 (text),
  line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][533]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 17 (text),
  line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at
  line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][534]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 14
  (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 47 (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][535]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 18
  (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][536]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 15
  (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 15 (text), line 50
  (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][537]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 17 (text),
  line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by [ADR-DSGN-RUNMODE][4]: the
  file cites it at line 41 (text), line 51 (text), line 66 (text), line 69 (text) and line 73 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][538]: selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 18
  (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/two-gates-check-the-layer-pins.md][539]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 15 (text),
  line 53 (text) and line 67 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][540]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 62
  (text); selected by [ADR-AUTO-BUNDLE][2]: the file cites it at line 16 (text), line 19 (text), line 31 (text), line 33 (text), line 49
  (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text); selected by [ADR-AUTO-TEST][3]: the file cites it at line 16
  (text), line 55 (text) and line 56 (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 16 (text), line 42 (text), line 57
  (text), line 63 (text) and line 64 (text).
- [docs/explanation/configuration/one-gate-guards-the-read-path.md][541]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 17
  (text), line 29 (text) and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][542]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 17 (text), line
  60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][543]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 56 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][544]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][545]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 17
  (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][546]: selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 14
  (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][547]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 72
  (text); selected by [ADR-DSGN-RUNMODE][4]: the file cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text), line 58
  (text), line 59 (text), line 60 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][548]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 62 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][549]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 17 (text) and
  line 60 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][550]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 16 (text)
  and line 52 (text).
- [docs/how-to/automation/manual-test-plan.md][551]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 56 (text) and line 62 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][552]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 17 (text) and line 69
  (text).
- [docs/how-to/automation/manual-test-plan/docs-and-links.md][553]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 13 (text).
- [docs/how-to/automation/manual-test-plan/module-system.md][554]: selected by [ADR-AUTO-ASSETDEP][1]: the file cites it at line 20 (text)
  and line 20 (text).
- [docs/how-to/automation/manual-test-plan/test-harness.md][555]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 17 (text).
- [docs/how-to/getting-started/automation/run-tests-and-checks.md][556]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 33
  (text).
- [docs/references/automation/catzc-base-docs.md][557]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 34 (text).
- [docs/references/automation/catzc-base-globs.md][558]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 44 (text).
- [docs/references/automation/catzc-base-languages.md][559]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 39 (text).
- [docs/references/automation/catzc-base-modulesystem.md][560]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 36 (text).
- [docs/references/automation/catzc-base-rootconfig.md][561]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 50 (text).

### pipelines × pipeline-yaml (1 lit file, touched)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][5]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [pipelines/ci-infrastructure.yaml][562]: selected by [ADR-AUTO-TEST][3]: the file cites it at line 68 (body comment) (a passing mention
  only).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][563]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [importer.ps1][564]: selected by [ADR-AUTO-BUNDLE][2]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by [ADR-AUTO-TEST][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/tests/Import-AllModules.Tests.ps1` line 200
  (body comment), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 1 (text),
  `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 80 (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1`
  line 5 (header) and `automation/.internal/tests/Test-FolderConventions.Tests.ps1` line 2 (header); selected by [ADR-DSGN-RUNMODE][4]: a
  root file carries the citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1`
  line 5 (header) and `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][563]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][565]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.gitattributes][566]: selected by [ADR-AUTO-ASSETDEP][1]: a root file carries the citations of its owner module's files (files.yml),
  which cite it at `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 17 (header); selected by [ADR-AUTO-TEST][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1`
  line 2 (header) and `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header); selected by
  [ADR-DSGN-RUNMODE][4]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line
  10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][567]: selected by [ADR-AUTO-ASSETDEP][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 7 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 17 (header); selected by [ADR-AUTO-TEST][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1`
  line 2 (header) and `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header); selected by
  [ADR-DSGN-RUNMODE][4]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line
  10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][568]
- [track][569]
- [file language][570]
- [cell][571]
- [lit cell][572]
- [root file][573]
- [unlisted file][574]
- [.claude][575]: a track
- [.github][575]: a track
- [automation][575]: a track
- [docs][575]: a track
- [pipelines][575]: a track
- [csharp][576]: a file language
- [markdown][576]: a file language
- [pipeline-yaml][576]: a file language
- [powershell][576]: a file language
- [yaml][576]: a file language

Terms the cited ADRs define:

- [all tests][577], defined by [ADR-AUTO-TEST#36][578]
- [build verification test][579], defined by [ADR-AUTO-TEST#24][580]
- [category][581], defined by [ADR-AUTO-TEST#1][582]
- [phase][583], defined by [ADR-AUTO-TEST#26][584]
- [quality gate][585], defined by [ADR-AUTO-TEST#35][586]
- [test][587], defined by [ADR-AUTO-TEST#42][588]
- [test file][589], defined by [ADR-AUTO-TEST#43][590]
- [test run][591], defined by [ADR-AUTO-TEST#34][592]
- [test suite][593], defined by [ADR-AUTO-TEST#37][594]
- [testing in production][595], defined by [ADR-AUTO-TEST#41][596]
- [tier][597], defined by [ADR-AUTO-TEST#13][598]
- [vertical test][599], defined by [ADR-AUTO-TEST#38][600]

[1]: ../../adr/automation/internal-asset-dependencies.md
[2]: ../../adr/automation/platform-bundle.md
[3]: ../../adr/automation/test-automation.md
[4]: ../../adr/design/run-modes.md
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[8]: ../../../.claude/CLAUDE.md
[9]: ../../../.claude/agents/catzc-worker.md
[10]: ../../../.claude/agents/test-optimization.md
[11]: ../../../.github/workflows/ci-automation.yml
[12]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[13]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[14]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[15]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[16]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[17]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[18]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[19]: ../../../automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
[20]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[21]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[22]: ../../../automation/Catzc.Base.Timeouts/types/TestTiers.cs
[23]: ../../../automation/.internal/assets/Import-Catzc.ps1
[24]: ../../../automation/.internal/tests/Import-AllModules.Tests.ps1
[25]: ../../../automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
[26]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[27]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[28]: ../../../automation/.internal/tests/Test-FolderConventions.Tests.ps1
[29]: ../../../automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1
[30]: ../../../automation/.scriptanalyzer/tests/NoScriptRootAnchor.Tests.ps1
[31]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
[32]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[33]: ../../../automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
[34]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[35]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
[36]: ../../../automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
[37]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[38]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
[39]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
[40]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
[41]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
[42]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
[43]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
[44]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
[45]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
[46]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
[47]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
[48]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[49]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
[50]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
[51]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
[52]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
[53]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
[54]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
[55]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
[56]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
[57]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
[58]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
[59]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
[60]: ../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[61]: ../../../automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
[62]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[63]: ../../../automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
[64]: ../../../automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
[65]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
[66]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
[67]: ../../../automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
[68]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
[69]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
[70]: ../../../automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
[71]: ../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[72]: ../../../automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
[73]: ../../../automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1
[74]: ../../../automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
[75]: ../../../automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[76]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1
[77]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[78]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[79]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
[80]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
[81]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[82]: ../../../automation/Catzc.Base.Contracts/Test-Contracts.ps1
[83]: ../../../automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
[84]: ../../../automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
[85]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
[86]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
[87]: ../../../automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
[88]: ../../../automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
[89]: ../../../automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
[90]: ../../../automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
[91]: ../../../automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
[92]: ../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[93]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[94]: ../../../automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
[95]: ../../../automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1
[96]: ../../../automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
[97]: ../../../automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
[98]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
[99]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
[100]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[101]: ../../../automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
[102]: ../../../automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1
[103]: ../../../automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
[104]: ../../../automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
[105]: ../../../automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
[106]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
[107]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
[108]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
[109]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
[110]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
[111]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
[112]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
[113]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
[114]: ../../../automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
[115]: ../../../automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
[116]: ../../../automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
[117]: ../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[118]: ../../../automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
[119]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[120]: ../../../automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
[121]: ../../../automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
[122]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
[123]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
[124]: ../../../automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
[125]: ../../../automation/Catzc.Base.Execution/Invoke-Executable.ps1
[126]: ../../../automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
[127]: ../../../automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
[128]: ../../../automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
[129]: ../../../automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
[130]: ../../../automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
[131]: ../../../automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
[132]: ../../../automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
[133]: ../../../automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
[134]: ../../../automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
[135]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[136]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[137]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[138]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[139]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[140]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[141]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[142]: ../../../automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
[143]: ../../../automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
[144]: ../../../automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
[145]: ../../../automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
[146]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[147]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[148]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[149]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[150]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[151]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[152]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
[153]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[154]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[155]: ../../../automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
[156]: ../../../automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
[157]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
[158]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[159]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
[160]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[161]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
[162]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
[163]: ../../../automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[164]: ../../../automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
[165]: ../../../automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
[166]: ../../../automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
[167]: ../../../automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
[168]: ../../../automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
[169]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[170]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[171]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[172]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[173]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[174]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[175]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[176]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[177]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[178]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[179]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[180]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[181]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[182]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[183]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[184]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[185]: ../../../automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
[186]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[187]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[188]: ../../../automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
[189]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
[190]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
[191]: ../../../automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
[192]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
[193]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
[194]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
[195]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
[196]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
[197]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
[198]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
[199]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
[200]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
[201]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[202]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[203]: ../../../automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
[204]: ../../../automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1
[205]: ../../../automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
[206]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[207]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[208]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[209]: ../../../automation/Catzc.Base.QualityGates/Test-Change.ps1
[210]: ../../../automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
[211]: ../../../automation/Catzc.Base.QualityGates/Test-Formatting.ps1
[212]: ../../../automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
[213]: ../../../automation/Catzc.Base.QualityGates/Test-Links.ps1
[214]: ../../../automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
[215]: ../../../automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
[216]: ../../../automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
[217]: ../../../automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
[218]: ../../../automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1
[219]: ../../../automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
[220]: ../../../automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
[221]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[222]: ../../../automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1
[223]: ../../../automation/Catzc.Base.QualityGates/Test-Spelling.ps1
[224]: ../../../automation/Catzc.Base.QualityGates/Test-Terminology.ps1
[225]: ../../../automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
[226]: ../../../automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
[227]: ../../../automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
[228]: ../../../automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
[229]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[230]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[231]: ../../../automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
[232]: ../../../automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1
[233]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
[234]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
[235]: ../../../automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1
[236]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
[237]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1
[238]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
[239]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
[240]: ../../../automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
[241]: ../../../automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
[242]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
[243]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[244]: ../../../automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
[245]: ../../../automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
[246]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
[247]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
[248]: ../../../automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
[249]: ../../../automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
[250]: ../../../automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
[251]: ../../../automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
[252]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
[253]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
[254]: ../../../automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
[255]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
[256]: ../../../automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
[257]: ../../../automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
[258]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
[259]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
[260]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
[261]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
[262]: ../../../automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
[263]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
[264]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
[265]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
[266]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
[267]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
[268]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
[269]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
[270]: ../../../automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
[271]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1
[272]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
[273]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
[274]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
[275]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
[276]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
[277]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[278]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
[279]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
[280]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
[281]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
[282]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
[283]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
[284]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
[285]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
[286]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
[287]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
[288]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
[289]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
[290]: ../../../automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
[291]: ../../../automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
[292]: ../../../automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
[293]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
[294]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
[295]: ../../../automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
[296]: ../../../automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
[297]: ../../../automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
[298]: ../../../automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
[299]: ../../../automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
[300]: ../../../automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
[301]: ../../../automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
[302]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
[303]: ../../../automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
[304]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[305]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[306]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
[307]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
[308]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
[309]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
[310]: ../../../automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
[311]: ../../../automation/Catzc.Base.QualityGates/tests/Test-InIsolation.Tests.ps1
[312]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
[313]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
[314]: ../../../automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
[315]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
[316]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
[317]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
[318]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
[319]: ../../../automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
[320]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
[321]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
[322]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[323]: ../../../automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
[324]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
[325]: ../../../automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
[326]: ../../../automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
[327]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
[328]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
[329]: ../../../automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
[330]: ../../../automation/Catzc.Base.Reports/Write-QualityGateReport.ps1
[331]: ../../../automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
[332]: ../../../automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
[333]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[334]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[335]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[336]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
[337]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
[338]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[339]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[340]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[341]: ../../../automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
[342]: ../../../automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
[343]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
[344]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
[345]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[346]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[347]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[348]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[349]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[350]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[351]: ../../../automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
[352]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[353]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
[354]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[355]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
[356]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[357]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[358]: ../../../automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
[359]: ../../../automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
[360]: ../../../automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
[361]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
[362]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
[363]: ../../../automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
[364]: ../../../automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
[365]: ../../../automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
[366]: ../../../automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
[367]: ../../../automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
[368]: ../../../automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
[369]: ../../../automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
[370]: ../../../automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
[371]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[372]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
[373]: ../../../automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
[374]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
[375]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
[376]: ../../../automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
[377]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
[378]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
[379]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
[380]: ../../../automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
[381]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
[382]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
[383]: ../../../automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1
[384]: ../../../automation/Catzc.Tooling.Toolchain/Install-Dotnet.ps1
[385]: ../../../automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
[386]: ../../../automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1
[387]: ../../../automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
[388]: ../../../automation/Catzc.Azure.DevOps/configs/identity-tokens.yml
[389]: ../../../automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
[390]: ../../../automation/Catzc.Azure/configs/identity-tokens.yml
[391]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[392]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[393]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
[394]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
[395]: ../../../automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml
[396]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[397]: ../../../automation/Catzc.Base.ModuleSystem/configs/artifacts.yml
[398]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[399]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[400]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[401]: ../../../automation/Catzc.Base.QualityGates/configs/test-policy.yml
[402]: ../../../automation/Catzc.Base.Reports/configs/reports.yml
[403]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[404]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[405]: adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
[406]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[407]: adr-auto-bundle--build-then-place-with-one-command--operations.tree.md
[408]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[409]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
[410]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[411]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md
[412]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[413]: adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
[414]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[415]: adr-auto-bundle--dot-source-one-entry-script--operations.tree.md
[416]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[417]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[418]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[419]: adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
[420]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[421]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
[422]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[423]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md
[424]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[425]: adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
[426]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[427]: adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md
[428]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[429]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[430]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[431]: adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md
[432]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[433]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[434]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[435]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md
[436]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[437]: adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
[438]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[439]: adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md
[440]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[441]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[442]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[443]: adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
[444]: adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
[445]: adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md
[446]: adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
[447]: adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md
[448]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[449]: adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md
[450]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[451]: adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md
[452]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[453]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[454]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[455]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[456]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[457]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[458]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[459]: adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md
[460]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[461]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[462]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[463]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md
[464]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[465]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[466]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[467]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
[468]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[469]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[470]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[471]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
[472]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[473]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[474]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[475]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md
[476]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[477]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[478]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[479]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[480]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[481]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[482]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[483]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[484]: ../../adr/automation/BCL/index.md
[485]: ../../adr/automation/BCL/native-csharp-types.md
[486]: ../../adr/automation/avoid-deep-nesting.md
[487]: ../../adr/automation/bash/bash-test-artifacts.md
[488]: ../../adr/automation/caching.md
[489]: ../../adr/automation/console-output-matters.md
[490]: ../../adr/automation/controlling-module-dependencies.md
[491]: ../../adr/automation/controlling-systemwide-deps.md
[492]: ../../adr/automation/cross-platform.md
[493]: ../../adr/automation/devbox-pipeline-parity.md
[494]: ../../adr/automation/dora-explains.md
[495]: ../../adr/automation/dry-run.md
[496]: ../../adr/automation/effective-in-enterprises.md
[497]: ../../adr/automation/environment-variables.md
[498]: ../../adr/automation/execution-engines.md
[499]: ../../adr/automation/fail-fast-with-asserts.md
[500]: ../../adr/automation/go/index.md
[501]: ../../adr/automation/go/test-artifacts.md
[502]: ../../adr/automation/idempotent-state-functions.md
[503]: ../../adr/automation/log-before-invoke.md
[504]: ../../adr/automation/managed-guids.md
[505]: ../../adr/automation/never-depend-on-pwd.md
[506]: ../../adr/automation/open-closed-architecture.md
[507]: ../../adr/automation/path-representation.md
[508]: ../../adr/automation/protected-globs.md
[509]: ../../adr/automation/python/index.md
[510]: ../../adr/automation/python/python-test-artifacts.md
[511]: ../../adr/automation/retry-as-last-resort.md
[512]: ../../adr/automation/sensible-defaults.md
[513]: ../../adr/automation/single-responsibility-functions.md
[514]: ../../adr/automation/spell-out-names.md
[515]: ../../adr/automation/tool-removal-lifecycle.md
[516]: ../../adr/automation/tracked-files-from-the-index.md
[517]: ../../adr/automation/use-proper-package-managers.md
[518]: ../../adr/automation/uv-python-handler.md
[519]: ../../adr/automation/zero-ceremony-poka-yoke.md
[520]: ../../adr/design/commit-lifecycle.md
[521]: ../../adr/design/dora-explains.md
[522]: ../../adr/design/module-aspects.md
[523]: ../../adr/design/self-service.md
[524]: ../../adr/design/server-remote-integration.md
[525]: ../../adr/design/thin-platforms.md
[526]: ../../adr/design/tracks.md
[527]: ../../adr/design/visual-design.md
[528]: ../../adr/glossary.md
[529]: ../../adr/index.md
[530]: ../../explanation/automation/build-then-place-with-one-command.md
[531]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[532]: ../../explanation/automation/dot-source-one-entry-script.md
[533]: ../../explanation/automation/every-code-root-is-a-copy.md
[534]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[535]: ../../explanation/automation/invoke-importer-in-code-order.md
[536]: ../../explanation/automation/one-commit-one-immutable-package.md
[537]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[538]: ../../explanation/automation/two-entries-feed-one-importer.md
[539]: ../../explanation/automation/two-gates-check-the-layer-pins.md
[540]: ../../explanation/automation/what-gates-each-bundle-stage.md
[541]: ../../explanation/configuration/one-gate-guards-the-read-path.md
[542]: ../../explanation/design/one-entry-script-per-mode.md
[543]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[544]: ../../explanation/design/shims-set-roots-mode-read-back.md
[545]: ../../explanation/design/two-roots-one-importer-same-modules.md
[546]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[547]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[548]: ../../explanation/design/which-rung-gates-exist-in-code.md
[549]: ../../explanation/flow/gates-check-source-and-trigger.md
[550]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[551]: ../../how-to/automation/manual-test-plan.md
[552]: ../../how-to/automation/manual-test-plan/azure.md
[553]: ../../how-to/automation/manual-test-plan/docs-and-links.md
[554]: ../../how-to/automation/manual-test-plan/module-system.md
[555]: ../../how-to/automation/manual-test-plan/test-harness.md
[556]: ../../how-to/getting-started/automation/run-tests-and-checks.md
[557]: ../../references/automation/catzc-base-docs.md
[558]: ../../references/automation/catzc-base-globs.md
[559]: ../../references/automation/catzc-base-languages.md
[560]: ../../references/automation/catzc-base-modulesystem.md
[561]: ../../references/automation/catzc-base-rootconfig.md
[562]: ../../../pipelines/ci-infrastructure.yaml
[563]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[564]: ../../../importer.ps1
[565]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[566]: ../../../.gitattributes
[567]: ../../../.gitignore
[568]: ../../adr/glossary.md#world-map
[569]: ../../adr/glossary.md#track
[570]: ../../adr/glossary.md#file-language
[571]: ../../adr/glossary.md#cell
[572]: ../../adr/glossary.md#lit-cell
[573]: ../../adr/glossary.md#root-file
[574]: ../../adr/glossary.md#unlisted-file
[575]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[576]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[577]: ../../adr/glossary.md#all-tests
[578]: ../../adr/automation/test-automation.md#rule-adr-auto-test36
[579]: ../../adr/glossary.md#build-verification-test
[580]: ../../adr/automation/test-automation.md#rule-adr-auto-test24
[581]: ../../adr/glossary.md#category
[582]: ../../adr/automation/test-automation.md#rule-adr-auto-test1
[583]: ../../adr/glossary.md#phase
[584]: ../../adr/automation/test-automation.md#rule-adr-auto-test26
[585]: ../../adr/glossary.md#quality-gate
[586]: ../../adr/automation/test-automation.md#rule-adr-auto-test35
[587]: ../../adr/glossary.md#test
[588]: ../../adr/automation/test-automation.md#rule-adr-auto-test42
[589]: ../../adr/glossary.md#test-file
[590]: ../../adr/automation/test-automation.md#rule-adr-auto-test43
[591]: ../../adr/glossary.md#test-run
[592]: ../../adr/automation/test-automation.md#rule-adr-auto-test34
[593]: ../../adr/glossary.md#test-suite
[594]: ../../adr/automation/test-automation.md#rule-adr-auto-test37
[595]: ../../adr/glossary.md#testing-in-production
[596]: ../../adr/automation/test-automation.md#rule-adr-auto-test41
[597]: ../../adr/glossary.md#tier
[598]: ../../adr/automation/test-automation.md#rule-adr-auto-test13
[599]: ../../adr/glossary.md#vertical-test
[600]: ../../adr/automation/test-automation.md#rule-adr-auto-test38

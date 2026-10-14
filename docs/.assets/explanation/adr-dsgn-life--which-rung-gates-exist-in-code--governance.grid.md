# docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md

`Grid minimap: adr-dsgn-life--which-rung-gates-exist-in-code--governance`

![Grid minimap of adr-dsgn-life--which-rung-gates-exist-in-code--governance](adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.png)

The grid minimap of the slide `adr-dsgn-life--which-rung-gates-exist-in-code--governance` (governance lens). The slide supports
[ADR-AUTO-TEST][1], [ADR-DSGN-LIFE][2], [ADR-DSGN-VISUAL][3] and [ADR-FLOW-CD][4]; the highlight of those ADR codes selects what is lit, and
each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 6 lit of 9 files
- automation × csharp: 10 lit of 219 files
- automation × powershell: 324 lit of 1412 files
- automation × yaml: 16 lit of 95 files
- docs × markdown: 90 lit of 742 files
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

### .claude × markdown (6 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.claude/CLAUDE.md][8]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 50 (text); selected by [ADR-FLOW-CD][4]: the file cites
  it at line 51 (text).
- [.claude/agents/catzc-worker.md][9]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 48 (text).
- [.claude/agents/drawio-diagram-waves.md][10]: selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 48 (text).
- [.claude/agents/test-optimization.md][11]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (text), line 21 (text), line 21
  (text), line 21 (text), line 22 (text), line 23 (text), line 52 (text), line 57 (text), line 58 (text), line 62 (text), line 62 (text),
  line 67 (text) and line 75 (text).
- [.claude/agents/write-drawio-files.md][12]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 43 (text); selected by
  [ADR-DSGN-VISUAL][3]: the file cites it at line 43 (text) and line 129 (text).
- [.claude/drawio/STYLE.md][13]: selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 41 (text), line 52 (text) and line 64 (text);
  selected by [ADR-FLOW-CD][4]: the file cites it at line 28 (text).

### automation × csharp (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][14]: selected by [ADR-FLOW-CD][4]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][15]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 40 (body comment) (a
  passing mention only); selected by [ADR-FLOW-CD][4]: the file cites it at line 41 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][16]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][17]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][18]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][19]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs][20]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][21]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][22]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Timeouts/types/TestTiers.cs][23]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2 (header) and line 3
  (header).

### automation × powershell (324 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/.internal/tests/Import-AllModules.Tests.ps1][24]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 206 (body comment)
  (a passing mention only).
- [automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1][25]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1 (text) and line
  80 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][26]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/.internal/tests/Test-FolderConventions.Tests.ps1][27]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1][28]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 154
  (text).
- [automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1][29]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 13 (body comment) (a passing mention only).
- [automation/Catzc.Azure.DevOps/Test-Pipelines.ps1][30]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 9 (header).
- [automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1][31]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 207 (body
  comment) (a passing mention only).
- [automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1][32]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 44 (text)
  and line 53 (text).
- [automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1][33]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 10
  (header).
- [automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1][34]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 23
  (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1][35]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8
  (header), line 10 (header) and line 13 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1][36]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 18
  (header) and line 26 (header).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1][37]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1][38]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 5 (body comment), line 5 (body comment) and line 36 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1][39]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 4 (body comment), line 4 (body comment), line 10 (body comment) and line 39 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1][40]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 5 (body comment), line 5 (body comment), line 11 (body comment) and line 40 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1][41]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1][42]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (body
  comment), line 5 (body comment), line 9 (body comment) and line 39 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1][43]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 34 (body comment), line 124 (body comment) and line 176 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1][44]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 46 (body
  comment), line 46 (body comment) and line 98 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1][45]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 6 (body comment), line 6 (body comment), line 11 (body comment) and line 51 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1][46]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 9 (header), line 12 (header), line 15 (header), line 20 (header) and line 25 (body comment).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1][47]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1][48]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1][49]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1][50]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1][51]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1][52]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 5 (body comment) and line 5 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1][53]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 4 (body comment), line 4 (body comment), line 42 (body comment) and line 42 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1][54]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1][55]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment), line 4 (body comment), line 57 (body comment) and line 57 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1][56]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (body comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1][57]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  4 (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1][58]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1][59]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 43 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1][60]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (body comment) (a passing mention only).
- [automation/Catzc.Azure/Test-AzureNetworkPlan.ps1][61]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1][62]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1][63]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment)
  (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1][64]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1][65]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1][66]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1][67]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment) and line 4 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1][68]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1][69]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (body comment)
  and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1][70]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (body
  comment) and line 7 (body comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1][71]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1][72]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body comment),
  line 15 (body comment), line 18 (body comment) and line 188 (body comment) (a passing mention only).
- [automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1][73]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 119 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][74]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1][75]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1][76]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.Contracts/Test-Contracts.ps1][77]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1][78]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1][79]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1][80]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1][81]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1][82]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1][83]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header), line 7 (header), line 35 (text), line 55 (body comment), line 79 (text) and line 187 (body comment).
- [automation/Catzc.Base.Docs/Test-AdrRegistry.ps1][84]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1][85]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1][86]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][87]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 17 (header).
- [automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1][88]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 18
  (header).
- [automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1][89]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1][90]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1][91]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1][92]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1][93]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header) and
  line 42 (body comment).
- [automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1][94]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1][95]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1][96]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1][97]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header), line
  22 (text), line 23 (text) and line 27 (text).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1][98]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1][99]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1][100]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1][101]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1][102]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 6 (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1][103]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1][104]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  5 (header) and line 17 (text).
- [automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1][105]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1][106]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1][107]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header), line 45 (text), line 104 (text) and line 115 (text).
- [automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1][108]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][109]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 47 (body
  comment), line 82 (body comment), line 83 (body comment) and line 96 (text).
- [automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1][110]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][111]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1][112]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1][113]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1][114]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header) and line 16 (text).
- [automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1][115]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header) and line 11 (text).
- [automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1][116]: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 6 (text).
- [automation/Catzc.Base.Execution/Invoke-Executable.ps1][117]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 107 (body comment)
  (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1][118]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1][119]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1][120]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 81
  (text) and line 81 (body comment).
- [automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1][121]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1][122]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1][123]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1][124]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1][125]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1][126]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (body comment), line 13 (body comment) and line 15 (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1][127]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1][128]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1][129]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (body comment) and line 8 (body comment) (a passing mention only).
- [automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1][130]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][131]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][132]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 14
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][133]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 18 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][134]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][135]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1][136]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (body comment)
  (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][137]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 16 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][138]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1][139]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  2 (header), line 19 (text), line 30 (text) and line 42 (text).
- [automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1][140]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header), line 4 (header), line 18 (text), line 25 (text) and line 36 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1][141]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][142]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header), line 5 (header), line 29 (text), line 37 (text) and line 50 (text).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1][143]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  2 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][144]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 32 (body
  comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1][145]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1][146]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  2 (header).
- [automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1][147]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1][148]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1][149]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1][150]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (body comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1][151]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 17 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1][152]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][153]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 22 (header);
  selected by [ADR-FLOW-CD][4]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][154]: selected by [ADR-FLOW-CD][4]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][155]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][156]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][157]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][158]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][159]: selected by [ADR-FLOW-CD][4]: the file cites it at line 70 (text)
  and line 71 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][160]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header), line 7 (header), line 45 (text), line 74 (text), line 80 (text) and line 90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][161]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header),
  line 7 (header), line 53 (text), line 104 (text), line 111 (text) and line 121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][162]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][163]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][164]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 34 (body
  comment) (a passing mention only).
- [automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1][165]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][166]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][167]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1][168]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1][169]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1][170]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1][171]: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 13 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1][172]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1][173]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1][174]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1][175]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header) and line 92 (body comment).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1][176]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1][177]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header), line 31 (text), line 37 (text) and line 47 (text).
- [automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1][178]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 3 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1][179]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1][180]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header), line 19 (text) and line 31 (text).
- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][181]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][182]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1][183]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (header) and line 8 (header).
- [automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1][184]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 13 (header), line
  24 (header), line 28 (header), line 34 (header) and line 35 (header).
- [automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1][185]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][186]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 13 (header), line
  19 (header), line 21 (header), line 71 (header), line 87 (header), line 172 (body comment) and line 184 (body comment).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][187]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header) and
  line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][188]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header), line
  16 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/Test-Change.ps1][189]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1][190]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.QualityGates/Test-Formatting.ps1][191]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1][192]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/Test-Links.ps1][193]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 13 (header).
- [automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1][194]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header)
  and line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1][195]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1][196]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header)
  and line 10 (header).
- [automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1][197]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1][198]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1][199]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1][200]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 16 (header).
- [automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1][201]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1][202]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.QualityGates/Test-Spelling.ps1][203]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.QualityGates/Test-Terminology.ps1][204]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 23 (header).
- [automation/Catzc.Base.QualityGates/Test-TestTitles.ps1][205]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header) and
  line 10 (header).
- [automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1][206]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1][207]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (header) and line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1][208]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][209]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1][210]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1][211]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1][212]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1][213]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  5 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1][214]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  6 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1][215]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1][216]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header), line 16 (header) and line 185 (body comment).
- [automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1][217]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 12 (header).
- [automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1][218]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 11 (header), line 39 (header) and line 137 (body comment).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1][219]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (header) and line 20 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][220]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1][221]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1][222]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  20 (header) and line 24 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1][223]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1][224]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  4 (header).
- [automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1][225]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1][226]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 14 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1][227]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1][228]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  6 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1][229]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header), line 3 (header) and line 231 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1][230]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1][231]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  40 (text).
- [automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1][232]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1][233]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 1 (text) and line 23 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1][234]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1][235]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1][236]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1][237]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1][238]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1][239]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1][240]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1][241]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1][242]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1][243]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 10 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1][244]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1][245]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1][246]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1][247]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  62 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1][248]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1][249]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 23
  (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1][250]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 21
  (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1][251]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1][252]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][253]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1][254]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1][255]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1][256]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  2 (text), line 2 (body comment), line 100 (text) and line 104 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1][257]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1][258]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1][259]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1][260]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1][261]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1][262]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1][263]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header) and line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1][264]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 77
  (body comment), line 83 (body comment), line 127 (body comment) and line 132 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1][265]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 85
  (text), line 110 (text), line 183 (text), line 198 (text), line 198 (body comment) and line 238 (text).
- [automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1][266]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 8 (header),
  line 13 (header) and line 15 (header).
- [automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1][267]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1][268]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1][269]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 44 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1][270]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1][271]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (text) and line 13 (text).
- [automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1][272]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1][273]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1][274]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1][275]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1][276]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 16 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1][277]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1][278]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header) and line 18 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1][279]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header), line 57 (text), line 66 (text) and line 81 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1][280]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1][281]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1][282]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header), line 4 (header), line 52 (text), line 56 (text) and line 74 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1][283]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header), line 3 (header), line 29 (body comment), line 37 (text) and line 79 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1][284]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header), line 23 (text), line 29 (text) and line 43 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1][285]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header), line 5 (header), line 24 (body comment), line 29 (body comment) and line 42 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1][286]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1][287]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header), line 6 (header), line 7 (header), line 43 (text), line 47 (text) and line 52 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1][288]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1][289]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1][290]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 19
  (text), line 29 (text), line 39 (text), line 103 (body comment) and line 105 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1][291]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 1 (header) and line 4 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1][292]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header), line 3 (header), line 29 (text) and line 60 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1][293]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  37 (text), line 46 (text) and line 58 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1][294]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header), line 4 (header) and line 162 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1][295]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1][296]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1][297]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 20
  (text), line 29 (text), line 43 (text), line 115 (body comment) and line 117 (body comment).
- [automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1][298]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1][299]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header) and line 6 (header).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1][300]: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1][301]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1][302]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  35 (body comment) (a passing mention only).
- [automation/Catzc.Base.Reports/Write-QualityGateReport.ps1][303]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1][304]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header), line 4 (header), line 14 (text), line 24 (text), line 32 (text) and line 42 (text).
- [automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1][305]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (text), line 10 (text) and line 17 (text).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1][306]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1][307]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][308]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][309]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1][310]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 138
  (body comment) and line 228 (body comment) (a passing mention only).
- [automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1][311]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 3 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1][312]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1][313]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][314]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1][315]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][316]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header) and line 3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1][317]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][318]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header) and line 4 (header).
- [automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1][319]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).
- [automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1][320]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 13 (header).
- [automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1][321]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1][322]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1][323]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 81 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1][324]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 7
  (body comment) and line 52 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1][325]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1][326]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1][327]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  4 (text).
- [automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1][328]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 35 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1][329]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  82 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1][330]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1][331]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1][332]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][333]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1][334]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1][335]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 7 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1][336]: selected by [ADR-AUTO-TEST][1]: the file cites
  it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1][337]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 3 (header) and line 4 (text).
- [automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1][338]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 45 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1][339]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1][340]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5
  (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1][341]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header) and line 3 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1][342]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header) and line 4 (header).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1][343]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 5 (body comment) (a passing mention only).
- [automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1][344]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1][345]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (body
  comment) (a passing mention only).
- [automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1][346]: selected by [ADR-AUTO-TEST][1]: the file cites it at
  line 2 (header).
- [automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1][347]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3
  (header).

### automation × yaml (16 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][5]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [automation/Catzc.Azure.DevOps/configs/identity-tokens.yml][348]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml][349]: selected by [ADR-AUTO-TEST][1]: the file cites it
  at line 7 (header).
- [automation/Catzc.Azure/configs/identity-tokens.yml][350]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][351]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 145 (text); selected by
  [ADR-DSGN-LIFE][2]: the file cites it at line 99 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 98 (text); selected
  by [ADR-FLOW-CD][4]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][352]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 57 (text), line 57 (body
  comment) and line 57 (body comment); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 32 (text), line 32 (body comment) and
  line 37 (text).
- [automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml][353]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header) and line 6 (text).
- [automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml][354]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1
  (header), line 8 (text) and line 16 (text).
- [automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml][355]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  5 (header).
- [automation/Catzc.Base.ModuleSystem/configs/artifacts.yml][356]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][357]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 52 (text);
  selected by [ADR-FLOW-CD][4]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][358]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 27
  (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][359]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 9 (text), line
  25 (text), line 34 (text), line 44 (text), line 71 (text), line 86 (text), line 109 (text), line 121 (text), line 131 (text), line 141
  (text), line 156 (text) and line 170 (text); selected by [ADR-FLOW-CD][4]: the file cites it at line 62 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][360]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 26 (header).
- [automation/Catzc.Base.QualityGates/configs/test-policy.yml][361]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Reports/configs/reports.yml][362]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml][363]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 120 (body
  comment) (a passing mention only).

### docs × markdown (90 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][5]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [docs/adr/automation/BCL/index.md][364]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/BCL/native-csharp-types.md][365]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][366]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][367]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/caching.md][368]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][369]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][370]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][371]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/cross-platform.md][372]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][373]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][374]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/dry-run.md][375]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][376]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/environment-variables.md][377]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][378]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][379]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][380]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/go/test-artifacts.md][381]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][382]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][383]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][384]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/managed-guids.md][385]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/never-depend-on-pwd.md][386]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][387]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/path-representation.md][388]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][389]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/protected-globs.md][390]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/python/index.md][391]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][392]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][393]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][394]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][395]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][396]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/test-automation.md][1]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/tool-removal-lifecycle.md][397]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][398]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][399]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][400]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][401]: selected by [ADR-AUTO-TEST][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/commit-lifecycle.md][2]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][402]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][403]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][404]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code;
  selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][405]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][406]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR
  domain of that code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][407]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][408]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code;
  selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][3]: selected by [ADR-DSGN-LIFE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][4]: selected by [ADR-FLOW-CD][4]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][409]: selected by [ADR-FLOW-CD][4]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][410]: selected by [ADR-FLOW-CD][4]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-detection.md][411]: selected by [ADR-FLOW-CD][4]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][412]: selected by [ADR-FLOW-CD][4]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-types.md][413]: selected by [ADR-FLOW-CD][4]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][414]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 329 (text), line 367 (text), line 378 (text), line
  411 (text), line 446 (text), line 464 (text), line 476 (text), line 490 (text), line 512 (text), line 526 (text), line 537 (text) and line
  557 (text); selected by [ADR-DSGN-LIFE][2]: the file cites it at line 149 (text); selected by [ADR-FLOW-CD][4]: the file cites it at line
  292 (text) and line 305 (text).
- [docs/adr/index.md][415]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 133 (text); selected by [ADR-DSGN-LIFE][2]: the file
  cites it at line 92 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 91 (text); selected by [ADR-FLOW-CD][4]: the file
  cites it at line 107 (text).
- [docs/explanation/automation/two-gates-check-the-layer-pins.md][416]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 15 (text),
  line 53 (text) and line 67 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][417]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 16 (text),
  line 55 (text) and line 56 (text).
- [docs/explanation/configuration/one-gate-guards-the-read-path.md][418]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 17
  (text), line 29 (text) and line 64 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][419]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][420]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][421]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 15 (text), line 50
  (text), line 51 (text) and line 57 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][422]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 14 (text), line 46 (text) and
  line 47 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][423]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][4]: the file cites it at line 55 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][424]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][425]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][4]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][426]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][427]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 46 (text);
  selected by [ADR-FLOW-CD][4]: the file cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][428]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][429]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 13 (text), line
  41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line
  46 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][430]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 56 (text);
  selected by [ADR-DSGN-LIFE][2]: the file cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line
  46 (text) and line 54 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 15 (text), line 20 (text), line 47 (text), line
  49 (text), line 50 (text) and line 58 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][431]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 12
  (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][432]: selected by [ADR-DSGN-LIFE][2]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text); selected by [ADR-FLOW-CD][4]: the file cites it at line 17 (text), line
  34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][433]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 62 (text);
  selected by [ADR-DSGN-LIFE][2]: the file cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line
  56 (text), line 57 (text), line 58 (text) and line 59 (text); selected by [ADR-DSGN-VISUAL][3]: the file cites it at line 63 (text);
  selected by [ADR-FLOW-CD][4]: the file cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][434]: selected by [ADR-FLOW-CD][4]: the file cites it at line 16 (text), line 48
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][435]: selected by [ADR-FLOW-CD][4]: the file cites it at line 15
  (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][436]: selected by [ADR-FLOW-CD][4]: the file cites it at line 17 (text),
  line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][437]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 17 (text) and
  line 60 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][438]: selected by [ADR-FLOW-CD][4]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][439]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 16 (text)
  and line 52 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][440]: selected by [ADR-FLOW-CD][4]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).
- [docs/how-to/automation/manual-test-plan.md][441]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 56 (text) and line 62 (text).
- [docs/how-to/automation/manual-test-plan/azure.md][442]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 17 (text) and line 69
  (text).
- [docs/how-to/automation/manual-test-plan/test-harness.md][443]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 17 (text).
- [docs/how-to/getting-started/automation/run-tests-and-checks.md][444]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 33
  (text).
- [docs/references/automation/catzc-base-docs.md][445]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 34 (text).
- [docs/references/automation/catzc-base-globs.md][446]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 44 (text).
- [docs/references/automation/catzc-base-languages.md][447]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 39 (text).
- [docs/references/automation/catzc-base-modulesystem.md][448]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 36 (text).
- [docs/references/automation/catzc-base-rootconfig.md][449]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 50 (text).

### pipelines × pipeline-yaml (1 lit file, touched)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][5]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [pipelines/ci-infrastructure.yaml][450]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 68 (body comment) (a passing mention
  only).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][451]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][6]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [importer.ps1][452]: selected by [ADR-AUTO-TEST][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/.internal/tests/Import-AllModules.Tests.ps1` line 206 (body comment),
  `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 1 (text), `automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1` line 80
  (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 5 (header) and
  `automation/.internal/tests/Test-FolderConventions.Tests.ps1` line 2 (header).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][451]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][453]). Lit ([ADR-DSGN-TRACK#12][7]) by:

- [.gitattributes][454]: selected by [ADR-AUTO-TEST][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 2 (header) and
  `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header).
- [.gitignore][455]: selected by [ADR-AUTO-TEST][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1` line 2 (header) and
  `automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1` line 2 (header).

## Keywords

- [world map][456]
- [track][457]
- [file language][458]
- [cell][459]
- [lit cell][460]
- [root file][461]
- [unlisted file][462]
- [.claude][463]: a track
- [automation][463]: a track
- [docs][463]: a track
- [pipelines][463]: a track
- [csharp][464]: a file language
- [markdown][464]: a file language
- [pipeline-yaml][464]: a file language
- [powershell][464]: a file language
- [yaml][464]: a file language

Terms the cited ADRs define:

- [all tests][465], defined by [ADR-AUTO-TEST#36][466]
- [build verification test][467], defined by [ADR-AUTO-TEST#24][468]
- [category][469], defined by [ADR-AUTO-TEST#1][470]
- [gate][471], defined by [ADR-FLOW-CD#13][472]
- [occupant][473], defined by [ADR-DSGN-LIFE#5][474]
- [phase][475], defined by [ADR-AUTO-TEST#26][476]
- [quality gate][477], defined by [ADR-AUTO-TEST#35][478]
- [release candidate][479], defined by [ADR-FLOW-CD#14][480]
- [test][481], defined by [ADR-AUTO-TEST#42][482]
- [test file][483], defined by [ADR-AUTO-TEST#43][484]
- [test run][485], defined by [ADR-AUTO-TEST#34][486]
- [test suite][487], defined by [ADR-AUTO-TEST#37][488]
- [testing in production][489], defined by [ADR-AUTO-TEST#41][490]
- [tier][491], defined by [ADR-AUTO-TEST#13][492]
- [vertical test][493], defined by [ADR-AUTO-TEST#38][494]

[1]: ../../adr/automation/test-automation.md
[2]: ../../adr/design/commit-lifecycle.md
[3]: ../../adr/design/visual-design.md
[4]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[8]: ../../../.claude/CLAUDE.md
[9]: ../../../.claude/agents/catzc-worker.md
[10]: ../../../.claude/agents/drawio-diagram-waves.md
[11]: ../../../.claude/agents/test-optimization.md
[12]: ../../../.claude/agents/write-drawio-files.md
[13]: ../../../.claude/drawio/STYLE.md
[14]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[15]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[16]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[17]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[18]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[19]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[20]: ../../../automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
[21]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[22]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[23]: ../../../automation/Catzc.Base.Timeouts/types/TestTiers.cs
[24]: ../../../automation/.internal/tests/Import-AllModules.Tests.ps1
[25]: ../../../automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
[26]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[27]: ../../../automation/.internal/tests/Test-FolderConventions.Tests.ps1
[28]: ../../../automation/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1
[29]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
[30]: ../../../automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
[31]: ../../../automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
[32]: ../../../automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
[33]: ../../../automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
[34]: ../../../automation/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
[35]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
[36]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
[37]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
[38]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
[39]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
[40]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
[41]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
[42]: ../../../automation/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
[43]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
[44]: ../../../automation/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
[45]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
[46]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
[47]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
[48]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
[49]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
[50]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
[51]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
[52]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
[53]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
[54]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
[55]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
[56]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
[57]: ../../../automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
[58]: ../../../automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
[59]: ../../../automation/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
[60]: ../../../automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
[61]: ../../../automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
[62]: ../../../automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
[63]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
[64]: ../../../automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
[65]: ../../../automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
[66]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
[67]: ../../../automation/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
[68]: ../../../automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
[69]: ../../../automation/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
[70]: ../../../automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
[71]: ../../../automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
[72]: ../../../automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1
[73]: ../../../automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
[74]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[75]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
[76]: ../../../automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
[77]: ../../../automation/Catzc.Base.Contracts/Test-Contracts.ps1
[78]: ../../../automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
[79]: ../../../automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
[80]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
[81]: ../../../automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
[82]: ../../../automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
[83]: ../../../automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
[84]: ../../../automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
[85]: ../../../automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
[86]: ../../../automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
[87]: ../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[88]: ../../../automation/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
[89]: ../../../automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
[90]: ../../../automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
[91]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
[92]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1
[93]: ../../../automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1
[94]: ../../../automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
[95]: ../../../automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
[96]: ../../../automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
[97]: ../../../automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
[98]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
[99]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
[100]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
[101]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
[102]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
[103]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
[104]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
[105]: ../../../automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
[106]: ../../../automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
[107]: ../../../automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
[108]: ../../../automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
[109]: ../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[110]: ../../../automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
[111]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[112]: ../../../automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
[113]: ../../../automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
[114]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
[115]: ../../../automation/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
[116]: ../../../automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
[117]: ../../../automation/Catzc.Base.Execution/Invoke-Executable.ps1
[118]: ../../../automation/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
[119]: ../../../automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
[120]: ../../../automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
[121]: ../../../automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
[122]: ../../../automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
[123]: ../../../automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
[124]: ../../../automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
[125]: ../../../automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
[126]: ../../../automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
[127]: ../../../automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
[128]: ../../../automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
[129]: ../../../automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
[130]: ../../../automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
[131]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[132]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[133]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[134]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[135]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[136]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
[137]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[138]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[139]: ../../../automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
[140]: ../../../automation/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
[141]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
[142]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[143]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
[144]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[145]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
[146]: ../../../automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
[147]: ../../../automation/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
[148]: ../../../automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
[149]: ../../../automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
[150]: ../../../automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
[151]: ../../../automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
[152]: ../../../automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
[153]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[154]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[155]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[156]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[157]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[158]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[159]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[160]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[161]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[162]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[163]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[164]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[165]: ../../../automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
[166]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[167]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[168]: ../../../automation/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
[169]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
[170]: ../../../automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
[171]: ../../../automation/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
[172]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
[173]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
[174]: ../../../automation/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
[175]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
[176]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
[177]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
[178]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
[179]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
[180]: ../../../automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
[181]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[182]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[183]: ../../../automation/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
[184]: ../../../automation/Catzc.Base.QualityGates/Invoke-TestFile.ps1
[185]: ../../../automation/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.ps1
[186]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[187]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[188]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[189]: ../../../automation/Catzc.Base.QualityGates/Test-Change.ps1
[190]: ../../../automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
[191]: ../../../automation/Catzc.Base.QualityGates/Test-Formatting.ps1
[192]: ../../../automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
[193]: ../../../automation/Catzc.Base.QualityGates/Test-Links.ps1
[194]: ../../../automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
[195]: ../../../automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
[196]: ../../../automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
[197]: ../../../automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
[198]: ../../../automation/Catzc.Base.QualityGates/Test-Markdownlint.ps1
[199]: ../../../automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
[200]: ../../../automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
[201]: ../../../automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
[202]: ../../../automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1
[203]: ../../../automation/Catzc.Base.QualityGates/Test-Spelling.ps1
[204]: ../../../automation/Catzc.Base.QualityGates/Test-Terminology.ps1
[205]: ../../../automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
[206]: ../../../automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
[207]: ../../../automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
[208]: ../../../automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
[209]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[210]: ../../../automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
[211]: ../../../automation/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
[212]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
[213]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
[214]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
[215]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
[216]: ../../../automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
[217]: ../../../automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
[218]: ../../../automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
[219]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
[220]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[221]: ../../../automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
[222]: ../../../automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
[223]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
[224]: ../../../automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
[225]: ../../../automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
[226]: ../../../automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
[227]: ../../../automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
[228]: ../../../automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
[229]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
[230]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
[231]: ../../../automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
[232]: ../../../automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
[233]: ../../../automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
[234]: ../../../automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
[235]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
[236]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
[237]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
[238]: ../../../automation/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
[239]: ../../../automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
[240]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
[241]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
[242]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
[243]: ../../../automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
[244]: ../../../automation/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
[245]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
[246]: ../../../automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
[247]: ../../../automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
[248]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
[249]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
[250]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
[251]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
[252]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
[253]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[254]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
[255]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
[256]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
[257]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
[258]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
[259]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
[260]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
[261]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
[262]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
[263]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
[264]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
[265]: ../../../automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
[266]: ../../../automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
[267]: ../../../automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
[268]: ../../../automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
[269]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
[270]: ../../../automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
[271]: ../../../automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
[272]: ../../../automation/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
[273]: ../../../automation/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
[274]: ../../../automation/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
[275]: ../../../automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
[276]: ../../../automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
[277]: ../../../automation/Catzc.Base.QualityGates/tests/Test-AnalyzerAdrMap.Tests.ps1
[278]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
[279]: ../../../automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
[280]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
[281]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
[282]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
[283]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
[284]: ../../../automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
[285]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
[286]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
[287]: ../../../automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
[288]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
[289]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
[290]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
[291]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
[292]: ../../../automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
[293]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
[294]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
[295]: ../../../automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
[296]: ../../../automation/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
[297]: ../../../automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
[298]: ../../../automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
[299]: ../../../automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
[300]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
[301]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
[302]: ../../../automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
[303]: ../../../automation/Catzc.Base.Reports/Write-QualityGateReport.ps1
[304]: ../../../automation/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
[305]: ../../../automation/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
[306]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
[307]: ../../../automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
[308]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[309]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[310]: ../../../automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
[311]: ../../../automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
[312]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
[313]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
[314]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[315]: ../../../automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
[316]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[317]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
[318]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[319]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
[320]: ../../../automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
[321]: ../../../automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
[322]: ../../../automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
[323]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
[324]: ../../../automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
[325]: ../../../automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
[326]: ../../../automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
[327]: ../../../automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
[328]: ../../../automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
[329]: ../../../automation/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
[330]: ../../../automation/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
[331]: ../../../automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
[332]: ../../../automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
[333]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[334]: ../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
[335]: ../../../automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
[336]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
[337]: ../../../automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
[338]: ../../../automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
[339]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
[340]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
[341]: ../../../automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
[342]: ../../../automation/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
[343]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
[344]: ../../../automation/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
[345]: ../../../automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1
[346]: ../../../automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
[347]: ../../../automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
[348]: ../../../automation/Catzc.Azure.DevOps/configs/identity-tokens.yml
[349]: ../../../automation/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
[350]: ../../../automation/Catzc.Azure/configs/identity-tokens.yml
[351]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[352]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[353]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
[354]: ../../../automation/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
[355]: ../../../automation/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml
[356]: ../../../automation/Catzc.Base.ModuleSystem/configs/artifacts.yml
[357]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[358]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[359]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[360]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[361]: ../../../automation/Catzc.Base.QualityGates/configs/test-policy.yml
[362]: ../../../automation/Catzc.Base.Reports/configs/reports.yml
[363]: ../../../automation/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
[364]: ../../adr/automation/BCL/index.md
[365]: ../../adr/automation/BCL/native-csharp-types.md
[366]: ../../adr/automation/avoid-deep-nesting.md
[367]: ../../adr/automation/bash/bash-test-artifacts.md
[368]: ../../adr/automation/caching.md
[369]: ../../adr/automation/console-output-matters.md
[370]: ../../adr/automation/controlling-module-dependencies.md
[371]: ../../adr/automation/controlling-systemwide-deps.md
[372]: ../../adr/automation/cross-platform.md
[373]: ../../adr/automation/devbox-pipeline-parity.md
[374]: ../../adr/automation/dora-explains.md
[375]: ../../adr/automation/dry-run.md
[376]: ../../adr/automation/effective-in-enterprises.md
[377]: ../../adr/automation/environment-variables.md
[378]: ../../adr/automation/execution-engines.md
[379]: ../../adr/automation/fail-fast-with-asserts.md
[380]: ../../adr/automation/go/index.md
[381]: ../../adr/automation/go/test-artifacts.md
[382]: ../../adr/automation/idempotent-state-functions.md
[383]: ../../adr/automation/internal-asset-dependencies.md
[384]: ../../adr/automation/log-before-invoke.md
[385]: ../../adr/automation/managed-guids.md
[386]: ../../adr/automation/never-depend-on-pwd.md
[387]: ../../adr/automation/open-closed-architecture.md
[388]: ../../adr/automation/path-representation.md
[389]: ../../adr/automation/platform-bundle.md
[390]: ../../adr/automation/protected-globs.md
[391]: ../../adr/automation/python/index.md
[392]: ../../adr/automation/python/python-test-artifacts.md
[393]: ../../adr/automation/retry-as-last-resort.md
[394]: ../../adr/automation/sensible-defaults.md
[395]: ../../adr/automation/single-responsibility-functions.md
[396]: ../../adr/automation/spell-out-names.md
[397]: ../../adr/automation/tool-removal-lifecycle.md
[398]: ../../adr/automation/tracked-files-from-the-index.md
[399]: ../../adr/automation/use-proper-package-managers.md
[400]: ../../adr/automation/uv-python-handler.md
[401]: ../../adr/automation/zero-ceremony-poka-yoke.md
[402]: ../../adr/design/dora-explains.md
[403]: ../../adr/design/module-aspects.md
[404]: ../../adr/design/run-modes.md
[405]: ../../adr/design/self-service.md
[406]: ../../adr/design/server-remote-integration.md
[407]: ../../adr/design/thin-platforms.md
[408]: ../../adr/design/tracks.md
[409]: ../../adr/flow/dora-explains.md
[410]: ../../adr/flow/durable-sha-globs.md
[411]: ../../adr/flow/pipeline-detection.md
[412]: ../../adr/flow/pipeline-runner-pattern.md
[413]: ../../adr/flow/pipeline-types.md
[414]: ../../adr/glossary.md
[415]: ../../adr/index.md
[416]: ../../explanation/automation/two-gates-check-the-layer-pins.md
[417]: ../../explanation/automation/what-gates-each-bundle-stage.md
[418]: ../../explanation/configuration/one-gate-guards-the-read-path.md
[419]: ../../explanation/design/clients-bridge-to-one-server.md
[420]: ../../explanation/design/code-wires-only-the-first-rungs.md
[421]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[422]: ../../explanation/design/deploying-is-not-integrating.md
[423]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[424]: ../../explanation/design/every-deploy-stage-is-main-only.md
[425]: ../../explanation/design/four-domains-promote-one-artifact.md
[426]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[427]: ../../explanation/design/integrators-depend-on-an-occupant.md
[428]: ../../explanation/design/merging-to-main-is-what-deploys.md
[429]: ../../explanation/design/one-way-climb-three-endings.md
[430]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[431]: ../../explanation/design/sync-from-the-last-certified-commit.md
[432]: ../../explanation/design/sync-point-rules-are-adr-only.md
[433]: ../../explanation/design/which-rung-gates-exist-in-code.md
[434]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[435]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[436]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[437]: ../../explanation/flow/gates-check-source-and-trigger.md
[438]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[439]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[440]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[441]: ../../how-to/automation/manual-test-plan.md
[442]: ../../how-to/automation/manual-test-plan/azure.md
[443]: ../../how-to/automation/manual-test-plan/test-harness.md
[444]: ../../how-to/getting-started/automation/run-tests-and-checks.md
[445]: ../../references/automation/catzc-base-docs.md
[446]: ../../references/automation/catzc-base-globs.md
[447]: ../../references/automation/catzc-base-languages.md
[448]: ../../references/automation/catzc-base-modulesystem.md
[449]: ../../references/automation/catzc-base-rootconfig.md
[450]: ../../../pipelines/ci-infrastructure.yaml
[451]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[452]: ../../../importer.ps1
[453]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[454]: ../../../.gitattributes
[455]: ../../../.gitignore
[456]: ../../adr/glossary.md#world-map
[457]: ../../adr/glossary.md#track
[458]: ../../adr/glossary.md#file-language
[459]: ../../adr/glossary.md#cell
[460]: ../../adr/glossary.md#lit-cell
[461]: ../../adr/glossary.md#root-file
[462]: ../../adr/glossary.md#unlisted-file
[463]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[464]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[465]: ../../adr/glossary.md#all-tests
[466]: ../../adr/automation/test-automation.md#rule-adr-auto-test36
[467]: ../../adr/glossary.md#build-verification-test
[468]: ../../adr/automation/test-automation.md#rule-adr-auto-test24
[469]: ../../adr/glossary.md#category
[470]: ../../adr/automation/test-automation.md#rule-adr-auto-test1
[471]: ../../adr/glossary.md#gate
[472]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[473]: ../../adr/glossary.md#occupant
[474]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[475]: ../../adr/glossary.md#phase
[476]: ../../adr/automation/test-automation.md#rule-adr-auto-test26
[477]: ../../adr/glossary.md#quality-gate
[478]: ../../adr/automation/test-automation.md#rule-adr-auto-test35
[479]: ../../adr/glossary.md#release-candidate
[480]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[481]: ../../adr/glossary.md#test
[482]: ../../adr/automation/test-automation.md#rule-adr-auto-test42
[483]: ../../adr/glossary.md#test-file
[484]: ../../adr/automation/test-automation.md#rule-adr-auto-test43
[485]: ../../adr/glossary.md#test-run
[486]: ../../adr/automation/test-automation.md#rule-adr-auto-test34
[487]: ../../adr/glossary.md#test-suite
[488]: ../../adr/automation/test-automation.md#rule-adr-auto-test37
[489]: ../../adr/glossary.md#testing-in-production
[490]: ../../adr/automation/test-automation.md#rule-adr-auto-test41
[491]: ../../adr/glossary.md#tier
[492]: ../../adr/automation/test-automation.md#rule-adr-auto-test13
[493]: ../../adr/glossary.md#vertical-test
[494]: ../../adr/automation/test-automation.md#rule-adr-auto-test38

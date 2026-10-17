# docs/explanation/.assets/grid/adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.grid.md

`Grid minimap: adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance`

![Grid minimap of adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance](adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.grid.png)

The grid minimap of the slide `adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance` (governance lens). The slide
supports [ADR-AUTO-FAILFAST][1], [ADR-FLOW-CD-DETECT][2] and [ADR-FLOW-CD-GLOBS][3]; the highlight of those ADR codes selects what is lit,
and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 10 lit of 71 files
- .unordered × markdown: 9 lit of 20 files
- automation × csharp: 7 lit of 274 files
- automation × powershell: 56 lit of 1579 files
- automation × yaml: 5 lit of 109 files
- docs × markdown: 48 lit of 2165 files
- github-workflows × yaml: 1 lit of 2 files, touched
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (10 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/CLAUDE.md][7]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 113 (text).
- [.claude/plans/decisions-2026-10-16.md][8]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text), line 71 (text), line
  71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-assert-wait.md][9]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 32 (text), line 44 (text), line 57
  (text), line 65 (text) and line 115 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][10]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 27 (text), line 56
  (text), line 302 (text) and line 303 (text).
- [.claude/plans/plan-config-defaults.md][11]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 62 (text) and line 266 (text).
- [.claude/plans/plan-lazy-types-load.md][12]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 204 (text).
- [.claude/plans/plan-minimal-robots-agents.md][13]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text) and line 91
  (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][14]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text) and line
  131 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][15]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 19 (text)
  and line 40 (text).
- [.claude/plans/questionnaire-2026-10-16.md][16]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 141 (text).

### .unordered × markdown (9 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][17]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 43 (text), line 96
  (text), line 124 (text) and line 167 (text).
- [.unordered/15-10-2026/plan-adr-pwsh-followups.md][18]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 111 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][19]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 13 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][20]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 101 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][21]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 96 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 97 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][22]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 14 (text) and line 16
  (text).
- [.unordered/15-10-2026/plan-duration-categories.md][23]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][24]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 129 (text); selected
  by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 38 (text), line 39 (text), line 58 (text), line 77 (text), line 103 (text) and line
  103 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][25]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 70 (text).

### automation × csharp (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][26]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][27]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (text).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][28]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][29]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (text), line 47
  (text), line 51 (text), line 55 (text), line 67 (text), line 71 (text) and line 80 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][30]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (text) and line 79
  (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][31]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (text), line 98
  (text), line 161 (text), line 165 (text) and line 179 (text).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][32]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (text).

### automation × powershell (56 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][33]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21
  (header) and line 36 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][34]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 20 (header) and line 30 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][35]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 22 (header) and line 28 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][36]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][37]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1][38]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.Docs/Test-Glossary.ps1][39]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and line 41
  (header).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][40]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][41]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][42]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header)
  and line 27 (header).
- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][43]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][44]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20
  (header) and line 87 (text).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][45]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and
  line 26 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][46]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and line 25
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1][47]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 20 (header)
  and line 26 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][48]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header), line 25
  (header) and line 28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][49]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and line
  28 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][50]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header) and
  line 25 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][51]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header) and
  line 27 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][52]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][53]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header) and line
  26 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][54]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][55]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][56]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21 (header) and
  line 43 (header); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22 (header) and line 33 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][57]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 23 (header),
  line 36 (header) and line 95 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][58]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22
  (header) and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][59]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header)
  and line 28 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][60]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21 (header)
  and line 26 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][61]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][62]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21
  (header) and line 31 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][63]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1][65]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line
  20 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][67]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][69]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][70]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][71]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][72]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header), line 25 (text) and line 27 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][73]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  21 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][74]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  20 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][75]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  21 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][76]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20
  (header) and line 81 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][77]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (header)
  and line 32 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][78]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22
  (header), line 78 (text), line 91 (text), line 102 (text) and line 114 (text).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][79]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 23 (header)
  and line 102 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][80]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22
  (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][81]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 23 (header).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][82]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 22
  (header) and line 31 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][83]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line
  21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][84]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 23 (header) and line 43 (header).
- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][85]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][86]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 20 (header) and
  line 26 (header).
- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][87]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 21
  (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][88]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 22
  (header) and line 29 (header).

### automation × yaml (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][89]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 148 (text); selected by
  [ADR-FLOW-CD-DETECT][2]: the file cites it at line 117 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 119 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][90]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 74 (body comment) and
  line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][91]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 23 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][92]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 30
  (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][93]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 599
  (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1212 (text).

### docs × markdown (48 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/automation/dora-explains.md][94]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 310 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][1]: selected by [ADR-AUTO-FAILFAST][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][95]: selected by [ADR-FLOW-CD-DETECT][2]: the file cites it at line 81 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 124 (text).
- [docs/adr/flow/durable-sha-globs.md][3]: selected by [ADR-FLOW-CD-GLOBS][3]: the ADR's own file.
- [docs/adr/flow/pipeline-detection.md][2]: selected by [ADR-FLOW-CD-DETECT][2]: the ADR's own file.
- [docs/adr/index.md][96]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 159 (text); selected by [ADR-FLOW-CD-DETECT][2]:
  the file cites it at line 129 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 131 (text).
- [docs/adr/repository/ai-agent-contract.md][97]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 18 (text) and line 55
  (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][98]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16
  (text) and line 36 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][99]: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][100]: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 35 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][101]: selected by [ADR-FLOW-CD-DETECT][2]: the file
  cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][102]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it
  at line 32 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][103]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-globs.md][104]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 51 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][105]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  20 (text), line 35 (text), line 38 (text) and line 86 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][106]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 17 (text), line 31 (text) and line 41 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][107]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18
  (text), line 33 (text), line 38 (text), line 46 (text), line 48 (text), line 62 (text), line 92 (text) and line 106 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][108]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][109]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][110]: selected by [ADR-FLOW-CD-DETECT][2]: the
  file cites it at line 27 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][111]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 17 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][112]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][113]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][114]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][115]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][116]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][117]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][118]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 18 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][119]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][120]: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][121]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text), line 30 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][122]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 17 (text), line 31 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][123]: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 18 (text), line 34 (text), line 36 (text) and line 45 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][124]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 18
  (text) and line 39 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][125]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  17 (text), line 30 (text) and line 36 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][126]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  17 (text), line 36 (text), line 37 (text) and line 38 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][127]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 17
  (text), line 32 (text), line 34 (text), line 35 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 57 (text),
  line 66 (text), line 84 (text), line 101 (text), line 111 (text), line 135 (text) and line 143 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][128]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line
  17 (text), line 32 (text), line 36 (text), line 39 (text) and line 58 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][129]: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 17 (text) and line 70 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][130]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-typessystem.md][131]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at line 16 (text) and
  line 89 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][132]: selected by [ADR-AUTO-FAILFAST][1]: the file cites it at
  line 17 (text) and line 31 (text).
- [docs/references/pipelines/cd-apex.yaml.md][133]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 47 (text).
- [docs/references/pipelines/cd-flux.yaml.md][134]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 46 (text).
- [docs/references/pipelines/cd-nova.yaml.md][135]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 46 (text).
- [docs/references/pipelines/cd-shared.yaml.md][136]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 41 (text).
- [docs/references/pipelines/ci-automation.yaml.md][137]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 31 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][138]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 33 (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.github/workflows/ci-automation.yml][139]: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 20 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/ci-automation.yaml][140]: selected by [ADR-AUTO-FAILFAST][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line
  21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 148
  (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 95
  (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 26 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 20 (header), `automation/Catzc.Base.Engines/types/ExecutionEngine.cs` line
  22 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 87 (text), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 43 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 599 (text),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 43 (header),
  `automation/Catzc.Base.Timeouts/Assert-Wait.ps1` line 20 (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 20
  (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 26 (header),
  `automation/Catzc.Base.Timeouts/types/BashSafeguard.cs` line 21 (text), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1`
  line 21 (header), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 27 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 22 (header) and
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 29 (header); selected by [ADR-FLOW-CD-DETECT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1` line 21
  (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 117 (text), `automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1` line 26 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1` line 20 (header) and
  `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 30 (text); selected by [ADR-FLOW-CD-GLOBS][3]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1` line 30 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 22 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1` line 28 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 21 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1` line 26 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 20 (header),
  `automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1` line 28 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 119 (text), `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 21 (header),
  `automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1` line 27 (header), `automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1` line 26 (header), `automation/Catzc.Base.Globs/Get-GlobSet.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-GlobSet.ps1` line 25 (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 20
  (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 25 (header), `automation/Catzc.Base.Globs/Get-GlobSetFile.ps1` line 28
  (header), `automation/Catzc.Base.Globs/Get-GlobSetHash.ps1` line 20 (header), `automation/Catzc.Base.Globs/Get-GlobSetHash.ps1` line 28
  (header), `automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1` line 20 (header), `automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1` line
  25 (header), `automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1` line 27 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 26
  (header), `automation/Catzc.Base.Globs/Get-TrackedFile.ps1` line 21 (header), `automation/Catzc.Base.Globs/Get-TrackedFile.ps1` line 26
  (header), `automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1` line 22 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`
  line 22 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 33 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 23 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1`
  line 36 (header), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 95 (text),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1` line 28 (header), `automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1`
  line 21 (header), `automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1` line 28 (header),
  `automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1` line 21 (header), `automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1`
  line 26 (header), `automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1` line 27 (header),
  `automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1` line 31 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 81 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 20 (header), `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1`
  line 32 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 78 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 91 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 102 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 114 (text), `automation/Catzc.Base.Globs/types/Aspect.cs` line 22
  (text), `automation/Catzc.Base.Globs/types/DurableHash.cs` line 20 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 21
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 47 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 51
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 55 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 67
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 71 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 80
  (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 21 (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 79 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 21 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 98 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 161 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 165 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 179 (text), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 23
  (header), `automation/Catzc.Base.QualityGates/Test-Automation.ps1` line 102 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 1212 (text),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 22 (header),
  `automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 22 (header) and
  `automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1` line 31 (header).

## Keywords

- [world map][141]
- [track][142]
- [file language][143]
- [cell][144]
- [lit cell][145]
- [.claude][146]: a track
- [.unordered][146]: a track
- [automation][146]: a track
- [docs][146]: a track
- [github-workflows][146]: a track
- [pipelines][146]: a track
- [csharp][147]: a file language
- [markdown][147]: a file language
- [pipeline-yaml][147]: a file language
- [powershell][147]: a file language
- [yaml][147]: a file language

[1]: ../../../adr/automation/fail-fast-with-asserts.md
[2]: ../../../adr/flow/pipeline-detection.md
[3]: ../../../adr/flow/durable-sha-globs.md
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../../.claude/CLAUDE.md
[8]: ../../../../.claude/plans/decisions-2026-10-16.md
[9]: ../../../../.claude/plans/plan-assert-wait.md
[10]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[11]: ../../../../.claude/plans/plan-config-defaults.md
[12]: ../../../../.claude/plans/plan-lazy-types-load.md
[13]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[14]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[15]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[16]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[17]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[18]: ../../../../.unordered/15-10-2026/plan-adr-pwsh-followups.md
[19]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[20]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[21]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[22]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[23]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[24]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[25]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[26]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[27]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[28]: ../../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[29]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[30]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[31]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[32]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[33]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[34]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[35]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[36]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[37]: ../../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[38]: ../../../../automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
[39]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[40]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[41]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[42]: ../../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[43]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[44]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[45]: ../../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[46]: ../../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[47]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
[48]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[49]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[50]: ../../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[51]: ../../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[52]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[53]: ../../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[54]: ../../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[55]: ../../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[56]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[57]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[58]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[59]: ../../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[60]: ../../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[61]: ../../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[62]: ../../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[63]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[64]: ../../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[65]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
[66]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[67]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[68]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[69]: ../../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[70]: ../../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[71]: ../../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[72]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[73]: ../../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[74]: ../../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[75]: ../../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[76]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[77]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[78]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[79]: ../../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[80]: ../../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[81]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[82]: ../../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[83]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[84]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[85]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[86]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[87]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[88]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[89]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[90]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[91]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[92]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[93]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[94]: ../../../adr/automation/dora-explains.md
[95]: ../../../adr/flow/dora-explains.md
[96]: ../../../adr/index.md
[97]: ../../../adr/repository/ai-agent-contract.md
[98]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[99]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[100]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[101]: ../../../references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[102]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[103]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[104]: ../../../references/automation/catzc-base-globs.md
[105]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[106]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[107]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[108]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[109]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[110]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[111]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[112]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[113]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[114]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[115]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[116]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[117]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[118]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[119]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[120]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[121]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[122]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[123]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[124]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[125]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[126]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[127]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[128]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[129]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[130]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[131]: ../../../references/automation/catzc-base-typessystem.md
[132]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[133]: ../../../references/pipelines/cd-apex.yaml.md
[134]: ../../../references/pipelines/cd-flux.yaml.md
[135]: ../../../references/pipelines/cd-nova.yaml.md
[136]: ../../../references/pipelines/cd-shared.yaml.md
[137]: ../../../references/pipelines/ci-automation.yaml.md
[138]: ../../../references/pipelines/ci-infrastructure.yaml.md
[139]: ../../../../.github/workflows/ci-automation.yml
[140]: ../../../../pipelines/ci-automation.yaml
[141]: ../../../adr/glossary.md#world-map
[142]: ../../../adr/glossary.md#track
[143]: ../../../adr/glossary.md#file-language
[144]: ../../../adr/glossary.md#cell
[145]: ../../../adr/glossary.md#lit-cell
[146]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[147]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

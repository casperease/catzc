# docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md

`Grid minimap: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance`

![Grid minimap of adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.png)

The grid minimap of the slide `adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance` (governance lens). The slide
supports [ADR-DSGN-ASPECT][1], [ADR-FLOW-CD-GLOBS][2], [ADR-PWSH-MANIFEST][3], [ADR-PWSH-ONEFUNC][4] and [ADR-REPO-FOLDERS][5]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 8 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 10 lit of 219 files
- automation × powershell: 49 lit of 1412 files
- automation × yaml: 7 lit of 95 files
- docs × markdown: 78 lit of 742 files
- pipelines × pipeline-yaml: 6 lit of 9 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][6]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [.claude/CLAUDE.md][9]: selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 45 (text).

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][6]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [.github/workflows/ci-automation.yml][10]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (body comment) (a passing
  mention only).

### automation × csharp (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][6]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [automation/Catzc.Base.Globs/types/Aspect.cs][11]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 1 (header), line 14
  (header) and line 92 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][12]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header) and line
  7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][13]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header), line 8
  (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57 (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][14]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 5
  (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32 (body comment), line 41 (body
  comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158 (body comment) and line 180
  (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][15]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 7
  (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text) and line 172 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][16]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][17]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][18]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 15 (header).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][19]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][20]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 18 (header).

### automation × powershell (49 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][6]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [automation/.internal/assets/Import-ModuleFiles.ps1][21]: selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 1 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][22]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][23]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][25]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][26]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][27]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][28]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header) and
  line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][29]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][30]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header) and line 9
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][31]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header) and line
  10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][32]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header) and
  line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][33]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][34]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 6 (header), line 10
  (header) and line 83 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72 (body comment), line 75 (body
  comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][35]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][36]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][37]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][38]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][39]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header),
  line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][40]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][41]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][42]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][43]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][44]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][45]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][46]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][47]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][48]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][49]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][50]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][51]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 40
  (text).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][52]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][53]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][54]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][55]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][56]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][57]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][58]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][59]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1
  (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][60]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header),
  line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][61]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3
  (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][62]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 8
  (header) and line 89 (body comment).
- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][63]: selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][64]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1][65]: selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][66]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][67]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 54 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 143 (body comment) (a
  passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][68]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9
  (header).
- [automation/Catzc.Base.Variants/Get-Aspect.ps1][69]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 6 (header).

### automation × yaml (7 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][6]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][70]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][71]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 102 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 122 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 189 (text);
  selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 187 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 308
  (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][72]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 32 (body comment) and
  line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][73]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 17 (text).
- [automation/Catzc.Base.Globs/configs/globs.yml][74]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header), line 7
  (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][75]: selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 590 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][76]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 30 (body comment)
  (a passing mention only).

### docs × markdown (78 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][6]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [docs/adr/design/commit-lifecycle.md][77]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][78]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][1]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][79]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][80]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][81]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][82]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][83]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][84]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][85]: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR domain, the ADR
  domain of that code.
- [docs/adr/flow/dora-explains.md][86]: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-detection.md][87]: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-runner-pattern.md][88]: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/pipeline-types.md][89]: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][90]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 752 (text).
- [docs/adr/index.md][91]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 111 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 175 (text); selected by
  [ADR-PWSH-ONEFUNC][4]: the file cites it at line 173 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 287 (text).
- [docs/adr/pwsh/announce-state-changes.md][92]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/assert-idioms.md][93]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][94]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][95]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/cross-platform-powershell.md][96]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dora-explains.md][97]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][3]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/environment-variable-mechanics.md][98]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/error-handling.md][99]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][100]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/identifier-names.md][101]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/index.md][102]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code;
  selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][103]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/one-function-per-file.md][4]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/parameter-design.md][104]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pester-testing.md][105]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/powershell-formatting.md][106]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][107]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the
  ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][108]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the
  ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][109]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pwsh-engine.md][110]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][111]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain
  of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/script-scope-caching.md][112]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][113]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][114]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/working-directory-mechanics.md][115]: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/repository/agent-definitions.md][116]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/api-contracts.md][117]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/controlled-vocabulary.md][118]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][5]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][119]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][120]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][121]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain,
  the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][122]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/generated-readmes.md][123]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/generated-root-configs.md][124]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the
  ADR domain of that code.
- [docs/adr/repository/inspiration.md][125]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/markdown-links.md][126]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/output-formats.md][127]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/adr/repository/repo-variants.md][128]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/uniform-formatting.md][129]: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository` ADR domain, the ADR
  domain of that code.
- [docs/explanation/automation/what-gates-each-bundle-stage.md][130]: selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 16
  (text), line 32 (text) and line 50 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][131]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 16
  (text), line 46 (text) and line 48 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 52 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][132]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 14 (text),
  line 42 (text), line 44 (text), line 45 (text), line 46 (text), line 51 (text), line 53 (text) and line 55 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 51 (text).
- [docs/explanation/design/manifest-and-aspects-from-one-folder.md][133]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 18
  (text), line 53 (text), line 55 (text) and line 61 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 59 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][134]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 17
  (text), line 51 (text), line 53 (text), line 55 (text), line 59 (text) and line 61 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 59 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][135]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line
  17 (text), line 21 (text), line 22 (text), line 45 (text), line 46 (text), line 48 (text), line 59 (text), line 60 (text), line 61 (text),
  line 65 (text) and line 67 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 49 (text) and line 67 (text); selected by
  [ADR-PWSH-MANIFEST][3]: the file cites it at line 36 (text), line 42 (text), line 43 (text), line 55 (text), line 56 (text) and line 69
  (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 35 (text) and line 53 (text); selected by [ADR-REPO-FOLDERS][5]: the
  file cites it at line 38 (text), line 57 (text) and line 71 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][136]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 59
  (text) and line 59 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 54 (text) and line 55 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][137]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][138]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][139]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text),
  line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text), line 59
  (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][140]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][141]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][142]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18
  (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][143]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16
  (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][144]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text),
  line 38 (text) and line 40 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][145]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][146]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text),
  line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][147]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18
  (text).
- [docs/references/automation/catzc-base-globs.md][148]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][149]: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 47 (text) and line
  77 (text).

### pipelines × pipeline-yaml (6 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][6]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [pipelines/cd-apex.yaml][150]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (header).
- [pipelines/cd-flux.yaml][151]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (header).
- [pipelines/cd-nova.yaml][152]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (header).
- [pipelines/cd-shared.yaml][153]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29 (header).
- [pipelines/ci-automation.yaml][154]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][155]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (header).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][156]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][7]). Lit ([ADR-DSGN-TRACK#12][8]) by:

- [importer.ps1][157]: selected by [ADR-PWSH-MANIFEST][3]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

## Keywords

- [world map][158]
- [track][159]
- [file language][160]
- [cell][161]
- [lit cell][162]
- [root file][163]
- [.claude][76]: a track
- [.github][76]: a track
- [automation][76]: a track
- [docs][76]: a track
- [pipelines][76]: a track
- [csharp][164]: a file language
- [markdown][164]: a file language
- [pipeline-yaml][164]: a file language
- [powershell][164]: a file language
- [yaml][164]: a file language

Terms the cited ADRs define:

- [domain][165], defined by [ADR-REPO-FOLDERS#5][166]

[1]: ../../adr/design/module-aspects.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/pwsh/dynamic-module-manifests.md
[4]: ../../adr/pwsh/one-function-per-file.md
[5]: ../../adr/repository/conventional-folders.md
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[8]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[9]: ../../../.claude/CLAUDE.md
[10]: ../../../.github/workflows/ci-automation.yml
[11]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[12]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[13]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[14]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[15]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[16]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[17]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[18]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[19]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[20]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[21]: ../../../automation/.internal/assets/Import-ModuleFiles.ps1
[22]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[23]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[24]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[25]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[26]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[27]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[28]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[29]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[30]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[31]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[32]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[33]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[34]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[35]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[36]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[37]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[38]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[39]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[40]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[41]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[42]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[43]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[44]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[45]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[46]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[47]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[48]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[49]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[50]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[51]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[52]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[53]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[54]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[55]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[56]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[57]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[58]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[59]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[60]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[61]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[62]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[63]: ../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[64]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[65]: ../../../automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
[66]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[67]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[68]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[69]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[70]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[71]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[72]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[73]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[74]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[75]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[76]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[77]: ../../adr/design/commit-lifecycle.md
[78]: ../../adr/design/dora-explains.md
[79]: ../../adr/design/run-modes.md
[80]: ../../adr/design/self-service.md
[81]: ../../adr/design/server-remote-integration.md
[82]: ../../adr/design/thin-platforms.md
[83]: ../../adr/design/tracks.md
[84]: ../../adr/design/visual-design.md
[85]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[86]: ../../adr/flow/dora-explains.md
[87]: ../../adr/flow/pipeline-detection.md
[88]: ../../adr/flow/pipeline-runner-pattern.md
[89]: ../../adr/flow/pipeline-types.md
[90]: ../../adr/glossary.md
[91]: ../../adr/index.md
[92]: ../../adr/pwsh/announce-state-changes.md
[93]: ../../adr/pwsh/assert-idioms.md
[94]: ../../adr/pwsh/automatic-variable-pitfalls.md
[95]: ../../adr/pwsh/avoid-using-semicolons.md
[96]: ../../adr/pwsh/cross-platform-powershell.md
[97]: ../../adr/pwsh/dora-explains.md
[98]: ../../adr/pwsh/environment-variable-mechanics.md
[99]: ../../adr/pwsh/error-handling.md
[100]: ../../adr/pwsh/hosting-csharp-types.md
[101]: ../../adr/pwsh/identifier-names.md
[102]: ../../adr/pwsh/index.md
[103]: ../../adr/pwsh/module-path-hygiene.md
[104]: ../../adr/pwsh/parameter-design.md
[105]: ../../adr/pwsh/pester-testing.md
[106]: ../../adr/pwsh/powershell-formatting.md
[107]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[108]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[109]: ../../adr/pwsh/prepost-extension-modules.md
[110]: ../../adr/pwsh/pwsh-engine.md
[111]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[112]: ../../adr/pwsh/script-scope-caching.md
[113]: ../../adr/pwsh/use-ps1-not-psm1.md
[114]: ../../adr/pwsh/vendor-toolset-dependencies.md
[115]: ../../adr/pwsh/working-directory-mechanics.md
[116]: ../../adr/repository/agent-definitions.md
[117]: ../../adr/repository/api-contracts.md
[118]: ../../adr/repository/controlled-vocabulary.md
[119]: ../../adr/repository/dedicated-output-directory.md
[120]: ../../adr/repository/documentation-examples.md
[121]: ../../adr/repository/domain-language-separation.md
[122]: ../../adr/repository/dora-explains.md
[123]: ../../adr/repository/generated-readmes.md
[124]: ../../adr/repository/generated-root-configs.md
[125]: ../../adr/repository/inspiration.md
[126]: ../../adr/repository/markdown-links.md
[127]: ../../adr/repository/output-formats.md
[128]: ../../adr/repository/repo-variants.md
[129]: ../../adr/repository/uniform-formatting.md
[130]: ../../explanation/automation/what-gates-each-bundle-stage.md
[131]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[132]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[133]: ../../explanation/design/manifest-and-aspects-from-one-folder.md
[134]: ../../explanation/design/one-folder-two-independent-readers.md
[135]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[136]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[137]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[138]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[139]: ../../explanation/flow/gates-check-source-and-trigger.md
[140]: ../../explanation/flow/globs-module-owns-config-and-types.md
[141]: ../../explanation/flow/independence-check-groups-by-layer.md
[142]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[143]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[144]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[145]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[146]: ../../explanation/flow/two-declared-layers-one-derived.md
[147]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[148]: ../../references/automation/catzc-base-globs.md
[149]: ../../references/automation/catzc-base-languages.md
[150]: ../../../pipelines/cd-apex.yaml
[151]: ../../../pipelines/cd-flux.yaml
[152]: ../../../pipelines/cd-nova.yaml
[153]: ../../../pipelines/cd-shared.yaml
[154]: ../../../pipelines/ci-automation.yaml
[155]: ../../../pipelines/ci-infrastructure.yaml
[156]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[157]: ../../../importer.ps1
[158]: ../../adr/glossary.md#world-map
[159]: ../../adr/glossary.md#track
[160]: ../../adr/glossary.md#file-language
[161]: ../../adr/glossary.md#cell
[162]: ../../adr/glossary.md#lit-cell
[163]: ../../adr/glossary.md#root-file
[164]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[165]: ../../adr/glossary.md#domain
[166]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5

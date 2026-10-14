# docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md

`Tree minimap: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance`

![Tree minimap of adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance` (governance lens). The slide
supports [ADR-DSGN-ASPECT][1], [ADR-FLOW-CD-GLOBS][2], [ADR-PWSH-MANIFEST][3], [ADR-PWSH-ONEFUNC][4] and [ADR-REPO-FOLDERS][5]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 138 files in 21 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 40 lit files
- adr/pwsh (docs/adr/pwsh): 26 lit files
- adr/repo (docs/adr/repository): 16 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 6 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- Docs (automation/Catzc.Base.Docs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Languages (automation/Catzc.Base.Languages): 3 lit files
- docs (docs/ outside docs/adr/): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- Root files: 1 lit file
- .claude: 1 lit file
- .github: 1 lit file
- .internal (automation/.internal): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- Overlay (automation/Catzc.Base.Overlay): 1 lit file

## Why each group is lit

### Globs (40 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][6], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][7], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][8], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][9], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][10], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][11], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][12], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72
  (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][13], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][14], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][15], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][16], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][17], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][18], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][19], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 2 (header), line 7 (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body
  comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][20], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][21], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][22], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][23], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][26], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][27], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][28], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][29], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][30], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][31], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][32], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][33], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][34], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][35], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][37], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][38], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][39], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][40], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text),
  line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][41], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 1 (header), line 14 (header) and line 92 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][42], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][43], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][44], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][45], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### adr/pwsh (26 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/announce-state-changes.md][46], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/assert-idioms.md][47], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][48], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][49], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/cross-platform-powershell.md][50], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/dora-explains.md][51], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][3], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/environment-variable-mechanics.md][52], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/error-handling.md][53], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][54], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/identifier-names.md][55], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/index.md][56], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the
  ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][57], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/one-function-per-file.md][4], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/parameter-design.md][58], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pester-testing.md][59], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/powershell-formatting.md][60], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][61], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][62], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][63], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/pwsh-engine.md][64], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][65], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/script-scope-caching.md][66], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][67], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][68], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/working-directory-mechanics.md][69], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.

### adr/repo (16 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][70], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][71], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][72], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][5], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][73], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][74], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][75], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][76], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][77], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][78], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][79], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][80], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][81], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/protected-globs.md][82], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][83], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][84], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][85], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][86], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][87], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][88], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][89], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][90], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][91], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][92], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### QualityGates (6 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][93], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][94], in the cell automation × yaml: selected by [ADR-PWSH-ONEFUNC][4]: the
  file cites it at line 590 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1][95], in the cell automation × powershell: selected by
  [ADR-PWSH-ONEFUNC][4]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][96], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][97], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][98], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][99], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][100], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][101], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][102], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][103], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][104], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][105], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][106], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][107], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][108], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  4 (header).
- [pipelines/ci-infrastructure.yaml][109], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][110], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][111], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][112], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][113], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][114], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (header).

### Docs (4 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][115], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 122 (text); selected by [ADR-PWSH-MANIFEST][3]: the file
  cites it at line 188 (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 186 (text); selected by [ADR-REPO-FOLDERS][5]:
  the file cites it at line 308 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][116], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][5]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][117], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][5]: the file cites
  it at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][118], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][5]: the
  file cites it at line 7 (header).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][119], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][120], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][121], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][122], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### Languages (3 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/types/BashConfig.cs][123], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][124], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][125], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 15 (header).

### docs (3 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][126], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs.md][127], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][128], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites
  it at line 47 (text) and line 77 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][129], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 765 (text).
- [docs/adr/index.md][130], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 111 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 174 (text);
  selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 172 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 286
  (text).

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][131], in the cell Root files × powershell: selected by [ADR-PWSH-MANIFEST][3]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][132], in the cell .claude × markdown: selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 45 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][133], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (body comment) (a passing mention only).

### .internal (1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-ModuleFiles.ps1][134], in the cell automation × powershell: selected by [ADR-PWSH-MANIFEST][3]: the
  file cites it at line 1 (header).

### Contracts (1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1][135], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 7 (header).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][136], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 6 (header).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][137], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (header) and line 89 (body comment).

### Overlay (1 lit file)

The group holds the files of automation/Catzc.Base.Overlay; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][138], in the cell automation × powershell: selected by
  [ADR-PWSH-MANIFEST][3]: the file cites it at line 8 (header).

## Keywords

- [world map][139]
- [track][140]
- [file language][141]
- [cell][142]
- [lit cell][143]
- [root file][144]
- [.claude][120]: a track
- [.github][120]: a track
- [automation][120]: a track
- [docs][120]: a track
- [pipelines][120]: a track
- [csharp][145]: a file language
- [markdown][145]: a file language
- [pipeline-yaml][145]: a file language
- [powershell][145]: a file language
- [yaml][145]: a file language

Terms the cited ADRs define:

- [domain][146], defined by [ADR-REPO-FOLDERS#5][147]

[1]: ../../adr/design/module-aspects.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/pwsh/dynamic-module-manifests.md
[4]: ../../adr/pwsh/one-function-per-file.md
[5]: ../../adr/repository/conventional-folders.md
[6]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[7]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[8]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[10]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[11]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[12]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[13]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[14]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[15]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[16]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[17]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[18]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[19]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[20]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[21]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[22]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[23]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[24]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[25]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[26]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[27]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[28]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[29]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[30]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[31]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[32]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[33]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[34]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[35]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[36]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[37]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[38]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[39]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[40]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[41]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[42]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[43]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[44]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[45]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[46]: ../../adr/pwsh/announce-state-changes.md
[47]: ../../adr/pwsh/assert-idioms.md
[48]: ../../adr/pwsh/automatic-variable-pitfalls.md
[49]: ../../adr/pwsh/avoid-using-semicolons.md
[50]: ../../adr/pwsh/cross-platform-powershell.md
[51]: ../../adr/pwsh/dora-explains.md
[52]: ../../adr/pwsh/environment-variable-mechanics.md
[53]: ../../adr/pwsh/error-handling.md
[54]: ../../adr/pwsh/hosting-csharp-types.md
[55]: ../../adr/pwsh/identifier-names.md
[56]: ../../adr/pwsh/index.md
[57]: ../../adr/pwsh/module-path-hygiene.md
[58]: ../../adr/pwsh/parameter-design.md
[59]: ../../adr/pwsh/pester-testing.md
[60]: ../../adr/pwsh/powershell-formatting.md
[61]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[62]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[63]: ../../adr/pwsh/prepost-extension-modules.md
[64]: ../../adr/pwsh/pwsh-engine.md
[65]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[66]: ../../adr/pwsh/script-scope-caching.md
[67]: ../../adr/pwsh/use-ps1-not-psm1.md
[68]: ../../adr/pwsh/vendor-toolset-dependencies.md
[69]: ../../adr/pwsh/working-directory-mechanics.md
[70]: ../../adr/repository/agent-definitions.md
[71]: ../../adr/repository/api-contracts.md
[72]: ../../adr/repository/controlled-vocabulary.md
[73]: ../../adr/repository/dedicated-output-directory.md
[74]: ../../adr/repository/documentation-examples.md
[75]: ../../adr/repository/domain-language-separation.md
[76]: ../../adr/repository/dora-explains.md
[77]: ../../adr/repository/generated-readmes.md
[78]: ../../adr/repository/generated-root-configs.md
[79]: ../../adr/repository/inspiration.md
[80]: ../../adr/repository/markdown-links.md
[81]: ../../adr/repository/output-formats.md
[82]: ../../adr/repository/protected-globs.md
[83]: ../../adr/repository/repo-variants.md
[84]: ../../adr/repository/uniform-formatting.md
[85]: ../../adr/design/commit-lifecycle.md
[86]: ../../adr/design/dora-explains.md
[87]: ../../adr/design/run-modes.md
[88]: ../../adr/design/self-service.md
[89]: ../../adr/design/server-remote-integration.md
[90]: ../../adr/design/thin-platforms.md
[91]: ../../adr/design/tracks.md
[92]: ../../adr/design/visual-design.md
[93]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[94]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[95]: ../../../automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
[96]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[97]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[98]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[99]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[100]: ../../adr/flow/dora-explains.md
[101]: ../../adr/flow/pipeline-detection.md
[102]: ../../adr/flow/pipeline-runner-pattern.md
[103]: ../../adr/flow/pipeline-types.md
[104]: ../../../pipelines/cd-apex.yaml
[105]: ../../../pipelines/cd-flux.yaml
[106]: ../../../pipelines/cd-nova.yaml
[107]: ../../../pipelines/cd-shared.yaml
[108]: ../../../pipelines/ci-automation.yaml
[109]: ../../../pipelines/ci-infrastructure.yaml
[110]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[111]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[112]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[113]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[114]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[115]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[116]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[117]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[118]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[119]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[120]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[121]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[122]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[123]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[124]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[125]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[126]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[127]: ../../references/automation/catzc-base-globs.md
[128]: ../../references/automation/catzc-base-languages.md
[129]: ../../adr/glossary.md
[130]: ../../adr/index.md
[131]: ../../../importer.ps1
[132]: ../../../.claude/CLAUDE.md
[133]: ../../../.github/workflows/ci-automation.yml
[134]: ../../../automation/.internal/assets/Import-ModuleFiles.ps1
[135]: ../../../automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1
[136]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[137]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[138]: ../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[139]: ../../adr/glossary.md#world-map
[140]: ../../adr/glossary.md#track
[141]: ../../adr/glossary.md#file-language
[142]: ../../adr/glossary.md#cell
[143]: ../../adr/glossary.md#lit-cell
[144]: ../../adr/glossary.md#root-file
[145]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[146]: ../../adr/glossary.md#domain
[147]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5

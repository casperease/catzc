---
catzc:
  immutable:
    with_body_sha: d3b7b4dbbc1d
    repo_status: locked
    path: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/grid.md
    source: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the world-map minimap

```text
Where the files that cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 198 files.
```

![The world-map minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to
one pipeline is held by review alone][199], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 17 lit of 89 files
- docs × markdown: 131 lit of 2767 files
- pipelines × pipeline-yaml: 3 lit of 14 files
- pwsh × csharp: 10 lit of 293 files
- pwsh × powershell: 28 lit of 1651 files
- pwsh × yaml: 9 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (17 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 55 (text).
- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text), line 26 (text), line 45
  (text), line 53 (text), line 116 (text), line 117 (text), line 121 (text), line 121 (text), line 123 (text), line 129 (text), line 131
  (text) and line 176 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text), line 193 (text) and line 193 (text).
- [.claude/plans/decisions-2026-10-18.md][6]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 33 (text) and line
  33 (text).
- [.claude/plans/plan-adr-code-language.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text) and line 36 (text);
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 126 (text), line 127 (text), line 128 (text), line 181 (text) and line 184
  (text).
- [.claude/plans/plan-diagram-folders.md][8]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 44 (text) and line 82 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 59 (text) and line 109
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 36 (text), line 60 (text), line 97 (text) and line 109 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 77 (text), line
  78 (text) and line 195 (text).
- [.claude/plans/plan-master.md][11]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text) and line 24
  (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 12 (text) and line 23 (text).
- [.claude/plans/plan-promotion-ladder.md][13]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text), line 35 (text) and
  line 94 (text).
- [.claude/plans/prompt-diagram-folders-2-adrs.md][14]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 15 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][15]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 79 (text) and line 90 (text).
- [.claude/plans/task-diagram-folders.md][17]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 62 (text).
- [.claude/plans/task-layers-classification-flip.md][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 31
  (text), line 31 (text), line 31 (text) and line 33 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 31 (text).
- [.claude/plans/task-loose-ends.md][19]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][20]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 35 (text).

### docs × markdown (131 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [docs/adr/design/dora-explains.md][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][22]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (text) and line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/glossary.md][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161 (text), line 178 (text), line
  210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329 (text), line 332 (text), line
  355 (text), line 395 (text), line 409 (text), line 418 (text), line 432 (text), line 445 (text), line 479 (text) and line 491 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 1203 (text).
- [docs/adr/index.md][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 129 (text) and line 133 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 318 (text).
- [docs/adr/repository/conventional-folders.md][3]: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][25]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 11 (text).
- [docs/how-to/automation/apply-environment-approvals.md][26]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (text).
- [docs/how-to/automation/sort-an-import.md][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][28]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text),
  line 17 (text), line 23 (text), line 23 (text), line 26 (text), line 26 (text), line 28 (text), line 28 (text), line 28 (text), line 29
  (text), line 30 (text) and line 32 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][30]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 55 (text) and line 55 (text).
- [docs/references/note-file-kind.md][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text), line 34 (text) and line 37
  (text).
- [docs/references/pipelines/cd-apex.yaml.md][32]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][33]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][34]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][35]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][37]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][38]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][39]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][40]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][41]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][42]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][43]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][44]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 15 (text).
- [docs/references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md][45]: selected by [ADR-REPO-FOLDERS][3]: the file
  cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text) and
  line 22 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md][47]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text) and
  line 17 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text),
  line 35 (text) and line 47 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 28 (text), line 29 (text), line 57 (text)
  and line 58 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][51]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][52]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-globs.md][53]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][54]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][55]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][56]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][57]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][58]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][59]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (text), line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][60]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][61]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 58
  (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][62]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][63]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][64]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][65]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][66]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][67]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][68]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 105 (text);
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41 (text),
  line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][69]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][70]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][71]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][72]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 18 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][73]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 33 (text), line 108 (text) and line 108 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][74]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][75]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][76]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][77]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][78]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][79]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][80]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][81]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][82]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][83]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][84]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][85]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][86]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][87]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][88]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][89]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][90]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11
  (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][91]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17
  (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][92]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text),
  line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38 (text), line 47 (text), line 65
  (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][93]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13
  (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-languages.md][94]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 45 (text) and line 75
  (text).
- [docs/references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][97]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][98]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-languages/types/BashConfig.cs.md][99]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22
  (text).
- [docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md][100]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md][101]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  12 (text).
- [docs/references/pwsh/catzc-base-languages/types/PythonConfig.cs.md][103]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 25
  (text).
- [docs/references/pwsh/catzc-base-maps.md][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 66 (text), line 68 (text) and
  line 80 (text).
- [docs/references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md][105]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 21 (text), line 23 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][106]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 17 (text) and line 43 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md][107]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14
  (text), line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md][108]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text),
  line 16 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][109]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text) and line 60 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 54 (text).
- [docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md][110]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 22 (text), line 25 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md][111]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text),
  line 21 (text), line 25 (text), line 28 (text) and line 29 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][112]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text),
  line 42 (text), line 44 (text) and line 49 (text).
- [docs/references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md][113]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][114]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][115]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][116]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][117]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][118]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][119]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][120]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md][121]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text),
  line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][122]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text),
  line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md][123]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md][124]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md][125]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text), line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md][126]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md][127]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text) and
  line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md][128]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 19 (text), line 22 (text) and line 65 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md][129]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13
  (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md][130]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md][131]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text),
  line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md][132]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 16 (text) and line 68 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][133]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md][134]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][135]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md][136]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][137]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][138]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][139]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md][140]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md][141]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][142]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md][143]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][144]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text),
  line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][145]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 75
  (text), line 78 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][146]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][147]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32
  (text), line 35 (text) and line 37 (text).
- [docs/references/pwsh/claude-drawio/minimaps/highlights.ps1.md][148]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51
  (text).

### pipelines × pipeline-yaml (3 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pipelines/cd-shared.yaml][149]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 45 (body comment) (a passing mention only).
- [pipelines/ci-automation.yaml][150]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (text), `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108
  (text), `pwsh/Catzc.Base.Docs/types/AdrsConfig.cs` line 15 (body comment),
  `pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 41 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml` line 5 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 111 (text), `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1`
  line 123 (text), `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 161 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 15 (text),
  `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 16 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 26 (text),
  `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 29 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 46 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 26 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 62 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 66 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 67 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 42 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1`
  line 17 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 89
  (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 74 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  49 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 54 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  55 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 56 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 60 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  63 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  80 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 57 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  61 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 64 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  68 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 69 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  73 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 82 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  83 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 87 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  91 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 92 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  111 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 111 (text), `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 15 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 22 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 17 (text), `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line
  26 (text), `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 39 (text), `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1`
  line 69 (text), `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 113 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 127 (text), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs` line 9
  (body comment), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs` line 12 (body comment), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 5 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 62 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 70 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 79 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 88 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 94 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 190 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 200 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 211 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 234 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 247 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 261 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 276 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 289 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 301 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 314 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 316 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 328 (text),
  `pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml` line 7 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line
  299 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 302 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Variants/configs/track-types.yml`
  line 42 (text), `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 52 (text), `pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 71
  (text), `pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Variants/types/ModulePlace.cs`
  line 6 (body comment), `pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs` line 5 (body comment),
  `pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 10 (body comment), `pwsh/Catzc.Base.Variants/types/PathModule.cs` line 3 (body
  comment) and `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs` line 265 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text),
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text), `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42 (text),
  `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2 (text), `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1`
  line 4 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 58 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 53
  (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line
  89 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 23 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 31 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text),
  `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 47 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text),
  `pwsh/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text) and `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`
  line 1076 (text); selected by [ADR-REPO-FOLDERS][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it
  at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 294 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 34 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 39 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 67 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (text),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 43 (text), `pwsh/Catzc.Base.QualityGates/Test-Plans.ps1` line 45 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 47 (text), `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line
  89 (text) and `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 93 (text).
- [pipelines/extends/cd-customer.yaml][151]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 21 (body comment) (a passing
  mention only).

### pwsh × csharp (10 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/types/AdrsConfig.cs][152]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (body comment) (a passing
  mention only).
- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][153]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 23 (text), line 27
  (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][154]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 54 (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][155]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 73 (text), line 136
  (text), line 140 (text) and line 154 (text).
- [pwsh/Catzc.Base.Maps/types/ValueChainCell.cs][156]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (body comment) and line
  12 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModulePlace.cs][157]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs][158]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs][159]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/PathModule.cs][160]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/VariantsConfig.cs][161]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 265 (text).

### pwsh × powershell (28 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][162]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text) and
  line 108 (text).
- [pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][163]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][164]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][165]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (text)
  and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][166]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][167]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][168]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 41 (text);
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][169]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 111 (text),
  line 123 (text) and line 161 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][170]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1][171]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 16 (text),
  line 26 (text), line 29 (text) and line 46 (text).
- [pwsh/Catzc.Base.Maps/Test-WorldMap.ps1][172]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 45 (text), line
  62 (text), line 66 (text) and line 67 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][173]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text),
  line 23 (text) and line 42 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][174]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line
  36 (text) and line 36 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][175]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 89 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][176]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text);
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 70 (text) and line 71 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][177]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 49 (text), line
  49 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 60 (text), line 63 (text), line 80 (text), line 80 (text)
  and line 80 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][178]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 57 (text), line 61
  (text), line 64 (text), line 68 (text), line 69 (text), line 73 (text), line 82 (text), line 83 (text), line 87 (text), line 91 (text),
  line 92 (text), line 111 (text), line 111 (text) and line 111 (text).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][179]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 22 (text), line 28 (text), line 45 (text) and line 45 (text).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][180]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text),
  line 26 (text), line 31 (text) and line 39 (text).
- [pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][181]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 69 (text),
  line 113 (text) and line 127 (text).
- [pwsh/Catzc.Base.QualityGates/Test-Plans.ps1][182]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 45 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][183]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][184]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][185]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1][186]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 47 (text),
  line 89 (text) and line 93 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][187]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text) and
  line 52 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][188]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][189]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).

### pwsh × yaml (9 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][190]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 97 (text) and line 101 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 294 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][191]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 28 (text), line 34 (text) and
  line 39 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][192]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 67 (text) and line 77
  (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][193]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 43 (text).
- [pwsh/Catzc.Base.Languages/configs/glossary.yml][194]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][195]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (text), line 62
  (text), line 70 (text), line 79 (text), line 88 (text), line 94 (text), line 190 (text), line 200 (text), line 211 (text), line 234
  (text), line 247 (text), line 261 (text), line 276 (text), line 289 (text), line 301 (text), line 314 (text), line 316 (text) and line 328
  (text).
- [pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml][196]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][197]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 299 (text) and
  line 302 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1076 (text).
- [pwsh/Catzc.Base.Variants/configs/track-types.yml][198]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 42 (text).

## Keywords

- [world map][200]
- [track][201]
- [file language][202]
- [cell][203]
- [lit cell][204]
- [.claude][205]: a track
- [docs][205]: a track
- [pipelines][205]: a track
- [pwsh][205]: a track
- [csharp][206]: a file language
- [markdown][206]: a file language
- [pipeline-yaml][206]: a file language
- [powershell][206]: a file language
- [yaml][206]: a file language

[1]: ../../../../adr/design/tracks.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../adr/repository/conventional-folders.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../../.claude/plans/decisions-2026-10-18.md
[7]: ../../../../../.claude/plans/plan-adr-code-language.md
[8]: ../../../../../.claude/plans/plan-diagram-folders.md
[9]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[10]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[11]: ../../../../../.claude/plans/plan-master.md
[12]: ../../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[13]: ../../../../../.claude/plans/plan-promotion-ladder.md
[14]: ../../../../../.claude/plans/prompt-diagram-folders-2-adrs.md
[15]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[16]: ../../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[17]: ../../../../../.claude/plans/task-diagram-folders.md
[18]: ../../../../../.claude/plans/task-layers-classification-flip.md
[19]: ../../../../../.claude/plans/task-loose-ends.md
[20]: ../../../../../.claude/plans/value-of-plan.md
[21]: ../../../../adr/design/dora-explains.md
[22]: ../../../../adr/flow/dora-explains.md
[23]: ../../../../adr/glossary.md
[24]: ../../../../adr/index.md
[25]: ../../../../adr/repository/dora-explains.md
[26]: ../../../../how-to/automation/apply-environment-approvals.md
[27]: ../../../../how-to/automation/sort-an-import.md
[28]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[29]: ../../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[30]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[31]: ../../../../references/note-file-kind.md
[32]: ../../../../references/pipelines/cd-apex.yaml.md
[33]: ../../../../references/pipelines/cd-flux.yaml.md
[34]: ../../../../references/pipelines/cd-nova.yaml.md
[35]: ../../../../references/pipelines/cd-shared.yaml.md
[36]: ../../../../references/pipelines/ci-automation.yaml.md
[37]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[38]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[39]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[40]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[41]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[42]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[43]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[44]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[45]: ../../../../references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
[46]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[47]: ../../../../references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md
[48]: ../../../../references/pwsh/catzc-base-docs/types/AdrDomain.cs.md
[49]: ../../../../references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md
[50]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[51]: ../../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[52]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[53]: ../../../../references/pwsh/catzc-base-globs.md
[54]: ../../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[55]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[56]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[57]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[58]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[59]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[60]: ../../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[61]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[62]: ../../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[63]: ../../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[64]: ../../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[65]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[66]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[67]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[68]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[69]: ../../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[70]: ../../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[71]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[72]: ../../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[73]: ../../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[74]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[75]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[76]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[77]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[78]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[79]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[80]: ../../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[81]: ../../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[82]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[83]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[84]: ../../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[85]: ../../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[86]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[87]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[88]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[89]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[90]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[91]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[92]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[93]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[94]: ../../../../references/pwsh/catzc-base-languages.md
[95]: ../../../../references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md
[96]: ../../../../references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md
[97]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[98]: ../../../../references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[99]: ../../../../references/pwsh/catzc-base-languages/types/BashConfig.cs.md
[100]: ../../../../references/pwsh/catzc-base-languages/types/FileLanguage.cs.md
[101]: ../../../../references/pwsh/catzc-base-languages/types/GoConfig.cs.md
[102]: ../../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[103]: ../../../../references/pwsh/catzc-base-languages/types/PythonConfig.cs.md
[104]: ../../../../references/pwsh/catzc-base-maps.md
[105]: ../../../../references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md
[106]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[107]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md
[108]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
[109]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[110]: ../../../../references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
[111]: ../../../../references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
[112]: ../../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[113]: ../../../../references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
[114]: ../../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[115]: ../../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[116]: ../../../../references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[117]: ../../../../references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[118]: ../../../../references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[119]: ../../../../references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[120]: ../../../../references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[121]: ../../../../references/pwsh/catzc-base-maps/types/MapCell.cs.md
[122]: ../../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[123]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md
[124]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md
[125]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md
[126]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md
[127]: ../../../../references/pwsh/catzc-base-maps/types/WorldMap.cs.md
[128]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
[129]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md
[130]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
[131]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md
[132]: ../../../../references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[133]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[134]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md
[135]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[136]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md
[137]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[138]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[139]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[140]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md
[141]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md
[142]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[143]: ../../../../references/pwsh/catzc-base-variants/Get-PathModule.ps1.md
[144]: ../../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[145]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[146]: ../../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[147]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[148]: ../../../../references/pwsh/claude-drawio/minimaps/highlights.ps1.md
[149]: ../../../../../pipelines/cd-shared.yaml
[150]: ../../../../../pipelines/ci-automation.yaml
[151]: ../../../../../pipelines/extends/cd-customer.yaml
[152]: ../../../../../pwsh/Catzc.Base.Docs/types/AdrsConfig.cs
[153]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[154]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[155]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[156]: ../../../../../pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
[157]: ../../../../../pwsh/Catzc.Base.Variants/types/ModulePlace.cs
[158]: ../../../../../pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[159]: ../../../../../pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[160]: ../../../../../pwsh/Catzc.Base.Variants/types/PathModule.cs
[161]: ../../../../../pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
[162]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[163]: ../../../../../pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[164]: ../../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[165]: ../../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[166]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[167]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[168]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[169]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[170]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[171]: ../../../../../pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
[172]: ../../../../../pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
[173]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[174]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[175]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[176]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[177]: ../../../../../pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[178]: ../../../../../pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[179]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[180]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[181]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[182]: ../../../../../pwsh/Catzc.Base.QualityGates/Test-Plans.ps1
[183]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[184]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[185]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[186]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
[187]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[188]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[189]: ../../../../../pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[190]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[191]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[192]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[193]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[194]: ../../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[195]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[196]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
[197]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[198]: ../../../../../pwsh/Catzc.Base.Variants/configs/track-types.yml
[199]: ../../unit-to-pipeline-rule-is-review-only.md
[200]: ../../../../adr/glossary.md#world-map
[201]: ../../../../adr/glossary.md#track
[202]: ../../../../adr/glossary.md#file-language
[203]: ../../../../adr/glossary.md#cell
[204]: ../../../../adr/glossary.md#lit-cell
[205]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[206]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

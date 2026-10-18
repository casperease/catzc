---
catzc:
  immutable:
    with_body_sha: "1ff072c811b7"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
    source: docs/explanation/.assets/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the world-map minimap

```text
Where the files that cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS sit in the repository: tracks down, file languages across.
7 of 342 cells lit, holding 192 files.
```

![The world-map minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to
one pipeline is held by review alone][196], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 15 lit of 90 files
- automation × csharp: 10 lit of 289 files
- automation × powershell: 28 lit of 1629 files
- automation × yaml: 9 lit of 112 files
- docs × markdown: 128 lit of 2742 files
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

### .claude × markdown (15 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/CLAUDE.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text).
- [.claude/plans/decisions-2026-10-16.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text), line 26 (text), line 45
  (text), line 53 (text), line 116 (text), line 117 (text), line 121 (text), line 121 (text), line 123 (text), line 129 (text), line 131
  (text) and line 176 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text), line 193 (text) and line 193 (text).
- [.claude/plans/decisions-2026-10-18.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 33 (text) and line
  33 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 79 (text), line
  80 (text), line 193 (text), line 437 (text), line 478 (text), line 503 (text), line 583 (text), line 785 (text), line 812 (text), line 916
  (text) and line 921 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 917 (text).
- [.claude/plans/plan-master.md][12]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text) and line 40 (text).
- [.claude/plans/plan-module-kinds-tracks.md][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 42 (text), line 46 (text),
  line 72 (text), line 78 (text), line 119 (text), line 120 (text), line 141 (text), line 142 (text), line 163 (text), line 183 (text), line
  231 (text), line 344 (text), line 353 (text), line 501 (text), line 515 (text), line 546 (text), line 551 (text), line 597 (text), line
  613 (text), line 613 (text), line 639 (text), line 641 (text), line 643 (text), line 653 (text), line 661 (text), line 662 (text), line
  672 (text), line 691 (text), line 801 (text), line 813 (text), line 818 (text), line 820 (text), line 849 (text), line 856 (text), line
  878 (text), line 917 (text), line 936 (text), line 945 (text), line 986 (text) and line 1041 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 85
  (text) and line 211 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 75 (text) and line 132 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 28 (text)
  and line 53 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 34 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 29
  (text), line 30 (text), line 69 (text) and line 78 (text).
- [.claude/plans/prompt-module-model-2-implement.md][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (text), line 27
  (text) and line 39 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 79 (text) and line 90 (text).
- [.claude/plans/task-file-head-leftovers.md][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text) and line 70 (text).
- [.claude/plans/task-import-landing-zone.md][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 35 (text) and line 42 (text).

### automation × csharp (10 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pwsh/Catzc.Base.Docs/types/AdrsConfig.cs][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][23]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 23 (text), line 27
  (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][24]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 54 (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][25]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 73 (text), line 136
  (text), line 140 (text) and line 154 (text).
- [pwsh/Catzc.Base.Maps/types/ValueChainCell.cs][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (body comment) and
  line 12 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModulePlace.cs][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (body comment)
  (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/PathModule.cs][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/VariantsConfig.cs][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 268 (text).

### automation × powershell (28 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text)
  and line 108 (body comment).
- [pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][34]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][35]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2
  (text) and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][36]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 58
  (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][37]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 41 (text);
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 53 (text), line 66 (text), line 77 (text) and line 89 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 111
  (text), line 123 (text) and line 161 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 16
  (text), line 26 (text), line 29 (text) and line 46 (text).
- [pwsh/Catzc.Base.Maps/Test-WorldMap.ps1][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 45 (text),
  line 62 (text), line 66 (text) and line 67 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 23 (text) and line 42 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text),
  line 36 (text) and line 36 (body comment).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][45]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 89 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74
  (text).
- [pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 49 (text),
  line 49 (body comment), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 60 (text), line 63 (text), line 80 (text),
  line 80 (body comment) and line 80 (body comment).
- [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 57 (text), line
  61 (text), line 64 (text), line 68 (text), line 69 (text), line 73 (text), line 82 (text), line 83 (text), line 87 (text), line 91 (text),
  line 92 (text), line 111 (text), line 111 (body comment) and line 111 (body comment).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 22 (text), line 28 (text), line 45 (text) and line 45 (body comment).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 26 (text), line 31 (text) and line 39 (text).
- [pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][51]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 69
  (text), line 113 (text) and line 127 (text).
- [pwsh/Catzc.Base.QualityGates/Test-Plans.ps1][52]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 45 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][53]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][54]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][55]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1][56]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 47 (body
  comment), line 89 (body comment) and line 93 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][57]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text)
  and line 52 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][58]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][59]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).

### automation × yaml (9 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][60]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 294 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][61]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 28 (body comment), line
  34 (body comment) and line 39 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][62]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 67 (body comment)
  and line 77 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][63]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 43 (text).
- [pwsh/Catzc.Base.Languages/configs/glossary.yml][64]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][65]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (text), line
  62 (text), line 70 (text), line 79 (text), line 88 (text), line 94 (text), line 190 (text), line 200 (text), line 211 (text), line 234
  (text), line 247 (text), line 261 (text), line 276 (text), line 289 (text), line 301 (text), line 314 (text), line 316 (text) and line 328
  (text).
- [pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml][66]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7
  (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][67]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 297 (text)
  and line 300 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1216 (text).
- [pwsh/Catzc.Base.Variants/configs/track-types.yml][68]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 42 (text).

### docs × markdown (128 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/design/dora-explains.md][69]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][70]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][2]: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.
- [docs/adr/glossary.md][71]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161 (text), line 178 (text), line
  210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329 (text), line 331 (text), line
  346 (text), line 386 (text), line 400 (text), line 409 (text), line 423 (text), line 436 (text), line 470 (text) and line 482 (text);
  selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 1162 (text).
- [docs/adr/index.md][72]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 133 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 318 (text).
- [docs/adr/repository/conventional-folders.md][3]: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][73]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 11 (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][74]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16
  (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][75]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text), line 23 (text), line 23 (text), line 26 (text), line 26 (text), line 28 (text), line 28 (text), line 28 (text), line 29 (text),
  line 30 (text) and line 32 (text).
- [docs/how-to/automation/sort-an-import.md][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][77]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][78]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][79]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][80]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][81]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][82]: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md][83]: selected by [ADR-REPO-FOLDERS][3]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text)
  and line 22 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md][85]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md][87]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32
  (text), line 35 (text) and line 47 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][89]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-globs.md][91]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][92]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  15 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][93]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][94]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][95]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][96]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 20
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][97]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  15 (text), line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][98]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][99]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  58 (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][100]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][101]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][102]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][103]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 17 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][104]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][105]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][106]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 105
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text), line 17 (text), line 25 (text), line 27 (text), line 41
  (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][107]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][108]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][109]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][110]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 18 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][111]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 33 (text) and line 108 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][112]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][113]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][114]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][115]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][116]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][117]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][118]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][119]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][120]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][121]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][122]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][123]: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][124]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][125]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][126]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][127]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 19
  (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][128]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  11 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][129]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  17 (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][130]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13
  (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38 (text), line 47 (text),
  line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][131]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-languages.md][132]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 45 (text) and line
  75 (text).
- [docs/references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md][133]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md][134]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][135]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][136]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-languages/types/BashConfig.cs.md][137]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 22 (text).
- [docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md][138]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md][139]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  25 (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][140]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-languages/types/PythonConfig.cs.md][141]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 25 (text).
- [docs/references/pwsh/catzc-base-maps.md][142]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 66 (text), line 68 (text)
  and line 80 (text).
- [docs/references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md][143]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 21 (text), line 23 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][144]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 16 (text), line 17 (text) and line 43 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md][145]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14
  (text), line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md][146]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 16 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][147]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  20 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md][148]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 22 (text), line 25 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md][149]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 21 (text), line 25 (text), line 28 (text) and line 29 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][150]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36
  (text), line 42 (text), line 44 (text) and line 49 (text).
- [docs/references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md][151]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 17 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][152]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][153]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][154]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][155]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][156]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][157]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][158]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md][159]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][160]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md][161]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md][162]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md][163]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text), line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md][164]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md][165]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13
  (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md][166]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  18 (text), line 19 (text), line 22 (text) and line 65 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md][167]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md][168]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md][169]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14
  (text), line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md][170]: selected by [ADR-REPO-FOLDERS][3]: the file cites
  it at line 16 (text) and line 68 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][171]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md][172]: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line
  18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][173]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md][174]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][175]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][176]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][177]: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md][178]: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md][179]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][180]: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md][181]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][182]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14
  (text), line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][183]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  75 (text), line 78 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][184]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][185]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 32 (text), line 35 (text) and line 37 (text).
- [docs/references/pwsh/claude-drawio/minimaps/highlights.ps1.md][186]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51
  (text).
- [docs/references/note-file-kind.md][187]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text), line 34 (text) and line 37
  (text).
- [docs/references/pipelines/cd-apex.yaml.md][188]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][189]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][190]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][191]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][192]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][193]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).

### github-workflows × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track github-workflows ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language
yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.github/workflows/ci-automation.yml][194]: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (body comment) (a passing
  mention only).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/ci-automation.yaml][195]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (text),
  `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (body comment), `pwsh/Catzc.Base.Docs/types/AdrsConfig.cs`
  line 15 (body comment), `pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 41 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml`
  line 5 (text), `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 111 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 123 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 161 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line
  15 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 16 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 26
  (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 29 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 46
  (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 26 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 62 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 66 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 67 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line
  17 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 42 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 89 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 74 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 54 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 55 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 56 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 60 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 63 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 57 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  61 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 64 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 68 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  69 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 73 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 82 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  83 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 87 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 91 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  92 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 15 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 22 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (body comment),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 26 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 39 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 69 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 113 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 127 (text), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs`
  line 9 (body comment), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs` line 12 (body comment),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 5 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 62
  (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 70 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 79 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  88 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 94 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 190 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  200 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 211 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 234 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  247 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 261 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 276 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  289 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 301 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 314 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  316 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 328 (text),
  `pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml` line 7 (text),
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 297 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`
  line 300 (text), `pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Variants/configs/track-types.yml` line 42 (text), `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1`
  line 1 (text), `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 52 (text),
  `pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 71 (text),
  `pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Variants/types/ModulePlace.cs` line 6 (body comment), `pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs`
  line 5 (body comment), `pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 10 (body comment),
  `pwsh/Catzc.Base.Variants/types/PathModule.cs` line 3 (body comment) and `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs`
  line 268 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it
  at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 101 (text), `pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42
  (text), `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2 (text),
  `pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 4 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 58 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1`
  line 53 (text), `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 89 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 23
  (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 31
  (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 47
  (text), `pwsh/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text), `pwsh/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text),
  `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text), `pwsh/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 1216 (text); selected by [ADR-REPO-FOLDERS][3]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 294 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 28 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 34 (body
  comment), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 39 (body comment), `pwsh/Catzc.Base.Docs/configs/capabilities.yml`
  line 67 (body comment), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 77 (body comment),
  `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 43 (text), `pwsh/Catzc.Base.QualityGates/Test-Plans.ps1` line 45 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 47 (body comment),
  `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 89 (body comment) and
  `pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 93 (body comment).

## Keywords

- [world map][197]
- [track][198]
- [file language][199]
- [cell][200]
- [lit cell][201]
- [.claude][202]: a track
- [automation][202]: a track
- [docs][202]: a track
- [github-workflows][202]: a track
- [pipelines][202]: a track
- [csharp][203]: a file language
- [markdown][203]: a file language
- [pipeline-yaml][203]: a file language
- [powershell][203]: a file language
- [yaml][203]: a file language

Terms the cited ADRs define:

- [cell][200], defined by [ADR-DSGN-TRACK#10][204]
- [deployable-unit][205], defined by [ADR-DSGN-TRACK#5][206]
- [domain][207], defined by [ADR-REPO-FOLDERS#5][208]
- [file language][199], defined by [ADR-DSGN-TRACK#6][5]
- [import][209], defined by [ADR-DSGN-TRACK#17][210]
- [landing address][211], defined by [ADR-DSGN-TRACK#17][210]
- [lit cell][201], defined by [ADR-DSGN-TRACK#12][6]
- [place][212], defined by [ADR-DSGN-TRACK#1][4]
- [root file][213], defined by [ADR-DSGN-TRACK#7][214]
- [sorting][215], defined by [ADR-DSGN-TRACK#17][210]
- [stack violation][216], defined by [ADR-DSGN-TRACK#11][217]
- [track][198], defined by [ADR-DSGN-TRACK#1][4]
- [unlisted file][218], defined by [ADR-DSGN-TRACK#8][219]
- [unordered track][220], defined by [ADR-DSGN-TRACK#17][210]
- [value-chain concern][221], defined by [ADR-DSGN-TRACK#15][222]
- [value-chain map][223], defined by [ADR-DSGN-TRACK#16][224]
- [value-chain stack][225], defined by [ADR-DSGN-TRACK#14][226]
- [verification track][227], defined by [ADR-DSGN-TRACK#2][228]
- [world map][197], defined by [ADR-DSGN-TRACK#9][229]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/repository/conventional-folders.md
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../../.claude/CLAUDE.md
[8]: ../../../../.claude/plans/decisions-2026-10-16.md
[9]: ../../../../.claude/plans/decisions-2026-10-18.md
[10]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[11]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[12]: ../../../../.claude/plans/plan-master.md
[13]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[14]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[15]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[16]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[17]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[18]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[19]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[20]: ../../../../.claude/plans/task-file-head-leftovers.md
[21]: ../../../../.claude/plans/task-import-landing-zone.md
[22]: ../../../../pwsh/Catzc.Base.Docs/types/AdrsConfig.cs
[23]: ../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[24]: ../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[25]: ../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[26]: ../../../../pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
[27]: ../../../../pwsh/Catzc.Base.Variants/types/ModulePlace.cs
[28]: ../../../../pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[29]: ../../../../pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[30]: ../../../../pwsh/Catzc.Base.Variants/types/PathModule.cs
[31]: ../../../../pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
[32]: ../../../../pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[33]: ../../../../pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[34]: ../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[35]: ../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[36]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[37]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[38]: ../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[39]: ../../../../pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[40]: ../../../../pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[41]: ../../../../pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
[42]: ../../../../pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
[43]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[44]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[45]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[46]: ../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[47]: ../../../../pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[48]: ../../../../pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[49]: ../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[50]: ../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[51]: ../../../../pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[52]: ../../../../pwsh/Catzc.Base.QualityGates/Test-Plans.ps1
[53]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[54]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[55]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[56]: ../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
[57]: ../../../../pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[58]: ../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[59]: ../../../../pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[60]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[61]: ../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[62]: ../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[63]: ../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[64]: ../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[65]: ../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[66]: ../../../../pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
[67]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[68]: ../../../../pwsh/Catzc.Base.Variants/configs/track-types.yml
[69]: ../../../adr/design/dora-explains.md
[70]: ../../../adr/flow/dora-explains.md
[71]: ../../../adr/glossary.md
[72]: ../../../adr/index.md
[73]: ../../../adr/repository/dora-explains.md
[74]: ../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[75]: ../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[76]: ../../../how-to/automation/sort-an-import.md
[77]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[78]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[79]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[80]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[81]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[82]: ../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[83]: ../../../references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
[84]: ../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[85]: ../../../references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md
[86]: ../../../references/pwsh/catzc-base-docs/types/AdrDomain.cs.md
[87]: ../../../references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md
[88]: ../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[89]: ../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[90]: ../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[91]: ../../../references/pwsh/catzc-base-globs.md
[92]: ../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[93]: ../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[94]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[95]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[96]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[97]: ../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[98]: ../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[99]: ../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[100]: ../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[101]: ../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[102]: ../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[103]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[104]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[105]: ../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[106]: ../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[107]: ../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[108]: ../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[109]: ../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[110]: ../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[111]: ../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[112]: ../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[113]: ../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[114]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[115]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[116]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[117]: ../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[118]: ../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[119]: ../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[120]: ../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[121]: ../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[122]: ../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[123]: ../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[124]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[125]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[126]: ../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[127]: ../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[128]: ../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[129]: ../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[130]: ../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[131]: ../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[132]: ../../../references/pwsh/catzc-base-languages.md
[133]: ../../../references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md
[134]: ../../../references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md
[135]: ../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[136]: ../../../references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[137]: ../../../references/pwsh/catzc-base-languages/types/BashConfig.cs.md
[138]: ../../../references/pwsh/catzc-base-languages/types/FileLanguage.cs.md
[139]: ../../../references/pwsh/catzc-base-languages/types/GoConfig.cs.md
[140]: ../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[141]: ../../../references/pwsh/catzc-base-languages/types/PythonConfig.cs.md
[142]: ../../../references/pwsh/catzc-base-maps.md
[143]: ../../../references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md
[144]: ../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[145]: ../../../references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md
[146]: ../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
[147]: ../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[148]: ../../../references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
[149]: ../../../references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
[150]: ../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[151]: ../../../references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
[152]: ../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[153]: ../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[154]: ../../../references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[155]: ../../../references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[156]: ../../../references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[157]: ../../../references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[158]: ../../../references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[159]: ../../../references/pwsh/catzc-base-maps/types/MapCell.cs.md
[160]: ../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[161]: ../../../references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md
[162]: ../../../references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md
[163]: ../../../references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md
[164]: ../../../references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md
[165]: ../../../references/pwsh/catzc-base-maps/types/WorldMap.cs.md
[166]: ../../../references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
[167]: ../../../references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md
[168]: ../../../references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
[169]: ../../../references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md
[170]: ../../../references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[171]: ../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[172]: ../../../references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md
[173]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[174]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md
[175]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[176]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[177]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[178]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md
[179]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md
[180]: ../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[181]: ../../../references/pwsh/catzc-base-variants/Get-PathModule.ps1.md
[182]: ../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[183]: ../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[184]: ../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[185]: ../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[186]: ../../../references/pwsh/claude-drawio/minimaps/highlights.ps1.md
[187]: ../../../references/note-file-kind.md
[188]: ../../../references/pipelines/cd-apex.yaml.md
[189]: ../../../references/pipelines/cd-flux.yaml.md
[190]: ../../../references/pipelines/cd-nova.yaml.md
[191]: ../../../references/pipelines/cd-shared.yaml.md
[192]: ../../../references/pipelines/ci-automation.yaml.md
[193]: ../../../references/pipelines/ci-infrastructure.yaml.md
[194]: ../../../../.github/workflows/ci-automation.yml
[195]: ../../../../pipelines/ci-automation.yaml
[196]: ../../design/unit-to-pipeline-rule-is-review-only.md
[197]: ../../../adr/glossary.md#world-map
[198]: ../../../adr/glossary.md#track
[199]: ../../../adr/glossary.md#file-language
[200]: ../../../adr/glossary.md#cell
[201]: ../../../adr/glossary.md#lit-cell
[202]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[203]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[204]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[205]: ../../../adr/glossary.md#deployable-unit
[206]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[207]: ../../../adr/glossary.md#domain
[208]: ../../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[209]: ../../../adr/glossary.md#import
[210]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[211]: ../../../adr/glossary.md#landing-address
[212]: ../../../adr/glossary.md#place
[213]: ../../../adr/glossary.md#root-file
[214]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[215]: ../../../adr/glossary.md#sorting
[216]: ../../../adr/glossary.md#stack-violation
[217]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[218]: ../../../adr/glossary.md#unlisted-file
[219]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[220]: ../../../adr/glossary.md#unordered-track
[221]: ../../../adr/glossary.md#value-chain-concern
[222]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[223]: ../../../adr/glossary.md#value-chain-map
[224]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[225]: ../../../adr/glossary.md#value-chain-stack
[226]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[227]: ../../../adr/glossary.md#verification-track
[228]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[229]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9

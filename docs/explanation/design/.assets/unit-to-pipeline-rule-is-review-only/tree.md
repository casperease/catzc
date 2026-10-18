---
catzc:
  immutable:
    with_body_sha: c2977e72cbae
    repo_status: locked
    path: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/tree.md
    source: docs/explanation/design/.assets/unit-to-pipeline-rule-is-review-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the tree minimap

```text
Which files cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS: every file of the world map is a tile, grouped by top-level folder.
190 files lit in 15 groups.
```

![The tree minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to one
pipeline is held by review alone][191], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
every file that cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below,
naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 190 files in 15 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 123 lit files
- Maps (pwsh/Catzc.Base.Maps): 12 lit files
- Variants (pwsh/Catzc.Base.Variants): 9 lit files
- Globs (pwsh/Catzc.Base.Globs): 8 lit files
- .claude: 7 lit files
- QualityGates (pwsh/Catzc.Base.QualityGates): 7 lit files
- Docs (pwsh/Catzc.Base.Docs): 6 lit files
- adr/dsgn (docs/adr/design): 4 lit files
- pipelines: 3 lit files
- Languages (pwsh/Catzc.Base.Languages): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- Git (pwsh/Catzc.Base.Git): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 123 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/apply-environment-approvals.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 4 (text).
- [docs/how-to/automation/sort-an-import.md][5], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4
  (text).
- [docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md][6], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 16 (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][7], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text), line 17 (text), line 23 (text), line 23 (text), line 26 (text), line 26 (text), line 28 (text), line 28
  (text), line 28 (text), line 29 (text), line 30 (text) and line 32 (text).
- [docs/references/note-file-kind.md][8], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text),
  line 34 (text) and line 37 (text).
- [docs/references/pipelines/cd-apex.yaml.md][9], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][11], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][12], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][13], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 13 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][14], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 13 (text).
- [docs/references/pipelines/github-workflows/ci-automation.yml.md][15], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md][16], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 33 (text), line 108 (text) and line 108 (text).
- [docs/references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md][17], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 55 (text) and line 55 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][20], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][22], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md][23], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][25], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 21 (text) and line 22 (text).
- [docs/references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md][26], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md][27], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md][28], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][29], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 32 (text), line 35 (text) and line 47 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 28 (text),
  line 29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md][30], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md][33], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text) and line 27 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][35], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md][36], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 14 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md][37], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text), line 29 (text) and line 30 (text).
- [docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][39], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][43], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md][44], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 17 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][46], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][47], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 105 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text), line 17 (text), line 25 (text), line
  27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md][49], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][50], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md][51], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][53], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][55], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][57], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][58], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][60], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][63], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][65], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][67], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md][68], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 11 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md][69], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md][70], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line 38
  (text), line 47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md][71], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/pwsh/catzc-base-languages.md][72], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 45 (text) and line 75 (text).
- [docs/references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md][73], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md][74], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][75], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][76], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-languages/types/BashConfig.cs.md][77], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]:
  the file cites it at line 22 (text).
- [docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md][78], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md][79], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the
  file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][80], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-languages/types/PythonConfig.cs.md][81], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]:
  the file cites it at line 25 (text).
- [docs/references/pwsh/catzc-base-maps.md][82], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 66
  (text), line 68 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md][83], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (text), line 21 (text), line 23 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][84], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 17 (text) and line 43 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 37
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md][85], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 14 (text), line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md][86], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 15 (text), line 16 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][87], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (text) and line 60 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 54 (text).
- [docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md][88], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 20 (text), line 22 (text), line 25 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md][89], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 18 (text), line 21 (text), line 25 (text), line 28 (text) and line 29 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][90], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 36 (text), line 42 (text), line 44 (text) and line 49 (text).
- [docs/references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md][91], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][92], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][93], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][94], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][95], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][96], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][97], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][98], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md][99], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][100], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 15 (text), line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md][101], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md][102], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md][103], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (text), line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md][104], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md][105], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md][106], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 19 (text), line 22 (text) and line 65 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md][107], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md][108], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md][109], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 14 (text), line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md][110], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 16 (text) and line 68 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md][111], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 97 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md][112], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the
  file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][113], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md][114], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][115], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][116], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][117], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 80 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md][118], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md][119], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][120], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md][121], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][122], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (text), line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][123], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 75 (text), line 78 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][124], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 11 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][125], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 32 (text), line 35 (text) and line 37 (text).
- [docs/references/pwsh/claude-drawio/minimaps/highlights.ps1.md][126], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 51 (text).

### Maps (pwsh/Catzc.Base.Maps, 12 lit files)

The group holds the files of pwsh/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1][127], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 15 (text), line 16 (text), line 26 (text), line 29 (text) and line 46 (text).
- [pwsh/Catzc.Base.Maps/Test-WorldMap.ps1][128], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  26 (text), line 45 (text), line 62 (text), line 66 (text) and line 67 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][129], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 23 (text) and line 42 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][130], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text), line 36 (text) and line 36 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][131], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 89 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][132], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 74 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 70 (text) and line 71 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][133], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 49 (text), line 49 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 60 (text), line 63
  (text), line 80 (text), line 80 (text) and line 80 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][134], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 57 (text), line 61 (text), line 64 (text), line 68 (text), line 69 (text), line 73 (text), line 82 (text), line 83 (text), line
  87 (text), line 91 (text), line 92 (text), line 111 (text), line 111 (text) and line 111 (text).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][135], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 22 (text), line 28 (text), line 45 (text) and line 45 (text).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][136], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 17 (text), line 26 (text), line 31 (text) and line 39 (text).
- [pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][137], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 69 (text), line 113 (text) and line 127 (text).
- [pwsh/Catzc.Base.Maps/types/ValueChainCell.cs][138], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  9 (body comment) and line 12 (body comment) (a passing mention only).

### Variants (pwsh/Catzc.Base.Variants, 9 lit files)

The group holds the files of pwsh/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Variants/configs/track-types.yml][139], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 42 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][140], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (text) and line 52 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][141], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 71 (text).
- [pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][142], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Variants/types/ModulePlace.cs][143], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 6 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs][144], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 5 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs][145], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 10 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/PathModule.cs][146], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  3 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/VariantsConfig.cs][147], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 265 (text).

### Globs (pwsh/Catzc.Base.Globs, 8 lit files)

The group holds the files of pwsh/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][148], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 42 (text).
- [pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][149], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 2 (text) and line 4 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][150], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 58 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][151], in the cell pwsh × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 9 (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][152], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 41 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 53 (text), line 66 (text), line 77 (text) and
  line 89 (text).
- [pwsh/Catzc.Base.Globs/types/GlobPattern.cs][153], in the cell pwsh × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 23 (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [pwsh/Catzc.Base.Globs/types/GlobSet.cs][154], in the cell pwsh × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 54
  (text).
- [pwsh/Catzc.Base.Globs/types/GlobsConfig.cs][155], in the cell pwsh × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 73 (text), line 136 (text), line 140 (text) and line 154 (text).

### .claude (7 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][156], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text); selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 55 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][157], in the cell .claude × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 18 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][158], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 37 (text).
- [.claude/plans/plan-master.md][159], in the cell .claude × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 23
  (text).
- [.claude/plans/plan-promotion-ladder.md][160], in the cell .claude × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 11 (text) and line 38 (text).
- [.claude/plans/task-layers-classification-flip.md][161], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 21 (text).
- [.claude/plans/value-of-plan.md][162], in the cell .claude × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 33
  (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 7 lit files)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/Test-Plans.ps1][163], in the cell pwsh × powershell: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 45 (text).
- [pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml][164], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 7 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][165], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 299 (text) and line 302 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1076 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][166], in the cell pwsh × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][167], in the cell pwsh × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][168], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1][169], in the cell pwsh × powershell: selected by [ADR-REPO-FOLDERS][3]: the file
  cites it at line 47 (text), line 89 (text) and line 93 (text).

### Docs (pwsh/Catzc.Base.Docs, 6 lit files)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][170], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 97 (text) and line 101 (text); selected by [ADR-REPO-FOLDERS][3]:
  the file cites it at line 294 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][171], in the cell pwsh × yaml: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 28
  (text), line 34 (text) and line 39 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][172], in the cell pwsh × yaml: selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 67 (text) and line 77 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][173], in the cell pwsh × yaml: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 43
  (text).
- [pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][174], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 108 (text) and line 108 (text).
- [pwsh/Catzc.Base.Docs/types/AdrsConfig.cs][175], in the cell pwsh × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (body comment) (a passing mention only).

### adr/dsgn (docs/adr/design, 4 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/.assets/sync-point/chain.md][176], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 59 (text), line 62 (text), line 63 (text), line 67 (text), line 70 (text), line 71 (text), line 75 (text), line 78 (text) and line 79
  (text).
- [docs/adr/design/.assets/sync-point/grid.md][177], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  52 (text), line 53 (text), line 53 (text), line 61 (text), line 62 (text), line 62 (text), line 72 (text), line 73 (text), line 73 (text),
  line 81 (text), line 82 (text) and line 82 (text).
- [docs/adr/design/dora-explains.md][178], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11
  (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### pipelines (3 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-shared.yaml][179], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 45
  (body comment) (a passing mention only).
- [pipelines/ci-automation.yaml][180], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text),
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
- [pipelines/extends/cd-customer.yaml][181], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 21 (body comment) (a passing mention only).

### Languages (pwsh/Catzc.Base.Languages, 3 lit files)

The group holds the files of pwsh/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Languages/configs/glossary.yml][182], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  5 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][183], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 111 (text), line 123 (text) and line 161 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][184], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 1 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][185], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161
  (text), line 178 (text), line 210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329
  (text), line 332 (text), line 355 (text), line 395 (text), line 409 (text), line 418 (text), line 432 (text), line 445 (text), line 479
  (text) and line 491 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 1203 (text).
- [docs/adr/index.md][186], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 129 (text) and line 133 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at
  line 318 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][187], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11
  (text) and line 92 (text).
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/conventional-folders.md][3], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][188], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 11
  (text).

### Git (pwsh/Catzc.Base.Git, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][189], in the cell pwsh × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 1 (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][190], in the cell pwsh × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 5 (text), line 62 (text), line 70 (text), line 79 (text), line 88 (text), line 94 (text), line 190 (text), line 200 (text), line 211
  (text), line 234 (text), line 247 (text), line 261 (text), line 276 (text), line 289 (text), line 301 (text), line 314 (text), line 316
  (text) and line 328 (text).

## Keywords

- [world map][192]
- [track][193]
- [file language][194]
- [cell][195]
- [lit cell][196]
- [.claude][197]: a track
- [docs][197]: a track
- [pipelines][197]: a track
- [pwsh][197]: a track
- [csharp][198]: a file language
- [markdown][198]: a file language
- [pipeline-yaml][198]: a file language
- [powershell][198]: a file language
- [yaml][198]: a file language

[1]: ../../../../adr/design/tracks.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../adr/repository/conventional-folders.md
[4]: ../../../../how-to/automation/apply-environment-approvals.md
[5]: ../../../../how-to/automation/sort-an-import.md
[6]: ../../../../how-to/pwsh/manual-test-plan/pipelines-and-globs.md
[7]: ../../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[8]: ../../../../references/note-file-kind.md
[9]: ../../../../references/pipelines/cd-apex.yaml.md
[10]: ../../../../references/pipelines/cd-flux.yaml.md
[11]: ../../../../references/pipelines/cd-nova.yaml.md
[12]: ../../../../references/pipelines/cd-shared.yaml.md
[13]: ../../../../references/pipelines/ci-automation.yaml.md
[14]: ../../../../references/pipelines/ci-infrastructure.yaml.md
[15]: ../../../../references/pipelines/github-workflows/ci-automation.yml.md
[16]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.md
[17]: ../../../../references/pwsh/.assets/protected-module-skip-by-hash/diagram.drawio.verify.md
[18]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[19]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[20]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[21]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[22]: ../../../../references/pwsh/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[23]: ../../../../references/pwsh/catzc-azure-devops/Sync-AdoEnvironmentApprovals.ps1.md
[24]: ../../../../references/pwsh/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
[25]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[26]: ../../../../references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md
[27]: ../../../../references/pwsh/catzc-base-docs/types/AdrDomain.cs.md
[28]: ../../../../references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md
[29]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[30]: ../../../../references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[31]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[32]: ../../../../references/pwsh/catzc-base-globs.md
[33]: ../../../../references/pwsh/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[34]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSet.ps1.md
[35]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[36]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md
[37]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetHash.ps1.md
[38]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[39]: ../../../../references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[40]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[41]: ../../../../references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md
[42]: ../../../../references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[43]: ../../../../references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[44]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
[45]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[46]: ../../../../references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[47]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[48]: ../../../../references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md
[49]: ../../../../references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[50]: ../../../../references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[51]: ../../../../references/pwsh/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[52]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[53]: ../../../../references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[54]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[55]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[56]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[57]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[58]: ../../../../references/pwsh/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[59]: ../../../../references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[60]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[61]: ../../../../references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[62]: ../../../../references/pwsh/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[63]: ../../../../references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[64]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[65]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[66]: ../../../../references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[67]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[68]: ../../../../references/pwsh/catzc-base-globs/types/DurableHash.cs.md
[69]: ../../../../references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
[70]: ../../../../references/pwsh/catzc-base-globs/types/GlobSet.cs.md
[71]: ../../../../references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
[72]: ../../../../references/pwsh/catzc-base-languages.md
[73]: ../../../../references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md
[74]: ../../../../references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md
[75]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[76]: ../../../../references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[77]: ../../../../references/pwsh/catzc-base-languages/types/BashConfig.cs.md
[78]: ../../../../references/pwsh/catzc-base-languages/types/FileLanguage.cs.md
[79]: ../../../../references/pwsh/catzc-base-languages/types/GoConfig.cs.md
[80]: ../../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[81]: ../../../../references/pwsh/catzc-base-languages/types/PythonConfig.cs.md
[82]: ../../../../references/pwsh/catzc-base-maps.md
[83]: ../../../../references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md
[84]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[85]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md
[86]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
[87]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[88]: ../../../../references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
[89]: ../../../../references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
[90]: ../../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[91]: ../../../../references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
[92]: ../../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[93]: ../../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[94]: ../../../../references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[95]: ../../../../references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[96]: ../../../../references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[97]: ../../../../references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[98]: ../../../../references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[99]: ../../../../references/pwsh/catzc-base-maps/types/MapCell.cs.md
[100]: ../../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[101]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md
[102]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md
[103]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md
[104]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md
[105]: ../../../../references/pwsh/catzc-base-maps/types/WorldMap.cs.md
[106]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
[107]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md
[108]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
[109]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md
[110]: ../../../../references/pwsh/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[111]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Automation.ps1.md
[112]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md
[113]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[114]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md
[115]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[116]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[117]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[118]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md
[119]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md
[120]: ../../../../references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[121]: ../../../../references/pwsh/catzc-base-variants/Get-PathModule.ps1.md
[122]: ../../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[123]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[124]: ../../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[125]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[126]: ../../../../references/pwsh/claude-drawio/minimaps/highlights.ps1.md
[127]: ../../../../../pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
[128]: ../../../../../pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
[129]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[130]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[131]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[132]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[133]: ../../../../../pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[134]: ../../../../../pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[135]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[136]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[137]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[138]: ../../../../../pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
[139]: ../../../../../pwsh/Catzc.Base.Variants/configs/track-types.yml
[140]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[141]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[142]: ../../../../../pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[143]: ../../../../../pwsh/Catzc.Base.Variants/types/ModulePlace.cs
[144]: ../../../../../pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[145]: ../../../../../pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[146]: ../../../../../pwsh/Catzc.Base.Variants/types/PathModule.cs
[147]: ../../../../../pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
[148]: ../../../../../pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[149]: ../../../../../pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[150]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[151]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[152]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[153]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobPattern.cs
[154]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobSet.cs
[155]: ../../../../../pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
[156]: ../../../../../.claude/CLAUDE.md
[157]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[158]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[159]: ../../../../../.claude/plans/plan-master.md
[160]: ../../../../../.claude/plans/plan-promotion-ladder.md
[161]: ../../../../../.claude/plans/task-layers-classification-flip.md
[162]: ../../../../../.claude/plans/value-of-plan.md
[163]: ../../../../../pwsh/Catzc.Base.QualityGates/Test-Plans.ps1
[164]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
[165]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[166]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[167]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[168]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[169]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
[170]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[171]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[172]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[173]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[174]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[175]: ../../../../../pwsh/Catzc.Base.Docs/types/AdrsConfig.cs
[176]: ../../../../adr/design/.assets/sync-point/chain.md
[177]: ../../../../adr/design/.assets/sync-point/grid.md
[178]: ../../../../adr/design/dora-explains.md
[179]: ../../../../../pipelines/cd-shared.yaml
[180]: ../../../../../pipelines/ci-automation.yaml
[181]: ../../../../../pipelines/extends/cd-customer.yaml
[182]: ../../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[183]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[184]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[185]: ../../../../adr/glossary.md
[186]: ../../../../adr/index.md
[187]: ../../../../adr/flow/dora-explains.md
[188]: ../../../../adr/repository/dora-explains.md
[189]: ../../../../../pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[190]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[191]: ../../unit-to-pipeline-rule-is-review-only.md
[192]: ../../../../adr/glossary.md#world-map
[193]: ../../../../adr/glossary.md#track
[194]: ../../../../adr/glossary.md#file-language
[195]: ../../../../adr/glossary.md#cell
[196]: ../../../../adr/glossary.md#lit-cell
[197]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[198]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

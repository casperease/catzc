---
catzc:
  immutable:
    with_body_sha: "8595f7a23e31"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
    source: docs/explanation/.assets/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the tree minimap

```text
Which files cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS: every file of the world map is a tile, grouped by top-level folder.
192 files lit in 16 groups.
```

![The tree minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit to one
pipeline is held by review alone][193], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
every file that cites those codes, grouped by folder, so it shows which files carry the decision. Each lit group has its reason below,
naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 192 files in 16 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 120 lit files
- .claude: 15 lit files
- Maps (automation/Catzc.Base.Maps): 12 lit files
- Variants (automation/Catzc.Base.Variants): 9 lit files
- Globs (automation/Catzc.Base.Globs): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 7 lit files
- Docs (automation/Catzc.Base.Docs): 6 lit files
- Languages (automation/Catzc.Base.Languages): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/flow (docs/adr/flow): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- .github: 1 lit file
- Git (automation/Catzc.Base.Git): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 120 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][4], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 16 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][5], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 23 (text), line 23 (text), line 26 (text), line 26 (text), line 28 (text), line 28 (text), line 28
  (text), line 29 (text), line 30 (text) and line 32 (text).
- [docs/how-to/automation/sort-an-import.md][6], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4
  (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][7], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 55 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md][8], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md][9], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text) and line 74 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md][10], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md][11], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md][12], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md][13], in the cell docs × markdown: selected
  by [ADR-REPO-FOLDERS][3]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][14], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 21 (text) and line 22 (text).
- [docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md][15], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md][16], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text) and line 17 (text).
- [docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md][17], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][18], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 32 (text), line 35 (text) and line 47 (text).
- [docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 27 (text).
- [docs/references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md][22], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text) and line 27 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSet.ps1.md][23], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md][25], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 14 (text) and line 16 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md][26], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 20 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetTrigger.ps1.md][27], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text), line 29 (text) and line 30 (text).
- [docs/references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md][28], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][29], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 58 (text), line 61 (text) and line 109 (text).
- [docs/references/automation/catzc-base-globs/Get-TrackedFile.ps1.md][30], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md][31], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md][32], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 24 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md][33], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text) and line 20 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md][34], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18 (text), line 56 (text) and line 66 (text).
- [docs/references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md][35], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/configs/globs.yml.md][36], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 105 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text), line 17 (text), line 25 (text),
  line 27 (text), line 41 (text), line 71 (text) and line 85 (text).
- [docs/references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md][37], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md][38], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md][39], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 16 (text).
- [docs/references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md][40], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][41], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 33 (text) and line 108 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md][43], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md][46], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md][47], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md][48], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md][49], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md][50], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md][51], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md][53], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md][54], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md][55], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md][56], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14 (text), line 16 (text) and line 25 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][57], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 19 (text).
- [docs/references/automation/catzc-base-globs/types/DurableHash.cs.md][58], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (text) and line 17 (text).
- [docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text), line 18 (text) and line 19 (text).
- [docs/references/automation/catzc-base-globs/types/GlobSet.cs.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 13 (text), line 15 (text), line 16 (text), line 22 (text), line 25 (text), line 27 (text), line 30 (text), line
  38 (text), line 47 (text), line 65 (text), line 82 (text), line 92 (text), line 116 (text) and line 124 (text).
- [docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 13 (text), line 17 (text), line 20 (text) and line 39 (text).
- [docs/references/automation/catzc-base-languages.md][62], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites
  it at line 45 (text) and line 75 (text).
- [docs/references/automation/catzc-base-languages/Get-FileLanguage.ps1.md][63], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-languages/Get-PathFileType.ps1.md][64], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][65], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][66], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-languages/types/BashConfig.cs.md][67], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text).
- [docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md][68], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][69], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][70], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-languages/types/PythonConfig.cs.md][71], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 25 (text).
- [docs/references/automation/catzc-base-maps.md][72], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 66 (text), line 68 (text) and line 80 (text).
- [docs/references/automation/catzc-base-maps/Export-WorldMapPdf.ps1.md][73], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (text), line 21 (text), line 23 (text) and line 60 (text).
- [docs/references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md][74], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-maps/Get-ValueChainMap.ps1.md][75], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 14 (text), line 16 (text) and line 17 (text).
- [docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md][76], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 16 (text) and line 26 (text).
- [docs/references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md][77], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text) and line 60 (text).
- [docs/references/automation/catzc-base-maps/Test-ValueChainMap.ps1.md][78], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 20 (text), line 22 (text), line 25 (text) and line 28 (text).
- [docs/references/automation/catzc-base-maps/Test-WorldMap.ps1.md][79], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 18 (text), line 21 (text), line 25 (text), line 28 (text) and line 29 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][80], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 36 (text), line 42 (text), line 44 (text) and line 49 (text).
- [docs/references/automation/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md][81], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text) and line 18 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][82], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][83], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][84], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][85], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][86], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][87], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][88], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-maps/types/MapCell.cs.md][89], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][90], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 16 (text) and line 20 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md][91], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md][92], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 13 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainMap.cs.md][93], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 12 (text), line 13 (text) and line 15 (text).
- [docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md][94], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text) and line 14 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMap.cs.md][95], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 13 (text) and line 14 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md][96], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text), line 19 (text), line 22 (text) and line 65 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md][97], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text) and line 14 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md][98], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md][99], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 14 (text), line 15 (text) and line 16 (text).
- [docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md][100], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 16 (text) and line 68 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md][101], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 97 (text).
- [docs/references/automation/catzc-base-qualitygates/Test-Plans.ps1.md][102], in the cell docs × markdown: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 18 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][103], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md][104], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md][105], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][106], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][107], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 80 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md][108], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md][109], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md][110], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-base-variants/Get-PathModule.ps1.md][111], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-variants/Get-Track.ps1.md][112], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 14 (text), line 16 (text) and line 19 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][113], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 75 (text), line 78 (text) and line 80 (text).
- [docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md][114], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text) and line 13 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][115], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text), line 35 (text) and line 37 (text).
- [docs/references/automation/claude-drawio/minimaps/highlights.ps1.md][116], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 51 (text).
- [docs/references/note-file-kind.md][117], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 34 (text) and line 37 (text).
- [docs/references/pipelines/cd-apex.yaml.md][118], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 31 (text).
- [docs/references/pipelines/cd-flux.yaml.md][119], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-nova.yaml.md][120], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 30 (text).
- [docs/references/pipelines/cd-shared.yaml.md][121], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 22 (text).
- [docs/references/pipelines/ci-automation.yaml.md][122], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 13 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 12 (text).
- [docs/references/pipelines/ci-infrastructure.yaml.md][123], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 13 (text).

### .claude (15 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][124], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text).
- [.claude/plans/decisions-2026-10-16.md][125], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  19 (text), line 26 (text), line 45 (text), line 53 (text), line 116 (text), line 117 (text), line 121 (text), line 121 (text), line 123
  (text), line 129 (text), line 131 (text) and line 176 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22 (text), line
  193 (text) and line 193 (text).
- [.claude/plans/decisions-2026-10-18.md][126], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  16 (text), line 33 (text) and line 33 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][127], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 51 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][128], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 79 (text), line 80 (text), line 193 (text), line 437 (text), line 478 (text), line 503 (text), line 583 (text), line 785
  (text), line 812 (text), line 916 (text) and line 921 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 917 (text).
- [.claude/plans/plan-master.md][129], in the cell .claude × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 22
  (text) and line 40 (text).
- [.claude/plans/plan-module-kinds-tracks.md][130], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 42 (text), line 46 (text), line 72 (text), line 78 (text), line 119 (text), line 120 (text), line 141 (text), line 142 (text), line
  163 (text), line 183 (text), line 231 (text), line 344 (text), line 353 (text), line 501 (text), line 515 (text), line 546 (text), line
  551 (text), line 597 (text), line 613 (text), line 613 (text), line 639 (text), line 641 (text), line 643 (text), line 653 (text), line
  661 (text), line 662 (text), line 672 (text), line 691 (text), line 801 (text), line 813 (text), line 818 (text), line 820 (text), line
  849 (text), line 856 (text), line 878 (text), line 917 (text), line 936 (text), line 945 (text), line 986 (text) and line 1041 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][131], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 30 (text), line 85 (text) and line 211 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 75 (text) and line
  132 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][132], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 17 (text), line 28 (text) and line 53 (text).
- [.claude/plans/prompt-k8s-kinds-2-implement.md][133], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 34 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][134], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 17 (text), line 29 (text), line 30 (text), line 69 (text) and line 78 (text).
- [.claude/plans/prompt-module-model-2-implement.md][135], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 9 (text), line 27 (text) and line 39 (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][136], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 28 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 79 (text) and line 90 (text).
- [.claude/plans/task-file-head-leftovers.md][137], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 27 (text) and line 70 (text).
- [.claude/plans/task-import-landing-zone.md][138], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 35 (text) and line 42 (text).

### Maps (automation/Catzc.Base.Maps, 12 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][139], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 15 (text), line 16 (text), line 26 (text), line 29 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][140], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 26 (text), line 45 (text), line 62 (text), line 66 (text) and line 67 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][141], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 23 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][142], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 17 (text), line 36 (text) and line 36 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][143], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 89 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][144], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][145], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 49 (text), line 49 (body comment), line 53 (text), line 54 (text), line 55 (text), line 56
  (text), line 60 (text), line 63 (text), line 80 (text), line 80 (body comment) and line 80 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][146], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 57 (text), line 61 (text), line 64 (text), line 68 (text), line 69 (text), line 73 (text), line 82 (text), line 83
  (text), line 87 (text), line 91 (text), line 92 (text), line 111 (text), line 111 (body comment) and line 111 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][147], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 22 (text), line 28 (text), line 45 (text) and line 45 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][148], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line 26 (text), line 31 (text) and line 39 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][149], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 69 (text), line 113 (text) and line 127 (text).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][150], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (body comment) and line 12 (body comment) (a passing mention only).

### Variants (automation/Catzc.Base.Variants, 9 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/track-types.yml][151], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 42 (text).
- [automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][152], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text) and line 52 (text).
- [automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][153], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 71 (text).
- [automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][154], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.Variants/types/ModulePlace.cs][155], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs][156], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 5 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs][157], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 10 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/PathModule.cs][158], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][159], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 268 (text).

### Globs (automation/Catzc.Base.Globs, 8 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][160], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 42 (text).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][161], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (text) and line 4 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][162], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 58 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][163], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 9 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][164], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 41 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 53 (text), line 66
  (text), line 77 (text) and line 89 (text).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][165], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 23 (text), line 27 (text), line 31 (text), line 43 (text), line 47 (text) and line 56 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][166], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 54 (text).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][167], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 73 (text), line 136 (text), line 140 (text) and line 154 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 7 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Plans.ps1][168], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][3]: the file
  cites it at line 45 (text).
- [automation/Catzc.Base.QualityGates/configs/source-conventions.yml][169], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 7 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][170], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 297 (text) and line 300 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1216 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][171], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][172], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][173], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1][174], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][3]: the file cites it at line 47 (body comment), line 89 (body comment) and line 93 (body comment) (a passing mention
  only).

### Docs (automation/Catzc.Base.Docs, 6 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][175], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 74 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 101 (text); selected by [ADR-REPO-FOLDERS][3]: the file
  cites it at line 294 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][176], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][3]: the file cites it
  at line 28 (body comment), line 34 (body comment) and line 39 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][177], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][3]: the file
  cites it at line 67 (body comment) and line 77 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][178], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][3]: the file cites
  it at line 43 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][179], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 108 (text) and line 108 (body comment).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][180], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 15 (body comment) (a passing mention only).

### Languages (automation/Catzc.Base.Languages, 3 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/configs/glossary.yml][181], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 5 (text).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][182], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 111 (text), line 123 (text) and line 161 (text).
- [automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][183], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][184], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161
  (text), line 178 (text), line 210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329
  (text), line 331 (text), line 346 (text), line 386 (text), line 400 (text), line 409 (text), line 423 (text), line 436 (text), line 470
  (text) and line 482 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 1162 (text).
- [docs/adr/index.md][185], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 133 (text); selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 318 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][186], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11
  (text).
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][187], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 92
  (text).
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the ADR's own file.

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/conventional-folders.md][3], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the ADR's own file.
- [docs/adr/repository/dora-explains.md][188], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][3]: the file cites it at line 11
  (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][189], in the cell github-workflows × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 4 (body comment) (a passing mention only).

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][190], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][191], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 5 (text), line 62 (text), line 70 (text), line 79 (text), line 88 (text), line 94 (text), line 190 (text), line 200
  (text), line 211 (text), line 234 (text), line 247 (text), line 261 (text), line 276 (text), line 289 (text), line 301 (text), line 314
  (text), line 316 (text) and line 328 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][192], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 74 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (text),
  `automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (body comment), `automation/Catzc.Base.Docs/types/AdrsConfig.cs`
  line 15 (body comment), `automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 1 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 41 (text), `automation/Catzc.Base.Languages/configs/glossary.yml`
  line 5 (text), `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 111 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 123 (text),
  `automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 161 (text),
  `automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 1 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line
  15 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 16 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 26
  (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 29 (text), `automation/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 46
  (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 26 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 45 (text),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 62 (text), `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 66 (text),
  `automation/Catzc.Base.Maps/Test-WorldMap.ps1` line 67 (text), `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line
  17 (text), `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 23 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 17 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text),
  `automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (body comment),
  `automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 89 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 74 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 53 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 54 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 55 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 60 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 63 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 57 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  61 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 64 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 68 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  69 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 73 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 82 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  83 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 91 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  92 (text), `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (text),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (body comment),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 15 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 22 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (body comment),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 17 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 31 (text),
  `automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 39 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 69 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 113 (text),
  `automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 127 (text), `automation/Catzc.Base.Maps/types/ValueChainCell.cs`
  line 9 (body comment), `automation/Catzc.Base.Maps/types/ValueChainCell.cs` line 12 (body comment),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 5 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 62
  (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 70 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 79 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  88 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 190 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  200 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 211 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 234 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  247 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 261 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 276 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  289 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 301 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 314 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  316 (text), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 328 (text),
  `automation/Catzc.Base.QualityGates/configs/source-conventions.yml` line 7 (text),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 297 (text), `automation/Catzc.Base.QualityGates/configs/terminology.yml`
  line 300 (text), `automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 1 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 1 (text),
  `automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 1 (text),
  `automation/Catzc.Base.Variants/configs/track-types.yml` line 42 (text), `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1`
  line 1 (text), `automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 52 (text),
  `automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 1 (text),
  `automation/Catzc.Base.Variants/types/ModulePlace.cs` line 6 (body comment), `automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs`
  line 5 (body comment), `automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 10 (body comment),
  `automation/Catzc.Base.Variants/types/PathModule.cs` line 3 (body comment) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs`
  line 268 (text); selected by [ADR-FLOW-CD-GLOBS][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it
  at `automation/Catzc.Base.Docs/configs/adrs.yml` line 101 (text), `automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1` line 42
  (text), `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 2 (text),
  `automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1` line 4 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1` line 58 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1` line 9 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1`
  line 53 (text), `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 77 (text),
  `automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 89 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 23
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 27 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 31
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 43 (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 47
  (text), `automation/Catzc.Base.Globs/types/GlobPattern.cs` line 56 (text), `automation/Catzc.Base.Globs/types/GlobSet.cs` line 54 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 73 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 136 (text),
  `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 140 (text), `automation/Catzc.Base.Globs/types/GlobsConfig.cs` line 154 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 1216 (text); selected by [ADR-REPO-FOLDERS][3]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 294 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 28 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 34 (body
  comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 39 (body comment), `automation/Catzc.Base.Docs/configs/capabilities.yml`
  line 67 (body comment), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 77 (body comment),
  `automation/Catzc.Base.Docs/configs/glossary.yml` line 43 (text), `automation/Catzc.Base.QualityGates/Test-Plans.ps1` line 45 (text),
  `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 47 (body comment),
  `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 89 (body comment) and
  `automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1` line 93 (body comment).

## Keywords

- [world map][194]
- [track][195]
- [file language][196]
- [cell][197]
- [lit cell][198]
- [.claude][199]: a track
- [automation][199]: a track
- [docs][199]: a track
- [github-workflows][199]: a track
- [pipelines][199]: a track
- [csharp][200]: a file language
- [markdown][200]: a file language
- [pipeline-yaml][200]: a file language
- [powershell][200]: a file language
- [yaml][200]: a file language

Terms the cited ADRs define:

- [cell][197], defined by [ADR-DSGN-TRACK#10][201]
- [deployable-unit][202], defined by [ADR-DSGN-TRACK#5][203]
- [domain][204], defined by [ADR-REPO-FOLDERS#5][205]
- [file language][196], defined by [ADR-DSGN-TRACK#6][206]
- [import][207], defined by [ADR-DSGN-TRACK#17][208]
- [landing address][209], defined by [ADR-DSGN-TRACK#17][208]
- [lit cell][198], defined by [ADR-DSGN-TRACK#12][210]
- [place][211], defined by [ADR-DSGN-TRACK#1][212]
- [root file][213], defined by [ADR-DSGN-TRACK#7][214]
- [sorting][215], defined by [ADR-DSGN-TRACK#17][208]
- [stack violation][216], defined by [ADR-DSGN-TRACK#11][217]
- [track][195], defined by [ADR-DSGN-TRACK#1][212]
- [unlisted file][218], defined by [ADR-DSGN-TRACK#8][219]
- [unordered track][220], defined by [ADR-DSGN-TRACK#17][208]
- [value-chain concern][221], defined by [ADR-DSGN-TRACK#15][222]
- [value-chain map][223], defined by [ADR-DSGN-TRACK#16][224]
- [value-chain stack][225], defined by [ADR-DSGN-TRACK#14][226]
- [verification track][227], defined by [ADR-DSGN-TRACK#2][228]
- [world map][194], defined by [ADR-DSGN-TRACK#9][229]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/repository/conventional-folders.md
[4]: ../../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[5]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[6]: ../../../how-to/automation/sort-an-import.md
[7]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[8]: ../../../references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
[9]: ../../../references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
[10]: ../../../references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
[11]: ../../../references/automation/catzc-azure-devops-buildvalidation/configs/build-validation.yml.md
[12]: ../../../references/automation/catzc-azure-devops-buildvalidation/private/Get-BuildValidationPathFilter.ps1.md
[13]: ../../../references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
[14]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[15]: ../../../references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
[16]: ../../../references/automation/catzc-base-docs/types/AdrDomain.cs.md
[17]: ../../../references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
[18]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[19]: ../../../references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
[20]: ../../../references/automation/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[21]: ../../../references/automation/catzc-base-globs.md
[22]: ../../../references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md
[23]: ../../../references/automation/catzc-base-globs/Get-GlobSet.ps1.md
[24]: ../../../references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[25]: ../../../references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md
[26]: ../../../references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md
[27]: ../../../references/automation/catzc-base-globs/Get-GlobSetTrigger.ps1.md
[28]: ../../../references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
[29]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[30]: ../../../references/automation/catzc-base-globs/Get-TrackedFile.ps1.md
[31]: ../../../references/automation/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
[32]: ../../../references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
[33]: ../../../references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md
[34]: ../../../references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
[35]: ../../../references/automation/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
[36]: ../../../references/automation/catzc-base-globs/configs/globs.yml.md
[37]: ../../../references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md
[38]: ../../../references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md
[39]: ../../../references/automation/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
[40]: ../../../references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md
[41]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[42]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
[43]: ../../../references/automation/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
[44]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
[45]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
[46]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetMember.Tests.ps1.md
[47]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
[48]: ../../../references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
[49]: ../../../references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
[50]: ../../../references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
[51]: ../../../references/automation/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
[52]: ../../../references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
[53]: ../../../references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
[54]: ../../../references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
[55]: ../../../references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
[56]: ../../../references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
[57]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[58]: ../../../references/automation/catzc-base-globs/types/DurableHash.cs.md
[59]: ../../../references/automation/catzc-base-globs/types/GlobPattern.cs.md
[60]: ../../../references/automation/catzc-base-globs/types/GlobSet.cs.md
[61]: ../../../references/automation/catzc-base-globs/types/GlobsConfig.cs.md
[62]: ../../../references/automation/catzc-base-languages.md
[63]: ../../../references/automation/catzc-base-languages/Get-FileLanguage.ps1.md
[64]: ../../../references/automation/catzc-base-languages/Get-PathFileType.ps1.md
[65]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[66]: ../../../references/automation/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[67]: ../../../references/automation/catzc-base-languages/types/BashConfig.cs.md
[68]: ../../../references/automation/catzc-base-languages/types/FileLanguage.cs.md
[69]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[70]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[71]: ../../../references/automation/catzc-base-languages/types/PythonConfig.cs.md
[72]: ../../../references/automation/catzc-base-maps.md
[73]: ../../../references/automation/catzc-base-maps/Export-WorldMapPdf.ps1.md
[74]: ../../../references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[75]: ../../../references/automation/catzc-base-maps/Get-ValueChainMap.ps1.md
[76]: ../../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md
[77]: ../../../references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[78]: ../../../references/automation/catzc-base-maps/Test-ValueChainMap.ps1.md
[79]: ../../../references/automation/catzc-base-maps/Test-WorldMap.ps1.md
[80]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[81]: ../../../references/automation/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
[82]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[83]: ../../../references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[84]: ../../../references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[85]: ../../../references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[86]: ../../../references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[87]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[88]: ../../../references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[89]: ../../../references/automation/catzc-base-maps/types/MapCell.cs.md
[90]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[91]: ../../../references/automation/catzc-base-maps/types/ValueChainCell.cs.md
[92]: ../../../references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
[93]: ../../../references/automation/catzc-base-maps/types/ValueChainMap.cs.md
[94]: ../../../references/automation/catzc-base-maps/types/ValueChainReason.cs.md
[95]: ../../../references/automation/catzc-base-maps/types/WorldMap.cs.md
[96]: ../../../references/automation/catzc-base-maps/types/WorldMapBuilder.cs.md
[97]: ../../../references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
[98]: ../../../references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
[99]: ../../../references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
[100]: ../../../references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
[101]: ../../../references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
[102]: ../../../references/automation/catzc-base-qualitygates/Test-Plans.ps1.md
[103]: ../../../references/automation/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[104]: ../../../references/automation/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md
[105]: ../../../references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
[106]: ../../../references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[107]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[108]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md
[109]: ../../../references/automation/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md
[110]: ../../../references/automation/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md
[111]: ../../../references/automation/catzc-base-variants/Get-PathModule.ps1.md
[112]: ../../../references/automation/catzc-base-variants/Get-Track.ps1.md
[113]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[114]: ../../../references/automation/catzc-base-variants/types/VariantTrack.cs.md
[115]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[116]: ../../../references/automation/claude-drawio/minimaps/highlights.ps1.md
[117]: ../../../references/note-file-kind.md
[118]: ../../../references/pipelines/cd-apex.yaml.md
[119]: ../../../references/pipelines/cd-flux.yaml.md
[120]: ../../../references/pipelines/cd-nova.yaml.md
[121]: ../../../references/pipelines/cd-shared.yaml.md
[122]: ../../../references/pipelines/ci-automation.yaml.md
[123]: ../../../references/pipelines/ci-infrastructure.yaml.md
[124]: ../../../../.claude/CLAUDE.md
[125]: ../../../../.claude/plans/decisions-2026-10-16.md
[126]: ../../../../.claude/plans/decisions-2026-10-18.md
[127]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[128]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[129]: ../../../../.claude/plans/plan-master.md
[130]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[131]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[132]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[133]: ../../../../.claude/plans/prompt-k8s-kinds-2-implement.md
[134]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[135]: ../../../../.claude/plans/prompt-module-model-2-implement.md
[136]: ../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[137]: ../../../../.claude/plans/task-file-head-leftovers.md
[138]: ../../../../.claude/plans/task-import-landing-zone.md
[139]: ../../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[140]: ../../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[141]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[142]: ../../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[143]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[144]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[145]: ../../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[146]: ../../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[147]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[148]: ../../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[149]: ../../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[150]: ../../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[151]: ../../../../automation/Catzc.Base.Variants/configs/track-types.yml
[152]: ../../../../automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[153]: ../../../../automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[154]: ../../../../automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[155]: ../../../../automation/Catzc.Base.Variants/types/ModulePlace.cs
[156]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[157]: ../../../../automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[158]: ../../../../automation/Catzc.Base.Variants/types/PathModule.cs
[159]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[160]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[161]: ../../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[162]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[163]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[164]: ../../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[165]: ../../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[166]: ../../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[167]: ../../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[168]: ../../../../automation/Catzc.Base.QualityGates/Test-Plans.ps1
[169]: ../../../../automation/Catzc.Base.QualityGates/configs/source-conventions.yml
[170]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[171]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[172]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[173]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[174]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
[175]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[176]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[177]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[178]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[179]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[180]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[181]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[182]: ../../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[183]: ../../../../automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[184]: ../../../adr/glossary.md
[185]: ../../../adr/index.md
[186]: ../../../adr/design/dora-explains.md
[187]: ../../../adr/flow/dora-explains.md
[188]: ../../../adr/repository/dora-explains.md
[189]: ../../../../.github/workflows/ci-automation.yml
[190]: ../../../../automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[191]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[192]: ../../../../pipelines/ci-automation.yaml
[193]: ../../design/unit-to-pipeline-rule-is-review-only.md
[194]: ../../../adr/glossary.md#world-map
[195]: ../../../adr/glossary.md#track
[196]: ../../../adr/glossary.md#file-language
[197]: ../../../adr/glossary.md#cell
[198]: ../../../adr/glossary.md#lit-cell
[199]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[200]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[201]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[202]: ../../../adr/glossary.md#deployable-unit
[203]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[204]: ../../../adr/glossary.md#domain
[205]: ../../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[206]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[207]: ../../../adr/glossary.md#import
[208]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[209]: ../../../adr/glossary.md#landing-address
[210]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[211]: ../../../adr/glossary.md#place
[212]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
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

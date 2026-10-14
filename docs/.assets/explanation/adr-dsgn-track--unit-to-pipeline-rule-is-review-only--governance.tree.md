# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md

`Tree minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Tree minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.png)

The tree minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD][2], [ADR-FLOW-CD-GLOBS][3] and [ADR-REPO-FOLDERS][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 205 files in 17 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 60 lit files
- Globs (automation/Catzc.Base.Globs): 38 lit files
- Maps (automation/Catzc.Base.Maps): 29 lit files
- adr/repo (docs/adr/repository): 15 lit files
- Docs (automation/Catzc.Base.Docs): 9 lit files
- Languages (automation/Catzc.Base.Languages): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 6 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- .claude: 3 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .github: 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file

## Why each group is lit

### docs (60 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][5], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 66 (text) and line 76 (text); selected by [ADR-REPO-FOLDERS][4]:
  the file cites it at line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][6], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][9], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][10], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md][11], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md][12], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 64 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][14], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 60 (text) and line 68 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 60 (text) and line 68 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md][15], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][16], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][17], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][18], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][19], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][20], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][21], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][22], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][23], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][24], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][25], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][26], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][27], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][28], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][29], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][30], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][31], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][32], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 52 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][33], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 55 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 51 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][35], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][36], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][37], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 59 (text).
- [docs/explanation/design/one-unit-one-pipeline.md][39], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 14 (text), line 38 (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][40], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 49 (text) and line 67 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at
  line 38 (text), line 57 (text) and line 71 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][42], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text);
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 59 (text) and line 59 (text); selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][43], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][44], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][45], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][46], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][47], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][48], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][49], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 17 (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][50], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57
  (text), line 58 (text), line 59 (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][51], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][52], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][53], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][54], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 18 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][55], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 16 (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][56], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 13 (text), line 38 (text) and line 40 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][57], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][58], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][59], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 15 (text), line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 18 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][61], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 19 (text), line 25 (text), line 25 (text), line 29 (text), line 29 (text), line 31 (text), line 31 (text), line 31
  (text), line 32 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs.md][62], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][63], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 47 (text) and line 77 (text).
- [docs/references/automation/catzc-base-maps.md][64], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### Globs (38 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][65], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][66], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][67], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][68], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][69], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][70], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][71], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 72 (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][72], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][73], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][74], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][75], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][76], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][77], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][78], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 7
  (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][79], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][80], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][81], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][82], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][83], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][85], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][87], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][88], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][89], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][90], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][91], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][92], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][93], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][94], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][95], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][96], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][97], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 50 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5 (header), line 13
  (body comment), line 62 (text), line 75 (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][98], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][99], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][100], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][101], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][102], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### Maps (29 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][103], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (header), line 11 (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][104], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 8 (header), line 9 (header) and line 22 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][105], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header), line 8 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][106], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 6 (header), line 7 (header) and line 15 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][107], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (header) and line 33 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][108], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (header), line 16 (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line
  68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][109], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 11 (header), line 14 (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102
  (text), line 106 (text) and line 107 (text).
- [automation/Catzc.Base.Maps/configs/maps.yml][110], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 26 (header), line 32 (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][111], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 9 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][112], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][113], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][114], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 72 (body comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][115], in the cell automation × powershell: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and line 71 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][116], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line
  61 (text), line 62 (text), line 63 (text), line 64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line
  90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][117], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header), line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81
  (text), line 90 (text), line 91 (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line
  121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][118], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text)
  and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][119], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][120], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 104 (text) and line 119 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][121], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 2 (header), line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][122], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 5 (header), line 6 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][123], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header), line 3 (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][124], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][125], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][126], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][127], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][128], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 7 (header), line 8 (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][129], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][130], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][131], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 4 (header), line 5 (header) and line 6 (header).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][132], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][133], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][134], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][4], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][135], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][136], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][137], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][138], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][139], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][140], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][141], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][142], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][143], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][144], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][145], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### Docs (9 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][146], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line
  118 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 286 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][147], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][148], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][149], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][150], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][151], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][152], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][153], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment); selected by [ADR-FLOW-CD][2]: the file cites it
  at line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][154], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Languages (9 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][155], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][156], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][157], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][158], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][159], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][160], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][161], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][162], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][163], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][164], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][165], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][166], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][167], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][168], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][169], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][170], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][171], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### QualityGates (6 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][172], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][173], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 62 (text).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][174], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][175], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][176], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][177], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9 (header).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][178], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][179], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][180], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-types.md][181], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][182], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][183], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][184], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][185], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][186], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][187], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][188], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][189], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][190], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][191], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][192], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (header).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][193], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][194], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][195], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][196], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][197], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][198], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 180 (text),
  line 181 (text), line 186 (text), line 194 (text), line 196 (text) and line 197 (text); selected by [ADR-FLOW-CD][2]: the file cites it at
  line 28 (text).
- [.claude/drawio/minimaps/highlights.ps1][199], in the cell .claude × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 44 (body comment) (a passing mention only).

### ModuleSystem (2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][200], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (header) and line 89 (body comment).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][201], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 21 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][202], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 292
  (text) and line 305 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 677 (text).
- [docs/adr/index.md][203], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 111 (text); selected
  by [ADR-REPO-FOLDERS][4]: the file cites it at line 267 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][204], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (body comment) (a passing mention only).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][205], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).

## Keywords

- [world map][206]
- [track][207]
- [file language][208]
- [cell][209]
- [lit cell][210]
- [.claude][194]: a track
- [.github][194]: a track
- [automation][194]: a track
- [docs][194]: a track
- [pipelines][194]: a track
- [csharp][157]: a file language
- [markdown][157]: a file language
- [pipeline-yaml][157]: a file language
- [powershell][157]: a file language
- [yaml][157]: a file language

Terms the cited ADRs define:

- [cell][209], defined by [ADR-DSGN-TRACK#10][211]
- [deployable-unit][212], defined by [ADR-DSGN-TRACK#5][213]
- [domain][214], defined by [ADR-REPO-FOLDERS#5][215]
- [file language][208], defined by [ADR-DSGN-TRACK#6][216]
- [gate][217], defined by [ADR-FLOW-CD#13][218]
- [lit cell][210], defined by [ADR-DSGN-TRACK#12][219]
- [release candidate][220], defined by [ADR-FLOW-CD#14][221]
- [root file][222], defined by [ADR-DSGN-TRACK#7][223]
- [stack violation][224], defined by [ADR-DSGN-TRACK#11][225]
- [track][207], defined by [ADR-DSGN-TRACK#1][226]
- [unlisted file][227], defined by [ADR-DSGN-TRACK#8][228]
- [value-chain concern][229], defined by [ADR-DSGN-TRACK#15][230]
- [value-chain map][231], defined by [ADR-DSGN-TRACK#16][232]
- [value-chain stack][233], defined by [ADR-DSGN-TRACK#14][234]
- [verification track][235], defined by [ADR-DSGN-TRACK#2][236]
- [world map][206], defined by [ADR-DSGN-TRACK#9][237]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/flow/durable-sha-globs.md
[4]: ../../adr/repository/conventional-folders.md
[5]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[6]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[7]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[8]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[9]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[10]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[11]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
[12]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
[13]: adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
[14]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[15]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
[16]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[17]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[18]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[19]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[20]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[21]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[22]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[23]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[24]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[25]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[26]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[27]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[28]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[29]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[30]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[31]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[32]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[33]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[34]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[35]: ../../explanation/design/four-domains-promote-one-artifact.md
[36]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[37]: ../../explanation/design/integrators-depend-on-an-occupant.md
[38]: ../../explanation/design/one-folder-two-independent-readers.md
[39]: ../../explanation/design/one-unit-one-pipeline.md
[40]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[41]: ../../explanation/design/sync-point-rules-are-adr-only.md
[42]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[43]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[44]: ../../explanation/design/which-rung-gates-exist-in-code.md
[45]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[46]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[47]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[48]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[49]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[50]: ../../explanation/flow/gates-check-source-and-trigger.md
[51]: ../../explanation/flow/globs-module-owns-config-and-types.md
[52]: ../../explanation/flow/independence-check-groups-by-layer.md
[53]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[54]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[55]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[56]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[57]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[58]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[59]: ../../explanation/flow/two-declared-layers-one-derived.md
[60]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[61]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[62]: ../../references/automation/catzc-base-globs.md
[63]: ../../references/automation/catzc-base-languages.md
[64]: ../../references/automation/catzc-base-maps.md
[65]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[66]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[67]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[68]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[69]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[70]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[71]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[72]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[73]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[74]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[75]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[76]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[77]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[78]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[79]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[80]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[81]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[82]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[83]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[84]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[85]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[86]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[87]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[88]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[89]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[90]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[91]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[92]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[93]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[94]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[95]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[96]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[97]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[98]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[99]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[100]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[101]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[102]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[103]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[104]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[105]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[106]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[107]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[108]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[109]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[110]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[111]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[112]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[113]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[114]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[115]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[116]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[117]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[118]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[119]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[120]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[121]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[122]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[123]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[124]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[125]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[126]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[127]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[128]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[129]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[130]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[131]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[132]: ../../adr/repository/agent-definitions.md
[133]: ../../adr/repository/api-contracts.md
[134]: ../../adr/repository/controlled-vocabulary.md
[135]: ../../adr/repository/dedicated-output-directory.md
[136]: ../../adr/repository/documentation-examples.md
[137]: ../../adr/repository/domain-language-separation.md
[138]: ../../adr/repository/dora-explains.md
[139]: ../../adr/repository/generated-readmes.md
[140]: ../../adr/repository/generated-root-configs.md
[141]: ../../adr/repository/inspiration.md
[142]: ../../adr/repository/markdown-links.md
[143]: ../../adr/repository/output-formats.md
[144]: ../../adr/repository/repo-variants.md
[145]: ../../adr/repository/uniform-formatting.md
[146]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[147]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[148]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[149]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[150]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[151]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[152]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[153]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[154]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[155]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[156]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[157]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[158]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[159]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[160]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[161]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[162]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[163]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[164]: ../../adr/design/commit-lifecycle.md
[165]: ../../adr/design/dora-explains.md
[166]: ../../adr/design/module-aspects.md
[167]: ../../adr/design/run-modes.md
[168]: ../../adr/design/self-service.md
[169]: ../../adr/design/server-remote-integration.md
[170]: ../../adr/design/thin-platforms.md
[171]: ../../adr/design/visual-design.md
[172]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[173]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[174]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[175]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[176]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[177]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[178]: ../../adr/flow/dora-explains.md
[179]: ../../adr/flow/pipeline-detection.md
[180]: ../../adr/flow/pipeline-runner-pattern.md
[181]: ../../adr/flow/pipeline-types.md
[182]: ../../../pipelines/cd-apex.yaml
[183]: ../../../pipelines/cd-flux.yaml
[184]: ../../../pipelines/cd-nova.yaml
[185]: ../../../pipelines/cd-shared.yaml
[186]: ../../../pipelines/ci-automation.yaml
[187]: ../../../pipelines/ci-infrastructure.yaml
[188]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[189]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[190]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[191]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[192]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[193]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[194]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[195]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[196]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[197]: ../../../.claude/CLAUDE.md
[198]: ../../../.claude/drawio/STYLE.md
[199]: ../../../.claude/drawio/minimaps/highlights.ps1
[200]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[201]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[202]: ../../adr/glossary.md
[203]: ../../adr/index.md
[204]: ../../../.github/workflows/ci-automation.yml
[205]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[206]: ../../adr/glossary.md#world-map
[207]: ../../adr/glossary.md#track
[208]: ../../adr/glossary.md#file-language
[209]: ../../adr/glossary.md#cell
[210]: ../../adr/glossary.md#lit-cell
[211]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[212]: ../../adr/glossary.md#deployable-unit
[213]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[214]: ../../adr/glossary.md#domain
[215]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[216]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[217]: ../../adr/glossary.md#gate
[218]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[219]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[220]: ../../adr/glossary.md#release-candidate
[221]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[222]: ../../adr/glossary.md#root-file
[223]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[224]: ../../adr/glossary.md#stack-violation
[225]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[226]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[227]: ../../adr/glossary.md#unlisted-file
[228]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[229]: ../../adr/glossary.md#value-chain-concern
[230]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[231]: ../../adr/glossary.md#value-chain-map
[232]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[233]: ../../adr/glossary.md#value-chain-stack
[234]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[235]: ../../adr/glossary.md#verification-track
[236]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[237]: ../../adr/design/tracks.md#rule-adr-dsgn-track9

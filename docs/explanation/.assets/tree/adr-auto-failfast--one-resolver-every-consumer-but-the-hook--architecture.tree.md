---
catzc:
  immutable:
    with_body_sha: "72768e5c76c3"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.tree.md
    source: docs/explanation/.assets/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One resolver serves every consumer but the hook, which compiles the same config type: the tree minimap

```text
Which files cite ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST: every file of the world map is a tile, grouped by top-level folder.
170 files lit in 21 groups.
```

![The tree minimap of One resolver serves every consumer but the hook, which compiles the same config type](adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [One resolver serves every consumer but the hook, which compiles the
same config type][171], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights every file that cites those codes,
grouped by folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 170 files in 21 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 61 lit files
- .claude: 27 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 23 lit files
- Docs (automation/Catzc.Base.Docs): 12 lit files
- Languages (automation/Catzc.Base.Languages): 7 lit files
- Contracts (automation/Catzc.Base.Contracts): 6 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 6 lit files
- Maps (automation/Catzc.Base.Maps): 5 lit files
- Slides (automation/Catzc.Base.Slides): 4 lit files
- Folders (automation/Catzc.Base.Folders): 3 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 3 lit files
- adr/auto (docs/adr/automation): 3 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 2 lit files
- Azure (automation/Catzc.Azure): 1 lit file
- Az.Cli (automation/Catzc.Azure.Cli): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Git (automation/Catzc.Base.Git): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- Reports (automation/Catzc.Base.Reports): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 61 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/automation/manual-test-plan/repository-conventions.md][3], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 15 (text) and line 56 (text).
- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][4], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 82 (text).
- [docs/references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md][5], in the cell docs × markdown:
  selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 15 (text) and line 77 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][6], in the cell docs ×
  markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 16 (text), line 64 (text), line 77 (text), line 80 (text), line 81
  (text) and line 81 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][7], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 123 (text).
- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][8], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 47 (text).
- [docs/references/automation/catzc-base-contracts/configs/contracts.yml.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-contracts/types/ContractsConfig.cs.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][14], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][15], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 60 (text).
- [docs/references/automation/catzc-base-docs/types/CheckMode.cs.md][16], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-docs/types/CheckModes.cs.md][17], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 16 (text), line 53 (text) and line 121 (text).
- [docs/references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][20], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages.md][21], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 82 (text).
- [docs/references/automation/catzc-base-languages/configs/file-carriers.yml.md][22], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/configs/go.yml.md][23], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][24], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 64 (text).
- [docs/references/automation/catzc-base-languages/configs/python.yml.md][25], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md][26], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md][27], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][28], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][29], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 49 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][30], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-maps/types/MapsConfig.cs.md][31], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md][32], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][33], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 46 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md][34], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/MapsPalette.cs.md][35], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md][36], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md][37], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/links.yml.md][38], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md][39], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md][40], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md][41], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][42], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][43], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][44], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][45], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][46], in the cell docs × markdown:
  selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md][47], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md][48], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md][49], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md][50], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md][51], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][52], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md][53], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][54], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][55], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][56], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][57], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md][58], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-typessystem.md][59], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 15 (text) and line 88 (text).
- [docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md][60], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][61], in the cell docs × markdown:
  selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md][62], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][63], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 17 (text) and line 31 (text).

### .claude (27 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][64], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 48 (text); selected
  by [ADR-AUTO-FAILFAST][2]: the file cites it at line 115 (text).
- [.claude/plans/decisions-2026-10-16.md][65], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  23 (text), line 51 (text), line 62 (text), line 63 (text) and line 156 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 25 (text), line 71 (text), line 71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/decisions-2026-10-18.md][66], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  22 (text) and line 40 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][67], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 24 (text), line 184 (text) and line 473 (text).
- [.claude/plans/plan-assert-wait.md][68], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text), line 94 (text) and line 95 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text), line 49 (text), line
  63 (text), line 71 (text), line 116 (text), line 118 (text), line 119 (text), line 158 (text) and line 165 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][69], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 25 (text), line 150 (text), line 165 (text), line 183 (text), line 191 (text), line 211 (text), line 223 (text), line 327
  (text) and line 345 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 26 (text), line 55 (text), line 303 (text) and
  line 304 (text).
- [.claude/plans/plan-config-defaults.md][70], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  31 (text), line 51 (text), line 97 (text), line 141 (text), line 197 (text) and line 263 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 61 (text) and line 265 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][71], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 31 (text), line 249 (text) and line 363 (text).
- [.claude/plans/plan-file-meta-head-policy.md][72], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 30 (text), line 61 (text) and line 166 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][73], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 26 (text), line 523 (text), line 560 (text), line 562 (text), line 702 (text) and line 794 (text).
- [.claude/plans/plan-lazy-types-load.md][74], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  30 (text) and line 85 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 108 (text).
- [.claude/plans/plan-master.md][75], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 101
  (text).
- [.claude/plans/plan-materialization-of-knowledge.md][76], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 24 (text) and line 43 (text).
- [.claude/plans/plan-module-kinds-tracks.md][77], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 31 (text), line 269 (text), line 333 (text) and line 376 (text).
- [.claude/plans/plan-out-artifacts.md][78], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 28
  (text) and line 150 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][79], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 23 (text) and line 224 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][80], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 18 (text) and line 39 (text).
- [.claude/plans/prompt-config-defaults-continue.md][81], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 34 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][82], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 40 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][83], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 18 (text), line 41 (text) and line 56 (text).
- [.claude/plans/questionnaire-2026-10-16.md][84], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 140 (text).
- [.claude/plans/task-assert-wait.md][85], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 70
  (text).
- [.claude/plans/task-config-defaults-postures.md][86], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 33 (text) and line 56 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 43 (text).
- [.claude/plans/task-config-defaults-variants.md][87], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 24 (text) and line 31 (text).
- [.claude/plans/task-import-landing-zone.md][88], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 31 (text), line 40 (text) and line 61 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text) and line 61
  (text).
- [.claude/plans/task-lazy-types-load.md][89], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  31 (text) and line 41 (text).
- [.claude/skills/catzc-module/SKILL.md][90], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  26 (text) and line 39 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 23 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][91], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 602 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1][92], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][93], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][94], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (header) and line 43 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][95], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 209 (text).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][96], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 28 (text), line 124 (text) and line 128 (text).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][97], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 32 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1][98], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 25 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][99], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 40 (text) and line 90 (text).
- [automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][100], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1][101], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 24 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][102], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 26 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][103], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 27 (text) and line 51 (text).
- [automation/Catzc.Base.QualityGates/types/CommentsConfig.cs][104], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs][105], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaKind.cs][106], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs][107], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][108], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][109], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/PlansConfig.cs][110], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 20 (text) and line 25 (body comment).
- [automation/Catzc.Base.QualityGates/types/SourceCheck.cs][111], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][112], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][113], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 21 (text).

### Docs (automation/Catzc.Base.Docs, 12 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-Glossary.ps1][114], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][115], in the cell automation × yaml: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 150 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 151 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][116], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 74 (body comment) and line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][117], in the cell automation × yaml: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 33 (body comment) (a passing mention only); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][118], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][119], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][120], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 28 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][121], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 27 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][122], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][123], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 22 (text).
- [automation/Catzc.Base.Docs/types/CheckMode.cs][124], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][125], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 21 (text).

### Languages (automation/Catzc.Base.Languages, 7 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][126], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 55 (text).
- [automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][127], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 155 (text).
- [automation/Catzc.Base.Languages/types/FileCarrier.cs][128], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/FileCarriersConfig.cs][129], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][130], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][131], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/LayoutRow.cs][132], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 20 (text).

### Contracts (automation/Catzc.Base.Contracts, 6 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][133], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 119 (text), line 287 (text) and line 303 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1][134], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 51 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][135], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 26 (text) and line 50 (text).
- [automation/Catzc.Base.Contracts/types/ContractCommand.cs][136], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.Contracts/types/ContractParameter.cs][137], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][138], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).

### Timeouts (automation/Catzc.Base.Timeouts, 6 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][139], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 22 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][140], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1][141], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 176 (text).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][142], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][143], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][144], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).

### Maps (automation/Catzc.Base.Maps, 5 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/types/MapsConfig.cs][145], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][146], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][147], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][148], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][149], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).

### Slides (automation/Catzc.Base.Slides, 4 lit files)

The group holds the files of automation/Catzc.Base.Slides; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1][150], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 19 (header), line 168 (text) and line 176 (text).
- [automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1][151], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]:
  the file cites it at line 19 (header) and line 67 (text).
- [automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][152], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header), line 26 (text) and line 56 (text).
- [automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1][153], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 42 (text).

### Folders (automation/Catzc.Base.Folders, 3 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][154], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header), line 87 (text) and line 93 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 20 (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][155], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 26 (text), line 33 (text) and line 74 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][156], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 46 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 20 (header) and line 87 (text).

### Tool.Inspiration (automation/Catzc.Tooling.Inspiration, 3 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1][157], in the cell automation × powershell: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][158], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][159], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).

### adr/auto (docs/adr/automation, 3 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][160], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 313
  (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 330 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.

### TypesSystem (automation/Catzc.Base.TypesSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][161], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][162], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (header) and line 29 (header).

### Azure (automation/Catzc.Azure, 1 lit file)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][163], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 21 (text).

### Az.Cli (automation/Catzc.Azure.Cli, 1 lit file)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][164], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 36 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][165], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 22 (text).

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1][166], in the cell automation × powershell: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 21 (header) and line 33 (header); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (header) and
  line 36 (header).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][167], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 21 (header) and line 43 (header).

### Reports (automation/Catzc.Base.Reports, 1 lit file)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][168], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header), line 66 (text) and line 88 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][169], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 162 (text); selected
  by [ADR-AUTO-FAILFAST][2]: the file cites it at line 163 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][170], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure/types/AzureConfig.cs` line 21 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 119 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 287 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 303 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.Contracts/types/ContractCommand.cs` line 21 (text), `automation/Catzc.Base.Contracts/types/ContractParameter.cs`
  line 20 (text), `automation/Catzc.Base.Contracts/types/ContractsConfig.cs` line 21 (text), `automation/Catzc.Base.Docs/configs/adrs.yml`
  line 150 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 33 (body comment),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 27 (text), `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line
  21 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 22 (text), `automation/Catzc.Base.Docs/types/CheckMode.cs` line 20
  (text), `automation/Catzc.Base.Docs/types/CheckModes.cs` line 21 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 33 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 74 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 46 (text),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 21 (header),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 33 (header),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 55 (text),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 155 (text),
  `automation/Catzc.Base.Languages/types/FileCarrier.cs` line 20 (text), `automation/Catzc.Base.Languages/types/FileCarriersConfig.cs` line
  21 (text), `automation/Catzc.Base.Languages/types/GoConfig.cs` line 21 (text), `automation/Catzc.Base.Languages/types/LanguagesConfig.cs`
  line 21 (text), `automation/Catzc.Base.Languages/types/LayoutRow.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsConfig.cs` line
  21 (text), `automation/Catzc.Base.Maps/types/MapsHighlight.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsLabels.cs` line 20
  (text), `automation/Catzc.Base.Maps/types/MapsLimits.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsPalette.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 209 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 124 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 128 (text),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 32 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1` line 25 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 40 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 90 (text),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1` line 24 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.QualityGates/types/CommentsConfig.cs` line 21 (text), `automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/FileMetaKind.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs` line 20 (text), `automation/Catzc.Base.QualityGates/types/LinksConfig.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/PlansConfig.cs` line 20 (text), `automation/Catzc.Base.QualityGates/types/PlansConfig.cs` line
  25 (body comment), `automation/Catzc.Base.QualityGates/types/SourceCheck.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs` line 21 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 88 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 56 (text),
  `automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1` line 42 (text),
  `automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` line 176 (text),
  `automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs` line 21 (text), `automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs`
  line 21 (text), `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 26 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1` line 20 (header) and
  `automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs` line 21 (text); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1`
  line 21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 151 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 95 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1` line 26 (header),
  `automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1` line 20 (header), `automation/Catzc.Base.Engines/types/ExecutionEngine.cs` line
  22 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 71 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 23 (header),
  `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1` line 36 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line
  21 (header), `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1` line 43 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 602 (text),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1` line 28 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1` line 43 (header),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 168 (text),
  `automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1` line 176 (text), `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1` line 67 (text),
  `automation/Catzc.Base.Timeouts/Assert-Wait.ps1` line 22 (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 20
  (header), `automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1` line 26 (header),
  `automation/Catzc.Base.Timeouts/types/BashSafeguard.cs` line 21 (text), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1`
  line 21 (header), `automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1` line 27 (header),
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 22 (header) and
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 29 (header).

## Keywords

- [world map][172]
- [track][173]
- [file language][174]
- [cell][175]
- [lit cell][176]
- [.claude][177]: a track
- [automation][177]: a track
- [docs][177]: a track
- [pipelines][177]: a track
- [csharp][178]: a file language
- [markdown][178]: a file language
- [pipeline-yaml][178]: a file language
- [powershell][178]: a file language
- [yaml][178]: a file language

[1]: ../../../adr/automation/sensible-defaults.md
[2]: ../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../how-to/automation/manual-test-plan/repository-conventions.md
[4]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[5]: ../../../references/.assets/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
[6]: ../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[7]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[8]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[9]: ../../../references/automation/catzc-base-contracts/configs/contracts.yml.md
[10]: ../../../references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[11]: ../../../references/automation/catzc-base-contracts/types/ContractsConfig.cs.md
[12]: ../../../references/automation/catzc-base-docs/configs/adr-checks.yml.md
[13]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[14]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[15]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[16]: ../../../references/automation/catzc-base-docs/types/CheckMode.cs.md
[17]: ../../../references/automation/catzc-base-docs/types/CheckModes.cs.md
[18]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[19]: ../../../references/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[20]: ../../../references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[21]: ../../../references/automation/catzc-base-languages.md
[22]: ../../../references/automation/catzc-base-languages/configs/file-carriers.yml.md
[23]: ../../../references/automation/catzc-base-languages/configs/go.yml.md
[24]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[25]: ../../../references/automation/catzc-base-languages/configs/python.yml.md
[26]: ../../../references/automation/catzc-base-languages/types/FileCarrier.cs.md
[27]: ../../../references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md
[28]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[29]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[30]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[31]: ../../../references/automation/catzc-base-maps/types/MapsConfig.cs.md
[32]: ../../../references/automation/catzc-base-maps/types/MapsHighlight.cs.md
[33]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[34]: ../../../references/automation/catzc-base-maps/types/MapsLimits.cs.md
[35]: ../../../references/automation/catzc-base-maps/types/MapsPalette.cs.md
[36]: ../../../references/automation/catzc-base-qualitygates/configs/comments.yml.md
[37]: ../../../references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
[38]: ../../../references/automation/catzc-base-qualitygates/configs/links.yml.md
[39]: ../../../references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[40]: ../../../references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
[41]: ../../../references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
[42]: ../../../references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[43]: ../../../references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[44]: ../../../references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[45]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[46]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[47]: ../../../references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md
[48]: ../../../references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[49]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
[50]: ../../../references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[51]: ../../../references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md
[52]: ../../../references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[53]: ../../../references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md
[54]: ../../../references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[55]: ../../../references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[56]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[57]: ../../../references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[58]: ../../../references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[59]: ../../../references/automation/catzc-base-typessystem.md
[60]: ../../../references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
[61]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[62]: ../../../references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[63]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[64]: ../../../../.claude/CLAUDE.md
[65]: ../../../../.claude/plans/decisions-2026-10-16.md
[66]: ../../../../.claude/plans/decisions-2026-10-18.md
[67]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[68]: ../../../../.claude/plans/plan-assert-wait.md
[69]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[70]: ../../../../.claude/plans/plan-config-defaults.md
[71]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[72]: ../../../../.claude/plans/plan-file-meta-head-policy.md
[73]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[74]: ../../../../.claude/plans/plan-lazy-types-load.md
[75]: ../../../../.claude/plans/plan-master.md
[76]: ../../../../.claude/plans/plan-materialization-of-knowledge.md
[77]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[78]: ../../../../.claude/plans/plan-out-artifacts.md
[79]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[80]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[81]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[82]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[83]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[84]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[85]: ../../../../.claude/plans/task-assert-wait.md
[86]: ../../../../.claude/plans/task-config-defaults-postures.md
[87]: ../../../../.claude/plans/task-config-defaults-variants.md
[88]: ../../../../.claude/plans/task-import-landing-zone.md
[89]: ../../../../.claude/plans/task-lazy-types-load.md
[90]: ../../../../.claude/skills/catzc-module/SKILL.md
[91]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[92]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
[93]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[94]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[95]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[96]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[97]: ../../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[98]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
[99]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[100]: ../../../../automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[101]: ../../../../automation/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
[102]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[103]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[104]: ../../../../automation/Catzc.Base.QualityGates/types/CommentsConfig.cs
[105]: ../../../../automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
[106]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaKind.cs
[107]: ../../../../automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs
[108]: ../../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[109]: ../../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[110]: ../../../../automation/Catzc.Base.QualityGates/types/PlansConfig.cs
[111]: ../../../../automation/Catzc.Base.QualityGates/types/SourceCheck.cs
[112]: ../../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[113]: ../../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[114]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[115]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[116]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[117]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[118]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[119]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[120]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[121]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[122]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[123]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[124]: ../../../../automation/Catzc.Base.Docs/types/CheckMode.cs
[125]: ../../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[126]: ../../../../automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[127]: ../../../../automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[128]: ../../../../automation/Catzc.Base.Languages/types/FileCarrier.cs
[129]: ../../../../automation/Catzc.Base.Languages/types/FileCarriersConfig.cs
[130]: ../../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[131]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[132]: ../../../../automation/Catzc.Base.Languages/types/LayoutRow.cs
[133]: ../../../../automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[134]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
[135]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[136]: ../../../../automation/Catzc.Base.Contracts/types/ContractCommand.cs
[137]: ../../../../automation/Catzc.Base.Contracts/types/ContractParameter.cs
[138]: ../../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[139]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[140]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[141]: ../../../../automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
[142]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[143]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[144]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[145]: ../../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[146]: ../../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[147]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[148]: ../../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[149]: ../../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[150]: ../../../../automation/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
[151]: ../../../../automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
[152]: ../../../../automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[153]: ../../../../automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
[154]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[155]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[156]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[157]: ../../../../automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1
[158]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[159]: ../../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[160]: ../../../adr/automation/dora-explains.md
[161]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[162]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[163]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[164]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[165]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[166]: ../../../../automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
[167]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[168]: ../../../../automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[169]: ../../../adr/index.md
[170]: ../../../../pipelines/ci-automation.yaml
[171]: ../../automation/one-resolver-every-consumer-but-the-hook.md
[172]: ../../../adr/glossary.md#world-map
[173]: ../../../adr/glossary.md#track
[174]: ../../../adr/glossary.md#file-language
[175]: ../../../adr/glossary.md#cell
[176]: ../../../adr/glossary.md#lit-cell
[177]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[178]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

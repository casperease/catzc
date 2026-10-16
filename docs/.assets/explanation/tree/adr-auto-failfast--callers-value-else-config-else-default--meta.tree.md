# docs/.assets/explanation/tree/adr-auto-failfast--callers-value-else-config-else-default--meta.tree.md

`Tree minimap: adr-auto-failfast--callers-value-else-config-else-default--meta`

![Tree minimap of adr-auto-failfast--callers-value-else-config-else-default--meta](adr-auto-failfast--callers-value-else-config-else-default--meta.tree.png)

The tree minimap of the slide `adr-auto-failfast--callers-value-else-config-else-default--meta` (meta lens). The slide supports
[ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 157 files in 21 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 55 lit files
- .claude: 21 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 20 lit files
- Docs (automation/Catzc.Base.Docs): 12 lit files
- .unordered: 10 lit files
- Languages (automation/Catzc.Base.Languages): 7 lit files
- Maps (automation/Catzc.Base.Maps): 5 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 5 lit files
- Contracts (automation/Catzc.Base.Contracts): 3 lit files
- Folders (automation/Catzc.Base.Folders): 3 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 3 lit files
- adr/auto (docs/adr/automation): 3 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 2 lit files
- Azure (automation/Catzc.Azure): 1 lit file
- Az.Cli (automation/Catzc.Azure.Cli): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- Reports (automation/Catzc.Base.Reports): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- adr/repo (docs/adr/repository): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 55 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-azure/types/AzureConfig.cs.md][3], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 47 (text).
- [docs/references/automation/catzc-base-contracts/configs/contracts.yml.md][4], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-contracts/types/ContractsConfig.cs.md][6], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/configs/adr-checks.yml.md][7], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][10], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 59 (text).
- [docs/references/automation/catzc-base-docs/types/CheckMode.cs.md][11], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-docs/types/CheckModes.cs.md][12], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-engines/types/ExecutionEngine.cs.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 17 (text) and line 57 (text).
- [docs/references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-languages.md][15], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 83 (text).
- [docs/references/automation/catzc-base-languages/configs/file-carriers.yml.md][16], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/configs/go.yml.md][17], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/configs/languages.yml.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 64 (text).
- [docs/references/automation/catzc-base-languages/configs/python.yml.md][19], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md][20], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md][21], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-languages/types/GoConfig.cs.md][22], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md][23], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 49 (text).
- [docs/references/automation/catzc-base-maps/configs/maps.yml.md][24], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-maps/types/MapsConfig.cs.md][25], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md][26], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md][27], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 46 (text).
- [docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md][28], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-maps/types/MapsPalette.cs.md][29], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md][30], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md][31], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/links.yml.md][32], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md][33], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md][34], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/test-policy.yml.md][35], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md][36], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md][37], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md][38], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md][39], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 32 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md][40], in the cell docs × markdown:
  selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md][41], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md][42], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md][43], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md][44], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 30 (text).
- [docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md][45], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md][46], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md][47], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md][48], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md][49], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md][50], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md][51], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 40 (text).
- [docs/references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md][52], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 43 (text).
- [docs/references/automation/catzc-base-typessystem.md][53], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 16 (text) and line 89 (text).
- [docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md][54], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 35 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][55], in the cell docs × markdown:
  selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md][56], in the cell docs × markdown: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 17 (text) and line 38 (text).
- [docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md][57], in the cell docs × markdown: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 17 (text) and line 31 (text).

### .claude (21 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][58], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 46 (text); selected
  by [ADR-AUTO-FAILFAST][2]: the file cites it at line 113 (text).
- [.claude/plans/decisions-2026-10-16.md][59], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  23 (text), line 51 (text), line 62 (text), line 63 (text) and line 156 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 25 (text), line 71 (text), line 71 (text), line 193 (text) and line 200 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][60], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 25 (text), line 177 (text) and line 466 (text).
- [.claude/plans/plan-assert-wait.md][61], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 31
  (text) and line 85 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 32 (text), line 44 (text), line 57 (text), line
  65 (text) and line 115 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][62], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 26 (text), line 149 (text), line 164 (text), line 182 (text), line 190 (text), line 210 (text), line 222 (text), line 326
  (text) and line 344 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 27 (text), line 56 (text), line 302 (text) and
  line 303 (text).
- [.claude/plans/plan-config-defaults.md][63], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  35 (text), line 54 (text), line 98 (text), line 142 (text), line 198 (text) and line 264 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 62 (text) and line 266 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][64], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 32 (text), line 227 (text) and line 341 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][65], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 27 (text), line 463 (text), line 500 (text), line 502 (text), line 642 (text) and line 734 (text).
- [.claude/plans/plan-lazy-types-load.md][66], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  31 (text), line 168 (text), line 225 (text) and line 296 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 204 (text).
- [.claude/plans/plan-materialization-of-knowledge.md][67], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 26 (text), line 44 (text) and line 117 (text).
- [.claude/plans/plan-minimal-robots-agents.md][68], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 25 (text) and line 91 (text).
- [.claude/plans/plan-minimal-robots-capabilities.md][69], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 25 (text) and line 131 (text).
- [.claude/plans/plan-module-kinds-tracks.md][70], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 34 (text), line 262 (text), line 326 (text) and line 369 (text).
- [.claude/plans/plan-out-artifacts.md][71], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 30
  (text) and line 148 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][72], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 24 (text) and line 172 (text).
- [.claude/plans/prompt-bounded-folder-enumeration-continue.md][73], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 19 (text) and line 40 (text).
- [.claude/plans/prompt-config-defaults-continue.md][74], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 37 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][75], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 43 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][76], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 19 (text), line 44 (text) and line 59 (text).
- [.claude/plans/questionnaire-2026-10-16.md][77], in the cell .claude × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 141 (text).
- [.claude/skills/catzc-module/SKILL.md][78], in the cell .claude × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line
  27 (text) and line 40 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 20 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][79], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 599 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1][80], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 27 (header).
- [automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1][81], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1][82], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (header) and line 43 (header).
- [automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1][83], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 204 (text).
- [automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 28 (text), line 124 (text) and line 128 (text).
- [automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1][85], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 32 (text).
- [automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 40 (text) and line 90 (text).
- [automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1][87], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 27 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1][88], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 26 (text).
- [automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1][89], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 27 (text) and line 51 (text).
- [automation/Catzc.Base.QualityGates/types/CommentsConfig.cs][90], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs][91], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/FileMetaKind.cs][92], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs][93], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 20 (text).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][94], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][95], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/SourceCheck.cs][96], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs][97], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][98], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 21 (text).

### Docs (automation/Catzc.Base.Docs, 12 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Test-Glossary.ps1][99], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][100], in the cell automation × yaml: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 147 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 148 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][101], in the cell automation × yaml: selected by [ADR-AUTO-FAILFAST][2]: the file cites it
  at line 74 (body comment) and line 95 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][102], in the cell automation × yaml: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 33 (body comment) (a passing mention only); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 23 (text).
- [automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1][103], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1][104], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]:
  the file cites it at line 20 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1][105], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 28 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][106], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 27 (text).
- [automation/Catzc.Base.Docs/types/AdrChecksConfig.cs][107], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][108], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 21 (text).
- [automation/Catzc.Base.Docs/types/CheckMode.cs][109], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][110], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 21 (text).

### .unordered (10 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][111], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 107 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][112], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 12 (text), line 29 (text), line 110 (text), line 214 (text) and line 273 (text); selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 13 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][113], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 44 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][114], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 30 (text).
- [.unordered/15-10-2026/plan-contracts.md][115], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at
  line 220 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][116], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites
  it at line 14 (text) and line 16 (text).
- [.unordered/15-10-2026/plan-duration-categories.md][117], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 12 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][118], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 129 (text).
- [.unordered/15-10-2026/plan-strip-comments.md][119], in the cell .unordered × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 77 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][120], in the cell .unordered × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites
  it at line 70 (text).

### Languages (automation/Catzc.Base.Languages, 7 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1][121], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 55 (text).
- [automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1][122], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header) and line 155 (text).
- [automation/Catzc.Base.Languages/types/FileCarrier.cs][123], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Languages/types/FileCarriersConfig.cs][124], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][125], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][126], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.Languages/types/LayoutRow.cs][127], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 19 (text).

### Maps (automation/Catzc.Base.Maps, 5 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/types/MapsConfig.cs][128], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 21 (text).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][129], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][130], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][131], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][132], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites
  it at line 20 (text).

### Timeouts (automation/Catzc.Base.Timeouts, 5 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/Assert-Wait.ps1][133], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1][134], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Timeouts/types/BashSafeguard.cs][135], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][136], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][137], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).

### Contracts (automation/Catzc.Base.Contracts, 3 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][138], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 118 (text), line 286 (text) and line 302 (text).
- [automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1][139], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 26 (text) and line 50 (text).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][140], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the
  file cites it at line 21 (text).

### Folders (automation/Catzc.Base.Folders, 3 lit files)

The group holds the files of automation/Catzc.Base.Folders; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1][141], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header), line 87 (text) and line 93 (text); selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 20 (header) and line 71 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1][142], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header), line 26 (text), line 33 (text) and line 74 (text).
- [automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1][143], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header) and line 46 (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 20 (header) and line 87 (text).

### Tool.Inspiration (automation/Catzc.Tooling.Inspiration, 3 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1][144], in the cell automation × powershell: selected by [ADR-AUTO-DEFAULT][1]:
  the file cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][145], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][146], in the cell automation × csharp: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 21 (text).

### adr/auto (docs/adr/automation, 3 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][147], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 293
  (text); selected by [ADR-AUTO-FAILFAST][2]: the file cites it at line 310 (text).
- [docs/adr/automation/fail-fast-with-asserts.md][2], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][2]: the ADR's own file.
- [docs/adr/automation/sensible-defaults.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the ADR's own file.

### TypesSystem (automation/Catzc.Base.TypesSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][148], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 27 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][149], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 22 (header) and line 29 (header).

### Azure (automation/Catzc.Azure, 1 lit file)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][150], in the cell automation × csharp: selected by [ADR-AUTO-DEFAULT][1]: the file cites it
  at line 21 (text).

### Az.Cli (automation/Catzc.Azure.Cli, 1 lit file)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][151], in the cell automation × powershell: selected by
  [ADR-AUTO-FAILFAST][2]: the file cites it at line 21 (header) and line 36 (header).

### Engines (automation/Catzc.Base.Engines, 1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][152], in the cell automation × csharp: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 22 (text).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][153], in the cell automation × powershell: selected by [ADR-AUTO-FAILFAST][2]: the
  file cites it at line 21 (header) and line 43 (header).

### Reports (automation/Catzc.Base.Reports, 1 lit file)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1][154], in the cell automation × powershell: selected by
  [ADR-AUTO-DEFAULT][1]: the file cites it at line 19 (header), line 66 (text) and line 88 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][155], in the cell docs × markdown: selected by [ADR-AUTO-DEFAULT][1]: the file cites it at line 158 (text); selected
  by [ADR-AUTO-FAILFAST][2]: the file cites it at line 159 (text).

### adr/repo (docs/adr/repository, 1 lit file)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/ai-agent-contract.md][156], in the cell docs × markdown: selected by [ADR-AUTO-FAILFAST][2]: the file cites it at
  line 18 (text) and line 55 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][157], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-DEFAULT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure/types/AzureConfig.cs` line 21 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 118 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 286 (text),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 302 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1` line 50 (text),
  `automation/Catzc.Base.Contracts/types/ContractsConfig.cs` line 21 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 147 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 33 (body comment),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 27 (text), `automation/Catzc.Base.Docs/types/AdrChecksConfig.cs` line
  21 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 21 (text), `automation/Catzc.Base.Docs/types/CheckMode.cs` line 20
  (text), `automation/Catzc.Base.Docs/types/CheckModes.cs` line 21 (text), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 87 (text),
  `automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 33 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` line 74 (text),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1` line 46 (text),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` line 55 (text),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` line 155 (text),
  `automation/Catzc.Base.Languages/types/FileCarrier.cs` line 20 (text), `automation/Catzc.Base.Languages/types/FileCarriersConfig.cs` line
  21 (text), `automation/Catzc.Base.Languages/types/GoConfig.cs` line 21 (text), `automation/Catzc.Base.Languages/types/LanguagesConfig.cs`
  line 21 (text), `automation/Catzc.Base.Languages/types/LayoutRow.cs` line 19 (text), `automation/Catzc.Base.Maps/types/MapsConfig.cs` line
  21 (text), `automation/Catzc.Base.Maps/types/MapsHighlight.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsLabels.cs` line 20
  (text), `automation/Catzc.Base.Maps/types/MapsLimits.cs` line 20 (text), `automation/Catzc.Base.Maps/types/MapsPalette.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1` line 27 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1` line 204 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 28 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 124 (text),
  `automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` line 128 (text),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1` line 32 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 40 (text),
  `automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1` line 90 (text),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1` line 26 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 27 (text),
  `automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` line 51 (text),
  `automation/Catzc.Base.QualityGates/types/CommentsConfig.cs` line 21 (text), `automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/FileMetaKind.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs` line 20 (text), `automation/Catzc.Base.QualityGates/types/LinksConfig.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/SourceCheck.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs` line 21 (text),
  `automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs` line 21 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 66 (text),
  `automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1` line 88 (text),
  `automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs` line 21 (text), `automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs`
  line 21 (text), `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1` line 26 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1` line 20 (header) and
  `automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs` line 21 (text); selected by [ADR-AUTO-FAILFAST][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1`
  line 21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 36 (header),
  `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 21 (header), `automation/Catzc.Base.Docs/Test-Glossary.ps1` line 41 (header),
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 148 (text), `automation/Catzc.Base.Docs/configs/agents.yml` line 74 (body comment),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 95 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 23 (text),
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
  `automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1` line 29 (header).

## Keywords

- [world map][158]
- [track][159]
- [file language][160]
- [cell][161]
- [lit cell][162]
- [.claude][163]: a track
- [.unordered][163]: a track
- [automation][163]: a track
- [docs][163]: a track
- [pipelines][163]: a track
- [csharp][164]: a file language
- [markdown][164]: a file language
- [pipeline-yaml][164]: a file language
- [powershell][164]: a file language
- [yaml][164]: a file language

[1]: ../../../adr/automation/sensible-defaults.md
[2]: ../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../../references/automation/catzc-azure/types/AzureConfig.cs.md
[4]: ../../../references/automation/catzc-base-contracts/configs/contracts.yml.md
[5]: ../../../references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
[6]: ../../../references/automation/catzc-base-contracts/types/ContractsConfig.cs.md
[7]: ../../../references/automation/catzc-base-docs/configs/adr-checks.yml.md
[8]: ../../../references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
[9]: ../../../references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
[10]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[11]: ../../../references/automation/catzc-base-docs/types/CheckMode.cs.md
[12]: ../../../references/automation/catzc-base-docs/types/CheckModes.cs.md
[13]: ../../../references/automation/catzc-base-engines/types/ExecutionEngine.cs.md
[14]: ../../../references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
[15]: ../../../references/automation/catzc-base-languages.md
[16]: ../../../references/automation/catzc-base-languages/configs/file-carriers.yml.md
[17]: ../../../references/automation/catzc-base-languages/configs/go.yml.md
[18]: ../../../references/automation/catzc-base-languages/configs/languages.yml.md
[19]: ../../../references/automation/catzc-base-languages/configs/python.yml.md
[20]: ../../../references/automation/catzc-base-languages/types/FileCarrier.cs.md
[21]: ../../../references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md
[22]: ../../../references/automation/catzc-base-languages/types/GoConfig.cs.md
[23]: ../../../references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
[24]: ../../../references/automation/catzc-base-maps/configs/maps.yml.md
[25]: ../../../references/automation/catzc-base-maps/types/MapsConfig.cs.md
[26]: ../../../references/automation/catzc-base-maps/types/MapsHighlight.cs.md
[27]: ../../../references/automation/catzc-base-maps/types/MapsLabels.cs.md
[28]: ../../../references/automation/catzc-base-maps/types/MapsLimits.cs.md
[29]: ../../../references/automation/catzc-base-maps/types/MapsPalette.cs.md
[30]: ../../../references/automation/catzc-base-qualitygates/configs/comments.yml.md
[31]: ../../../references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
[32]: ../../../references/automation/catzc-base-qualitygates/configs/links.yml.md
[33]: ../../../references/automation/catzc-base-qualitygates/configs/parameter-consistency.yml.md
[34]: ../../../references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
[35]: ../../../references/automation/catzc-base-qualitygates/configs/test-policy.yml.md
[36]: ../../../references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
[37]: ../../../references/automation/catzc-base-qualitygates/tests/types/FileMetaConfig.Tests.ps1.md
[38]: ../../../references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
[39]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceCheck.Tests.ps1.md
[40]: ../../../references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
[41]: ../../../references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md
[42]: ../../../references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
[43]: ../../../references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md
[44]: ../../../references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
[45]: ../../../references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md
[46]: ../../../references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
[47]: ../../../references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md
[48]: ../../../references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
[49]: ../../../references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md
[50]: ../../../references/automation/catzc-base-timeouts/types/BashSafeguard.cs.md
[51]: ../../../references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
[52]: ../../../references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md
[53]: ../../../references/automation/catzc-base-typessystem.md
[54]: ../../../references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
[55]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[56]: ../../../references/automation/catzc-tooling-inspiration/types/InspirationConfig.cs.md
[57]: ../../../references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
[58]: ../../../../.claude/CLAUDE.md
[59]: ../../../../.claude/plans/decisions-2026-10-16.md
[60]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[61]: ../../../../.claude/plans/plan-assert-wait.md
[62]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[63]: ../../../../.claude/plans/plan-config-defaults.md
[64]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[65]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[66]: ../../../../.claude/plans/plan-lazy-types-load.md
[67]: ../../../../.claude/plans/plan-materialization-of-knowledge.md
[68]: ../../../../.claude/plans/plan-minimal-robots-agents.md
[69]: ../../../../.claude/plans/plan-minimal-robots-capabilities.md
[70]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[71]: ../../../../.claude/plans/plan-out-artifacts.md
[72]: ../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[73]: ../../../../.claude/plans/prompt-bounded-folder-enumeration-continue.md
[74]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[75]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[76]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[77]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[78]: ../../../../.claude/skills/catzc-module/SKILL.md
[79]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[80]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
[81]: ../../../../automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
[82]: ../../../../automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
[83]: ../../../../automation/Catzc.Base.QualityGates/tests/Get-AdrCodesFileMetaFact.Tests.ps1
[84]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
[85]: ../../../../automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
[86]: ../../../../automation/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
[87]: ../../../../automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
[88]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
[89]: ../../../../automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
[90]: ../../../../automation/Catzc.Base.QualityGates/types/CommentsConfig.cs
[91]: ../../../../automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
[92]: ../../../../automation/Catzc.Base.QualityGates/types/FileMetaKind.cs
[93]: ../../../../automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs
[94]: ../../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[95]: ../../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[96]: ../../../../automation/Catzc.Base.QualityGates/types/SourceCheck.cs
[97]: ../../../../automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
[98]: ../../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[99]: ../../../../automation/Catzc.Base.Docs/Test-Glossary.ps1
[100]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[101]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[102]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[103]: ../../../../automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
[104]: ../../../../automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
[105]: ../../../../automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
[106]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[107]: ../../../../automation/Catzc.Base.Docs/types/AdrChecksConfig.cs
[108]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[109]: ../../../../automation/Catzc.Base.Docs/types/CheckMode.cs
[110]: ../../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[111]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[112]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[113]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[114]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[115]: ../../../../.unordered/15-10-2026/plan-contracts.md
[116]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[117]: ../../../../.unordered/15-10-2026/plan-duration-categories.md
[118]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[119]: ../../../../.unordered/15-10-2026/plan-strip-comments.md
[120]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[121]: ../../../../automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
[122]: ../../../../automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
[123]: ../../../../automation/Catzc.Base.Languages/types/FileCarrier.cs
[124]: ../../../../automation/Catzc.Base.Languages/types/FileCarriersConfig.cs
[125]: ../../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[126]: ../../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[127]: ../../../../automation/Catzc.Base.Languages/types/LayoutRow.cs
[128]: ../../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[129]: ../../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[130]: ../../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[131]: ../../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[132]: ../../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[133]: ../../../../automation/Catzc.Base.Timeouts/Assert-Wait.ps1
[134]: ../../../../automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
[135]: ../../../../automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
[136]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[137]: ../../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[138]: ../../../../automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[139]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
[140]: ../../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[141]: ../../../../automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
[142]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
[143]: ../../../../automation/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
[144]: ../../../../automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1
[145]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[146]: ../../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[147]: ../../../adr/automation/dora-explains.md
[148]: ../../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[149]: ../../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[150]: ../../../../automation/Catzc.Azure/types/AzureConfig.cs
[151]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[152]: ../../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[153]: ../../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[154]: ../../../../automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
[155]: ../../../adr/index.md
[156]: ../../../adr/repository/ai-agent-contract.md
[157]: ../../../../pipelines/ci-automation.yaml
[158]: ../../../adr/glossary.md#world-map
[159]: ../../../adr/glossary.md#track
[160]: ../../../adr/glossary.md#file-language
[161]: ../../../adr/glossary.md#cell
[162]: ../../../adr/glossary.md#lit-cell
[163]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[164]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

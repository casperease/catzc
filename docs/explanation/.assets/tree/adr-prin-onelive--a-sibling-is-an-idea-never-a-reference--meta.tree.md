# out/drawio/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta/tree/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.tree.md

`Tree minimap: adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta`

![Tree minimap of adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta](adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.tree.png)

The tree minimap of the slide `adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta` (meta lens). The slide supports
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 72 files in 13 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 18 lit files
- .claude: 16 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 16 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- Languages (automation/Catzc.Base.Languages): 4 lit files
- Files (automation/Catzc.Base.Files): 2 lit files
- Globs (automation/Catzc.Base.Globs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/prin (docs/adr/principles): 2 lit files
- Git (automation/Catzc.Base.Git): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 18 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/go/index.md][3], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at
  line 21 (text).
- [docs/references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md][4], in the cell docs ×
  markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 90 (text).
- [docs/references/agent-contracts.md][5], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 42
  (text).
- [docs/references/automation/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 18 (text) and line 28 (text).
- [docs/references/automation/catzc-base-docs/types/CheckModes.cs.md][7], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 18 (text) and line 33 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][8], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the
  file cites it at line 18 (text) and line 59 (text).
- [docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md][9], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the
  file cites it at line 18 (text) and line 44 (text).
- [docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md][10], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 19 (text) and line 38 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md][12], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md][13], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentPageMap.cs.md][14], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 18 (text) and line 34 (text).
- [docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md][15], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 20 (text) and line 38 (text).
- [docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md][16], in the cell docs × markdown: selected by
  [ADR-AUTO-GO][1]: the file cites it at line 17 (text) and line 65 (text).
- [docs/references/automation/catzc-base-vscode/configs/vscode-settings.yml.md][17], in the cell docs × markdown: selected by
  [ADR-AUTO-GO][1]: the file cites it at line 17 (text) and line 204 (text).
- [docs/references/automation/internal/Catzc.Internal.Importer.psm1.md][18], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 37 (text).
- [docs/references/automation/internal/Catzc.Internal.Loader.psm1.md][19], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 32 (text).
- [docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md][20], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 38 (text).

### .claude (16 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][21], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 56 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 58 (text) and line 140 (text).
- [.claude/plans/decisions-2026-10-16.md][22], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 77
  (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 30 (text), line 146 (text) and line 192 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][23], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 125 (text) and line 347 (text).
- [.claude/plans/plan-assert-wait.md][24], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 97
  (text), line 102 (text), line 106 (text) and line 168 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][25], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 187 (text), line 229 (text) and line 369 (text).
- [.claude/plans/plan-config-defaults.md][26], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  88 (text) and line 160 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][27], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 166 (text), line 298 (text) and line 407 (text).
- [.claude/plans/plan-file-meta-head-policy.md][28], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 42 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][29], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file
  cites it at line 425 (text) and line 759 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 132 (text), line 255 (text)
  and line 707 (text).
- [.claude/plans/plan-materialization-of-knowledge.md][30], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 45 (text) and line 131 (text).
- [.claude/plans/plan-module-kinds-tracks.md][31], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line
  321 (text) and line 467 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 242 (text), line 283 (text), line 423 (text),
  line 551 (text), line 590 (text), line 692 (text) and line 1058 (text).
- [.claude/plans/prompt-automation-layers-continue.md][32], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 77 (text).
- [.claude/plans/prompt-config-defaults-continue.md][33], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 76 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][34], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 40 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][35], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 41 (text).
- [.claude/plans/questionnaire-2026-10-16.md][36], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line
  173 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 523 (text) and line 622 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 16 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Build-CommentView.ps1][37], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 21 (header) and line 29 (header).
- [automation/Catzc.Base.QualityGates/Export-Comments.ps1][38], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 21 (header) and line 28 (header).
- [automation/Catzc.Base.QualityGates/Test-Comments.ps1][39], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 23 (header) and line 29 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][40], in the cell automation × yaml: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 574 (text).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1][41], in the cell automation × powershell: selected by
  [ADR-AUTO-GO][1]: the file cites it at line 23 (header) and line 32 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][42], in the cell automation × powershell: selected by
  [ADR-AUTO-GO][1]: the file cites it at line 23 (header) and line 36 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][43], in the cell automation × powershell: selected by
  [ADR-AUTO-GO][1]: the file cites it at line 23 (header) and line 144 (text).
- [automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1][44], in the cell automation × powershell: selected by [ADR-AUTO-GO][1]: the
  file cites it at line 21 (header) and line 30 (header).
- [automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1][45], in the cell automation × powershell: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1][46], in the cell automation × powershell: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 23 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1][47], in the cell automation × powershell: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1][48], in the cell automation × powershell: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.QualityGates/types/CommentBlockKind.cs][49], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/types/CommentEngine.cs][50], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/CommentPageMap.cs][51], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/types/CommentsConfig.cs][52], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 24 (text).

### Docs (automation/Catzc.Base.Docs, 5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][53], in the cell automation × yaml: selected by [ADR-AUTO-GO][1]: the file cites it at line
  167 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 53 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][54], in the cell automation × yaml: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 79 (body comment) and line 85 (text).
- [automation/Catzc.Base.Docs/configs/capabilities.yml][55], in the cell automation × yaml: selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 106 (text) and line 111 (text).
- [automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][56], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 22 (header) and line 26 (text).
- [automation/Catzc.Base.Docs/types/CheckModes.cs][57], in the cell automation × csharp: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 22 (text).

### Languages (automation/Catzc.Base.Languages, 4 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Invoke-GoTest.ps1][58], in the cell automation × powershell: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 23 (header).
- [automation/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1][59], in the cell automation × powershell: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 21 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][60], in the cell automation × yaml: selected by [ADR-AUTO-GO][1]: the file cites it
  at line 35 (text).
- [automation/Catzc.Base.Languages/private/Get-EngineContract.ps1][61], in the cell automation × powershell: selected by [ADR-AUTO-GO][1]:
  the file cites it at line 23 (header) and line 31 (header).

### Files (automation/Catzc.Base.Files, 2 lit files)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/Get-InputStamp.ps1][62], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][63], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 23 (header) and line 43 (header).

### Globs (automation/Catzc.Base.Globs, 2 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][64], in the cell automation × powershell: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 22 (header) and line 39 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][65], in the cell automation × powershell: selected by [ADR-AUTO-GO][1]:
  the file cites it at line 21 (header) and line 73 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][66], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 629 (text).
- [docs/adr/index.md][67], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 179 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 72 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][68], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 614
  (text).
- [docs/adr/automation/go/go-test-artifacts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the ADR's own file.

### adr/prin (docs/adr/principles, 2 lit files)

The group holds the files of docs/adr/principles; each sits in its world-map cell and is lit by:

- [docs/adr/principles/dora-explains.md][69], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 115
  (text).
- [docs/adr/principles/one-living-version.md][2], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the ADR's own file.

### Git (automation/Catzc.Base.Git, 1 lit file)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/configs/gitignore.yml][70], in the cell automation × yaml: selected by [ADR-AUTO-GO][1]: the file cites it at
  line 120 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1][71], in the cell automation × powershell: selected by
  [ADR-AUTO-GO][1]: the file cites it at line 21 (header).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][72], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-GO][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 167 (text),
  `automation/Catzc.Base.Git/configs/gitignore.yml` line 120 (text), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 22 (header),
  `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 39 (header), `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line
  21 (header), `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 73 (text),
  `automation/Catzc.Base.Languages/Invoke-GoTest.ps1` line 23 (header), `automation/Catzc.Base.Languages/configs/glossary.yml` line 35
  (text), `automation/Catzc.Base.Languages/private/Get-EngineContract.ps1` line 23 (header),
  `automation/Catzc.Base.Languages/private/Get-EngineContract.ps1` line 31 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1` line 32 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1` line 36 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 144 (text),
  `automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1` line 30 (header) and
  `automation/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1` line 21 (header); selected by [ADR-PRIN-ONELIVE][2]: a pipeline
  that cites nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 53 (text),
  `automation/Catzc.Base.Docs/configs/agents.yml` line 79 (body comment), `automation/Catzc.Base.Docs/configs/agents.yml` line 85 (text),
  `automation/Catzc.Base.Docs/configs/capabilities.yml` line 106 (text), `automation/Catzc.Base.Docs/configs/capabilities.yml` line 111
  (text), `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 22 (header),
  `automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 26 (text), `automation/Catzc.Base.Docs/types/CheckModes.cs` line 22
  (text), `automation/Catzc.Base.Files/Get-InputStamp.ps1` line 20 (header), `automation/Catzc.Base.Files/Write-FileIfChanged.ps1` line 23
  (header), `automation/Catzc.Base.Files/Write-FileIfChanged.ps1` line 43 (header),
  `automation/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Build-CommentView.ps1` line 21 (header), `automation/Catzc.Base.QualityGates/Build-CommentView.ps1`
  line 29 (header), `automation/Catzc.Base.QualityGates/Export-Comments.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/Export-Comments.ps1` line 28 (header), `automation/Catzc.Base.QualityGates/Test-Comments.ps1` line 23
  (header), `automation/Catzc.Base.QualityGates/Test-Comments.ps1` line 29 (header),
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 574 (text),
  `automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1` line 23 (header),
  `automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.QualityGates/types/CommentBlockKind.cs` line 19 (text), `automation/Catzc.Base.QualityGates/types/CommentEngine.cs`
  line 21 (text), `automation/Catzc.Base.QualityGates/types/CommentPageMap.cs` line 21 (text) and
  `automation/Catzc.Base.QualityGates/types/CommentsConfig.cs` line 24 (text).

## Keywords

- [world map][73]
- [track][74]
- [file language][75]
- [cell][76]
- [lit cell][77]
- [.claude][78]: a track
- [automation][78]: a track
- [docs][78]: a track
- [pipelines][78]: a track
- [csharp][79]: a file language
- [markdown][79]: a file language
- [pipeline-yaml][79]: a file language
- [powershell][79]: a file language
- [yaml][79]: a file language

Terms the cited ADRs define:

- [go test module][80], defined by [ADR-AUTO-GO#2][81]

[1]: ../../../../docs/adr/automation/go/go-test-artifacts.md
[2]: ../../../../docs/adr/principles/one-living-version.md
[3]: ../../../../docs/how-to/getting-started/automation/go/index.md
[4]: ../../../../docs/references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md
[5]: ../../../../docs/references/agent-contracts.md
[6]: ../../../../docs/references/automation/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
[7]: ../../../../docs/references/automation/catzc-base-docs/types/CheckModes.cs.md
[8]: ../../../../docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[9]: ../../../../docs/references/automation/catzc-base-languages/Invoke-GoTest.ps1.md
[10]: ../../../../docs/references/automation/catzc-base-qualitygates/configs/comments.yml.md
[11]: ../../../../docs/references/automation/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
[12]: ../../../../docs/references/automation/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md
[13]: ../../../../docs/references/automation/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md
[14]: ../../../../docs/references/automation/catzc-base-qualitygates/types/CommentPageMap.cs.md
[15]: ../../../../docs/references/automation/catzc-base-qualitygates/types/CommentsConfig.cs.md
[16]: ../../../../docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md
[17]: ../../../../docs/references/automation/catzc-base-vscode/configs/vscode-settings.yml.md
[18]: ../../../../docs/references/automation/internal/Catzc.Internal.Importer.psm1.md
[19]: ../../../../docs/references/automation/internal/Catzc.Internal.Loader.psm1.md
[20]: ../../../../docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md
[21]: ../../../../.claude/CLAUDE.md
[22]: ../../../../.claude/plans/decisions-2026-10-16.md
[23]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[24]: ../../../../.claude/plans/plan-assert-wait.md
[25]: ../../../../.claude/plans/plan-bounded-folder-enumeration.md
[26]: ../../../../.claude/plans/plan-config-defaults.md
[27]: ../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[28]: ../../../../.claude/plans/plan-file-meta-head-policy.md
[29]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[30]: ../../../../.claude/plans/plan-materialization-of-knowledge.md
[31]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[32]: ../../../../.claude/plans/prompt-automation-layers-continue.md
[33]: ../../../../.claude/plans/prompt-config-defaults-continue.md
[34]: ../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[35]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[36]: ../../../../.claude/plans/questionnaire-2026-10-16.md
[37]: ../../../../automation/Catzc.Base.QualityGates/Build-CommentView.ps1
[38]: ../../../../automation/Catzc.Base.QualityGates/Export-Comments.ps1
[39]: ../../../../automation/Catzc.Base.QualityGates/Test-Comments.ps1
[40]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[41]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1
[42]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[43]: ../../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[44]: ../../../../automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1
[45]: ../../../../automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1
[46]: ../../../../automation/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1
[47]: ../../../../automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1
[48]: ../../../../automation/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1
[49]: ../../../../automation/Catzc.Base.QualityGates/types/CommentBlockKind.cs
[50]: ../../../../automation/Catzc.Base.QualityGates/types/CommentEngine.cs
[51]: ../../../../automation/Catzc.Base.QualityGates/types/CommentPageMap.cs
[52]: ../../../../automation/Catzc.Base.QualityGates/types/CommentsConfig.cs
[53]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[54]: ../../../../automation/Catzc.Base.Docs/configs/agents.yml
[55]: ../../../../automation/Catzc.Base.Docs/configs/capabilities.yml
[56]: ../../../../automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[57]: ../../../../automation/Catzc.Base.Docs/types/CheckModes.cs
[58]: ../../../../automation/Catzc.Base.Languages/Invoke-GoTest.ps1
[59]: ../../../../automation/Catzc.Base.Languages/Test-GeneratedFileCurrent.ps1
[60]: ../../../../automation/Catzc.Base.Languages/configs/glossary.yml
[61]: ../../../../automation/Catzc.Base.Languages/private/Get-EngineContract.ps1
[62]: ../../../../automation/Catzc.Base.Files/Get-InputStamp.ps1
[63]: ../../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[64]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[65]: ../../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[66]: ../../../../docs/adr/glossary.md
[67]: ../../../../docs/adr/index.md
[68]: ../../../../docs/adr/automation/dora-explains.md
[69]: ../../../../docs/adr/principles/dora-explains.md
[70]: ../../../../automation/Catzc.Base.Git/configs/gitignore.yml
[71]: ../../../../automation/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1
[72]: ../../../../pipelines/ci-automation.yaml
[73]: ../../../../docs/adr/glossary.md#world-map
[74]: ../../../../docs/adr/glossary.md#track
[75]: ../../../../docs/adr/glossary.md#file-language
[76]: ../../../../docs/adr/glossary.md#cell
[77]: ../../../../docs/adr/glossary.md#lit-cell
[78]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[79]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[80]: ../../../../docs/adr/glossary.md#go-test-module
[81]: ../../../../docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2

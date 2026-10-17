# docs/explanation/.assets/tree/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md

`Tree minimap: adr-auto-bundle--what-gates-each-bundle-stage--governance`

![Tree minimap of adr-auto-bundle--what-gates-each-bundle-stage--governance](adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.png)

The tree minimap of the slide `adr-auto-bundle--what-gates-each-bundle-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 37 files in 14 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Exporter (automation/Catzc.Base.Exporter): 9 lit files
- .unordered: 5 lit files
- .claude: 4 lit files
- docs (docs/ outside docs/adr/): 4 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/pwsh (docs/adr/pwsh): 2 lit files
- Root files: 1 lit file
- .github: 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Overlay (automation/Catzc.Base.Overlay): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Exporter (automation/Catzc.Base.Exporter, 9 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][3], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 22 (header) and line 29 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][4], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 22 (header), line 27 (header) and line 73 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][5], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 20 (header) and line 26 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][6], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 21 (header) and line 29 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][7], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 20 (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][8], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 22 (header) and line 28 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][9], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][10], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][11], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 21 (text).

### .unordered (5 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-built-bundle.md][12], in the cell .unordered × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 12 (text), line 41 (text), line 271 (text), line 306 (text), line 309 (text) and line 312 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][13], in the cell .unordered × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 104 (text).
- [.unordered/15-10-2026/plan-contracts.md][14], in the cell .unordered × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 99 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][15], in the cell .unordered × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 70 (text) and line 71 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 75 (text).
- [.unordered/15-10-2026/plan-test-runtime.md][16], in the cell .unordered × markdown: selected by [ADR-PWSH-MANIFEST][2]: the file cites it
  at line 163 (text) and line 163 (text).

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-format-step-moves-comments.md][17], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 120 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][18], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 25 (text), line 464 (text), line 526 (text) and line 891 (text).
- [.claude/plans/plan-module-kinds-tracks.md][19], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 348 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 40 (text), line 178 (text), line 287 (text), line 345
  (text), line 361 (text) and line 403 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][20], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 42 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 43 (text).

### docs (docs/ outside docs/adr/, 4 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-exporter/configs/exporter.yml.md][21], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 33 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterBundle.cs.md][22], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 32 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md][23], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 31 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 34 (text).

### .internal (automation/.internal, 2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][25], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 20 (header).
- [automation/.internal/assets/Import-ModuleFiles.ps1][26], in the cell automation × powershell: selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 19 (header).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][27], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 158 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 186 (text).
- [automation/Catzc.Base.Docs/configs/glossary.yml][28], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 490 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][29], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 501 (text).
- [docs/adr/index.md][30], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 169 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 195 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][31], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 487
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### adr/pwsh (docs/adr/pwsh, 2 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/dora-explains.md][32], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 116
  (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][33], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header); selected by
  [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/assets/Import-ModuleFiles.ps1` line 19 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][34], in the cell github-workflows × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 64 (body comment) (a passing mention only).

### Contracts (automation/Catzc.Base.Contracts, 1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][35], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 21 (header) and line 36 (header).

### Overlay (automation/Catzc.Base.Overlay, 1 lit file)

The group holds the files of automation/Catzc.Base.Overlay; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1][36], in the cell automation × powershell: selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 22 (header) and line 29 (header).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][37], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1` line 21 (header),
  `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1` line 36 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 158
  (text), `automation/Catzc.Base.Docs/configs/glossary.yml` line 490 (text), `automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1` line 22
  (header), `automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1` line 29 (header), `automation/Catzc.Base.Exporter/Build-Modules.ps1`
  line 22 (header), `automation/Catzc.Base.Exporter/Build-Modules.ps1` line 27 (header), `automation/Catzc.Base.Exporter/Build-Modules.ps1`
  line 73 (text), `automation/Catzc.Base.Exporter/Export-Catzc.ps1` line 20 (header), `automation/Catzc.Base.Exporter/Export-Catzc.ps1` line
  26 (header), `automation/Catzc.Base.Exporter/Install-Catzc.ps1` line 21 (header), `automation/Catzc.Base.Exporter/Install-Catzc.ps1` line
  29 (header), `automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1` line 20 (header),
  `automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1` line 28 (header),
  `automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1` line 22 (header),
  `automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1` line 28 (header),
  `automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1` line 21 (header),
  `automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1` line 26 (header),
  `automation/Catzc.Base.Exporter/types/ExporterBundle.cs` line 20 (text) and `automation/Catzc.Base.Exporter/types/ExporterConfig.cs` line
  21 (text); selected by [ADR-PWSH-MANIFEST][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/.internal/assets/Import-ModuleFiles.ps1` line 19 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 186 (text),
  `automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1` line 22 (header) and
  `automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1` line 29 (header).

## Keywords

- [world map][38]
- [track][39]
- [file language][40]
- [cell][41]
- [lit cell][42]
- [root file][43]
- [.claude][44]: a track
- [.unordered][44]: a track
- [automation][44]: a track
- [docs][44]: a track
- [github-workflows][44]: a track
- [pipelines][44]: a track
- [csharp][45]: a file language
- [markdown][45]: a file language
- [pipeline-yaml][45]: a file language
- [powershell][45]: a file language
- [yaml][45]: a file language

Terms the cited ADRs define:

- [bundle][46], defined by [ADR-AUTO-BUNDLE#1][47]

[1]: ../../../adr/automation/platform-bundle.md
[2]: ../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[4]: ../../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[5]: ../../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[6]: ../../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[7]: ../../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[8]: ../../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[9]: ../../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[10]: ../../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[11]: ../../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[12]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[13]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[14]: ../../../../.unordered/15-10-2026/plan-contracts.md
[15]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[16]: ../../../../.unordered/15-10-2026/plan-test-runtime.md
[17]: ../../../../.claude/plans/plan-format-step-moves-comments.md
[18]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[19]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[20]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[21]: ../../../references/automation/catzc-base-exporter/configs/exporter.yml.md
[22]: ../../../references/automation/catzc-base-exporter/types/ExporterBundle.cs.md
[23]: ../../../references/automation/catzc-base-exporter/types/ExporterConfig.cs.md
[24]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[25]: ../../../../automation/.internal/assets/Import-Catzc.ps1
[26]: ../../../../automation/.internal/assets/Import-ModuleFiles.ps1
[27]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[28]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[29]: ../../../adr/glossary.md
[30]: ../../../adr/index.md
[31]: ../../../adr/automation/dora-explains.md
[32]: ../../../adr/pwsh/dora-explains.md
[33]: ../../../../importer.ps1
[34]: ../../../../.github/workflows/ci-automation.yml
[35]: ../../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[36]: ../../../../automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1
[37]: ../../../../pipelines/ci-automation.yaml
[38]: ../../../adr/glossary.md#world-map
[39]: ../../../adr/glossary.md#track
[40]: ../../../adr/glossary.md#file-language
[41]: ../../../adr/glossary.md#cell
[42]: ../../../adr/glossary.md#lit-cell
[43]: ../../../adr/glossary.md#root-file
[44]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[45]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[46]: ../../../adr/glossary.md#bundle
[47]: ../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

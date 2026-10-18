# Every stage of the bundle has a rule, and two gates check it: the tree minimap

```text
Which files cite ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST: every file of the world map is a tile, grouped by top-level folder.
30 files lit in 11 groups.
```

![The tree minimap of Every stage of the bundle has a rule, and two gates check it](adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.png)

This is the tree minimap in the sidebar of the governance diagram of [Every stage of the bundle has a rule, and two gates check it][31],
which explains [ADR-AUTO-BUNDLE][1] and [ADR-PWSH-MANIFEST][2]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 30 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 14 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/pwsh (docs/adr/pwsh): 2 lit files
- Root files: 1 lit file
- .github: 1 lit file
- .internal (automation/.internal): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 14 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-contracts/Publish-ContractRelease.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 20 (text).
- [docs/references/automation/catzc-base-exporter/Assert-CatzcBundle.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md][5], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-exporter/Export-Catzc.ps1.md][6], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-exporter/Install-Catzc.ps1.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-exporter/configs/exporter.yml.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text).
- [docs/references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 14 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterBundle.cs.md][12], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 13 (text).
- [docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md][13], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-overlay/Get-FunctionFileViolation.ps1.md][14], in the cell docs × markdown: selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 16 (text).
- [docs/references/automation/internal/Catzc.Internal.Builder.psm1.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text).
- [docs/references/automation/internal/assets/Import-Catzc.ps1.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][17], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 495 (text), line 557 (text) and line 918 (text).
- [.claude/plans/plan-module-kinds-tracks.md][18], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 336 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 166 (text), line 275 (text), line 333 (text), line 349
  (text) and line 391 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][19], in the cell .claude × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 19 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 20 (text).

### Docs (automation/Catzc.Base.Docs, 2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 142 (text); selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 172 (text).
- [automation/Catzc.Base.Docs/configs/glossary.yml][21], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it
  at line 501 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 595 (text).
- [docs/adr/index.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 173 (text); selected by
  [ADR-PWSH-MANIFEST][2]: the file cites it at line 201 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 437
  (text).
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the ADR's own file.

### adr/pwsh (docs/adr/pwsh, 2 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/dora-explains.md][25], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the file cites it at line 61
  (text).
- [docs/adr/pwsh/dynamic-module-manifests.md][2], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][2]: the ADR's own file.

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][26], in the cell Root files × powershell: selected by [ADR-PWSH-MANIFEST][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-ModuleFiles.ps1` line 1 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][27], in the cell github-workflows × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 48 (body comment) (a passing mention only).

### .internal (automation/.internal, 1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-ModuleFiles.ps1][28], in the cell automation × powershell: selected by [ADR-PWSH-MANIFEST][2]: the
  file cites it at line 1 (header).

### Exporter (automation/Catzc.Base.Exporter, 1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Build-Modules.ps1][29], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][30], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-BUNDLE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 142 (text),
  `automation/Catzc.Base.Docs/configs/glossary.yml` line 501 (text) and `automation/Catzc.Base.Exporter/Build-Modules.ps1` line 2 (text);
  selected by [ADR-PWSH-MANIFEST][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/.internal/assets/Import-ModuleFiles.ps1` line 1 (header) and `automation/Catzc.Base.Docs/configs/adrs.yml` line 172 (text).

## Keywords

- [world map][32]
- [track][33]
- [file language][34]
- [cell][35]
- [lit cell][36]
- [root file][37]
- [.claude][38]: a track
- [automation][38]: a track
- [docs][38]: a track
- [github-workflows][38]: a track
- [pipelines][38]: a track
- [markdown][39]: a file language
- [pipeline-yaml][39]: a file language
- [powershell][39]: a file language
- [yaml][39]: a file language

Terms the cited ADRs define:

- [bundle][40], defined by [ADR-AUTO-BUNDLE#1][41]

[1]: ../../../adr/automation/platform-bundle.md
[2]: ../../../adr/pwsh/dynamic-module-manifests.md
[3]: ../../../references/automation/catzc-base-contracts/Publish-ContractRelease.ps1.md
[4]: ../../../references/automation/catzc-base-exporter/Assert-CatzcBundle.ps1.md
[5]: ../../../references/automation/catzc-base-exporter/Build-Modules.ps1.md
[6]: ../../../references/automation/catzc-base-exporter/Export-Catzc.ps1.md
[7]: ../../../references/automation/catzc-base-exporter/Install-Catzc.ps1.md
[8]: ../../../references/automation/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md
[9]: ../../../references/automation/catzc-base-exporter/configs/exporter.yml.md
[10]: ../../../references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
[11]: ../../../references/automation/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
[12]: ../../../references/automation/catzc-base-exporter/types/ExporterBundle.cs.md
[13]: ../../../references/automation/catzc-base-exporter/types/ExporterConfig.cs.md
[14]: ../../../references/automation/catzc-base-overlay/Get-FunctionFileViolation.ps1.md
[15]: ../../../references/automation/internal/Catzc.Internal.Builder.psm1.md
[16]: ../../../references/automation/internal/assets/Import-Catzc.ps1.md
[17]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[18]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[19]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[20]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../../automation/Catzc.Base.Docs/configs/glossary.yml
[22]: ../../../adr/glossary.md
[23]: ../../../adr/index.md
[24]: ../../../adr/automation/dora-explains.md
[25]: ../../../adr/pwsh/dora-explains.md
[26]: ../../../../importer.ps1
[27]: ../../../../.github/workflows/ci-automation.yml
[28]: ../../../../automation/.internal/assets/Import-ModuleFiles.ps1
[29]: ../../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[30]: ../../../../pipelines/ci-automation.yaml
[31]: ../../automation/what-gates-each-bundle-stage.md
[32]: ../../../adr/glossary.md#world-map
[33]: ../../../adr/glossary.md#track
[34]: ../../../adr/glossary.md#file-language
[35]: ../../../adr/glossary.md#cell
[36]: ../../../adr/glossary.md#lit-cell
[37]: ../../../adr/glossary.md#root-file
[38]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[40]: ../../../adr/glossary.md#bundle
[41]: ../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1

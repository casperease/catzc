# docs/.assets/explanation/tree/adr-dsgn-aspect--each-track-picks-its-catch-all--meta.tree.md

`Tree minimap: adr-dsgn-aspect--each-track-picks-its-catch-all--meta`

![Tree minimap of adr-dsgn-aspect--each-track-picks-its-catch-all--meta](adr-dsgn-aspect--each-track-picks-its-catch-all--meta.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--each-track-picks-its-catch-all--meta` (meta lens). The slide supports [ADR-DSGN-ASPECT][1];
the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 28 files in 11 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 7 lit files
- .unordered: 4 lit files
- Globs (automation/Catzc.Base.Globs): 4 lit files
- .claude: 3 lit files
- Modules (automation/Catzc.Base.Modules): 2 lit files
- Variants (automation/Catzc.Base.Variants): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][2], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 46 (text).
- [docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 27 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][4], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 17 (text), line 31 (text), line 44 (text) and line 72 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][5], in the cell docs × markdown: selected
  by [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 80 (text).
- [docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 31 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 48 (text).

### .unordered (4 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][9], in the cell .unordered × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 128 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][10], in the cell .unordered × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 94 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][11], in the cell .unordered × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 21 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][12], in the cell .unordered × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 55 (text), line 76 (text), line 103 (text) and line 103 (text).

### Globs (automation/Catzc.Base.Globs, 4 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][13], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 24 (header) and line 35 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][14], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 24 (header) and line 61 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.Globs/types/Aspect.cs][16], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 21 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][17], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 889 (text).
- [.claude/plans/plan-module-kinds-tracks.md][18], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 38 (text), line 222 (text), line 246 (text), line 278 (text), line 285 (text), line 371 (text), line 743 (text) and line 932 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][19], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 41 (text).

### Modules (automation/Catzc.Base.Modules, 2 lit files)

The group holds the files of automation/Catzc.Base.Modules; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Modules/Get-Aspect.ps1][20], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 21 (header) and line 26 (header).
- [automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1][21], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 20 (header).

### Variants (automation/Catzc.Base.Variants, 2 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/types/VariantAspect.cs][22], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][23], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 22 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][24], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 211
  (text).
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][25], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 101 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][26], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 22 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][27], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 115 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][28], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 101 (text),
  `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 24 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 35
  (header), `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 24 (header),
  `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 61 (text), `automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1`
  line 20 (header), `automation/Catzc.Base.Globs/types/Aspect.cs` line 21 (text), `automation/Catzc.Base.Modules/Get-Aspect.ps1` line 21
  (header), `automation/Catzc.Base.Modules/Get-Aspect.ps1` line 26 (header), `automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1` line
  20 (header), `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 22 (header),
  `automation/Catzc.Base.Variants/types/VariantAspect.cs` line 21 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  22 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [.claude][34]: a track
- [.unordered][34]: a track
- [automation][34]: a track
- [docs][34]: a track
- [pipelines][34]: a track
- [csharp][35]: a file language
- [markdown][35]: a file language
- [pipeline-yaml][35]: a file language
- [powershell][35]: a file language
- [yaml][35]: a file language

[1]: ../../../adr/design/module-aspects.md
[2]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[3]: ../../../references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
[4]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[5]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[6]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[7]: ../../../references/automation/catzc-base-variants/types/VariantAspect.cs.md
[8]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[9]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[10]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[11]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[12]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[13]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[14]: ../../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[15]: ../../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[16]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[17]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[18]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[19]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[20]: ../../../../automation/Catzc.Base.Modules/Get-Aspect.ps1
[21]: ../../../../automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1
[22]: ../../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[23]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[24]: ../../../adr/design/dora-explains.md
[25]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[26]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[27]: ../../../adr/index.md
[28]: ../../../../pipelines/ci-automation.yaml
[29]: ../../../adr/glossary.md#world-map
[30]: ../../../adr/glossary.md#track
[31]: ../../../adr/glossary.md#file-language
[32]: ../../../adr/glossary.md#cell
[33]: ../../../adr/glossary.md#lit-cell
[34]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[35]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

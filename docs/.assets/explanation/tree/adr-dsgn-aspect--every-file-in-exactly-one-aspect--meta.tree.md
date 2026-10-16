# docs/.assets/explanation/tree/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md

`Tree minimap: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta`

![Tree minimap of adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta` (meta lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 27 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 7 lit files
- .unordered: 4 lit files
- Globs (automation/Catzc.Base.Globs): 4 lit files
- .claude: 3 lit files
- Variants (automation/Catzc.Base.Variants): 3 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 7 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][2], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 45 (text).
- [docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][4], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 16 (text), line 30 (text), line 43 (text) and line 71 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][5], in the cell docs × markdown: selected
  by [ADR-DSGN-ASPECT][1]: the file cites it at line 39 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 79 (text).
- [docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 30 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 47 (text).

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
  cites it at line 23 (header) and line 34 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][14], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 23 (header) and line 60 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 19 (header).
- [automation/Catzc.Base.Globs/types/Aspect.cs][16], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 20 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][17], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 796 (text).
- [.claude/plans/plan-module-kinds-tracks.md][18], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 116 (text), line 140 (text), line 171 (text), line 178 (text), line 260 (text), line 609 (text) and line 799 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][19], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 18 (text).

### Variants (automation/Catzc.Base.Variants, 3 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][20], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 19 (header) and line 24 (header).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][21], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][22], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 21 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][23], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 210
  (text).
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][24], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 100 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][25], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 21 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][26], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 112 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][27], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 100 (text),
  `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 23 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 34
  (header), `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 23 (header),
  `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 60 (text), `automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Globs/types/Aspect.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 21 (header),
  `automation/Catzc.Base.Variants/Get-Aspect.ps1` line 19 (header), `automation/Catzc.Base.Variants/Get-Aspect.ps1` line 24 (header),
  `automation/Catzc.Base.Variants/types/VariantAspect.cs` line 20 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  21 (text).

## Keywords

- [world map][28]
- [track][29]
- [file language][30]
- [cell][31]
- [lit cell][32]
- [.claude][33]: a track
- [.unordered][33]: a track
- [automation][33]: a track
- [docs][33]: a track
- [pipelines][33]: a track
- [csharp][34]: a file language
- [markdown][34]: a file language
- [pipeline-yaml][34]: a file language
- [powershell][34]: a file language
- [yaml][34]: a file language

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
[20]: ../../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[21]: ../../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[22]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[23]: ../../../adr/design/dora-explains.md
[24]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[25]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[26]: ../../../adr/index.md
[27]: ../../../../pipelines/ci-automation.yaml
[28]: ../../../adr/glossary.md#world-map
[29]: ../../../adr/glossary.md#track
[30]: ../../../adr/glossary.md#file-language
[31]: ../../../adr/glossary.md#cell
[32]: ../../../adr/glossary.md#lit-cell
[33]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[34]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

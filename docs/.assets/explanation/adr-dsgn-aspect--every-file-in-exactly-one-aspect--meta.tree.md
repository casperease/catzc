# docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md

`Tree minimap: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta`

![Tree minimap of adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta` (meta lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 13 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Globs (automation/Catzc.Base.Globs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### Globs (automation/Catzc.Base.Globs, 4 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][2], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][3], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][4], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/types/Aspect.cs][5], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 1 (header), line 14 (header) and line 92 (body comment).

### Variants (automation/Catzc.Base.Variants, 4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][6], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][7], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][8], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][9], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][10], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 142
  (text).
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][11], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][12], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][13], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text).

## Keywords

- [world map][14]
- [track][15]
- [file language][16]
- [cell][17]
- [lit cell][18]
- [automation][7]: a track
- [docs][7]: a track
- [csharp][19]: a file language
- [markdown][19]: a file language
- [powershell][19]: a file language
- [yaml][19]: a file language

[1]: ../../adr/design/module-aspects.md
[2]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[3]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[4]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[5]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[6]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[7]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[8]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[9]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[10]: ../../adr/design/dora-explains.md
[11]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[13]: ../../adr/index.md
[14]: ../../adr/glossary.md#world-map
[15]: ../../adr/glossary.md#track
[16]: ../../adr/glossary.md#file-language
[17]: ../../adr/glossary.md#cell
[18]: ../../adr/glossary.md#lit-cell
[19]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md

`Tree minimap: adr-dsgn-aspect--one-folder-two-independent-readers--architecture`

![Tree minimap of adr-dsgn-aspect--one-folder-two-independent-readers--architecture](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--one-folder-two-independent-readers--architecture` (architecture lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 25 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 9 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- Globs (automation/Catzc.Base.Globs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][2], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][4], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][5], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][6], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][7], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][8], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][9], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### docs (5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/drop-a-file-the-import-exports-it.md][10], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 16 (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][11], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 14 (text), line 42 (text), line 44 (text), line 45 (text), line 46 (text), line 51 (text), line 53 (text) and line 55
  (text).
- [docs/explanation/design/manifest-and-aspects-from-one-folder.md][12], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 18 (text), line 53 (text), line 55 (text) and line 61 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][13], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 17 (text), line 51 (text), line 53 (text), line 55 (text), line 59 (text) and line 61 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 17 (text), line 21 (text), line 22 (text), line 45 (text), line 46 (text), line 48 (text),
  line 59 (text), line 60 (text), line 61 (text), line 65 (text) and line 67 (text).

### Globs (4 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][15], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][16], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][17], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/types/Aspect.cs][18], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 1 (header), line 14 (header) and line 92 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][19], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][20], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][21], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][22], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][23], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][24], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][25], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text).

## Keywords

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [automation][20]: a track
- [docs][20]: a track
- [csharp][31]: a file language
- [markdown][31]: a file language
- [powershell][31]: a file language
- [yaml][31]: a file language

[1]: ../../adr/design/module-aspects.md
[2]: ../../adr/design/commit-lifecycle.md
[3]: ../../adr/design/dora-explains.md
[4]: ../../adr/design/run-modes.md
[5]: ../../adr/design/self-service.md
[6]: ../../adr/design/server-remote-integration.md
[7]: ../../adr/design/thin-platforms.md
[8]: ../../adr/design/tracks.md
[9]: ../../adr/design/visual-design.md
[10]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[11]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[12]: ../../explanation/design/manifest-and-aspects-from-one-folder.md
[13]: ../../explanation/design/one-folder-two-independent-readers.md
[14]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[15]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[16]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[17]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[18]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[19]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[20]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[21]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[22]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[23]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[24]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[25]: ../../adr/index.md
[26]: ../../adr/glossary.md#world-map
[27]: ../../adr/glossary.md#track
[28]: ../../adr/glossary.md#file-language
[29]: ../../adr/glossary.md#cell
[30]: ../../adr/glossary.md#lit-cell
[31]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md

`Tree minimap: adr-dsgn-aspect--one-folder-two-independent-readers--architecture`

![Tree minimap of adr-dsgn-aspect--one-folder-two-independent-readers--architecture](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--one-folder-two-independent-readers--architecture` (architecture lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 30 files in 7 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 10 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Globs (automation/Catzc.Base.Globs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md][2], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md][3], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md][4], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][6], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 66 (text) and line 75 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][7], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 16 (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][8], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 14 (text), line 42 (text), line 44 (text), line 45 (text), line 46 (text), line 51 (text), line 53 (text) and line 55
  (text).
- [docs/explanation/design/manifest-and-aspects-from-one-folder.md][9], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 18 (text), line 53 (text), line 55 (text) and line 61 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][10], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 17 (text), line 51 (text), line 53 (text), line 55 (text), line 59 (text) and line 61 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 17 (text), line 21 (text), line 22 (text), line 45 (text), line 46 (text), line 48 (text),
  line 59 (text), line 60 (text), line 61 (text), line 65 (text) and line 67 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][12], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][14], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][15], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][16], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][17], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][18], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][19], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Globs (4 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][20], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][21], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][22], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/types/Aspect.cs][23], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 1 (header), line 14 (header) and line 92 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][24], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][25], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][26], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][27], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][28], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][29], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][30], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [automation][25]: a track
- [docs][25]: a track
- [csharp][36]: a file language
- [markdown][36]: a file language
- [powershell][36]: a file language
- [yaml][36]: a file language

[1]: ../../adr/design/module-aspects.md
[2]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md
[3]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md
[4]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md
[5]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md
[6]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[7]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[8]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[9]: ../../explanation/design/manifest-and-aspects-from-one-folder.md
[10]: ../../explanation/design/one-folder-two-independent-readers.md
[11]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[12]: ../../adr/design/commit-lifecycle.md
[13]: ../../adr/design/dora-explains.md
[14]: ../../adr/design/run-modes.md
[15]: ../../adr/design/self-service.md
[16]: ../../adr/design/server-remote-integration.md
[17]: ../../adr/design/thin-platforms.md
[18]: ../../adr/design/tracks.md
[19]: ../../adr/design/visual-design.md
[20]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[21]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[22]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[23]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[24]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[25]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[27]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[28]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[30]: ../../adr/index.md
[31]: ../../adr/glossary.md#world-map
[32]: ../../adr/glossary.md#track
[33]: ../../adr/glossary.md#file-language
[34]: ../../adr/glossary.md#cell
[35]: ../../adr/glossary.md#lit-cell
[36]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

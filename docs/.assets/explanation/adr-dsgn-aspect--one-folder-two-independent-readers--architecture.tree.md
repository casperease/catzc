# docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md

`Tree minimap: adr-dsgn-aspect--one-folder-two-independent-readers--architecture`

![Tree minimap of adr-dsgn-aspect--one-folder-two-independent-readers--architecture](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--one-folder-two-independent-readers--architecture` (architecture lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 45 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 25 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Globs (automation/Catzc.Base.Globs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (25 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md][2], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md][3], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.tree.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83
  (text), line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line 39 (text),
  line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text), line 66
  (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text),
  line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83 (text),
  line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md][10], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text) and line 34
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md][11], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md][12], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.tree.md][13], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83
  (text), line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md][14], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md][15], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83
  (text), line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][18], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text) and line 38
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][19], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 66 (text) and line 75 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][20], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 46 (text), line 61 (text), line 62 (text), line 89
  (text), line 120 (text), line 134 (text), line 148 (text), line 153 (text), line 162 (text), line 172 (text), line 182 (text), line 184
  (text), line 187 (text), line 189 (text), line 191 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 225
  (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 247 (text), line 334 (text), line 336 (text), line 339
  (text), line 341 (text) and line 344 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md][21], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 52 (text), line 91 (text), line 104 (text), line 113
  (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 172 (text), line 175 (text), line 178
  (text), line 181 (text), line 185 (text), line 333 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 343
  (text), line 345 (text), line 347 (text), line 349 (text), line 365 (text), line 423 (text), line 438 (text), line 440 (text), line 442
  (text), line 444 (text) and line 463 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][22], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 16 (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][23], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 14 (text), line 42 (text), line 44 (text), line 45 (text), line 46 (text), line 51 (text), line 53 (text) and line 55
  (text).
- [docs/explanation/design/manifest-and-aspects-from-one-folder.md][24], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 18 (text), line 53 (text), line 55 (text) and line 61 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][25], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 17 (text), line 51 (text), line 53 (text), line 55 (text), line 59 (text) and line 61 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][26], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 17 (text), line 21 (text), line 22 (text), line 45 (text), line 46 (text), line 48 (text),
  line 59 (text), line 60 (text), line 61 (text), line 65 (text) and line 67 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][27], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][28], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][29], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][30], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][31], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][32], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][33], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][34], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Globs (4 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][35], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][37], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/types/Aspect.cs][38], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 1 (header), line 14 (header) and line 92 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][39], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][40], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites
  it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][41], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][42], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][43], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][44], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][45], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text).

## Keywords

- [world map][46]
- [track][47]
- [file language][48]
- [cell][49]
- [lit cell][50]
- [automation][40]: a track
- [docs][40]: a track
- [csharp][51]: a file language
- [markdown][51]: a file language
- [powershell][51]: a file language
- [yaml][51]: a file language

[1]: ../../adr/design/module-aspects.md
[2]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md
[3]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md
[4]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md
[5]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.tree.md
[6]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md
[7]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md
[8]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md
[9]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md
[10]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md
[11]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md
[12]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md
[13]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.tree.md
[14]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md
[15]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md
[16]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md
[17]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md
[18]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[19]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[20]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[21]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
[22]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[23]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[24]: ../../explanation/design/manifest-and-aspects-from-one-folder.md
[25]: ../../explanation/design/one-folder-two-independent-readers.md
[26]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[27]: ../../adr/design/commit-lifecycle.md
[28]: ../../adr/design/dora-explains.md
[29]: ../../adr/design/run-modes.md
[30]: ../../adr/design/self-service.md
[31]: ../../adr/design/server-remote-integration.md
[32]: ../../adr/design/thin-platforms.md
[33]: ../../adr/design/tracks.md
[34]: ../../adr/design/visual-design.md
[35]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[36]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[37]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[38]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[39]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[40]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[41]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[42]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[43]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[44]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[45]: ../../adr/index.md
[46]: ../../adr/glossary.md#world-map
[47]: ../../adr/glossary.md#track
[48]: ../../adr/glossary.md#file-language
[49]: ../../adr/glossary.md#cell
[50]: ../../adr/glossary.md#lit-cell
[51]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

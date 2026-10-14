# docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md

`Grid minimap: adr-dsgn-aspect--one-folder-two-independent-readers--architecture`

![Grid minimap of adr-dsgn-aspect--one-folder-two-independent-readers--architecture](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-aspect--one-folder-two-independent-readers--architecture` (architecture lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 3 lit of 219 files
- automation × powershell: 5 lit of 1412 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 15 lit of 742 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/types/Aspect.cs][5]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 1 (header), line 14 (header)
  and line 92 (body comment).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][6]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][7]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 18 (header).

### automation × powershell (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][8]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 6 (header), line 10
  (header) and line 83 (body comment).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][9]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][10]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 1 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][11]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 54 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/Get-Aspect.ps1][12]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 6 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 102 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][14]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 30 (body comment)
  (a passing mention only).

### docs × markdown (15 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][15]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][16]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][1]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][17]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][18]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][19]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][20]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][21]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][22]: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][23]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][24]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 16 (text),
  line 46 (text) and line 48 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][25]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 14 (text),
  line 42 (text), line 44 (text), line 45 (text), line 46 (text), line 51 (text), line 53 (text) and line 55 (text).
- [docs/explanation/design/manifest-and-aspects-from-one-folder.md][26]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 18
  (text), line 53 (text), line 55 (text) and line 61 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][27]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 17
  (text), line 51 (text), line 53 (text), line 55 (text), line 59 (text) and line 61 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][28]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line
  17 (text), line 21 (text), line 22 (text), line 45 (text), line 46 (text), line 48 (text), line 59 (text), line 60 (text), line 61 (text),
  line 65 (text) and line 67 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [automation][14]: a track
- [docs][14]: a track
- [csharp][34]: a file language
- [markdown][34]: a file language
- [powershell][34]: a file language
- [yaml][34]: a file language

[1]: ../../adr/design/module-aspects.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[6]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[7]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[8]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[9]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[10]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[11]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[12]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[13]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[15]: ../../adr/design/commit-lifecycle.md
[16]: ../../adr/design/dora-explains.md
[17]: ../../adr/design/run-modes.md
[18]: ../../adr/design/self-service.md
[19]: ../../adr/design/server-remote-integration.md
[20]: ../../adr/design/thin-platforms.md
[21]: ../../adr/design/tracks.md
[22]: ../../adr/design/visual-design.md
[23]: ../../adr/index.md
[24]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[25]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[26]: ../../explanation/design/manifest-and-aspects-from-one-folder.md
[27]: ../../explanation/design/one-folder-two-independent-readers.md
[28]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[29]: ../../adr/glossary.md#world-map
[30]: ../../adr/glossary.md#track
[31]: ../../adr/glossary.md#file-language
[32]: ../../adr/glossary.md#cell
[33]: ../../adr/glossary.md#lit-cell
[34]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md

`Grid minimap: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations`

![Grid minimap of adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations](adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.png)

The grid minimap of the slide `adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations` (operations lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 3 lit of 229 files
- automation × powershell: 5 lit of 1443 files
- automation × yaml: 2 lit of 97 files
- docs × markdown: 10 lit of 744 files

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

### docs × markdown (10 lit files)

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

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [automation][14]: a track
- [docs][14]: a track
- [csharp][29]: a file language
- [markdown][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

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
[24]: ../../adr/glossary.md#world-map
[25]: ../../adr/glossary.md#track
[26]: ../../adr/glossary.md#file-language
[27]: ../../adr/glossary.md#cell
[28]: ../../adr/glossary.md#lit-cell
[29]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

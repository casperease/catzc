# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md

`Grid minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Grid minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 8 lit of 1445 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 5 lit of 745 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][6]: selected by [ADR-AZ-CLI][1]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][7]: selected by [ADR-AZ-CLI][1]: the file cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][8]: selected by [ADR-AZ-CLI][1]: the file cites it at line 14
  (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][9]: selected by [ADR-AZ-CLI][1]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][10]: selected by [ADR-AZ-CLI][1]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][11]: selected by [ADR-AZ-CLI][1]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][12]: selected by [ADR-AZ-CLI][1]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][13]: selected by [ADR-AZ-CLI][1]: the file cites it at line 13 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-AZ-CLI][1]: the file cites it at line 271 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][15]: selected by [ADR-AZ-CLI][1]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][16]: selected by [ADR-AZ-CLI][1]: the file cites it at line 586 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 670 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/dora-explains.md][17]: selected by [ADR-AZ-CLI][1]: the file cites it at line 342 (text).
- [docs/adr/azure/prefer-az-cli.md][1]: selected by [ADR-AZ-CLI][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][18]: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 29 (text).
- [docs/adr/design/thin-platforms.md][2]: selected by [ADR-DSGN-THINPLAT][2]: the ADR's own file.
- [docs/adr/index.md][19]: selected by [ADR-AZ-CLI][1]: the file cites it at line 253 (text); selected by [ADR-DSGN-THINPLAT][2]: the file
  cites it at line 89 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [automation][25]: a track
- [docs][25]: a track
- [markdown][26]: a file language
- [powershell][26]: a file language
- [yaml][26]: a file language

[1]: ../../adr/azure/prefer-az-cli.md
[2]: ../../adr/design/thin-platforms.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[7]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[8]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[9]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[10]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[11]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[12]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[13]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[14]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[16]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[17]: ../../adr/azure/dora-explains.md
[18]: ../../adr/design/dora-explains.md
[19]: ../../adr/index.md
[20]: ../../adr/glossary.md#world-map
[21]: ../../adr/glossary.md#track
[22]: ../../adr/glossary.md#file-language
[23]: ../../adr/glossary.md#cell
[24]: ../../adr/glossary.md#lit-cell
[25]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

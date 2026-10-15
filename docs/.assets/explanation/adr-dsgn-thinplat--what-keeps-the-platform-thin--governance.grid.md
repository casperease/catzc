# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md

`Grid minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Grid minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AUTO-PARITY][1], [ADR-AZ-CLI][2] and [ADR-DSGN-THINPLAT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 9 lit of 1443 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 7 lit of 744 files
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### automation × powershell (9 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][7]: selected by [ADR-AZ-CLI][2]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][8]: selected by [ADR-AZ-CLI][2]: the file cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][9]: selected by [ADR-AZ-CLI][2]: the file cites it at line 14
  (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][10]: selected by [ADR-AZ-CLI][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][11]: selected by [ADR-AZ-CLI][2]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][12]: selected by [ADR-AZ-CLI][2]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][13]: selected by [ADR-AZ-CLI][2]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][14]: selected by [ADR-AZ-CLI][2]: the file cites it at line 13 (header).
- [automation/Catzc.Base.Repository/Get-RunEnvironment.ps1][15]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 6 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 137 (text); selected by
  [ADR-AZ-CLI][2]: the file cites it at line 270 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][17]: selected by [ADR-AZ-CLI][2]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][18]: selected by [ADR-AZ-CLI][2]: the file cites it at line 586 (text);
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 670 (text).

### docs × markdown (7 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/automation/devbox-pipeline-parity.md][1]: selected by [ADR-AUTO-PARITY][1]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][19]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 13 (text).
- [docs/adr/azure/dora-explains.md][20]: selected by [ADR-AZ-CLI][2]: the file cites it at line 342 (text).
- [docs/adr/azure/prefer-az-cli.md][2]: selected by [ADR-AZ-CLI][2]: the ADR's own file.
- [docs/adr/design/dora-explains.md][21]: selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 29 (text).
- [docs/adr/design/thin-platforms.md][3]: selected by [ADR-DSGN-THINPLAT][3]: the ADR's own file.
- [docs/adr/index.md][22]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 125 (text); selected by [ADR-AZ-CLI][2]: the file
  cites it at line 252 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 89 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][23]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][24]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.gitattributes][25]: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).
- [.gitignore][26]: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).

## Keywords

- [world map][27]
- [track][28]
- [file language][29]
- [cell][30]
- [lit cell][31]
- [root file][32]
- [unlisted file][33]
- [automation][34]: a track
- [docs][34]: a track
- [markdown][35]: a file language
- [powershell][35]: a file language
- [yaml][35]: a file language

[1]: ../../adr/automation/devbox-pipeline-parity.md
[2]: ../../adr/azure/prefer-az-cli.md
[3]: ../../adr/design/thin-platforms.md
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[8]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[9]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[10]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[11]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[12]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[13]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[14]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[15]: ../../../automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
[16]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[18]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[19]: ../../adr/automation/dora-explains.md
[20]: ../../adr/azure/dora-explains.md
[21]: ../../adr/design/dora-explains.md
[22]: ../../adr/index.md
[23]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[24]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[25]: ../../../.gitattributes
[26]: ../../../.gitignore
[27]: ../../adr/glossary.md#world-map
[28]: ../../adr/glossary.md#track
[29]: ../../adr/glossary.md#file-language
[30]: ../../adr/glossary.md#cell
[31]: ../../adr/glossary.md#lit-cell
[32]: ../../adr/glossary.md#root-file
[33]: ../../adr/glossary.md#unlisted-file
[34]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[35]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

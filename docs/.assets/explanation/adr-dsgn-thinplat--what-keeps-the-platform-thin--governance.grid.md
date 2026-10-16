# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md

`Grid minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Grid minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 51 files
- .unordered × markdown: 2 lit of 20 files
- automation × powershell: 8 lit of 1563 files
- automation × yaml: 3 lit of 107 files
- docs × markdown: 5 lit of 1985 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][6]: selected by [ADR-AZ-CLI][1]: the file cites it at line 137 (text).

### .unordered × markdown (2 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.unordered/15-10-2026/plan-concern-axis.md][7]: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 88 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][8]: selected by [ADR-AZ-CLI][1]: the file cites it at line 42 (text), line 50 (text) and
  line 61 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 81 (text).

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][9]: selected by [ADR-AZ-CLI][1]: the file cites it at line 21 (header) and line 31
  (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][10]: selected by [ADR-AZ-CLI][1]: the file cites it at line 20 (header) and line 35
  (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][11]: selected by [ADR-AZ-CLI][1]: the file cites it at line 21
  (header) and line 34 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][12]: selected by [ADR-AZ-CLI][1]: the file cites it at line 20 (header)
  and line 40 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][13]: selected by [ADR-AZ-CLI][1]: the file cites it at line 19 (header) and line 29
  (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][14]: selected by [ADR-AZ-CLI][1]: the file cites it at line 21 (header) and line 34
  (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][15]: selected by [ADR-AZ-CLI][1]: the file cites it at line 20 (header) and line 34
  (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][16]: selected by [ADR-AZ-CLI][1]: the file cites it at line 20 (header)
  and line 32 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17]: selected by [ADR-AZ-CLI][1]: the file cites it at line 270 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 92 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][18]: selected by [ADR-AZ-CLI][1]: the file cites it at line 25 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][19]: selected by [ADR-AZ-CLI][1]: the file cites it at line 580 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 670 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/azure/dora-explains.md][20]: selected by [ADR-AZ-CLI][1]: the file cites it at line 125 (text).
- [docs/adr/azure/prefer-az-cli.md][1]: selected by [ADR-AZ-CLI][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][21]: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 66 (text).
- [docs/adr/design/thin-platforms.md][2]: selected by [ADR-DSGN-THINPLAT][2]: the ADR's own file.
- [docs/adr/index.md][22]: selected by [ADR-AZ-CLI][1]: the file cites it at line 273 (text); selected by [ADR-DSGN-THINPLAT][2]: the file
  cites it at line 104 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][23]: selected by [ADR-AZ-CLI][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1` line 21 (header), `automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1`
  line 31 (header), `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 20 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 35 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 34 (header),
  `automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1` line 20 (header),
  `automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1` line 40 (header), `automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1`
  line 19 (header), `automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1` line 29 (header), `automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1`
  line 21 (header), `automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1` line 34 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1`
  line 20 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1` line 34 (header),
  `automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1` line 20 (header),
  `automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1` line 32 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 270
  (text), `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 25 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 580 (text); selected by [ADR-DSGN-THINPLAT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 92 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 670 (text).

## Keywords

- [world map][24]
- [track][25]
- [file language][26]
- [cell][27]
- [lit cell][28]
- [.claude][29]: a track
- [.unordered][29]: a track
- [automation][29]: a track
- [docs][29]: a track
- [pipelines][29]: a track
- [markdown][30]: a file language
- [pipeline-yaml][30]: a file language
- [powershell][30]: a file language
- [yaml][30]: a file language

[1]: ../../adr/azure/prefer-az-cli.md
[2]: ../../adr/design/thin-platforms.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[7]: ../../../.unordered/15-10-2026/plan-concern-axis.md
[8]: ../../../.unordered/15-10-2026/plan-explanation-drift.md
[9]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[10]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[11]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[12]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[13]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[14]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[15]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[16]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[17]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[19]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[20]: ../../adr/azure/dora-explains.md
[21]: ../../adr/design/dora-explains.md
[22]: ../../adr/index.md
[23]: ../../../pipelines/ci-automation.yaml
[24]: ../../adr/glossary.md#world-map
[25]: ../../adr/glossary.md#track
[26]: ../../adr/glossary.md#file-language
[27]: ../../adr/glossary.md#cell
[28]: ../../adr/glossary.md#lit-cell
[29]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[30]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

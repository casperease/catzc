# docs/explanation/.assets/grid/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md

`Grid minimap: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation`

![Grid minimap of adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation](adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation` (implementation lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .unordered × markdown: 2 lit of 20 files
- automation × yaml: 2 lit of 109 files
- docs × markdown: 3 lit of 2165 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .unordered × markdown (2 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-concern-axis.md][5]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 88 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][6]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 81 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][7]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 93 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][8]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 671 (text).

### docs × markdown (3 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][9]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 67 (text).
- [docs/adr/design/thin-platforms.md][1]: selected by [ADR-DSGN-THINPLAT][1]: the ADR's own file.
- [docs/adr/index.md][10]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 107 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][11]: selected by [ADR-DSGN-THINPLAT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 93 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 671 (text).

## Keywords

- [world map][12]
- [track][13]
- [file language][14]
- [cell][15]
- [lit cell][16]
- [.unordered][17]: a track
- [automation][17]: a track
- [docs][17]: a track
- [pipelines][17]: a track
- [markdown][18]: a file language
- [pipeline-yaml][18]: a file language
- [yaml][18]: a file language

[1]: ../../../adr/design/thin-platforms.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[6]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[7]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[9]: ../../../adr/design/dora-explains.md
[10]: ../../../adr/index.md
[11]: ../../../../pipelines/ci-automation.yaml
[12]: ../../../adr/glossary.md#world-map
[13]: ../../../adr/glossary.md#track
[14]: ../../../adr/glossary.md#file-language
[15]: ../../../adr/glossary.md#cell
[16]: ../../../adr/glossary.md#lit-cell
[17]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[18]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

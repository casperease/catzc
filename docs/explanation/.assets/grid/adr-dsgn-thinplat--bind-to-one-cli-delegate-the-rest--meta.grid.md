---
catzc:
  immutable:
    with_body_sha: "07e0a0c21ebb"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
    source: docs/explanation/.assets/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Consumers bind to one CLI, and everything behind it is delegated to the vendor: the world-map minimap

```text
Where the files that cite ADR-DSGN-THINPLAT sit in the repository: tracks down, file languages across.
3 of 342 cells lit, holding 6 files.
```

![The world-map minimap of Consumers bind to one CLI, and everything behind it is delegated to the vendor](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [Consumers bind to one CLI, and everything behind it is delegated to the
vendor][10], which explains [ADR-DSGN-THINPLAT][1]. It lights every cell of the world map that holds a file citing those codes, so it shows
where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 2 lit of 112 files
- docs × markdown: 3 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 75 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][6]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 657 (text).

### docs × markdown (3 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][7]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 27 (text).
- [docs/adr/design/thin-platforms.md][1]: selected by [ADR-DSGN-THINPLAT][1]: the ADR's own file.
- [docs/adr/index.md][8]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 109 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][9]: selected by [ADR-DSGN-THINPLAT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 75 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 657 (text).

## Keywords

- [world map][11]
- [track][12]
- [file language][13]
- [cell][14]
- [lit cell][15]
- [automation][16]: a track
- [docs][16]: a track
- [pipelines][16]: a track
- [markdown][17]: a file language
- [pipeline-yaml][17]: a file language
- [yaml][17]: a file language

[1]: ../../../adr/design/thin-platforms.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[7]: ../../../adr/design/dora-explains.md
[8]: ../../../adr/index.md
[9]: ../../../../pipelines/ci-automation.yaml
[10]: ../../design/bind-to-one-cli-delegate-the-rest.md
[11]: ../../../adr/glossary.md#world-map
[12]: ../../../adr/glossary.md#track
[13]: ../../../adr/glossary.md#file-language
[14]: ../../../adr/glossary.md#cell
[15]: ../../../adr/glossary.md#lit-cell
[16]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[17]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

---
catzc:
  immutable:
    with_body_sha: f3abc6d49a3f
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
    source: docs/explanation/.assets/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The first configured credential wins, and it must prove its org: the world-map minimap

```text
Where the files that cite ADR-PIPE-AUTH sit in the repository: tracks down, file languages across.
3 of 342 cells lit, holding 5 files.
```

![The world-map minimap of The first configured credential wins, and it must prove its org](adr-pipe-auth--configured-credential-proves-its-org--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [The first configured credential wins, and it must prove its org][9],
which explains [ADR-PIPE-AUTH][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the
decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 1 lit of 112 files
- docs × markdown: 3 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 223 (text).

### docs × markdown (3 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/index.md][6]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 250 (text).
- [docs/adr/pipelines/dora-explains.md][7]: selected by [ADR-PIPE-AUTH][1]: the file cites it at line 11 (text).
- [docs/adr/pipelines/dual-authentication.md][1]: selected by [ADR-PIPE-AUTH][1]: the ADR's own file.

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][8]: selected by [ADR-PIPE-AUTH][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 223 (text).

## Keywords

- [world map][10]
- [track][11]
- [file language][12]
- [cell][13]
- [lit cell][14]
- [automation][15]: a track
- [docs][15]: a track
- [pipelines][15]: a track
- [markdown][16]: a file language
- [pipeline-yaml][16]: a file language
- [yaml][16]: a file language

[1]: ../../../adr/pipelines/dual-authentication.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../adr/index.md
[7]: ../../../adr/pipelines/dora-explains.md
[8]: ../../../../pipelines/ci-automation.yaml
[9]: ../../pipelines/configured-credential-proves-its-org.md
[10]: ../../../adr/glossary.md#world-map
[11]: ../../../adr/glossary.md#track
[12]: ../../../adr/glossary.md#file-language
[13]: ../../../adr/glossary.md#cell
[14]: ../../../adr/glossary.md#lit-cell
[15]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[16]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

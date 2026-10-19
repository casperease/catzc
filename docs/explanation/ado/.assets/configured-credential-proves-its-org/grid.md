---
catzc:
  immutable:
    with_body_sha: "1d7977b639b9"
    warning: "Do Not Edit, this file is generated"
    repo_status: locked
    path: docs/explanation/ado/.assets/configured-credential-proves-its-org/grid.md
    source: docs/explanation/ado/.assets/configured-credential-proves-its-org/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The first configured credential wins, and it must prove its org: the world-map minimap

```text
Where the files that cite ADR-ADO-AUTH sit in the repository: tracks down, file languages across.
4 of 323 cells lit, holding 6 files.
```

![The world-map minimap of The first configured credential wins, and it must prove its org](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [The first configured credential wins, and it must prove its org][8],
which explains [ADR-ADO-AUTH][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the decision
lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 17 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (270 of the 323 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 55 files
- ado-pipelines × pipeline-yaml: 1 lit of 14 files
- docs × markdown: 3 lit of 2794 files
- pwsh × yaml: 1 lit of 117 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-ado-and-cicd-docs.md][3]: selected by [ADR-ADO-AUTH][1]: the file cites it at line 42 (text).

### ado-pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `.ado/` names the track ado-pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.ado/pipelines/ci-automation.yaml][4]: selected by [ADR-ADO-AUTH][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 225 (text).

### docs × markdown (3 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/ado/dora-explains.md][5]: selected by [ADR-ADO-AUTH][1]: the file cites it at line 11 (text).
- [docs/adr/ado/dual-authentication.md][1]: selected by [ADR-ADO-AUTH][1]: the ADR's own file.
- [docs/adr/index.md][6]: selected by [ADR-ADO-AUTH][1]: the file cites it at line 252 (text).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][7]: selected by [ADR-ADO-AUTH][1]: the file cites it at line 225 (text).

## Keywords

- [world map][9]
- [track][10]
- [file language][11]
- [cell][12]
- [lit cell][13]
- [.claude][14]: a track
- [ado-pipelines][14]: a track
- [docs][14]: a track
- [pwsh][14]: a track
- [markdown][15]: a file language
- [pipeline-yaml][15]: a file language
- [yaml][15]: a file language

[1]: ../../../../adr/ado/dual-authentication.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-ado-and-cicd-docs.md
[4]: ../../../../../.ado/pipelines/ci-automation.yaml
[5]: ../../../../adr/ado/dora-explains.md
[6]: ../../../../adr/index.md
[7]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../configured-credential-proves-its-org.md
[9]: ../../../../adr/glossary.md#world-map
[10]: ../../../../adr/glossary.md#track
[11]: ../../../../adr/glossary.md#file-language
[12]: ../../../../adr/glossary.md#cell
[13]: ../../../../adr/glossary.md#lit-cell
[14]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[15]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

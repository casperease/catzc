---
catzc:
  immutable:
    with_body_sha: "8fe6a0c724d2"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.grid.md
    source: docs/explanation/.assets/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One function answers "am I in a pipeline?", and every branch on context asks it: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD-DETECT sit in the repository: tracks down, file languages across.
3 of 342 cells lit, holding 11 files.
```

![The world-map minimap of One function answers "am I in a pipeline?", and every branch on context asks it](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [One function answers "am I in a pipeline?", and every branch on context
asks it][15], which explains [ADR-FLOW-CD-DETECT][1]. It lights every cell of the world map that holds a file citing those codes, so it
shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 2 lit of 112 files
- docs × markdown: 8 lit of 2742 files
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

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 99 (text).
- [pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][6]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text).

### docs × markdown (8 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/dora-explains.md][7]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 49 (text).
- [docs/adr/flow/pipeline-detection.md][1]: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.
- [docs/adr/index.md][8]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 131 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][9]: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][10]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at
  line 58 (text).
- [docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][11]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][12]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 26 (text) and line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][13]: selected by [ADR-FLOW-CD-DETECT][1]: the file cites
  it at line 11 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][14]: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 99 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [automation][21]: a track
- [docs][21]: a track
- [pipelines][21]: a track
- [markdown][22]: a file language
- [pipeline-yaml][22]: a file language
- [yaml][22]: a file language

[1]: ../../../../adr/flow/pipeline-detection.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[7]: ../../../../adr/flow/dora-explains.md
[8]: ../../../../adr/index.md
[9]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[10]: ../../../../references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[11]: ../../../../references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[12]: ../../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[13]: ../../../../references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[14]: ../../../../../pipelines/ci-automation.yaml
[15]: ../../one-boolean-answer-from-one-function.md
[16]: ../../../../adr/glossary.md#world-map
[17]: ../../../../adr/glossary.md#track
[18]: ../../../../adr/glossary.md#file-language
[19]: ../../../../adr/glossary.md#cell
[20]: ../../../../adr/glossary.md#lit-cell
[21]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

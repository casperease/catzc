# One artifact is built once and climbs to production unchanged: the world-map minimap

```text
Where the files that cite ADR-FLOW-CD sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 17 files.
```

![The world-map minimap of One artifact is built once and climbs to production unchanged](adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [One artifact is built once and climbs to production unchanged][21],
which explains [ADR-FLOW-CD][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the decision
lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 91 files
- automation × csharp: 2 lit of 286 files
- automation × powershell: 3 lit of 1618 files
- automation × yaml: 3 lit of 112 files
- docs × markdown: 7 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD][1]: the file cites it at line 52 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 23 (text).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 22 (header) and line
  41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (header) and line 49
  (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20
  (header), line 93 (text) and line 94 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 116 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 37 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 77 (text).

### docs × markdown (7 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 42 (text).
- [docs/adr/glossary.md][15]: selected by [ADR-FLOW-CD][1]: the file cites it at line 497 (text) and line 510 (text).
- [docs/adr/index.md][16]: selected by [ADR-FLOW-CD][1]: the file cites it at line 129 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 59 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51
  (text), line 52 (text), line 80 (text) and line 81 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20
  (text) and line 57 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][20]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 28
  (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 23 (text), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1`
  line 22 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 41 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 21 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49
  (header), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 37 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 77 (text).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [.claude][27]: a track
- [automation][27]: a track
- [docs][27]: a track
- [pipelines][27]: a track
- [csharp][28]: a file language
- [markdown][28]: a file language
- [pipeline-yaml][28]: a file language
- [powershell][28]: a file language
- [yaml][28]: a file language

Terms the cited ADRs define:

- [gate][29], defined by [ADR-FLOW-CD#13][30]
- [release candidate][31], defined by [ADR-FLOW-CD#14][32]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/CLAUDE.md
[6]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[7]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[8]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[9]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[10]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[11]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[13]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[14]: ../../../adr/flow/dora-explains.md
[15]: ../../../adr/glossary.md
[16]: ../../../adr/index.md
[17]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[18]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[19]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[20]: ../../../../pipelines/ci-automation.yaml
[21]: ../../flow/one-artifact-climbs-unchanged.md
[22]: ../../../adr/glossary.md#world-map
[23]: ../../../adr/glossary.md#track
[24]: ../../../adr/glossary.md#file-language
[25]: ../../../adr/glossary.md#cell
[26]: ../../../adr/glossary.md#lit-cell
[27]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[29]: ../../../adr/glossary.md#gate
[30]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[31]: ../../../adr/glossary.md#release-candidate
[32]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

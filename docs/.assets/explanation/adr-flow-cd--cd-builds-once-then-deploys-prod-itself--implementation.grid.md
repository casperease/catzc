# docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md

`Grid minimap: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation`

![Grid minimap of adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.png)

The grid minimap of the slide `adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation` (implementation lens). The slide
supports [ADR-FLOW-CD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × csharp: 2 lit of 229 files
- automation × powershell: 3 lit of 1443 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 8 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 105 (body comment) and line 118
  (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 62 (text).

### docs × markdown (8 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][14]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][15]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][16]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][17]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-types.md][18]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text).

## Keywords

- [world map][21]
- [track][22]
- [file language][23]
- [cell][24]
- [lit cell][25]
- [.claude][26]: a track
- [automation][26]: a track
- [docs][26]: a track
- [csharp][27]: a file language
- [markdown][27]: a file language
- [powershell][27]: a file language
- [yaml][27]: a file language

Terms the cited ADRs define:

- [gate][28], defined by [ADR-FLOW-CD#13][29]
- [release candidate][30], defined by [ADR-FLOW-CD#14][31]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/CLAUDE.md
[6]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[7]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[8]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[9]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[10]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[11]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[12]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[13]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[14]: ../../adr/flow/dora-explains.md
[15]: ../../adr/flow/durable-sha-globs.md
[16]: ../../adr/flow/pipeline-detection.md
[17]: ../../adr/flow/pipeline-runner-pattern.md
[18]: ../../adr/flow/pipeline-types.md
[19]: ../../adr/glossary.md
[20]: ../../adr/index.md
[21]: ../../adr/glossary.md#world-map
[22]: ../../adr/glossary.md#track
[23]: ../../adr/glossary.md#file-language
[24]: ../../adr/glossary.md#cell
[25]: ../../adr/glossary.md#lit-cell
[26]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[27]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[28]: ../../adr/glossary.md#gate
[29]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[30]: ../../adr/glossary.md#release-candidate
[31]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

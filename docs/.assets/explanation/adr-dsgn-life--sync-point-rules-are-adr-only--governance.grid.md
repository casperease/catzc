# docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md

`Grid minimap: adr-dsgn-life--sync-point-rules-are-adr-only--governance`

![Grid minimap of adr-dsgn-life--sync-point-rules-are-adr-only--governance](adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.png)

The grid minimap of the slide `adr-dsgn-life--sync-point-rules-are-adr-only--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 9 files
- automation × csharp: 2 lit of 229 files
- automation × powershell: 3 lit of 1443 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 6 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/agents/write-drawio-files.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][8]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][9]: selected by [ADR-FLOW-CD][2]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][10]: selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][11]: selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][12]: selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][15]: selected by [ADR-FLOW-CD][2]: the file cites it at line 62 (text).

### docs × markdown (6 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][17]: selected by [ADR-FLOW-CD][2]: the file cites it at line 13 (text).
- [docs/adr/glossary.md][18]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][19]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-FLOW-CD][2]: the file cites
  it at line 107 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [csharp][26]: a file language
- [markdown][26]: a file language
- [powershell][26]: a file language
- [yaml][26]: a file language

Terms the cited ADRs define:

- [gate][27], defined by [ADR-FLOW-CD#13][28]
- [occupant][29], defined by [ADR-DSGN-LIFE#5][30]
- [release candidate][31], defined by [ADR-FLOW-CD#14][32]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../.claude/agents/write-drawio-files.md
[8]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[9]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[10]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[11]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[12]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[13]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[15]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[16]: ../../adr/design/dora-explains.md
[17]: ../../adr/flow/dora-explains.md
[18]: ../../adr/glossary.md
[19]: ../../adr/index.md
[20]: ../../adr/glossary.md#world-map
[21]: ../../adr/glossary.md#track
[22]: ../../adr/glossary.md#file-language
[23]: ../../adr/glossary.md#cell
[24]: ../../adr/glossary.md#lit-cell
[25]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[27]: ../../adr/glossary.md#gate
[28]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[29]: ../../adr/glossary.md#occupant
[30]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[31]: ../../adr/glossary.md#release-candidate
[32]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

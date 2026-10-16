# docs/.assets/explanation/grid/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md

`Grid minimap: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture`

![Grid minimap of adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture](adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.png)

The grid minimap of the slide `adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture` (architecture lens). The slide supports
[ADR-FLOW-CD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 51 files
- .unordered × markdown: 5 lit of 20 files
- automation × csharp: 2 lit of 272 files
- automation × powershell: 3 lit of 1563 files
- automation × yaml: 3 lit of 107 files
- docs × markdown: 7 lit of 1985 files
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

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD][1]: the file cites it at line 50 (text).

### .unordered × markdown (5 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 44 (text), line 99 (text),
  line 152 (text), line 173 (text), line 178 (text), line 183 (text), line 291 (text) and line 291 (text).
- [.unordered/15-10-2026/plan-built-bundle.md][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 13 (text), line 255 (text) and
  line 277 (text).
- [.unordered/15-10-2026/plan-caf-waf-automation.md][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 22 (text), line 23 (text) and
  line 24 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 97 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 25 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 22 (text).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (header) and line
  40 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (header) and line
  48 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][15]: selected by [ADR-FLOW-CD][1]: the file cites it at line 19
  (header), line 92 (text) and line 93 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-FLOW-CD][1]: the file cites it at line 114 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 37 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 76 (text).

### docs × markdown (7 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 42 (text).
- [docs/adr/glossary.md][20]: selected by [ADR-FLOW-CD][1]: the file cites it at line 397 (text) and line 410 (text).
- [docs/adr/index.md][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 124 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 57 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 49
  (text), line 50 (text), line 78 (text) and line 79 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][24]: selected by [ADR-FLOW-CD][1]: the file cites it at line 19
  (text) and line 56 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][25]: selected by [ADR-FLOW-CD][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 114 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 25
  (text), `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 22 (text), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1`
  line 21 (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 40 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 20 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 48
  (header), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 92 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 37 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 76 (text).

## Keywords

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [.claude][31]: a track
- [.unordered][31]: a track
- [automation][31]: a track
- [docs][31]: a track
- [pipelines][31]: a track
- [csharp][32]: a file language
- [markdown][32]: a file language
- [pipeline-yaml][32]: a file language
- [powershell][32]: a file language
- [yaml][32]: a file language

Terms the cited ADRs define:

- [gate][33], defined by [ADR-FLOW-CD#13][34]
- [release candidate][35], defined by [ADR-FLOW-CD#14][36]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/CLAUDE.md
[6]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[7]: ../../../../.unordered/15-10-2026/plan-built-bundle.md
[8]: ../../../../.unordered/15-10-2026/plan-caf-waf-automation.md
[9]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[10]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[11]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[12]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[13]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[14]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[15]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[16]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[18]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[19]: ../../../adr/flow/dora-explains.md
[20]: ../../../adr/glossary.md
[21]: ../../../adr/index.md
[22]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[23]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[24]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[25]: ../../../../pipelines/ci-automation.yaml
[26]: ../../../adr/glossary.md#world-map
[27]: ../../../adr/glossary.md#track
[28]: ../../../adr/glossary.md#file-language
[29]: ../../../adr/glossary.md#cell
[30]: ../../../adr/glossary.md#lit-cell
[31]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[32]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[33]: ../../../adr/glossary.md#gate
[34]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[35]: ../../../adr/glossary.md#release-candidate
[36]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

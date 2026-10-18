# Only BVT has a gate in code; the sync-point rules are ADR-only: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE and ADR-FLOW-CD sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 22 files.
```

![The world-map minimap of Only BVT has a gate in code; the sync-point rules are ADR-only](adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Only BVT has a gate in code; the sync-point rules are
ADR-only][26], which explains [ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 91 files
- automation × csharp: 2 lit of 286 files
- automation × powershell: 4 lit of 1619 files
- automation × yaml: 3 lit of 112 files
- docs × markdown: 9 lit of 2220 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][2]: the file cites it at line 52 (text).
- [.claude/plans/plan-fast-push-followups.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 26 (text) and line 47 (text).
- [.claude/plans/value-of-plan.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 22 (text) and line 63 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][9]: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][10]: selected by [ADR-FLOW-CD][2]: the file cites it at line 23 (text).

### automation × powershell (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Git/Push-Dirty.ps1][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 21 (header) and line 26
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][12]: selected by [ADR-FLOW-CD][2]: the file cites it at line 22 (header) and line
  41 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][13]: selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (header) and line
  49 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][14]: selected by [ADR-FLOW-CD][2]: the file cites it at line 20
  (header), line 93 (text) and line 94 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 97 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 116 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 37 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][17]: selected by [ADR-FLOW-CD][2]: the file cites it at line 77 (text).

### docs × markdown (9 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][18]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 121 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][19]: selected by [ADR-FLOW-CD][2]: the file cites it at line 42 (text).
- [docs/adr/glossary.md][20]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 497 (text) and line 510 (text).
- [docs/adr/index.md][21]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 129 (text).
- [docs/references/automation/catzc-base-docs/configs/adrs.yml.md][22]: selected by [ADR-FLOW-CD][2]: the file cites it at line 59 (text).
- [docs/references/automation/catzc-base-docs/types/AdrsConfig.cs.md][23]: selected by [ADR-FLOW-CD][2]: the file cites it at line 51
  (text), line 52 (text), line 80 (text) and line 81 (text).
- [docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md][24]: selected by [ADR-FLOW-CD][2]: the file cites it at line 20
  (text) and line 57 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][25]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 21
  (header), `automation/Catzc.Base.Git/Push-Dirty.ps1` line 26 (header) and `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line
  68 (text); selected by [ADR-FLOW-CD][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 116 (text), `automation/Catzc.Base.Docs/types/AdrsConfig.cs` line 28 (text),
  `automation/Catzc.Base.Docs/types/GlossaryConcept.cs` line 23 (text), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 22
  (header), `automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1` line 41 (header),
  `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 21 (header), `automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1` line 49
  (header), `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 93 (text),
  `automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 94 (text),
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 37 (text) and `automation/Catzc.Base.QualityGates/configs/glossary.yml`
  line 77 (text).

## Keywords

- [world map][27]
- [track][28]
- [file language][29]
- [cell][30]
- [lit cell][31]
- [.claude][32]: a track
- [automation][32]: a track
- [docs][32]: a track
- [pipelines][32]: a track
- [csharp][33]: a file language
- [markdown][33]: a file language
- [pipeline-yaml][33]: a file language
- [powershell][33]: a file language
- [yaml][33]: a file language

Terms the cited ADRs define:

- [gate][34], defined by [ADR-FLOW-CD#13][35]
- [occupant][36], defined by [ADR-DSGN-LIFE#5][37]
- [release candidate][38], defined by [ADR-FLOW-CD#14][39]

[1]: ../../../adr/design/commit-lifecycle.md
[2]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../.claude/CLAUDE.md
[7]: ../../../../.claude/plans/plan-fast-push-followups.md
[8]: ../../../../.claude/plans/value-of-plan.md
[9]: ../../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[10]: ../../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[11]: ../../../../automation/Catzc.Base.Git/Push-Dirty.ps1
[12]: ../../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[13]: ../../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[14]: ../../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[15]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[16]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[17]: ../../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[18]: ../../../adr/design/dora-explains.md
[19]: ../../../adr/flow/dora-explains.md
[20]: ../../../adr/glossary.md
[21]: ../../../adr/index.md
[22]: ../../../references/automation/catzc-base-docs/configs/adrs.yml.md
[23]: ../../../references/automation/catzc-base-docs/types/AdrsConfig.cs.md
[24]: ../../../references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
[25]: ../../../../pipelines/ci-automation.yaml
[26]: ../../design/sync-point-rules-are-adr-only.md
[27]: ../../../adr/glossary.md#world-map
[28]: ../../../adr/glossary.md#track
[29]: ../../../adr/glossary.md#file-language
[30]: ../../../adr/glossary.md#cell
[31]: ../../../adr/glossary.md#lit-cell
[32]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[33]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[34]: ../../../adr/glossary.md#gate
[35]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[36]: ../../../adr/glossary.md#occupant
[37]: ../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[38]: ../../../adr/glossary.md#release-candidate
[39]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14

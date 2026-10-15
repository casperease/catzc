# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md

`Grid minimap: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance`

![Grid minimap of adr-dsgn-remote--ingress-gated-the-rest-by-review--governance](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.png)

The grid minimap of the slide `adr-dsgn-remote--ingress-gated-the-rest-by-review--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × csharp: 1 lit of 229 files
- automation × powershell: 1 lit of 1443 files
- automation × yaml: 3 lit of 97 files
- docs × markdown: 7 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/agents/write-drawio-files.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).

### automation × csharp (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][8]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 1 (header).

### automation × powershell (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][9]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 29 (header)
  and line 100 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 316 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).
- [automation/Catzc.Base.Variants/configs/variants.yml][12]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 1 (header).

### docs × markdown (7 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 105 (text).
- [docs/adr/design/server-remote-integration.md][2]: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.
- [docs/adr/glossary.md][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 93 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 294 (text).
- [docs/adr/repository/dora-explains.md][16]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 149 (text).
- [docs/adr/repository/repo-variants.md][3]: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.

## Keywords

- [world map][17]
- [track][18]
- [file language][19]
- [cell][20]
- [lit cell][21]
- [.claude][12]: a track
- [automation][12]: a track
- [docs][12]: a track
- [csharp][22]: a file language
- [markdown][22]: a file language
- [powershell][22]: a file language
- [yaml][22]: a file language

Terms the cited ADRs define:

- [occupant][23], defined by [ADR-DSGN-LIFE#5][24]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/repository/repo-variants.md
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../.claude/agents/write-drawio-files.md
[8]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[9]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[10]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[12]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[13]: ../../adr/design/dora-explains.md
[14]: ../../adr/glossary.md
[15]: ../../adr/index.md
[16]: ../../adr/repository/dora-explains.md
[17]: ../../adr/glossary.md#world-map
[18]: ../../adr/glossary.md#track
[19]: ../../adr/glossary.md#file-language
[20]: ../../adr/glossary.md#cell
[21]: ../../adr/glossary.md#lit-cell
[22]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[23]: ../../adr/glossary.md#occupant
[24]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5

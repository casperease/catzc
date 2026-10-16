# docs/.assets/explanation/adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.grid.md

`Grid minimap: adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation`

![Grid minimap of adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation](adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation.grid.png)

The grid minimap of the slide `adr-repo-variant--five-keys-one-reader-twelve-primitives--implementation` (implementation lens). The slide
supports [ADR-REPO-VARIANT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 51 files
- .unordered × markdown: 2 lit of 20 files
- automation × csharp: 1 lit of 272 files
- automation × powershell: 1 lit of 1563 files
- automation × yaml: 1 lit of 107 files
- docs × markdown: 5 lit of 1985 files
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

- [.claude/plans/plan-module-kinds-tracks.md][5]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 754 (text) and line 807
  (text).

### .unordered × markdown (2 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][6]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 106 (text) and line 257
  (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][7]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 25 (text).

### automation × csharp (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][8]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 23 (text).

### automation × powershell (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][9]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 23 (header),
  line 51 (header) and line 124 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][10]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 314 (text).

### docs × markdown (5 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/index.md][11]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 316 (text).
- [docs/adr/repository/dora-explains.md][12]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 197 (text).
- [docs/adr/repository/repo-variants.md][1]: selected by [ADR-REPO-VARIANT][1]: the ADR's own file.
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][13]: selected by [ADR-REPO-VARIANT][1]: the file cites it at line
  29 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][14]: selected by [ADR-REPO-VARIANT][1]: the file cites it at
  line 30 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][15]: selected by [ADR-REPO-VARIANT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 314 (text),
  `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 23 (header), `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1`
  line 51 (header), `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 124 (text) and
  `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line 23 (text).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [.claude][21]: a track
- [.unordered][21]: a track
- [automation][21]: a track
- [docs][21]: a track
- [pipelines][21]: a track
- [csharp][22]: a file language
- [markdown][22]: a file language
- [pipeline-yaml][22]: a file language
- [powershell][22]: a file language
- [yaml][22]: a file language

[1]: ../../adr/repository/repo-variants.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/plans/plan-module-kinds-tracks.md
[6]: ../../../.unordered/15-10-2026/plan-adr-consistency.md
[7]: ../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[8]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[9]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[10]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../adr/index.md
[12]: ../../adr/repository/dora-explains.md
[13]: ../../references/automation/catzc-base-variants/configs/variants.yml.md
[14]: ../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[15]: ../../../pipelines/ci-automation.yaml
[16]: ../../adr/glossary.md#world-map
[17]: ../../adr/glossary.md#track
[18]: ../../adr/glossary.md#file-language
[19]: ../../adr/glossary.md#cell
[20]: ../../adr/glossary.md#lit-cell
[21]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

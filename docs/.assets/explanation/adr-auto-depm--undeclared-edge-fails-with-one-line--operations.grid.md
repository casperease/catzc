# docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md

`Grid minimap: adr-auto-depm--undeclared-edge-fails-with-one-line--operations`

![Grid minimap of adr-auto-depm--undeclared-edge-fails-with-one-line--operations](adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.png)

The grid minimap of the slide `adr-auto-depm--undeclared-edge-fails-with-one-line--operations` (operations lens). The slide supports
[ADR-AUTO-DEPM][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (173 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × csharp: 3 lit of 229 files
- automation × yaml: 1 lit of 97 files
- docs × markdown: 3 lit of 744 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][5]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][6]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][7]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 3 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][8]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 157 (text).

### docs × markdown (3 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/controlling-module-dependencies.md][1]: selected by [ADR-AUTO-DEPM][1]: the ADR's own file.
- [docs/adr/automation/dora-explains.md][9]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 349 (text).
- [docs/adr/index.md][10]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 145 (text).

## Keywords

- [world map][11]
- [track][12]
- [file language][13]
- [cell][14]
- [lit cell][15]
- [automation][16]: a track
- [docs][16]: a track
- [csharp][17]: a file language
- [markdown][17]: a file language
- [yaml][17]: a file language

[1]: ../../adr/automation/controlling-module-dependencies.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[6]: ../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[7]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[8]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../adr/automation/dora-explains.md
[10]: ../../adr/index.md
[11]: ../../adr/glossary.md#world-map
[12]: ../../adr/glossary.md#track
[13]: ../../adr/glossary.md#file-language
[14]: ../../adr/glossary.md#cell
[15]: ../../adr/glossary.md#lit-cell
[16]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[17]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

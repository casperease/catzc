---
catzc:
  immutable:
    with_body_sha: aa215bd51dc3
    repo_status: locked
    path: docs/explanation/design/.assets/globs-yml-pipeline-field-is-the-binding/grid.md
    source: docs/explanation/design/.assets/globs-yml-pipeline-field-is-the-binding/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One field in globs.yml, pipeline:, binds a set to its pipeline file: the world-map minimap

```text
Where the files that cite ADR-DSGN-TRACK sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 104 files.
```

![The world-map minimap of One field in globs.yml, pipeline:, binds a set to its pipeline file](grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [One field in globs.yml, pipeline:, binds a set to its
pipeline file][105], which explains [ADR-DSGN-TRACK][1]. It lights every cell of the world map that holds a file citing those codes, so it
shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 9 lit of 89 files
- docs × markdown: 59 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × csharp: 7 lit of 293 files
- pwsh × powershell: 22 lit of 1651 files
- pwsh × yaml: 6 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (9 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [.claude/CLAUDE.md][2]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text).
- [.claude/plans/decisions-2026-10-16.md][3]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 19 (text), line 26 (text), line 45
  (text), line 53 (text), line 116 (text), line 117 (text), line 121 (text), line 121 (text), line 123 (text), line 129 (text), line 131
  (text) and line 176 (text).
- [.claude/plans/decisions-2026-10-18.md][4]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text), line 33 (text) and line
  33 (text).
- [.claude/plans/plan-adr-code-language.md][5]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text) and line 36 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][6]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 59 (text) and line 109
  (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][7]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 77 (text), line
  78 (text) and line 195 (text).
- [.claude/plans/plan-plans-body-sha-landing-zone.md][8]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text) and line 24
  (text).
- [.claude/plans/questionnaire-fundamental-2-2026-10-16.md][9]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text).
- [.claude/plans/task-layers-classification-flip.md][10]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 31
  (text), line 31 (text), line 31 (text) and line 33 (text).

### docs × markdown (59 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11 (text).
- [docs/adr/design/tracks.md][1]: selected by [ADR-DSGN-TRACK][1]: the ADR's own file.
- [docs/adr/glossary.md][12]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 134 (text), line 161 (text), line 178 (text), line
  210 (text), line 221 (text), line 233 (text), line 290 (text), line 300 (text), line 323 (text), line 329 (text), line 332 (text), line
  355 (text), line 395 (text), line 409 (text), line 418 (text), line 432 (text), line 445 (text), line 479 (text) and line 491 (text).
- [docs/adr/index.md][13]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text).
- [docs/how-to/automation/sort-an-import.md][14]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 4 (text).
- [docs/how-to/pwsh/manual-test-plan/repository-conventions.md][15]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text),
  line 17 (text), line 23 (text), line 23 (text), line 26 (text), line 26 (text), line 28 (text), line 28 (text), line 28 (text), line 29
  (text), line 30 (text) and line 32 (text).
- [docs/references/note-file-kind.md][16]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20 (text), line 34 (text) and line 37
  (text).
- [docs/references/pipelines/ci-automation.yaml.md][17]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][18]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 21 (text) and
  line 22 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md][19]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16 (text) and
  line 17 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md][20]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][21]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32 (text),
  line 35 (text) and line 47 (text).
- [docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md][22]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  14 (text).
- [docs/references/pwsh/catzc-base-globs/configs/globs.yml.md][23]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 105 (text).
- [docs/references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md][24]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md][25]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-languages/configs/languages.yml.md][26]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md][27]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md][28]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md][29]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-maps.md][30]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 66 (text), line 68 (text) and
  line 80 (text).
- [docs/references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md][31]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 21 (text), line 23 (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][32]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 16
  (text), line 17 (text) and line 43 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md][33]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text),
  line 16 (text) and line 17 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md][34]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line
  16 (text) and line 26 (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][35]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text) and line 60 (text).
- [docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md][36]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 20
  (text), line 22 (text), line 25 (text) and line 28 (text).
- [docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md][37]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18 (text),
  line 21 (text), line 25 (text), line 28 (text) and line 29 (text).
- [docs/references/pwsh/catzc-base-maps/configs/maps.yml.md][38]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 36 (text), line
  42 (text), line 44 (text) and line 49 (text).
- [docs/references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md][39]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  17 (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md][40]: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md][41]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md][42]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md][43]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text), line 13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md][44]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md][45]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 12 (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md][46]: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md][47]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12 (text), line
  13 (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md][48]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text),
  line 16 (text) and line 20 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md][49]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md][50]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md][51]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text), line 13 (text) and line 15 (text).
- [docs/references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md][52]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md][53]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13 (text) and
  line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md][54]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 18
  (text), line 19 (text), line 22 (text) and line 65 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md][55]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 13
  (text) and line 14 (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md][56]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md][57]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text),
  line 15 (text) and line 16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md][58]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 19 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md][59]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][60]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md][61]: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md][62]: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 15 (text).
- [docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md][63]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md][64]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 14 (text),
  line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][65]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 75
  (text), line 78 (text) and line 80 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md][66]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 11
  (text) and line 13 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][67]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 32
  (text), line 35 (text) and line 37 (text).
- [docs/references/pwsh/claude-drawio/minimaps/highlights.ps1.md][68]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 51 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pipelines/ci-automation.yaml][69]: selected by [ADR-DSGN-TRACK][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 74 (text), `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108
  (text), `pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1` line 108 (text), `pwsh/Catzc.Base.Docs/types/AdrsConfig.cs` line 15 (body
  comment), `pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1` line 41 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml` line 5 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 111 (text), `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1`
  line 123 (text), `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1` line 161 (text),
  `pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 15 (text),
  `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 16 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 26 (text),
  `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 29 (text), `pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1` line 46 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 26 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 62 (text), `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 66 (text),
  `pwsh/Catzc.Base.Maps/Test-WorldMap.ps1` line 67 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 17 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 23 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1` line 42 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1`
  line 17 (text), `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1` line 36 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1` line 89
  (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 74 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 49 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  49 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 53 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 54 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  55 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 56 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 60 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  63 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text),
  `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line 80 (text), `pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1` line
  80 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 57 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  61 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 64 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  68 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 69 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  73 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 82 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  83 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 87 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  91 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 92 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line
  111 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1` line 111 (text), `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`
  line 111 (text), `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 15 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 22 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 28 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1` line 45 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 17 (text), `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line
  26 (text), `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 31 (text),
  `pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1` line 39 (text), `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1`
  line 69 (text), `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 113 (text),
  `pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1` line 127 (text), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs` line 9
  (body comment), `pwsh/Catzc.Base.Maps/types/ValueChainCell.cs` line 12 (body comment), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 5 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 62 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 70 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 79 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 88 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 94 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 190 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 200 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 211 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 234 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 247 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 261 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 276 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 289 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 301 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 314 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`
  line 316 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 328 (text),
  `pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml` line 7 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line
  299 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 302 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Variants/configs/track-types.yml`
  line 42 (text), `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 1 (text),
  `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` line 52 (text), `pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1` line 71
  (text), `pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.Variants/types/ModulePlace.cs`
  line 6 (body comment), `pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs` line 5 (body comment),
  `pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs` line 10 (body comment), `pwsh/Catzc.Base.Variants/types/PathModule.cs` line 3 (body
  comment) and `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs` line 265 (text).

### pwsh × csharp (7 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/types/AdrsConfig.cs][70]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (body comment) (a passing
  mention only).
- [pwsh/Catzc.Base.Maps/types/ValueChainCell.cs][71]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 9 (body comment) and line
  12 (body comment) (a passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModulePlace.cs][72]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs][73]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs][74]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 10 (body comment) (a
  passing mention only).
- [pwsh/Catzc.Base.Variants/types/PathModule.cs][75]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 3 (body comment) (a passing
  mention only).
- [pwsh/Catzc.Base.Variants/types/VariantsConfig.cs][76]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 265 (text).

### pwsh × powershell (22 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][77]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 108 (text) and
  line 108 (text).
- [pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1][78]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][79]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 41 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][80]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 111 (text),
  line 123 (text) and line 161 (text).
- [pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1][81]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1][82]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15 (text), line 16 (text),
  line 26 (text), line 29 (text) and line 46 (text).
- [pwsh/Catzc.Base.Maps/Test-WorldMap.ps1][83]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 45 (text), line
  62 (text), line 66 (text) and line 67 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][84]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text),
  line 23 (text) and line 42 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][85]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line
  36 (text) and line 36 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][86]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 89 (text).
- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][87]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][88]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 49 (text), line
  49 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 60 (text), line 63 (text), line 80 (text), line 80 (text)
  and line 80 (text).
- [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][89]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 57 (text), line 61
  (text), line 64 (text), line 68 (text), line 69 (text), line 73 (text), line 82 (text), line 83 (text), line 87 (text), line 91 (text),
  line 92 (text), line 111 (text), line 111 (text) and line 111 (text).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][90]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 15
  (text), line 22 (text), line 28 (text), line 45 (text) and line 45 (text).
- [pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][91]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 17 (text), line
  26 (text), line 31 (text) and line 39 (text).
- [pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][92]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 69 (text),
  line 113 (text) and line 127 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1][93]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1][94]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line
  1 (text).
- [pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1][95]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).
- [pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1][96]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1 (text) and
  line 52 (text).
- [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1][97]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1][98]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 1
  (text).

### pwsh × yaml (6 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][1]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][1]). Lit ([ADR-DSGN-TRACK-LITCELL][1]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][99]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 74 (text).
- [pwsh/Catzc.Base.Languages/configs/glossary.yml][100]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][101]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 5 (text), line 62
  (text), line 70 (text), line 79 (text), line 88 (text), line 94 (text), line 190 (text), line 200 (text), line 211 (text), line 234
  (text), line 247 (text), line 261 (text), line 276 (text), line 289 (text), line 301 (text), line 314 (text), line 316 (text) and line 328
  (text).
- [pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml][102]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 7 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][103]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 299 (text) and
  line 302 (text).
- [pwsh/Catzc.Base.Variants/configs/track-types.yml][104]: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 42 (text).

## Keywords

- [world map][106]
- [track][107]
- [file language][108]
- [cell][109]
- [lit cell][110]
- [.claude][111]: a track
- [docs][111]: a track
- [pipelines][111]: a track
- [pwsh][111]: a track
- [csharp][112]: a file language
- [markdown][112]: a file language
- [pipeline-yaml][112]: a file language
- [powershell][112]: a file language
- [yaml][112]: a file language

[1]: ../../../../adr/design/tracks.md
[2]: ../../../../../.claude/CLAUDE.md
[3]: ../../../../../.claude/plans/decisions-2026-10-16.md
[4]: ../../../../../.claude/plans/decisions-2026-10-18.md
[5]: ../../../../../.claude/plans/plan-adr-code-language.md
[6]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[7]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[8]: ../../../../../.claude/plans/plan-plans-body-sha-landing-zone.md
[9]: ../../../../../.claude/plans/questionnaire-fundamental-2-2026-10-16.md
[10]: ../../../../../.claude/plans/task-layers-classification-flip.md
[11]: ../../../../adr/design/dora-explains.md
[12]: ../../../../adr/glossary.md
[13]: ../../../../adr/index.md
[14]: ../../../../how-to/automation/sort-an-import.md
[15]: ../../../../how-to/pwsh/manual-test-plan/repository-conventions.md
[16]: ../../../../references/note-file-kind.md
[17]: ../../../../references/pipelines/ci-automation.yaml.md
[18]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[19]: ../../../../references/pwsh/catzc-base-docs/types/AdrDomain.cs.md
[20]: ../../../../references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md
[21]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[22]: ../../../../references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
[23]: ../../../../references/pwsh/catzc-base-globs/configs/globs.yml.md
[24]: ../../../../references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md
[25]: ../../../../references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md
[26]: ../../../../references/pwsh/catzc-base-languages/configs/languages.yml.md
[27]: ../../../../references/pwsh/catzc-base-languages/tests/Get-FileLanguage.Tests.ps1.md
[28]: ../../../../references/pwsh/catzc-base-languages/types/FileLanguage.cs.md
[29]: ../../../../references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
[30]: ../../../../references/pwsh/catzc-base-maps.md
[31]: ../../../../references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md
[32]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[33]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md
[34]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
[35]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[36]: ../../../../references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
[37]: ../../../../references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
[38]: ../../../../references/pwsh/catzc-base-maps/configs/maps.yml.md
[39]: ../../../../references/pwsh/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
[40]: ../../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
[41]: ../../../../references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
[42]: ../../../../references/pwsh/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
[43]: ../../../../references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
[44]: ../../../../references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
[45]: ../../../../references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
[46]: ../../../../references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
[47]: ../../../../references/pwsh/catzc-base-maps/types/MapCell.cs.md
[48]: ../../../../references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
[49]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md
[50]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainHighlight.cs.md
[51]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainMap.cs.md
[52]: ../../../../references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md
[53]: ../../../../references/pwsh/catzc-base-maps/types/WorldMap.cs.md
[54]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
[55]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md
[56]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
[57]: ../../../../references/pwsh/catzc-base-maps/types/WorldMapPdf.cs.md
[58]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
[59]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-FileTypeFileMetaFact.ps1.md
[60]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[61]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleTypeFileMetaFact.ps1.md
[62]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-TrackFileMetaFact.ps1.md
[63]: ../../../../references/pwsh/catzc-base-variants/Get-PathModule.ps1.md
[64]: ../../../../references/pwsh/catzc-base-variants/Get-Track.ps1.md
[65]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[66]: ../../../../references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
[67]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[68]: ../../../../references/pwsh/claude-drawio/minimaps/highlights.ps1.md
[69]: ../../../../../pipelines/ci-automation.yaml
[70]: ../../../../../pwsh/Catzc.Base.Docs/types/AdrsConfig.cs
[71]: ../../../../../pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
[72]: ../../../../../pwsh/Catzc.Base.Variants/types/ModulePlace.cs
[73]: ../../../../../pwsh/Catzc.Base.Variants/types/ModuleTypeEntry.cs
[74]: ../../../../../pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs
[75]: ../../../../../pwsh/Catzc.Base.Variants/types/PathModule.cs
[76]: ../../../../../pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
[77]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[78]: ../../../../../pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
[79]: ../../../../../pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[80]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[81]: ../../../../../pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
[82]: ../../../../../pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
[83]: ../../../../../pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
[84]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[85]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[86]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[87]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[88]: ../../../../../pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[89]: ../../../../../pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[90]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[91]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[92]: ../../../../../pwsh/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[93]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-FileTypeFileMetaFact.Tests.ps1
[94]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-ModuleTypeFileMetaFact.Tests.ps1
[95]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/Get-TrackFileMetaFact.Tests.ps1
[96]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
[97]: ../../../../../pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
[98]: ../../../../../pwsh/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
[99]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[100]: ../../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[101]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[102]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
[103]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[104]: ../../../../../pwsh/Catzc.Base.Variants/configs/track-types.yml
[105]: ../../globs-yml-pipeline-field-is-the-binding.md
[106]: ../../../../adr/glossary.md#world-map
[107]: ../../../../adr/glossary.md#track
[108]: ../../../../adr/glossary.md#file-language
[109]: ../../../../adr/glossary.md#cell
[110]: ../../../../adr/glossary.md#lit-cell
[111]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[112]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

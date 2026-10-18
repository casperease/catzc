---
catzc:
  immutable:
    with_body_sha: "02d71656f9a9"
    repo_status: locked
    path: docs/explanation/design/.assets/only-automation-compiles-its-aspects/grid.md
    source: docs/explanation/design/.assets/only-automation-compiles-its-aspects/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Both tracks' conventions are read, but only the pwsh track's compiles into globsets: the world-map minimap

```text
Where the files that cite ADR-DSGN-ASPECT sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 20 files.
```

![The world-map minimap of Both tracks' conventions are read, but only the pwsh track's compiles into globsets](grid.png)

This is the world-map minimap in the sidebar of the architecture diagram of [Both tracks' conventions are read, but only the pwsh track's
compiles into globsets][22], which explains [ADR-DSGN-ASPECT][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 89 files
- docs × markdown: 13 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 2 lit of 1651 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-adr-code-language.md][3]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 111 (text) and line 111 (text).
- [.claude/plans/plan-diagram-folders.md][4]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 73 (text).
- [.claude/plans/task-layers-classification-flip.md][5]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 31 (text) and line 31
  (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/design/dora-explains.md][6]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 171 (text).
- [docs/adr/design/module-aspects.md][1]: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.
- [docs/adr/index.md][7]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 117 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][8]: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][9]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 16 (text)
  and line 69 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][10]: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][11]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line
  11 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][12]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 11 (text),
  line 24 (text) and line 52 (text).
- [docs/references/pwsh/catzc-base-modules/Get-Aspect.ps1.md][13]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][14]: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 50 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][15]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 61
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantAspect.cs.md][16]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 12
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][17]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 28
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][18]: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 83 (text),
  `pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 33 (text) and `pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1` line 1
  (header).

### pwsh × powershell (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][19]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 33 (text).
- [pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1][20]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 1 (header).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 83 (text).

## Keywords

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [.claude][28]: a track
- [docs][28]: a track
- [pipelines][28]: a track
- [pwsh][28]: a track
- [markdown][29]: a file language
- [pipeline-yaml][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

[1]: ../../../../adr/design/module-aspects.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-adr-code-language.md
[4]: ../../../../../.claude/plans/plan-diagram-folders.md
[5]: ../../../../../.claude/plans/task-layers-classification-flip.md
[6]: ../../../../adr/design/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[9]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[10]: ../../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[11]: ../../../../references/pwsh/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
[12]: ../../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[13]: ../../../../references/pwsh/catzc-base-modules/Get-Aspect.ps1.md
[14]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[15]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[16]: ../../../../references/pwsh/catzc-base-variants/types/VariantAspect.cs.md
[17]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[18]: ../../../../../pipelines/ci-automation.yaml
[19]: ../../../../../pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[20]: ../../../../../pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1
[21]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../only-automation-compiles-its-aspects.md
[23]: ../../../../adr/glossary.md#world-map
[24]: ../../../../adr/glossary.md#track
[25]: ../../../../adr/glossary.md#file-language
[26]: ../../../../adr/glossary.md#cell
[27]: ../../../../adr/glossary.md#lit-cell
[28]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

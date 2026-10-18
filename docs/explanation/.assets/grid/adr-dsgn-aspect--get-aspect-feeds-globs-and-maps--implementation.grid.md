---
catzc:
  immutable:
    with_body_sha: "7b2752ce7bed"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-dsgn-aspect--get-aspect-feeds-globs-and-maps--implementation.grid.md
    source: docs/explanation/.assets/adr-dsgn-aspect--get-aspect-feeds-globs-and-maps--implementation.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Get-Aspect feeds Globs, which compiles the aspects into sets, and Maps, which only classifies live: the world-map minimap

```text
Where the files that cite ADR-DSGN-ASPECT sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 20 files.
```

![The world-map minimap of Get-Aspect feeds Globs, which compiles the aspects into sets, and Maps, which only classifies live](adr-dsgn-aspect--get-aspect-feeds-globs-and-maps--implementation.grid.png)

This is the world-map minimap in the sidebar of the implementation diagram of [Get-Aspect feeds Globs, which compiles the aspects into sets,
and Maps, which only classifies live][24], which explains [ADR-DSGN-ASPECT][1]. It lights every cell of the world map that holds a file
citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects
it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 90 files
- automation × powershell: 2 lit of 1629 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 13 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][5]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 916 (text).
- [.claude/plans/plan-module-kinds-tracks.md][6]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 210 (text), line 234 (text),
  line 266 (text), line 273 (text), line 359 (text), line 734 (text) and line 923 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][7]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 18 (text).

### automation × powershell (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][8]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 33 (text).
- [pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1][9]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 1 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][10]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 83 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][11]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 171 (text).
- [docs/adr/design/module-aspects.md][1]: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.
- [docs/adr/index.md][12]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 117 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][13]: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 55 (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][14]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 16
  (text) and line 69 (text).
- [docs/references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md][15]: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 109 (text).
- [docs/references/pwsh/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][16]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 11 (text).
- [docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md][17]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 11
  (text), line 24 (text) and line 52 (text).
- [docs/references/pwsh/catzc-base-modules/Get-Aspect.ps1.md][18]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][19]: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 50 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][20]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line
  61 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantAspect.cs.md][21]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 12 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][22]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 28 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][23]: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 83 (text),
  `pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 33 (text) and
  `pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1` line 1 (header).

## Keywords

- [world map][25]
- [track][26]
- [file language][27]
- [cell][28]
- [lit cell][29]
- [.claude][30]: a track
- [automation][30]: a track
- [docs][30]: a track
- [pipelines][30]: a track
- [markdown][31]: a file language
- [pipeline-yaml][31]: a file language
- [powershell][31]: a file language
- [yaml][31]: a file language

[1]: ../../../adr/design/module-aspects.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[6]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[7]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[8]: ../../../../pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[9]: ../../../../pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1
[10]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../adr/design/dora-explains.md
[12]: ../../../adr/index.md
[13]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[14]: ../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[15]: ../../../references/pwsh/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[16]: ../../../references/pwsh/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
[17]: ../../../references/pwsh/catzc-base-globs/types/Aspect.cs.md
[18]: ../../../references/pwsh/catzc-base-modules/Get-Aspect.ps1.md
[19]: ../../../references/pwsh/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[20]: ../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[21]: ../../../references/pwsh/catzc-base-variants/types/VariantAspect.cs.md
[22]: ../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[23]: ../../../../pipelines/ci-automation.yaml
[24]: ../../design/get-aspect-feeds-globs-and-maps.md
[25]: ../../../adr/glossary.md#world-map
[26]: ../../../adr/glossary.md#track
[27]: ../../../adr/glossary.md#file-language
[28]: ../../../adr/glossary.md#cell
[29]: ../../../adr/glossary.md#lit-cell
[30]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[31]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml

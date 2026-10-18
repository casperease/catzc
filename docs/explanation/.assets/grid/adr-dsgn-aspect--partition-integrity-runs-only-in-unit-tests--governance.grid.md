# Partition integrity runs only in unit tests: the world-map minimap

```text
Where the files that cite ADR-DSGN-ASPECT sit in the repository: tracks down, file languages across.
6 of 324 cells lit, holding 26 files.
```

![The world-map minimap of Partition integrity runs only in unit tests](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Partition integrity runs only in unit tests][30], which explains
[ADR-DSGN-ASPECT][1]. It lights every cell of the world map that holds a file citing those codes, so it shows where the decision lives in
the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (271 of the 324 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 91 files
- automation × csharp: 3 lit of 286 files
- automation × powershell: 6 lit of 1618 files
- automation × yaml: 1 lit of 112 files
- docs × markdown: 12 lit of 2220 files
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

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][5]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 945 (text).
- [.claude/plans/plan-module-kinds-tracks.md][6]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 35 (text), line 229 (text),
  line 253 (text), line 285 (text), line 292 (text), line 378 (text), line 753 (text) and line 942 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][7]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 38 (text).

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/types/Aspect.cs][8]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][9]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][10]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 22 (text).

### automation × powershell (6 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][11]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 24 (header) and line
  35 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][12]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 24
  (header) and line 61 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][13]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Modules/Get-Aspect.ps1][14]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 21 (header) and line 26
  (header).
- [automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1][15]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][16]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 22 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 102 (text).

### docs × markdown (12 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][18]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 210 (text).
- [docs/adr/design/module-aspects.md][1]: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.
- [docs/adr/index.md][19]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 117 (text).
- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][20]: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 75 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][21]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 46
  (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][22]: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 131 (text).
- [docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][23]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 27 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][24]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 17
  (text), line 31 (text), line 44 (text) and line 72 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][25]: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 40 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][26]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line
  80 (text).
- [docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md][27]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 31 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][28]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 48 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][29]: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 102 (text),
  `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 24 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 35
  (header), `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 24 (header),
  `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 61 (text), `automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1`
  line 20 (header), `automation/Catzc.Base.Globs/types/Aspect.cs` line 21 (text), `automation/Catzc.Base.Modules/Get-Aspect.ps1` line 21
  (header), `automation/Catzc.Base.Modules/Get-Aspect.ps1` line 26 (header), `automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1` line
  20 (header), `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 22 (header),
  `automation/Catzc.Base.Variants/types/VariantAspect.cs` line 21 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  22 (text).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.claude][36]: a track
- [automation][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [csharp][37]: a file language
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [powershell][37]: a file language
- [yaml][37]: a file language

[1]: ../../../adr/design/module-aspects.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[6]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[7]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[8]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[9]: ../../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[10]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[11]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[12]: ../../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[13]: ../../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[14]: ../../../../automation/Catzc.Base.Modules/Get-Aspect.ps1
[15]: ../../../../automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1
[16]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[17]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../adr/design/dora-explains.md
[19]: ../../../adr/index.md
[20]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[21]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[22]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[23]: ../../../references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
[24]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[25]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[26]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[27]: ../../../references/automation/catzc-base-variants/types/VariantAspect.cs.md
[28]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[29]: ../../../../pipelines/ci-automation.yaml
[30]: ../../design/partition-integrity-runs-only-in-unit-tests.md
[31]: ../../../adr/glossary.md#world-map
[32]: ../../../adr/glossary.md#track
[33]: ../../../adr/glossary.md#file-language
[34]: ../../../adr/glossary.md#cell
[35]: ../../../adr/glossary.md#lit-cell
[36]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

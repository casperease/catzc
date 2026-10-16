# docs/.assets/explanation/grid/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md

`Grid minimap: adr-dsgn-aspect--one-folder-two-independent-readers--architecture`

![Grid minimap of adr-dsgn-aspect--one-folder-two-independent-readers--architecture](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-aspect--one-folder-two-independent-readers--architecture` (architecture lens). The slide supports
[ADR-DSGN-ASPECT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 16 tracks (rows) with the 18 file languages (columns) of the world map and lights 7 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (237 of the 288 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 51 files
- .unordered × markdown: 4 lit of 20 files
- automation × csharp: 3 lit of 272 files
- automation × powershell: 5 lit of 1563 files
- automation × yaml: 1 lit of 107 files
- docs × markdown: 10 lit of 1985 files
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

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][5]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 796 (text).
- [.claude/plans/plan-module-kinds-tracks.md][6]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 116 (text), line 140 (text),
  line 171 (text), line 178 (text), line 260 (text), line 609 (text) and line 799 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][7]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 18 (text).

### .unordered × markdown (4 lit files)

Placed: the root folder `.unordered/` names the track .unordered ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.unordered/15-10-2026/plan-adr-consistency.md][8]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 128 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][9]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 94 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][10]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 21 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][11]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 55 (text), line 76
  (text), line 103 (text) and line 103 (text).

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/types/Aspect.cs][12]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][13]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 20 (text).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][14]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 21 (text).

### automation × powershell (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][15]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 23 (header) and line
  34 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][16]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 23
  (header) and line 60 (text).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][17]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][18]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 21 (header).
- [automation/Catzc.Base.Variants/Get-Aspect.ps1][19]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 19 (header) and line 24
  (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 100 (text).

### docs × markdown (10 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/dora-explains.md][21]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 210 (text).
- [docs/adr/design/module-aspects.md][1]: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.
- [docs/adr/index.md][22]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 112 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][23]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 45
  (text).
- [docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][24]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 26 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][25]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 16
  (text), line 30 (text), line 43 (text) and line 71 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][26]: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 39 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][27]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line
  79 (text).
- [docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md][28]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 30 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][29]: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 47 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/ci-automation.yaml][30]: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing itself carries its globset's
  citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 100 (text),
  `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 23 (header), `automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1` line 34
  (header), `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 23 (header),
  `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 60 (text), `automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1`
  line 19 (header), `automation/Catzc.Base.Globs/types/Aspect.cs` line 20 (text),
  `automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1` line 21 (header),
  `automation/Catzc.Base.Variants/Get-Aspect.ps1` line 19 (header), `automation/Catzc.Base.Variants/Get-Aspect.ps1` line 24 (header),
  `automation/Catzc.Base.Variants/types/VariantAspect.cs` line 20 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs` line
  21 (text).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.claude][36]: a track
- [.unordered][36]: a track
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
[8]: ../../../../.unordered/15-10-2026/plan-adr-consistency.md
[9]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[10]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[11]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[12]: ../../../../automation/Catzc.Base.Globs/types/Aspect.cs
[13]: ../../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[14]: ../../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[15]: ../../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[16]: ../../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[17]: ../../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[18]: ../../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[19]: ../../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[20]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../adr/design/dora-explains.md
[22]: ../../../adr/index.md
[23]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[24]: ../../../references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
[25]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[26]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[27]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[28]: ../../../references/automation/catzc-base-variants/types/VariantAspect.cs.md
[29]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[30]: ../../../../pipelines/ci-automation.yaml
[31]: ../../../adr/glossary.md#world-map
[32]: ../../../adr/glossary.md#track
[33]: ../../../adr/glossary.md#file-language
[34]: ../../../adr/glossary.md#cell
[35]: ../../../adr/glossary.md#lit-cell
[36]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml

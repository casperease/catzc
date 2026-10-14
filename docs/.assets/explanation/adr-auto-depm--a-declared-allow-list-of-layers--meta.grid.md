# docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md

`Grid minimap: adr-auto-depm--a-declared-allow-list-of-layers--meta`

![Grid minimap of adr-auto-depm--a-declared-allow-list-of-layers--meta](adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.png)

The grid minimap of the slide `adr-auto-depm--a-declared-allow-list-of-layers--meta` (meta lens). The slide supports [ADR-AUTO-DEPM][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × csharp: 3 lit of 219 files
- automation × yaml: 1 lit of 95 files
- docs × markdown: 45 lit of 742 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/drawio/STYLE.md][5]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 329 (text).

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][6]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][7]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][8]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 3 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 157 (text).

### docs × markdown (45 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/BCL/index.md][10]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/BCL/native-csharp-types.md][11]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][12]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][13]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/caching.md][14]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][15]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][1]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][16]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/cross-platform.md][17]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/devbox-pipeline-parity.md][18]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][19]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/dry-run.md][20]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][21]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/environment-variables.md][22]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][23]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][24]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][25]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/go/go-test-artifacts.md][26]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/idempotent-state-functions.md][27]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][28]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][29]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/managed-guids.md][30]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/never-depend-on-pwd.md][31]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][32]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/path-representation.md][33]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][34]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/protected-globs.md][35]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/python/index.md][36]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][37]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][38]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][39]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/single-responsibility-functions.md][40]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][41]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/test-automation.md][42]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][43]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][44]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][45]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][46]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][47]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/index.md][48]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 145 (text).
- [docs/explanation/automation/a-declared-allow-list-of-layers.md][49]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 14 (text),
  line 38 (text), line 40 (text), line 41 (text) and line 42 (text).
- [docs/explanation/automation/three-layers-edges-point-down.md][50]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 15 (text),
  line 44 (text), line 46 (text) and line 48 (text).
- [docs/explanation/automation/two-gates-check-the-layer-pins.md][51]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 15 (text),
  line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51 (text) and line 55 (text).
- [docs/explanation/automation/two-sections-unioned-into-one-allow-set.md][52]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 18
  (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/automation/undeclared-edge-fails-with-one-line.md][53]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 15
  (text), line 49 (text), line 50 (text) and line 51 (text).

## Keywords

- [world map][54]
- [track][55]
- [file language][56]
- [cell][57]
- [lit cell][58]
- [.claude][59]: a track
- [automation][59]: a track
- [docs][59]: a track
- [csharp][60]: a file language
- [markdown][60]: a file language
- [yaml][60]: a file language

[1]: ../../adr/automation/controlling-module-dependencies.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/drawio/STYLE.md
[6]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[7]: ../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[8]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[9]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../adr/automation/BCL/index.md
[11]: ../../adr/automation/BCL/native-csharp-types.md
[12]: ../../adr/automation/avoid-deep-nesting.md
[13]: ../../adr/automation/bash/bash-test-artifacts.md
[14]: ../../adr/automation/caching.md
[15]: ../../adr/automation/console-output-matters.md
[16]: ../../adr/automation/controlling-systemwide-deps.md
[17]: ../../adr/automation/cross-platform.md
[18]: ../../adr/automation/devbox-pipeline-parity.md
[19]: ../../adr/automation/dora-explains.md
[20]: ../../adr/automation/dry-run.md
[21]: ../../adr/automation/effective-in-enterprises.md
[22]: ../../adr/automation/environment-variables.md
[23]: ../../adr/automation/execution-engines.md
[24]: ../../adr/automation/fail-fast-with-asserts.md
[25]: ../../adr/automation/go/index.md
[26]: ../../adr/automation/go/go-test-artifacts.md
[27]: ../../adr/automation/idempotent-state-functions.md
[28]: ../../adr/automation/internal-asset-dependencies.md
[29]: ../../adr/automation/log-before-invoke.md
[30]: ../../adr/automation/managed-guids.md
[31]: ../../adr/automation/never-depend-on-pwd.md
[32]: ../../adr/automation/open-closed-architecture.md
[33]: ../../adr/automation/path-representation.md
[34]: ../../adr/automation/platform-bundle.md
[35]: ../../adr/repository/protected-globs.md
[36]: ../../adr/automation/python/index.md
[37]: ../../adr/automation/python/python-test-artifacts.md
[38]: ../../adr/automation/retry-as-last-resort.md
[39]: ../../adr/automation/sensible-defaults.md
[40]: ../../adr/automation/single-responsibility-functions.md
[41]: ../../adr/automation/spell-out-names.md
[42]: ../../adr/automation/test-automation.md
[43]: ../../adr/automation/tool-removal-lifecycle.md
[44]: ../../adr/automation/tracked-files-from-the-index.md
[45]: ../../adr/automation/use-proper-package-managers.md
[46]: ../../adr/automation/uv-python-handler.md
[47]: ../../adr/automation/zero-ceremony-poka-yoke.md
[48]: ../../adr/index.md
[49]: ../../explanation/automation/a-declared-allow-list-of-layers.md
[50]: ../../explanation/automation/three-layers-edges-point-down.md
[51]: ../../explanation/automation/two-gates-check-the-layer-pins.md
[52]: ../../explanation/automation/two-sections-unioned-into-one-allow-set.md
[53]: ../../explanation/automation/undeclared-edge-fails-with-one-line.md
[54]: ../../adr/glossary.md#world-map
[55]: ../../adr/glossary.md#track
[56]: ../../adr/glossary.md#file-language
[57]: ../../adr/glossary.md#cell
[58]: ../../adr/glossary.md#lit-cell
[59]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[60]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md

`Tree minimap: adr-auto-depm--a-declared-allow-list-of-layers--meta`

![Tree minimap of adr-auto-depm--a-declared-allow-list-of-layers--meta](adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.png)

The tree minimap of the slide `adr-auto-depm--a-declared-allow-list-of-layers--meta` (meta lens). The slide supports [ADR-AUTO-DEPM][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 50 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 39 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 3 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][2], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][3], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][4], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][5], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][6], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][7], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][8], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][9], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][10], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][11], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][12], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][13], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][14], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][15], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][16], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][17], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][18], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][19], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][20], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][21], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][22], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][23], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][24], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][25], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][26], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/protected-globs.md][27], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][28], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][29], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][30], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][31], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][32], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][33], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][34], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][35], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][36], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][37], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][38], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][39], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### docs (5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/automation/a-declared-allow-list-of-layers.md][40], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 14 (text), line 38 (text), line 40 (text), line 41 (text) and line 42 (text).
- [docs/explanation/automation/three-layers-edges-point-down.md][41], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 15 (text), line 44 (text), line 46 (text) and line 48 (text).
- [docs/explanation/automation/two-gates-check-the-layer-pins.md][42], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 15 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51 (text) and line 55 (text).
- [docs/explanation/automation/two-sections-unioned-into-one-allow-set.md][43], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]:
  the file cites it at line 18 (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/automation/undeclared-edge-fails-with-one-line.md][44], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 15 (text), line 49 (text), line 50 (text) and line 51 (text).

### ModuleSystem (3 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][45], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][46], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][47], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 3 (header).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/drawio/STYLE.md][48], in the cell .claude × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 329 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][49], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 157 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][50], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 145 (text).

## Keywords

- [world map][51]
- [track][52]
- [file language][53]
- [cell][54]
- [lit cell][55]
- [.claude][56]: a track
- [automation][56]: a track
- [docs][56]: a track
- [csharp][57]: a file language
- [markdown][57]: a file language
- [yaml][57]: a file language

[1]: ../../adr/automation/controlling-module-dependencies.md
[2]: ../../adr/automation/BCL/index.md
[3]: ../../adr/automation/BCL/native-csharp-types.md
[4]: ../../adr/automation/avoid-deep-nesting.md
[5]: ../../adr/automation/bash/bash-test-artifacts.md
[6]: ../../adr/automation/caching.md
[7]: ../../adr/automation/console-output-matters.md
[8]: ../../adr/automation/controlling-systemwide-deps.md
[9]: ../../adr/automation/cross-platform.md
[10]: ../../adr/automation/devbox-pipeline-parity.md
[11]: ../../adr/automation/dora-explains.md
[12]: ../../adr/automation/dry-run.md
[13]: ../../adr/automation/effective-in-enterprises.md
[14]: ../../adr/automation/environment-variables.md
[15]: ../../adr/automation/execution-engines.md
[16]: ../../adr/automation/fail-fast-with-asserts.md
[17]: ../../adr/automation/go/index.md
[18]: ../../adr/automation/go/go-test-artifacts.md
[19]: ../../adr/automation/idempotent-state-functions.md
[20]: ../../adr/automation/internal-asset-dependencies.md
[21]: ../../adr/automation/log-before-invoke.md
[22]: ../../adr/automation/managed-guids.md
[23]: ../../adr/automation/never-depend-on-pwd.md
[24]: ../../adr/automation/open-closed-architecture.md
[25]: ../../adr/automation/path-representation.md
[26]: ../../adr/automation/platform-bundle.md
[27]: ../../adr/repository/protected-globs.md
[28]: ../../adr/automation/python/index.md
[29]: ../../adr/automation/python/python-test-artifacts.md
[30]: ../../adr/automation/retry-as-last-resort.md
[31]: ../../adr/automation/sensible-defaults.md
[32]: ../../adr/automation/single-responsibility-functions.md
[33]: ../../adr/automation/spell-out-names.md
[34]: ../../adr/automation/test-automation.md
[35]: ../../adr/automation/tool-removal-lifecycle.md
[36]: ../../adr/automation/tracked-files-from-the-index.md
[37]: ../../adr/automation/use-proper-package-managers.md
[38]: ../../adr/automation/uv-python-handler.md
[39]: ../../adr/automation/zero-ceremony-poka-yoke.md
[40]: ../../explanation/automation/a-declared-allow-list-of-layers.md
[41]: ../../explanation/automation/three-layers-edges-point-down.md
[42]: ../../explanation/automation/two-gates-check-the-layer-pins.md
[43]: ../../explanation/automation/two-sections-unioned-into-one-allow-set.md
[44]: ../../explanation/automation/undeclared-edge-fails-with-one-line.md
[45]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[46]: ../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[47]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[48]: ../../../.claude/drawio/STYLE.md
[49]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[50]: ../../adr/index.md
[51]: ../../adr/glossary.md#world-map
[52]: ../../adr/glossary.md#track
[53]: ../../adr/glossary.md#file-language
[54]: ../../adr/glossary.md#cell
[55]: ../../adr/glossary.md#lit-cell
[56]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[57]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

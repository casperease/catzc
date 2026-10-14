# docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md

`Tree minimap: adr-auto-depm--a-declared-allow-list-of-layers--meta`

![Tree minimap of adr-auto-depm--a-declared-allow-list-of-layers--meta](adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.png)

The tree minimap of the slide `adr-auto-depm--a-declared-allow-list-of-layers--meta` (meta lens). The slide supports [ADR-AUTO-DEPM][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 45 files in 4 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 40 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 3 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (40 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][2], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][3], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][4], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][5], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/index.md][6], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][7], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][8], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/consumer-overlay.md][9], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][1], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][10], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][11], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][12], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][14], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][15], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][16], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][17], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][18], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][19], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][20], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][21], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][22], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][23], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][24], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][25], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][26], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][27], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][28], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][29], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][30], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][31], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][32], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][33], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][34], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][35], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][36], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][37], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][38], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][39], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][40], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### ModuleSystem (3 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][41], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][42], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][43], in the cell automation × csharp: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 3 (header).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][44], in the cell automation × yaml: selected by [ADR-AUTO-DEPM][1]: the file cites it at
  line 157 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][45], in the cell docs × markdown: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 145 (text).

## Keywords

- [world map][46]
- [track][47]
- [file language][48]
- [cell][49]
- [lit cell][50]
- [automation][51]: a track
- [docs][51]: a track
- [csharp][52]: a file language
- [markdown][52]: a file language
- [yaml][52]: a file language

[1]: ../../adr/automation/controlling-module-dependencies.md
[2]: ../../adr/automation/BCL/index.md
[3]: ../../adr/automation/BCL/native-csharp-types.md
[4]: ../../adr/automation/avoid-deep-nesting.md
[5]: ../../adr/automation/bash/bash-test-artifacts.md
[6]: ../../adr/automation/bash/index.md
[7]: ../../adr/automation/caching.md
[8]: ../../adr/automation/console-output-matters.md
[9]: ../../adr/automation/consumer-overlay.md
[10]: ../../adr/automation/controlling-systemwide-deps.md
[11]: ../../adr/automation/cross-platform.md
[12]: ../../adr/automation/devbox-pipeline-parity.md
[13]: ../../adr/automation/dora-explains.md
[14]: ../../adr/automation/dry-run.md
[15]: ../../adr/automation/effective-in-enterprises.md
[16]: ../../adr/automation/environment-variables.md
[17]: ../../adr/automation/execution-engines.md
[18]: ../../adr/automation/fail-fast-with-asserts.md
[19]: ../../adr/automation/go/go-test-artifacts.md
[20]: ../../adr/automation/go/index.md
[21]: ../../adr/automation/idempotent-state-functions.md
[22]: ../../adr/automation/internal-asset-dependencies.md
[23]: ../../adr/automation/log-before-invoke.md
[24]: ../../adr/automation/managed-guids.md
[25]: ../../adr/automation/never-depend-on-pwd.md
[26]: ../../adr/automation/open-closed-architecture.md
[27]: ../../adr/automation/path-representation.md
[28]: ../../adr/automation/platform-bundle.md
[29]: ../../adr/automation/python/index.md
[30]: ../../adr/automation/python/python-test-artifacts.md
[31]: ../../adr/automation/retry-as-last-resort.md
[32]: ../../adr/automation/sensible-defaults.md
[33]: ../../adr/automation/single-responsibility-functions.md
[34]: ../../adr/automation/spell-out-names.md
[35]: ../../adr/automation/test-automation.md
[36]: ../../adr/automation/tool-removal-lifecycle.md
[37]: ../../adr/automation/tracked-files-from-the-index.md
[38]: ../../adr/automation/use-proper-package-managers.md
[39]: ../../adr/automation/uv-python-handler.md
[40]: ../../adr/automation/zero-ceremony-poka-yoke.md
[41]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[42]: ../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[43]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[44]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[45]: ../../adr/index.md
[46]: ../../adr/glossary.md#world-map
[47]: ../../adr/glossary.md#track
[48]: ../../adr/glossary.md#file-language
[49]: ../../adr/glossary.md#cell
[50]: ../../adr/glossary.md#lit-cell
[51]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[52]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

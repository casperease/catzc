# docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md

`Tree minimap: adr-auto-bundle--build-verify-then-copy-the-folder--implementation`

![Tree minimap of adr-auto-bundle--build-verify-then-copy-the-folder--implementation](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.png)

The tree minimap of the slide `adr-auto-bundle--build-verify-then-copy-the-folder--implementation` (implementation lens). The slide supports
[ADR-AUTO-BUNDLE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 65 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 39 lit files
- Exporter (automation/Catzc.Base.Exporter): 10 lit files
- docs (docs/ outside docs/adr/): 10 lit files
- Root files: 1 lit file
- .github: 1 lit file
- .internal (automation/.internal): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][2], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][3], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][4], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][5], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][6], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][7], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][8], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][9], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][10], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][11], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][12], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][13], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][14], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][15], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][16], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][17], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][18], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/go/go-test-artifacts.md][19], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][20], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][21], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][22], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][23], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][24], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][25], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][26], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/repository/protected-globs.md][27], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][28], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][29], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][30], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][31], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][32], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][33], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][34], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][35], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][36], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][37], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][38], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][39], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### Exporter (10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][40], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][41], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][42], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][43], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][44], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][45], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][46], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][47], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][48], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][49], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header).

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/automation/build-then-place-with-one-command.md][50], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][51], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][52], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][53], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][54], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text), line 44 (text) and line 46 (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][55], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][56], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text), line 45 (text), line 47 (text) and line 49 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][57], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][58], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][59], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 16 (text), line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text)
  and line 61 (text).

### Root files (1 lit file)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [importer.ps1][60], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][61], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### .internal (1 lit file)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][62], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header).

### Contracts (1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][63], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][64], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 162 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][65], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text).

## Keywords

- [world map][66]
- [track][67]
- [file language][68]
- [cell][69]
- [lit cell][70]
- [root file][71]
- [.github][72]: a track
- [automation][72]: a track
- [docs][72]: a track
- [csharp][73]: a file language
- [markdown][73]: a file language
- [powershell][73]: a file language
- [yaml][73]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/index.md
[3]: ../../adr/automation/BCL/native-csharp-types.md
[4]: ../../adr/automation/avoid-deep-nesting.md
[5]: ../../adr/automation/bash/bash-test-artifacts.md
[6]: ../../adr/automation/caching.md
[7]: ../../adr/automation/console-output-matters.md
[8]: ../../adr/automation/controlling-module-dependencies.md
[9]: ../../adr/automation/controlling-systemwide-deps.md
[10]: ../../adr/automation/cross-platform.md
[11]: ../../adr/automation/devbox-pipeline-parity.md
[12]: ../../adr/automation/dora-explains.md
[13]: ../../adr/automation/dry-run.md
[14]: ../../adr/automation/effective-in-enterprises.md
[15]: ../../adr/automation/environment-variables.md
[16]: ../../adr/automation/execution-engines.md
[17]: ../../adr/automation/fail-fast-with-asserts.md
[18]: ../../adr/automation/go/index.md
[19]: ../../adr/automation/go/go-test-artifacts.md
[20]: ../../adr/automation/idempotent-state-functions.md
[21]: ../../adr/automation/internal-asset-dependencies.md
[22]: ../../adr/automation/log-before-invoke.md
[23]: ../../adr/automation/managed-guids.md
[24]: ../../adr/automation/never-depend-on-pwd.md
[25]: ../../adr/automation/open-closed-architecture.md
[26]: ../../adr/automation/path-representation.md
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
[40]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[41]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[42]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[43]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[44]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[45]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[46]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[47]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[48]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[49]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[50]: ../../explanation/automation/build-then-place-with-one-command.md
[51]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[52]: ../../explanation/automation/dot-source-one-entry-script.md
[53]: ../../explanation/automation/every-code-root-is-a-copy.md
[54]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[55]: ../../explanation/automation/invoke-importer-in-code-order.md
[56]: ../../explanation/automation/one-commit-one-immutable-package.md
[57]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[58]: ../../explanation/automation/two-entries-feed-one-importer.md
[59]: ../../explanation/automation/what-gates-each-bundle-stage.md
[60]: ../../../importer.ps1
[61]: ../../../.github/workflows/ci-automation.yml
[62]: ../../../automation/.internal/assets/Import-Catzc.ps1
[63]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[64]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[65]: ../../adr/index.md
[66]: ../../adr/glossary.md#world-map
[67]: ../../adr/glossary.md#track
[68]: ../../adr/glossary.md#file-language
[69]: ../../adr/glossary.md#cell
[70]: ../../adr/glossary.md#lit-cell
[71]: ../../adr/glossary.md#root-file
[72]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[73]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

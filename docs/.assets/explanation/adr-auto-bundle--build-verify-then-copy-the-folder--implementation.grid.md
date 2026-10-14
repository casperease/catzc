# docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md

`Grid minimap: adr-auto-bundle--build-verify-then-copy-the-folder--implementation`

![Grid minimap of adr-auto-bundle--build-verify-then-copy-the-folder--implementation](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.png)

The grid minimap of the slide `adr-auto-bundle--build-verify-then-copy-the-folder--implementation` (implementation lens). The slide supports
[ADR-AUTO-BUNDLE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 2 lit of 219 files
- automation × powershell: 9 lit of 1412 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 50 lit of 742 files
- Root files × powershell: 1 lit of 1 file

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.github/workflows/ci-automation.yml][5]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48 (body comment) (a passing mention
  only).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][6]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][7]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 2 (header).

### automation × powershell (9 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/.internal/assets/Import-Catzc.ps1][8]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][9]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 12 (header).
- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][10]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][11]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header) and line 54
  (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][12]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][13]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][14]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][15]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 6
  (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][16]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 5
  (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 162 (text).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][18]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header).

### docs × markdown (50 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/automation/BCL/index.md][19]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/BCL/native-csharp-types.md][20]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][21]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][22]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/caching.md][23]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][24]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][25]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][26]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][27]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][28]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][29]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/dry-run.md][30]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][31]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/environment-variables.md][32]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][33]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][34]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][35]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/go/go-test-artifacts.md][36]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][37]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][38]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][39]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/managed-guids.md][40]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/never-depend-on-pwd.md][41]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][42]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/path-representation.md][43]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][1]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/repository/protected-globs.md][44]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/python/index.md][45]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][46]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][47]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][48]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][49]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][50]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/test-automation.md][51]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][52]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][53]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][54]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][55]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][56]: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/index.md][57]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text).
- [docs/explanation/automation/build-then-place-with-one-command.md][58]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][59]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17
  (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][60]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][61]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][62]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 14
  (text), line 44 (text) and line 46 (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][63]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 18 (text),
  line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][64]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 15
  (text), line 45 (text), line 47 (text) and line 49 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][65]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 17 (text),
  line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][66]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 18 (text),
  line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][67]: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 16 (text),
  line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text) and line 61 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][68]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [importer.ps1][69]: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header).

## Keywords

- [world map][70]
- [track][71]
- [file language][72]
- [cell][73]
- [lit cell][74]
- [root file][75]
- [.github][76]: a track
- [automation][76]: a track
- [docs][76]: a track
- [csharp][77]: a file language
- [markdown][77]: a file language
- [powershell][77]: a file language
- [yaml][77]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.github/workflows/ci-automation.yml
[6]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[7]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[8]: ../../../automation/.internal/assets/Import-Catzc.ps1
[9]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[10]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[11]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[12]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[13]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[14]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[15]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[16]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[17]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[19]: ../../adr/automation/BCL/index.md
[20]: ../../adr/automation/BCL/native-csharp-types.md
[21]: ../../adr/automation/avoid-deep-nesting.md
[22]: ../../adr/automation/bash/bash-test-artifacts.md
[23]: ../../adr/automation/caching.md
[24]: ../../adr/automation/console-output-matters.md
[25]: ../../adr/automation/controlling-module-dependencies.md
[26]: ../../adr/automation/controlling-systemwide-deps.md
[27]: ../../adr/automation/cross-platform.md
[28]: ../../adr/automation/devbox-pipeline-parity.md
[29]: ../../adr/automation/dora-explains.md
[30]: ../../adr/automation/dry-run.md
[31]: ../../adr/automation/effective-in-enterprises.md
[32]: ../../adr/automation/environment-variables.md
[33]: ../../adr/automation/execution-engines.md
[34]: ../../adr/automation/fail-fast-with-asserts.md
[35]: ../../adr/automation/go/index.md
[36]: ../../adr/automation/go/go-test-artifacts.md
[37]: ../../adr/automation/idempotent-state-functions.md
[38]: ../../adr/automation/internal-asset-dependencies.md
[39]: ../../adr/automation/log-before-invoke.md
[40]: ../../adr/automation/managed-guids.md
[41]: ../../adr/automation/never-depend-on-pwd.md
[42]: ../../adr/automation/open-closed-architecture.md
[43]: ../../adr/automation/path-representation.md
[44]: ../../adr/repository/protected-globs.md
[45]: ../../adr/automation/python/index.md
[46]: ../../adr/automation/python/python-test-artifacts.md
[47]: ../../adr/automation/retry-as-last-resort.md
[48]: ../../adr/automation/sensible-defaults.md
[49]: ../../adr/automation/single-responsibility-functions.md
[50]: ../../adr/automation/spell-out-names.md
[51]: ../../adr/automation/test-automation.md
[52]: ../../adr/automation/tool-removal-lifecycle.md
[53]: ../../adr/automation/tracked-files-from-the-index.md
[54]: ../../adr/automation/use-proper-package-managers.md
[55]: ../../adr/automation/uv-python-handler.md
[56]: ../../adr/automation/zero-ceremony-poka-yoke.md
[57]: ../../adr/index.md
[58]: ../../explanation/automation/build-then-place-with-one-command.md
[59]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[60]: ../../explanation/automation/dot-source-one-entry-script.md
[61]: ../../explanation/automation/every-code-root-is-a-copy.md
[62]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[63]: ../../explanation/automation/invoke-importer-in-code-order.md
[64]: ../../explanation/automation/one-commit-one-immutable-package.md
[65]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[66]: ../../explanation/automation/two-entries-feed-one-importer.md
[67]: ../../explanation/automation/what-gates-each-bundle-stage.md
[68]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[69]: ../../../importer.ps1
[70]: ../../adr/glossary.md#world-map
[71]: ../../adr/glossary.md#track
[72]: ../../adr/glossary.md#file-language
[73]: ../../adr/glossary.md#cell
[74]: ../../adr/glossary.md#lit-cell
[75]: ../../adr/glossary.md#root-file
[76]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[77]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

# docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md

`Grid minimap: adr-dsgn-runmode--one-entry-script-per-mode--operations`

![Grid minimap of adr-dsgn-runmode--one-entry-script-per-mode--operations](adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.png)

The grid minimap of the slide `adr-dsgn-runmode--one-entry-script-per-mode--operations` (operations lens). The slide supports
[ADR-DSGN-RUNMODE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 28 lit of 1412 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 20 lit of 742 files
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### automation × powershell (28 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/.internal/assets/Import-Catzc.ps1][5]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][6]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][7]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][8]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][9]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 29 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][10]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][11]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][12]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][13]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][14]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 28
  (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][15]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][16]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][17]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][18]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][19]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][20]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][21]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][22]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][23]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][24]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][25]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][26]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][27]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 30
  (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][28]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][29]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][30]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][31]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][32]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][33]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 101 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][34]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 596 (text).

### docs × markdown (20 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][35]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][36]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][37]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][1]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][38]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][39]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][40]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][41]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][42]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][43]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 94 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][44]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (text),
  line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][45]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 47
  (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][46]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 15
  (text), line 50 (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][47]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 41 (text),
  line 51 (text), line 66 (text), line 69 (text) and line 73 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][48]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text),
  line 42 (text), line 57 (text), line 63 (text) and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][49]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (text), line
  60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][50]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][51]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17
  (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][52]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 14
  (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][53]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (text),
  line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line 61 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][54]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [importer.ps1][55]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][54]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][56]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.gitattributes][57]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][58]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1`
  line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][59]
- [track][60]
- [file language][61]
- [cell][62]
- [lit cell][63]
- [root file][64]
- [unlisted file][65]
- [automation][66]: a track
- [docs][66]: a track
- [markdown][67]: a file language
- [powershell][67]: a file language
- [yaml][67]: a file language

[1]: ../../adr/design/run-modes.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/.internal/assets/Import-Catzc.ps1
[6]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[7]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[8]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[10]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[11]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[12]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[13]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[14]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[15]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[16]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[17]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[18]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[19]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[22]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[23]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[24]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[25]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[26]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[27]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[28]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[29]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[30]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[31]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[32]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[33]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[35]: ../../adr/design/commit-lifecycle.md
[36]: ../../adr/design/dora-explains.md
[37]: ../../adr/design/module-aspects.md
[38]: ../../adr/design/self-service.md
[39]: ../../adr/design/server-remote-integration.md
[40]: ../../adr/design/thin-platforms.md
[41]: ../../adr/design/tracks.md
[42]: ../../adr/design/visual-design.md
[43]: ../../adr/index.md
[44]: ../../explanation/automation/every-code-root-is-a-copy.md
[45]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[46]: ../../explanation/automation/one-commit-one-immutable-package.md
[47]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[48]: ../../explanation/automation/what-gates-each-bundle-stage.md
[49]: ../../explanation/design/one-entry-script-per-mode.md
[50]: ../../explanation/design/shims-set-roots-mode-read-back.md
[51]: ../../explanation/design/two-roots-one-importer-same-modules.md
[52]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[53]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[54]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[55]: ../../../importer.ps1
[56]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[57]: ../../../.gitattributes
[58]: ../../../.gitignore
[59]: ../../adr/glossary.md#world-map
[60]: ../../adr/glossary.md#track
[61]: ../../adr/glossary.md#file-language
[62]: ../../adr/glossary.md#cell
[63]: ../../adr/glossary.md#lit-cell
[64]: ../../adr/glossary.md#root-file
[65]: ../../adr/glossary.md#unlisted-file
[66]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[67]: ../../../automation/Catzc.Base.Languages/configs/languages.yml

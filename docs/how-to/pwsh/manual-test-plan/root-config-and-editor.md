# Manual test plan — Root config and editor

The managed root config files, the importer drift guard, `.gitignore`, and the VS Code registries. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                  |
| --- | ---- | ---------------------------------------------------------------------- |
| 1   | L2   | [Build-RootConfig — real rootconfig.yml][c1]                           |
| 2   | L1   | [Root PSScriptAnalyzerSettings.psd1 copy][c2]                          |
| 3   | L1   | [New-GitIgnore — real gitignore.yml][c3]                               |
| 4   | L1   | [New-VsCodeSettings — real vscode-settings.yml][c4]                    |
| 5   | L1   | [New-VsCodeExtensions — real vscode-extensions.yml][c5]                |
| 6   | L1   | [New-VsCodeLaunch — real vscode-launch.yml][c6]                        |
| 7   | L2   | [New-Importer — importer.ps1 drift guard][c7]                          |
| 8   | L2   | [Managed root config files agree with .gitignore and git tracking][c8] |
| 9   | L0   | [integrity (shipped config)][c9]                                       |
| 10  | L1   | [New-GoWorkspace — the shipped tools.yml pin][c10]                     |
| 11  | L1   | [New-VsCodeTasks — real vscode-tasks.yml][c11]                         |
| 12  | L1   | [New-VsCodeExtensionFolder — real vscode-extensions.yml][c12]          |
| 13  | L1   | [New-GitAttributes — shipped assets/root/.gitattributes-template][c13] |
| 14  | L1   | [New-Cspell — shipped assets/root/cspell-template.yml][c14]            |
| 15  | L1   | [New-VsCodeFileIconTheme — real file-icons.yml][c15]                   |
| 16  | L1   | [catzc-track-lamps — the real repository][c16]                         |
| 17  | L0   | [integrity (shipped config)][c17]                                      |
| 18  | L1   | [Get-GeneratedTarget — the real repository][c18]                       |
| 19  | L1   | [Build-WidthConfigs][c19]                                              |
| 20  | L1   | [New-JsConfig — the editor declarations match the manifests][c20]      |

[c1]: #1-build-rootconfig--real-rootconfigyml
[c2]: #2-root-psscriptanalyzersettingspsd1-copy
[c3]: #3-new-gitignore--real-gitignoreyml
[c4]: #4-new-vscodesettings--real-vscode-settingsyml
[c5]: #5-new-vscodeextensions--real-vscode-extensionsyml
[c6]: #6-new-vscodelaunch--real-vscode-launchyml
[c7]: #7-new-importer--importerps1-drift-guard
[c8]: #8-managed-root-config-files-agree-with-gitignore-and-git-tracking
[c9]: #9-integrity-shipped-config
[c10]: #10-new-goworkspace--the-shipped-toolsyml-pin
[c11]: #11-new-vscodetasks--real-vscode-tasksyml
[c12]: #12-new-vscodeextensionfolder--real-vscode-extensionsyml
[c13]: #13-new-gitattributes--shipped-assetsrootgitattributes-template
[c14]: #14-new-cspell--shipped-assetsrootcspell-templateyml
[c15]: #15-new-vscodefileicontheme--real-file-iconsyml
[c16]: #16-catzc-track-lamps--the-real-repository
[c17]: #17-integrity-shipped-config
[c18]: #18-get-generatedtarget--the-real-repository
[c19]: #19-build-widthconfigs
[c20]: #20-new-jsconfig--the-editor-declarations-match-the-manifests

## Checks

### 1. Build-RootConfig — real rootconfig.yml

**Test file:** `pwsh/Base.RootConfig/tests/Build-RootConfig.Tests.ps1` (L2), block `Build-RootConfig — real rootconfig.yml`.

**Guards:** Every opted-in managed root file composes from its source of truth, and `Test-GeneratedFiles -Generator Build-RootConfig`
reports 0 issues (every managed root file drift-free, importer.ps1 included).

### 2. Root PSScriptAnalyzerSettings.psd1 copy

**Test file:** `pwsh/Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1` (L1), block `Root PSScriptAnalyzerSettings.psd1 copy`.

**Guards:** `Test-RootAnalyzerSettings` reports 0 issues: the root analyzer settings parse as a literal settings hashtable under its
generated head, proving consumers can read the copy.

### 3. New-GitIgnore — real gitignore.yml

**Test file:** `pwsh/Base.Git/tests/New-GitIgnore.Tests.ps1` (L1), block `New-GitIgnore — real gitignore.yml`.

**Guards:** The shipped section registry renders with the root-config provider — every section resolves into the generated .gitignore.

### 4. New-VsCodeSettings — real vscode-settings.yml

**Test file:** `pwsh/Base.VSCode/tests/New-VsCodeSettings.Tests.ps1` (L1), block `New-VsCodeSettings — real vscode-settings.yml`.

**Guards:** The shipped settings registry renders to valid JSON with the analyzer wiring and the authored un-exclude intact.

### 5. New-VsCodeExtensions — real vscode-extensions.yml

**Test file:** `pwsh/Base.VSCode/tests/New-VsCodeExtensions.Tests.ps1` (L1), block `New-VsCodeExtensions — real vscode-extensions.yml`.

**Guards:** The shipped recommendation registry validates and renders to a non-empty list carrying the PowerShell extension.

### 6. New-VsCodeLaunch — real vscode-launch.yml

**Test file:** `pwsh/Base.VSCode/tests/New-VsCodeLaunch.Tests.ps1` (L1), block `New-VsCodeLaunch — real vscode-launch.yml`.

**Guards:** The shipped launch registry validates and renders with the importer debug profile's workspace placeholder intact.

### 7. New-Importer — importer.ps1 drift guard

**Test file:** `pwsh/Base.ModuleSystem/tests/New-Importer.Tests.ps1` (L2), block `New-Importer — importer.ps1 drift guard`.

**Guards:** The committed importer.ps1 equals New-Importer output (`Test-GeneratedFiles -Generator New-Importer` reports 0 issues) and its
parameter set matches the Invoke-Importer overlay (no drift).

### 8. Managed root config files agree with .gitignore and git tracking

**Test file:** `pwsh/Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1` (L2), block
`Managed root config files agree with .gitignore and git tracking`.

**Guards:** `Test-RootConfigFiles` reports 0 issues: per opted-in entry, `committed` and git agree (false ⇒ ignored + untracked; true ⇒
tracked + not ignored), every `source` target is its template under the generated head, and no managed target is a link.

### 9. integrity (shipped config)

**Test file:** `pwsh/Base.VSCode/tests/types/VscodeSettingsConfig.Tests.ps1` (L0), block `integrity (shipped config)`.

**Guards:** The shipped `vscode-settings.yml` loads through `VscodeSettingsConfig`, with its authored `search.exclude` map.

### 10. New-GoWorkspace — the shipped tools.yml pin

**Test file:** `pwsh/Base.Languages/tests/New-GoWorkspace.Tests.ps1` (L1), block `New-GoWorkspace — the shipped tools.yml pin`.

**Guards:** The rendered go.work and go.mod files carry the go directive from the shipped tools.yml go pin (global.tools.go.version), so the
Go version has one source.

### 11. New-VsCodeTasks — real vscode-tasks.yml

**Test file:** `pwsh/Base.VSCode/tests/New-VsCodeTasks.Tests.ps1` (L1), block `New-VsCodeTasks — real vscode-tasks.yml`.

**Guards:** The shipped vscode-tasks.yml registry renders with the fast-push task and its input resolved.

### 12. New-VsCodeExtensionFolder — real vscode-extensions.yml

**Test file:** `pwsh/Base.VSCode/tests/New-VsCodeExtensionFolder.Tests.ps1` (L1), block
`New-VsCodeExtensionFolder — real vscode-extensions.yml`.

**Guards:** Every own-extension entry renders from its shipped assets/extensions script to a package.json and extension.js that
Build-VsCodeExtension packs.

### 13. New-GitAttributes — shipped assets/root/.gitattributes-template

**Test file:** `pwsh/Base.RootConfig/tests/New-GitAttributes.Tests.ps1` (L1), block
`New-GitAttributes — shipped assets/root/.gitattributes-template`.

**Guards:** The shipped .gitattributes template renders through the shipped file-kinds registry with its placeholder filled and the catzc
attributes set.

### 14. New-Cspell — shipped assets/root/cspell-template.yml

**Test file:** `pwsh/Base.RootConfig/tests/New-Cspell.Tests.ps1` (L1), block `New-Cspell — shipped assets/root/cspell-template.yml`.

**Guards:** The shipped cspell template renders through the shipped third-party glob set with its placeholder filled by the set's ignore
paths.

### 15. New-VsCodeFileIconTheme — real file-icons.yml

**Test file:** `pwsh/Base.VSCode/tests/New-VsCodeFileIconTheme.Tests.ps1` (L1), block `New-VsCodeFileIconTheme — real file-icons.yml`.

**Guards:** The shipped icon registry gives every file type tracked in the repository an icon.

### 16. catzc-track-lamps — the real repository

**Test file:** `pwsh/Base.VSCode/tests/catzc-track-lamps.Tests.ps1` (L1), block `catzc-track-lamps — the real repository`.

**Guards:** The track-lamps extension lights the real tree's files by the shipped filters and tracks.

### 17. integrity (shipped config)

**Test file:** `pwsh/Base.VSCode/tests/types/LampPaletteConfig.Tests.ps1` (L0), block `integrity (shipped config)`.

**Guards:** The shipped `lamp-palette.yml` loads and validates through `LampPaletteConfig`.

### 18. Get-GeneratedTarget — the real repository

**Test file:** `pwsh/Base.Variants/tests/Get-GeneratedTarget.Tests.ps1` (L1), block `Get-GeneratedTarget — the real repository`.

**Guards:** Every opted-in root config and every README `readme.yml` names comes back by its generator.

### 19. Build-WidthConfigs

**Test file:** `pwsh/Base.FileLimits/tests/Build-WidthConfigs.Tests.ps1` (L1), block `Build-WidthConfigs`.

**Guards:** the editor, prettier and markdownlint widths are rendered from file-limits.yml at the widths the formatters used before it.

**Checks:**

- `.editorconfig` renders `.ps1` at 120 and `.md` and `.py` at 140, with no width token left.
- Prettier `printWidth` and every markdownlint MD013 length render at 140.
- A target it does not render is rejected.

### 20. New-JsConfig — the editor declarations match the manifests

**Test file:** `pwsh/Base.Languages/tests/New-JsConfig.Tests.ps1` (L1), block `New-JsConfig — the editor declarations match the manifests`.

**Guards:** the JavaScript workspace pins the editor API to the version every extension manifest declares.

**Checks:**

- `@types/vscode` is pinned to the editor version every extension manifest declares.

### 21. Build-WidthConfigs — shipped assets/root templates

**Test file:** `pwsh/Base.FileLimits/tests/Build-WidthConfigs.Tests.ps1` (L1), block `Build-WidthConfigs — shipped assets/root templates`.

**Guards:** `Build-WidthConfigs` renders every target from the template the loaded RootConfig module ships, with each width token filled
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

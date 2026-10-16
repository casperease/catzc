---
catzc:
  derived:
    path: docs/how-to/automation/manual-test-plan/root-config-and-editor.md
    folder: docs/how-to/automation/manual-test-plan
    name: root-config-and-editor
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    body_sha: "134788ad7604"
    links:
      - docs/how-to/automation/manual-test-plan.md
---

# Manual test plan — Root config and editor

The managed root config files, the importer drift guard, `.gitignore`, and the VS Code registries. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                     | FullNameFilter                                                   | Guards                                                                                                                                                                                                                                                 |
| --- | ---- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L1   | automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1             | Build-RootConfig — real rootconfig.yml                           | Every opted-in managed root file composes from its source of truth, and `Test-GeneratedFiles -Generator Build-RootConfig` reports 0 issues (every managed root file drift-free, importer.ps1 included).                                                |
| 2   | L1   | automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1     | Root PSScriptAnalyzerSettings.psd1 link                          | `Test-RootAnalyzerSettings` reports 0 issues: the root analyzer settings parse as a literal settings hashtable through the copyAsLink link, proving consumers can follow it.                                                                           |
| 3   | L1   | automation/Catzc.Base.Git/tests/New-GitIgnore.Tests.ps1                       | New-GitIgnore — real gitignore.yml                               | The shipped section registry renders with the root-config provider — every section resolves into the generated .gitignore.                                                                                                                             |
| 4   | L1   | automation/Catzc.Base.VSCode/tests/New-VSCodeSettings.Tests.ps1               | New-VSCodeSettings — real vscode-settings.yml                    | The shipped settings registry renders to valid JSON with the analyzer wiring and the authored un-exclude intact.                                                                                                                                       |
| 5   | L1   | automation/Catzc.Base.VSCode/tests/New-VSCodeExtensions.Tests.ps1             | New-VSCodeExtensions — real vscode-extensions.yml                | The shipped recommendation registry validates and renders to a non-empty list carrying the PowerShell extension.                                                                                                                                       |
| 6   | L1   | automation/Catzc.Base.VSCode/tests/New-VSCodeLaunch.Tests.ps1                 | New-VSCodeLaunch — real vscode-launch.yml                        | The shipped launch registry validates and renders with the importer debug profile's workspace placeholder intact.                                                                                                                                      |
| 7   | L1   | automation/Catzc.Base.VSCode/tests/New-VSCodePipelineSchema.Tests.ps1         | New-VSCodePipelineSchema — real vscode-pipeline-schema.yml       | The shipped Azure Pipelines schema renders to parseable JSON that relaxes the task step (killing the offline ^PowerShell@2$ false positives) while keeping structural teeth.                                                                           |
| 8   | L2   | automation/Catzc.Base.ModuleSystem/tests/New-Importer.Tests.ps1               | New-Importer — importer.ps1 drift guard                          | The committed importer.ps1 equals New-Importer output (`Test-GeneratedFiles -Generator New-Importer` reports 0 issues) and its parameter set matches the Invoke-Importer overlay (no drift).                                                           |
| 9   | L2   | automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1     | Managed root config files agree with .gitignore and git tracking | `Test-RootConfigFiles` reports 0 issues: per opted-in entry, `committed` and git agree (false ⇒ ignored + untracked; true ⇒ tracked + not ignored), every copyAsLink target is an effective link to its source, and no other managed target is a link. |
| 10  | L0   | automation/Catzc.Base.VSCode/tests/types/VscodeSettingsConfig.Tests.ps1       | integrity (shipped config)                                       | The shipped `vscode-settings.yml` loads through `VscodeSettingsConfig`, with its authored `search.exclude` map.                                                                                                                                        |
| 11  | L0   | automation/Catzc.Base.VSCode/tests/types/VscodePipelineSchemaConfig.Tests.ps1 | integrity (shipped config)                                       | The shipped `vscode-pipeline-schema.yml` loads through `VscodePipelineSchemaConfig`, with its `step` definition.                                                                                                                                       |
| 12  | L1   | automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1               | New-GoWorkspace — the shipped tools.yml pin                      | The rendered go.work and go.mod files carry the go directive from the shipped tools.yml go pin (global.tools.go.version), so the Go version has one source.                                                                                            |

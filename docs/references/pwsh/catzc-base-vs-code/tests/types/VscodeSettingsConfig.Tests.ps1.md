# pwsh/Base.VSCode/tests/types/VscodeSettingsConfig.Tests.ps1

The L0 tests of `Catzc.Base.VSCode.VscodeSettingsConfig`, the type of `vscode-settings.yml`: constructing it maps and validates the parsed
YAML, so a malformed settings registry never loads through `Get-Config -Config vscode-settings`.

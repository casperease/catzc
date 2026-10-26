# pwsh/Tooling.Core/tests/Get-ToolCommandSuffix.Tests.ps1

The L0 tests of `Get-ToolCommandSuffix`.

## Mapping

Each snake_case `tools.yml` key must map to the PascalCase suffix of its Install, Uninstall and Invoke commands. That those commands exist
for each tool is covered in `Get-ToolConfig.Tests.ps1`.

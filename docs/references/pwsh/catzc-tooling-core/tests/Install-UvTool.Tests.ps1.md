# pwsh/Tooling.Core/tests/Install-UvTool.Tests.ps1

The L0 tests of `Install-UvTool`.

## Config mocks

`Get-ToolConfig` returns the typed record, so the mocks do too: an optional key the entry omits reads as its default, exactly as in
production.

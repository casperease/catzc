# pwsh/Tooling.Core/tests/Test-ToolRequiresElevation.Tests.ps1

The L0 tests of `Test-ToolRequiresElevation`.

## Typed record

The production input is the typed record `Get-ToolConfig` returns, so the tests build one: a flag the record does not map would be absent
here exactly as in production.

# pwsh/Tooling.Provisioning/tests/Assert-DevBoxToolsStatus.Tests.ps1

The tests of `Assert-DevBoxToolsStatus`. `Get-ToolsStatus` is the only boundary: it is mocked to return fabricated `ToolStatus` rows, and
the tests assert the pass or throw decision. The rows use deliberately non-production tool names.

# pwsh/Tooling.Provisioning/tests/Install-DevBoxTools.Tests.ps1

The tests of `Install-DevBoxTools`, pure orchestration over mocked seams. With an empty install order the version-locked loop is a no-op, so
the tests focus on the fixed sequence (removing Chocolatey, the status, the additional installers) and on the two decision points that are
pure logic: the report of a usable but unmanaged tool, and the guard against a missing installer.

`Get-ToolConfig` returns the typed record, so the mocks do too: every flag an entry omits reads as its default, exactly as in production.

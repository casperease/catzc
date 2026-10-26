# pwsh/Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1

The L0 tests of `Test-ExpectedPackageManager`.

## MSYS2 fixtures

Both fixtures are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The first is an entry
whose mechanism is an MSYS2 package, installed on Windows into the tree `Get-ScriptInstallDir` names. The second declares the MSYS2 package
for Windows, the apt package for Linux and nothing for macOS, so each platform takes one manager.

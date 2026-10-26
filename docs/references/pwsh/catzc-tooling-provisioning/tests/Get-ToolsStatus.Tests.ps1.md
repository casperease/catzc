# pwsh/Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1

The tests of `Get-ToolsStatus`.

## The probed branch

A tool with candidate paths takes its location and version from the probe record (`Test-Tool -PassThru`) and never starts a version job on
its bare name. The probe, the package-manager oracle, the scope and winget are mocked. Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The two-mechanism tool

The fixture entry carries an MSYS2 package for Windows and an apt package for Linux, and nothing for macOS, so each platform takes exactly one
manager: msys2 on Windows, apt on Linux, the system on macOS.

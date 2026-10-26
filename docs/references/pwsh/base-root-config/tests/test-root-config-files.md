# pwsh/Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1

The tests of `Test-RootConfigFiles` over fixture root files in `$TestDrive`: the registry entries, git's ignore check and the index are
mocked, so each test pins one agreement rule.

## The link stand-in

A hard link stands in for a materialised link, which needs no privilege. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
